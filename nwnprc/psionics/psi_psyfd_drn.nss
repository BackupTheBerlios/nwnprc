void main()
{
    object oCaster = OBJECT_SELF;
    // # to drain from one stat to add to another
    int nDrain = GetLocalInt(oCaster, "PsychoBurnNum");
    nDrain += 1;
    SetLocalInt(oCaster, "PsychoBurnNum", nDrain);
    FloatingTextStringOnCreature("Psychofeedback will drain and boost by: " + IntToString(nDrain), oCaster, FALSE);
}