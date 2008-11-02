//::///////////////////////////////////////////////
//:: Sohei
//:: prc_sohei.nss
//:://////////////////////////////////////////////
//:: Applies the passive bonuses from sohei
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sept 11, 2006
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "x0_i0_modes"

void SoheiDamageResist(object oPC, object oSkin, int nLevel)
{
    if(GetLocalInt(oSkin, "SoheiDamageResist") == TRUE) return;
    
    int nDR;
    if (nLevel >= 38) nDR = IP_CONST_DAMAGERESIST_10;
    else if (nLevel >= 35) nDR = IP_CONST_DAMAGERESIST_9;
    else if (nLevel >= 32) nDR = IP_CONST_DAMAGERESIST_8;
    else if (nLevel >= 29) nDR = IP_CONST_DAMAGERESIST_7;
    else if (nLevel >= 26) nDR = IP_CONST_DAMAGERESIST_6;
    else if (nLevel >= 23) nDR = IP_CONST_DAMAGERESIST_5;
    else if (nLevel >= 20) nDR = IP_CONST_DAMAGERESIST_4;
    else if (nLevel >= 17) nDR = IP_CONST_DAMAGERESIST_3;
    else if (nLevel >= 14) nDR = IP_CONST_DAMAGERESIST_2;
    else if (nLevel >= 11) nDR = IP_CONST_DAMAGERESIST_1;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PIERCING, nDR), oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SLASHING, nDR), oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_BLUDGEONING, nDR), oSkin);
    SetLocalInt(oSkin, "SoheiDamageResist", TRUE);
}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nSoh = GetLevelByClass(CLASS_TYPE_SOHEI, oPC);
    object oWeap = GetItemLastEquipped();
    object oUnequip = GetItemLastUnequipped();
    int nEvent = GetRunningEvent();
    

    if(nSoh >= 3) SoheiDamageResist(oPC, oSkin, nSoh);
    if(nSoh >= 5)
    {
    	// Gains immunity to stunning
    	// Can't be done as an iprop, so we effect bomb
    	effect eStun = EffectImmunity(IMMUNITY_TYPE_STUN);
    	effect eSleep = EffectImmunity(IMMUNITY_TYPE_SLEEP);
    	// No Dispelling, and no going away on rest
    	eStun = EffectLinkEffects(eStun, eSleep);
    	eStun = SupernaturalEffect(eStun);
    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStun, oPC);
    }
    
    //Defensive Strike
    if(nEvent == FALSE && nSoh >= 7)
    {
        oPC = OBJECT_SELF;
        if(DEBUG) DoDebug("prc_sohei: Adding eventhooks");

        AddEventScript(oPC, EVENT_ONHEARTBEAT,   "prc_sohei", TRUE, FALSE);
    }
    // We're being called from the OnHeartbeat eventhook, so check or skip
    else if(nEvent == EVENT_ONHEARTBEAT)
    {
        // Only applies when using expertise
        if(GetModeActive(ACTION_MODE_EXPERTISE))
        {
       		effect eAtk = EffectAttackIncrease(4);
       		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAtk, oPC, 6.0);
        }
    }// end if - Running OnHeart event       
}
