/*
   ----------------
   prc_enforce_psi
   ----------------

   21/10/04 by Stratovarius

   This script is used to enforce the proper selection of bonus feats
   so that people cannot use epic bonus feats and class bonus feats to
   select feats they should not be allowed to. 
   
   Is also used to enforce the proper number of power selections.
*/


#include "prc_class_const"
#include "prc_feat_const"

// Totals all the powers a PC has
// to prevent them from getting extras
int TotalPCPowers(object oPC = OBJECT_SELF);

// Totals the number of powers a PC can have
// counts all 3 psionic base classes, in case
// they have decided to multi-class
int GetAllowedPowers(object oPC = OBJECT_SELF);

// Uses the numbers totalled in the two above
// functions to see whether a PC has too many
// powers, and if so, relevels them.
void PCPowerCheck(object oPC = OBJECT_SELF);

// Enforces the proper selection of the Psion feats
// that are used to determine discipline.
// You must have only one discipline.
void PsionDiscipline(object oPC = OBJECT_SELF);

// ---------------
// BEGIN FUNCTIONS
// ---------------

int TotalPCPowers(object oPC = OBJECT_SELF)
{
  int iPower;

  iPower =      GetHasFeat(FEAT_NOMAD_BALE_TELEPORT, oPC) + GetHasFeat(FEAT_TELEPATH_CRISIS_OF_LIFE, oPC) + 
  		GetHasFeat(FEAT_PSIONWILD_MIND_THRUST, oPC) + GetHasFeat(FEAT_PSIONWILD_BESTOW_POWER, oPC) + 
  		GetHasFeat(FEAT_ALL_BLACK_DRAGON_BREATH, oPC) + GetHasFeat(FEAT_PSIONWILD_CALL_TO_MIND, oPC) +
		GetHasFeat(FEAT_PSIONWILD_CRYSTAL_SHARD, oPC) + GetHasFeat(FEAT_ALL_BODY_ADJUSTMENT, oPC) +
		GetHasFeat(FEAT_TELEPATH_BRAIN_LOCK, oPC)+ GetHasFeat(FEAT_TELEPATH_CHARM_PERSON, oPC) +
		GetHasFeat(FEAT_ALL_DARKVISION, oPC) + GetHasFeat(FEAT_ALL_DAZE, oPC) + 
		GetHasFeat(FEAT_ALL_DECELERATION, oPC) + GetHasFeat(FEAT_ALL_DISINTEGRATE, oPC) + 
		GetHasFeat(FEAT_ALL_DISSIPATING_TOUCH, oPC) + GetHasFeat(FEAT_ALL_FORCE_SCREEN, oPC) +
		GetHasFeat(FEAT_ALL_INERTIAL_ARMOUR, oPC) + GetHasFeat(FEAT_PSIONWILD_PSIBLAST, oPC) +
		GetHasFeat(FEAT_PSIONWILD_RECALL_AGONY, oPC)+ GetHasFeat(FEAT_PSIONWILD_RECALL_DEATH, oPC) +
		GetHasFeat(FEAT_ALL_VIGOR, oPC) + GetHasFeat(FEAT_KINETICPSYWAR_INERTIAL_BARRIER, oPC) + 
		GetHasFeat(FEAT_EGOISTPSYWAR_THICK_SKIN, oPC) + GetHasFeat(FEAT_SHAPER_CRYSTALLIZE, oPC) +
		GetHasFeat(FEAT_PSYWAR_DISSOLVING_TOUCH, oPC) + GetHasFeat(FEAT_PSYWAR_EXHALATION_BLACKDRAG, oPC) +
		GetHasFeat(FEAT_PSYWAR_STEADFAST_PERCEPTION, oPC)+ GetHasFeat(FEAT_PSYWAR_STOMP, oPC) +		
		GetHasFeat(FEAT_ALL_CONCEAL_AMORPHA, oPC) + GetHasFeat(FEAT_SHAPERPSYWAR_GAMORPHA, oPC) +
		GetHasFeat(FEAT_PSIONWILD_BOLT, oPC) + GetHasFeat(FEAT_PSIONWILD_DEMORALIZE, oPC) +
		GetHasFeat(FEAT_PSIONWILD_DISABLE, oPC) + GetHasFeat(FEAT_ALL_DISTRACT, oPC) +		
		GetHasFeat(FEAT_ALL_EMPTYMIND, oPC) + GetHasFeat(FEAT_PSIONWILD_ENERGYRAY, oPC);		
		
	return iPower;

}

