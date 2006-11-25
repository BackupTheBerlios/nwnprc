//::///////////////////////////////////////////////
//:: x0_inc_generic
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    new functions breaking down some of the 'big'
    functions in nw_i0_generic for readability.



    MODIFICATION FEBRUARY 6 2003: MAJOR!!!
    Put the clarallactions that preceeded almost every talent call
    inside of TalentFilter


    - Dec 18 2002: Only henchmen will now make evaluations
           based upon difficulty of the combat.

* Many of these functions are incorporating
* Pausanias' changes, a big thanks goes out to him.


SECTION 1:

*/
// ChazM 7/26/06 - Modified ChooseNewTarget() to avoid familiars.
// ChazM 8/29/06 - Modified ChooseNewTarget() so that DefendMaserMode will prevent creature from aquiring 
// 				targets (except for hated enemies) that are too far away from the master.
// DBR 8/30/06 - Modified ChooseNewTarget() to continue iterating after a failed distance check.
// ChazM 9/5/06 - Modified bkAcquireTarget() so no weapon switching also applies to companions.
// ChazM 9/6/06 - Modified bkTalentFilter() to account for feat type; added TalentSpellFilter(), structure rValidTalent
// DBR 9/11/06 - Added SpellFilterHasImmunity(), to prevent casters from casting Fear and Mind spells on those that
//				 are immune (part of this is handled by bkTalentFiler)
// DBR 9/14/06 - Ignored SpellFilterHasImmunity() check if target of spell is self (for buffs).
// ChazM 9/19/06 rename bkTalentFilter() as TalentFilter()
// ChazM 9/19/06 moved GetCreatureTalentBestStd(), GetCreatureTalentRandomStd(), GetCreatureTalent() from x0_i0_talent;
//				modified TalentSpellFilter()
// BMA-OEI 10/12/06 - Added N2_COMBAT_MODE_USE_DISABLED
// DBR 10/25/06 - When choosing a new target, 'defending' companions should not choose someone who is in combat.
// DBR 11/06/06 - TalentSpellFilter() - Don't cast 'keen edge' or 'weapon of impact' on inappropriate weapons.

#include "x0_i0_debug"
// #include "x0_i0_match" -- included in x0_i0_enemy
// #include "x0_i0_enemy" -- included in x0_i0_equip
// #include "x0_i0_assoc" -- included in x0_i0_equip
#include "x0_i0_equip"

//void main(){}


/**********************************************************************
 * CONSTANTS & Structures
 **********************************************************************/

// IF this is true there is no CR consideration for using powers
const int NO_SMART = FALSE;

const float DEFEND_MASTER_MAX_TARGET_DISTANCE = 22.0f;

// prefix notation is "r" for structure definition, "o" for instance of structure.
struct rValidTalent
{
     talent tTalent;	// Talent in question 
     // int bUseAtLocation;	// set to true to signal talent to be used at location instead of on object
     object oTarget;	// tareget of the talent
     int bValid;		// FALSE indicates should be treated as TALENT_INVALID (if it existed)
};

const string N2_TALENT_EXCLUDE = "N2_TALENT_EXCLUDE";	// bit flag containing talents to exclude

// Disable changing Combat Modes in Combat AI 
const string N2_COMBAT_MODE_USE_DISABLED = "N2_COMBAT_MODE_USE_DISABLED";


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/
// wrapper for GetCreatureTalentRandom() using flag specified on the creature.
talent GetCreatureTalentRandomStd(int nCategory, object oCreature=OBJECT_SELF);

// wrapper for GetCreatureTalentBest() using flag specified on the creature.
talent GetCreatureTalentBestStd(int nCategory, int nCRMax, object oCreature=OBJECT_SELF);

