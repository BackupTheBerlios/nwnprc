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
#include "prc_spell_const"

//Pseudo-heartbeat function for abil damage
void DoCurseDam (object oTarget, object oPC, int nMetaMagic)
{
	int nDam = d6(1);
	//Check if spell was Maximized
	if(nMetaMagic == METAMAGIC_MAXIMIZE)
	{
		nDam = 6;
	}
	//Check if spell was Empowered
	if (nMetaMagic == METAMAGIC_EMPOWER)
	{	
		nDam += (nDam / 2);
	}
	
	//Ability damage
	ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam, DURATION_TYPE_PERMANENT, FALSE, 0.0f, FALSE, SPELL_ROTTING_CURSE_OF_URFESTRA, -1, oPC);
	
	//Delay 1 hour, then hit the poor bastard again.
	DelayCommand(3600.0f, DoCurseDam(oTarget, oPC, nMetaMagic));
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
        
        SPRaiseSpellCastAt(oTarget, TRUE, SPELL_ROTTING_CURSE_OF_URFESTRA, oPC);
			
	//Spell Resistance
	if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
	{
		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget,oPC)))
		{
			DoCurseDam(oTarget, oPC, nMetaMagic);				
		}
	}
	
	//Corrupt spell cost
	int nCorrupt = d6(1);
		
	DoCorruptionCost(oPC, ABILITY_STRENGTH, nCorrupt, 0);	
	
	//Alignment shift if switch set
	SPEvilShift(oPC);
		
	SPSetSchool();
}

	
			
		