/*

    prc_inc_natweap.nss
    
    Natural Weapon include
    
    This include controlls natural weapons.
    These are different to unarmed weapons.
    
    From the SRD:
    
    Natural Weapons
    
    Natural weapons are weapons that are physically a part of a creature. A creature making a melee attack with 
    a natural weapon is considered armed and does not provoke attacks of opportunity. Likewise, it threatens any 
    space it can reach. Creatures do not receive additional attacks from a high base attack bonus when using 
    natural weapons. The number of attacks a creature can make with its natural weapons depends on the type of 
    the attackl generally, a creature can make one bite attack, one attack per claw or tentacle, one gore attack, 
    one sting attack, or one slam attack (although Large creatures with arms or arm-like limbs can make a slam 
    attack with each arm). Refer to the individual monster descriptions.
    
    Unless otherwise noted, a natural weapon threatens a critical hit on a natural attack roll of 20.
    
    When a creature has more than one natural weapon, one of them (or sometimes a pair or set of them) is the 
    primary weapon. All the creature’s remaining natural weapons are secondary.
    
    The primary weapon is given in the creature’s Attack entry, and the primary weapon or weapons is given first 
    in the creature’s Full Attack entry. A creature’s primary natural weapon is its most effective natural attack, 
    usually by virtue of the creature’s physiology, training, or innate talent with the weapon. An attack with a 
    primary natural weapon uses the creature’s full attack bonus. Attacks with secondary natural weapons are less 
    effective and are made with a -5 penalty on the attack roll, no matter how many there are. (Creatures with the 
    Multiattack feat take only a -2 penalty on secondary attacks.) This penalty applies even when the creature 
    makes a single attack with the secondary weapon as part of the attack action or as an attack of opportunity. 
    
    Natural weapons have types just as other weapons do. The most common are summarized below.
     
    Bite
    The creature attacks with its mouth, dealing piercing, slashing, and bludgeoning damage.
    
    Claw or Talon
    The creature rips with a sharp appendage, dealing piercing and slashing damage.
    
    Gore
    The creature spears the opponent with an antler, horn, or similar appendage, dealing piercing damage.
    
    Slap or Slam
    The creature batters opponents with an appendage, dealing bludgeoning damage.
    
    Sting
    The creature stabs with a stinger, dealing piercing damage. Sting attacks usually deal damage from poison in 
    addition to hit point damage.
    
    Tentacle    
    The creature flails at opponents with a powerful tentacle, dealing bludgeoning (and sometimes slashing) damage. 
    
    The main differences are:
    
    *) There are primary and secondary natural weapons.
    
    *) Natural weapons do not get additional attacks at higher BAB
    
    *) Primary natural weapon is at full BAB with full str bonus
    
    *) Secondary natural weaponss are at -5 (or -2 with Multiattack, or no penalty for Improved Multiattack) 
       with half strength bonus
    
    *) If a creature has a weapon in its "hands", it may still use non-claw attacks. For example, a double axe 
       plus a bite.
    
    *) A creature with both natural claw weapons and unarmed attacks, for example a Monk Werewolf, can choose
       to either use natural claw weapons or unarmed attacks, but not both.
       
       
    Implementation notes:
    
    *) Primary natural weapons use the creature inventory slots so the animation works
    
    *) Secondary natural weapons use the heartbeat and the scripted combat engine
    
    *) Since bioware divides the 6 second combat round into 3 flurries, secondary weapons try to respect those
       flurries.
       
    *) The target for secondary weapons GetAttackTarget() is used.
    
    *) Since initiative is hardcoded, we cant use that at all. Relies on heartbeat scripts instead.
*/

void DoNaturalAttack(object oWeapon);
void DoNaturalWeaponHB(object oPC = OBJECT_SELF);
void AddNaturalSecondaryWeapon(object oPC, string sResRef, int nCount = 1);
int GetIsUsingPrimaryNaturalWeapons(object oPC);
void SetIsUsingPrimaryNaturalWeapons(object oPC, int nNatural);
void ClearNaturalWeapons(object oPC);
void UpdateSecondaryWeaponSizes(object oPC);
string GetAffixForSize(int nSize);
void SetPrimaryNaturalWeapon(object oPC, int nIndex);
void RemoveNaturalPrimaryWeapon(object oPC, string sResRef);
void NaturalSecondaryWeaponTempCheck(object oManifester, object oTarget, int nSpellID, 
    int nBeatsRemaining, string sResref);
