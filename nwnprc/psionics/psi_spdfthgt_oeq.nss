//::///////////////////////////////////////////////
//:: Speed of Thought onequip script
//:: psi_spdfthgt_oeq
//:://////////////////////////////////////////////
/*
	Removes the Speed of Thought bonus if
	OBJECT_SELF equipped heavy armor.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 23.03.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"

void main()
{
    if(GetBaseAC(GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF)) >= 6)
        RemoveSpellEffects(SPELL_FEAT_SPEED_OF_THOUGHT_BONUS, OBJECT_SELF, OBJECT_SELF);
}