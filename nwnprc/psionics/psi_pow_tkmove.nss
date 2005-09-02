/*
   ----------------
   Telekinetic Maneuver
   
   prc_pow_tkmove
   ----------------

   26/3/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 4
   Range: Medium
   Target: One Creature
   Duration: 1 Round/2 levels
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 7
   
   You mentally push your foe or his weapon, attempting to knock him down and disarm him. The DC of the discipline check
   to knock him down and disarm is your manifester level plus your intelligence modifier. The target gets a seperate check
   for knockdown and for disarm.
   
   Augment: For every 2 additional power points spent, the DC of the discipline check goes up by 1.
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
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, 0, 0);    
    
    if (nSurge > 0) PsychicEnervation(oCaster, nSurge);
    
    if (nMetaPsi > 0) 
    {
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	effect eKnock = EffectKnockdown();
	int nDur = nCaster/2;
	int nDC = nCaster + GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
		
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0) nDC += nAugment;
	
	SignalEvent(oTarget, EventSpellCastAt(oTarget, GetSpellId()));
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nPen))
	{
		if(!GetIsSkillSuccessful(oTarget, SKILL_DISCIPLINE, nDC))
		{
			AssignCommand(oTarget,ClearAllActions());
			AssignCommand(oTarget,ActionPutDownItem(oItem));
			FloatingTextStringOnCreature("*Target disarmed!*", OBJECT_SELF, FALSE);
   		}
	
		if(!GetIsSkillSuccessful(oTarget, SKILL_DISCIPLINE, nDC))
		{               	
	               	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
	        }               	
	}
    }
}