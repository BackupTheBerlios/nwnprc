//::///////////////////////////////////////////////
//:: Name           template include
//:: FileName       prc_inc_template
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is the main include file for the template system
    Deals with applying templates and interacting with the 2da
*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 18/4/06
//:://////////////////////////////////////////////

#include "prc_template_const"

//Checks if the target has the template or not.
//returns 1 if it does, 0 if it doesnt or if its an invalid target
int GetHasTemplate(int nTemplate, object oPC = OBJECT_SELF);

int GetHasTemplate(int nTemplate, object oPC = OBJECT_SELF)
{
    return GetPersistentLocalInt(oPC, "template_"+IntToString(nTemplate));
}

void ApplyTemplateToObject(int nTemplate, object oPC = OBJECT_SELF)
{
    //templates never stack, so dont let them
    if(GetHasTemplate(nTemplate, oPC))
        return;
    
    //run the application script
    string sScript = Get2DACache("templates", "SetupScript", nTemplate); 
    ExecuteScript(sScript, oPC);
    
    //mark the PC as possessing the template
    GetPersistentLocalInt(oPC, "template_"+IntToString(nTemplate), TRUE);
    
    //run the main PRC function system
    //run the whole thing so we trigger any other feats weve borrowed
    EvalPRCFeats(oPC);
}