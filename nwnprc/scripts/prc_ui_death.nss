#include "prc_alterations"
#include "inc_utility"

void main()
{
object oPC = OBJECT_SELF;
object oSkin = GetPCSkin(oPC);
itemproperty ipDeath = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DEATH_MAGIC);
IPSafeAddItemProperty(oSkin, ipDeath);
}
