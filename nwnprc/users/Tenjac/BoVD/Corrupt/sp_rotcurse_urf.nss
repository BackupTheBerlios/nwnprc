//::///////////////////////////////////////////////
//:: Name: Rotting Curse of Urfestra
//:: Filename: sp_rotcurse_urf.nss
//::///////////////////////////////////////////////
/**@file Rotting Curse of Urfestra
Transmutation [Evil]
Level: Corrupt 3
Components: V, S, Corrupt
Casting Time: 1 action
Range: Touch
Target: Living creature touched
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

The subject's flesh and bones begin to rot. The subject
takes 1d6 points of Constitution damage immediately, 
and a further 1d6 points of Constitution damage 
every hour until the subject dies or the curse is 
removed with a wish, miracle, or remove curse spell.

Corruption Cost: 1d6 points of Strength damage.
    
@author Written By: Tenjac
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"
#include "inc_abil_damage"
#include "prc_inc_spells"

//Pseudo-heartbeat function for abil damage
void DoCurseDam (object oTarget)
{
	if(GetPersistantLocalInt(oTarget, "HAS_CURSE"))
	{
		
		int nDam = d6(1);
		//Check if spell was Maximized
		if GetLocalInt (oPC, "MMMaximize")
		{
			nDam = 6;
		}
		//Check if spell was Empowered
		if GetLocalInt (oPC, "MMEmpower")
		{
			nDam += (nDam / 2);
		}
		
		//Ability damage
		ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam, DURATION_TYPE_PERMANENT, FALSE, 0.0f, FALSE, SPELL_ROTTING_CURSE, -1, oPC);
		
		//Delay 1 hour, then hit the poor bastard again.
		DelayCommand(3600.0f, DoCurseDam(oTarget));
	}
}


void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	//define vars
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel();
	int nMetaMagic = PRCGetMetaMagicFeat();
        int nPenetr = nCasterLvl + SPGetPenetr();
	
	if(nMetaMagic == METAMAGIC_MAXIMIZE)
	{
		SetLocalInt (oPC, "MMMaximize", 1)
	}
		
	if (nMetaMagic == METAMAGIC_EMPOWER)
	{
		SetLocalInt (oPC, "MMEmpower", 1)
	}
	
	//Spell Resistance
	if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
	{
		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget,oPC)))
		{
			DoCurseDam(oTarget);
				
		}
	}
	
	//Corruption Cost paid when effect ends if not cast on item
	if(GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
	{
		//Corrupt spell cost
		int nCorrupt = d6(1);
		
		ApplyAbilityDamage(oPC, ABILITY_STRENGTH, nCorrupt, DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE, SPELL_ROTTING_CURSE, -1, oPC);
	}
	
	//Alignment shift if switch set
	SPEvilShift();
		
	SPSetSchool();
}

	
			
		