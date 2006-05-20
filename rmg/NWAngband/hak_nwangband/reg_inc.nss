//this struct is used to track how many different CRs and stuff to create
struct encounter{
    int    nCount1;  float fCR1;
    int    nCount2;  float fCR2;
    int    nCount3;  float fCR3;
    int    nCount4;  float fCR4;
    int    nCount5;  float fCR5;
    int    nCount6;  float fCR6;
    int    nCount7;  float fCR7;
    int    nCount8;  float fCR8;
    int    nCount9;  float fCR9;
    int    nCount10; float fCR10;
};

//This returns the total Encounter Level
//Encounter Level equal to the level of a party of 4
//should take 20% of resources to beat
//+2EL is a doubling of difficulting
float GetELForEncounter(struct encounter eEn);

//This returns a random encounter set for this
//fEL      = the level of a party of 4
//           should take 20% of resources to beat
//nCount   = Number of creatures to spawn
struct encounter GetRandomEncounterForEL(float fEL, int nSeed = 0);

const string REG_DATABASE = "reg";

#include "prc_gateway"
#include "random_inc"
#include "reg_inc_setup"
#include "spawn_inc"

void REG_SpawnObject(string sResRef, float fCR, location lLoc)
{
    object oSpawn;
    oSpawn =                                CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lLoc);
    if(!GetIsObjectValid(oSpawn)) oSpawn =  CreateObject(OBJECT_TYPE_ITEM,      sResRef, lLoc);
    if(!GetIsObjectValid(oSpawn)) oSpawn =  CreateObject(OBJECT_TYPE_STORE,     sResRef, lLoc);
    if(!GetIsObjectValid(oSpawn)) oSpawn =  CreateObject(OBJECT_TYPE_WAYPOINT,  sResRef, lLoc);
    if(!GetIsObjectValid(oSpawn))
    {
        //must be a creature
        AddToSpawnQueue(sResRef, lLoc, fCR);
        return;
    }
    SetLocalFloat(oSpawn, "CR", fCR);
    ExecuteScript(sResRef, oSpawn);
}

int REG_CheckSpawningClear(location lLoc, float fBlockingSize)
{
    if(GetLocalInt(OBJECT_SELF, "REG_BlockSpawn"))
    {
        DoDebug("encounter already triggered, aborting");
        return FALSE;
    }
    //check any nearby spawns and if present stop spawning
    object oTest = GetFirstObjectInShape(SHAPE_SPHERE, fBlockingSize, lLoc);
    while(GetIsObjectValid(oTest))
    {
        if(GetLocalInt(oTest, "REG_BlockSpawn")
            && oTest != OBJECT_SELF)
        {
            DoDebug("encounter already present, aborting");
            return FALSE;
        }
        SetLocalInt(oTest, "REG_BlockSpawn", TRUE);
        oTest = GetNextObjectInShape(SHAPE_SPHERE, fBlockingSize, lLoc);
    }
    SetLocalInt(OBJECT_SELF, "REG_BlockSpawn", TRUE);
    return TRUE;
}