void NaturalPrimaryWeaponTempCheck(object oManifester, object oTarget, int nSpellID, 
    int nBeatsRemaining, string sResref);

//the name of the array that the resrefs of the natural weapons are stored in
const string ARRAY_NAT_SEC_WEAP_RESREF   = "ARRAY_NAT_SEC_WEAP_RESREF";
const string ARRAY_NAT_PRI_WEAP_RESREF   = "ARRAY_NAT_PRI_WEAP_RESREF";
const string ARRAY_NAT_PRI_WEAP_ATTACKS  = "ARRAY_NAT_PRI_WEAP_ATTACKS";
const string NATURAL_WEAPON_ATTACK_COUNT = "NATURAL_WEAPON_ATTACK_COUNT";

#include "prc_alterations"
#include "prc_inc_combat"
#include "x2_i0_spells"

void DoNaturalAttack(object oWeapon)
{

    //if weapon is not valid, abort    
    if(!GetIsObjectValid(oWeapon))
        return;


//    object oTarget = GetAttackTarget(); 
    object oTarget = GetAttemptedAttackTarget(); 

// motu99: The following checks should be made by PerformAttack(), so they are somewhat redundant

	// if not melee/ranged fighting, abort
	if (!GetIsObjectValid(oTarget))
		return;

    //no point attacking plot
    if(GetPlotFlag(oTarget))
        return;

	object oPC = OBJECT_SELF;
	
	// natural attacks are (usually) not ranged attacks, so PerformAttack() will move to a target, if it is out of melee range
	// However, we do not want to run to the target if we are in the midst of doing ranged attacks, e.g. if we have a ranged
	// weapon equipped (and are still out of melee range, so we can effectively do ranged attacks)
	// so check for a ranged weapon in the right hand slot and abort if we have one and are out of melee range
	object oWeaponR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	if (GetIsObjectValid(oWeaponR)
		&& GetIsRangedWeaponType(GetBaseItemType(oWeaponR))
		&& !GetIsInMeleeRange(oTarget, oPC))
		return;
/*		
	//if not fighting, abort 
	// motu99: GetIsFighting() not only checks. whether GetAttemptedAttackTarget() (relevant for melee attacks) returns a valid object
	// it also checks whether we have attempted to attack a valid target with a spell
	// but spell attacks don't make sense for natural attacks (which are pure melee), so commented out
	if(!GetIsFighting(oPC))
	{ 
 DoDebug(COLOR_WHITE + "DoNaturalAttack(): not fighting any more - aborting");
		return;
	}
*/
    
    //null effect
    effect eInvalid;
    string sMessageSuccess;
    string sMessageFailure;
	if (DEBUG)
	{
		sMessageSuccess += GetName(oWeapon);
		//add attack
		sMessageSuccess += " natural attack";        
		//copy it to failure
		sMessageFailure = sMessageSuccess;
		//add hit/miss
		sMessageSuccess += " hit";
		sMessageFailure += " miss";
		//add stars around messages
		sMessageSuccess = "*"+sMessageSuccess+"*";
		sMessageFailure = "*"+sMessageFailure+"*";
	}

    //secondary attacks are -5 to hit
    int nAttackMod = -5;
/*
	//check for (Improved) Multiattack
	if(GetHasFeat(FEAT_IMPROVED_MULTIATTACK, oPC))
		nAttackMod = 0;
	else if(GetHasFeat(FEAT_MULTIATTACK, oPC))
		nAttackMod = -2;
*/
    //secondary attacks are half strength (we use offhand for this)


	if (DEBUG) DoDebug(COLOR_WHITE + "initiating a secondary natural attack with "+GetName(oWeapon)+" and attack mod " + IntToString(nAttackMod));     

    PerformAttack(oTarget, 
        oPC,                //
        eInvalid,           //effect eSpecialEffect,
        0.0,                //float eDuration = 0.0
        nAttackMod,         //int iAttackBonusMod = 0
        0,                  //int iDamageModifier = 0
        DAMAGE_TYPE_SLASHING,    //int iDamageType = DAMAGE_TYPE_SLASHING, otherwise it uses magical damage.
        sMessageSuccess,	//sMessageSuccess
        sMessageFailure,	//sMessageFailure
        FALSE,              //int iTouchAttackType = FALSE
        oWeapon,      // we should have something in the right hand (might need it for some calculations)
        oWeapon,      // we put the creature weapon in the left hand slot 
        1             //offhand override (for half strength)
        );        
}

