//::///////////////////////////////////////////////
//:: Target list management functions include
//:: inc_target_list
//::///////////////////////////////////////////////
/*
    A single calling point for UnarmedFeats() and
    UnarmedFists(). This is called from EvalPRCFeats
    after all scripts that need these two funtions
    called are run.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 15.03.2005
//:://////////////////////////////////////////////

#include "prc_inc_unarmed"
#include "inc_eventhook"

void main(){
    PrintString("Executing unarmed_caller");
    if(GetLocalInt(OBJECT_SELF, CALL_UNARMED_FEATS))
        UnarmedFeats(OBJECT_SELF);
    if(GetLocalInt(OBJECT_SELF, CALL_UNARMED_FISTS))
        UnarmedFists(OBJECT_SELF);
    
    DeleteLocalInt(OBJECT_SELF, CALL_UNARMED_FEATS);
    DeleteLocalInt(OBJECT_SELF, CALL_UNARMED_FISTS);
    
    SetLocalInt(OBJECT_SELF, UNARMED_CALLBACK, TRUE);
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, CALLBACKHOOK_UNARMED);
    DeleteLocalInt(OBJECT_SELF, UNARMED_CALLBACK);
}