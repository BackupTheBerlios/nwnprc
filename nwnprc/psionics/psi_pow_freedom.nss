/*
   ----------------
   Freedom of Movement
   
   prc_pow_freedom
   ----------------

   19/2/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 4
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 7
   
   When you manifest this power, you may move as normal, even under the influence of magic
   that would normally impede movement.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nAugCost = 0;
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
    	float fDur = 600.0 * nCaster;
	if (nMetaPsi == 2)	fDur *= 2;     	
    	
    	effect eParal = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
    	effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
    	effect eSlow = EffectImmunity(IMMUNITY_TYPE_SLOW);
    	effect eMove = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);
    	effect eVis = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	
    	//Link effects
    	effect eLink = EffectLinkEffects(eParal, eEntangle);
    	eLink = EffectLinkEffects(eLink, eSlow);
    	eLink = EffectLinkEffects(eLink, eVis);
    	eLink = EffectLinkEffects(eLink, eDur);
    	eLink = EffectLinkEffects(eLink, eMove);
	
    	//Fire cast spell at event for the specified target
    	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	
    	//Search for and remove the above negative effects
    	effect eLook = GetFirstEffect(oTarget);
    	while(GetIsEffectValid(eLook))
    	{
    	    if(GetEffectType(eLook) == EFFECT_TYPE_PARALYZE ||
    	        GetEffectType(eLook) == EFFECT_TYPE_ENTANGLE ||
    	        GetEffectType(eLook) == EFFECT_TYPE_SLOW ||
    	        GetEffectType(eLook) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
    	    {
    	        RemoveEffect(oTarget, eLook);
    	    }
    	    eLook = GetNextEffect(oTarget);
    	}

        //Apply the VFX impact and effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,nCaster);
    }
}