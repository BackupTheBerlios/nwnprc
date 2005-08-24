#include "prc_alterations"

void main()
{
    ActionDoCommand(SetLocalInt(OBJECT_SELF, "UsingSunDomain", TRUE));
    ActionCastSpell(SPELLABILITY_TURN_UNDEAD);
    ActionDoCommand(DecrementRemainingFeatUses(FEAT_TURN_UNDEAD));
    ActionDoCommand(DeleteLocalInt(OBJECT_SELF, "UsingSunDomain"));
}