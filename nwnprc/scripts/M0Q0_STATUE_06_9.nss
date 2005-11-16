// Added compatibility for PRC base classes
#include "prc_class_const"


//* Check to see if a spell was cast at the statue, which will destroy it and
void main()
{
    object oCaster = GetLastSpellCaster();
    if(GetLevelByClass(CLASS_TYPE_BARD,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_SORCERER,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_WILDER,oCaster) > 0 ||
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
