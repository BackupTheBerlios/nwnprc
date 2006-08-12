// Added compatibility for PRC base classes
#include "prc_class_const"
#include "inc_utility"

void main()
{
if(DEBUG) DoDebug("m1q0boldgred_item running");
    string sItemTemplate;
    object oPC = GetPCSpeaker();
    if(GetLocalInt(oPC,"NW_L_M1Q0Item1") == FALSE)
    {
        SetLocalInt(oPC,"NW_L_M1Q0Item1",TRUE);
        if(GetLevelByClass(CLASS_TYPE_BARD,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_DRUID,oPC) > 0 ||
	   GetLevelByClass(CLASS_TYPE_TRUENAMER,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_SWASHBUCKLER,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_SOULKNIFE,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_ROGUE,oPC) > 0)
        {
            sItemTemplate = "nw_aarcl002"; //studded leather
        }
        else if(GetLevelByClass(CLASS_TYPE_SORCERER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_PSION,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_WILDER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_NINJA,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_WIZARD,oPC) > 0)
        {
            sItemTemplate = "nw_mcloth009"; //robe of fire resistance
        }
        else if(GetLevelByClass(CLASS_TYPE_MONK,oPC) > 0)
        {
            sItemTemplate = "nw_mcloth018"; //robe of the shining hand +1
        }
        else
        {
            sItemTemplate = "nw_aarcl012"; //chainshirt
        }
        object oItem = CreateItemOnObject(sItemTemplate,oPC);
        SetIdentified(oItem,TRUE);
    }
}
