void main()
{
    if(GetTrapFlagged(OBJECT_SELF))
    {
        int i = 1;
        object oTest = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, i);
        while(GetIsObjectValid(oTest) && i < 20)
        {
            SetTrapDetectedBy(OBJECT_SELF, oTest);
            i++;
            oTest = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, i);
        }
    }
}
