/*
   ----------------
   Compression
   
   psi_pow_compress
   ----------------

   4/12/05 by Stratovarius

   Class: Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   This power causes instant diminution, giving you the benefits of a small size. This grants you +2 Dexterity, -2 Strength, +1 
   to attack, and +1 Armour class.
   
   Augment: Augment this power 3 times and all numerical changes double (+4 dex, -4 str, and so on)
   	    Augment this power 4 times and the duration changes to 1 minute a level.
   
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
    int nAugCost = 2;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);    
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
    	// Amount to add/remove
    	int nBonus = 2;
    	// If he's compressed twice
    	if (nAugment >= 3) nBonus = 4;
    	
    	int nDur = nCaster;
    	if (nMetaPsi == 2)	nDur *= 2;
    	// If duration is increased
    	if (nAugment >= 4) nDur *= 10; // number of rounds in a minute
    	
    	effect eAC = EffectACIncrease(nBonus/2); //Half the str/dex bonus
    	effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, nBonus);
    	effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH, nBonus);
    	effect eAB = EffectAttackIncrease(nBonus/2);
        effect eVis = EffectVisualEffect(VFX_DUR_SANCTUARY);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	effect eLink = EffectLinkEffects(eVis, eDex);
        eLink = EffectLinkEffects(eLink, eDur);
        eLink = EffectLinkEffects(eLink, eAC);
        eLink = EffectLinkEffects(eLink, eStr);
        eLink = EffectLinkEffects(eLink, eAB);
    	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
    }
}