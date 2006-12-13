
#include "prc_alterations"
#include "inc_dynconv"
#include "ral_inc"

void main()
{
                //just a jump to first portal WP at the moment
                object oWP = GetWaypointByTag("wp_portal");
                location lLoc = GetLocation(oWP);
                object oArea = GetAreaFromLocation(lLoc);
                DelayCommand(60.0, AssignCommand(GetLastSpeaker(), JumpToLocation(lLoc)));
                SignalEvent(oArea,
                    EventUserDefined(RAL_SETUP_EVENT_ID));
    DoDebug("area_onud : Event "+IntToString(RAL_SETUP_EVENT_ID)+" signalling to "+GetResRef(oArea));
                
                
    string sConv = GetLocalString(OBJECT_SELF, "DynamicConvResRef");
    object oPC;
    //placeables
    oPC= GetLastUsedBy();
    if(GetIsObjectValid(oPC))
        StartDynamicConversation(sConv, oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE,
            TRUE, FALSE, OBJECT_SELF);
    //creatures
    else    
    {
        oPC = GetLastSpeaker();
        if(GetListenPatternNumber() == -1
            && GetIsObjectValid(oPC))
        {
            // Make sure we're not already inside the dynconvo
            if(!GetLocalInt(OBJECT_SELF, "InDynConvoMarker"))
            {
                SetLocalInt(OBJECT_SELF, "InDynConvoMarker", TRUE);
                //StartDynamicConversation("prc_cohort_convo", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, OBJECT_SELF);
                StartDynamicConversation(sConv, oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, oPC);
            }
        }
    }
}
