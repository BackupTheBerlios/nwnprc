void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("nw_ch_ac5", OBJECT_SELF);
    else
        ExecuteScript("x2_def_ondamage", OBJECT_SELF);
    ExecuteScript("prc_npc_damage", OBJECT_SELF);
}