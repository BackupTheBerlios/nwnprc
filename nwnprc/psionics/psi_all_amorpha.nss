/*
   ----------------
   Concealing Amorpha
   
   prc_all_amorpha
   ----------------

   22/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 2
   Range: Personal
   Target: Self
   Duration: 1 Minute/Level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   When you manifest this power, you weave a quasi-real membrane around yourself. 
   This distortion grants you 20% concealment.
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
    	effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
	effect eConceal = EffectConcealment(20);
	effect eDur = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
	effect eLink = EffectLinkEffects(eDur, eConceal);
	float fDuration = 60.0 * CasterLvl;

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration,TRUE,-1,CasterLvl);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    }
}