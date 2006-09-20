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
    DoDebug("Running template maintenence script "+sScript);
    ExecuteScript(sScript, oPC);
}


void main()
{
    DoDebug("Running Prc_templates");
    object oPC = OBJECT_SELF;
    //stop infinite loop
    if(GetLocalInt(oPC, "TemplateTest"))
        return;
    
    //loop over all templates and see if the player has them
    int i;
    int bHasTemplate = FALSE;
    for(i=0;i<200;i++)
    {
        if(GetHasTemplate(i, oPC))
        {
            bHasTemplate = TRUE;
            RunTemplateStuff(i, oPC);    
        }    
    }
    
    if(bHasTemplate)
    {
    
    /*
        //call evalPRCFeats again to repeat templates
        SetLocalInt(oPC, "TemplateTest", TRUE);
        DelayCommand(1.0, DeleteLocalInt(oPC, "TemplateTest"));
        EvalPRCFeats(oPC);
    */
        DoDebug("Re-running prc_feat");
        
        //run the main PRC feat system so we trigger any other feats weve borrowed
        ExecuteScript("prc_feat", oPC);
    }
}