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
const int MONST_DAMAGE_3D6   = 10; //7L: Large/Huge Monk only
const int MONST_DAMAGE_4D8   = 21; //9L: Large/Huge Monk only

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

// Determines the amount of damage a character can do.
// IoDM: +1 dice at level 4, +2 dice at level 8
// Sacred Fist: Levels add to monk levels, or stand alone as monk levels.
// Shou: 1d6 at level 1, 1d8 at level 2, 1d10 at level 3, 2d6 at level 5
// Monk: 1d6 at level 1, 1d8 at level 4, 1d10 at level 8, 2d6 at level 12, 2d8 at level 16, 2d10 at level 20
// Brawler: 1d6 at level 1, 1d8 at level 6, 1d10 at level 12, 2d6 at level 18, 2d8 at level 24, 2d10 at level 30, 3d8 at level 36
int FindUnarmedDamage(object oCreature)
{
    int iDamage = 0;
    int iMonk = GetLevelByClass(CLASS_TYPE_MONK, oCreature);
    int iShou = GetLevelByClass(CLASS_TYPE_SHOU, oCreature);
    int iIoDM = GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC, oCreature);
    int iBrawler = GetLevelByClass(CLASS_TYPE_BRAWLER, oCreature);
    int iSacredFist = GetLevelByClass(CLASS_TYPE_SACREDFIST, oCreature);
    int iMonkDamage = 0;
    int iShouDamage = 0;
    int iBrawlerDamage = 0;
    int iDamageToUse = 0;
    int iSize = GetCreatureSize(oCreature);

    // Sacred Fist cannot add their levels if they've broken their code.    
    if (GetHasFeat(FEAT_SF_CODE,oCreature)) iSacredFist = 0;
    
    // Sacred Fist adds their levels to the monk class otherwise.
    // Note: If a Sacred Fist has 0 levels of monk, it is considered to be a monk
    // of equal level when considering damage (and unarmed attack schedule, which
    // is not implemented.)
    if (iSacredFist) iMonk += iSacredFist;

    // Add Shou Disciple levels to all unarmed base classes
    if (iShou)
    {
        if (iBrawler) iBrawler += iShou;
        if (iMonk)    iMonk += iShou;
    }

    // Brawler has a very simple damage progression (regardless of size):    
    if (iBrawler) iBrawlerDamage = iBrawler / 6 + 2;   // 1d6, 1d8, 1d10, 2d6, 2d8, 2d10, 3d8
  
    // Monk 3.5 Dmg Table
    if (iMonk) iMonkDamage =  iMonk / 4 + 2; //1d6, 1d8, 1d10, 2d6, 2d8, 2d10
    if (iMonkDamage > 7) iMonkDamage = 7;
   
     // Small monks get damage penalty
    if (iSize == CREATURE_SIZE_SMALL || iSize == CREATURE_SIZE_TINY)
        iMonkDamage--; //1d4, 1d6, 1d8, 1d10, 2d6, 2d8
    
    // Bigger Monks get even more damage (that varies from the normal tables too, grr.)
    int iUseBigMonk = FALSE;
    if (iMonk && (iSize == CREATURE_SIZE_LARGE || iSize == CREATURE_SIZE_HUGE))
    {
        if (iMonk < 4) iMonk = 1;
        iMonkDamage += 2; //1d8, 2d6, 2d8, 3d6, 3d8, 4d8
        iUseBigMonk = TRUE;
    }
    
    // Shou Disciple either adds its level to existing class or does its own damage, depending
    // on which is better. Here we will determine how much damage the Shou Disciple does
    // without stacking.
    if (iShou > 0) iShouDamage = iShou + 1; // Lv. 1: 1d6, Lv. 2: 1d8, Lv. 3: 1d10
    if (iShou > 3) iShouDamage--;           // Lv. 4: 1d10, Lv. 5: 2d6
   
    // Future unarmed classes:  if you do your own damage, add in "comparisons" below here.
    iDamageToUse = (iMonkDamage > iDamageToUse) ? iMonkDamage : 0;
    iDamageToUse = (iBrawlerDamage > iDamageToUse) ? iBrawlerDamage : iDamageToUse;
    iDamageToUse = (iShouDamage > iDamageToUse) ? iShouDamage : iDamageToUse;

    // Future unarmed classes:  if you enhance other classes' damage, add in bonuses here.
    if (GetHasFeat(FEAT_EPIC_INCREASE_DAMAGE5, oCreature)) iDamageToUse += 7;
    else if (GetHasFeat(FEAT_EPIC_INCREASE_DAMAGE4, oCreature)) iDamageToUse += 6;
    else if (GetHasFeat(FEAT_EPIC_INCREASE_DAMAGE3, oCreature)) iDamageToUse += 5;
    else if (GetHasFeat(FEAT_EPIC_INCREASE_DAMAGE2, oCreature)) iDamageToUse += 4;
    else if (GetHasFeat(FEAT_EPIC_INCREASE_DAMAGE1, oCreature)) iDamageToUse += 3;
    else if (GetHasFeat(FEAT_INCREASE_DAMAGE2, oCreature)) iDamageToUse += 2;
    else if (GetHasFeat(FEAT_INCREASE_DAMAGE1, oCreature)) iDamageToUse += 1;
    
    // This is where the correct damage dice is calculated
    if (iDamageToUse > 11) iDamageToUse = 11;
    
    switch (iDamageToUse)
    {
        case 0:
            iDamage = MONST_DAMAGE_1D3;
            break;
        case 1: // Start: Small Monk
            iDamage = MONST_DAMAGE_1D4;
            break;
        case 2: // Start: Medium Monk
            iDamage = MONST_DAMAGE_1D6;
            break;
        case 3: // Start: Large Monk
	    iDamage = MONST_DAMAGE_1D8;
	    break;
        case 4:
	    iDamage = MONST_DAMAGE_1D10;
	    break;
        case 5: // Best Shou Disciple
            iDamage = MONST_DAMAGE_2D6;
	    break;
        case 6: // Best Small Monk
            iDamage = MONST_DAMAGE_2D8;
            break;
        case 7: // Best Medium Monk (2d10)
            iDamage = (iUseBigMonk) ? MONST_DAMAGE_3D6 : MONST_DAMAGE_2D10;
	    break;
        case 8: // Best Brawler
            iDamage = MONST_DAMAGE_3D8;
            break;
        case 9: // Best Large/Huge Monk (4d8)
            iDamage = (iUseBigMonk) ? MONST_DAMAGE_4D8 : MONST_DAMAGE_3D10;
            break;
        case 10: // Best Brawler/IoDM (?) ... Best Small Monk/IoDM
            iDamage = MONST_DAMAGE_3D12;
            break;
        case 11: // Best any build can hit.  (Medium/Large/Huge Monk/IoDM builds).
            iDamage = MONST_DAMAGE_4D10;
            break;
        default:
            break;
    }

    return iDamage;
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
        iKi = (iMonk > 12)                         ? 2 : iKi;
        iKi = (iMonk > 15)                         ? 3 : iKi;
    
    int bDragClaw = GetHasFeat(FEAT_CLAWDRAGON,oCreature) ? 1: 0;
        bDragClaw = GetHasFeat(FEAT_CLAWENH2,oCreature)   ? 2: bDragClaw;
        bDragClaw = GetHasFeat(FEAT_CLAWENH3,oCreature)   ? 3: bDragClaw;    
              
    int iBrawlEnh = iBrawler / 6;
         
    int iEpicKi = GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_4,oCreature) ? 1 : 0 ;
        iEpicKi = GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_5,oCreature) ? 2 : iEpicKi ;
    
    int Enh;
          
    iKi += iEpicKi;

    Enh = (iKi > iBrawlEnh) ? iKi : iBrawlEnh;
          
    Enh += bDragClaw;
          
    object oItem=GetItemInSlot(INVENTORY_SLOT_ARMS,oCreature);
        
    //Strip the Fist.
    itemproperty ip = GetFirstItemProperty(oWeapL);
    while (GetIsItemPropertyValid(ip))
    {
        RemoveItemProperty(oWeapL, ip);
        ip = GetNextItemProperty(oWeapL);
    }
    
    // Leave the fist blank if weapons are equipped.  The only way a weapon will
    // be equipped on the left hand is if there is a weapon in the right hand.
    if (GetIsObjectValid(oRighthand)) return;

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
            ip = GetFirstItemProperty(oItem);
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
    
    int iMonsterDamage = FindUnarmedDamage(oCreature);

    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyMonsterDamage(iMonsterDamage),oWeapL);

    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAttackBonus(Enh),oWeapL);
}
