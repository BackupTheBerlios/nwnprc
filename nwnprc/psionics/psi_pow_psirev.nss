/*
   ----------------
   Psionic Revivify
   
   prc_pow_psirev
   ----------------

   17/5/05 by Stratovarius

   Class: Psion (Egoist)
   Power Level: 5
   Range: Touch
   Target: One Dead Creature
   Duration: Instantaneous
   Saving Throw: No
   Power Resistance: No
   Power Point Cost: 9, XP
   
   Psionic Revivify lets a manifester reconnect a corpse with its body, restoring life to a recently deceased creature. This power
   functions like the raise dead spell, except that it costs the manifester 200 XP to manifest.
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
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	effect eRaise = EffectResurrection();
	effect eVis = EffectVisualEffect(VFX_IMP_RAISE_DEAD);

	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAISE_DEAD, FALSE));
	if(GetIsDead(oTarget))
	{
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eRaise, oTarget); 
		ExecuteScript("prc_pw_raisedead", OBJECT_SELF);

		if(GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oTarget))
			SetPersistantLocalInt(oTarget, "persist_dead", FALSE);    
			
	        int nXP = GetXP(oCaster);
	        nXP -= 200;
	        SetXP(oCaster,nXP);
	}
    }
}