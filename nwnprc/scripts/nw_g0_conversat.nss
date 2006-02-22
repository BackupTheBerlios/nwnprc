////////////////////////////////////////////////////////////
// OnConversation
// g_ConversationDG.nss
// Copyright (c) 2001 Bioware Corp.
////////////////////////////////////////////////////////////
// Created By: Noel Borstad
// Created On: 04/25/02001
// Description: This is the default script that is called if
//              no OnConversation script is specified.
////////////////////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_leadersh"

void main()
{
    if(GetIsPC(OBJECT_SELF))
    {
        SetLocalInt(OBJECT_SELF, "default_conversation_event", TRUE);
        ExecuteScript("default", OBJECT_SELF);
    }
    else if(GetListenPatternNumber() == -1)
        BeginConversation();
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_VIRTUAL_ONCONVERSATION);
}
