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

#include "inc_npc"
#include "prc_class_const"

void main()
{

    	SummonFamiliar();
    	object oFam = GetAssociate(ASSOCIATE_TYPE_FAMILIAR);
          
    	if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER))
    	{
    		DestroyObject(oFam, 0.5);
    	}
    	
    	if (GetLevelByClass(CLASS_TYPE_DIABOLIST) >= 2)
    	{
    		if (GetAppearanceType(oFam) != APPEARANCE_TYPE_IMP)
	    	{
	    		DestroyObject(oFam, 0.5);
	    	}
    	}

}