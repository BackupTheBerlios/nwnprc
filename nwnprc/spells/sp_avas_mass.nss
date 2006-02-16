//::///////////////////////////////////////////////
//:: Name     Avascular Mass
//:: FileName   sp_avas_mass.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*Avascular Mass
  Necromancy [Death, Evil]
  Sorc/Wizard 8
  Range: Close
  Saving Throw: Fortitude partial and Reflex negates
  Spell Resistance: yes

  You shoot a ray of necromantic energy from your outstretched 
  hand, causing any living creature struck by the ray to violently 
  purge blood vessels through its skin. You must succeed 
  on a ranged touch attack to affect the subject. If successful, the 
  subject is reduced to half of its current hit points (rounded down) 
  and stunned for 1 round. On a successful Fortitude saving throw the 
  subject is not stunned.
  
  Also, the purged blood vessels are magically animated, creating a many
  layered mass of magically strong, adhesive tissue that traps those caught
  in it... Creatures caught within a 20 foot radius become entangled unless 
  the succeed on a Reflex save. The original target of the spell is automatically 
  entangled.

  The entangled creature takes a -2 penalty on attack rolls, -4 to effective Dex, 
  and can't move. An entangled character that attempts to cast a spell must succeed 
  in a concentration check. Because the avascular mass is magically animate, and 
  gradually tightens on those it holds, the Concentration check DC is 30...Once loose,
  a creature may progress through the writhing blood vessels very slowly.  

  Spell is modeled after Entanglement, using three seperate scripts.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 10/05/05
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "x2_inc_spellhook"
#include "spinc_common"
#include "prc_misc_const"

void main()
{
	
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
	
	/*
	Spellcast Hook Code
	Added 2003-06-20 by Georg
	If you want to make changes to all spells,
	check x2_inc_spellhook.nss to find out more
	*/
	
	if (!X2PreSpellCastCode())
	{
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
		return;
	}
	// End of Spell Cast Hook
	
	object oTarget = GetSpellTargetObject();
	object oPC = OBJECT_SELF;
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	int nHP = GetCurrentHitPoints(oTarget);
	int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
	effect eHold = EffectEntangle();
	effect eSlow = EffectSlow();
	
	SPRaiseSpellCastAt(oTarget, TRUE, SPELL_AVASCULAR_MASS, oPC);
	
	// Gotta be a living critter
	    int nType = MyPRCGetRacialType(oTarget);
	    if ((nType == RACIAL_TYPE_CONSTRUCT) ||
	        (nType == RACIAL_TYPE_UNDEAD) ||
	        (nType == RACIAL_TYPE_ELEMENTAL))
	        {
			return;
		}
	
	{
		//VFX for spell when finished, commented out until done
		
		//Define AoE VFX
		//effect eMass = EffectVisualEffect(VFX_DUR_AVASMASS);
		
		//Define VFX tangling the feet of targets
		//effect eFeet = EffectVisualEffect(VFX_DUR_AMFOOTTANGLE);
		
		//Define VFX connecting entangled victims
		//effect eConnect = EffectVisualEffect(VFX_DUR_AMSTRAND);
		
		//Link the VFX part of Entangling 
		
		//effect eTangleLink = EffectLinkEffects(eConnect, eFeet);
		
		//Link eTangleLink and Hold effects
		//effect eLink = EffectLinkEffects(eHold, eTangleLink);
	}
	
	//temporary VFX
	
	effect eLink = EffectVisualEffect(VFX_DUR_ENTANGLE);
	
	//damage rounds up
	int nDam = (nHP - (nHP / 2));
	effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
	
	
	//Blood gush
	effect eBlood = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED);
	
	//Make touch attack
	int nTouch = PRCDoRangedTouchAttack(oTarget);
	
	// Do attack beam VFX. Ornedan is my hero. 
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_EVIL, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f); 
	
	if (nTouch)
	{	
		//Spell Resistance
		if (!MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
		{
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eBlood, oTarget);
			
			
			//Apply AoE writing blood vessel VFX centered on oTarget
			//ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eMass, lLocation, fDuration);
			
			//Orignial target automatically entangled
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2),FALSE);
			
			//Fortitude Save for Stun
			if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
			{
				effect eStun = EffectStunned();
				effect eStunVis = EffectVisualEffect(VFX_IMP_STUN);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eStunVis, oTarget);
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(1));
			}
			
			//Declare major variables for Mass including Area of Effect Object
			effect eAOE = EffectAreaOfEffect(VFX_PER_AVASMASS);
			location lTarget = PRCGetSpellTargetLocation();
			
			int nDuration = 3 + PRCGetCasterLevel(OBJECT_SELF) / 2;
			int nMetaMagic = PRCGetMetaMagicFeat();
			
			//Make sure duration does not equal 0
			if(nDuration < 1)
			{
				nDuration = 1;
			}
			//Check Extend metamagic feat
			if(CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
			{
				nDuration = nDuration * 2;    //Duration is +100%
			}
			
			
			//Create an instance of the AOE Object using the Apply Effect function
			ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
			DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
			// Getting rid of the local integer storing the spellschool name
		}
	}
	SPEvilShift(oPC);
}


