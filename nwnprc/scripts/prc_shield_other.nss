/*
    prc_shield_other

    Shield Other
    Abjuration
    Level: Clr 2, Pal 2, Protection 2
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One creature
    Duration: 1 hour/level (D)
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    This spell wards the subject and creates a
    mystic connection between you and the
    subject so that some of its wounds are
    transferred to you. The subject gains a +1
    deflection bonus to AC and a +1 resistance
    bonus on saves. Additionally, the subject
    takes only half damage from all wounds
    and attacks (including that dealt by special
    abilities) that deal hit point damage. The
    amount of damage not taken by the
    warded creature is taken by you. Forms of
    harm that do not involve hit points, such
    as charm effects, temporary ability damage,
    level draining, and death effects, are not
    affected. If the subject suffers a reduction
    of hit points from a lowered Constitution
    score, the reduction is not split with you
    because it is not hit point damage. When
    the spell ends, subsequent damage is no
    longer divided between the subject and
    you, but damage already split is not
    reassigned to the subject.
    If you and the subject of the spell move
    out of range of each other, the spell ends.
    Focus: A pair of platinum rings (worth at
    least 50 gp each) worn by both you and the
    warded creature.

    By: Flaming_Sword
    Created: Oct 19, 2008
    Modified: Oct 22, 2008

*/
#include "prc_alterations"

void main()
{
    object oSelf = OBJECT_SELF;
    object oSucker = OBJECT_INVALID;     //the poor bastard who offered to take half my damage for me :D

    effect eSearch = GetFirstEffect(oSelf);

    int nDamage = GetTotalDamageDealt() / 2;
    if(DEBUG) DoDebug("prc_shield_other: nDamage = " + IntToString(nDamage));

    while(GetIsEffectValid(eSearch))
    {
        if(GetEffectSpellId(eSearch) == SPELL_SHIELD_OTHER)
        {
            oSucker = GetEffectCreator(eSearch);
            if(DEBUG) DoDebug("prc_shield_other: Found a sucker! (" + GetName(oSucker) + ")");
            break;
        }
        eSearch = GetNextEffect(oSelf);
    }

    if(GetIsObjectValid(oSucker))
    {
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nDamage), oSelf);
        //make the damager apply the damage to the sucker
        AssignCommand(GetLastDamager(), SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY), oSucker));
    }
}
