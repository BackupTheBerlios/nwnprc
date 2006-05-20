#include "ral_inc"
#include "rad_inc"

void main()
{
    int nEventID = GetUserDefinedEventNumber();
    object oArea = OBJECT_SELF;
    switch(nEventID)
    {
        case RAL_SETUP_EVENT_ID:
        if(!GetLocalInt(oArea, "Spawned"))
        {
            //this is rather fugly, but nevermind
            float fCR = GetChallengeRating(GetFirstPC());
            //spawn area must be run by an object in the area
            object oTest = GetFirstObjectInArea(oArea);
            string sSpawn = GetLocalString(oArea, "rad_spawnlist");
            if(sSpawn == "")
                sSpawn = "rad_"+GetTilesetResRef(oArea);
            float fRoomSize = GetLocalFloat(oArea, "rad_roomsize");
            if(fRoomSize == 0.0)
                fRoomSize = 20.0;
            AssignCommand(oTest,
                DelayCommand(1.0,
                    SpawnArea(oArea, fCR, sSpawn, fRoomSize)));
            SetLocalInt(oArea, "Spawned", TRUE);
            while(GetIsObjectValid(oTest))
            {
                //randomize doors
                if(GetObjectType(oTest) == OBJECT_TYPE_DOOR)
                {
                    //all doors can be locked
                    SetLockLockable(oTest, TRUE);
                    //all doors are untrapped by default
                    SetTrapActive(oTest, FALSE);
                    SetTrapDetectable(oTest, FALSE);
                    object oPC = GetFirstPC();
                    while(GetIsObjectValid(oPC))
                    {
                        SetTrapDetectedBy(oTest, oPC, FALSE);
                        oPC = GetNextPC();
                    }
                    //hook in the respawning door stuff
                    AddEventScript(oTest, EVENT_DOOR_ONDAMAGED, "door_damaged", TRUE, FALSE);
                    AddEventScript(oTest, EVENT_DOOR_ONUSERDEFINED, "door_ud", TRUE, FALSE);
                    //now the random part
                    /*
                    switch(Random(5))
                    {
                        //destroyed
                        case 0:
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints(oTest)-1), oTest);
                            break;
                        //opened
                        case 1:
                            if(Random(2))
                                AssignCommand(oTest, PlayAnimation(ANIMATION_DOOR_OPEN1));
                            else
                                AssignCommand(oTest, PlayAnimation(ANIMATION_DOOR_OPEN2));
                            break;
                        //locked
                        case 2:
                            SetLocked(oTest, TRUE);
                    }
                    */
                    //and the ral transition stuff
                    //for the moment, assume all doors are ral transition doors
                    //in reality only doors that are marked as area transitions will have a transit event)
                    AddEventScript(oTest, EVENT_DOOR_ONTRANSITION, "ral_transition", TRUE, FALSE);
                }
                oTest = GetNextObjectInArea(oArea);
            }
        }
        break;

        case RAL_CLEAR_EVENT_ID:
        {
            object oTest = GetFirstObjectInArea(oArea);
            while(GetIsObjectValid(oTest))
            {
                //clean up stuff
                if(!GetIsPC(oTest)
                    && !GetPlotFlag(oTest)
                    && GetObjectType(oTest) != OBJECT_TYPE_DOOR
                    && GetObjectType(oTest) != OBJECT_TYPE_TRIGGER
                    )
                {
                    if(GetHasInventory(oTest))
                    {
                        object oTest2 = GetFirstItemInInventory(oTest);
                        while(GetIsObjectValid(oTest2))
                        {
                            if(GetHasInventory(oTest2))
                            {
                                object oTest3 = GetFirstItemInInventory(oTest2);
                                while(GetIsObjectValid(oTest3))
                                {
                                    DestroyObject(oTest3);
                                    oTest3 = GetNextItemInInventory(oTest2);
                                }
                            }
                            DestroyObject(oTest2);
                            oTest2 = GetNextItemInInventory(oTest);
                        }
                        DestroyObject(oTest2);
                    }
                    DestroyObject(oTest);
                }

                //respawn doors
                if(GetObjectType(oTest) == OBJECT_TYPE_DOOR)
                    SignalEvent(oTest, EventUserDefined(500));

                //destroy trigger traps as these must have come from trap kits
                if(GetObjectType(oTest) == OBJECT_TYPE_TRIGGER
                    &&GetIsTrapped(oTest))
                    DestroyObject(oTest);

                oTest = GetNextObjectInArea(oArea);
            }
            DeleteLocalInt(oArea, "Spawned");
            //award XP
            //assume single-party
            object oPC = GetFirstFactionMember(GetFirstPC(), TRUE);
            float fXP = GetLocalFloat(oArea, "XPAward");
            DeleteLocalFloat(oArea, "XPAward");
            while(GetIsObjectValid(oPC))
            {
                GiveXPToCreature(oPC, FloatToInt(fXP));
                oPC = GetNextFactionMember(GetFirstPC(), TRUE);
            }
        }
        break;
    }
}
