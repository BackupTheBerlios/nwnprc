/*
   ----------------
   Charm Person
   
   prc_psi_charmper
   ----------------

   21/10/04 by Stratovarius

   Class: Psion (Telepath)
   Power Level: 1
   Range: Short
   Target: One Humanoid
   Duration: 1 Hour/Level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 1
   
   You charm the spells target, as per charm person. 
   
   Augment: If you augment this power 1 time, this power also affects Animal, Fey, Giant, Magical Beast
   or Monstrous Humanoid. If you augment this power 3 times, this power also affects Aberration, Dragon, Outsider
   and Elementals. If you augment this power 5 times, duration increases to 1 day/level. It costs 2 power 
   points to augment once, 6 to augment 3 times, and 10 to augment 5 times. For every 2 power points spent
   this way, the DC increases by 1.
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
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	int nRacial = MyPRCGetRacialType(oTarget);
	int nTargetRace = FALSE;
	float fDuration = HoursToSeconds(nCaster);
	
	if (nMetaPsi == 2)	fDuration *= 2;
	
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
	if	(nAugment >= 3 && (nRacial == RACIAL_TYPE_ABERRATION) ||
		(nRacial == RACIAL_TYPE_DRAGON) ||
		(nRacial == RACIAL_TYPE_OUTSIDER) ||
		(nRacial == RACIAL_TYPE_ELEMENTAL))
	{
		nTargetRace = TRUE;
	}
	
	//Augmentation effects to Damage
	if (nAugment > 0)	nDC += nAugment;
	
	// Duration boost
	if (nAugment >= 5)	fDuration = HoursToSeconds((nCaster * 24));
	
	if (nTargetRace)
	{
		effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
		effect eCharm = EffectCharmed();
		eCharm = GetScaledEffect(eCharm, oTarget);
		effect eLink = EffectLinkEffects(eMind, eCharm);
		
		
		//Check for Power Resistance
		if (PRCMyResistPower(oCaster, oTarget, nPen))
		{
		
		    //Fire cast spell at event for the specified target
        	    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        	    
        	        //Make a saving throw check
        	        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
        	        {
        		        //Apply VFX Impact and daze effect
        	                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration,TRUE,-1,nCaster);
        	        }
		}
	}
    }
}