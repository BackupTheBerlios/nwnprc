#include "x2_inc_itemprop"
#include "inc_item_props"

void main()
{
object oPC = OBJECT_SELF;
object oSkin = GetPCSkin(oPC);
itemproperty ipSneakAttack = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB);
IPSafeAddItemProperty(oSkin, ipSneakAttack);
}

