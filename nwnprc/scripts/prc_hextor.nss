//::///////////////////////////////////////////////
//:: Fist of Hextor
//:: prc_hextor.nss
//:://////////////////////////////////////////////
//:: Applies Fist of Hextor Bonuses
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: April 20, 2004
//:://////////////////////////////////////////////

#include "prc_inc_clsfunc"

void main()
{
        // Attack and damage added as effects by SPELL_HEXTOR_DAMAGE
        ActionCastSpellOnSelf(SPELL_HEXTOR_DAMAGE);    
}