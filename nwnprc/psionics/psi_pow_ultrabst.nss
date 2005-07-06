/*
   ----------------
   Ultrablast
   
   prc_pow_ultrabst
   ----------------

   25/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 7
   Range: 15
   Area: 15 ft burst centered on caster
   Duration: Instantaneous
   Saving Throw: Will half.
   Power Resistance: Yes
   Power Point Cost: 13
   
   You grumble psychically, then release a horrid shriek from your subconcious that disrupts the brains of all enemies in the power's
   area, dealing 13d6 to each enemy.
   
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
    object oTarget = OBJECT_SELF;
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, METAPSIONIC_EMPOWER, 0, METAPSIONIC_MAXIMIZE, 0, METAPSIONIC_TWIN, METAPSIONIC_WIDEN);
    
    if (nSurge > 0)
    {
        
        PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
    int nDC = GetManifesterDC(oCaster);
    int nCaster = GetManifesterLevel(oCaster);
    int nPen = GetPsiPenetration(oCaster);
    location lTarget = GetSpellTargetLocation();
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    int nDice = 13;
    int nDiceSize = 6;
    float fWidth = DoWiden(15.0, nMetaPsi);
    
        float fDelay;
        
    if (nSurge > 0) nAugment += nSurge;
    
    //Augmentation effects to Damage
    if (nAugment > 0) 
    {
        nDice += nAugment;
    }
    
        effect eFNF = EffectVisualEffect(VFX_FNF_HOWL_MIND);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fWidth, GetLocation(OBJECT_SELF));
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            if (PRCMyResistPower(oCaster, oTarget, nPen))
            {
                if (nAugment > 0) nDice += nAugment;
                int nDamage = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster, TRUE);
                    nDamage += nDice;

                if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    nDamage /= 2;
                }       
                effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);                   
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fWidth, GetLocation(OBJECT_SELF));
    }
    }
}