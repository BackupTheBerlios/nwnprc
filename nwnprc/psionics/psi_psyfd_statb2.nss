void main()
{
    object oCaster = OBJECT_SELF;
    // Stat 1 = Str/Int, Stat 2 = Dex/Wis, Stat 3 = Con/Cha
    SetLocalInt(oCaster, "PsychoBurnStat", 2);
    FloatingTextStringOnCreature("Stat #2 Selected", oCaster, FALSE);
}