// * Wrapper function so that I could add a variable to allow randomization
// * to the AI.
// * WARNING: This will make the AI cast spells badly if they have a bad
// * spell selection (i.e., only turn randomization on if you know what you are doing
// *
// * nCRMax only applies if bRandom is FALSE
// * oCreature is the creature checking to see if it has the talent
talent GetCreatureTalent(int nCategory, int nCRMax, int bRandom=FALSE, object oCreature = OBJECT_SELF);


// Set up our hated class
void bkSetupBehavior(int nBehaviour);

// Return the combat difficulty.
// This is only used for henchmen and its only function currently
// is to keep henchmen from casting spells in an easy fight.
// This determines the difficulty by counting the number of allies
// and enemies and their respective CRs, then converting the value
// into a "spell CR" rating.
// A value of 20 means use whatever you have, a negative value
// means a very easy fight.
int GetCombatDifficulty(object oRelativeTo=OBJECT_SELF, int bEnable=FALSE);

// Determine our target for the next combat round.
// Normally, this will be the same target as the last round.
// The only time this changes is if the target is gone/killed
// or they are in dying mode.
object bkAcquireTarget();

// Choose a new nearby target. Target must be an enemy, perceived,
// and not in dying mode. If possible, we first target members of
// a class we "hate" -- this is generally random, to keep everyone
// from attacking the same target.
object ChooseNewTarget();

//    Determines the Spell CR to be used in the
//    given situation
//
//    BK: changed this. It returns the the max CR for
//    this particular scenario.
//
//    NOTE: Will apply to all creatures though it may
//    be necessary to limit it just for associates.
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 18, 2001
int GetCRMax();

//    Returns true if something that shouldn't
//    have happened, happens. Will abort this combat
//    round.
int bkEvaluationSanityCheck(object oIntruder, float fFollow);

// DBR 9/11/06
//Checks to see if target creature might be immune to a certain spells
// This is not a clear-cut "does creature have immunity"? check, there are 
// some spells we do not want to check for so immunity can be seen in-game (and player can feel cool).
int SpellFilterHasImmunity(object oTarget, int nSpellID);

struct rValidTalent TalentSpellFilter(talent tUse, object oTarget);

//    This function is the last minute filter to prevent
//    any inappropriate effects from being applied
//    to inapproprite creatures.
//
//    Returns TRUE if the talent was valid, FALSE otherwise.
//
//    If an invalid talent is attempted, we instead perform
//    a standard melee attack to avoid AI stopping.
//
// Based on Pausanias's Final Talent Filter.
// Parameters
// bJustTest = If this is true the function only does a test
//  the action stack is NOT modified at all
int TalentFilter(talent tUse, object oTarget, int bJustTest=FALSE);

//Sets a local variable for the last spell used
void SetLastGenericSpellCast(int nSpell);

//Returns a SPELL_ constant for the last spell used
int GetLastGenericSpellCast();

//Compares the current spell with the last one cast
int CompareLastSpellCast(int nSpell);

//Does a check to determine if the NPC has an attempted
//spell or attack target
int GetIsFighting(object oFighting);


/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

 // wrapper for GetCreatureTalentRandom() using flag specified on the creature.
talent GetCreatureTalentRandomStd(int nCategory, object oCreature=OBJECT_SELF)
{
	return (GetCreatureTalentRandom(nCategory, oCreature, GetLocalInt(oCreature, N2_TALENT_EXCLUDE)));
}
// wrapper for GetCreatureTalentBest() using flag specified on the creature.
talent GetCreatureTalentBestStd(int nCategory, int nCRMax, object oCreature=OBJECT_SELF)
{
	return (GetCreatureTalentBest(nCategory, nCRMax, oCreature, GetLocalInt(oCreature, N2_TALENT_EXCLUDE)));
}