void DoOffhandAttack(int nAttackMod)
{
	object oPC = OBJECT_SELF;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);


	// check for offhand or double sided weapon, if not - return
	if (!GetIsOffhandWeapon(oWeapon))
	{
		object oWeaponR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		if (!GetIsDoubleSidedWeapon(oWeaponR))
			return;
		oWeapon = oWeaponR;
	}

 //    object oTarget = GetAttackTarget(); 
	object oTarget = GetAttemptedAttackTarget(); 

	// motu99: The following checks should be made by PerformAttack(), so they are somewhat redundant

   //no point attacking plot
    if(GetPlotFlag(oTarget))
        return;

	// if not melee fighting, abort
	if (!GetIsObjectValid(oTarget))
		return;

/*
	//if not fighting, abort 
	if(!GetIsFighting(oPC))
	{
		DoDebug(COLOR_WHITE + "DoOffhandAttack(): not fighting any more - aborting");
		return;
	}
*/

    string sMessageSuccess;
    string sMessageFailure;
	if (DEBUG)
	{
		sMessageSuccess += GetName(oWeapon);
		//add attack
		sMessageSuccess += " scripted offhand";
		//copy it to failure
		sMessageFailure = sMessageSuccess;
		//add hit/miss
		sMessageSuccess += " hit";
		sMessageFailure += " miss";
		//add stars around messages
		sMessageSuccess = "*"+sMessageSuccess+"*";
		sMessageFailure = "*"+sMessageFailure+"*";
	}
    
    //null effect
    effect eInvalid;

	if (DEBUG) DoDebug(COLOR_WHITE + "initiating an overflow offhand attack with "+GetName(oWeapon)+" and attack mod "+IntToString(nAttackMod));  	

	PerformAttack(oTarget, 
        oPC,                //
        eInvalid,           //effect eSpecialEffect,
        0.0,                //float eDuration = 0.0
        nAttackMod,         //int iAttackBonusMod = 0
        0,                  //int iDamageModifier = 0
        DAMAGE_TYPE_SLASHING,    //int iDamageType = DAMAGE_TYPE_SLASHING, otherwise it uses magical damage.
        sMessageSuccess,	//sMessageSuccess,    //string sMessageSuccess = ""   
        sMessageFailure,	//sMessageFailure,    //string sMessageFailure = ""
        FALSE,              //int iTouchAttackType = FALSE
        oWeapon,      //object oRightHandOverride = OBJECT_INVALID,
        oWeapon,      //object oLeftHandOverride = OBJECT_INVALID,
        1                  // offhand attack 
        );        
}

// motu99: This is only for test purposes (in order to test PerformAttackRound())
void DoOffhandAttackRound(object oPC = OBJECT_SELF)
{
 //    object oTarget = GetAttackTarget(); 
	object oTarget = GetAttemptedAttackTarget(); 

	// motu99: The following checks should be made by PerformAttack(), so they are somewhat redundant

   //no point attacking plot
    if(GetPlotFlag(oTarget))
        return;

	// if not melee fighting, abort
	if (!GetIsObjectValid(oTarget))
		return;

/*
	//if not fighting, abort 
	if(!GetIsFighting(oPC))
	{
		DoDebug(COLOR_WHITE + "DoOffhandAttack(): not fighting any more - aborting");
		return;
	}
*/

    string sMessageSuccess;
    string sMessageFailure;
	if (DEBUG)
	{
//		sMessageSuccess += GetName(oWeapon);
		//add attack
//		sMessageSuccess += " scripted offhand";
		//copy it to failure
//		sMessageFailure = sMessageSuccess;
		//add hit/miss
		sMessageSuccess += "s hit";
		sMessageFailure += "s miss";
		//add stars around messages
		sMessageSuccess = "*"+sMessageSuccess+"*";
		sMessageFailure = "*"+sMessageFailure+"*";
	}
    
    //null effect
    effect eInvalid;

	DoDebug(COLOR_WHITE + "initiating an overflow offhand attack round");  	

	PerformAttackRound(oTarget, // object oDefender
		oPC, // object oAttacker,
		eInvalid, // effect eSpecialEffect,
		0.0, // float eDuration = 0.0,
		0, // int iAttackBonusMod = 0,
		0, // int iDamageModifier = 0,
		0, //    int iDamageType = 0,
		0, // int bEffectAllAttacks = FALSE,
		sMessageSuccess, // string sMessageSuccess = "",
		sMessageFailure, // string sMessageFailure = "",
		0, // int bApplyTouchToAll = FALSE,
		0, // int iTouchAttackType = FALSE,
		0 //int bInstantAttack = FALSE);
		);	
}

