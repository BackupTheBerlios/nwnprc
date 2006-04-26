//::///////////////////////////////////////////////
//:: Name           Template main script
//:: FileName       prc_templates
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

    This deals with maintaining the bonus' that the
    various templates grant.

*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 18/04/06
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_template"

void RunTemplateStuff(int nTemplate, object oPC = OBJECT_SELF)
{   
    //run the maintenence script
    string sScript = Get2DACache("templates", "MaintainScript", nTemplate); 
    ExecuteScript(sScript, oPC);
}


void main()
{

    object oPC = OBJECT_SELF;
    
    //loop over all templates and see if the player has them
    int i;
    for(i=0;i<200;i++)
    {
        if(GetHasTemplate())
            RunTemplateStuff(i, oPC);    
    }
}