// * Wrapper function so that I could add a variable to allow randomization
// * to the AI.
// * WARNING: This will make the AI cast spells badly if they have a bad
// * spell selection (i.e., only turn randomization on if you know what you are doing
// *
// * nCRMax only applies if bRandom is FALSE
// * oCreature is the creature checking to see if it has the talent
talent GetCreatureTalent(int nCategory, int nCRMax, int bRandom=FALSE, object oCreature = OBJECT_SELF)
{
    // * bRandom can be overridden by the variable X2_SPELL_RANDOM = 1
    if (bRandom == FALSE)
    {
        bRandom = GetLocalInt(OBJECT_SELF, "X2_SPELL_RANDOM");
    }

    if (bRandom == FALSE)
    {
        return GetCreatureTalentBestStd(nCategory, nCRMax, oCreature);
    }
    else
    // * randomize it
    {
        return GetCreatureTalentRandomStd(nCategory, oCreature);
    }
}



//::///////////////////////////////////////////////
//:: SetupBehaviour
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Behavior1 = Hated Class
*/
void bkSetupBehavior(int nBehaviour)
{
    int nHatedClass = Random(10);
    nHatedClass = nHatedClass + 1;     // for purposes of using 0 as a
                                       // unitialized value.
                                       // will decrement in bkAcquireTarget
    SetLocalInt(OBJECT_SELF, "NW_L_BEHAVIOUR1", nHatedClass);
}

// Return the combat difficulty.
// This is only used for henchmen and its only function currently
// is to keep henchmen from casting spells in an easy fight.
// This determines the difficulty by counting the number of allies
// and enemies and their respective CRs, then converting the value
// into a "spell CR" rating.
// A value of 20 means use whatever you have, a negative value
// means a very easy fight.
// * Only does something if Enable is turned on, since I originally turned this function off
int GetCombatDifficulty(object oRelativeTo=OBJECT_SELF, int bEnable=FALSE)
{
    // DECEMBER 2002
    // * if I am not a henchman then DO NOT use combat difficulty
    // * simply use whatever I have available

    // FEBRUARY 2003
    // * Testing indicated that people were just too confused
    // * when they saw their henchmen not casting spells
    // * so this functionality has been cut entirely.

    // if (GetHenchman(GetMaster()) != oRelativeTo)
    if (bEnable == FALSE)
        return 20;

    // * Count Enemies
    struct sSituation sitCurr = CountEnemiesAndAllies(20.0, oRelativeTo);
    int nNumEnemies = sitCurr.ENEMY_NUM;
    int nNumAllies = sitCurr.ALLY_NUM;
    int nAllyCR = sitCurr.ALLY_CR;
    int nEnemyCR = sitCurr.ENEMY_CR;

    // * If for some reason no enemies then return low number
    if (nNumEnemies == 0) return -3;
    if (nNumAllies == 0) nNumAllies = 1;

    // * Average CR of enemies vs. Average CR of the players
    // * The + 5.0 is for flash. It would be boring if equally matched
    // * opponents never cast spells at each other.
    int nDiff = (nEnemyCR/nNumEnemies) - (nAllyCR/nNumAllies) + 3;

    // * if my side is outnumbered, then add difficulty to it
    if (nNumEnemies > (nNumAllies + 1))
        nDiff += 10;

    if (nDiff <= 1)
        return -2;

    // We now convert this number into the "spell CR" --
    // spell CR is as follows:
    // spell innate level * 2 - 1
    // eg, cantrip: innate level 0: spell CR -1
    // level 1 spell: innate level 1: spell CR 1
    // level 4 spell: innate level 4: spell CR 7
    // etc
    nDiff = (nDiff * 2) - 1;

    // * If I am at less than 50% hit-points add +10 -->
    // * it means that things are going badly for me
    // * and I need an edge
    if (GetCurrentHitPoints() <= GetMaxHitPoints()/2)
        nDiff = nDiff + 10;

    // * if not a low number then just return the difficulty
    // * converted into 'spell rounding'
    return nDiff;
}

// This function returns the target for this combat round.
// Normally, this will be the same target as the last round.
// The only time this changes is if the target is gone/killed
// or they are in dying mode.
object bkAcquireTarget()
{
    object oLastTarget = GetAttackTarget();

