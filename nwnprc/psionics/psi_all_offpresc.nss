/*
   ----------------
   Offensive Prescience
   
   prc_all_offpresc
   ----------------

   31/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   Your awareness extends a fraction of a second into the future, allowing you to 
   better aim blows against an opponent. You gain a +2 bonus to your damage.
   
   Augment: For every 3 additional power points you spend, the bonus improves by 1.
*/

#include "prc_inc_psifunc"
#include "prc_inc_psionic"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

    object oCaster = OBJECT_SELF;
    int nAugCost = 3;
    int nAugment = GetLocalInt(oCaster, "Augment");
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
    	int CasterLvl = GetManifesterLevel(oCaster);
    	int nBonus = 2;


    	// Augmentation effects to armour class
	if (nAugment > 0)	nBonus += nAugment;
	
    	effect eDamage = EffectDamageIncrease(nBonus, DAMAGE_TYPE_MAGICAL);
   	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	effect eLink = EffectLinkEffects(eDamage, eDur);

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, (60.0 * CasterLvl),TRUE,-1,CasterLvl);
    }
}