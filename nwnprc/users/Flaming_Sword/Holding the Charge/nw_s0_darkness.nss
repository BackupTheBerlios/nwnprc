/*
    nw_s0_darkness

    Creates a globe of darkness around those in the area
    of effect.

    By: Preston Watamaniuk
    Created: Jan 7, 2002
    Modified: June 12, 2006

    Flaming_Sword: Added touch attack roll
*/

#include "prc_sp_func"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);
    object oItemTarget = oTarget;
    int iAttackRoll = 1;

    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {   //touch attack roll if target creature is hostile
        if(!GetIsReactionTypeFriendly(oTarget))
            iAttackRoll = PRCDoMeleeTouchAttack(oTarget);

        if (iAttackRoll > 0)
        {
            oItemTarget = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
            if(!GetIsObjectValid(oTarget))
            {
                //no armor, check other slots
                int i;
                for(i=0;i<14;i++)
                {
                    oItemTarget = GetItemInSlot(i, oTarget);
                    if(GetIsObjectValid(oTarget))
                        break;//end for loop
                }
            }
        }
    }
    int nCasterLvl = nCasterLevel;
    int  nDuration = nCasterLvl;//10min/level for PnP

    int nMetaMagic = PRCGetMetaMagicFeat();
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
       nDuration = nDuration *2;    //Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function
    //placeables get an effect
    //or if no equipment
    if(!GetPRCSwitch(PRC_PNP_DARKNESS))
    {
        if (iAttackRoll > 0)
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, GetLocation(oTarget), RoundsToSeconds(nDuration));
    }
    else if(GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE
        || !GetIsObjectValid(oItemTarget))
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, RoundsToSeconds(nDuration),TRUE,-1,nCasterLvl);
    else
    {
        //otherwise items get an IP
        itemproperty ipDarkness = ItemPropertyAreaOfEffect(IP_CONST_AOE_DARKNESS, nCasterLvl);
        IPSafeAddItemProperty(oItemTarget, ipDarkness, TurnsToSeconds(nDuration*10));
        //this applies the effects relating to it
        DelayCommand(0.1, VoidCheckPRCLimitations(oItemTarget, OBJECT_INVALID));
    }

    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    SPSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    SPSetSchool();
}