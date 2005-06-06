void main()
{
    object oCaster = OBJECT_SELF;
    // Stat 1 = Str/Int, Stat 2 = Dex/Wis, Stat 3 = Con/Cha
    SetLocalInt(oCaster, "PsychoBurnStat", 3);
    FloatingTextStringOnCreature("Stat #3 Selected", oCaster, FALSE);
}