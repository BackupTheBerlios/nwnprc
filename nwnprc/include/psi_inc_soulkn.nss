//::///////////////////////////////////////////////
//:: Soulknife includes
//:: psi_inc_soulkn
//::///////////////////////////////////////////////
/** @file
    Constants and common functions used by
    Soulknife scripts.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 06.04.2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_class_const"
#include "inc_persist_loca"


//////////////////////////////////////////////////
/* Constant declarations                        */
//////////////////////////////////////////////////

const string MBLADE_SHAPE        = "PRC_PSI_SK_MindbladeShape";
const string FREEDRAW_USED        = "PRC_PSI_SK_FreeDraw_Used";
const string PSYCHIC_STRIKE_MAINH = "PRC_PSI_SK_PsychisStrike_MainHand";
const string PSYCHIC_STRIKE_OFFH  = "PRC_PSI_SK_PsychisStrike_OffHand";
const string KTTS                 = "PRC_PSI_SK_KnifeToTheSoul";
const string BLADEWIND            = "PRC_PSI_SK_Bladewind_Active";

const int KTTS_TYPE_MASK    = 3; // 2 LSB
const int KTTS_TYPE_OFF     = 0;
const int KTTS_TYPE_INT     = 1;
const int KTTS_TYPE_WIS     = 2;
const int KTTS_TYPE_CHA     = 3;

const int MBLADE_SHAPE_SHORTSWORD       = 0;
const int MBLADE_SHAPE_DUAL_SHORTSWORDS = 1;
const int MBLADE_SHAPE_LONGSWORD        = 2;
const int MBLADE_SHAPE_BASTARDSWORD     = 3;
const int MBLADE_SHAPE_RANGED           = 4; // Actual shape is throwing axe


const string MBLADE_FLAGS   = "PRC_PSI_SK_MindbladeFlags";
const int MBLADE_FLAG_COUNT = 13;

const int MBLADE_FLAG_LUCKY                 = 1;
const int MBLADE_FLAG_DEFENDING             = 2;
const int MBLADE_FLAG_KEEN                  = 4;
const int MBLADE_FLAG_VICIOUS               = 8;
const int MBLADE_FLAG_PSYCHOKINETIC         = 16;
const int MBLADE_FLAG_MIGHTYCLEAVING        = 32;
const int MBLADE_FLAG_COLLISION             = 64;
const int MBLADE_FLAG_MINDCRUSHER           = 128;
const int MBLADE_FLAG_PSYCHOKINETICBURST    = 256;
const int MBLADE_FLAG_SUPPRESSION           = 512;
const int MBLADE_FLAG_WOUNDING              = 1024;
const int MBLADE_FLAG_DISRUPTING            = 2048;
const int MBLADE_FLAG_SOULBREAKER           = 4096;



//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

// Sums the enhancement costs of enhancements contained in the given flag set
// ==========================================================================
// nFlags   a set of mindblade flags
//
// Returns the sum of the enhancements costs of the mindblade abilities
// set in nFlags.
int GetTotalEnhancementCost(int nFlags);

// Gets the enhancement cost of the given mindblade ability
// ========================================================
// nFlag    one of the MBLADE_FLAG_* contants
int GetFlagCost(int nFlag);

// Gets the maximum mindblade enhancement usable by the given creature
// ===================================================================
// oSK  a creature to calculate the value of Soulknife class ability
//      "Mind blade enhancement" for
int GetMaxEnhancementCost(object oSK);



//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

int GetTotalEnhancementCost(int nFlags)
{
    int nCost, i;
    for(; i < MBLADE_FLAG_COUNT; i++)
        nCost += GetFlagCost(nFlags & (1 << i));
    return nCost;
}

