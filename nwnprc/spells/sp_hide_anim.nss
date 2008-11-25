//::///////////////////////////////////////////////
//:: Name      Hide from Animals
//:: FileName  sp_hide_anim.nss
//:://////////////////////////////////////////////
/** @file Hide from Animals
Abjuration
Level: Drd 1, Rgr 1, Justice of Weald and Woe 1
Components: S, DF
Casting Time: 1 standard action
Range: Touch
Targets: One creature touched/level
Duration: 10 min./level (D)
Saving Throw: Will negates (harmless)
Spell Resistance: Yes

Animals cannot see, hear, or smell the
warded creatures. Even extraordinary or
supernatural sensory capabilities, such as
blindsense, blindsight, scent, and tremorsense,
cannot detect or locate warded creatures.
Animals simply act as though the
warded creatures are not there. Warded
creatures could stand before the hungriest
of lions and not be molested or even
noticed. If a warded character touches an
animal or attacks any creature, even with a
spell, the spell ends for all recipients.

Author:    Tenjac
Created:   8/14/08
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_ABJURATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur = (nCasterLvl * 600.0);
        
        effect eInvis = VersusRacialTypeEffect(EffectInvisibility(INVISIBILITY_TYPE_NORMAL), RACIAL_TYPE_ANIMAL);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, fDur);
        
        PRCSetSchool();
}