/* 
   ----------------
   prc_psi_ppoints
   ----------------
   
   19/10/04 by Stratovarius
   
   Calculates the power point allotment of each class.
   Psion, Psychic Warrior, Wilder. (Soulknife does not have Power Points)
*/

#include "psi_inc_psifunc"
#include "inc_utility"

// Returns Bonus Power Points gained from Feats
// ============================================
// oCaster  creature whose feats to evaluate
int GetFeatBonusPP(object oCaster = OBJECT_SELF);

// Returns Bonus Power Points gained from Abilities
int GetModifierPP (object oCaster = OBJECT_SELF);

// Returns Power Points derived from a specific class
int GetPPForClass (object oCaster, int nClass);

// ---------------
// BEGIN FUNCTIONS
// ---------------


int GetFeatBonusPP(object oCaster = OBJECT_SELF){
    int nBonusPP; // Implicit init to 0
    
    // Normal feats
    if(GetHasFeat(FEAT_WILD_TALENT, oCaster))
        nBonusPP += 2;
    
    int i, nPsiTalents;
    for(i = FEAT_PSIONIC_TALENT_1; i <= FEAT_PSIONIC_TALENT_10; i++)
        if(GetHasFeat(i, oCaster)) nPsiTalents++;
    
    nBonusPP += nPsiTalents * (2 + nPsiTalents + 1) / 2;
    
    // Epic feats
    int nImpManifestations;
    for(i = FEAT_IMPROVED_MANIFESTATION_1; i <= FEAT_IMPROVED_MANIFESTATION_10; i++)
        if(GetHasFeat(i, oCaster)) nImpManifestations++;
    
    nBonusPP += nImpManifestations * (18 + nImpManifestations);
    
    // Racial boni
    
    return nBonusPP;
}


int GetModifierPP (object oCaster)
{
    int nPP;
    int nBonus;
    int nPsion = GetLevelByClass(CLASS_TYPE_PSION, oCaster);
    int nPsychic = GetLevelByClass(CLASS_TYPE_PSYWAR, oCaster);
    int nWilder = GetLevelByClass(CLASS_TYPE_WILDER, oCaster);

    if (nPsion > 0)
    {
        if (nPsion > 20)	nPsion = 20;
        nBonus = (nPsion * GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster)) / 2;
        nPP = nBonus + nPP;
    }
    if (nPsychic > 0)
    {
        if (nPsychic > 20)	nPsychic = 20;
        nBonus = (nPsychic * GetAbilityModifier(ABILITY_WISDOM, oCaster)) / 2;
        nPP = nBonus + nPP;
    }
    if (nWilder > 0)
    {
        if (nWilder > 20)	nWilder = 20;
        nBonus = (nWilder * GetAbilityModifier(ABILITY_CHARISMA, oCaster)) / 2;
        nPP = nBonus + nPP;
    }

    return nPP;
}

int GetPPForClass (object oCaster, int nClass)
{
    int nPP;
    int nLevel = GetLevelByClass(nClass, oCaster);
    nLevel += GetPsionicPRCLevels(oCaster);
    string sPsiFile = Get2DACache("classes", "FeatsTable", nClass);
    sPsiFile = GetStringLeft(sPsiFile, 4)+"psbk"+GetStringRight(sPsiFile, GetStringLength(sPsiFile)-8);
    nPP = StringToInt(Get2DACache(sPsiFile, "PowerPoints", nLevel-1));
    
    return nPP;
}


int GetTotalPP (object oCaster)
{
    //Variables
    int nPP;
   
    nPP += GetPPForClass(oCaster, CLASS_TYPE_PSION);
    nPP += GetPPForClass(oCaster, CLASS_TYPE_WILDER);
    nPP += GetPPForClass(oCaster, CLASS_TYPE_PSYWAR);
      		  
//    if (nPP > 343) nPP = 343;
      		  
    nPP = nPP + GetModifierPP(oCaster);
    
    nPP += GetFeatBonusPP(oCaster);
    
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