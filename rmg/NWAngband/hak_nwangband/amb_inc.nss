

// Because CreateObject doesnt work with sounds this is the fudge
// It assumes there are multiple placed instances somewhere for each
// object where the resref is the same as the tag.
// I estimate about 5-10 instances per resref are needed, depending on useage
//
// NOTE: Dont delete these objects when no longer needed. Instead use
// SoundObjectStop() to stop them.
//
// NOTE: This automatically starts the sound playing, but it does not alter
// position or volume.
//
// NOTE: This selects sound objects to move based on earliest spawned
// It does not take into acocunt if it is on or off at the time, nor how much
// use it gets. It also does not separete placed sounds and ones put in a
// storage areas
//
// lSpawn is the location to put the sound at
//
// sTag is the tag of the original to use. This does not need to be the same
// as the resref, and you can have multiple different tags based of the same
// resref
//
// return is the sound object that was moved
object CreateSoundObject(location lSpawn, string sTag);


//sounds are in a nice shade of blue    100,100,200
//feelings and observations are grey    200,200,200
//smells are in green                   100,200,100

#include "gen_inc_color"

const float SOUND_TEST_DELAY = 60.0;
const string MESSAGE_FLOATING = "Description_Message_Floating";//0 is none, 1 is self, 2 is party
const string MESSAGE_PRIVATE = "Description_Message_Private";//0 is no, 1 is yes

object CreateSoundObject(location lSpawn, string sTag)
{
    int i = GetLocalInt(GetModule(), "Sound_"+sTag);
    object oSound = GetObjectByTag(sTag, i);
    if(!GetIsObjectValid(oSound))
    {
        oSound = GetObjectByTag(sTag, 0);
        SetLocalInt(GetModule(), "Sound_"+sTag, 0);
    }
    else
    {
        i++;
        SetLocalInt(GetModule(), "Sound_"+sTag, i);
    }
    AssignCommand(oSound, JumpToLocation(lSpawn));
    SoundObjectPlay(oSound);
    return oSound;
}

