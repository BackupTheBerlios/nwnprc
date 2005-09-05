#include "prc_alterations"
#include "inc_utility"

void main()
{
object oPC = OBJECT_SELF;
object oSkin = GetPCSkin(oPC);
itemproperty ipMind = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS);
IPSafeAddItemProperty(oSkin, ipMind);
}

