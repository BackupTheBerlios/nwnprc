void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("nw_ch_ac3", OBJECT_SELF);
    else
        ExecuteScript("x2_def_endcombat", OBJECT_SELF);
    ExecuteScript("prc_npc_combat", OBJECT_SELF);
}