    // * for now no 'target switching' other
    // * than what occurs in the OnDamaged and OnPerceived events
    // * (I may roll their functionality into this function
    if (GetIsObjectValid(oLastTarget) == TRUE
        && !GetAssociateState(NW_ASC_MODE_DYING, oLastTarget))
    {
        return oLastTarget;
    } else {
        oLastTarget = ChooseNewTarget();
    }

    // * If no valid target it means no enemies are nearby, resume normal behavior
    if (! GetIsObjectValid(oLastTarget)) {
        // * henchmen should only equip weapons based on what you tell them
        if (GetIsObjectValid(GetCurrentMaster(OBJECT_SELF)) == FALSE) {
            // * if no ranged weapon this function should
            // * automatically be melee weapon
            ActionEquipMostDamagingRanged();
        }
    }

    // valid or not, return it
    return oLastTarget;
}



// Choose a new nearby target. Target must be an enemy, perceived,
// and not in dying mode. If possible, we first target members of
// a class we hate.
object ChooseNewTarget()
{
    int nHatedClass = GetLocalInt(OBJECT_SELF, "NW_L_BEHAVIOUR1") - 1;

    // * if the object has no hated class, then assign it
    // * a random one.
    // * NOTE: Classes are off-by-one
    if (nHatedClass == -1)
    {
        bkSetupBehavior(1);
        nHatedClass = GetLocalInt(OBJECT_SELF, "NW_L_BEHAVIOUR1") - 1;
    }

    //MyPrintString("I hate " + IntToString(nHatedClass));

    // * First try to attack the class you hate the most
    object oTarget = GetNearestPerceivedEnemy(OBJECT_SELF, 1,
                                              CREATURE_TYPE_CLASS,
                                              nHatedClass);

    if (GetIsObjectValid(oTarget) && !GetAssociateState(NW_ASC_MODE_DYING, oTarget))
	{
		//if in Defend master, skip this step because of the over-ruling behaviors of defend master
		if (!(GetAssociateState(NW_ASC_MODE_DEFEND_MASTER))) 
			// familiars of hated type don't qualify
			if (GetAssociateType(oTarget) != ASSOCIATE_TYPE_FAMILIAR)
	        	return oTarget;
	}
    // If we didn't find one with the criteria, look
    // for a nearby one
    // * Keep looking until we find a perceived target that
    // * isn't in dying mode
    oTarget = GetNearestPerceivedEnemy();
    int nNth = 1, nSaveNth;
	object oSaveTarget;
    while (GetIsObjectValid(oTarget)
           && GetAssociateState(NW_ASC_MODE_DYING, oTarget))
    {
        nNth++;
        oTarget = GetNearestPerceivedEnemy(OBJECT_SELF, nNth);
    }
	
	// if target is a familiar, keep looking
	if (GetIsObjectValid(oTarget) && GetAssociateType(oTarget) == ASSOCIATE_TYPE_FAMILIAR)
	{
		oSaveTarget = oTarget;
		nSaveNth = nNth;
        nNth++;
		oTarget = GetNearestPerceivedEnemy(OBJECT_SELF, nNth);
	    while ((GetIsObjectValid(oTarget)
	           && GetAssociateState(NW_ASC_MODE_DYING, oTarget))
			   || (GetAssociateType(oTarget) == ASSOCIATE_TYPE_FAMILIAR))
	    {
	        nNth++;
	        oTarget = GetNearestPerceivedEnemy(OBJECT_SELF, nNth);
	    }
	
		// if couldn't find a non-familiar to attack, then attack the familiar.
		if (!GetIsObjectValid(oTarget))
		{
			oTarget = oSaveTarget;
			nNth = nSaveNth;
		}
	}

