//::///////////////////////////////////////////////
//:: Name      Wave of Exhaustion
//:: FileName  sp_wave_exhst.nss
//:://////////////////////////////////////////////
/**@file Waves of Exhaustion
Necromancy
Level: Sor/Wiz 7 
Components: V, S 
Casting Time: 1 standard action 
Range: 60 ft. 
Area: Cone-shaped burst 
Duration: Instantaneous 
Saving Throw: No 
Spell Resistance: Yes

Waves of negative energy cause all living creatures
in the spell’s area to become exhausted. This spell
has no effect on a creature that is already exhausted.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        SPSetSchool(SPELL_SCHOOL_NECROMANCY);
        
        object oPC = OBJECT_SELF;
        location lLoc = GetSpellTargetLocation();
        object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 18.29f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
        int nCasterLevel = PRCGetCasterLevel(oPC);
        int nPenetr = nCasterLevel + SPGetPenetr();
        
        while(GetIsObjectValid(oTarget))
        {
                if(!MyPRCResistSpell(OBJECT_SELF, oTarget, nPenetr))
                {
                        effect eSpeed = EffectMovementSpeedDecrease(50);
                        effect eLink = EffectLinkEffects(EffectAbilityDecrease(ABILITY_STRENGTH, 6), EffectAbilityDecrease(ABILITY_DEXTERITY, 6));
                               eLink = EffectLinkEffects(eLink, eSpeed);
                        
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(8));
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
                        
                        if(GetIsPC(oTarget))
                        {
                                SendMessageToPC(oTarget, "You are exhausted. You need to rest.");
                        }
                }
                oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 18.29f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
        }
        SPSetSchool();
}