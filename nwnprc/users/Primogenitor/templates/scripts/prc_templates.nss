//::///////////////////////////////////////////////
//:: Name           Template main script
//:: FileName       prc_templates
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

    This deals with maintaining the bonus' that the
    various templates grant.

*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 18/04/06
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_template"

void RunTemplateStuff(int nTemplate, object oPC = OBJECT_SELF)
{    
    object oSkin = GetPCSkin(oPC);
    
    //ability adjustments
    int nStrMod = StringToInt(Get2DACache("templates", "Str", nTemplate));
    int nDexMod = StringToInt(Get2DACache("templates", "Dex", nTemplate));
    int nConMod = StringToInt(Get2DACache("templates", "Con", nTemplate));
    int nIntMod = StringToInt(Get2DACache("templates", "Int", nTemplate));
    int nWisMod = StringToInt(Get2DACache("templates", "Wis", nTemplate));
    int nChaMod = StringToInt(Get2DACache("templates", "Cha", nTemplate));
    if(nStrMod)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_str", nStrMod, 
            ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_STR);
    else if(nStrMod < 0)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_str", -nStrMod, 
            ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_STR);
    if(nDexMod)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_dex", nDexMod, 
            ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_DEX);
    else if(nDexMod < 0)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_dex", -nDexMod, 
            ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_DEX);
    if(nConMod)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_con", nConMod, 
            ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
    else if(nConMod < 0)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_con", -nConMod, 
            ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_CON);
    if(nIntMod)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_int", nIntMod, 
            ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
    else if(nIntMod < 0)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_int", -nIntMod, 
            ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_INT);
    if(nWisMod)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_wis", nWisMod, 
            ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS);
    else if(nWisMod < 0)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_wis", -nWisMod, 
            ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_WIS);
    if(nChaMod)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_cha", nChaMod, 
            ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);
    else if(nChaMod < 0)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_cha", -nChaMod, 
            ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_CHA);
    
    //natural AC
    int nNaturalAC = StringToInt(Get2DACache("templates", "NaturalAC", nTemplate));
    if(nNaturalAC)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_NaturalAC", nNaturalAC, 
            ITEM_PROPERTY_AC_BONUS);
    else if(nNaturalAC < 0)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_NaturalAC", -nNaturalAC, 
            ITEM_PROPERTY_DECREASED_AC);
            
    //saving throws        
    int nFort = StringToInt(Get2DACache("templates", "Fort", nTemplate));
    int nRef  = StringToInt(Get2DACache("templates", "Ref", nTemplate));
    int nWill = StringToInt(Get2DACache("templates", "Will", nTemplate));
    if(nFort)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_Fort", nFort, 
            ITEM_PROPERTY_SAVING_THROW_BONUS, IP_CONST_SAVEBASETYPE_FORTITUDE);
    else if(nFort < 0)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_Fort", -nFort, 
            ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
    if(nRef)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_Ref", nRef, 
            ITEM_PROPERTY_SAVING_THROW_BONUS, IP_CONST_SAVEBASETYPE_REFLEX);
    else if(nFort < 0)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_Ref", -nRef, 
            ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
    if(nWill)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_Will", nWill, 
            ITEM_PROPERTY_SAVING_THROW_BONUS, IP_CONST_SAVEBASETYPE_WILL);
    else if(nFort < 0)
        SetCompositeBonus(oSkin, "template_"+IntToString(nTemplate)+"_Will", -nWill, 
            ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
    
    //SR
    string sSR = Get2DACache("templates", "SR", nTemplate);
    int nSR;
    if(GetStringLeft(sSR, 3) == "HD+")
        nSR = StringToInt(GetStringRight(sSR, GetStringLength(sSR)-3))+GetHitDice(oPC);
    else if(GetStringLeft(sSR, 4) == "ECL+")
        nSR = StringToInt(GetStringRight(sSR, GetStringLength(sSR)-4))+GetECL(oPC);
    else if(GetStringLeft(sSR, 4) == "CR+")
        nSR = StringToInt(GetStringRight(sSR, GetStringLength(sSR)-3))+FloatToInt(GetChallengeRating(oPC));
    else
        nSR = StringToInt(sSR);
    if(nSR)
    {
        itemproperty ipIP = ItemPropertyBonusSpellResistance(GetSRByValue());
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);        
    }
    
    //AB
    int nAB = StringToInt(Get2DACache("templates", "AB", nTemplate));
    if(nAB != 0)
    {
        //get the creator
        string sTag = "PRC_Template_"+IntToString(nTemplate)+"_AB_WP";
        object oWP = GetObjectByTag(sTag);
        if(!GetIsObjectValid(oWP))
        {
            object oLimbo = GetObjectByTag("HEARTOFCHAOS");
            location lLimbo;
            if(GetIsObjectValid(oLimbo))
                lLimbo = GetLocation(oLimbo);
            else
                lLimbo = GetStartingLocation();
            oWP = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", lLimbo, FALSE, sTag);
        }
        //remove any prior effects
        effect eTest = GetFirstEffect(oPC);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectCreator(eTest) == oWP)
                RemoveEffect(oPC, eTest);
            eTest = GetNextEffect(oPC);    
        }
        //apply a new one
        if(nAB > 0)
            AssignCommand(oWP, 
                ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                    SupernaturalEffect(EffectAttackIncrease(nAB)),
                    oPC));
        else if(nAB < 0)            
            AssignCommand(oWP, 
                ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                    SupernaturalEffect(EffectAttackDecrease(-nAB)),
                    oPC));
    }
    
    //Speed
    int nSpeed = StringToInt(Get2DACache("templates", "Speed", nTemplate));
    if(nSpeed != 0)
    {
        //get the creator
        string sTag = "PRC_Template_"+IntToString(nTemplate)+"_Speed_WP";
        object oWP = GetObjectByTag(sTag);
        if(!GetIsObjectValid(oWP))
        {
            object oLimbo = GetObjectByTag("HEARTOFCHAOS");
            location lLimbo;
            if(GetIsObjectValid(oLimbo))
                lLimbo = GetLocation(oLimbo);
            else
                lLimbo = GetStartingLocation();
            oWP = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", lLimbo, FALSE, sTag);
        }
        //remove any prior effects
        effect eTest = GetFirstEffect(oPC);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectCreator(eTest) == oWP)
                RemoveEffect(oPC, eTest);
            eTest = GetNextEffect(oPC);    
        }
        //apply a new one
        if(nSpeed > 0)
            AssignCommand(oWP, 
                ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                    SupernaturalEffect(EffectMovementSpeedIncrease(nSpeed)),
                    oPC));
        else if(nSpeed < 0)            
            AssignCommand(oWP, 
                ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                    SupernaturalEffect(EffectMovementSpeedDecrease(-nSpeed)),
                    oPC));
    }
    
    //run the maintenence script
    string sScript = Get2DACache("templates", "MaintainScript", nTemplate); 
    ExecuteScript(sScript, oPC);
}


void main()
{

    object oPC = OBJECT_SELF;
    
    //loop over all templates and see if the player has them
    int i;
    for(i=0;i<200;i++)
    {
        if(GetHasTemplate())
            RunTemplateStuff(i, oPC);    
    }
}