	//Warning - GetAssociateState is doing double duty here, making sure OBJECT_SELF is an associate and also making sure it is set to stand ground.
	//	This function is run for all creatures, not just associates.
	if (GetAssociateState(NW_ASC_MODE_DEFEND_MASTER)) // have associates w/ Defend Master stay in sight of Master		
	{
		object oMaster = GetCurrentMaster();
	    while (GetIsObjectValid(oTarget) && 
			((!GetIsInCombat(oTarget)) || GetAssociateState(NW_ASC_MODE_DYING, oTarget) || ((GetDistanceBetween(oMaster, oTarget) >= DEFEND_MASTER_MAX_TARGET_DISTANCE))))
	    {
       		nNth++;
       		oTarget = GetNearestPerceivedEnemy(OBJECT_SELF, nNth);
    	}
	}////	
	
    return oTarget;
}


//::///////////////////////////////////////////////
//:: Get CR Max for Talents
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines the Spell CR to be used in the
    given situation

    BK: changed this. It returns the the max CR for
    this particular scenario.

    NOTE: Will apply to all creatures though it may
    be necessary to limit it just for associates.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 18, 2001
//:://////////////////////////////////////////////
int GetCRMax()
{
    //int nCR;

    // * retrieves the combat difficulty that has been stored
    // * from being set in DetermineCombatRound
    //int nDiff =  GetLocalInt(OBJECT_SELF, "NW_L_COMBATDIFF");

    if  (NO_SMART == TRUE)
        return 20;
   else
       return GetLocalInt(OBJECT_SELF, "NW_L_COMBATDIFF"); // the max CR of any talent that is going to be used
}



//::///////////////////////////////////////////////
//:: bkEvaluationSanityCheck
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Returns true if something that shouldn't
    have happened, happens. Will abort this combat
    round.



*/
int bkEvaluationSanityCheck(object oIntruder, float fFollow)
{
    // Pausanias: sanity check for various effects
    if (GetHasEffect(EFFECT_TYPE_PARALYZE) ||
        GetHasEffect(EFFECT_TYPE_STUNNED) ||
        GetHasEffect(EFFECT_TYPE_FRIGHTENED) ||
        GetHasEffect(EFFECT_TYPE_SLEEP) ||
        GetHasEffect(EFFECT_TYPE_DAZED))
        return TRUE;

    // * no point in seeing if intruder has same master if no valid intruder
    if (!GetIsObjectValid(oIntruder))
        return FALSE;

    // Pausanias sanity check: do not attack target
    // if you share the same master.
    object oMaster = GetMaster();
    int iHaveMaster = GetIsObjectValid(oMaster);
    if (iHaveMaster && GetMaster(oIntruder) == oMaster)
        return TRUE;

    return FALSE; //* COntinue on with DetermineCombatRound
}

// DBR 9/11/06
//Checks to see if target creature might be immune to a certain spells
// This is not a clear-cut "does creature have immunity"? check, there are 
// some spells we do not want to check for so immunity can be seen in-game (and player can feel cool).
int SpellFilterHasImmunity(object oTarget, int nSpellID)
{
	string sImmunity = Get2DAString("spells","ImmunityType",nSpellID);
	
	/*	if (sImmunity=="Acid")
		else if (sImmunity == "Cold")
		else if (sImmunity == "Death")
			return GetIsImmune(oTarget,IMMUNITY_TYPE_DEATH);
		else if (sImmunity == "Disease")
			return GetIsImmune(oTarget,IMMUNITY_TYPE_DISEASE);
		else if (sImmunity == "Divine")
		else if (sImmunity == "Electricity")
	*/
		
		if (sImmunity == "Fear")
			return GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR);
		//else if (sImmunity == "Fire")
		else if (sImmunity == "Mind_Affecting")
			return GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS);
		/*else if (sImmunity == "Negative")
		else if (sImmunity == "Poison")
			return GetIsImmune(oTarget, IMMUNITY_TYPE_POISON);
		else if (sImmunity == "Positive")
		else if (sImmunity == "Sonic")*/

	return FALSE;
}