int GetFlagCost(int nFlag)
{
    switch(nFlag)
    {
        case 0: return 0;
        case MBLADE_FLAG_LUCKY:                 return 1;
        case MBLADE_FLAG_DEFENDING:             return 1;
        case MBLADE_FLAG_KEEN:                  return 1;
        case MBLADE_FLAG_VICIOUS:               return 1;
        case MBLADE_FLAG_PSYCHOKINETIC:         return 1;
        case MBLADE_FLAG_MIGHTYCLEAVING:        return 2;
        case MBLADE_FLAG_COLLISION:             return 2;
        case MBLADE_FLAG_MINDCRUSHER:           return 2;
        case MBLADE_FLAG_PSYCHOKINETICBURST:    return 2;
        case MBLADE_FLAG_SUPPRESSION:           return 2;
        case MBLADE_FLAG_WOUNDING:              return 2;
        case MBLADE_FLAG_DISRUPTING:            return 3;
        case MBLADE_FLAG_SOULBREAKER:           return 4;
        
        default:
            WriteTimestampedLogEntry("Unknown flag passed to GetFlagCost: " + IntToString(nFlag));
    }
    
    return 0;
}

int GetMaxEnhancementCost(object oSK)
{
    return (GetLevelByClass(CLASS_TYPE_SOULKNIFE, oSK) - 2) / 4;
}








/*
/\/ Template used to generate the startingconditionals for Mindblade Enhancement convo \/\
//::///////////////////////////////////////////////
//:: Soulknife: Conversation - Show ~~~Name~~~
//:: psi_sk_conv_~~~Suffix~~~
//::///////////////////////////////////////////////
/*
    Checks whether to show ~~~Name~~~ and whether
    it is to be added or removed.
/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 06.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_sk_const"


int StartingConditional()
{
    int nReturn; // Implicit init to FALSE
    // Check if the flag is already present
    if(GetLocalInt(GetPCSpeaker(), MBLADE_FLAGS + "_T") & ~~~Flag~~~)
    {
        SetCustomToken(~~~TokenNum~~~, GetStringByStrRef(7654)); // Remove
        nReturn = TRUE;
    }
    // It isn't, so see if there is enough bonus left to add it
    else if(GetTotalEnhancementCost(GetLocalInt(GetPCSpeaker(), MBLADE_FLAGS + "_T")) + GetFlagCost(~~~Flag~~~) <= GetMaxEnhancementCost(GetPCSpeaker()))
    {
        SetCustomToken(~~~TokenNum~~~, GetStringByStrRef(62476)); // Add
        nReturn = TRUE;
    }
    
    return nReturn;
}


/\/ Template used to generate the toggles for Mindblade Enhancement convo \/\
//::///////////////////////////////////////////////
//:: Soulknife: Conversation - Toggle ~~~Name~~~
//:: psi_sk_conv_~~~Suffix~~~
//::///////////////////////////////////////////////
/*
    Adds or removes ~~~Name~~~ from the mindblade
    flags.
/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 06.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_sk_const"


void main()
{
    SetLocalInt(GetPCSpeaker(), MBLADE_FLAGS + "_T",
                GetLocalInt(GetPCSpeaker(), MBLADE_FLAGS + "_T") ^ ~~~Flag~~~
               );
}



/\/ 2da files used for both \/\
2DA V2.0

    Suffix  Name                    TokenNum    Flag
0   lu_s    Lucky                   102         MBLADE_FLAG_LUCKY
1   de_s    Defending               103         MBLADE_FLAG_DEFENDING
2   ke_s    Keen                    104         MBLADE_FLAG_KEEN
3   vi_s    Vicous                  105         MBLADE_FLAG_VICIOUS
4   ps_s    Psychokinetic           106         MBLADE_FLAG_PSYCHOKINETIC
5   mc_s    "Mighty Cleaving"       107         MBLADE_FLAG_MIGHTYCLEAVING
6   co_s    Collision               108         MBLADE_FLAG_COLLISION
7   mi_s    Mindcrusher             109         MBLADE_FLAG_MINDCRUSHER
8   pb_s    "Psychokinetic Burst"   110         MBLADE_FLAG_PSYCHOKINETICBURST
9   su_s    Suppression             111         MBLADE_FLAG_SUPPRESSION
10  wo_s    Wounding                112         MBLADE_FLAG_WOUNDING
11  di_s    Disrupting              113         MBLADE_FLAG_DISRUPTING
12  so_s    Soulbreaker             114         MBLADE_FLAG_SOULBREAKER
*/
