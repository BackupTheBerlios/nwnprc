/*
    prc_sp_event

    Script for implementing holding the charge
        touch attacks

    By: Flaming_Sword
    Created: February 2, 2006
    Modified: February 12, 2006
*/

#include "prc_sp_func"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nID = GetSpellId();

    if(nID == SPELLS_SPELLS_TOUCH_ATTACK || nID == SPELLS_SPELLS_RANGED_ATTACK)
    {
        int nCharges = GetLocalInt(oPC, PRC_SPELL_CHARGE_COUNT);
        if(nCharges > 0)//sanity check
        {
            int nSpellID = GetLocalInt(oPC, PRC_SPELL_CHARGE_SPELLID);
            if(!IsTouchSpell(nSpellID) && nID == SPELLS_SPELLS_TOUCH_ATTACK)
                SendMessageToPC(oPC, "This is not a touch spell");  //sanity check
            else if(IsTouchSpell(nSpellID) && nID == SPELLS_SPELLS_RANGED_ATTACK)
                SendMessageToPC(oPC, "This is not a ranged spell");  //sanity check
            else
                RunSpellScript(oPC, nSpellID, PRC_SPELL_EVENT_ATTACK);
        }
        else
            SendMessageToPC(oPC, "You have no charges remaining");
    }
    else if(nID == SPELLS_SPELLS_CONCENTRATION_TARGET)
    {
        SetLocalObject(oPC, PRC_SPELL_CONC_TARGET, oTarget);
        FloatingTextStringOnCreature("*Target Selected*", oPC);
    }
    else if (nID == SPELLS_SPELLS_HOLD_CHARGE_TOGGLE)
    {
        int nState = GetLocalInt(oPC, PRC_SPELL_HOLD);
        if(nState)
            FloatingTextStringOnCreature("*Normal Casting*", oPC);
        else
            FloatingTextStringOnCreature("*Holding the Charge*", oPC);

        SetLocalInt(oPC, PRC_SPELL_HOLD, !nState);
    }
}