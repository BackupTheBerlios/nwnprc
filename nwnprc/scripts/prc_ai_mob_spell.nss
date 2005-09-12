void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("nw_ch_acb", OBJECT_SELF);
    else
        ExecuteScript("x2_def_spell", OBJECT_SELF);
    ExecuteScript("prc_npc_spellat", OBJECT_SELF);
}