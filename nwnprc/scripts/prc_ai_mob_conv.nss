void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("nw_ch_ac4", OBJECT_SELF);
    else
        ExecuteScript("x2_def_onconv", OBJECT_SELF);
    ExecuteScript("prc_npc_conv", OBJECT_SELF);
}