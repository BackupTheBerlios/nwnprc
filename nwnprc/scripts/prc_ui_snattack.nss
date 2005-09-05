#include "prc_alterations"
#include "inc_utility"

void main()
{
object oPC = OBJECT_SELF;
object oSkin = GetPCSkin(oPC);
itemproperty ipSneakAttack = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB);
IPSafeAddItemProperty(oSkin, ipSneakAttack);
}

