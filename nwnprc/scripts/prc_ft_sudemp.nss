//::///////////////////////////////////////////////
//:: Sudden Empower
//:: prc_ft_sudemp.nss
//:://////////////////////////////////////////////
//:: Applies Empower to next spell cast.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 24/06/2007
//:://////////////////////////////////////////////

void main()
{

	object oPC = OBJECT_SELF;
	SetLocalInt(oPC, "SuddenMetaEmpower", TRUE);
	FloatingTextStringOnCreature("Sudden Empower Activated", oPC, FALSE);
}