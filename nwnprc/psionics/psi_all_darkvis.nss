/*
   ----------------
   Darkvision
   
   prc_all_darkvis
   ----------------

   25/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: Psion/Wilder 3, Psychic Warrior 2
   Range: Personal
   Target: Caster
   Duration: 1 hour/level
   Saving Throw: None
   Power Resistance: None
   Power Point Cost: Psion/Wilder 5, Psychic Warrior 3
   
   You psionically enhance your eyes to gain the effects of darkvision.
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
	int nCaster = GetManifesterLevel(oCaster);
	
	effect eVis = EffectVisualEffect(VFX_DUR_ULTRAVISION);
	effect eVis2 = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eUltra = EffectUltravision();
	effect eLink = EffectLinkEffects(eVis, eDur);
	eLink = EffectLinkEffects(eLink, eVis2);
    	eLink = EffectLinkEffects(eLink, eUltra);
    	
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, HoursToSeconds(nCaster),TRUE,-1,nCaster);

    }
}