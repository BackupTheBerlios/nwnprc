/*
   ----------------
   prc_enforce_psi
   ----------------

   21/10/04 by Stratovarius

   This script is used to enforce the proper selection of bonus feats
   so that people cannot use epic bonus feats and class bonus feats to
   select feats they should not be allowed to. 
   
   Is also used to enforce the proper discipline selection.
*/


#include "prc_class_const"
#include "prc_feat_const"
#include "psi_inc_psifunc"

string PLEASE_RESELECT = GetStringByStrRef(16826471); //"Please reselect your feats."

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
               SetXP(oPC,nNewXP);         //You may only have 1 Discipline.
               FloatingTextStringOnCreature(GetStringByStrRef(16826470) + " " + PLEASE_RESELECT, oPC, FALSE);
               DelayCommand(1.0, SetXP(oPC,nOldXP));
          }
     }
}

void AntiPsionicFeats(object oPC)
{
    int bHasAntiPsionicFeats = FALSE,
        bRelevel             = FALSE,
        bFirst               = 1;
    string sFeats = "";

    if(GetHasFeat(FEAT_CLOSED_MIND))        { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826422); }
    if(GetHasFeat(FEAT_FORCE_OF_WILL))      { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826424); }
    if(GetHasFeat(FEAT_HOSTILE_MIND))       { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826426); }
    if(GetHasFeat(FEAT_MENTAL_RESISTANCE))  { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826428); }
    if(GetHasFeat(FEAT_PSIONIC_HOLE))       { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826430); }
    //if(GetHasFeat())      { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(); }

    if(bRelevel)
    {
        int nHD = GetHitDice(oPC);
        int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
        int nOldXP = GetXP(oPC);
        int nNewXP = nMinXPForLevel - 1000;
        SetXP(oPC,nNewXP);         //You are a psionic character and may not take        
        FloatingTextStringOnCreature(GetStringByStrRef(16826473) + " " + sFeats + ". " + PLEASE_RESELECT, oPC, FALSE);
        DelayCommand(1.0, SetXP(oPC,nOldXP));
    }
}    

void PsionicFeats(object oPC)
{
    int bRelevel = FALSE,
        bFirst   = 1;
    string sFeats = "";
    
    
    //if(GetHasFeat(FEAT_BOOST_CONSTRUCT))              { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826476); }
    //if(GetHasFeat(FEAT_COMBAT_MANIFESTATION))         { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826432); }
    if(GetHasFeat(FEAT_MENTAL_LEAP))                  { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826434); }
    // Only check for the first Metamorphic Transfer feat... If some source forces one of the other feats on the char, nothing releveling could do about it, anyway
    if(GetHasFeat(FEAT_METAMORPHIC_TRANSFER_1))       { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(-1/*FIXME*/); }
    if(GetHasFeat(FEAT_NARROW_MIND))                  { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826436); }
    //if(GetHasFeat(FEAT_OVERCHANNEL))                  { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826478); }
    //if(GetHasFeat(FEAT_TALENTED))                     { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826500); }
    //if(GetHasFeat(FEAT_POWER_PENETRATION))            { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826438); }
    //if(GetHasFeat(FEAT_GREATER_POWER_PENETRATION))    { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826440); }
    //if(GetHasFeat(FEAT_POWER_SPECIALIZATION))         { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826446); }
    //if(GetHasFeat(FEAT_GREATER_POWER_SPECIALIZATION)) { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826448); }
    if(GetHasFeat(FEAT_PSIONIC_DODGE))                { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826450); }
    //if(GetHasFeat(FEAT_PSIONIC_ENDOWMENT))            { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826452); }
    //if(GetHasFeat(FEAT_GREATER_PSIONIC_ENDOWMENT))    { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826454); }
    if(GetHasFeat(FEAT_PSIONIC_FIST))                 { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826456); }
    if(GetHasFeat(FEAT_GREATER_PSIONIC_FIST))         { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826458); }
    if(GetHasFeat(FEAT_UNAVOIDABLE_STRIKE))           { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(-1/*FIXME*/); }
    if(GetHasFeat(FEAT_PSIONIC_MEDITATION))           { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(-1/*FIXME*/); }
    if(GetHasFeat(FEAT_PSIONIC_SHOT))                 { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826464); }
    if(GetHasFeat(FEAT_GREATER_PSIONIC_SHOT))         { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826466); }
    // Only check for the first Psionic Talent feat
    if(GetHasFeat(FEAT_PSIONIC_TALENT_1))             { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826488); }
    if(GetHasFeat(FEAT_PSIONIC_WEAPON))               { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826460); }
    if(GetHasFeat(FEAT_GREATER_PSIONIC_WEAPON))       { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826462); }
    if(GetHasFeat(FEAT_SPEED_OF_THOUGHT))             { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16826486); }
    if(GetHasFeat(FEAT_WOUNDING_ATTACK))              { bRelevel = TRUE; sFeats += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(-1/*FIXME*/); }
    
    if(bRelevel)
    {
        int nHD = GetHitDice(oPC);
        int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
        int nOldXP = GetXP(oPC);
        int nNewXP = nMinXPForLevel - 1000;
        SetXP(oPC,nNewXP);         //You are not a psionic character and may not take        
        FloatingTextStringOnCreature(GetStringByStrRef(16826472) + " " + sFeats + ". " + PLEASE_RESELECT, oPC, FALSE);
        DelayCommand(1.0, SetXP(oPC,nOldXP));
    }
}


void main()
{
     //Declare Major Variables
     object oPC = OBJECT_SELF;
     PsionDiscipline(oPC);
     
     if(GetIsPsionicCharacter(oPC))
        AntiPsionicFeats(oPC); // Feats that require one to *not* be a psionic character
     else
        PsionicFeats(oPC);     // Feats that require one to be a psionic character
}