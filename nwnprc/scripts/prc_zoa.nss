#include "prc_alterations"

void main()
{
    ActionDoCommand(SetLocalInt(OBJECT_SELF, "UsingZoneOfAnimation", TRUE));
    ActionCastSpell(SPELLABILITY_TURN_UNDEAD);
    ActionDoCommand(DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD));
    ActionDoCommand(DeleteLocalInt(OBJECT_SELF, "UsingZoneOfAnimation"));
}