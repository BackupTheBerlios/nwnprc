//:://////////////////////////////////////////////
//:: Generic Listener object OnSpawn script
//:: prc_glist_onspwn
//:://////////////////////////////////////////////
/** @file
    The generic listener's OnSpawn script.
    Currently just for debugging.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 04.08.2005
//:://////////////////////////////////////////////


void main()
{
    SetListening(OBJECT_SELF, TRUE);
    //FloatingTextStringOnCreature("Running prc_glist_onspwn", OBJECT_SELF, FALSE);

    if(!GetLocalInt(OBJECT_SELF, "PRC_GenericListener_NoNotification"))
    {
        if(GetLocalInt(OBJECT_SELF, "PRC_GenericListener_ListenToSingle"))
            // "Listener ready. Due to some detail of how the NWN engine handles listening, the listener may only actually start listening during the next 3 seconds."
            AssignCommand(OBJECT_SELF, SendMessageToPCByStrRef(GetLocalObject(OBJECT_SELF, "PRC_GenericListener_ListeningTo"), 16825209));
        else
            FloatingTextStrRefOnCreature(16825209, OBJECT_SELF, FALSE);
    }
}