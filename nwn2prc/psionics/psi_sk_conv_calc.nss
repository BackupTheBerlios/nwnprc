//::///////////////////////////////////////////////
//:: Soulknife: Conversation - Calculate status
//:: psi_sk_conv_calc
//::///////////////////////////////////////////////
/*
    Constructs the strings telling the current
    status of the mindblade enhancement.
    
    This is for the settings currently in effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 06.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"


int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nFlags = GetPersistantLocalInt(oPC, MBLADE_FLAGS);
    // Build selections
    string sSelect = "";
    int bFirst = 1;

    if(nFlags & MBLADE_FLAG_LUCKY)              { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(1982); }
    if(nFlags & MBLADE_FLAG_DEFENDING)          { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824499); }
    if(nFlags & MBLADE_FLAG_KEEN)               { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(713); }
    if(nFlags & MBLADE_FLAG_VICIOUS)            { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824500); }
    if(nFlags & MBLADE_FLAG_PSYCHOKINETIC)      { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824501); }
    if(nFlags & MBLADE_FLAG_MIGHTYCLEAVING)     { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824502); }
    if(nFlags & MBLADE_FLAG_COLLISION)          { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824503); }
    if(nFlags & MBLADE_FLAG_MINDCRUSHER)        { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824504); }
    if(nFlags & MBLADE_FLAG_PSYCHOKINETICBURST) { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824505); }
    if(nFlags & MBLADE_FLAG_SUPPRESSION)        { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824506); }
    if(nFlags & MBLADE_FLAG_WOUNDING)           { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(741); }
    if(nFlags & MBLADE_FLAG_DISRUPTING)         { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824507); }
    if(nFlags & MBLADE_FLAG_SOULBREAKER)        { sSelect += (bFirst-- > 0 ? "":" ,") + GetStringByStrRef(16824508); }    
    
    SetCustomToken(100, sSelect);
    
    // Build free enhancement boni
    //SetCustomToken(101, IntToString(GetMaxEnhancementCost(oPC) - GetTotalEnhancementCost(nFlags));
    
    // Always pass, this is just to get the tokens in
    return TRUE;
}