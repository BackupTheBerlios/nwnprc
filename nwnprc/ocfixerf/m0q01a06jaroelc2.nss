// Added compatibility for PRC base classes
#include "prc_class_const"
#include "inc_utility"

// Remember to update the TLK whenever new base classes are added to Jaroo's test

void main()
{
DoDebug("m0q01a06jaroelc2 running");
    if(GetLevelByClass(CLASS_TYPE_PSION,  GetPCSpeaker()) > 0 ||
       GetLevelByClass(CLASS_TYPE_PSYWAR, GetPCSpeaker()) > 0 ||
       GetLevelByClass(CLASS_TYPE_WILDER, GetPCSpeaker()) > 0
       )
        // "PRC note: Though Jaroo will not say so, you may pass his test by using a spell or a power to destroy the statue."
        FloatingTextStrRefOnCreature(0x01000000 + 49455 , GetPCSpeaker(), FALSE);

    SetLocalInt(OBJECT_SELF,"NW_L_TALKLEVEL",2);
}

