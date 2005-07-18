/*
   ----------------
   Dissipating Touch
   
   prc_all_dsspttch
   ----------------

   27/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Touch
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 1
   
   Your mere touch can dispere the surface material of a foe, sending a tiny portion
   of it far away. This effect is disruptive; thus your melee touch attack deals 1d6 damage.
   
   Augment: For every additional power point spent, this power's damage increases by 1d6. 
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
    int nAugCost = 1;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, METAPSIONIC_EMPOWER, 0, METAPSIONIC_MAXIMIZE, 0, METAPSIONIC_TWIN, 0);
    
    if (nSurge > 0)
    {
        
        PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
    int nDC = GetManifesterDC(oCaster);
    int nCaster = GetManifesterLevel(oCaster);
    int nPen = GetPsiPenetration(oCaster);
    int nDice = 1;
    int nDiceSize = 6;
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
            
    if (nSurge > 0) nAugment += nSurge;
    
    //Augmentation effects to Damage
    if (nAugment > 0) nDice += nAugment;
    
    int nDamage = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster, TRUE);
    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
    
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    
    // Perform the Touch Attach
    int nTouchAttack = PRCDoMeleeTouchAttack(oTarget);;
    if (nTouchAttack > 0)
    {
        //Check for Power Resistance
        if (PRCMyResistPower(oCaster, oTarget, nPen))
        {       
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
    

    }
}