void DoOverflowOnhandAttack(int nAttackMod)
{
    object oPC = OBJECT_SELF;
 	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    //if weapon is not valid, abort    
    if(!GetIsObjectValid(oWeapon))
        return;

 //  	 object oTarget = GetAttackTarget(); 
    object oTarget = GetAttemptedAttackTarget(); 

	// motu99: The following checks should be made by PerformAttack(), so they are somewhat redundant

   //no point attacking plot
    if(GetPlotFlag(oTarget))
        return;

	// if not melee fighting, abort
	if (!GetIsObjectValid(oTarget))
		return;
/*
	//if not fighting, abort 
	if(!GetIsFighting(oPC))
	{
		DoDebug(COLOR_WHITE + "DoOverflowOnhandAttack(): not fighting any more - aborting");
		return;
	}
*/

	string sMessageSuccess;
    string sMessageFailure;
	if (DEBUG)
	{
		sMessageSuccess += GetName(oWeapon);
		//add attack
		sMessageSuccess += " scripted overflow";
		//copy it to failure
		sMessageFailure = sMessageSuccess;
		//add hit/miss
		sMessageSuccess += " hit";
		sMessageFailure += " miss";
		//add stars around messages
		sMessageSuccess = "*"+sMessageSuccess+"*";
		sMessageFailure = "*"+sMessageFailure+"*";
	}
    
    //null effect
    effect eInvalid;

    if (DEBUG) DoDebug(COLOR_WHITE+"initiating an overflow onhand attack with "+GetName(oWeapon)+" and attack mod "+IntToString(nAttackMod));     

    PerformAttack(oTarget, 
        oPC,                //
        eInvalid,           //effect eSpecialEffect,
        0.0,                //float eDuration = 0.0
        nAttackMod,         //int iAttackBonusMod = 0
        0,  		       //int iDamageModifier = 0
        DAMAGE_TYPE_SLASHING,    //int iDamageType = DAMAGE_TYPE_SLASHING, otherwise it uses magical damage.
        sMessageSuccess,//sMessageSuccess,    //string sMessageSuccess = ""   
        sMessageFailure,//sMessageFailure,    //string sMessageFailure = ""
        FALSE,              //int iTouchAttackType = FALSE
        oWeapon,            //object oRightHandOverride = OBJECT_INVALID,
        OBJECT_INVALID,      //object oLeftHandOverride = OBJECT_INVALID
		0
        );        
}

