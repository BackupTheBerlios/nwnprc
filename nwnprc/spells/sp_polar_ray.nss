/*
Polar Ray

Caster Level(s): Wizard / Sorcerer 8
Innate Level: 8
School: Evocation
Descriptor(s): Cold
Component(s): Verbal, Somatic
Range: Short
Area of Effect / Target: Single
Duration: Instant
Additional Counter Spells: 
Save: None
Spell Resistance: Yes

A blue-white ray of freezing air and ice springs from your hand. 
You must succeed on a ranged touch attack with the ray to deal 
damage to a target. The ray deals 1d6 points of cold damage per 
caster level (maximum 25d6).
*/

#include "spinc_common"
#include "prc_inc_sp_tch"

#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    int nDam = nCasterLevel;
    // 25d6 Max
    if (nDam > 25) nDam = 25;
    nDam = d6(nDam);
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eRay = EffectBeam(VFX_BEAM_COLD, OBJECT_SELF, BODY_NODE_HAND);
    
    nCasterLevel +=SPGetPenetr();

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_FROST));
        eRay = EffectBeam(VFX_BEAM_COLD, OBJECT_SELF, BODY_NODE_HAND);
        
        int iAttackRoll = PRCDoRangedTouchAttack(oTarget);;
        if(iAttackRoll > 0)
        {
            //Make SR Check
            if(!MyPRCResistSpell(OBJECT_SELF, oTarget,nCasterLevel))
            {
                 //Enter Metamagic conditions
                 if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                 {
                     nDam = 6 * nCasterLevel;//Damage is at max
                     // 25 * 6 = 150, so its the most the spell can do.
                     if (nDam > 150) nDam = 150;
                 }
                 if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                 {
                     nDam = nDam + nDam/2; //Damage/Healing is +50%
                 }
            
                 // perform ranged touch attack and apply sneak attack if any exists
                 int eDamageType = ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_COLD);
                 ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDam, eDamageType);
                 PRCBonusDamage(oTarget);
    
                 //Apply the VFX impact and damage effect
                 SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
             }
        }
    }
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school

}
