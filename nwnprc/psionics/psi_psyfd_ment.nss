void main()
{
    object oCaster = OBJECT_SELF;
    // Physical = 1, Mental = 2
    SetLocalInt(oCaster, "PsychoBurnMP", 2);
    FloatingTextStringOnCreature("Mental Stat Selected", oCaster, FALSE);
}