void DoNaturalWeaponHB(object oPC = OBJECT_SELF)
{
	if (DEBUG) DoDebug("entered DoNaturalWeaponHB");

    //not in combat, abort
	if (!GetIsInCombat(oPC))
		return;
		
    float fDelay = 0.5 + IntToFloat(Random(10))/10.0;

    //no natural weapons, abort
    //in a different form, abort for now fix it later   
    if(array_exists(oPC, ARRAY_NAT_SEC_WEAP_RESREF)
        && !GetIsPolyMorphedOrShifted(oPC))
    {   
// DoDebug("DoNaturalWeaponHB: creature has natural secondary weapons");
	    UpdateSecondaryWeaponSizes(oPC);
        int i;
        while(i<array_get_size(oPC, ARRAY_NAT_SEC_WEAP_RESREF))
        {
            //get the resref to use
            string sResRef = array_get_string(oPC, ARRAY_NAT_SEC_WEAP_RESREF, i);
            //if null, move to next
            if(sResRef != "")
            {
                //get the created item
                object oWeapon = GetObjectByTag(sResRef);
                if(!GetIsObjectValid(oWeapon))
                {
                    object oLimbo = GetObjectByTag("HEARTOFCHAOS");
                    location lLimbo = GetLocation(oLimbo);
                    if(!GetIsObjectValid(oLimbo))
                        lLimbo = GetStartingLocation();
                    oWeapon = CreateObject(OBJECT_TYPE_ITEM, sResRef, lLimbo);
                }

// DoDebug(COLOR_WHITE + "DoNaturalWeaponHB: scheduling a secondary natural attack with "+GetName(oWeapon)+" at delay "+FloatToString(fDelay)); 
				//do the attack within a delay
/*				
// motu99: commented this out; AssignCommand ist not needed, because OBJECT_SELF is oPC - using AssignCommand will only degrade performance
				AssignCommand(oPC, 
					DelayCommand(fDelay,
						DoNaturalAttack(oWeapon)));
*/
				
				DelayCommand(fDelay, DoNaturalAttack(oWeapon));

				//calculate the delay to use next time
				fDelay += 2.05;
				if(fDelay > 6.0)
					fDelay -= 6.0;
			}
			i++;
		}
	}

	int iMod = 5;   // motu99: added check for monk weapon
	if (GetHasMonkWeaponEquipped(oPC)) iMod = 3;

	// check for overflow (main hand) attacks
    int nOverflowAttackCount = GetLocalInt(oPC, "OverflowBaseAttackCount");
    if(nOverflowAttackCount)
    {
        int i;
		// the first overflow attack would be the seventh main hand attack, at an AB of -30
        int nAttackPenalty = -6*iMod; // -30 for normal bab, -18 for monks
// DoDebug("DoNaturalWeaponHB(): number of scripted overflow attacks: "+IntToString(nOverflowAttackCount));
        for(i=0;i<nOverflowAttackCount;i++)
        {
// DoDebug(COLOR_WHITE + "DoNaturalWeaponHB(): scheduling a scripted overflow attack with attack mod "+IntToString(nAttackPenalty)+" at delay "+FloatToString(fDelay)); 
/*
// motu99: see comment above why this is commented out
			AssignCommand(oPC, 
				DelayCommand(fDelay,
					DoOverflowOnhandAttack(nAttackPenalty)));
*/
			DelayCommand(fDelay, DoOverflowOnhandAttack(nAttackPenalty));

            //calculate the delay to use
            fDelay += 2.05;
            if(fDelay > 6.0)
                fDelay -= 6.0;        
            //calculate new attack penalty   
            nAttackPenalty -= iMod; // motu99: usually -5, for monks -3 (unarmed or kama)
        }    
    }
	

// motu99: this is only here for debugging in order to  test PerformAttackRound()
// must be deleted after debugging!!!
//if (GetPRCSwitch(PRC_PNP_TRUESEEING)) DelayCommand(0.01, DoOffhandAttackRound());


	// check for overflow offhand attacks
    int nOffhandAttackCount = GetLocalInt(oPC, "OffhandOverflowAttackCount");
	if (DEBUG) DoDebug("DoNaturalWeaponHB: number of scripted offhand attacks = "+IntToString(nOffhandAttackCount));
    if(nOffhandAttackCount)
    {
		int i;
		int nAttackPenalty = -2*iMod;  // offhand attacks always come at -5 per additional attack (but for monks we assume -3) 
		for(i=0;i<nOffhandAttackCount;i++)
		{
// DoDebug(COLOR_WHITE + "DoNaturalWeaponHB(): scheduling a scripted offhand attack with attack mod "+IntToString(nAttackPenalty)+" at delay "+FloatToString(fDelay)); 

			DelayCommand(fDelay, DoOffhandAttack(nAttackPenalty));

			//calculate the delay to use
			fDelay += 2.05;
			if(fDelay > 6.0)
				fDelay -= 6.0;        
            //calculate new attack penalty   
			nAttackPenalty -= iMod;
		}
	}
}

string GetAffixForSize(int nSize)
{
    string sResRef;
    switch(nSize)
    {
        case CREATURE_SIZE_FINE:        sResRef += "f"; break;
        case CREATURE_SIZE_DIMINUTIVE:  sResRef += "d"; break;
        case CREATURE_SIZE_SMALL:       sResRef += "s"; break;
        case CREATURE_SIZE_MEDIUM:      sResRef += "m"; break;
        case CREATURE_SIZE_LARGE:       sResRef += "l"; break;
        case CREATURE_SIZE_HUGE:        sResRef += "h"; break;
        case CREATURE_SIZE_GARGANTUAN:  sResRef += "g"; break;
        case CREATURE_SIZE_COLOSSAL:    sResRef += "c"; break;
        default:                        sResRef += "l"; break;
    }   
    return sResRef;        
}

