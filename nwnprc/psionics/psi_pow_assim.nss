/*
   ----------------
   Assimilate
   
   prc_pow_assim
   ----------------

   26/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 9
   Range: Touch
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: Fortitude half.
   Power Resistance: Yes
   Power Point Cost: 17
   
   Your pointing finger turns black as obsidian. A creature touched by you is partially assimilated into your form and takes
   20d6 points of damage. If the creature survives this damage, you gain half of the damage dealt as temporary hitpoints. If the 
   creature dies, you gain all of the damage dealt as temporary hitpoints, and +4 to all stats. All bonuses last for 1 hour.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

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
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, METAPSIONIC_EMPOWER, 0, METAPSIONIC_MAXIMIZE, 0, METAPSIONIC_TWIN, 0);

    if (nMetaPsi > 0)
    {
        int nDC = GetManifesterDC(oCaster);
        int nCaster = GetManifesterLevel(oCaster);
        int nPen = GetPsiPenetration(oCaster);
        effect eVis = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);
        effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR);
        int nDice = 20;
        int nDiceSize = 6;

        // Stat boosts
        effect eCha = EffectAbilityIncrease(ABILITY_CHARISMA, 4);
        effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 4);
        effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 4);
        effect eInt = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 4);
        effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
        effect eWis = EffectAbilityIncrease(ABILITY_WISDOM, 4);

        effect eLink = EffectLinkEffects(eCha, eCon);
        eLink = EffectLinkEffects(eLink, eDex);
        eLink = EffectLinkEffects(eLink, eInt);
        eLink = EffectLinkEffects(eLink, eStr);
        eLink = EffectLinkEffects(eLink, eWis);
        eLink = EffectLinkEffects(eLink, eDur);

        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        
        int nTouchAttack = TouchAttackMelee(oTarget);
    	if (nTouchAttack > 0)
    	{
            //Check for Power Resistance
            if (PRCMyResistPower(oCaster, oTarget, nPen))
            {
                int nDamage = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster, TRUE);
                nDamage += nDice;
    
                if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                {
                    nDamage /= 2;
                }
    
                effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    
                effect eHP = EffectTemporaryHitpoints(nDamage/2);
                if (GetIsDead(oTarget))
                {
                    eHP = EffectTemporaryHitpoints(nDamage);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(1),TRUE,-1,nCaster);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, HoursToSeconds(1),TRUE,-1,nCaster);
                }
                else 	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, HoursToSeconds(1),TRUE,-1,nCaster);
            }// end if - resist failed
        }// end if - touch attack succeeded
    }// end if - could manifest
}