const int nLevel = 5;

void main()
{
    object oCaster = OBJECT_SELF;
    if(!GetLocalInt(oCaster, "Overchannel"))
    {
        SetLocalInt(oCaster, "WildSurge", nLevel);
        FloatingTextStringOnCreature("Wild Surge Level Five", oCaster, FALSE);
    }
    else
        FloatingTextStringOnCreature("You cannot have Wild Surge and Overchannel active at the same time", oCaster, FALSE);
}