#include "prc_feat_const"
#include "prc_ipfeat_const"
#include "prc_class_const"
#include "inc_item_props"

const int MONST_DAMAGE_1D3   = 2;  //0
const int MONST_DAMAGE_1D4   = 3;  //1
const int MONST_DAMAGE_1D6   = 8;  //2
const int MONST_DAMAGE_1D8   = 18; //3
const int MONST_DAMAGE_1D10  = 28; //4
const int MONST_DAMAGE_2D6   = 9;  //5
const int MONST_DAMAGE_2D8   = 19; //6
const int MONST_DAMAGE_2D10  = 29; //7
const int MONST_DAMAGE_3D8   = 20; //8
const int MONST_DAMAGE_3D10  = 30; //9
const int MONST_DAMAGE_3D12  = 40; //10
const int MONST_DAMAGE_4D10  = 31; //11
const int MONST_DAMAGE_3D6   = 10; //7: Large/Huge Monk only
const int MONST_DAMAGE_4D8   = 21; //9: Large/Huge Monk only

const int ITEM_PROPERTY_WOUNDING = 69;

// Clean up any extras in the inventory.
void CleanExtraFists(object oCreature)
{
    object oClean = GetFirstItemInInventory(oCreature);
    while (GetIsObjectValid(oClean))
    {
        if (GetTag(oClean) == "NW_IT_CREWPB010" && oClean != GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature))
            DestroyObject(oClean);
        oClean = GetNextItemInInventory(oCreature);
    }
}

// Adds appropriate feats to the skin. Stolen from SoulTaker + expanded with overwhelming/devastating critical.
void UnarmedFeats(object oCreature)
{
    object oSkin = GetPCSkin(oCreature);

    if (GetHasFeat(FEAT_WEAPON_FOCUS_UNARMED_STRIKE, oCreature) && !GetHasFeat(FEAT_WEAPON_FOCUS_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapFocCreature),oSkin);

    if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE, oCreature) && !GetHasFeat(FEAT_WEAPON_SPECIALIZATION_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapSpecCreature),oSkin);

    if (GetHasFeat(FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE, oCreature) && !GetHasFeat(FEAT_IMPROVED_CRITICAL_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_ImpCritCreature),oSkin);

    if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_UNARMED, oCreature) && !GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapEpicFocCreature),oSkin);

    if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED, oCreature) && !GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapEpicSpecCreature),oSkin);

    if (GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_UNARMED, oCreature) && !GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_OVERCRITICAL_CREATURE),oSkin);

    if (GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED, oCreature) && !GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_DEVCRITICAL_CREATURE),oSkin);
}

