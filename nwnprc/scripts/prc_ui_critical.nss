#include "prc_alterations"
#include "inc_utility"

void main()
{
object oPC = OBJECT_SELF;
object oSkin = GetPCSkin(oPC);
itemproperty ipCritical = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS);
IPSafeAddItemProperty(oSkin, ipCritical);
}

