/*
   ----------------
   Thought Shield
   
   prc_all_tghtshld
   ----------------

   9/11/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 2
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   Your fortify your mind against intrusion, gaining 13 Power Resistance.
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
    	int nCaster = GetManifesterLevel(oCaster);
	
	//Massive effect linkage, go me
    	effect eSR = EffectSpellResistanceIncrease(13);
    	effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	effect eDur2 = EffectVisualEffect(249);
    	effect eLink = EffectLinkEffects(eSR, eDur);
    	eLink = EffectLinkEffects(eLink, eDur2);

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nCaster),TRUE,-1,nCaster);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    }
}