// Determines the amount of damage a character can do.
int FindUnarmedDamage(object oCreature)
{
    int iDamage = 0;
    int iMonk = GetLevelByClass(CLASS_TYPE_MONK, oCreature);
    int iShou = GetLevelByClass(CLASS_TYPE_SHOU, oCreature);
    int iIoDM = GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC, oCreature);
    int iBrawler = GetLevelByClass(CLASS_TYPE_BRAWLER, oCreature);
    int iSacredFist = GetLevelByClass(CLASS_TYPE_SACREDFIST, oCreature);
    
    if (GetHasFeat(FEAT_SF_CODE,oCreature)) iSacredFist = 0;
   
    // IoDM: +1 dice at level 4, +2 dice at level 8
    // Shou: 1d6 at level 1, 1d8 at level 2, 1d10 at level 3, 2d6 at level 5
    // Monk: 1d6 at level 1, 1d8 at level 4, 1d10 at level 8, 2d6 at level 12, 2d10 at level 16
    int iMonkDamage;
    int iShouDamage;
    int iBrawlerDamage;
    
    int iSize = GetCreatureSize(oCreature);
    
    int iDamageToUse = 0;
    
    // Decided to allow Shou disciple levels to stack on top of brawler.
    if (iBrawler) iBrawler = iBrawler + iShou;

    // Brawler has a very simple damage progression (regardless of size):    
    iBrawlerDamage = iBrawler / 6 + 2;   //1d6, 1d8, 1d10, 2d6, 2d8, 2d10, 3d8
   
    // Future unarmed classes: if you do your own damage, add in "levelups" below here.
    iMonk = iMonk + iShou + iSacredFist;
    
    // 3.5 Dmg Table
    iMonkDamage =  iMonk / 4 + 2;
    
    // Monks have a damage cap.
    if (iMonkDamage > 7) iMonkDamage = 7;
   
     // Small monks get damage penalty
    if (iSize == CREATURE_SIZE_SMALL || iSize == CREATURE_SIZE_TINY)
       iMonkDamage--; //1d4, 1d6, 1d8, 1d10, 2d6, 2d8
    
    // Bigger Monks get even more damage
    int iUseBigMonk = FALSE;
    if (iSize == CREATURE_SIZE_LARGE || iSize == CREATURE_SIZE_HUGE)
    {
       // 1d8, 2d6, 2d8, 3d6, 3d8, 4d8
       iMonkDamage = (iMonk >= 4) ? 5 : 3;
       iMonkDamage = (iMonk >= 8) ? 6 : iMonkDamage;
       iMonkDamage = (iMonk >= 12) ? 7 : iMonkDamage; // different from other progressions
       iMonkDamage = (iMonk >= 16) ? 8 : iMonkDamage;
       iMonkDamage = (iMonk >= 20) ? 9 : iMonkDamage; // different from other progressions
       iUseBigMonk = TRUE;
    }
    
    if (iShou == 1) iShouDamage = 2;                //1d6
    if (iShou == 2) iShouDamage = 3;                //1d8
    if (iShou == 3 || iShou == 4) iShouDamage = 4;  //1d10
    if (iShou == 5) iShouDamage = 5;                //2d6
    
    // Future unarmed classes:  if you do your own damage, add in "comparisons" below here.
    iDamageToUse = (iMonkDamage > iDamageToUse) ? iMonkDamage : 0;
    iDamageToUse = (iBrawlerDamage > iDamageToUse) ? iBrawlerDamage : iDamageToUse;
    iDamageToUse = (iShouDamage > iDamageToUse) ? iShouDamage : iDamageToUse;
    
    // Future unarmed classes:  if you enhance other classes' damage, add in bonuses here.
    if (iIoDM >= 4) iDamageToUse++;
    if (iIoDM >= 8) iDamageToUse++;
    
    // This is where the correct damage dice is calculated
    if (iDamageToUse > 11) iDamageToUse = 11;
    
    switch (iDamageToUse)
    {
        case 0:
            iDamage = MONST_DAMAGE_1D3;
            break;
        case 1:
            iDamage = MONST_DAMAGE_1D4;
            break;
        case 2:
            iDamage = MONST_DAMAGE_1D6;
            break;
        case 3:
	    iDamage = MONST_DAMAGE_1D8;
	    break;
        case 4:
	    iDamage = MONST_DAMAGE_1D10;
	    break;
        case 5:
            iDamage = MONST_DAMAGE_2D6;
	    break;
        case 6:
            iDamage = MONST_DAMAGE_2D8;
            break;
        case 7:
            iDamage = (iUseBigMonk) ? MONST_DAMAGE_3D6 : MONST_DAMAGE_2D10;
	    break;
        case 8:
            iDamage = MONST_DAMAGE_3D8;
            break;
        case 9: // biggest achievable by Monk/IoDM and Brawler/IoDM
            iDamage = (iUseBigMonk) ? MONST_DAMAGE_4D8 : MONST_DAMAGE_3D10;
            break;
        case 10: // only achievable by Large/Huge Monk 20+/IoDM 4+
            iDamage = MONST_DAMAGE_3D12;
            break;
        case 11: // biggest achievable by Large/Huge Monk 20+/IoDM 8+
            iDamage = MONST_DAMAGE_4D10;
            break;
        default:
            break;
    }

    return iDamage;
}

