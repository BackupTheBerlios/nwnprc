void main()
{
    int nEventID = GetUserDefinedEventNumber();
    switch(nEventID)
    {
        //respawn
        case 500:
        {
            effect eTest = GetFirstEffect(OBJECT_SELF);
            while(GetIsEffectValid(eTest))
            {
                RemoveEffect(OBJECT_SELF, eTest);
                eTest = GetNextEffect(OBJECT_SELF);
            }
            int nMaxHP = GetLocalInt(OBJECT_SELF, "DoorMaxHP");
            //if its not set, check the reflex saving throw field
            if(nMaxHP == 0)
                nMaxHP = GetReflexSavingThrow(OBJECT_SELF);
            //if thats not set, default to 20HP    
            if(nMaxHP == 0)
                nMaxHP = 20;
            SetLocalInt(OBJECT_SELF, "DoorHP", nMaxHP);
            SetPlotFlag(OBJECT_SELF, FALSE);
            //ActionCloseDoor(OBJECT_SELF);
            PlayAnimation(ANIMATION_DOOR_CLOSE);
        }
        break;
    }
}
