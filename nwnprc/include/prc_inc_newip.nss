
//new function to return a PRC caster level itemproperty
//will putput to log file if it doesnt work
//relys on blueprints containing these itemproperties
itemproperty ItemPropertyTrueCasterLevel(int nSpell, int nLevel);

//not implemented
itemproperty ItemPropertyLimitUseByAbility(int nAbility, int nMinScore);
//not implemented
itemproperty ItemPropertyLimitUseBySkill(int nSkill, int nMinScore);
//not implemented
itemproperty ItemPropertyLimitUseBySpellcasting(int nLevel);
//not implemented
itemproperty ItemPropertyLimitUseByArcaneSpellcasting(int nLevel);
//not implemented
itemproperty ItemPropertyLimitUseByDivineSpellcasting(int nLevel);
//not implemented
itemproperty ItemPropertyLimitUseBySneakAttackDice(int nDice);

itemproperty ItemPropertyTrueCasterLevel(int nSpell, int nLevel)
{
    itemproperty ipReturn;
    string sResRef = "prc_ip85_"+IntToString(nSpell);
    object oChest = GetObjectByTag("HeartOfChaos");//use the crafting chest
    object oItem = CreateItemOnObject(sResRef, oChest);
    DestroyObject(oItem);
    ipReturn = GetFirstItemProperty(oItem);
    ipReturn = GetNextItemProperty(oItem);//first ip is duplicated
    int i;
    for(i=0;i<nLevel;i++)
    {
        ipReturn = GetNextItemProperty(oItem);
    }
    if(!GetIsItemPropertyValid(ipReturn))
        PrintString("ItemPropertyTrueCasterLevel "+IntToString(nSpell)+" "+IntToString(nLevel)+" is not valid");
    return ipReturn;
}

itemproperty ItemPropertyLimitUseByAbility(int nAbility, int nMinScore)
{
    itemproperty ipReturn;
    if(!GetIsItemPropertyValid(ipReturn))
        PrintString("ItemPropertyLimitUseByAbility "+IntToString(nAbility)+" "+IntToString(nMinScore)+" is not valid");
    return ipReturn;
}

itemproperty ItemPropertyLimitUseBySkill(int nSkill, int nMinScore)
{
    itemproperty ipReturn;
    if(!GetIsItemPropertyValid(ipReturn))
        PrintString("ItemPropertyLimitUseBySkill "+IntToString(nSkill)+" "+IntToString(nMinScore)+" is not valid");
    return ipReturn;
}

itemproperty ItemPropertyLimitUseBySpellcasting(int nLevel)
{
    itemproperty ipReturn;
    if(!GetIsItemPropertyValid(ipReturn))
        PrintString("ItemPropertyLimitUseBySpellcasting "+IntToString(nLevel)+" is not valid");
    return ipReturn;
}

itemproperty ItemPropertyLimitUseByArcaneSpellcasting(int nLevel)
{
    itemproperty ipReturn;
    if(!GetIsItemPropertyValid(ipReturn))
        PrintString("ItemPropertyLimitUseByArcaneSpellcasting "+IntToString(nLevel)+" is not valid");
    return ipReturn;
}

itemproperty ItemPropertyLimitUseByDivineSpellcasting(int nLevel)
{
    itemproperty ipReturn;
    if(!GetIsItemPropertyValid(ipReturn))
        PrintString("ItemPropertyLimitUseByDivineSpellcasting "+IntToString(nLevel)+" is not valid");
    return ipReturn;
}

itemproperty ItemPropertyLimitUseBySneakAttackDice(int nDice)
{
    itemproperty ipReturn;
    if(!GetIsItemPropertyValid(ipReturn))
        PrintString("ItemPropertyLimitUseBySneakAttackDice "+IntToString(nDice)+" is not valid");
    return ipReturn;
}