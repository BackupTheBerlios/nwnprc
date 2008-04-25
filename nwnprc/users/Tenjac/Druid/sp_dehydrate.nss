///////////////////////////////////////////////////////////////////
// Dehydrate
// sp_dehydrate.nss
///////////////////////////////////////////////////////////////////
/** @file Dehydrate
Necromancy
Level: Druid 3
Components: V, S, DF
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Target: One living creature
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

You afflict the target with a horrible, desiccating curse
that deals 1d6 points of Constitution damage, plus 1 additional
point of Constitution damage per three caster levels, to a maximum of
1d6+5 at 15th level. Oozes, plants,and creatures with the aquatic
subtype are more susceptible to this spell than other targets.
Such creatures take 1d8 points of Constitution damage, plus 1
additional point of Constitution damage per three caster levels, to
a maximum of 1d8+5.
*/
/////////////////////////////////////////////////////////////////////
// Tenjac   10/1/07
/////////////////////////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nDC = PRCGetSaveDC(oTarget, oPC);
        int nDam = d6();
        int nMetaMagic = PRCGetMetaMagicFeat();
        
        if(nMetaMagic == METAMAGIC_MAXIMIZE)
        {
                nDam = 6;
        }
        
        if(nCasterLvl > 2) nDam++;        
        if(nCasterLvl > 5) nDam++;        
        if(nCasterLvl > 8) nDam++;        
        if(nCasterLvl >11) nDam++;
        if(nCasterLvl >14) nDam++;
        
        if(nMetaMagic == METAMAGIC_EMPOWER)
        {
                nDam += (nDam/2);
        }
        
        if(!PRCDoResistSpell(oTarget, oPC, nCasterLvl + SPGetPenetr()))
        {
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                {
                        //VFX
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
                        
                        ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, DURATION_TYPE_TEMPORARY, TRUE, -1.0, FALSE, -1, -1, OBJECT_SELF_;
                }
        }        
        PRCSetSchool();
}
        
                