#include "prc_drnknmstr"
#include "prcl_const_class"
#include "prcl_const_feat"

void main()
{
object oPC = OBJECT_SELF;

//see if player is already in a drunken rage:
if(GetLocalInt(oPC, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE") != 0)
    {
    FloatingTextStringOnCreature("You are already in a Drunken Rage", oPC);
    return;
    }

float fSec;

if(GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oPC) > 9)
    {
    // Set duration to 3 hours:
    fSec = HoursToSeconds(3);
    SetLocalInt(oPC, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE", 1);
    DelayCommand(fSec, SetLocalInt(oPC, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE", 0));
    }
else
    {
    // Otherwise set duration to 1 hour:
    fSec = HoursToSeconds(1);
    SetLocalInt(oPC, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE", 1);
    DelayCommand(fSec, SetLocalInt(oPC, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE", 0));
    }

//Bonuses:
effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
effect eCst = EffectAbilityIncrease(ABILITY_CONSTITUTION, 4);
effect eWillSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 2);

//Penalties:
effect eAC = EffectACDecrease(2);

//Visual Effects:
effect eVFX2 = EffectVisualEffect(VFX_DUR_BLUR);
effect eVFX3  = EffectVisualEffect(VFX_DUR_AURA_FIRE);

ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStr, oPC, fSec);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCst, oPC, fSec);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWillSave, oPC, fSec);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, fSec);

ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX2, oPC, fSec);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX3, oPC, fSec);

FloatingTextStringOnCreature("Drunken Rage Activated", oPC);
}