void REG_SpawnEncounter(float fEL, string sFilename, location lLoc, int nSeed = 0, float fBlockingSize = 40.0)
{
    //check for nearby spawns
    if(!REG_CheckSpawningClear(lLoc, fBlockingSize))
        return;
    float fXPAward; //add proper XP calculation here
    struct encounter eEn = GetRandomEncounterForEL(fEL, nSeed);
    int i;
    for(i=0; i<eEn.nCount1; i++)
    {
        string sResRef = sFilename;//this should be replaced once random_inc is added
        REG_SpawnObject(sResRef, eEn.fCR1, lLoc);
        fXPAward += (eEn.fCR1*(eEn.fCR1+1.0)*500.0)/17.0;
    }
    for(i=0; i<eEn.nCount2; i++)
    {
        string sResRef = sFilename;//this should be replaced once random_inc is added
        REG_SpawnObject(sResRef, eEn.fCR2, lLoc);
        fXPAward += (eEn.fCR2*(eEn.fCR2+1.0)*500.0)/17.0;
    }
    for(i=0; i<eEn.nCount3; i++)
    {
        string sResRef = sFilename;//this should be replaced once random_inc is added
        REG_SpawnObject(sResRef, eEn.fCR3, lLoc);
        fXPAward += (eEn.fCR3*(eEn.fCR3+1.0)*500.0)/17.0;
    }
    for(i=0; i<eEn.nCount4; i++)
    {
        string sResRef = sFilename;//this should be replaced once random_inc is added
        REG_SpawnObject(sResRef, eEn.fCR4, lLoc);
        fXPAward += (eEn.fCR4*(eEn.fCR4+1.0)*500.0)/17.0;
    }
    for(i=0; i<eEn.nCount5; i++)
    {
        string sResRef = sFilename;//this should be replaced once random_inc is added
        REG_SpawnObject(sResRef, eEn.fCR5, lLoc);
        fXPAward += (eEn.fCR5*(eEn.fCR5+1.0)*500.0)/17.0;
    }
    for(i=0; i<eEn.nCount6; i++)
    {
        string sResRef = sFilename;//this should be replaced once random_inc is added
        REG_SpawnObject(sResRef, eEn.fCR6, lLoc);
        fXPAward += (eEn.fCR6*(eEn.fCR6+1.0)*500.0)/17.0;
    }
    for(i=0; i<eEn.nCount7; i++)
    {
        string sResRef = sFilename;//this should be replaced once random_inc is added
        REG_SpawnObject(sResRef, eEn.fCR7, lLoc);
        fXPAward += (eEn.fCR7*(eEn.fCR7+1.0)*500.0)/17.0;
    }
    for(i=0; i<eEn.nCount8; i++)
    {
        string sResRef = sFilename;//this should be replaced once random_inc is added
        REG_SpawnObject(sResRef, eEn.fCR8, lLoc);
        fXPAward += (eEn.fCR8*(eEn.fCR8+1.0)*500.0)/17.0;
    }
    for(i=0; i<eEn.nCount9; i++)
    {
        string sResRef = sFilename;//this should be replaced once random_inc is added
        REG_SpawnObject(sResRef, eEn.fCR9, lLoc);
        fXPAward += (eEn.fCR9*(eEn.fCR9+1.0)*500.0)/17.0;
    }
    for(i=0; i<eEn.nCount10; i++)
    {
        string sResRef = sFilename;//this should be replaced once random_inc is added
        REG_SpawnObject(sResRef, eEn.fCR10, lLoc);
        fXPAward += (eEn.fCR10*(eEn.fCR10+1.0)*500.0)/17.0;
    }
    //add the XP reward to the total on the area
    object oArea = GetAreaFromLocation(lLoc);
    float fCurAreaXP = GetLocalFloat(oArea, "XPAward");
    SetLocalFloat(oArea, "XPAward", fCurAreaXP+fXPAward);
}

