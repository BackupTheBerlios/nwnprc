#include "prc_feat_const"
#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;

    if(GetLocalInt(oPC, "PsionicFocus"))
    {
        SendMessageToPC(oPC, "You are already Psionically Focused.");
        GainPsionicFocus(oPC); // Recheck the bonuses associated with Psionic Focus
        return;
    }
    
    int nDC = 20;
    if(GetHasFeat(FEAT_NARROW_MIND, oPC))         nDC -= 4;
    if(GetHasFeat(FEAT_COMBAT_MANIFESTATION, oPC) nDC += 4; // Hack to avoid granting bonus from Combat manifestation where it should not be
    
    if(GetIsSkillSuccessful(oPC, SKILL_CONCENTRATION, nDC))
    {
        SendMessageToPC(oPC, "You are now Psionically Focused.");
        GainPsionicFocus(oPC);
    }
    else
        SendMessageToPC(oPC, "You failed to become Psionically Focused.");
}
 