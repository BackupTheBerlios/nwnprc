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
#include "prc_inc_sp_tch"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    if (!PreInvocationCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    
    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);
    object oItemTarget = oTarget;
    int iAttackRoll = 1;

    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {   //touch attack roll if target creature is not an ally
        if(!spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
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
}