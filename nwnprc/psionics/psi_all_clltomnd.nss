/*
   ----------------
   Call to Mind
   
   prc_all_clltomnd
   ----------------

   22/10/04 by Stratovarius

   Class: Psion / Wilder
   Power Level: 1
   Range: Short
   Target: Self
   Duration: 2 Rounds
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   When you manifest this power, you gain a bonus to lore equal to 4 + caster level.
*/

#include "prc_inc_psifunc"
#include "prc_inc_psionic"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

    object oCaster = OBJECT_SELF;
    
    if (GetCanManifest(oCaster, 0)) 
    {
    	int CasterLvl = GetManifesterLevel(oCaster);
    	int nBonus = 4 + CasterLvl;
    	effect eLore = EffectSkillIncrease(SKILL_LORE, nBonus);
    	effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	effect eLink = EffectLinkEffects(eVis, eDur);
    	eLink = EffectLinkEffects(eLink, eLore);

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(2),TRUE,-1,CasterLvl);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    }
}