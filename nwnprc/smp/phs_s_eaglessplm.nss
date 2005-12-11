/*:://////////////////////////////////////////////
//:: Spell Name Eagle�s Splendor, Mass
//:: Spell FileName PHS_S_EaglesSplM
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Brd 6, Clr 6, Sor/Wiz 6
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One creature/level, within a 5M radius sphere
    Duration: 1 min./level
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes

    The transmuted creatures becomes more poised, articulate, and personally
    forceful. The spell grants a +4 enhancement bonus to Charisma, adding the
    usual benefits to Charisma-based skill checks and other uses of the
    Charisma modifier. Sorcerers and bards (and other spellcasters who rely on
    Charisma) affected by this spell do not gain any additional bonus spells
    for the increased Charisma, but the save DCs for spells they cast while
    under this spell�s effect do increase.

    Arcane Material Component: A few feathers or a pinch of droppings from an
    eagle.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    +4 In the stat, Doesn't stack with normal, and can affect up to 1 target/
    level. Friends only targeted.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_BULLS_STRENGTH_MASS)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCnt, nFriend;
    // Ability to use
    int nAbility = ABILITY_CHARISMA;

    // Duration - 1 minute/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Delcare Effects
    effect eAbility = EffectAbilityIncrease(nAbility, 4);
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eAbility, eCessate);

    // Loop all allies in a huge sphere
    nCnt = 1;
    oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
    // 1 target/level, nearest to location within a 5.0M radius
    while(GetIsObjectValid(oTarget) && nFriend < nCasterLevel &&
          GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) <= 5.0)
    {
        // Friendly check
        if(oTarget == OBJECT_SELF ||
           GetIsFriend(oTarget) ||
           GetFactionEqual(oTarget))
        {
            // Make sure they are not immune to spells
            if(!PHS_TotalSpellImmunity(oTarget))
            {
                // Check if oTarget has better effects already
                if(PHS_GetHasAbilityBonusOfPower(oTarget, nAbility, 4) != 2)
                {
                    // Add one to counter
                    nFriend++;

                    // Signal the spell cast at event
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_BULLS_STRENGTH_MASS, FALSE);

                    // Remove these abilities effects
                    PHS_RemoveAnyAbilityBonuses(oTarget, nAbility);

                    //Apply effects and VFX to target
                    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
                }
            }
        }
        // Get next target
        oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
    }
}
