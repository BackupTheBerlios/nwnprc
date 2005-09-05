// Written by Stratovarius
// Turns Blood Component on and off.

void main()
{

     object oPC = OBJECT_SELF;
     string nMes = "";

     if(!GetLocalInt(oPC, "RuneUsesPerDay"))
     {    
     	if (GetLocalInt(oPC, "RuneCharges"))
     	{
     		DeleteLocalInt(oPC, "RuneCharges");
     		FloatingTextStringOnCreature("*Charges Deactivated*", oPC, FALSE);
     	}     
	SetLocalInt(oPC, "RuneUsesPerDay", TRUE);
     	nMes = "*Uses Per Day Activated*";
     }
     else     
     {
	// Removes effects
	DeleteLocalInt(oPC, "RuneUsesPerDay");
	nMes = "*Uses Per Day Deactivated*";
     }

     FloatingTextStringOnCreature(nMes, oPC, FALSE);
}