object CreateDescriptiveSound(string sTag, string sDesc, location lSpawn, int nDC = 0, int nOneShot = FALSE)
{
    //sounds are in a nice shade of blue
    string sMess = GetRGB(100, 100, 200)+"* You hear: "+sDesc+GetRGB(100, 100, 200)+" *";
    //create the sound object
    object oSound = CreateSoundObject(lSpawn, sTag);
    //set it to non-playable
    SoundObjectStop(oSound);
    //set it to half-volumne
    SoundObjectSetVolume(oSound, 64);
    //pick a suitable AoE effect based on radius size
    //only invis purge is non-visible at the moment
    effect eAoE = EffectAreaOfEffect(AOE_MOB_INVISIBILITY_PURGE, "amb_sound_enter", "amb_sound_hb", "amb_sound_exit");
    //make supernatural so cant be dispelled etc
    eAoE = SupernaturalEffect(eAoE);
    //apply it
    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eAoE, lSpawn);
    //get the AoE Object we just made
    string sTag = Get2DAString("vfx_persistent", "LABEL", AOE_MOB_INVISIBILITY_PURGE);
    object oAoE = GetFirstObjectInShape(SHAPE_SPHERE, 1.0f, lSpawn, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
    while(GetIsObjectValid(oAoE))
    {
        // Test if we found the correct AoE
        if(GetTag(oAoE) == sTag
            && !GetLocalInt(oAoE, "ParanoiaMarker") // Just in case there are two traps in the almost same location
           )
        {
            SetLocalInt(oAoE, "ParanoiaMarker", TRUE);
            break;
        }
        // Didn't find, get next
        oAoE = GetNextObjectInShape(SHAPE_SPHERE, 1.0f, lSpawn, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
    }
    //set information on the AoE object
    SetLocalInt(oAoE, "SoundDC", nDC);
    SetLocalString(oAoE, "SoundDesc", sDesc);
    SetLocalString(oAoE, "SoundMess", sMess);
    SetLocalObject(oAoE, "SoundObject", oSound);
    SetLocalInt(oAoE, "SoundOneShot", nOneShot);
    return oAoE;
}

object CreateDescriptiveSmell(string sDesc, location lSpawn, int nDC = 0, int nOneShot = FALSE)
{
    //smells are in a nice shade of green
    string sMess = GetRGB(100, 200, 100)+"* You smell: "+sDesc+GetRGB(100, 200, 100)+" *";
    //pick a suitable AoE effect based on radius size
    //only invis purge is non-visible at the moment
    effect eAoE = EffectAreaOfEffect(AOE_MOB_INVISIBILITY_PURGE, "amb_smell_enter", "amb_smell_hb", "amb_smell_exit");
    //make supernatural so cant be dispelled etc
    eAoE = SupernaturalEffect(eAoE);
    //apply it
    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eAoE, lSpawn);
    //get the AoE Object we just made
    string sTag = Get2DAString("vfx_persistent", "LABEL", AOE_MOB_INVISIBILITY_PURGE);
    object oAoE = GetFirstObjectInShape(SHAPE_SPHERE, 1.0f, lSpawn, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
    while(GetIsObjectValid(oAoE))
    {
        // Test if we found the correct AoE
        if(GetTag(oAoE) == sTag
            && !GetLocalInt(oAoE, "ParanoiaMarker") // Just in case there are two traps in the almost same location
           )
        {
            SetLocalInt(oAoE, "ParanoiaMarker", TRUE);
            break;
        }
        // Didn't find, get next
        oAoE = GetNextObjectInShape(SHAPE_SPHERE, 1.0f, lSpawn, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
    }
    //set information on the AoE object
    SetLocalInt(oAoE, "SmellDC", nDC);
    SetLocalString(oAoE, "SmellDesc", sDesc);
    SetLocalString(oAoE, "SmellMess", sMess);
    SetLocalInt(oAoE, "SmellOneShot", nOneShot);
    return oAoE;
}

object CreateDescriptiveFeeling(string sDesc, location lSpawn, int nDC = 0, int nOneShot = FALSE)
{
    //feelings are in a nice shade of grey
    string sMess = GetRGB(200, 200, 200)+"* You feel: "+sDesc+GetRGB(200, 200, 200)+" *";
    //pick a suitable AoE effect based on radius size
    //only invis purge is non-visible at the moment
    effect eAoE = EffectAreaOfEffect(AOE_MOB_INVISIBILITY_PURGE, "amb_feel_enter", "amb_feel_hb", "amb_feel_exit");
    //make supernatural so cant be dispelled etc
    eAoE = SupernaturalEffect(eAoE);
    //apply it
    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eAoE, lSpawn);
    //get the AoE Object we just made
    string sTag = Get2DAString("vfx_persistent", "LABEL", AOE_MOB_INVISIBILITY_PURGE);
    object oAoE = GetFirstObjectInShape(SHAPE_SPHERE, 1.0f, lSpawn, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
    while(GetIsObjectValid(oAoE))
    {
        // Test if we found the correct AoE
        if(GetTag(oAoE) == sTag
            && !GetLocalInt(oAoE, "ParanoiaMarker") // Just in case there are two traps in the almost same location
           )
        {
            SetLocalInt(oAoE, "ParanoiaMarker", TRUE);
            break;
        }
        // Didn't find, get next
        oAoE = GetNextObjectInShape(SHAPE_SPHERE, 1.0f, lSpawn, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
    }
    //set information on the AoE object
    SetLocalInt(oAoE, "FeelDC", nDC);
    SetLocalString(oAoE, "FeelDesc", sDesc);
    SetLocalString(oAoE, "FeelMess", sMess);
    SetLocalInt(oAoE, "FeelOneShot", nOneShot);
    return oAoE;
}

void SendAmbientMessage(object oPC, string sMess, string sDesc, string sVerb)
{
    //henchmen say things
    if(GetIsObjectValid(GetMaster(oPC)))
    {
        //animals dont talk
        //nor oozes
        //nor constructs
        //nor stupid things
        if(GetRacialType(oPC) == RACIAL_TYPE_ANIMAL
            || GetRacialType(oPC) == RACIAL_TYPE_MAGICAL_BEAST
            || GetRacialType(oPC) == RACIAL_TYPE_BEAST
            || GetRacialType(oPC) == RACIAL_TYPE_OOZE
            || GetRacialType(oPC) == RACIAL_TYPE_CONSTRUCT
            || GetAbilityScore(oPC, ABILITY_INTELLIGENCE) <= 3)
        {
            object oMaster = GetMaster(oPC);
            object oTest = oMaster;
            while(GetIsObjectValid(oTest))
            {
                oTest = oMaster;
                oTest = GetMaster(oTest);
            }
            //light grey color
            sMess = GetRGB(200, 200, 200)+GetName(oPC)+" looks uncomfortable.";
            //players dont, they can talk to each other
            if(GetLocalInt(oPC, MESSAGE_FLOATING))
                FloatingTextStringOnCreature(sMess, oMaster, FALSE);
            //some people may like a PM instead
            if(GetLocalInt(oPC, MESSAGE_PRIVATE))
                SendMessageToPC(oMaster, sMess);
        }
        SpeakString("Wait, I "+sVerb+" "+sDesc+".");
    }
    else
    {
        if(GetLocalInt(oPC, MESSAGE_FLOATING) == 1)
            FloatingTextStringOnCreature(sMess, oPC, FALSE);
        else if(GetLocalInt(oPC, MESSAGE_FLOATING) == 2)
            FloatingTextStringOnCreature(sMess, oPC, TRUE);
        //some people may like a PM instead
        if(GetLocalInt(oPC, MESSAGE_PRIVATE))
            SendMessageToPC(oPC, sMess);
    }
}

void DoSoundCheck(object oPC)
{
    //check if the PC has already tested recently
    if(GetLocalInt(OBJECT_SELF, "TestedSound_"+ObjectToString(oPC)))
        return;
    //mark them as having tried to listen
    SetLocalInt(OBJECT_SELF, "TestedSound_"+ObjectToString(oPC), TRUE);
    DelayCommand(SOUND_TEST_DELAY, DeleteLocalInt(OBJECT_SELF, "TestedSound_"+ObjectToString(oPC)));
    //get stored information
    int nDC = GetLocalInt(OBJECT_SELF, "SoundDC");
    string sMess = GetLocalString(OBJECT_SELF, "SoundMess");
    string sDesc = GetLocalString(OBJECT_SELF, "SoundDesc");
    object oSound = GetLocalObject(OBJECT_SELF, "SoundObject");
    int nOneShot = GetLocalInt(OBJECT_SELF, "SoundOneShot");
    //make the skill check
    if(GetIsSkillSuccessful(oPC, SKILL_LISTEN, nDC))
    {
        //play the sound
        SoundObjectPlay(oSound);
        //do the message
        SendAmbientMessage(oPC, sMess, sDesc, "hear");
        //if its one-shot, clean up
        if(nOneShot)
            DestroyObject(OBJECT_SELF);
    }
}

void DoSmellCheck(object oPC)
{
    //check if the PC has already tested recently
    if(GetLocalInt(OBJECT_SELF, "TestedSmell_"+ObjectToString(oPC)))
        return;
    //mark them as having tried to listen
    SetLocalInt(OBJECT_SELF, "TestedSmell_"+ObjectToString(oPC), TRUE);
    DelayCommand(SOUND_TEST_DELAY, DeleteLocalInt(OBJECT_SELF, "TestedSmell_"+ObjectToString(oPC)));
    //get stored information
    int nDC = GetLocalInt(OBJECT_SELF, "SmellDC");
    string sMess = GetLocalString(OBJECT_SELF, "SmellMess");
    string sDesc = GetLocalString(OBJECT_SELF, "SmellDesc");
    int nOneShot = GetLocalInt(OBJECT_SELF, "SmellOneShot");
    //make the skill check
    int nRoll = d20()+GetAbilityModifier(ABILITY_WISDOM, oPC);
    if(nRoll > nDC)
    {
        //do the message
        SendAmbientMessage(oPC, sMess, sDesc, "smell");
        //if its one-shot, clean up
        if(nOneShot)
            DestroyObject(OBJECT_SELF);
    }
}

void DoFeelingCheck(object oPC)
{
    //check if the PC has already tested recently
    if(GetLocalInt(OBJECT_SELF, "TestedFeel_"+ObjectToString(oPC)))
        return;
    //mark them as having tried to listen
    SetLocalInt(OBJECT_SELF, "TestedFeel_"+ObjectToString(oPC), TRUE);
    DelayCommand(SOUND_TEST_DELAY, DeleteLocalInt(OBJECT_SELF, "TestedFeel_"+ObjectToString(oPC)));
    //get stored information
    int nDC = GetLocalInt(OBJECT_SELF, "FeelDC");
    string sMess = GetLocalString(OBJECT_SELF, "FeelMess");
    string sDesc = GetLocalString(OBJECT_SELF, "FeelDesc");
    int nOneShot = GetLocalInt(OBJECT_SELF, "FeelOneShot");
    //make the skill check
    int nRoll = d20()+GetAbilityModifier(ABILITY_WISDOM, oPC);
    if(nRoll > nDC)
    {
        //do the message
        SendAmbientMessage(oPC, sMess, sDesc, "feel");
        //if its one-shot, clean up
        if(nOneShot)
            DestroyObject(OBJECT_SELF);
    }
}
