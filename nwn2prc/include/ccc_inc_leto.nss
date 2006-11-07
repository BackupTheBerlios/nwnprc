/**
 * convoCC letoscript functions
 * 
 */
 
#include "inc_letoscript"
#include "inc_letocommands"

/**
 * main cutscene function
 * letoscript changes to the PC clone are done via this function
 * nSetup indicates whether the cutscene needs seting up or not
 */
void DoCutscene(object oPC, int nSetup = FALSE);

/**
 * Cutscene pseudo HB functions
 */
 
// used to cleanup clones when a player leaves
void CloneMasterCheck();

// sets up the camera to rotate around the clone 
// and the clone do random animations
void DoRotatingCamera();

/**
 * functions to set appearance, portrait, soundset
 */
 
// sets race appearance as defined in racialtype.2da
// removes wings, tails and undead graft arm as well as making invisible bits visible
void DoSetRaceAppearance();
 
// assigns the ccc chosen gender to the clone and resets the soundset
// if it's changed
void DoCloneGender();



/**
 * definitions
 */

void DoCutscene(object oPC, int nSetup = FALSE)
{
    //DISABLE FOR DEBUGGING
    if (nSetup && !DEBUG)
    {
        // start the cutscene
        // off for debugging to see the debug text in the client
        SetCutsceneMode(oPC, TRUE);
        SetCameraMode(oPC, CAMERA_MODE_TOP_DOWN);
    }
    
    // get what stage we're at
    int nStage = GetStage(oPC);
    // get whether this function has been called in setting up a stage,
    // in response to a choice or by prc_enter
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    
    /* TODO - getting it to do the right stage */
    // if we are on STAGE_RACE_CHECK 
    // or if we are setting up the cutscene and have got at least that far in the convo
    if (nStage == STAGE_RACE_CHECK || (nStage > STAGE_RACE_CHECK && nSetup))
    {
        // set race appearance, remove wings and tails, get rid of
        // invisible/undead etc body parts
        DoSetRaceAppearance();
        // clone the PC and hide the swap with a special effect
        // make the real PC non-collideable
        effect eGhost = EffectCutsceneGhost();
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGhost, OBJECT_SELF, 99999999.9);
        // make the swap and hide with an effect
        effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(OBJECT_SELF));
        // make clone
        object oClone = CopyObject(OBJECT_SELF, GetLocation(OBJECT_SELF), OBJECT_INVALID, "PlayerClone");
        ChangeToStandardFaction(oClone, STANDARD_FACTION_MERCHANT);
        // make the real PC invisible
        effect eInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, OBJECT_SELF, 9999.9);
        //make sure the clone stays put
        effect eParal = EffectCutsceneImmobilize();
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oClone, 9999.9);
        // swap local objects
        SetLocalObject(OBJECT_SELF, "Clone", oClone);
        SetLocalObject(oClone, "Master", OBJECT_SELF);
        // this makes sure the clone gets destroyed if the PC leaves the game
        AssignCommand(oClone, CloneMasterCheck());
        // use letoscript to assign the gender
        DoCloneGender();
        // set up the camera and animations
        DoRotatingCamera();
    }
}

void CloneMasterCheck()
{
    object oMaster = GetLocalObject(OBJECT_SELF, "Master");
    if(!GetIsObjectValid(oMaster))
    {
        SetIsDestroyable(TRUE);
        DestroyObject(OBJECT_SELF);
    }
    else
        DelayCommand(10.0, CloneMasterCheck());
}

void DoRotatingCamera()
{
    object oPC = OBJECT_SELF;
    if(!GetIsObjectValid(oPC))
        return;
    if(GetLocalInt(oPC, "StopRotatingCamera"))
    {
        DeleteLocalInt(oPC, "StopRotatingCamera");
        DeleteLocalFloat(oPC, "DoRotatingCamera");
        return;
    }
    float fDirection = GetLocalFloat(oPC, "DoRotatingCamera");
    fDirection += 30.0;
    if(fDirection > 360.0)
        fDirection -= 360.0;
    if(fDirection <= 0.0)
        fDirection += 360.0;
    SetLocalFloat(oPC, "DoRotatingCamera", fDirection);
    SetCameraMode(oPC, CAMERA_MODE_TOP_DOWN);
    SetCameraFacing(fDirection, 4.0, 45.0, CAMERA_TRANSITION_TYPE_VERY_SLOW);
    DelayCommand(6.0, DoRotatingCamera());
    //its the clone not the PC that does things
    object oClone = GetLocalObject(oPC, "Clone");
    if(GetIsObjectValid(oClone))
        oPC = oClone;
    if(d2()==1)
        AssignCommand(oPC, ActionPlayAnimation(100+Random(17)));
    else
        AssignCommand(oPC, ActionPlayAnimation(100+Random(21), 1.0, 6.0));
}

