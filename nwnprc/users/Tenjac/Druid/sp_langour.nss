///////////////////////////////////////////////////////
//
//
///////////////////////////////////////////////////////
/** @file Languor
Transmutation
Level: Druid 4
Components: V, S
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Effect: Ray
Duration: 1 round/level
Saving Throw: Will partial
Spell Resistance: Yes

With a low thrumming sound, a blue beam lances from your finger
to strike your foe and weaken him. You must succeed on a ranged 
touch attack with the ray to strike a target. This ray causes 
creatures it hits to become weak and slow for the spell’s
duration. A struck creature takes a penalty to Strength
equal to 1d6+1 per two caster levels (maximum 1d6+10). In addition,
a subject that fails a Will save is slowed. The spell’s slow effect
counters and is countered by haste. 

*/
////////////////////////////////////////////////////////////
// Tenjac  10/2/07
////////////////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nTouch = PRCDoRangedTouchAttack(oTarget);
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nMetaMagic = PRCGetMetaMagicFeat();
        float fDur = RoundsToSeconds(nCasterLvl);
        
        if (nMetaMagic == METAMAGIC_EXTEND) fDur += fDur;
        
        //VFX
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_SILENT_COLD, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f); 
        PlaySound("sff_gasnatr");
        
        if(nTouch)
        {
                if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
                {
                        int nSave = PRCMySavingThrow(SAVING_THROW_WILL, oTarget, SPGetSaveDC(oTarget, oPC), SAVING_THROW_TYPE_SPELL);
                        int nDam = d6(1);
                        
                        if(nMetaMagic == METAMAGIC_MAXIMIZE) nDam = 6;
                        
                        //Bonus
                        nDam += (nCasterLvl/2);
                        
                        if(nMetaMagic == METAMAGIC_EMPOWER) nDam += (nDam/2);
                        
                        if(nSave) nDam = (nDam/2);                        
                        
                        else SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSlow(), oTarget, fDur, TRUE, SPELL_LANGOUR, nCasterLvl);                                
                        
                        //Strength damage
                        ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, nDam, DURATION_TYPE_TEMPORARY, TRUE, -1.0);
                }
        }
        
        PRCSetSchool();
}
                        

        
        