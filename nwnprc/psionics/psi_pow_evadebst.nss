/*
   ----------------
   Evade Burst
   
   prc_pow_evadebst
   ----------------

   22/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: Psion/Wilder 7, PsyWar 3
   Range: Personal
   Target: Self
   Duration: 1 Round/Level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: Psion/Wilder 13, PsyWar 5
   
   When you manifest this power, you gain the effect of evasion.
   
   Augment: If you spend 4 additional points, you gain improved evasion. Augmenting this power beyond level 1 does nothing.
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
    int nAugCost = 4;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, 0, 0);
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nFeat = IP_CONST_FEAT_EVASION;
	
	//Augmentation effects to Damage
	if (nAugment > 0) nFeat = IP_CONST_FEAT_IMPEVASION;
	
    	int CasterLvl = GetManifesterLevel(oCaster);
    	object oSkin = GetPCSkin(oCaster);
	AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyBonusFeat(nFeat), oSkin,RoundsToSeconds(nCaster));
    }
}