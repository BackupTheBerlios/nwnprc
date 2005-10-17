// Written by Stratovarius
// Turns Blood Component on and off.

//to avoid acidentally leaving it on, inscibe rune
//will automatically turn off after 1 minute
void DelayInscribeRuneDisable(object oPC)
{   
    if(GetLocalInt(oPC, "InscribeRune"))
    {
            DeleteLocalInt(oPC, "InscribeRune");
            string nMes = "*Inscribe Rune Deactivated*";
            FloatingTextStringOnCreature(nMes, oPC, FALSE); 
    }
}

void main()
{

     object oPC = OBJECT_SELF;
     string nMes = "";

     if(!GetLocalInt(oPC, "InscribeRune"))
     {    
            SetLocalInt(oPC, "InscribeRune", TRUE);
            nMes = "*Inscribe Rune Activated*";
            DelayInscribeRuneDisable(oPC);
     }
     else     
     {
            // Removes effects
            DeleteLocalInt(oPC, "InscribeRune");
            nMes = "*Inscribe Rune Deactivated*";
     }

     FloatingTextStringOnCreature(nMes, oPC, FALSE);
}