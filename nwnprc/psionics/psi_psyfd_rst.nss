void main()
{
    object oCaster = OBJECT_SELF;
    // Reset's the Drain Int to 0.
    SetLocalInt(oCaster, "PsychoBurnNum", 0);
    FloatingTextStringOnCreature("Number to drain reset to 0", oCaster, FALSE);
}