void EquipNaturalWeaponCheck(object oPC, object oItem)
{
    if(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC) != oItem)
        MyDestroyObject(oItem);
    else 
        DelayCommand(10.0, 
            EquipNaturalWeaponCheck(oPC, oItem));
}

object EquipNaturalWeapon(object oPC, string sResRef)
{
    object oObject = CreateItemOnObject(sResRef, oPC);
    SetIdentified(oObject, TRUE);
    ForceEquip(oPC, oObject, INVENTORY_SLOT_CWEAPON_L);
    AssignCommand(oPC, 
        DelayCommand(10.0, 
            EquipNaturalWeaponCheck(oPC, oObject)));
    return oObject;
}

void UpdateNaturalWeaponSizes(object oPC)
{
    int nSize = PRCGetCreatureSize(oPC);
    int nLastSize = GetLocalInt(oPC, "NaturalWeaponCreatureSize");
    if(nSize == nLastSize)
        return; 
    SetLocalInt(oPC, "NaturalWeaponCreatureSize", nSize);
    string sCurrent = "_"+GetAffixForSize(nSize);
    //secondary
    UpdateSecondaryWeaponSizes(oPC);
    //primary
    int i;
    for(i=0; i<array_get_size(oPC, ARRAY_NAT_PRI_WEAP_RESREF); i++)
    {
        string sTest = array_get_string(oPC, ARRAY_NAT_PRI_WEAP_RESREF, i);
        string sTestSize = GetStringRight(sTest, 2);
        if(sTestSize != sCurrent
            && GetStringLeft(sTestSize, 1) == "_")
        {
            array_set_string(oPC, ARRAY_NAT_PRI_WEAP_RESREF, i, 
                GetStringLeft(sTest, GetStringLength(sTest)-2)+sCurrent);
        }
    }    
    //equiped
    if(GetIsUsingPrimaryNaturalWeapons(oPC))
    {
        object oObject = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
        string sTest = GetResRef(oObject);
        string sTestSize = GetStringRight(sTest, 2);
        if(sTestSize != sCurrent
            && GetStringLeft(sTestSize, 1) == "_")
        {
            DestroyObject(oObject);
            string sNewResRef = GetStringLeft(sTest, GetStringLength(sTest)-2)+sCurrent;
            EquipNaturalWeapon(oPC, sNewResRef);            
        }
    }
}

void UpdateSecondaryWeaponSizes(object oPC)
{
    int nSize = PRCGetCreatureSize(oPC);
    int nLastSize = GetLocalInt(oPC, "NaturalWeaponCreatureSize");
    if(nSize == nLastSize)
        return; 
    SetLocalInt(oPC, "NaturalWeaponCreatureSize", nSize);
    string sCurrent = "_"+GetAffixForSize(nSize);
    int i;
    for(i=0; i<array_get_size(oPC, ARRAY_NAT_SEC_WEAP_RESREF); i++)
    {
        string sTest = array_get_string(oPC, ARRAY_NAT_SEC_WEAP_RESREF, i);
        string sTestSize = GetStringRight(sTest, 2);
        if(sTestSize != sCurrent
            && GetStringLeft(sTestSize, 1) == "_")
        {
            array_set_string(oPC, ARRAY_NAT_SEC_WEAP_RESREF, i, 
                GetStringLeft(sTest, GetStringLength(sTest)-2)+sCurrent);
        }
    }    
}

void AddNaturalSecondaryWeapon(object oPC, string sResRef, int nCount = 1)
{
    if(!array_exists(oPC, ARRAY_NAT_SEC_WEAP_RESREF))
        array_create(oPC, ARRAY_NAT_SEC_WEAP_RESREF);
    //check if it was already added
    int i;
    for(i=0;i<array_get_size(oPC, ARRAY_NAT_SEC_WEAP_RESREF);i++)
    {
        string sTest = array_get_string(oPC, ARRAY_NAT_SEC_WEAP_RESREF, i);
        if(sTest == sResRef)
            return;
    }
    //add it/them
    for(i=0;i<nCount;i++)
    {
        array_set_string(oPC, ARRAY_NAT_SEC_WEAP_RESREF,
            array_get_size(oPC, ARRAY_NAT_SEC_WEAP_RESREF), sResRef);
    }       
}

