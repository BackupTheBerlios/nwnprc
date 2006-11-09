tlk entries:

39  // Continue

123 // Head
124 // Select the Appearance of your Character
125 // Hair Color
128 // Skin Color
147 // Portrait
337 // Tattoo Colors

2409 // Wings
2410 // Tail
7383 // Select a portrait
7498 // Sound Set
7535 // Select a sound set
7880 // Select Character Colors
7888 // Select Color

52977 // Select
65992 // Select None

void DoCutscene(object oPC, int nSetup = FALSE)
{
    string sScript;
    int nStage = GetStage(oPC);
    if (nStage < STAGE_RACE_CHECK) // if we don't need to set the clone up
        return;
    
    DoDebug("DoCutscene() stage is :" + IntToString(nStage) + " nSetup = " + IntToString(nSetup));
    object oClone;
    
    if(nStage == STAGE_RACE_CHECK || (nStage > STAGE_RACE_CHECK && nSetup))
    {
        // check the PC has finished entering the area
        if(!GetIsObjectValid(GetArea(oPC)))
        {
            DelayCommand(1.0, DoCutscene(oPC, nSetup));
            return;
        }
        // make the PC look like the race they have chosen
        DoSetRaceAppearance(oPC);
        // clone the PC and hide the swap with a special effect
        // make the real PC non-collideable
        effect eGhost = EffectCutsceneGhost();
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGhost, oPC, 99999999.9);
        // make the swap and hide with an effect
        effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
        // make clone
        oClone = CopyObject(oPC, GetLocation(oPC), OBJECT_INVALID, "PlayerClone");
        ChangeToStandardFaction(oClone, STANDARD_FACTION_MERCHANT);
        // make the real PC invisible
        effect eInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oPC, 9999.9);
        // swap local objects
        SetLocalObject(oPC, "Clone", oClone);
        SetLocalObject(oClone, "Master", oPC);
        // this makes sure the clone gets destroyed if the PC leaves the game
        AssignCommand(oClone, CloneMasterCheck());
        // end of clone making
        
        int nGender = GetLocalInt(oPC, "Gender");
        // this only needs doing if the gender has changed
        if (GetGender(oPC) != nGender)
        {
            sScript = LetoSet("Gender", IntToString(nSex), "byte");
            // reset soundset only if we've not changed it yet
            if (nStage < STAGE_SOUNDSET)
                sScript += LetoSet("SoundSetFile", IntToString(0), "word");
        }
    }
    
    if(nStage == STAGE_APPEARANCE || (nStage > STAGE_APPEARANCE && nSetup))
    {
        DoSetAppearance(oPC);
    }
    
    if(nStage == STAGE_SOUNDSET || (nStage > STAGE_SOUNDSET && nSetup))
    {
        int nSoundset = GetLocalInt(oPC, "Soundset");
        if (nSoundset != -1) // then it has been changed
        {
            sScript += LetoSet("SoundSetFile", IntToString(nSoundset), "word");
        }
    }
    
    if (nStage == STAGE_SKIN_COLOUR || (nStage > STAGE_SKIN_COLOUR && nSetup))
    {
        int nSkin = GetLocalInt(oPC, "Skin");
        if (nSkin != -1) // then it has been changed
        {
            sScript += SetSkinColor(nSkin);
        }
    }
    
    if (nStage == STAGE_HAIR_COLOUR || (nStage > STAGE_HAIR_COLOUR && nSetup))
    {
        int nHair = GetLocalInt(oPC, "Hair");
        if (nHair != -1) // then it has been changed
        {
            sScript += SetSkinColor(nHair);
        }
    }
    
    if (nStage == STAGE_TATTOO_COLOUR1 || (nStage > STAGE_TATTOO_COLOUR1 && nSetup))
    {
        int nTattooColour1 = GetLocalInt(oPC, "TattooColour1");
        if (nTattooColour1 != -1) // then it has been changed
        {
            sScript += SetSkinColor(nTattooColour1, 1);
        }
    }
    
    if (nStage == STAGE_TATTOO_COLOUR2 || (nStage > STAGE_TATTOO_COLOUR2 && nSetup))
    {
        int nTattooColour2 = GetLocalInt(oPC, "TattooColour2");
        if (nTattooColour2 != -1) // then it has been changed
        {
            sScript += SetSkinColor(nTattooColour2, 2);
        }
    }
    // no point in running the letoscript commands if no changes are made
    if (nScript != "")
    {
        StackedLetoScript(sScript);
        string sResult;
        RunStackedLetoScriptOnObject(oClone, "OBJECT", "SPAWN", "prc_ccc_app_lspw", TRUE);
        sResult = GetLocalString(GetModule(), "LetoResult");
        SetLocalObject(GetModule(), "PCForThread"+sResult, OBJECT_SELF);
    }
}
