//::///////////////////////////////////////////////
//:: Name      Vile Death
//:: FileName  sp_vile_death.nss
//:://////////////////////////////////////////////
/** @file Vile Death
Conjuration (Calling) [Evil]
Level: Clr 9, Dn 7, Wiz 9
Components: V, S, M
Casting Time: 1 standard action
Range: Touch
Targets: One undead creature
Duration: Permanent

The target undead creature gains the Fiendish template.

Author:    Stratovarius
Created:   5/17/09
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_template"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur = (nCasterLvl * 600.0);
        int nMetaMagic = PRCGetMetaMagicFeat();
	if (nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur = (fDur * 2);
	}        
        if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
        	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_BLASPHEMY), oTarget);
        	ApplyTemplateToObject(TEMPLATE_FIENDISH, oTarget);
        }
        
        PRCSetSchool();
}