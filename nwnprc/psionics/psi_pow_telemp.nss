/*
   ----------------
   Telempathic Projection
   
   prc_all_telemp
   ----------------

   12/12/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Medium
   Target: One Creature
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You grant a +4 Perform and Persuade bonus to the affected creature.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

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
    
    if (GetCanManifest(oCaster, 0)) 
    {
    	object oTarget = GetSpellTargetObject();
    	int nCaster = GetManifesterLevel(oCaster);
    	
    	effect ePersuade = EffectSkillIncrease(SKILL_PERSUADE, 4);
    	effect ePerform = EffectSkillIncrease(SKILL_PERFORM, 4);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	effect eLink = EffectLinkEffects(ePerform, eDur);
    	eLink = EffectLinkEffects(eLink, ePersuade);
    	
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, (60.0 * nCaster),TRUE,-1,nCaster);
    }
}