// ChazM 10/6/06 - split out from TalentFilter.  Refrained from calling it cmTalentSpellFilter() ;)
// Run a talent of type spell through a filter to make sure it's sensible.
// return a struct that specifies our final choice of talent and if it's valid
struct rValidTalent TalentSpellFilter(talent tUse, object oTarget)
{
    talent tFinal = tUse;
	object oFinalTarget = oTarget;
	
    int iId = GetIdFromTalent(tUse);
    int iAmDone = FALSE;
    int nNotValid = FALSE;

    int nTargetRacialType = GetRacialType(oTarget);

	// Check for undead!
	
    if (nTargetRacialType == RACIAL_TYPE_UNDEAD)
    {
		//SpawnScriptDebugger();
		
        // DO NOT USE SILLY HARM ON THEM; substitute a heal spell if possible
        if (MatchInflictTouchAttack(iId) || MatchMindAffectingSpells(iId))
        {
			
            talent tTemp =
                GetCreatureTalentBestStd(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH,20);
            if (GetIsTalentValid(tTemp)
                && GetIdFromTalent(tTemp) == SPELL_HEAL
                && GetChallengeRating(oTarget) > 8.0)
            {
                tFinal = tTemp;
                iAmDone = TRUE;
            }  else
            {
                nNotValid = TRUE;
            }
        }

    }

    // *
    // * Don't use drown against nonliving opponents
    if (iId == SPELL_DROWN && !iAmDone)
    {
        if (MatchNonliving(nTargetRacialType) == TRUE)
        {
           nNotValid = TRUE;
           iAmDone = TRUE;
           DecrementRemainingSpellUses(OBJECT_SELF, SPELL_DROWN);
        }

    }
	
	//Straight up immunity check, skipped on self-buff spells
	if (OBJECT_SELF!=oTarget) //ignore immunity for buffs
		if (SpellFilterHasImmunity(oTarget, iId) && !iAmDone)
		{
			nNotValid = TRUE;
			iAmDone= TRUE;	
		}
	
	//Don't cast 'keen edge' on bludgeoning weapons 
	if (!iAmDone && (iId == SPELL_KEEN_EDGE))
	{
		int nWeaponType = GetWeaponType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget));
		if ((nWeaponType == WEAPON_TYPE_BLUDGEONING)||(nWeaponType == WEAPON_TYPE_NONE))
		{
	        DecrementRemainingSpellUses(OBJECT_SELF, iId); //these should be removed when we can iterate through talents
			nNotValid=TRUE;
			iAmDone=TRUE;
		}
	}
	
	//Don't cast 'weapon of impact' on anything but bludgeoning weapons
	if (!iAmDone && (iId == SPELL_WEAPON_OF_IMPACT))
	{
		int nWeaponType = GetWeaponType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget));
		if (nWeaponType != WEAPON_TYPE_BLUDGEONING)
		{
	        DecrementRemainingSpellUses(OBJECT_SELF, iId);//these should be removed when we can iterate through talents
			nNotValid=TRUE;
			iAmDone=TRUE;
		}
	}
		
		
    // * August 2003
    // * If casting certain spells that should not harm creatures
    // * who are immune to losing levels, try another
    if (!iAmDone && iId == SPELL_ENERGY_DRAIN && GetIsImmune(oTarget, IMMUNITY_TYPE_NEGATIVE_LEVEL))
    {
        nNotValid = TRUE;
        DecrementRemainingSpellUses(OBJECT_SELF, iId);
        iAmDone = TRUE;
    }

