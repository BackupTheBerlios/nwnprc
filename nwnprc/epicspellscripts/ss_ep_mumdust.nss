//::///////////////////////////////////////////////
//:: Mummy Dust
//:: X2_S2_MumDust
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Summons a strong warrior mummy for you to
     command.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 07, 2003
//:://////////////////////////////////////////////
/*
    Altered by Boneshank, for purposes of the Epic Spellcasting project.
*/

#include "x2_inc_spellhook"
#include "inc_epicspells"
void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, MUMDUST_DC, MUMDUST_S, MUMDUST_XP))
    {
        effect eSummon;
        eSummon = EffectSummonCreature("X2_S_MUMMYWARR",496,1.0f);
        eSummon = ExtraordinaryEffect(eSummon);
        //Apply the summon visual and summon the undead.
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummon, GetSpellTargetLocation());
    }
}


