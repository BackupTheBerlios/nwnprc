/*
    ----------------
    Recall Death
    
    psi_all_rcldeath
    ----------------

    28/10/04 by Stratovarius

    Class: Psion/Wilder
    Power Level: 8
    Range: Medium
    Target: One Creature
    Duration: Instantaneous
    Saving Throw: Will half
    Power Resistance: Yes
    Power Point Cost: 15
 
    The fabric of time parts to your will, revealing wounds the foe has recieved in the past.
    These wounds are potentially fatal. If the target succeeds on its throw, it takes 5d6 damage.
    If it fails, it dies.
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
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nDamage = d6(5);
	effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
    	effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
	object oTarget = GetSpellTargetObject();
	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nCaster))
	{
		
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		
                	if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_DEATH))
                	{
                		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                	}
                	else 
                	{
                		//Apply the VFX impact and effects
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                	}
	}

    
    }
}