//::///////////////////////////////////////////////
//:: Summon Familiar
//:: NW_S2_Familiar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons an Arcane casters familiar
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////

#include "heartward_inc"
#include "prc_getcast_lvl"
#include "soul_inc"
#include "inc_npc"

void main()
{

    SummonFamiliar();
          
    if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER))
    {
      object oFam =GetAssociate(ASSOCIATE_TYPE_FAMILIAR);
      DestroyObject(oFam, 0.5);
    }

}