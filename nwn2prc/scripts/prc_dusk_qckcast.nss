// Written by Stratovarius
// Turns Quick Cast on

void main()
{
     object oPC = OBJECT_SELF;
     SetLocalInt(oPC, "DBQuickCast", TRUE);
     FloatingTextStringOnCreature("*Quick Cast Activated*", oPC, FALSE);
}