// JLR - OEI 07/11/05 -- Removed
    // * Negative damage does nothing to undead or constructs. Don't use it.
    if (!iAmDone && (iId == SPELL_NEGATIVE_ENERGY_BURST || iId == SPELL_NEGATIVE_ENERGY_RAY) && nTargetRacialType == RACIAL_TYPE_CONSTRUCT)
    {
        nNotValid = TRUE;
        DecrementRemainingSpellUses(OBJECT_SELF, iId);
        iAmDone = TRUE;
    }

    // Check if the sleep spell is being used appropriately.
    if (iId == SPELL_SLEEP && !iAmDone)
    {
        if (GetHitDice(oTarget) > 4)
        {
            nNotValid = TRUE;
            iAmDone = TRUE;
            DecrementRemainingSpellUses(OBJECT_SELF, SPELL_SLEEP);
        }

        // * elves and half-elves are immune to sleep
        switch (nTargetRacialType)
        {
        case RACIAL_TYPE_ELF:
        case RACIAL_TYPE_HALFELF:
          nNotValid = TRUE;
          iAmDone = TRUE;
          DecrementRemainingSpellUses(OBJECT_SELF, SPELL_SLEEP);
          break;
        }

    }

    // * Check: (Dec 19 2002) Don't waste Power Word Kill
    // on Targets with more than 100hp
    if (iId == SPELL_POWER_WORD_KILL && !iAmDone)
    {
        if (GetCurrentHitPoints(oTarget) > 100)
        {
            nNotValid = TRUE;
            iAmDone = TRUE;
            // * remove the spell, so the caster doesn't get stuck
            // * trying to use it.
            DecrementRemainingSpellUses(OBJECT_SELF, iId);

            // * Since planning on doing a harmful ranged, try another one
            talent tUse = GetCreatureTalentBestStd(TALENT_CATEGORY_HARMFUL_RANGED, 20);
            if(GetIsTalentValid(tUse))
            {
                nNotValid = FALSE;
            }
            else
            {
             DecrementRemainingSpellUses(OBJECT_SELF, SPELL_POWER_WORD_KILL);
            }
        }
    }

    // Check if person spells are being used appropriately.

    if (MatchPersonSpells(iId) && !iAmDone)
        switch (nTargetRacialType)
        {
            case RACIAL_TYPE_ELF:
            case RACIAL_TYPE_HALFELF:
            case RACIAL_TYPE_DWARF:
            case RACIAL_TYPE_HUMAN:
            case RACIAL_TYPE_HALFLING:
            case RACIAL_TYPE_HALFORC:
            case RACIAL_TYPE_GNOME: iAmDone = TRUE; DecrementRemainingSpellUses(OBJECT_SELF, iId); break;

            default: nNotValid = TRUE; break;
        }

    // Do a final check for mind affecting spells.
    if (MatchMindAffectingSpells(iId) && !iAmDone)
	{
        if (GetIsImmune(oTarget,IMMUNITY_TYPE_MIND_SPELLS))
        {
            nNotValid = TRUE;
            DecrementRemainingSpellUses(OBJECT_SELF, iId);
		}
	}
	
    // *
    // * STAY STILL!!  (return condition)
    // * September 5 2003
    // *
    // * In certain cases (i.e., the spell Meteor Swarm) the caster should not move
    // * towards his target if the target is within range. In this caster the caster should just
    // * cast the spell centered around himself
    if (iId == SPELL_METEOR_SWARM || iId == SPELL_FIRE_STORM || iId == SPELL_STORM_OF_VENGEANCE)
    {
        if (GetDistanceToObject(oTarget) <= 10.5)
        {
            //ActionUseTalentAtLocation(tFinal, GetLocation(OBJECT_SELF));
            //return TRUE;
        }
        else
        {
            ActionMoveToObject(oTarget, TRUE, 9.0);
            //ActionUseTalentAtLocation(tFinal, GetLocation(OBJECT_SELF));
            //return TRUE;
        }
		oFinalTarget = OBJECT_SELF; // change target to self.
    }
	
	struct rValidTalent oRet;
	
	oRet.tTalent = tFinal;
	oRet.bValid = !nNotValid;
	oRet.oTarget = oFinalTarget;
	return (oRet);
}



