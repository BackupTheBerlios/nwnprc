/*
   ----------------
   Energy Adaption
   
   prc_pow_enadapt
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
   
   When you manifest this power, you gain 10 resistance to acid, cold, electricity, fire and sonic damage.
   This increases to 20 at manifester level 9, and 30 at manifester level 13.
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
    	int nResist = 10;
    	float fDur = 600.0 * nCaster;
    	if (nMetaPsi == 2)	fDur *= 2;
    	
    	if (nCaster >= 13)	nResist = 30;
    	else if (nCaster >= 9)	nResist = 20;
    	
	effect eResistA = EffectDamageResistance(DAMAGE_TYPE_ACID, nResist);
	effect eResistC = EffectDamageResistance(DAMAGE_TYPE_COLD, nResist);
	effect eResistE = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResist);
	effect eResistF = EffectDamageResistance(DAMAGE_TYPE_FIRE, nResist);
	effect eResistS = EffectDamageResistance(DAMAGE_TYPE_SONIC, nResist);
	effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
	effect eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
    	effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	effect eLink = EffectLinkEffects(eResistA, eDur);
    	eLink = EffectLinkEffects(eLink, eResistC);
    	eLink = EffectLinkEffects(eLink, eResistE);
    	eLink = EffectLinkEffects(eLink, eResistF);
    	eLink = EffectLinkEffects(eLink, eResistS);
    	eLink = EffectLinkEffects(eLink, eDur2);

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,nCaster);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}
