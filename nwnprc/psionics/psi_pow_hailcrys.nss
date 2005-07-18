/*
   ----------------
   Hail of Crystals
   
   prc_pow_hailcrys
   ----------------

   9/4/05 by Stratovarius

   Class: Psion (Shaper)
   Power Level: 5
   Range: Medium
   Target: 20' Burst
   Duration: Instantaneous
   Saving Throw: Reflex half
   Power Resistance: No
   Power Point Cost: 9
   
   An ectoplasmic crystal emanates from your outstretched hand and expands into a two foot ball as it hurtles towards the chosen target.
   You must make a ranged touch attack to strike the target of the spell, who takes 5d4 bludgeoning damage. All those who are in the
   area of effect take 9d4 slashing with a reflex save for half. 
   
   Augment: For every additional power point spent, all those in the area of effect take another 1d4. 
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"
#include "prc_inc_combat"

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
    int nAugCost = 1;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, METAPSIONIC_EMPOWER, 0, METAPSIONIC_MAXIMIZE, 0, METAPSIONIC_TWIN, METAPSIONIC_WIDEN);
    
    if (nMetaPsi > 0) 
    {
    int nDC = GetManifesterDC(oCaster);
    int nCaster = GetManifesterLevel(oCaster);
    int nPen = GetPsiPenetration(oCaster);
    int nDiceTarget = 5;
    int nDiceBurst = 5;
    int nDiceSize = 4;
    float fWidth = DoWiden(RADIUS_SIZE_LARGE, nMetaPsi);
    location lTarget = GetSpellTargetLocation();    
    effect eTarget = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
    int nDamage;
    
    //Augmentation effects to Damage
    if (nAugment > 0) nDiceBurst += nAugment;
    
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    
    // Perform the Touch Attach
    int nTouchAttack = PRCDoRangedTouchAttack(oTarget);;
    if (nTouchAttack > 0)
    {
        if (nTouchAttack == 2) nDiceTarget *= 2;
        nDamage = MetaPsionics(nDiceSize, nDiceTarget, nMetaPsi, oCaster, TRUE, oTarget, TRUE);
        effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eTarget, oTarget);
    }
    
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        //Cycle through the targets within the spell shape until an invalid object is captured.
        while(GetIsObjectValid(oTarget))
        {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

        nDamage = MetaPsionics(nDiceSize, nDiceBurst, nMetaPsi, oCaster, TRUE, oTarget, TRUE);              
                //Make a saving throw check
                if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                {
                    nDamage /= 2;
                }
        effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_SLASHING);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eTarget, oTarget);

        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }   
    

    }
}