struct encounter GetRandomEncounterForEL(float fEL, int nSeed = 0)
{
    struct encounter eEn;
    int nRow = StringToInt(GetRandomFrom2DA("reg_r", "random_default", nSeed));
    eEn.fCR1    = fEL+StringToFloat(Get2DACache("reg", "CR1", nRow));
    eEn.nCount1 =  StringToInt(Get2DACache("reg", "Count1", nRow));
    eEn.fCR1    = fEL+StringToFloat(Get2DACache("reg", "CR2", nRow));
    eEn.nCount2 =  StringToInt(Get2DACache("reg", "Count2", nRow));
    eEn.fCR2    = fEL+StringToFloat(Get2DACache("reg", "CR3", nRow));
    eEn.nCount3 =  StringToInt(Get2DACache("reg", "Count3", nRow));
    eEn.fCR3    = fEL+StringToFloat(Get2DACache("reg", "CR4", nRow));
    eEn.nCount4 =  StringToInt(Get2DACache("reg", "Count4", nRow));
    eEn.fCR4    = fEL+StringToFloat(Get2DACache("reg", "CR5", nRow));
    eEn.nCount5 =  StringToInt(Get2DACache("reg", "Count5", nRow));
    eEn.fCR5    = fEL+StringToFloat(Get2DACache("reg", "CR6", nRow));
    eEn.nCount6 =  StringToInt(Get2DACache("reg", "Count6", nRow));
    eEn.fCR6    = fEL+StringToFloat(Get2DACache("reg", "CR7", nRow));
    eEn.nCount7 =  StringToInt(Get2DACache("reg", "Count7", nRow));
    eEn.fCR7    = fEL+StringToFloat(Get2DACache("reg", "CR8", nRow));
    eEn.nCount8 =  StringToInt(Get2DACache("reg", "Count8", nRow));
    eEn.fCR8    = fEL+StringToFloat(Get2DACache("reg", "CR9", nRow));
    eEn.nCount9 =  StringToInt(Get2DACache("reg", "Count9", nRow));
    eEn.fCR10   = fEL+StringToFloat(Get2DACache("reg", "CR10", nRow));
    eEn.nCount10=  StringToInt(Get2DACache("reg", "Count10", nRow));
DoDebug("GetRandomEncounterForEL() complete eEn.fCR1 = "+FloatToString(eEn.fCR1));
    return eEn;
}

