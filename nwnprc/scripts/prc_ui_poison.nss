#include "prc_alterations"
#include "inc_utility"

void main()
{
object oPC = OBJECT_SELF;
object oSkin = GetPCSkin(oPC);
itemproperty ipPoison = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);
IPSafeAddItemProperty(oSkin, ipPoison);
}

