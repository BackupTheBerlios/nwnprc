#include "prc_alterations"
#include "prc_inc_smite"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    DoSmite(oPC, oTarget, SMITE_TYPE_KIAI);
}