/*
    sp_deepdarkness

    Creates a globe of darkness around those in the area
    of effect.
    As darkness but bigger & longer

    By: Preston Watamaniuk
    Created: Jan 7, 2002
    Modified: Jul 1, 2006
*/

#include "prc_sp_func"
#include "prc_inc_itmrstr"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    effect eAOE = EffectAreaOfEffect(AOE_PER_DEEPER_DARKNESS);
    object oItemTarget = oTarget;
    int iAttackRoll = 1;    //placeholder
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
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
    int  nDuration = nCasterLvl*24;//1day/level

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
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, GetLocation(oTarget), RoundsToSeconds(nDuration));
    else if(GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE
        || !GetIsObjectValid(oItemTarget))
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, HoursToSeconds(nDuration),TRUE,-1,nCasterLvl);
    else
    {
        //otherwise items get an IP
        itemproperty ipDarkness = ItemPropertyAreaOfEffect(IP_CONST_AOE_DEEPER_DARKNESS, nCasterLvl);
        IPSafeAddItemProperty(oItemTarget, ipDarkness, HoursToSeconds(nDuration));
        //this applies the effects relating to it
        DelayCommand(0.1, VoidCheckPRCLimitations(oItemTarget, OBJECT_INVALID));
    }

    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
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
    PRCSetSchool();
}