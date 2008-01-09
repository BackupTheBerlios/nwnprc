//::///////////////////////////////////////////////
//:: Turns player into a wolf
//:: prc_wwformwolf
//:: Copyright (c) 2004 Shepherd Soft
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Russell S. Ahlstrom
//:: Created On: May 11, 2004
//:://////////////////////////////////////////////

//Modified for use with Hound Archon

#include "prc_inc_clsfunc"
#include "prc_feat_const"

void main()
{
    object oPC = OBJECT_SELF;
    int nPoly;

   if (GetLocalInt(oPC, "WWWolf") != TRUE)
   {
    	nPoly = POLYMORPH_TYPE_WOLF_2;
	
    	LycanthropePoly(oPC, nPoly);
    	SetLocalInt(oPC, "WWWolf", TRUE);
    }
    else
    {
    ExecuteScript("prc_wwunpoly", oPC);
    SetLocalInt(oPC, "WWWolf", FALSE);
    }    	
}
