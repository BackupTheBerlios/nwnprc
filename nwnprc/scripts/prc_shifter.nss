//::///////////////////////////////////////////////
//:: Name        Shifter evaluation
//:: FileName    prc_shifter.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// Fills in some default critters from the shifterlist.2da file

// Called by the EvalPRC function

#include "pnp_shifter"


void main()
{
    // being called by EvalPRCFeats
    object oPC = OBJECT_SELF;

    int nShifterLevel = GetLevelByClass(CLASS_TYPE_PNP_SHIFTER,oPC);
 
    if (!GetLocalInt(oPC,"SHIFTOnEnterHit"))
    {
        object oHidePC = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);

        // If we are entering a module, we have been stripped of the skin
        // and our powers are gone, shift back to true form so we dont confuse the player
        if ( (GetTrueForm(oPC) != GetAppearanceType(oPC)) && 
             !(GetLocalInt(oHidePC,"nPCShifted")) )
        {
            SetShiftTrueForm(oPC);
            // Set a local on the pc so we dont have to do this more than once
	    SetLocalInt(oPC,"SHIFTOnEnterHit",1);
        }
    }

//SendMessageToPC(oPC,"ShifterLevel = " + IntToString(nShifterLevel));
//SendMessageToPC(oPC,"ShifterDefaultListLevel = " + IntToString(GetLocalInt(oPC,"ShifterDefaultListLevel")));
    // Make sure we are not doing this io intesive loop more than once per level
    if (nShifterLevel <= GetLocalInt(oPC,"ShifterDefaultListLevel"))
	return;

    string sShifterFile = "shifterlist";
    string sCreatureResRef = "";
    string sShifterLevel = "0";
    int i = 0;
    int nShiftLevelFile = 0;
    
    while(sShifterLevel != "")
    {
        sShifterLevel = Get2DAString(sShifterFile,"SLEVEL",i);
//SendMessageToPC(oPC,"sShifterLevel = " + sShifterLevel);
        nShiftLevelFile = StringToInt(sShifterLevel);
        if ((nShiftLevelFile <= nShifterLevel) && (sShifterLevel != ""))
        {
		// The creature is a standard that we apply to the shifters spark of life list
		sCreatureResRef = Get2DAString(sShifterFile,"CResRef",i);
		RecognizeCreature( oPC, sCreatureResRef);
//SendMessageToPC(oPC,"Creature Added = " + sCreatureResRef);
        }
	i++;
    }

    // Set a local on the PC so we dont do this more than once per level
    SetLocalInt(oPC,"ShifterDefaultListLevel",nShifterLevel);

    return;
}