void RemoveNaturalSecondaryWeapons(object oPC, string sResRef)
{
    if(!array_exists(oPC, ARRAY_NAT_SEC_WEAP_RESREF))
        array_create(oPC, ARRAY_NAT_SEC_WEAP_RESREF);
    //check if it was already added
    int i;
    for(i=0; i<array_get_size(oPC, ARRAY_NAT_SEC_WEAP_RESREF); i++)
    {
        string sTest = array_get_string(oPC, ARRAY_NAT_SEC_WEAP_RESREF, i);
        if(sTest == sResRef)
            array_set_string(oPC, ARRAY_NAT_SEC_WEAP_RESREF, i, "");            
    }    
}

void NaturalSecondaryWeaponTempCheck(object oManifester, object oTarget, int nSpellID, 
    int nBeatsRemaining, string sResRef)
{
    if(!((nBeatsRemaining-- == 0)                                         || // Has the power ended since the last beat, or does the duration run out now
         GZGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester)  || // Has the power been dispelled
         GetHasEffect(EFFECT_TYPE_POLYMORPH, oTarget)                        // Has the target been polymorphed
         )
       )
    {
        // Schedule next HB
        DelayCommand(6.0f, NaturalSecondaryWeaponTempCheck(oManifester, oTarget, nSpellID, nBeatsRemaining, sResRef));
    }
    // Power expired
    else
    {
        if(DEBUG) DoDebug(sResRef+": Power expired, exiting HB");
        RemoveSpellEffects(nSpellID, oManifester, oTarget);
        RemoveNaturalSecondaryWeapons(oTarget, sResRef);
    }
}

void ClearNaturalWeapons(object oPC)
{
    array_delete(oPC, ARRAY_NAT_SEC_WEAP_RESREF);
    array_delete(oPC, ARRAY_NAT_PRI_WEAP_RESREF);
    array_delete(oPC, ARRAY_NAT_PRI_WEAP_ATTACKS);
}

void AddNaturalPrimaryWeapon(object oPC, string sResRef, int nCount = 1, int nForceUse = FALSE)
{
    int nFirstNaturalWeapon = FALSE;
    if(!array_exists(oPC, ARRAY_NAT_PRI_WEAP_RESREF))
    {
        array_create(oPC, ARRAY_NAT_PRI_WEAP_RESREF);
        nFirstNaturalWeapon = TRUE;
    }    
    if(!array_exists(oPC, ARRAY_NAT_PRI_WEAP_ATTACKS))
        array_create(oPC, ARRAY_NAT_PRI_WEAP_ATTACKS);
    //check if it was already added
    int i;
    for(i=0;i<array_get_size(oPC, ARRAY_NAT_PRI_WEAP_RESREF);i++)
    {
        string sTest = array_get_string(oPC, ARRAY_NAT_PRI_WEAP_RESREF, i);
        if(sTest == sResRef)
            return;
    }
    //add it/them
    array_set_string(oPC, ARRAY_NAT_PRI_WEAP_RESREF,
        array_get_size(oPC, ARRAY_NAT_PRI_WEAP_RESREF), sResRef);
    array_set_int(oPC, ARRAY_NAT_PRI_WEAP_ATTACKS,
        array_get_size(oPC, ARRAY_NAT_PRI_WEAP_ATTACKS), nCount);
    //if this is the first natural weapon, use it    
    if((nFirstNaturalWeapon 
             && !GetLevelByClass(CLASS_TYPE_MONK)
             && !GetLevelByClass(CLASS_TYPE_BRAWLER))
        || nForceUse)
        SetPrimaryNaturalWeapon(oPC, 0);
}

void RemoveNaturalPrimaryWeapon(object oPC, string sResRef)
{
    if(!array_exists(oPC, ARRAY_NAT_PRI_WEAP_RESREF))
        array_create(oPC, ARRAY_NAT_PRI_WEAP_RESREF);
    if(!array_exists(oPC, ARRAY_NAT_PRI_WEAP_ATTACKS))
        array_create(oPC, ARRAY_NAT_PRI_WEAP_ATTACKS);
    int nPos;
    for(nPos = 0; nPos < array_get_size(oPC, ARRAY_NAT_PRI_WEAP_RESREF); nPos++)
    {
        string sTempResRef = array_get_string(oPC, ARRAY_NAT_PRI_WEAP_RESREF, nPos);
        if(sResRef == sTempResRef)
            break;
    }
    if(nPos < array_get_size(oPC, ARRAY_NAT_PRI_WEAP_RESREF))
    {
        array_set_string(oPC, ARRAY_NAT_PRI_WEAP_RESREF,
            array_get_size(oPC, ARRAY_NAT_PRI_WEAP_RESREF), "");
        array_set_int(oPC, ARRAY_NAT_PRI_WEAP_ATTACKS,
            array_get_size(oPC, ARRAY_NAT_PRI_WEAP_ATTACKS), 0);           
    }   
}

