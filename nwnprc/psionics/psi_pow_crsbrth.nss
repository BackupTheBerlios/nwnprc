/*
   ----------------
   Crisis of Breathe
   
   psi_pow_crsbrth
   ----------------

   19/4/05 by Stratovarius

   Class: Psion (Telepath)
   Power Level: 3
   Range: Medium
   Target: One Living Humanoid
   Duration: 1 Round/level
   Saving Throw: Will negates, Fort partial
   Power Resistance: Yes
   Power Point Cost: 5
   
   You compel the subject to purge its entire store of air in one explosive exhalation, and thereby disrupt the subject's autonomic
   breathing cycle. If the target succeeds on a Will save when target by this power, it is unaffected. Otherwise, it must succeed on
   a Fortitude save every round or black out. If the target succeeds on the Fortitude save, nothing happens. If it fails, it blacks
   out and falls down. For every round it fails the Fort save, the DC increases by 1. If it fails the Fort save for 3 consecutive 
   rounds, it dies from lack of air.
   
   Augment: If you augment this power 1 time, this power also affects Animal, Fey, Giant, Magical Beast
   or Monstrous Humanoid. If you augment this power 3 times, this power also affects Aberration, Dragon and Outsiders. 
   It costs 2 power points to augment once and 6 to augment 3 times. For every 2 power points spent this way, the DC increases by 1.   
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"
#include "prc_alterations"



void RunImpact(object oTarget, object oCaster, int nSpell, int nDC, int nRound)
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(nSpell,oTarget,oCaster))
    {
        return;
    }

    if (GetIsDead(oTarget) == FALSE)
    {
    	int nDCTemp = nDC;
    	if (nRound > 0) nDCTemp += nRound;
    
	if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDCTemp))
	{
		nRound += 1;
		effect eKnock = EffectKnockdown();
		effect ePara = EffectCutsceneParalyze();
		effect eLink = EffectLinkEffects(eKnock, ePara);
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,6.0,FALSE);
	}
	else //Made saving throw, reset round counter
	{
		nRound = 0;
	}
	// Run out of breath
	if (nRound >= 3)
	{
		effect eDeath = EffectDeath();
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
	}
		
        DelayCommand(6.0f,RunImpact(oTarget, oCaster, nSpell, nDC, nRound));
    }
}

int CheckRace(int nAugment, object oTarget, object oCaster)
{

	int nRacial = MyPRCGetRacialType(oTarget);
	int nTargetRace = FALSE;
	//Verify that the Racial Type is humanoid
	if((nRacial == RACIAL_TYPE_DWARF) || (nRacial == RACIAL_TYPE_ELF) || (nRacial == RACIAL_TYPE_GNOME) || (nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) || (nRacial == RACIAL_TYPE_HALFLING) || (nRacial == RACIAL_TYPE_HUMAN) || (nRacial == RACIAL_TYPE_HALFELF) || (nRacial == RACIAL_TYPE_HALFORC) || (nRacial == RACIAL_TYPE_HUMANOID_ORC) || (nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN))
        {
		nTargetRace = TRUE;
	}
	if (nAugment >= 1 || GetLevelByClass(CLASS_TYPE_THRALLHERD, OBJECT_SELF) >= 7)
	{
		if (nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS || nRacial == RACIAL_TYPE_FEY || nRacial == RACIAL_TYPE_GIANT || nRacial == RACIAL_TYPE_ANIMAL || nRacial == RACIAL_TYPE_MAGICAL_BEAST || nRacial == RACIAL_TYPE_BEAST)
		{
			nTargetRace = TRUE;
		}
	}
	if (nAugment >= 3 || GetLevelByClass(CLASS_TYPE_THRALLHERD, OBJECT_SELF) >= 9)
	{
		if (nRacial == RACIAL_TYPE_ABERRATION || nRacial == RACIAL_TYPE_DRAGON || nRacial == RACIAL_TYPE_OUTSIDER)
		{
			nTargetRace = TRUE;
		}
	}
	
	return nTargetRace;
}

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
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);    
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    	effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    	int nDur = nCaster;
    	int nRound = 0;
    	int nSpell = GetSpellId();
		
	int nTargetRace = CheckRace(nAugment, oTarget, oCaster);
		
	if (nTargetRace)
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		if(PRCMyResistPower(oCaster, oTarget, nPen))
		{
			if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
        	    	{
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oTarget,RoundsToSeconds(nDur),FALSE);
				RunImpact(oTarget, oCaster, nSpell, nDC, nRound);
			}
		}
		else
		{
			effect eSmoke = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT,eSmoke,oTarget);
		}
	}
    }
}