// Added compatibility for PRC base classes
#include "prc_alterations"
#include "inc_utility"

//* Check to see if a spell was cast at the statue, which will destroy it and
void main()
{
if(DEBUG) DoDebug("m0q0_statue_06_9 running");
    object oCaster = GetLastSpellCaster();
    if(GetLevelByClass(CLASS_TYPE_BARD,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_SORCERER,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_WILDER,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_SWORDSAGE,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_WARLOCK,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_SHUGENJA,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_WARMAGE,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_DUSKBLADE,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_PSYWAR,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_PSION,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_WIZARD,oCaster) > 0)
    {
        effect eDeath = EffectDeath(TRUE);
        SetPlotFlag(OBJECT_SELF,FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,OBJECT_SELF);
        SetLocalInt(GetModule(),"NW_G_M0Q01_MAGE_TEST",2);
        AssignCommand(GetNearestObjectByTag("M1Q0BJaroo"),
                      SpeakOneLinerConversation());
    }
}
