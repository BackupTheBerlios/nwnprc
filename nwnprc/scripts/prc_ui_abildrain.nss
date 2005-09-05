#include "prc_alterations"
#include "inc_utility"


void main()
{
object oPC = OBJECT_SELF;
object oSkin = GetPCSkin(oPC);
float fDuration = 0.0f;
itemproperty ipAbilDrain = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN);
IPSafeAddItemProperty(oSkin, ipAbilDrain);
}

