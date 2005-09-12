void main()
{   
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("nw_ch_ac7", OBJECT_SELF);
    else
        ExecuteScript("x2_def_ondeath", OBJECT_SELF);
    ExecuteScript("prc_npc_death", OBJECT_SELF);
}