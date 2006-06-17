/*
    prc_sp_func

    Additional spell functions, including holding the
        charge and concentration spells

    By: Flaming_Sword
    Created: January 31, 2006   *complete rewrite
    Modified: May 3, 2006

    From Player's Handbook 3.5ed p141:

    Holding the Charge: If you don't discharge the
        spell in the round when you cast the sepll,
        you can hold the discharge of the spell
        (hold the charge) indefinitely. You can
        continue to make touch attacks round after
        round. You can touch one friend as a standard
        action or up to six friends as a full-round
        action. If you touch anything or anyone while
        holding a charge, even unintentionally, the
        spell discharges. If you cast another spell,
        the touch spell dissipates. Alternatively, you
        may make a normal unarmed attack (or an attack
        with a natural weapon) while holding a charge.
        In this case you aren't considered armed and you
        provoke attacks of opportunity as normal for
        the attack. (If your unarmed attacks or natural
        weapon attack doesn't provoke attacks of
        opportunity, neither dies this attack. If the
        attack hits, you deal normal damage for your
        unarmed attack or natural weapon and the spell
        discharges. If the attack misses, you are still
        holding the charge.

    Conclusion:
        Holy crap! Charges stay if your touch attacks miss!

    FEATURES:
        Stores data for a spell (ranged attack defaulted
            to medium range) and concentration
            spell (with target)


    LIMITATIONS:
        Currently only supports one valid target
            for all spells

    IMPLEMENTATION:
        Run as thread for caster?

        Local int for spellid
        Local int for number of charges
        Local object for target object

        Variables must be deleted on rest

        Needs new feat(s) for changing targets

    USE:
        Modify new and existing spell/power scripts


NOTE: Code can be put in functions to avoid duplication

NOTES TO SELF:

*/

#include "prc_alterations"
#include "psi_inc_manifest"
#include "spinc_common"

//constant declarations in case they change
const string PRC_SPELL_CHARGE_COUNT             = "PRC_SPELL_CHARGE_COUNT";
const string PRC_SPELL_CHARGE_SPELLID           = "PRC_SPELL_CHARGE_SPELLID";
const string PRC_SPELL_CONC_TARGET              = "PRC_SPELL_CONC_TARGET";

const string PRC_POWER_HOLD_MANIFESTATION       = "PRC_POWER_HOLD_MANIFESTATION";

const string PRC_SPELL_EVENT                    = "PRC_SPELL_EVENT";

const string PRC_SPELL_HOLD                     = "PRC_SPELL_HOLD";

const int PRC_SPELL_EVENT_NONE                  = 0;
const int PRC_SPELL_EVENT_ATTACK                = 1;
const int PRC_SPELL_EVENT_CONCENTRATION         = 2;

const int FEAT_SPELLS_TOUCH_ATTACK              = 4092;
const int FEAT_SPELLS_RANGED_ATTACK             = 4093;
const int FEAT_SPELLS_CONCENTRATION_TARGET      = 4094;
const int FEAT_SPELLS_HOLD_CHARGE_TOGGLE        = 4095;

const int SPELLS_SPELLS_TOUCH_ATTACK            = 3042;
const int SPELLS_SPELLS_RANGED_ATTACK           = 3043;
const int SPELLS_SPELLS_CONCENTRATION_TARGET    = 3044;
const int SPELLS_SPELLS_HOLD_CHARGE_TOGGLE      = 3045;

//Deletes local variables used for spell functions
//  To be called (or copied) on rest, from spellhook
void CleanSpellVariables(object oPC)
{
    DeleteLocalInt(oPC, PRC_SPELL_CHARGE_COUNT);
    DeleteLocalInt(oPC, PRC_SPELL_CHARGE_SPELLID);
    DeleteLocalObject(oPC, PRC_SPELL_CONC_TARGET);
    DeleteLocalInt(oPC, PRC_SPELL_HOLD);
    DeleteLocalManifestation(oPC, PRC_POWER_HOLD_MANIFESTATION);
}

//Returns whether a spell is a touch spell
//  nSpellID, the spell id (row in spells.2da) of the spell
int IsTouchSpell(int nSpellID)
{
    return (Get2DACache("spells", "Range", nSpellID) == "T");
}

//Sets local variables for the new spell functions
//  object oCaster, the caster of the spell
//  int nCharges, the number of charges for a spell
//  int nSpellIDOverride, for overriding a SpellID
void SetLocalSpellVariables(object oCaster, int nCharges = 1, int nSpellIDOverride = -1)
{
    int nTemp = (nSpellIDOverride == -1) ? GetSpellId() : nSpellIDOverride;
    SetLocalInt(oCaster, PRC_SPELL_CHARGE_SPELLID, nTemp);
    SetLocalInt(oCaster, PRC_SPELL_CHARGE_COUNT, nCharges);
    FloatingTextStringOnCreature("*Holding the Charge*", oCaster);
}

//Decrements the number of spell charges
//  object oPC, the subject losing a charge
void DecrementSpellCharges(object oPC)
{
    int nCharges= GetLocalInt(oPC, PRC_SPELL_CHARGE_COUNT);
    SetLocalInt(oPC, PRC_SPELL_CHARGE_COUNT, nCharges - 1);
    FloatingTextStringOnCreature("Charges Remaining: " + IntToString(nCharges - 1), oPC);
}

//Called from scripts, will run a spell script with local int for flags
//  NOTE: Flags must be interpreted by the spell script
//  This lets spell scripts handle events the way they want
//
//  object oPC, the subject running the script
//  int nSpellID, the spellid of the spell to run
//  int nEventType, an integer containing flags defining events to use
void RunSpellScript(object oPC, int nSpellID, int nEventType)
{
    //string sScript = Get2DACache("spells", "ImpactScript", nSpellID);
    SetLocalInt(oPC, PRC_SPELL_EVENT, nEventType);
    ActionCastSpell(nSpellID);
    DelayCommand(0.3, DeleteLocalInt(oPC, PRC_SPELL_EVENT));
}

