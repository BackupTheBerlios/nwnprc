//::///////////////////////////////////////////////
//:: [Knight of the Chalice Feats]
//:: [prc_knghtch.nss]
//:://////////////////////////////////////////////
//:: Check to see which Knight of the Chalice feats
//:: a creature has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Mar 17, 2004
//:://////////////////////////////////////////////

#include "prc_inc_clsfunc"

void main()
{
    // Everything is handled by the spell's script.
    ActionCastSpellOnSelf(2733); //prc_knight_dam.nss, Applies attack and damage bonus.
}
