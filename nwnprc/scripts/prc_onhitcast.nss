//::///////////////////////////////////////////////
//:: User Defined OnHitCastSpell code
//:: prc_onhitcast
//:://////////////////////////////////////////////
/*
    This file holds all the OnHitCastSpell events
    used by PRC.
    It was created to replace x2_s3_onhitcast so that
    it wouldn't override module-specific onhitcast events.
    
    Add your own entries after the previous ones. Try to
    keep variable scope as little as possible. ie, no top-
    level variables if you just can avoid it.
    If your entry is long (over 20 lines), consider placing
    the guts of it outside the main to improve readability
    for the rest of us :D
    
    
    Please remember comment your entry.
    At least mention what class ability / spell / whatever
    it is part of.
*/
//:://////////////////////////////////////////////
//:: Created By: Various people
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "psi_inc_onhit"
#include "inc_rend"
#include "psi_inc_ac_const"
#include "inc_eventhook"


void SetRancorVar(object oPC);
void SetPsiEnRetortVar(object oPC);
void SetImprovedRicochetVar(object oPC);
void DoImprovedRicochet(object oPC, object oTarget);

void main()
{
    // Call the normal OnHitCastSpell: Unique script
    ExecuteScript("x2_s3_onhitcast", OBJECT_SELF);

    object oItem;        // The item casting triggering this spellscript
    object oSpellTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
    object oSpellOrigin; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor
    int nVassal;         //Vassal Level
    int nBArcher;        // Blood Archer level
    int nFoeHunter;      // Foe Hunter Level
    //int bItemIsWeapon;



    // fill the variables
    oSpellOrigin = OBJECT_SELF;
    oSpellTarget = GetSpellTargetObject();
    oItem        = GetSpellCastItem();
    // Scripted combat system
    if(!GetIsObjectValid(oItem))
    {
        oItem = GetLocalObject(oSpellOrigin, "PRC_CombatSystem_OnHitCastSpell_Item");
    }
    nVassal    = GetLevelByClass(CLASS_TYPE_VASSAL, OBJECT_SELF);
    nBArcher   = GetLevelByClass(CLASS_TYPE_BLARCHER, OBJECT_SELF);
    nFoeHunter = GetLevelByClass(CLASS_TYPE_FOE_HUNTER, OBJECT_SELF);



    //// Stormlord Shocking & Thundering Spear

    if(GetHasFeat(FEAT_THUNDER_WEAPON, OBJECT_SELF))
        ExecuteScript("ft_shockweap", OBJECT_SELF);

    if (GetHasSpellEffect(TEMPUS_ENCHANT_WEAPON, oItem))
    {
        if((GetLocalInt(OBJECT_SELF, "WeapEchant1") == TEMPUS_ABILITY_VICIOUS &&
             MyPRCGetRacialType(oSpellTarget)==GetLocalInt(OBJECT_SELF,"WeapEchantRace1")) ||
           (GetLocalInt(OBJECT_SELF,"WeapEchant2")==TEMPUS_ABILITY_VICIOUS &&
            MyPRCGetRacialType(oSpellTarget)==GetLocalInt(OBJECT_SELF,"WeapEchantRace2")) ||
           (GetLocalInt(OBJECT_SELF,"WeapEchant3")==TEMPUS_ABILITY_VICIOUS &&
            MyPRCGetRacialType(oSpellTarget)==GetLocalInt(OBJECT_SELF,"WeapEchantRace3"))
          )
            ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(d6()),OBJECT_SELF);
    }

    if (GetIsPC(oSpellOrigin))
        SetLocalInt(oSpellOrigin,"DmgDealt",GetTotalDamageDealt());


    /// Vassal of Bahamut Dragonwrack
    if (nVassal > 3)
    {
        if (GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            ExecuteScript("prc_vb_dw_armor", oSpellOrigin);
        }
        else
        {
            ExecuteScript("prc_vb_dw_weap", oSpellOrigin);
        }
    }
    /// Blood Archer Acidic Blood
    if (nBArcher >= 2)
    {
        if (GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            ExecuteScript("prc_bldarch_ab", oSpellOrigin);
        }
    }

    // Blood Archer Poison Blood
    if (nBArcher > 1 && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
    {
        // poison number based on archer level
        // gives proper DC for poison
        int iPoison = 104 + nBArcher;
        effect ePoison = EffectPoison(iPoison);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oSpellTarget);
    }

    // Frenzied Berserker Auto Frenzy
    if(GetHasFeat(FEAT_FRENZY, OBJECT_SELF) && GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
    {
        if(!GetHasFeatEffect(FEAT_FRENZY))
        {
            DelayCommand(0.01, ExecuteScript("prc_fb_auto_fre", OBJECT_SELF) );
        }

        if(GetHasFeatEffect(FEAT_FRENZY) && GetHasFeat(FEAT_DEATHLESS_FRENZY, OBJECT_SELF) && GetCurrentHitPoints(OBJECT_SELF) == 1)
        {
            DelayCommand(0.01, ExecuteScript("prc_fb_deathless", OBJECT_SELF) );
        }
    }
    
    // Warsling Sniper Improved Ricochet
    if ((GetLevelByClass(CLASS_TYPE_HALFLING_WARSLINGER, oSpellOrigin) == 6) > 0 && GetLocalInt(oSpellOrigin, "CanRicochet") != 2 && GetBaseItemType(oItem) == BASE_ITEM_BULLET)
    {
        DoImprovedRicochet(oSpellOrigin, oSpellTarget);

        // Deactivates Ability
        SetLocalInt(oSpellOrigin, "CanRicochet", 2);

        // Prevents the heartbeat script from running multiple times
        if(GetLocalInt(oSpellOrigin, "ImpRicochetVarRunning") != 1)
        {
            DelayCommand(6.0, SetImprovedRicochetVar(oSpellOrigin) );
            SetLocalInt(oSpellOrigin, "ImpRicochetVarRunning", 1);
        }
    }  	


    // Foe Hunter Damage Resistance
    if(nFoeHunter > 1 && GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
    {
        DelayCommand(0.01, ExecuteScript("prc_fh_dr",OBJECT_SELF) );
    }

    // Foe Hunter Rancor Attack
    if(nFoeHunter > 0 && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
    {
        if(GetLocalInt(oSpellOrigin, "PRC_CanUseRancor") != 2 && GetLocalInt(oSpellOrigin, "HatedFoe") == MyPRCGetRacialType(oSpellTarget) )
        {
            int iFHLevel = GetLevelByClass(CLASS_TYPE_FOE_HUNTER, oSpellOrigin);
            int iRancorDice = FloatToInt( (( iFHLevel + 1.0 ) /2) );

            int iDamage = d6(iRancorDice);
            int iDamType = GetWeaponDamageType(oItem);
            int iDamPower = GetDamagePowerConstant(oItem, oSpellTarget, oSpellOrigin);

            effect eDam = EffectDamage(iDamage, iDamType, iDamPower);

            string sMess = "*Rancor Attack*";
            FloatingTextStringOnCreature(sMess, oSpellOrigin, FALSE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oSpellTarget);

            // Deactivates Ability
            SetLocalInt(oSpellOrigin, "PRC_CanUseRancor", 2);

            // Prevents the heartbeat script from running multiple times
            if(GetLocalInt(oSpellOrigin, "PRC_RancorVarRunning") != 1)
            {
                DelayCommand(6.0, SetRancorVar(oSpellOrigin) );
                SetLocalInt(oSpellOrigin, "PRC_RancorVarRunning", 1);
            }
        }
    }


    /*//////////////////////////////////////////////////
    //////////////// PSIONICS //////////////////////////
    //////////////////////////////////////////////////*/

    if (GetLocalInt(oSpellOrigin, "PsiEnRetort") > 0 && GetLocalInt(oSpellOrigin, "PsiCanRetort") != 2 && GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
    {
        PsiEnergyRetort(oSpellOrigin, oSpellTarget);

        // Deactivates Ability
        SetLocalInt(oSpellOrigin, "PsiCanRetort", 2);

        // Prevents the heartbeat script from running multiple times
        if(GetLocalInt(oSpellOrigin, "PsiRetortVarRunning") != 1)
        {
            DelayCommand(6.0, SetPsiEnRetortVar(oSpellOrigin) );
            SetLocalInt(oSpellOrigin, "PsiRetortVarRunning", 1);
        }
    }
    
    if (GetIsObjectValid(GetLocalObject(oSpellOrigin, "FatedPartner")))
    {
        DelayCommand(0.01, FateLink(oSpellOrigin));
    }

    if(GetLocalInt(oItem, "DissolvingWeaponDamage"))
    {
        int nDamage = GetLocalInt(oItem, "DissolvingWeaponDamage");

        effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
        effect eLink = EffectLinkEffects(eDamage, EffectVisualEffect(VFX_IMP_ACID_L));
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oSpellTarget);

        // Clean up the local
        DeleteLocalInt(oItem, "DissolvingWeaponDamage");
    }

    // Astral Construct's Poison Touch special ability
    if(GetLocalInt(oSpellOrigin, ASTRAL_CONSTRUCT_POISON_TOUCH))
    {
        ExecuteScript("psi_ast_con_ptch", oSpellOrigin);
    }


    // Share Pain and Share Pain, Forced
    if(GetLocalInt(oSpellOrigin, "SharePain") == TRUE && GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
    {
        DelayCommand(0.01, SharePain(oSpellOrigin));
    }

    // Empathic Feedback
    if(GetLocalInt(oSpellOrigin, "EmpathicFeedback") == TRUE && GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
    {
        DelayCommand(0.01, EmpathicFeedback(oSpellOrigin));
    }
    /*//////////////////////////////////////////////////
    //////////////// END PSIONICS //////////////////////
    //////////////////////////////////////////////////*/

    if(GetLocalInt(OBJECT_SELF,"doarcstrike") && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
    {
        int nDice = GetLocalInt(OBJECT_SELF,"curentspell");
        int nDamage = d4(nDice);
        effect eDam = EffectDamage(nDamage);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oSpellTarget);
    }

    //spellsword & arcane archer
    if(GetLocalInt(oItem, "spell") == 1 
        && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
    {

        object oPC = oSpellOrigin;
        //Arcane Archer uses same code, but can do AoE damage
        if(GetBaseItemType(oItem) != BASE_ITEM_ARROW) 
            SetLocalInt(oPC,"spellswd_aoe",1);
            
        SetLocalInt(oPC, "AttackHasHit", TRUE);    
            
        int nSpellMetamagic1 = GetLocalInt(oItem,"metamagic_feat_1");
        int nSpellMetamagic2 = GetLocalInt(oItem,"metamagic_feat_2");
        int nSpellMetamagic3 = GetLocalInt(oItem,"metamagic_feat_3");
        int nSpellMetamagic4 = GetLocalInt(oItem,"metamagic_feat_4");
        DeleteLocalString(oItem,"metamagic_feat_1");
        DeleteLocalString(oItem,"metamagic_feat_2");
        DeleteLocalString(oItem,"metamagic_feat_3");
        DeleteLocalString(oItem,"metamagic_feat_4");
        string sSpellString1 = GetLocalString(oItem,"spellscript1");
        string sSpellString2 = GetLocalString(oItem,"spellscript2");
        string sSpellString3 = GetLocalString(oItem,"spellscript3");
        string sSpellString4 = GetLocalString(oItem,"spellscript4");
        DeleteLocalString(oItem,"spellscript1");
        DeleteLocalString(oItem,"spellscript2");
        DeleteLocalString(oItem,"spellscript3");
        DeleteLocalString(oItem,"spellscript4");
        
        DeleteLocalInt(oItem,"spell");
        
        if(sSpellString1 != "")
        {
            SetLocalInt(oPC,"spell_metamagic",nSpellMetamagic1);
            ExecuteScript(sSpellString1,oPC);
        }    
        if(sSpellString2 != "")
        {
            SetLocalInt(oPC,"spell_metamagic",nSpellMetamagic2);
            ExecuteScript(sSpellString2,oPC);
        }    
        if(sSpellString3 != "")
        {
            SetLocalInt(oPC,"spell_metamagic",nSpellMetamagic3);
            ExecuteScript(sSpellString3,oPC);
        }
        if(sSpellString4 != "")
        {
            SetLocalInt(oPC,"spell_metamagic",nSpellMetamagic4);
            ExecuteScript(sSpellString4,oPC);
        }    
        
        DeleteLocalInt(oPC,"spellswd_aoe");
        DeleteLocalInt(oPC,"spell_metamagic");
        DeleteLocalInt(oPC, "AttackHasHit"); 
    }

    // Handle Rend. Creature weapon damage + 1.5x STR bonus.
    // Only happens when attacking with a creature weapon
    if(GetHasFeat(FEAT_REND, oSpellOrigin) &&
       (GetBaseItemType(oItem) == BASE_ITEM_CBLUDGWEAPON ||
        GetBaseItemType(oItem) == BASE_ITEM_CPIERCWEAPON ||
        GetBaseItemType(oItem) == BASE_ITEM_CSLASHWEAPON ||
        GetBaseItemType(oItem) == BASE_ITEM_CSLSHPRCWEAP)
      )
    {
        DoRend(oSpellTarget, oSpellOrigin, oItem);
    }
    
    //handle other OnHit:CastSpell properties
    itemproperty ipTest = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ipTest))
    {
        if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_ONHITCASTSPELL)
        {
            int nIPSpell = GetItemPropertySubType(ipTest);
            if(nIPSpell == 125)
            {   
                ipTest = GetNextItemProperty(oItem);
                continue; //abort if its OnHit:CastSpell:UniquePower otherwise it would TMI.
            }    
            int nSpell   = StringToInt(Get2DACache("iprp_onhitspell", "SpellIndex", nIPSpell));
            int nLevel   = GetItemPropertyCostTableValue(ipTest);
            string sScript = Get2DACache("spells", "ImpactScript", nSpell);
            ExecuteScript(sScript,oSpellOrigin);         
        }
        ipTest = GetNextItemProperty(oItem);
    }

    // Handle poisoned weapons
    /*
    if(GetLocalInt(oItem, "pois_wpn_uses"))
    {
        ExecuteScript("poison_wpn_onhit", OBJECT_SELF);
    }
    */
    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oSpellOrigin, EVENT_ONHIT);
    ExecuteAllScriptsHookedToEvent(oItem, EVENT_ITEM_ONHIT);
}

void SetRancorVar(object oPC)
{
    // Turn Rancor on
    SetLocalInt(oPC, "PRC_CanUseRancor", 1);
    //FloatingTextStringOnCreature("Rancor Attack Possible", oPC, FALSE);

    int iMain = GetMainHandAttacks(oPC);
    float fDelay = 6.0 / IntToFloat(iMain);

    // Turn Rancor off after one attack is made
    DelayCommand(fDelay, SetLocalInt(oPC, "PRC_CanUseRancor", 2));
    //DelayCommand((fDelay + 0.01), FloatingTextStringOnCreature("Rancor Attack Not Possible", oPC, FALSE));

    // Call again if the character is still in combat.
    // this allows the ability to keep running even if the
    // player does not score a rancor hit during the allotted time
    if( GetIsFighting(oPC) )
    {
        DelayCommand(6.0, SetRancorVar(oPC) );
    }
    else
    {
        DelayCommand(2.0, SetLocalInt(oPC, "PRC_CanUseRancor", 1));
        DelayCommand(2.1, SetLocalInt(oPC, "PRC_RancorVarRunning", 2));
        //DelayCommand(2.2, FloatingTextStringOnCreature("Rancor Enabled After Combat", oPC, FALSE));
    }
}

void SetPsiEnRetortVar(object oPC)
{
    // Turn Retort on
    SetLocalInt(oPC, "PsiCanRetort", 1);

    // Turn Retort off after one attack is made
    DelayCommand(0.01, SetLocalInt(oPC, "PsiCanRetort", 0));

    // Call again if the character is still in combat.
    // this allows the ability to keep running even if the
    // player does not score a retort hit during the allotted time
    if( GetIsFighting(oPC) )
    {
        DelayCommand(6.0, SetPsiEnRetortVar(oPC) );
    }
    else
    {
        DelayCommand(2.0, SetLocalInt(oPC, "PsiCanRetort", 1));
        DelayCommand(2.1, SetLocalInt(oPC, "PsiRetortVarRunning", 2));
    }
}

void DoImprovedRicochet(object oPC, object oTarget)
{
	int nTargetsLeft = 1;
	effect eVis = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);

	location lTarget = GetLocation(oTarget);
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);

	//Cycle through the targets within the spell shape until you run out of targets.
	while (GetIsObjectValid(oAreaTarget) && nTargetsLeft > 0)
	{
		if (spellsIsTarget(oAreaTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oAreaTarget != OBJECT_SELF && oAreaTarget != oTarget)
		{
			PerformAttack(oAreaTarget, oPC, eVis, 0.0, -2, 0, 0, "*Improved Ricochet Hit*", "*Improved Ricochet Missed*");
			 // Use up a target slot only if we actually did something to it
			nTargetsLeft -= 1;
		}
			
	//Select the next target within the spell shape.
	oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}	
}

void SetImprovedRicochetVar(object oPC)
{
    // Turn Retort on
    SetLocalInt(oPC, "CanRicochet", 1);

    // Turn Retort off after one attack is made
    DelayCommand(0.01, SetLocalInt(oPC, "CanRicochet", 0));

    // Call again if the character is still in combat.
    // this allows the ability to keep running even if the
    // player does not score a retort hit during the allotted time
    if( GetIsFighting(oPC) )
    {
        DelayCommand(6.0, SetImprovedRicochetVar(oPC));
    }
    else
    {
        DelayCommand(2.0, SetLocalInt(oPC, "CanRicochet", 1));
        DelayCommand(2.1, SetLocalInt(oPC, "ImpRicochetVarRunning", 2));
    }
}