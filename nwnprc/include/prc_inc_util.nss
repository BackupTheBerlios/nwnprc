
///////////////////////////////////////////////////////////////////////////////
//  FUNCTION DECLARATIONS
///////////////////////////////////////////////////////////////////////////////

// Returns the number of henchmen a player has.
int GetNumHenchmen(object oPC);

float MetersToFeet(float fMeters);
///////////////////////////////////////////////////////////////////////////////
//  FUNCTION DEFINITIONS
///////////////////////////////////////////////////////////////////////////////

int GetNumHenchmen(object oPC)
{
     if (!GetIsPC(oPC)) return -1;

     int nLoop, nCount;
     for (nLoop = 1; nLoop <= GetMaxHenchmen(); nLoop++)
     {
          if (GetIsObjectValid(GetHenchman(oPC, nLoop)))
          nCount++;
     }
     
     return nCount;
}

float MetersToFeet(float fMeters)
{
     fMeters *= 3.281;
     return fMeters;
}