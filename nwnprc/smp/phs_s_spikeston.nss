/*:://////////////////////////////////////////////
//:: Spell Name Spike Stones
//:: Spell FileName PHS_S_SpikeSton
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation [Earth]
    Level: Drd 4, Earth 4
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Medium (20M)
    Area: 2M/level square, to a maximum of 20x20M at level 10
    Duration: 1 hour/level (D)
    Saving Throw: Reflex partial
    Spell Resistance: Yes

    Rocky ground, stone floors, and similar surfaces shape themselves into long,
    sharp points that blend into the background. Typically, this can only be cast
    indoors, in a naturally created underground area.

    Spike stones impede progress through an area and deal damage. Any creature
    moving on foot into or through the spell�s area moves at half speed.

    In addition, each creature moving through the area takes 1d8 points of
    piercing damage for each 1 meter of movement through the spiked area, done
    each round (a minimum of 1d8 is done as long as a creature moved).

    Any creature that takes damage from this spell must also succeed on a Reflex
    save or suffer injuries to its feet and legs that slow its land speed by
    one-half. This speed penalty lasts for 24 hours or until the injured creature
    receives a cure spell (which also restores lost hit points). Another
    character can remove the penalty by taking 10 minutes to dress the injuries
    and succeeding on a Heal check against the spell�s save DC.

    Spike growth can�t be disabled with the Disable Device skill, and it is
    automatically detected. Spike Growth can also be dispelled normally.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This copies a lot from Spike Growth.

    Won't overlap - one effect is one effect (uses the default set/remove
    system, but also see just below)

    A delayed integer setting is used to stop multiple heartbeats from running
    on the same person.

    Thier position is tracked, using SetLocation() mainly (which we can get
    position points from easily). Note, of course, area checks are in place,
    incase someone exits from the area and causes the On Exit to fire and
    complete the damage.

    The speed penalty is applied once, and so previous ones are removed (24
    hour duration).

    AOE is a minimum of 10Mx10M (level 5 druids get level 3 spells), up to 20x20
    (for a level 10 caster).

    Note: Default checks make this Exterior, Natural, Overground ONLY. There is
    an additional module setting "only let spike stones operate in these areas"
    and always a "never let this spell operate in this area" check too.

    This is because this affects plants, right? and spike stones does the same
    for rocks...woohoo...
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SPIKE_STONES)) return;

    // Get caster
    object oCaster = OBJECT_SELF;
    object oArea = GetArea(oCaster);

    // Force off toggle for this area
    if(GetLocalInt(oArea, "PHS_SETTING_NO_SPIKE_STONES") == TRUE) return;

    // Toggle for "only these areas"
    if(!PHS_SettingGetGlobal("PHS_GROWTH_SPELLS_ONLY_IN_SET_AREAS"))
    {
        // Else, Must be in a natural, underground, inside area
        if(GetIsAreaAboveGround(oArea) == TRUE ||
           GetIsAreaInterior(oArea) == FALSE ||
           GetIsAreaNatural(oArea) == AREA_ARTIFICIAL)
        {
            return;
        }
    }
    else if(!GetLocalInt(oArea, "PHS_SETTING_SPIKE_STONES_ON"))
    {
        // Stop
        return;
    }

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration - 1 hour/level (Note: Still dispellable)
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // 2M a side level, and we do the vfx_persistant.2da entries, of course,
    // starting at 10M, then 11, etc, up to 20.
    // we add 1 for level 6, and so on, up to level 10, which adds 5

    // Change caster level to be in limits
    int nAOECaster = PHS_LimitInteger(nCasterLevel - 5, 0, 5);

    // Add on, to the default one, 0 to 5.
    int nAOE = PHS_AOE_PER_SPIKE_STONES_10 + nAOECaster;

    // Declare effects
    effect eAOE = EffectAreaOfEffect(nAOE);

    // Apply effects
    PHS_ApplyLocationDuration(lTarget, eAOE, fDuration);
}