int GetIsUsingPrimaryNaturalWeapons(object oPC)
{
    //check a creature weapon exists
    object oObject = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
    if(!GetIsObjectValid(oObject))
        return FALSE;
    //check your hand is empty    
    oObject = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if(GetIsObjectValid(oObject))
        return FALSE;        
    //check if the local was set
    return GetLocalInt(oPC, NATURAL_WEAPON_ATTACK_COUNT);
    /*
    string sResRef = GetResRef(oObject);
    int i;
    for(i=0;i<array_get_size(oPC, ARRAY_NAT_PRI_WEAP_RESREF);i++)
    {
        string sTest = array_get_string(oPC, ARRAY_NAT_PRI_WEAP_RESREF, i);
        if(sTest == sResRef)
            return TRUE;            
    }    
    return FALSE;
    */
}

void SetPrimaryNaturalWeapon(object oPC, int nIndex)
{
    if(!array_exists(oPC, ARRAY_NAT_PRI_WEAP_RESREF))
        array_create(oPC, ARRAY_NAT_PRI_WEAP_RESREF);
    if(!array_exists(oPC, ARRAY_NAT_PRI_WEAP_ATTACKS))
        array_create(oPC, ARRAY_NAT_PRI_WEAP_ATTACKS);
    if(nIndex == -1)
    {
        //remove natural weapons
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC));
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC));
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC));
        DeleteLocalInt(oPC, NATURAL_WEAPON_ATTACK_COUNT);
        return;
    }
    string sResRef = array_get_string(oPC, ARRAY_NAT_PRI_WEAP_RESREF, nIndex);
    if(sResRef == "")
        return;
    object oNaturalWeapon = EquipNaturalWeapon(oPC, sResRef);
    int nAttackCount = array_get_int(oPC, ARRAY_NAT_PRI_WEAP_ATTACKS, nIndex);
    //set the number of attacks correctly
    //note this function does set the number, not BAB
    //note this function does work on PCs, despite the description
    //dont set it directly, instead set the local which is checked in prc_bab_caller
    SetLocalInt(oPC, NATURAL_WEAPON_ATTACK_COUNT, 1);
    
    //rather than using SetBaseAttackBonus, use an effect instead
    //this makes it all at full AB without the -5 a time penalty
    if(nAttackCount > 1)
    {
        //get the object thats going to apply the effect
        //this strips previous effects too
        object oWP = GetObjectToApplyNewEffect("WP_PrimaryNaturalWeapEffect", oPC, TRUE);
        AssignCommand(oWP, 
            ActionDoCommand(
                ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                    SupernaturalEffect(
                        EffectModifyAttacks(nAttackCount-1)),
                    oPC)));  
    }                
}

int GetPrimaryNaturalWeaponCount(object oPC)
{
    return array_get_size(oPC, ARRAY_NAT_PRI_WEAP_RESREF);
}


void NaturalPrimaryWeaponTempCheck(object oManifester, object oTarget, int nSpellID, 
    int nBeatsRemaining, string sResRef)
{
    if(!((nBeatsRemaining-- == 0)                                         || // Has the power ended since the last beat, or does the duration run out now
         GZGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester)  || // Has the power been dispelled
         GetHasEffect(EFFECT_TYPE_POLYMORPH, oTarget)                        // Has the target been polymorphed
         )
       )
    {
        // Schedule next HB
        DelayCommand(6.0f, NaturalPrimaryWeaponTempCheck(oManifester, oTarget, nSpellID, nBeatsRemaining, sResRef));
    }
    // Power expired
    else
    {
        if(DEBUG) DoDebug(sResRef+": Power expired, exiting HB");
        RemoveSpellEffects(nSpellID, oManifester, oTarget);
        RemoveNaturalPrimaryWeapon(oTarget, sResRef);
    }
}