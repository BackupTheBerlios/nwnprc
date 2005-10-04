//::///////////////////////////////////////////////
//:: Deeper Darkness
//:: sp_deepdarkness.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
    As darkness but bigger & longer
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_alterations"

#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook



    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_DEEPER_DARKNESS);
    object oTarget = PRCGetSpellTargetObject();
    object oItemTarget = oTarget;
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
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
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int  nDuration = nCasterLvl*24;//1day/level

    int nMetaMagic = GetMetaMagicFeat();
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
    if(GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE
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

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}
