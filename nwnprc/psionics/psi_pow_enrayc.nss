/*
   ----------------
   Energy Ray Cold
   
   prc_all_enrayc
   ----------------

   30/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Short
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 1
   
   You create a ray of energy of the chosen type that shoots forth from your finger tips,
   doing 1d6+1 cold damage on a successful ranged touch attack.
   
   Augment: For every additional power point spent, this power's damage increases by 1d6+1. 
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
    int nAugCost = 1;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	object oTarget = GetSpellTargetObject();
	effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
	effect eRay = EffectBeam(VFX_BEAM_COLD, OBJECT_SELF, BODY_NODE_HAND);
	int nDice = 1;
	int nDiceSize = 6;
		
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0) nDice += nAugment;
	int nDamage = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster);
	nDamage += nDice;
	
	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	
	// Perform the Touch Attach
	int nTouchAttack = TouchAttackRanged(oTarget);
	if (nTouchAttack > 0)
	{
		//Check for Power Resistance
		if (PRCMyResistPower(oCaster, oTarget, nPen))
		{
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);
		}
	}
    }
}