float GetELForEncounter(struct encounter eEn)
{
    //calculate each types EL based on count
    float fEL1;
    fEL1 = eEn.fCR1;
    fEL1 += IntToFloat(eEn.nCount1/2)*2.0; //each doubling of numbers adds +2 to EL
    float fEL2;
    fEL2 = eEn.fCR2;
    fEL2 += IntToFloat(eEn.nCount2/2)*2.0;
    float fEL3;
    fEL3 = eEn.fCR3;
    fEL3 += IntToFloat(eEn.nCount3/2)*2.0;
    float fEL4;
    fEL4 = eEn.fCR4;
    fEL4 += IntToFloat(eEn.nCount4/2)*2.0;
    float fEL5;
    fEL5 = eEn.fCR5;
    fEL5 += IntToFloat(eEn.nCount5/2)*2.0;
    float fEL6;
    fEL6 = eEn.fCR6;
    fEL6 += IntToFloat(eEn.nCount6/2)*2.0;
    float fEL7;
    fEL7 = eEn.fCR7;
    fEL7 += IntToFloat(eEn.nCount7/2)*2.0;
    float fEL8;
    fEL8 = eEn.fCR8;
    fEL8 += IntToFloat(eEn.nCount8/2)*2.0;
    float fEL9;
    fEL9 = eEn.fCR9;
    fEL9 += IntToFloat(eEn.nCount9/2)*2.0;
    float fEL10;
    fEL10 = eEn.fCR10;
    fEL10 += IntToFloat(eEn.nCount10/2)*2.0;

    //now add them all together
    float fELTotal;
    fELTotal = fEL1;
    if     (fEL2 < fELTotal-5.0) fELTotal += 0.0; //too low to be significant
    else if(fEL2 < fELTotal-3.0) fELTotal += 1.0; //slightly low, add 1
    else if(fEL2 < fELTotal+3.0) fELTotal += 2.0; //roughly equvilent, add 2
    else if(fEL2 < fELTotal+5.0) fELTotal = fEL2+1.0; //slightly higher, set to new and add 1
    else                         fELTotal = fEL2; //a lot higher, set to new past was insignificant
    if     (fEL3 < fELTotal-5.0) fELTotal += 0.0; //too low to be significant
    else if(fEL3 < fELTotal-3.0) fELTotal += 1.0; //slightly low, add 1
    else if(fEL3 < fELTotal+3.0) fELTotal += 2.0; //roughly equvilent, add 2
    else if(fEL3 < fELTotal+5.0) fELTotal = fEL3+1.0; //slightly higher, set to new and add 1
    else                         fELTotal = fEL3; //a lot higher, set to new past was insignificant
    if     (fEL4 < fELTotal-5.0) fELTotal += 0.0; //too low to be significant
    else if(fEL4 < fELTotal-3.0) fELTotal += 1.0; //slightly low, add 1
    else if(fEL4 < fELTotal+3.0) fELTotal += 2.0; //roughly equvilent, add 2
    else if(fEL4 < fELTotal+5.0) fELTotal = fEL4+1.0; //slightly higher, set to new and add 1
    else                         fELTotal = fEL4; //a lot higher, set to new past was insignificant
    if     (fEL5 < fELTotal-5.0) fELTotal += 0.0; //too low to be significant
    else if(fEL5 < fELTotal-3.0) fELTotal += 1.0; //slightly low, add 1
    else if(fEL5 < fELTotal+3.0) fELTotal += 2.0; //roughly equvilent, add 2
    else if(fEL5 < fELTotal+5.0) fELTotal = fEL5+1.0; //slightly higher, set to new and add 1
    else                         fELTotal = fEL5; //a lot higher, set to new past was insignificant
    if     (fEL6 < fELTotal-5.0) fELTotal += 0.0; //too low to be significant
    else if(fEL6 < fELTotal-3.0) fELTotal += 1.0; //slightly low, add 1
    else if(fEL6 < fELTotal+3.0) fELTotal += 2.0; //roughly equvilent, add 2
    else if(fEL6 < fELTotal+5.0) fELTotal = fEL6+1.0; //slightly higher, set to new and add 1
    else                         fELTotal = fEL6; //a lot higher, set to new past was insignificant
    if     (fEL7 < fELTotal-5.0) fELTotal += 0.0; //too low to be significant
    else if(fEL7 < fELTotal-3.0) fELTotal += 1.0; //slightly low, add 1
    else if(fEL7 < fELTotal+3.0) fELTotal += 2.0; //roughly equvilent, add 2
    else if(fEL7 < fELTotal+5.0) fELTotal = fEL7+1.0; //slightly higher, set to new and add 1
    else                         fELTotal = fEL7; //a lot higher, set to new past was insignificant
    if     (fEL8 < fELTotal-5.0) fELTotal += 0.0; //too low to be significant
    else if(fEL8 < fELTotal-3.0) fELTotal += 1.0; //slightly low, add 1
    else if(fEL8 < fELTotal+3.0) fELTotal += 2.0; //roughly equvilent, add 2
    else if(fEL8 < fELTotal+5.0) fELTotal = fEL8+1.0; //slightly higher, set to new and add 1
    else                         fELTotal = fEL8; //a lot higher, set to new past was insignificant
    if     (fEL9 < fELTotal-5.0) fELTotal += 0.0; //too low to be significant
    else if(fEL9 < fELTotal-3.0) fELTotal += 1.0; //slightly low, add 1
    else if(fEL9 < fELTotal+3.0) fELTotal += 2.0; //roughly equvilent, add 2
    else if(fEL9 < fELTotal+5.0) fELTotal = fEL9+1.0; //slightly higher, set to new and add 1
    else                         fELTotal = fEL9; //a lot higher, set to new past was insignificant
    if     (fEL10 < fELTotal-5.0) fELTotal += 0.0; //too low to be significant
    else if(fEL10 < fELTotal-3.0) fELTotal += 1.0; //slightly low, add 1
    else if(fEL10 < fELTotal+3.0) fELTotal += 2.0; //roughly equvilent, add 2
    else if(fEL10 < fELTotal+5.0) fELTotal = fEL10+1.0; //slightly higher, set to new and add 1
    else                          fELTotal = fEL10; //a lot higher, set to new past was insignificant
    return fELTotal;
}