int GetAllowedPowers(object oPC = OBJECT_SELF)
{
	int nPsion = GetLevelByClass(CLASS_TYPE_PSION, oPC);
	int nPsychic = GetLevelByClass(CLASS_TYPE_PSYWARRIOR, oPC);
	int nWilder = GetLevelByClass(CLASS_TYPE_WILDER, oPC);
	int nTotal;
	int nPsiPowers;
	int nWarPowers;
	int nWildPowers;
	
	if (nPsion > 0)
	{
		switch (nPsion)
		{
			case 1: nPsiPowers = 3; break;
			case 2: nPsiPowers = 5; break;
			case 3: nPsiPowers = 7; break;
			case 4: nPsiPowers = 9; break;
			case 5: nPsiPowers = 11; break;
			case 6: nPsiPowers = 13; break;
			case 7: nPsiPowers = 15; break;
			case 8: nPsiPowers = 17; break;
			case 9: nPsiPowers = 19; break;
			case 10: nPsiPowers = 21; break;
			case 11: nPsiPowers = 22; break;
			case 12: nPsiPowers = 24; break;
			case 13: nPsiPowers = 25; break;
			case 14: nPsiPowers = 27; break;
			case 15: nPsiPowers = 28; break;
			case 16: nPsiPowers = 30; break;
			case 17: nPsiPowers = 31; break;
			case 18: nPsiPowers = 33; break;
			case 19: nPsiPowers = 34; break;
			case 20: nPsiPowers = 36; break;           
		}
		if (nPsion > 20) nPsiPowers = 36;
		nTotal += nPsiPowers;
	}
	
	if (nWilder > 0)
	{
		switch (nWilder)
		{
			case 1: nWildPowers = 1; break;
			case 2: nWildPowers = 2; break;
			case 3: nWildPowers = 2; break;
			case 4: nWildPowers = 3; break;
			case 5: nWildPowers = 3; break;
			case 6: nWildPowers = 4; break;
			case 7: nWildPowers = 4; break;
			case 8: nWildPowers = 5; break;
			case 9: nWildPowers = 5; break;
			case 10: nWildPowers = 6; break;
			case 11: nWildPowers = 6; break;
			case 12: nWildPowers = 7; break;
			case 13: nWildPowers = 7; break;
			case 14: nWildPowers = 8; break;
			case 15: nWildPowers = 8; break;
			case 16: nWildPowers = 9; break;
			case 17: nWildPowers = 9; break;
			case 18: nWildPowers = 10; break;
			case 19: nWildPowers = 10; break;
			case 20: nWildPowers = 11; break;           
		}
		if (nWilder > 20) nWildPowers = 11;
		nTotal += nWildPowers;
	}	
	
	if (nPsychic > 0)
	{
		switch (nPsychic)
		{
			case 1: nWarPowers = 1; break;
			case 2: nWarPowers = 2; break;
			case 3: nWarPowers = 3; break;
			case 4: nWarPowers = 4; break;
			case 5: nWarPowers = 5; break;
			case 6: nWarPowers = 6; break;
			case 7: nWarPowers = 7; break;
			case 8: nWarPowers = 8; break;
			case 9: nWarPowers = 9; break;
			case 10: nWarPowers = 10; break;
			case 11: nWarPowers = 11; break;
			case 12: nWarPowers = 12; break;
			case 13: nWarPowers = 13; break;
			case 14: nWarPowers = 14; break;
			case 15: nWarPowers = 15; break;
			case 16: nWarPowers = 16; break;
			case 17: nWarPowers = 17; break;
			case 18: nWarPowers = 18; break;
			case 19: nWarPowers = 19; break;
			case 20: nWarPowers = 20; break;           
		}
		if (nPsychic > 20) nWarPowers = 20;
		nTotal += nWarPowers;
	}	
	
	return nTotal;
}

void PCPowerCheck(object oPC = OBJECT_SELF)
{

	int nPsion = GetLevelByClass(CLASS_TYPE_PSION, oPC);
	int nPsychic = GetLevelByClass(CLASS_TYPE_PSYWARRIOR, oPC);
	int nWilder = GetLevelByClass(CLASS_TYPE_WILDER, oPC);
	
	if (nPsion > 0 || nPsychic > 0 || nWilder > 0)
	{
		int nAllowed = GetAllowedPowers(oPC);
		int nKnown = TotalPCPowers(oPC);
		FloatingTextStringOnCreature("Total Powers Allowed: " + IntToString(nAllowed), oPC, FALSE);
		FloatingTextStringOnCreature("Total Powers Known: " + IntToString(nKnown), oPC, FALSE);
		
	        if (nKnown > nAllowed)
	        {
	               int nHD = GetHitDice(oPC);
	               int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
	               int nOldXP = GetXP(oPC);
	               int nNewXP = nMinXPForLevel - 1000;
	               SetXP(oPC,nNewXP);
	               FloatingTextStringOnCreature("You have too many powers. Please reselect your feats.", oPC, FALSE);
	               DelayCommand(1.0, SetXP(oPC,nOldXP));
          	}
	}
	
	

}


void PsionDiscipline(object oPC = OBJECT_SELF)
{

     int nPsion = GetLevelByClass(CLASS_TYPE_PSION, oPC);
     int nDisc;

     if (nPsion > 0)
     {
          nDisc    += 	 (GetHasFeat(FEAT_PSION_DIS_EGOIST, oPC))
                   +     (GetHasFeat(FEAT_PSION_DIS_KINETICIST, oPC))
                   +     (GetHasFeat(FEAT_PSION_DIS_NOMAD, oPC))
                   +     (GetHasFeat(FEAT_PSION_DIS_SEER, oPC))
                   +     (GetHasFeat(FEAT_PSION_DIS_SHAPER, oPC))
                   +     (GetHasFeat(FEAT_PSION_DIS_TELEPATH, oPC));


          if (nDisc != 1)
          {
               int nHD = GetHitDice(oPC);
               int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
               int nOldXP = GetXP(oPC);
               int nNewXP = nMinXPForLevel - 1000;
               SetXP(oPC,nNewXP);
               FloatingTextStringOnCreature("You may only have 1 Discipline. Please reselect your feats.", oPC, FALSE);
               DelayCommand(1.0, SetXP(oPC,nOldXP));
          }
     }
}


void main()
{
     //Declare Major Variables
     object oPC = OBJECT_SELF;

     PsionDiscipline(oPC);
     PCPowerCheck(oPC);
}