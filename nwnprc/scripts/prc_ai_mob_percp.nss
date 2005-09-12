void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("nw_ch_ac2", OBJECT_SELF);
    else
        ExecuteScript("x2_def_percept", OBJECT_SELF);
    ExecuteScript("prc_npc_percep", OBJECT_SELF);
}