/*
//    This function is the last minute filter to prevent
//    any inappropriate effects from being applied
//    to inapproprite creatures.
//
//    Returns TRUE if the talent was valid, FALSE otherwise.
//
//    If an invalid talent is attempted, we instead perform
//    a standard melee attack to avoid AI stopping.
//
 MODIFIED JULY 11 2003 (BK):
      - If I cannot use this particular ability
        then in *most* cases I will delete the spell
        from my list so I do not try to use it again.
        This will help to prevent the "wizard just attacking"
        when the spell they most want to use is ineffective.
// Based on Pausanias's Final Talent Filter.
//
*/
int TalentFilter(talent tUse, object oTarget, int bJustTest=FALSE)
{
	int iType = GetTypeFromTalent(tUse);
    int bValid = TRUE;

	if (bJustTest == FALSE)
		ClearActions(CLEAR_X0_INC_GENERIC_TalentFilter);

	bkEquipAppropriateWeapons(oTarget, GetAssociateState(NW_ASC_USE_RANGED_WEAPON));

    
	switch (iType)
	{
		case TALENT_TYPE_SPELL:
		{
			struct rValidTalent oTalent = TalentSpellFilter(tUse, oTarget);
			tUse = oTalent.tTalent;
			bValid = oTalent.bValid;
			oTarget = oTalent.oTarget;
			break;
		}	
		case TALENT_TYPE_FEAT:
	        //MyPrintString("Using feat: " + IntToString(iId));
	        if (VerifyCombatMeleeTalent(tUse, oTarget)
	            && VerifyDisarm(tUse, oTarget))
	        {
	            //MyPrintString("combat melee & disarm OK");
	            bValid = FALSE;
	        }
			break;
			
		case TALENT_TYPE_SKILL:
			break;
	}


    // * BK: My talent was not appropriate to use
    // *     will attack this round instead
    if (!bValid)
    {
        //MyPrintString("Invalid talent, id: " + IntToString(iId)
        //              + ", type: " + IntToString(GetTypeFromTalent(tUse)));

        if (bJustTest == FALSE)
          WrapperActionAttack(oTarget);
    }
    else
    {
        if (bJustTest == FALSE)
		{
			//if (bUseLocation)
            //	ActionUseTalentAtLocation(tUse, GetLocation(oTarget));
			//else				
        		ActionUseTalentOnObject(tUse, oTarget);
		}
    }

    return (bValid);
}



//::///////////////////////////////////////////////
//:: Get / Set Compare Last Spell Cast
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gets the local int off of the character
    determining what the Last Spell Cast was.

    Sets the local int on of the character
    storing what the Last Spell Cast was.

    Compares whether the local is the same as the
    currently selected spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 27, 2002
//:://////////////////////////////////////////////

int GetLastGenericSpellCast()
{
    return GetLocalInt(OBJECT_SELF, "NW_GENERIC_LAST_SPELL");
}

void SetLastGenericSpellCast(int nSpell)
{
    SetLocalInt(OBJECT_SELF, "NW_GENERIC_LAST_SPELL", nSpell);
    // February 2003. Needed to add a way for this to reset itself, so that
    // spell might indeed be atempted later.
    DelayCommand(8.0,SetLocalInt(OBJECT_SELF, "NW_GENERIC_LAST_SPELL", -1));
}

int CompareLastSpellCast(int nSpell)
{
    int nLastSpell = GetLastGenericSpellCast();
    if(nSpell == nLastSpell)
    {
        return TRUE;
        SetLastGenericSpellCast(-1);
    }
    return FALSE;
}


//::///////////////////////////////////////////////
//:: GetIsFighting
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks if the passed object has an Attempted
    Attack or Spell Target
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 13, 2002
//:://////////////////////////////////////////////
int GetIsFighting(object oFighting)
{
    object oAttack = GetAttemptedAttackTarget();
    object oSpellTarget = GetAttemptedSpellTarget();

    if(GetIsObjectValid(oAttack) || GetIsObjectValid(oSpellTarget))
    {
        return TRUE;
    }
    return FALSE;
}



/* void main() {} /* */