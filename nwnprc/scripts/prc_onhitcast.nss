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
#include "prc_alterations"
#include "inc_grapple"
#include "psi_inc_onhit"
#include "inc_rend"
#include "psi_inc_ac_const"


void SetRancorVar(object oPC);
void SetImprovedRicochetVar(object oPC);
void DoImprovedRicochet(object oPC, object oTarget);


void main()
{
	object oSpellOrigin = OBJECT_SELF; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor

    // Call the normal OnHitCastSpell: Unique script
	if (DEBUG) DoDebug("prc_onhitcast: entered, executing normal onhitcastspell unique power script x2_s3_onhitcast for "+GetName(oSpellOrigin));
    ExecuteScript("x2_s3_onhitcast", oSpellOrigin);

	// motu99: setting a local int, so that onhitcast impact spell scripts can find out, whether they were called from prc_onhitcast
	// or from somewhere else (presumably the aurora engine). This local int will be deleted just before we exit prc_onhitcast
	// Note that any scripts that are called by a DelayCommand (or AssignCommand) from prc_onhitcast will not find this local int
	SetLocalInt(oSpellOrigin, "prc_ohc", TRUE);

    object oItem;        // The item casting triggering this spellscript
    object oSpellTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
    int nVassal;         //Vassal Level
    int nBArcher;        // Blood Archer level
    int nFoeHunter;      // Foe Hunter Level
    //int bItemIsWeapon;


	// fill the variables
	oSpellTarget = PRCGetSpellTargetObject(oSpellOrigin);

	// motu99: replaced call to Bioware's GetSpellCastItem with new PRC wrapper function
	// that will ensure that we retrieve a valid item when we are called from scripted combat (prc_inc_combat) or
	// any other routine that calls ExecuteSpellScript (found in prc_inc_spells) *outside* of a spell script
	// oItem = GetSpellCastItem();
	oItem = PRCGetSpellCastItem(oSpellOrigin);
	
	// if (DEBUG) DoDebug("prc_onhitcast: now executing prc stuff with item = "+ GetName(oItem)+", target = "+GetName(oSpellTarget)+", caller = "+GetName(oSpellOrigin));

    nVassal    = GetLevelByClass(CLASS_TYPE_VASSAL, oSpellOrigin);
    nBArcher   = GetLevelByClass(CLASS_TYPE_BLARCHER, oSpellOrigin);
    nFoeHunter = GetLevelByClass(CLASS_TYPE_FOE_HUNTER, oSpellOrigin);

    //// Swashbuckler Weakening and Wounding Criticals
    if(GetHasFeat(INSIGHTFUL_STRIKE, oSpellOrigin))
        ExecuteScript("prc_swashweak", oSpellOrigin);

    //// Stormlord Shocking & Thundering Spear

    if(GetHasFeat(FEAT_THUNDER_WEAPON, oSpellOrigin))
        ExecuteScript("ft_shockweap", oSpellOrigin);

    if (GetHasSpellEffect(TEMPUS_ENCHANT_WEAPON, oItem))
    {
        if((GetLocalInt(oSpellOrigin, "WeapEchant1") == TEMPUS_ABILITY_VICIOUS &&
             MyPRCGetRacialType(oSpellTarget)==GetLocalInt(oSpellOrigin,"WeapEchantRace1")) ||
           (GetLocalInt(oSpellOrigin,"WeapEchant2")==TEMPUS_ABILITY_VICIOUS &&
            MyPRCGetRacialType(oSpellTarget)==GetLocalInt(oSpellOrigin,"WeapEchantRace2")) ||
           (GetLocalInt(oSpellOrigin,"WeapEchant3")==TEMPUS_ABILITY_VICIOUS &&
            MyPRCGetRacialType(oSpellTarget)==GetLocalInt(oSpellOrigin,"WeapEchantRace3"))
          )
            ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(d6()),oSpellOrigin);
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
    if (nBArcher > 0 && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
    {
        // poison number based on archer level
        // gives proper DC for poison
        int iPoison = 104 + nBArcher;
        effect ePoison = EffectPoison(iPoison);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oSpellTarget);
    }

    // Frenzied Berserker Auto Frenzy
    if(GetHasFeat(FEAT_FRENZY, oSpellOrigin) && GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
    {
        if(!GetHasFeatEffect(FEAT_FRENZY, oSpellOrigin))
        {
            DelayCommand(0.01, ExecuteScript("prc_fb_auto_fre", oSpellOrigin) );
        }

        if(GetHasFeatEffect(FEAT_FRENZY, oSpellOrigin) && GetHasFeat(FEAT_DEATHLESS_FRENZY, oSpellOrigin) && GetCurrentHitPoints(oSpellOrigin) == 1)
        {
            DelayCommand(0.01, ExecuteScript("prc_fb_deathless", oSpellOrigin) );
        }
    }

    // Warsling Sniper Improved Ricochet
    if ((GetLevelByClass(CLASS_TYPE_HALFLING_WARSLINGER, oSpellOrigin) == 6) && GetLocalInt(oSpellOrigin, "CanRicochet") != 2 && GetBaseItemType(oItem) == BASE_ITEM_BULLET)
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

    // Warchief Devoted Bodyguards
    if(GetLevelByClass(CLASS_TYPE_WARCHIEF, oSpellOrigin) >= 8 && GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
    {
        // Warchief must make a reflex save
        if (!GetLocalInt(oSpellOrigin, "WarChiefDelay"))
        {
            // Done this way for formatting reasons in game
            if (ReflexSave(oSpellOrigin, 15) > 0) DelayCommand(0.01, ExecuteScript("prc_wchf_bodygrd",oSpellOrigin));
        }
        // He can only do this once a round, so put a limit on it
        // Also have to make sure its only set once a round
        if (!GetLocalInt(oSpellOrigin, "WarChiefDelay"))
        {
            SetLocalInt(oSpellOrigin, "WarChiefDelay", TRUE);
            DelayCommand(6.0, DeleteLocalInt(oSpellOrigin, "WarChiefDelay"));
        }
    }


    // Foe Hunter Damage Resistance
    if(nFoeHunter > 1 && GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
    {
        DelayCommand(0.01, ExecuteScript("prc_fh_dr",oSpellOrigin) );
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

    //Creatures with a necrotic cyst take +1d6 damage from natural attacks of undead

    if(GetHasNecroticCyst(oSpellOrigin))
    {
        //if enemy is undead
        if(MyPRCGetRacialType(oSpellTarget) == RACIAL_TYPE_UNDEAD)
        {
            //and unarmed
            if (!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSpellTarget)) &&
                !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSpellTarget)))

                {
                effect eDam = EffectDamage(d6(1), DAMAGE_TYPE_MAGICAL);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oSpellOrigin);
            }
         }
     }


    /*//////////////////////////////////////////////////
    //////////////// PSIONICS //////////////////////////
    //////////////////////////////////////////////////*/

    // SweepingStrike OnHit
    if(GetLocalInt(oItem, "SweepingStrike") && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
    {
        SweepingStrike(oSpellOrigin, oSpellTarget);
    }

    // Astral Construct's Poison Touch special ability
    if(GetLocalInt(oSpellOrigin, ASTRAL_CONSTRUCT_POISON_TOUCH))
    {
        ExecuteScript("psi_ast_con_ptch", oSpellOrigin);
    }

    /*//////////////////////////////////////////////////
    //////////////// END PSIONICS //////////////////////
    //////////////////////////////////////////////////*/
    
    /*//////////////////////////////////////////////////
    //////////////// Blade Magic ///////////////////////
    //////////////////////////////////////////////////*/
/*
    // Martial Spirit
    if(GetHasSpellEffect(MOVE_DS_MARTIAL_SPIRIT, oSpellOrigin) && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
    {
        object oHealTarget = GetCrusaderHealTarget(oSpellOrigin, 30.0);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(2), oHealTarget);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_L_LAW), oHealTarget);
    }
    
    // Blood in the Water
    if(GetHasSpellEffect(MOVE_TC_BLOOD_WATER, oSpellOrigin) && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
    {
    	// Fake critical hit check
    	if (d20() >= GetWeaponCriticalRange(oSpellOrigin, oItem))
    	{
        	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(1), oSpellOrigin);
        	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(1), oSpellOrigin);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_YELLOW_HEAD), oSpellOrigin);
	}
    }    
*/
    /*//////////////////////////////////////////////////
    //////////////// Blade Magic ///////////////////////
    //////////////////////////////////////////////////*/    

    if(GetLocalInt(oSpellOrigin,"doarcstrike") && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
    {
        int nDice = GetLocalInt(oSpellOrigin,"curentspell");
        int nDamage = d4(nDice);
        effect eDam = EffectDamage(nDamage);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oSpellTarget);
    }

    //spellsword & arcane archer
    //will also fire for other OnHit:UniquePower items that have a SpellSequencer property
    if(GetLocalInt(oItem, "X2_L_NUMTRIGGERS"))
    {
        DoDebug("Triggering Sequencer Discharge");
        ExecuteScript("x2_s3_sequencer", oSpellOrigin);
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

	// now cycle through all onhitcast spells on the item
	// we must exclude unique power (which is associated with prc_onhitcast), because otherwise we would get infinite recursions
	// it is of utmost importance to devise a *safe* way to cycle through all onhitcast spells on the item. The safe way is provided
	// by the function ApplyAllOnHitCastSpellsOnItemExcludingSubType defined in prc_inc_spells

	// There are two ways to call this function: Either with all necessary parameters passed explicitly to the function
	// or with no parameters passed to the function (in this case default values are used, which also works, at least in prc_onhitcast)

	// VERSION 1:
	// generally it is more efficient to call ApplyAllOnHitCastSpellsOnItemExcludingSubType by explicitly passing the parameters to the function
	// this will set up the overrides in the PRC-wrappers for the spell information functions, which generally is much faster
	ApplyAllOnHitCastSpellsOnItemExcludingSubType(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, oSpellTarget, oItem, oSpellOrigin);

	// VERSION 2:
	// motu99: It might be safer to call this only with defaults in order disallow overrides being set.
	// (they could have been set beforehand, though - in fact they *are* if we were routed from an onhitcast spell to prc_onhitcast)
	// VERSION 2 has also been tested to work; however, if Bioware changes its implementation the code below is more likely to break
	// ApplyAllOnHitCastSpellsOnItemExcludingSubType(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER); 

/*
// motu99: This is the old (unsafe) way to cycle through the onhitcast spells.
// This method will break, whenever the called impact spell script cycles through the item properties of the SpellCastItem on its own
// (or calls a function that cycles through the item properties - such as PRCGetMetaMagicFeat)
// The safe way to do things is to use the functions ApplyAllOnHitCastSpells* to be found in prc_inc_spells
// Left the piece of code here as an example and a warning, how perfectly reasonable code can break without the fault of the scripter
// Such an "error" can easily happen to any of us. It is hellishly difficult to spot an error, caused by nested loops
// over item properties in *different* scripts. Runtime behavior is erratic. If you are lucky, you get an
// infinite recursion (then you will notice that something is wrong). If you are not lucky, the loop will just skip over
// some item properties. And this simply because you put a completely harmless looking function like PRCGetMetaMagicFeat
// into your Spell script. How could you possibly know that you just broke your script, because of an unsafe implementation
// in a *different* script (here: prc_onhitcast)? You might not even know, that this different scripts exists.

	//handle other OnHit:CastSpell properties
DoDebug("prc_onhitcast: now doing other OnHitCastSpell properties on item = "+GetName(oItem));
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
			// int nLevel   = GetItemPropertyCostTableValue(ipTest);
			string sScript = Get2DACache("spells", "ImpactScript", nSpell);
DoDebug("prc_onhitcast: Now executing Impact spell script "+sScript);
			// motu99: Never execute complicated scripts within an GetFirst* / GetNext* loop !!!
			// The code will break, whenever the script does a loop over item properties (or effects) on its own 
			// rather store all found scripts in a local array, and execute the scripts in a separate loop
			ExecuteScript(sScript,oSpellOrigin);
		}
		ipTest = GetNextItemProperty(oItem);
	}
*/

    /*//////////////////////////////////////////////////
    ///////////////////  SPELLFIRE  ////////////////////
    //////////////////////////////////////////////////*/

    int nSpellfire = GetLevelByClass(CLASS_TYPE_SPELLFIRE, oSpellOrigin);
    if(nSpellfire && (GetBaseItemType(oItem) == BASE_ITEM_ARMOR))
    {
        int nStored = GetPersistantLocalInt(oSpellOrigin, "SpellfireLevelStored");
        int nCON = GetAbilityScore(oSpellOrigin, ABILITY_CONSTITUTION);
        int nFlare = 0;
        int bFlare = FALSE;
        if(nStored > 4 * nCON)
        {
            nFlare = d6(2);
            bFlare = TRUE;
        }
        else if(nStored > 3 * nCON)
        {
            nFlare = d6();
            bFlare = TRUE;
        }
        else if(nStored > 2 * nCON)
            nFlare = d4();
        else if(nStored > nCON)
            nFlare = 1;
        if(nFlare)
        {
            nStored -= nFlare;
            if(nStored < 0) nStored = 0;
            SetPersistantLocalInt(oSpellOrigin, "SpellfireLevelStored", nStored);
        }
        if(bFlare)
        {
            int nDC = 10 + nFlare;
            location lTarget = GetLocation(oSpellOrigin);
            object oFlareTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oFlareTarget))
            {
                if(spellsIsTarget(oFlareTarget, SPELL_TARGET_STANDARDHOSTILE, oSpellOrigin))
                {
                    if(!MyPRCResistSpell(oSpellOrigin, oFlareTarget, nSpellfire))
                    {
                        if (PRCMySavingThrow(SAVING_THROW_FORT, oFlareTarget, nDC))
                    	{
				if (GetHasMettle(oFlareTarget, SAVING_THROW_FORT))
				// This script does nothing if it has Mettle, bail
					return;  		                    	
                    	    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_S), oFlareTarget);
                    	    //EffectDazzled from race_hb
                    	    effect eAttack = EffectAttackDecrease(1);
                    	    effect eSearch = EffectSkillDecrease(SKILL_SEARCH, 1);
                    	    effect eSpot   = EffectSkillDecrease(SKILL_SPOT,   1);
                    	    effect eLink   = EffectLinkEffects(eAttack, eSearch);
                    	    eLink          = EffectLinkEffects(eLink,   eSpot);
                    	    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oFlareTarget, 60.0);
                    	}
                    }
                }
                oFlareTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            }
        }
        if(GetLocalInt(oSpellOrigin, "SpellfireCrown"))  //melts non-magical melee weapons
        {   //can't really get which weapon hit you, so...
            object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSpellTarget);
            if(GetIsObjectValid(oWeapon))
            {
                if(IPGetIsMeleeWeapon(oWeapon) && !GetIsMagicItem(oWeapon))
                {
                    DestroyObject(oWeapon);
                    FloatingTextStringOnCreature("*Your weapon has melted!*", oSpellTarget);
                }
            }
            else
            {
                oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSpellTarget);
                if(GetIsObjectValid(oWeapon))
                {
                    if(IPGetIsMeleeWeapon(oWeapon) && !GetIsMagicItem(oWeapon))
                    {
                        DestroyObject(oWeapon);
                        FloatingTextStringOnCreature("*Your weapon has melted!*", oSpellTarget);
                    }
                }
                else    //You're putting your arms and legs through something that melts weapons?
                {       //Silly monk/brawler/fool with molten weapons!
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d20()), oSpellTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d20(), DAMAGE_TYPE_FIRE), oSpellTarget);
                }
            }
        }
    }

    /*//////////////////////////////////////////////////
    ////////////////// END SPELLFIRE ///////////////////
    //////////////////////////////////////////////////*/

    // Handle poisoned weapons
    /*
    if(GetLocalInt(oItem, "pois_wpn_uses"))
    {
        ExecuteScript("poison_wpn_onhit", OBJECT_SELF);
    }
    */
    // Execute scripts hooked to this event for the player triggering it
	if (DEBUG) DoDebug("prc_onhitcast: executing all scripts hooked to onhit events of attacker and item");
    ExecuteAllScriptsHookedToEvent(oSpellOrigin, EVENT_ONHIT);
    ExecuteAllScriptsHookedToEvent(oItem, EVENT_ITEM_ONHIT);

	DeleteLocalInt(oSpellOrigin, "prc_ohc");
	
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
