#include "x2_inc_itemprop"
#include "inc_item_props"

void main()
{
object oPC = OBJECT_SELF;
object oSkin = GetPCSkin(oPC);
itemproperty ipPara = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS);
IPSafeAddItemProperty(oSkin, ipPara);
}

