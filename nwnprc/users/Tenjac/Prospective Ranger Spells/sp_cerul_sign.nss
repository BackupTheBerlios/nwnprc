//::///////////////////////////////////////////////
//:: Name      Invoke The Cerulean Sign
//:: FileName  sp_cerul_sign.nss
//:://////////////////////////////////////////////
/**@file Invoke The Cerulean Sign
Evocation
Level: Bard 3, cleric 3, druid 2, paladin 3, ranger 2, sorc/wiz 3
Components: S
Casting Time: 1 standard action
Range: 30 ft.
Area: Multiple aberrations whose combined total Hit Dice do
not exceed twice caster level in a spread emanating from the
character to the extreme of the range
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: No

The cerulean sign is an ancient symbol said to embody the purity
of the natural world, and as such it is anathema to aberrations.
While druids and rangers are the classes most often known
to cast this ancient spell, its magic is nearly universal and can
be mastered by all spellcasting classes.

When you cast this spell, you trace the cerulean sign in the air
with a hand, leaving a glowing blue rune in the air for a brief
moment before it flashes and fills the area of effect with a pulse
of cerulean light. Any aberration within the area must make
a Fortitude saving throw or suffer the following ill effects.
Closer aberrations are affected first.

Aberration Hit Dice Effect
Up to caster level +10 None
Up to caster level +5 Sickened
Up to caster level Nauseated
Up to caster level -5 Dazed
Up to caster level -10 Stunned

Each effect lasts for 1 round.

None: The aberration suffers no ill effect, even if it fails the
saving throw.

Sickened: The aberration takes a -2 penalty on attack rolls,
saving throws, skill checks, and ability checks for 1 round.

Nauseated: The aberration cannot attack, cast spells, concentrate
on spells, or do anything but take a single move action
for 1 round.

Dazed: The aberration can take no actions, but has no penalty
to its Armor Class, for 1 round.

Stunned: The aberration drops everything held, can’t take
actions, takes a -2 penalty to AC, and loses its Dexterity bonus
to AC (if any) for 1 round.

Once a creature recovers from an effect, it moves up one
level on the table. Thus, a creature that is stunned by this
spell is dazed the round after that, nauseated the round after
that, sickened the round after that, and then recovers fully
the next round.

Author:    Tenjac
Created:   8/8/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        SPSetSchool(SPELL_SCHOOL_EVOCATION);
        
        object oPC = OBJECT_SELF;
        location lLoc = GetLocation(oPC);
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0f), lLoc, TRUE, OBJECT_TYPE_CREATURE);
        int nDC;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        effect eStun = EffectStunned();
        effect eDaze = EffectLinkEffects(EffectDazed(), EffectCutsceneImmobilize());
        effect eNaus = EffectDazed();
        effect eSick = EffectAttackDecrease(2, ATTACK_BONUS_MISC);
        eSick = EffectLinkEffects(eSick, EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
        eSick = EffectLinkEffects(eSick, EffectSkillDecrease(SKILL_ALL_SKILLS, 2));
        
        int nCasterHD = GetHitDice(oPC);
        int nTargetHD;
        int nTotalHDToBeAffected = nCasterLvl * 2;
        int nDiff;
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD), oPC);
        
        while(GetIsObjectValid(oTarget) && nTotalHDToBeAffected > 0)
        {
                if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_ABERRATION)
                {
                        nTargetHD = GetHitDice(oTarget);
                        if(nTargetHD < nTotalHDToBeAffected)
                        {
                                nDC = SPGetSpellSaveDC(oTarget, oPC);
                                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                                {
                                        nDiff = nCasterHD - nTargetHD;
                                        
                                        if(nDiff > 5)
                                        {
                                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(1));
                                                DelayCommand(RoundsToSeconds(1), SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, RoundsToSeconds(1));
                                                DelayCommand(RoundsToSeconds(2), SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNaus, oTarget, RoundsToSeconds(1));
                                                DelayCommand(RoundsToSeconds(3), SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSick, oTarget, RoundsToSeconds(1));
                                        }
                                        
                                        else if((nDiff > 0) && (nDiff < 6))
                                        {
                                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, RoundsToSeconds(1));
                                                DelayCommand(RoundsToSeconds(1), SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNaus, oTarget, RoundsToSeconds(1));
                                                DelayCommand(RoundsToSeconds(2), SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSick, oTarget, RoundsToSeconds(1));
                                        }
                                        
                                        else if((nDiff > -5) && (nDiff < 1))
                                        {
                                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNaus, oTarget, RoundsToSeconds(1));
                                                DelayCommand(RoundsToSeconds(1), SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSick, oTarget, RoundsToSeconds(1));
                                        }
                                        
                                        else if((nDiff > -10) && (nDiff < -4))
                                        {
                                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSick, oTarget, RoundsToSeconds(1));
                                        }
                                        
                                        else ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), oTarget, 0.1f);
                                        
                                        //Decrement the HD to be affected
                                        nTotalHDToBeAffected = nTotalHDToBeAffected - nTargetHD;
                                }
                        }
                }
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0f), lLoc, TRUE, OBJECT_TYPE_CREATURE);
        }
        SPSetSchool();
}
                                