#include "prc_inc_function"
#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    if (GetLocalInt(oSkin, "PsionicFocus") == 0)
    {
        SendMessageToPC(oPC, "You must be psionically focused to use this feat");
        return;
    }

    effect eJump = EffectSkillIncrease(SKILL_JUMP, 10);
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eJump, oPC, 12.0);
    SetLocalInt(oSkin, "PsionicFocus", 0);
}
   