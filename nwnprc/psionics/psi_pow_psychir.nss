/*
   ----------------
   Psychic Chirurgery
   
   prc_psi_psychir
   ----------------

   11/5/05 by Stratovarius

   Class: Psion (Telepath)
   Power Level: 9
   Range: Close
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 17
   
   The target has all negative effects removed from it, including level drain and ability damage.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

// return TRUE if the effect created by a supernatural force and can't be dispelled by spells
int GetIsSupernaturalCurse(effect eEff);

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 1);

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
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, 0, 0);
    
    if (nMetaPsi) 
    {
	int nCaster = GetManifesterLevel(oCaster);
	effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER);
	effect eBad = GetFirstEffect(oTarget);
    	//Search for negative effects
    	while(GetIsEffectValid(eBad))
    	{
    		if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
    		GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
    		GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
    		GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
    		GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
    		GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
    		GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
    		GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
    		GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
    		GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
    		GetEffectType(eBad) == EFFECT_TYPE_CURSE ||
    		GetEffectType(eBad) == EFFECT_TYPE_DISEASE ||
    		GetEffectType(eBad) == EFFECT_TYPE_POISON ||
    		GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
    		GetEffectType(eBad) == EFFECT_TYPE_CHARMED ||
    		GetEffectType(eBad) == EFFECT_TYPE_DOMINATED ||
    		GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
    		GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
    		GetEffectType(eBad) == EFFECT_TYPE_FRIGHTENED ||
    		GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL ||
    		GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
    		GetEffectType(eBad) == EFFECT_TYPE_SLOW ||
    		GetEffectType(eBad) == EFFECT_TYPE_STUNNED)
    		{
    			//Remove effect if it is negative.
        		if(!GetIsSupernaturalCurse(eBad))
        			RemoveEffect(oTarget, eBad);
        	}
        	eBad = GetNextEffect(oTarget);
    	}
    	//Fire cast spell at event for the specified target
    	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_RESTORATION, FALSE));

    	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
    	SetLocalInt(oTarget, "WasRestored", TRUE);
    	DelayCommand(HoursToSeconds(1), DeleteLocalInt(oTarget, "WasRestored"));
     }
}

int GetIsSupernaturalCurse(effect eEff)
{
    object oCreator = GetEffectCreator(eEff);
    if(GetTag(oCreator) == "q6e_ShaorisFellTemple")
        return TRUE;
    return FALSE;
}