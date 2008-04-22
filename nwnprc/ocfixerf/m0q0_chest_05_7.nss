// Added compatibility for PRC base classes
#include "inc_debug"
#include "prc_class_const"

void main()
{
if(DEBUG) DoDebug("m0q0_chest_05_7 running");
    object oAttacker = GetLastAttacker();
    if(GetLocalInt(GetModule(), "NW_PROLOGUE_PLOT") != 99)
    {
        if(GetLevelByClass(CLASS_TYPE_BARBARIAN,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_BARD,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_FIGHTER,oAttacker) > 0 ||
	   GetLevelByClass(CLASS_TYPE_TRUENAMER,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_HEXBLADE,oAttacker) > 0 ||
	   GetLevelByClass(CLASS_TYPE_DUSKBLADE,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_ANTI_PALADIN,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_SCOUT,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_SOHEI,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_KNIGHT,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_SAMURAI,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_WARBLADE,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_SWORDSAGE,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_CRUSADER,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_ARCHER,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_BRAWLER,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_SOULKNIFE,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_PSYWAR,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_CW_SAMURAI,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_SWASHBUCKLER,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_MARSHAL,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_MONK,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_PALADIN,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER,oAttacker) > 0 ||
           GetLevelByClass(CLASS_TYPE_RANGER,oAttacker) > 0 )
        {
            SetLocalInt(GetModule(),"NW_G_M1Q0BMelee",TRUE);
            if(GetLocalInt(GetModule(),"NW_G_M1Q0BRanged"))
            {
                SetLocalInt(GetModule(),"NW_G_M0Q01_FIGHTER_TEST",2);
            }
        }
        else
        {
            SetLocalInt(GetModule(),"NW_G_M0Q01_NONFIGHTER_PASS2",TRUE);
        }
        AssignCommand(GetNearestObjectByTag("M1Q0BDendy"),SpeakOneLinerConversation());
    }
}