// Creates/strips a creature weapon and applies bonuses.  Large chunks stolen from SoulTaker.
void UnarmedFists(object oCreature)
{
       object oRighthand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
       object oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
       object oWeapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature);
       
    int iMonk = GetLevelByClass(CLASS_TYPE_MONK, oCreature);
    int iShou = GetLevelByClass(CLASS_TYPE_SHOU, oCreature);
    int iIoDM = GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC, oCreature);
    int iBrawler = GetLevelByClass(CLASS_TYPE_BRAWLER, oCreature);

    if (!GetIsObjectValid(oWeapL))
    {
        if (GetHasItem(oCreature, "NW_IT_CREWPB010"))
        {
            oWeapL = GetItemPossessedBy(oCreature,"NW_IT_CREWPB010");
            SetIdentified(oWeapL, TRUE);
            AssignCommand(oCreature,ActionEquipItem(oWeapL,INVENTORY_SLOT_CWEAPON_L));
        }
        else
        {
            oWeapL = CreateItemOnObject("NW_IT_CREWPB010", oCreature);
            SetIdentified(oWeapL, TRUE);
            AssignCommand(oCreature,ActionEquipItem(oWeapL,INVENTORY_SLOT_CWEAPON_L));
        }
    }
    
    // Clean up the mess of extra fists made on taking first level.
    DelayCommand(1.0,CleanExtraFists(oCreature));

    if (GetTag(oWeapL) != "NW_IT_CREWPB010") return;
    
    int iKi = GetHasFeat(FEAT_KI_STRIKE,oCreature) ? 1 : 0 ;
        iKi = (iMonk>12)                     ? 2 : iKi;
        iKi = (iMonk>15)                     ? 3 : iKi;
    
    int bDragClaw =  GetHasFeat(FEAT_CLAWDRAGON,oCreature) ? 1: 0;
        bDragClaw =  GetHasFeat(FEAT_CLAWENH2,oCreature)   ? 2: bDragClaw;
        bDragClaw =  GetHasFeat(FEAT_CLAWENH3,oCreature)   ? 3: bDragClaw;    
              
    int iBrawlEnh = iBrawler / 6;
         
    int iEpicKi = GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_4,oCreature) ? 1 : 0 ;
        iEpicKi = GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_5,oCreature) ? 2 : iEpicKi ;
    
    int Enh;
          
    iKi+= iEpicKi;
    if (iKi > iBrawlEnh) Enh+= iKi;
    else Enh+= iBrawlEnh;
          
    Enh += bDragClaw;
          
    object oItem=GetItemInSlot(INVENTORY_SLOT_ARMS,oCreature);
        
    //Strip the Fist.
    itemproperty ip = GetFirstItemProperty(oWeapL);
    while (GetIsItemPropertyValid(ip))
    {
        RemoveItemProperty(oWeapL, ip);
        ip = GetNextItemProperty(oWeapL);
    }
    
    // Leave the fist blank if weapons/shields are equipped.
    if (GetIsObjectValid(oRighthand) || GetIsObjectValid(oLefthand)) return;

    // -----------------------------------------
    // ALL CREATURE WEAPON BONUSES GO BELOW HERE
    // -----------------------------------------
    // Add glove bonuses.
    if (GetIsObjectValid(oItem))
    {
        int iType = GetBaseItemType(oItem);
        if (iType == BASE_ITEM_GLOVES)
        {
            ip = GetFirstItemProperty(oItem);
            while(GetIsItemPropertyValid(ip))
            {
                iType = GetItemPropertyType(ip);
                switch (iType)
                {
                    case ITEM_PROPERTY_DAMAGE_BONUS:
                    case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
                    case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
                    case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
                    case ITEM_PROPERTY_ON_HIT_PROPERTIES:
                    case ITEM_PROPERTY_ONHITCASTSPELL:
                    case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:
                    case ITEM_PROPERTY_KEEN:
                    case ITEM_PROPERTY_MASSIVE_CRITICALS:
                    case ITEM_PROPERTY_POISON:
                    case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
                    case ITEM_PROPERTY_WOUNDING:
                    case ITEM_PROPERTY_DECREASED_DAMAGE:
                    case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:
                        AddItemProperty(DURATION_TYPE_PERMANENT,ip,oWeapL);
                        break;
                    case ITEM_PROPERTY_ATTACK_BONUS:
                        int iCost = GetItemPropertyCostTableValue(ip);
                        Enh = (iCost>Enh) ? iCost:Enh;
                        break;
                }
                ip = GetNextItemProperty(oItem);
            }
            // handles these seperately so as not to create "attack penalties vs. xxxx"
            while(GetIsItemPropertyValid(ip))
	    {
	        iType = GetItemPropertyType(ip);
	        switch (iType)
	        {
                    case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
	            case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
	            case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
	            if (GetItemPropertyCostTableValue(ip) > Enh)
	                AddItemProperty(DURATION_TYPE_PERMANENT,ip,oWeapL);
                    break;
                }
		ip = GetNextItemProperty(oItem);
	    }
        }
    }
    
    // Brawler blocking.
    int iBlocking = 0;
        
    if (GetHasFeat(FEAT_BRAWLER_BLOCK_1, oCreature))
        iBlocking = 1;
    if (GetHasFeat(FEAT_BRAWLER_BLOCK_2, oCreature))
        iBlocking = 2;
    if (GetHasFeat(FEAT_BRAWLER_BLOCK_3, oCreature))
        iBlocking = 3;
    if (GetHasFeat(FEAT_BRAWLER_BLOCK_4, oCreature))
        iBlocking = 4;
    if (GetHasFeat(FEAT_BRAWLER_BLOCK_5, oCreature))
        iBlocking = 5;
    
    if (iBlocking) AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyACBonus(iBlocking),oWeapL);

    // ALL ADDITIONAL CLASS BONUSES ADDED BELOW HERE.
    int iMonsterDamage = FindUnarmedDamage(oCreature);  // Find the monster damage type to add.

    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyMonsterDamage(iMonsterDamage),oWeapL);

    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAttackBonus(Enh),oWeapL);

    if (iIoDM >= 2)
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyExtraMeleeDamageType(IP_CONST_DAMAGETYPE_SLASHING),oWeapL);
}
