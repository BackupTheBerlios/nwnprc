//::///////////////////////////////////////////////
//:: Name      Repel Vermin
//:: FileName  sp_repel_vermin.nss
//:://////////////////////////////////////////////
/**@file Repel Vermin
Abjuration
Level: Brd 4, Clr 4, Drd 4, Rgr 3
Components: V, S, DF
Casting Time: 1 standard action
Range: 10 ft.
Area: 10-ft.-radius emanation centered on you
Duration: 10 min./level (D)
Saving Throw: None or Will negates; see text
Spell Resistance: Yes

An invisible barrier holds back vermin. A vermin 
with Hit Dice of less than one-third your level 
cannot penetrate the barrier. A vermin with Hit 
Dice of one-third your level or more can penetrate
the barrier if it succeeds on a Will save. Even so,
crossing the barrier deals the vermin 2d6 points 
of damage, and pressing against the barrier causes
pain, which deters most vermin.

**/

//////////////////////////////////////////////////
//:: Author: Tenjac
//:: Date:   No thanks, I'm married now
//////////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	
	object oPC = OBJECT_SELF;
	effect eAoE = EffectAreaOfEffect(AOE_PER_REPEL_VERMIN);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	float fDur = (600.0f * nCasterLvl);
	
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAoE, oPC, fDur);
	
	PRCSetSchool();
}