/* 
   ----------------
   prc_psi_ppoints
   ----------------
   
   19/10/04 by Stratovarius
   
   Calculates the power point allotment of each class.
   Psion, Psychic Warrior, Wilder. (Soulknife does not have Power Points)
*/

#include "prc_feat_const"
#include "prc_class_const"

// Returns Bonus Power Points gained from Abilities
int GetModifierPP (object oCaster = OBJECT_SELF);

// Returns Psion Power Points
int GetPsionPP (object oCaster = OBJECT_SELF);

// Returns Psychic Warrior Power Points
int GetPsychicPP (object oCaster = OBJECT_SELF);

// Returns Wilder Power Points
int GetWilderPP (object oCaster = OBJECT_SELF);

// Returns Total Power Points
int GetTotalPP (object oCaster = OBJECT_SELF);

// ---------------
// BEGIN FUNCTIONS
// ---------------

int GetModifierPP (object oCaster)
{
   int nPP;
   int nBonus;
   int nPsion = GetLevelByClass(CLASS_TYPE_PSION, oCaster);
   int nPsychic = GetLevelByClass(CLASS_TYPE_PSYWARRIOR, oCaster);
   int nWilder = GetLevelByClass(CLASS_TYPE_WILDER, oCaster);
   
   if (nPsion > 0)
   {
   	nBonus = (nPsion * GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster)) / 2;
   	nPP = nBonus + nPP;
   }
   if (nPsychic > 0)
   {
   	nBonus = (nPsychic * GetAbilityModifier(ABILITY_WISDOM, oCaster)) / 2;
   	nPP = nBonus + nPP;
   }   
   if (nWilder > 0)
   {
   	nBonus = (nWilder * GetAbilityModifier(ABILITY_CHARISMA, oCaster)) / 2;
   	nPP = nBonus + nPP;
   }
   
   return nPP;
}

int GetPsionPP (object oCaster)
{
   int nPP;
   int nClass = GetLevelByClass(CLASS_TYPE_PSION, oCaster);
   switch (nClass)
   {
           case 1: nPP = 2; break;
           case 2: nPP = 6; break;
           case 3: nPP = 11; break;
           case 4: nPP = 17; break;
           case 5: nPP = 25; break;
           case 6: nPP = 35; break;
           case 7: nPP = 46; break;
           case 8: nPP = 58; break;
           case 9: nPP = 72; break;
           case 10: nPP = 88; break;
           case 11: nPP = 106; break;
           case 12: nPP = 126; break;
           case 13: nPP = 147; break;
           case 14: nPP = 170; break;
           case 15: nPP = 195; break;
           case 16: nPP = 221; break;
           case 17: nPP = 250; break;
           case 18: nPP = 280; break;
           case 19: nPP = 311; break;
           case 20: nPP = 343; break;           
    }
    if (nClass > 20) nPP = 343;
    
    return nPP;
}

int GetPsychicPP (object oCaster)
{
   int nPP;
   int nClass = GetLevelByClass(CLASS_TYPE_PSYWARRIOR, oCaster);
   switch (nClass)
   {
           case 1: nPP = 0; break;
           case 2: nPP = 1; break;
           case 3: nPP = 3; break;
           case 4: nPP = 5; break;
           case 5: nPP = 7; break;
           case 6: nPP = 11; break;
           case 7: nPP = 15; break;
           case 8: nPP = 19; break;
           case 9: nPP = 23; break;
           case 10: nPP = 27; break;
           case 11: nPP = 35; break;
           case 12: nPP = 43; break;
           case 13: nPP = 51; break;
           case 14: nPP = 59; break;
           case 15: nPP = 67; break;
           case 16: nPP = 79; break;
           case 17: nPP = 91; break;
           case 18: nPP = 103; break;
           case 19: nPP = 115; break;
           case 20: nPP = 127; break;           
    }
    if (nClass > 20) nPP = 127;
    
    return nPP;
}

int GetWilderPP (object oCaster)
{
   int nPP;
   int nClass = GetLevelByClass(CLASS_TYPE_WILDER, oCaster);
   switch (nClass)
   {
           case 1: nPP = 2; break;
           case 2: nPP = 6; break;
           case 3: nPP = 11; break;
           case 4: nPP = 17; break;
           case 5: nPP = 25; break;
           case 6: nPP = 35; break;
           case 7: nPP = 46; break;
           case 8: nPP = 58; break;
           case 9: nPP = 72; break;
           case 10: nPP = 88; break;
           case 11: nPP = 106; break;
           case 12: nPP = 126; break;
           case 13: nPP = 147; break;
           case 14: nPP = 170; break;
           case 15: nPP = 195; break;
           case 16: nPP = 221; break;
           case 17: nPP = 250; break;
           case 18: nPP = 280; break;
           case 19: nPP = 311; break;
           case 20: nPP = 343; break;           
    }
    if (nClass > 20) nPP = 343;
    
    return nPP;
}

int GetTotalPP (object oCaster)
{
    //Variables
    int nPP;
   
    nPP		  += GetPsionPP(oCaster)
    		  +  GetPsychicPP(oCaster)
      		  +  GetWilderPP(oCaster);
      		  
    if (nPP > 343) nPP = 343;
      		  
    nPP = nPP + GetModifierPP(oCaster);
    
    return nPP;
}


void main()
{
    object oCaster = OBJECT_SELF;
    int nPP = GetTotalPP(oCaster);
    SetLocalInt(oCaster, "PowerPoints", nPP);
    if (nPP != 0) 
        FloatingTextStringOnCreature("Power Points Remaining: " + IntToString(nPP), oCaster, FALSE);
}