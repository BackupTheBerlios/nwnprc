// Goes a bit further than RemoveSpellEffects -- makes sure to remove ALL effects
// made by the Singer+Song.
void RemoveSongEffects(int iSong, object oCaster, object oTarget)
{
    effect eCheck = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eCheck))
    {
        if (GetEffectCreator(eCheck) == oCaster && GetEffectSpellId(eCheck) == iSong)
            RemoveEffect(oTarget, eCheck);
        eCheck = GetNextEffect(oTarget);
    }
}

// Stores a Song recipient to the PC as a local variable, and creates a list by using
// an index variable.
void StoreSongRecipient(object oRecipient, object oSinger, int iSongID, int iDuration)
{
    int iIndex = GetLocalInt(oSinger, "RecipientIndex") + 1;
    string sIndex = "SONG_RECIPIENT_" + IntToString(iIndex);

    SetLocalObject(oSinger, sIndex, oRecipient);
   
    SetLocalInt(oSinger, "SongInUse", iSongID);
   
    SetLocalInt(oSinger, "RecipientIndex", iIndex);
}

// Removes all effects given by the previous song from all creatures who recieved it.
void RemoveOldSongEffects(object oSinger)
{
    object oCreature;
    int iRecipients = GetLocalInt(oSinger, "RecipientIndex");
    int iSongInUse = GetLocalInt(oSinger, "SongInUse");
    int iIndex;
    string sIndex;
    
    SetLocalInt(oSinger, "RecipientIndex", 0);
    SetLocalInt(oSinger, "SongInUse", 0);
    
    RemoveSongEffects(iSongInUse, oSinger, oSinger);
    
    for (iIndex = 1 ; iIndex <= iRecipients ; iIndex++)
    {
       sIndex = "SONG_RECIPIENT_" + IntToString(iIndex);
       oCreature = GetLocalObject(oSinger, sIndex);

       RemoveSongEffects(iSongInUse, oSinger, oCreature);
    }
}
