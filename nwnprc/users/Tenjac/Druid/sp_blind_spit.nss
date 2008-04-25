////////////////////////////////////////////////////
//  Blinding Spittle
//  sp_blind_spit.nss
////////////////////////////////////////////////////
/** @file Blinding Spittle
Transmutation
Level: Druid 2
Components: V, S
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Effect: One missile of spit
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes

You spit caustic saliva into your target’s
eyes with a successful ranged touch
attack. A -4 penalty applies to the
attack roll. The subject is blinded until
it can wash its eyes with water or some
other rinsing fluid, which requires a
standard action.

This spell has no effect on creatures
without eyes or creatures that don’t
depend on eyes for vision.

*/
///////////////////////////////////////////////////
// Tenjac  10/1/07
///////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        
        //***Remember to add ability to give a modifier and default it to 0 ***        
        int nTouch = PRCDoRangedTouchAttack(oTarget, TRUE, oCaster, -4);
        
        if(nTouch)
        {
                //Must need eyes
                if(nType != RACIAL_TYPE_CONSTRUCT &&
                nType != RACIAL_TYPE_OOZE &&
                nType != RACIAL_TYPE_ELEMENTAL &&
                nType != RACIAL_TYPE_UNDEAD)
                {
                        if(!PRCDoResistSpell(oCaster, oTarget, nCasterLvl + SPGetPenetr()))
                        {
                                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectBlindness(), oTarget, TRUE, SPELL_BLINDING_SPITTLE, nCasterLvl);
                        }
                }
        }
        PRCSetSchool();
}