void DoSetRaceAppearance()
{
    // sets the appearance type
    int nSex = GetLocalInt(OBJECT_SELF, "Gender");
    int nRace = GetLocalInt(OBJECT_SELF, "Race");
    // appearance type switches go here
    if(nRace == RACIAL_TYPE_RAKSHASA
        && nSex == GENDER_FEMALE
        && GetPRCSwitch(PRC_CONVOCC_RAKSHASHA_FEMALE_APPEARANCE))
        SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_RAKSHASA_TIGER_FEMALE);
    else if(nRace == RACIAL_TYPE_DRIDER
        && nSex == GENDER_FEMALE
        && GetPRCSwitch(PRC_CONVOCC_DRIDER_FEMALE_APPEARANCE))
        SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_DRIDER_FEMALE);
    else
        SetCreatureAppearanceType(OBJECT_SELF, 
                    StringToInt(Get2DACache("racialtypes", "Appearance",
                        GetLocalInt(OBJECT_SELF, "Race"))));
    
    // remove wings and tails - so this can be set later
    // enforcing wing and tail related switches comes later too
    SetCreatureWingType(CREATURE_WING_TYPE_NONE);
    SetCreatureTailType(CREATURE_TAIL_TYPE_NONE);
    
    // get rid of invisible/undead etc bits, but keep tatoos as is
    SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, 1);
    SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, 1);
    SetCreatureBodyPart(CREATURE_PART_PELVIS, 1);
    SetCreatureBodyPart(CREATURE_PART_BELT, 0);
    SetCreatureBodyPart(CREATURE_PART_NECK, 1);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_SHOULDER, 0);
    SetCreatureBodyPart(CREATURE_PART_LEFT_SHOULDER, 0);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, 1);
    SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, 1);
    // make invisible heads visible, otherwise leave
    if(GetCreatureBodyPart(CREATURE_PART_HEAD) == 0)
        SetCreatureBodyPart(CREATURE_PART_HEAD, 1);
    // preserve tattoos, get rid of anything else
    if(!(GetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN) == 1))
        SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, 2);
    if(!(GetCreatureBodyPart(CREATURE_PART_LEFT_SHIN) == 1))
        SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, 2);
    if(!(GetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH) == 1))
        SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH, 2);
    if(!(GetCreatureBodyPart(CREATURE_PART_LEFT_THIGH) == 1))
        SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH, 2);
    if(!(GetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM) == 1))
        SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, 2);
    if(!(GetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM) == 1))
        SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, 2);
    if(!(GetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP) == 1))
        SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, 2);
    if(!(GetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP) == 1))
        SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, 2);
}

void DoCloneGender()
{
    object oClone = GetLocalObject(OBJECT_SELF, "Clone");
    if(!GetIsObjectValid(oClone))
        return;
    int nSex = GetLocalInt(OBJECT_SELF, "Gender");
    int nCurrentSex = GetGender(oClone);
    StackedLetoScript(LetoSet("Gender", IntToString(nSex), "byte"));
    // if the gender needs changing, reset the soundset
    if (nSex != nCurrentSex)
        StackedLetoScript(LetoSet("SoundSetFile", IntToString(0), "word"));
    string sResult;
    RunStackedLetoScriptOnObject(oClone, "OBJECT", "SPAWN", "prc_ccc_app_lspw", TRUE);
    sResult = GetLocalString(GetModule(), "LetoResult");
    SetLocalObject(GetModule(), "PCForThread"+sResult, OBJECT_SELF);
}
