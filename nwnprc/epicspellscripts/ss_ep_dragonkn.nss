//::///////////////////////////////////////////////
//:: Dragon Knight
//:: X2_S2_DragKnght
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Summons an adult red dragon for you to
     command.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 07, 2003
//:://////////////////////////////////////////////

/*
    Altered by Boneshank, for purposes of the Epic Spellcasting project.
*/

#include "x2_inc_toollib"
#include "inc_epicspells"
#include "x2_inc_spellhook"
void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, DRG_KNI_DC, DRG_KNI_S, DRG_KNI_XP))
    {
        //Declare major variables
        int nDuration = 20;
        effect eSummon;
        effect eVis = EffectVisualEffect(460);
        eSummon = EffectSummonCreature("x2_s_drgred001",481,0.0f,TRUE);

        // * make it so dragon cannot be dispelled
        eSummon = ExtraordinaryEffect(eSummon);
        //Apply the summon visual and summon the dragon.
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon,GetSpellTargetLocation(), RoundsToSeconds(nDuration));
        DelayCommand(1.0f,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis,GetSpellTargetLocation()));
    }
}


