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


// Enforces the proper selection of the Psion feats
// that are used to determine discipline.
// You must have only one discipline.
void PsionDiscipline(object oPC = OBJECT_SELF);


// ---------------
// BEGIN FUNCTIONS
// ---------------

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
}