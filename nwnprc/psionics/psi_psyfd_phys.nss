void main()
{
    object oCaster = OBJECT_SELF;
    // Physical = 1, Mental = 2
    SetLocalInt(oCaster, "PsychoBurnMP", 1);
    FloatingTextStringOnCreature("Physical Stat Selected", oCaster, FALSE);
}