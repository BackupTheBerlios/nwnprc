/*
   ----------------
   Power Leech
   
   prc_pow_pwrleech
   ----------------

   19/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 4
   Range: Short
   Target: One Psionic Creature
   Duration: 1 Round/Level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 7
   
   Your brow erupts with an arc of dark crackling energy that connects with your foe, draining it of 1d6
   power points and adding 1 point to your reserve. If the subject is drained of points, the power ends.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

void DoDrain(object oTarget, object oCaster, int nMetaPsi)
{
	int nTargetPP = GetLocalInt(oTarget, "PowerPoints");
	int nCasterPP = GetLocalInt(oCaster, "PowerPoints");
	effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
	int nDice = 1;
	int nDiceSize = 6;
	int nDrain = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster);
	effect eRay = EffectBeam(VFX_BEAM_MIND, OBJECT_SELF, BODY_NODE_HAND);
	
	nTargetPP -= nDrain;
	if (nTargetPP < 0)	nTargetPP = 0;
	SetLocalInt(oTarget, "PowerPoints", nTargetPP);
	SetLocalInt(oCaster, "PowerPoints", (nCasterPP + 1));
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);
	
	int nDur = GetLocalInt(oCaster, "PowerLeechDur");
	if (nDur > 0 && nTargetPP > 0)
	{
		SetLocalInt(oCaster, "PowerLeechDur", (nDur -1));
		DelayCommand(6.0, DoDrain(oTarget, oCaster, nMetaPsi));	
	}
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
    int nAugCost = 3;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, METAPSIONIC_EMPOWER, 0, METAPSIONIC_MAXIMIZE, 0, METAPSIONIC_TWIN, 0);
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
	int nTargetPP = GetLocalInt(oTarget, "PowerPoints");
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	int nDC = GetManifesterDC(oCaster);
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nPen))
	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            
                //Make a saving throw check
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                	SetLocalInt(oCaster, "PowerLeechDur", nCaster);
			if (nTargetPP > 0)	DoDrain(oTarget, oCaster, nMetaPsi);
                }
	}	
    }
}