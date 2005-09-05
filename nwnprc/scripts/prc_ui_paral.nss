#include "prc_alterations"
#include "inc_utility"

void main()
{
object oPC = OBJECT_SELF;
object oSkin = GetPCSkin(oPC);
itemproperty ipPara = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS);
IPSafeAddItemProperty(oSkin, ipPara);
}

