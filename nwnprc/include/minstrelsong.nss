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
    int iSlot = GetLocalInt(oSinger, "SONG_SLOT");
    int iIndex = GetLocalInt(oSinger, "SONG_INDEX_" + IntToString(iSlot)) + 1;
    string sIndex = "SONG_INDEX_" + IntToString(iSlot);
    string sRecip = "SONG_RECIPIENT_" + IntToString(iIndex) + "_" + IntToString(iSlot);
    string sSong = "SONG_IN_USE_" + IntToString(iSlot);

    // Store the recipient into the current used slot
    SetLocalObject(oSinger, sRecip, oRecipient);
   
    // Store the song information
    SetLocalInt(oSinger, sSong, iSongID);
   
    // Store the index of creatures we're on
    SetLocalInt(oSinger, sIndex, iIndex);
}

// Removes all effects given by the previous song from all creatures who recieved it.
// Now allows for two "slots", which means you can perform two songs at a time.
void RemoveOldSongEffects(object oSinger, int iSongID)
{
    object oCreature;
    int iSlotNow = GetLocalInt(oSinger, "SONG_SLOT");
    int iSlot;
    int iNumRecip;
    int iSongInUse;
    int iIndex;
    string sIndex;
    string sRecip;
    string sSong;
    
    // If you use the same song twice in a row you
    // should deal with the same slot again...
    if (GetLocalInt(oSinger, "SONG_IN_USE_" + IntToString(iSlotNow)) == iSongID)
        iSlot = iSlotNow;
    // Otherwise, we should toggle between slot "1" and slot "0"
    else
        iSlot = (iSlotNow == 1) ? 0 : 1;
    
    // Save the toggle we're on for later.
    SetLocalInt(oSinger, "SONG_SLOT", iSlot);

    // Find the proper variable names based on slot     
    sIndex = "SONG_INDEX_" + IntToString(iSlot);
    sSong = "SONG_IN_USE_" + IntToString(iSlot);
    
    // Store the local variables into script variables
    iNumRecip = GetLocalInt(oSinger, sIndex);
    iSongInUse = GetLocalInt(oSinger, sSong);
    
    // Reset the local variables
    SetLocalInt(oSinger, sIndex, 0);
    SetLocalInt(oSinger, sSong, 0);
    
    // Removes any effects from the caster first
    RemoveSongEffects(iSongInUse, oSinger, oSinger);
    
    // Removes any effects from the recipients
    for (iIndex = 1 ; iIndex <= iNumRecip ; iIndex++)
    {
       sRecip = "SONG_RECIPIENT_" + IntToString(iIndex) + "_" + IntToString(iSlot);
       oCreature = GetLocalObject(oSinger, sRecip);

       RemoveSongEffects(iSongInUse, oSinger, oCreature);
    }
}
