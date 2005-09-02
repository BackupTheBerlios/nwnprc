/*
   ----------------
   Distract
   
   prc_all_distract
   ----------------

   25/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Short
   Target: One Creature
   Duration: 1 Min/level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 1
   
   You cause your subjects mind to wander, applying a -4 penalty to Spot, Search, and Listen.
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
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	float fDur = 60.0 * nCaster;
	if (nMetaPsi == 2)	fDur *= 2;
	
	effect eSpot = EffectSkillDecrease(SKILL_SPOT, 4);
	effect eSearch = EffectSkillDecrease(SKILL_SEARCH, 4);
	effect eListen = EffectSkillDecrease(SKILL_LISTEN, 4);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink = EffectLinkEffects(eSpot, eDur);
	eLink = EffectLinkEffects(eSearch, eLink);
	eLink = EffectLinkEffects(eListen, eLink);
	effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
		
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nPen))
	{
		
	    //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            
                //Make a saving throw check
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                        //Apply VFX Impact and daze effect
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,nCaster);
               		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
	}
    }
}