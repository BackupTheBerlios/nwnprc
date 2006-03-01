// Added compatibility for PRC base classes
#include "prc_class_const"
#include "inc_utility"

void main()
{
if(DEBUG) DoDebug("m1q0dchest1 running");
    string sItemTemplate;
    object oPC = GetLastOpenedBy();
    if(GetIsObjectValid(oPC) == FALSE)
    {
        oPC = GetLastAttacker();
    }
    if(GetLocalInt(oPC,"NW_L_M1Q0Item3") == FALSE)
    {
        SetLocalInt(oPC,"NW_L_M1Q0Item3",TRUE);
        if(GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_SAMURAI,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_ARCHER,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_CW_SAMURAI,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_RANGER,oPC) > 0)
        {
            sItemTemplate = "NW_AARCL010"; // breastplate
        }
        else if(GetLevelByClass(CLASS_TYPE_BARD,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_SWASHBUCKLER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_CLERIC,oPC) > 0)
        {
            sItemTemplate = "NW_IT_MNECK024"; //amulet of will
        }
     /*   else if(GetLevelByClass(CLASS_TYPE_SORCERER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_PSION,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_WILDER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_WIZARD,oPC) > 0)
        {
            sItemTemplate = "NW_IT_MBELT011"; //archer's belt
        }*/
        else if(GetLevelByClass(CLASS_TYPE_DRUID,oPC) > 0)
        {
            sItemTemplate = "nw_aarcl012"; //chainshirt
        }
        else if(GetLevelByClass(CLASS_TYPE_ROGUE,oPC) > 0)
        {
            sItemTemplate = "NW_IT_MBOOTS010";
        }
        else
        {
            sItemTemplate = "NW_IT_MRING024"; // ring of fortitude
        }
        object oItem = CreateItemOnObject(sItemTemplate);
        SetIdentified(oItem,TRUE);
    }
}
