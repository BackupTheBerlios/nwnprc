//::///////////////////////////////////////////////
//:: Speed of Thought onunequip script
//:: psi_spdfthgt_ueq
//:://////////////////////////////////////////////
/*
	Adds the Speed of Thought back to OBJECT_SELF,
	if they now have non-heavy armor and are
	still psionically focused.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 23.03.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"

void main()
{
    if(GetBaseAC(GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF)) < 6 &&
       GetIsPsionicallyFocused(OBJECT_SELF))
        AssignCommand(OBJECT_SELF, ActionCastSpellAtObject(SPELL_FEAT_SPEED_OF_THOUGHT_BONUS, OBJECT_SELF, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
}