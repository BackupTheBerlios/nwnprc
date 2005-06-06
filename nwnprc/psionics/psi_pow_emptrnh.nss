/*
   ----------------
   Empathic Transfer, Hostile
   
   psi_pow_emptrnh
   ----------------

   19/4/05 by Stratovarius

   Class: Psion (Telepath)
   Power Level: 3
   Range: Touch
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: Will partial
   Power Resistance: Yes
   Power Point Cost: 5
   
   You transfer your hurt to another. When you manifest this power and make a successful touch attack, you transfer up to 50 points
   of damage from yourself to the touched creature. You regain hitpoints equal to the amount transferred. You cannot exceed your 
   maximum total hitpoints through use of this power. 
   
   Augment: For every additional power point spent, you can transfer an additional 10 points of damage (maximum of 90)
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
    object oTarget = GetSpellTargetObject();
    int nAugCost = 1;
    int nAugment = GetAugmentLevel(oCaster);
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, 0, 0);
   
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	int nCap = 50;
	int nMax = GetMaxHitPoints(oCaster);
	int nCur = GetCurrentHitPoints(oCaster);
	int nDamage = (nMax - nCur);
	
	//Augmentation effects to HD
	if (nAugment > 0) nCap += (nAugment * 10);
	// Max you can transfer
	if (nCap > 90) nCap = 90;
	// Cant exceed the max
	if (nDamage > nCap) nDamage = nCap;

        int nTouch = TouchAttackMelee(oTarget);
        if (nTouch > 0)
        {
		//Check for Power Resistance
		if (PRCMyResistPower(oCaster, oTarget, nPen))
		{
				
			//Fire cast spell at event for the specified target
        		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        	    
        		//Make a saving throw check
        		if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
        		{
				nDamage /= 2;	
			}
			effect eHeal = EffectHeal(nDamage);
			effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCaster);
		}
	}
    }
}