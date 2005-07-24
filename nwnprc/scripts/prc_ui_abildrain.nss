#include "x2_inc_itemprop"
#include "inc_item_props"


void main()
{
object oPC = OBJECT_SELF;
object oSkin = GetPCSkin(oPC);
float fDuration = 0.0f;
itemproperty ipAbilDrain = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN);
IPSafeAddItemProperty(oSkin, ipAbilDrain);
}

