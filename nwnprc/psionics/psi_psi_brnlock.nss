/*
   ----------------
   Brain Lock
   
   prc_psi_brnlock
   ----------------

   21/10/04 by Stratovarius

   Class: Psion (Telepath)
   Power Level: 2
   Range: Medium
   Target: One Humanoid
   Duration: 1 Round/Level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 3
   
   The subject's higher mind is locked away. He stands dazed, 
   unable to take any mental decisions at all.
   
   Augment: If you spend 2 additional power points, this power also affects Animal, Fey, Giant, Magical Beast
   or Monstrous Humanoid. If you spend 4 additional power points, this power also affects Aberration, Dragon, 
   Outsiders, and Elementals. Augmenting this power beyond level 2 will waste power points. 
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

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
    int nAugCost = 2;
    int nAugment = GetLocalInt(oCaster, "Augment");
    object oTarget = GetSpellTargetObject();
    
    if (GetCanManifest(oCaster, nAugCost, oTarget)) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nRacial = MyPRCGetRacialType(oTarget);
	int nTargetRace = FALSE;
	
	//Verify that the Racial Type is humanoid
	if  	((nRacial == RACIAL_TYPE_DWARF) ||
		(nRacial == RACIAL_TYPE_ELF) ||
		(nRacial == RACIAL_TYPE_GNOME) ||
		(nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) ||
		(nRacial == RACIAL_TYPE_HALFLING) ||
		(nRacial == RACIAL_TYPE_HUMAN) ||
		(nRacial == RACIAL_TYPE_HALFELF) ||
		(nRacial == RACIAL_TYPE_HALFORC) ||
		(nRacial == RACIAL_TYPE_HUMANOID_ORC) ||
		(nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN))
        {
		nTargetRace = TRUE;
	}
	if	(nAugment >= 1 && (nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS) ||
		(nRacial == RACIAL_TYPE_FEY) ||
		(nRacial == RACIAL_TYPE_GIANT) ||
		(nRacial == RACIAL_TYPE_ANIMAL) ||
		(nRacial == RACIAL_TYPE_MAGICAL_BEAST) ||
		(nRacial == RACIAL_TYPE_BEAST))
	{
		nTargetRace = TRUE;
	}
	if	(nAugment >= 2 && (nRacial == RACIAL_TYPE_ABERRATION) ||
		(nRacial == RACIAL_TYPE_DRAGON) ||
		(nRacial == RACIAL_TYPE_OUTSIDER) ||
		(nRacial == RACIAL_TYPE_ELEMENTAL))
	{
		nTargetRace = TRUE;
	}
	
	if (nTargetRace)
	{
		effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
		effect eDaze = EffectDazed();
		effect eLink = EffectLinkEffects(eMind, eDaze);
		
		//Check for Power Resistance
		if (PRCMyResistPower(oCaster, oTarget, nCaster))
		{
		
		    //Fire cast spell at event for the specified target
        	    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        	    
        	        //Make a saving throw check
        	        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
        	        {
        		        //Apply VFX Impact and daze effect
        	                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCaster),TRUE,-1,nCaster);
        	        }
		}
	}
    }
}