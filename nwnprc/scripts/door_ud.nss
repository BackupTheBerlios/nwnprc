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
            if(nMaxHP == 0)
                nMaxHP = 20;
            SetLocalInt(OBJECT_SELF, "DoorHP", nMaxHP);
            SetPlotFlag(OBJECT_SELF, FALSE);
            ActionCloseDoor(OBJECT_SELF);
        }
        break;
        //despawn
        case 501:
        {
        }
        break;
        //prerespawn
        case 502:
        {
        }
        break;
    }
}
