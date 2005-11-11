/*

This include file details the PRC replacement for biowares effect variable type
It is required so that we can access the components of an effect much as we can
with itemproperties.
Also useful for storing things like metamagic, spell level, etc


Primogenitor
*/

struct PRCeffect{
    effect eEffect;
    int nEffectType;
    int nEffectSubtype;
    int nDurationType;
    float fDuration;
    int nVersesRace;
    int nVersesTraps;
    int nVersesAlignmentOrder;
    int nVersesAlignmentMoral;
    
    //these are the subcomponents
    //probably more here than needed, but better safe than sorry!
    int nVar1;    object oVar1;    string sVar1;    location lVar1;    float fVar1;
    int nVar2;    object oVar2;    string sVar2;    location lVar2;    float fVar2;
    int nVar3;    object oVar3;    string sVar3;    location lVar3;    float fVar3;
    int nVar4;    object oVar4;    string sVar4;    location lVar4;    float fVar4;
    int nVar5;    object oVar5;    string sVar5;    location lVar5;    float fVar5;
    int nVar6;    object oVar6;    string sVar6;    location lVar6;    float fVar6;
    int nVar7;    object oVar7;    string sVar7;    location lVar7;    float fVar7;
    int nVar8;    object oVar8;    string sVar8;    location lVar8;    float fVar8;
    int nVar9;    object oVar9;    string sVar9;    location lVar9;    float fVar9;

    int nLinkedCount;
    int nLinkedID
    //linked effects are stored in an array on the module with the prefix PRC_LinkEffects_X
    //where X is an ID number that is incremented for each new effect that has linked effects

    int nSpellID;
    int nCasterLevel;
    object oCaster;
    int nMetamagic;
    int nSpellLevel;
    int nWeave;
};

//get/set local handlers
void             SetLocalPRCEffect(object oObject, string sVarName, struct PRCeffect eValue);
struct PRCeffect GetLocalPRCEffect(object oObject, string sVarName);
void             DeleteLocalPRCEffect(object oObject, string sVarName);
//default constructor
struct PRCeffect GetNewPRCEffectBase();


//get/set local handlers
void             SetLocalPRCEffect(object oObject, string sVarName, struct PRCeffect eValue)
{
    SetLocalInt     (oObject, sVarName+".nEffectType", eValue.nEffectType);
    SetLocalInt     (oObject, sVarName+".nEffectSubType", eValue.nEffectSubType);
    SetLocalInt     (oObject, sVarName+".nDurationType", eValue.nDurationType);
    SetLocalFloat   (oObject, sVarName+".fDuration", eValue.fDuration);
    SetLocalInt     (oObject, sVarName+".nVersesRace", eValue.nVersesRace);
    SetLocalInt     (oObject, sVarName+".nVersesTraps", eValue.nVersesTraps);
    SetLocalInt     (oObject, sVarName+".nVersesAlignmentOrder", eValue.nVersesAlignmentOrder);
    SetLocalInt     (oObject, sVarName+".nVersesAlignmentMoral", eValue.nVersesAlignmentMoral);
    SetLocalInt     (oObject, sVarName+".nLinkedCount", eValue.nLinkedCount);
    SetLocalInt     (oObject, sVarName+".nLinkedID", eValue.nLinkedID);
    SetLocalInt     (oObject, sVarName+".nSpellID", eValue.nSpellID);
    SetLocalInt     (oObject, sVarName+".nCasterLevel", eValue.nCasterLevel);
    SetLocalObject  (oObject, sVarName+".oCaster", eValue.oCaster);
    SetLocalInt     (oObject, sVarName+".nMetamagic", eValue.nMetamagic);
    SetLocalInt     (oObject, sVarName+".nSpellLevel", eValue.nSpellLevel);
    SetLocalInt     (oObject, sVarName+".nWeave", eValue.nWeave);
    SetLocalInt     (oObject, sVarName+".nVar1", eValue.nVar1);
    SetLocalInt     (oObject, sVarName+".nVar2", eValue.nVar2);
    SetLocalInt     (oObject, sVarName+".nVar3", eValue.nVar3);
    SetLocalInt     (oObject, sVarName+".nVar4", eValue.nVar4);
    SetLocalInt     (oObject, sVarName+".nVar5", eValue.nVar5);
    SetLocalInt     (oObject, sVarName+".nVar6", eValue.nVar6);
    SetLocalInt     (oObject, sVarName+".nVar7", eValue.nVar7);
    SetLocalInt     (oObject, sVarName+".nVar8", eValue.nVar8);
    SetLocalInt     (oObject, sVarName+".nVar9", eValue.nVar9);
    SetLocalObject  (oObject, sVarName+".oVar1", eValue.oVar1);
    SetLocalObject  (oObject, sVarName+".oVar2", eValue.oVar2);
    SetLocalObject  (oObject, sVarName+".oVar3", eValue.oVar3);
    SetLocalObject  (oObject, sVarName+".oVar1", eValue.oVar4);
    SetLocalObject  (oObject, sVarName+".oVar5", eValue.oVar5);
    SetLocalObject  (oObject, sVarName+".oVar6", eValue.oVar6);
    SetLocalObject  (oObject, sVarName+".oVar7", eValue.oVar7);
    SetLocalObject  (oObject, sVarName+".oVar8", eValue.oVar8);
    SetLocalObject  (oObject, sVarName+".oVar9", eValue.oVar9);
    SetLocalString  (oObject, sVarName+".sVar1", eValue.sVar1);
    SetLocalString  (oObject, sVarName+".sVar2", eValue.sVar2);
    SetLocalString  (oObject, sVarName+".sVar3", eValue.sVar3);
    SetLocalString  (oObject, sVarName+".sVar4", eValue.sVar4);
    SetLocalString  (oObject, sVarName+".sVar5", eValue.sVar5);
    SetLocalString  (oObject, sVarName+".sVar6", eValue.sVar6);
    SetLocalString  (oObject, sVarName+".sVar7", eValue.sVar7);
    SetLocalString  (oObject, sVarName+".sVar8", eValue.sVar8);
    SetLocalString  (oObject, sVarName+".sVar9", eValue.sVar9);
    SetLocalLocation(oObject, sVarName+".lVar1", eValue.lVar1);
    SetLocalLocation(oObject, sVarName+".lVar2", eValue.lVar2);
    SetLocalLocation(oObject, sVarName+".lVar3", eValue.lVar3);
    SetLocalLocation(oObject, sVarName+".lVar4", eValue.lVar4);
    SetLocalLocation(oObject, sVarName+".lVar5", eValue.lVar5);
    SetLocalLocation(oObject, sVarName+".lVar6", eValue.lVar6);
    SetLocalLocation(oObject, sVarName+".lVar7", eValue.lVar7);
    SetLocalLocation(oObject, sVarName+".lVar8", eValue.lVar8);
    SetLocalLocation(oObject, sVarName+".lVar9", eValue.lVar9);
    SetLocalFloat   (oObject, sVarName+".fVar1", eValue.fVar1);
    SetLocalFloat   (oObject, sVarName+".fVar2", eValue.fVar2);
    SetLocalFloat   (oObject, sVarName+".fVar3", eValue.fVar3);
    SetLocalFloat   (oObject, sVarName+".fVar4", eValue.fVar4);
    SetLocalFloat   (oObject, sVarName+".fVar5", eValue.fVar5);
    SetLocalFloat   (oObject, sVarName+".fVar6", eValue.fVar6);
    SetLocalFloat   (oObject, sVarName+".fVar7", eValue.fVar7);
    SetLocalFloat   (oObject, sVarName+".fVar8", eValue.fVar8);
    SetLocalFloat   (oObject, sVarName+".fVar9", eValue.fVar9);
}
struct PRCeffect GetLocalPRCEffect(object oObject, string sVarName)
{
    struct PRCeffect eReturn = GetNewPRCEffectBase();
    eReturn.nEffectType=    GetLocalInt     (oObject, sVarName+".nEffectType", );
    eReturn.nEffectSubType= GetLocalInt     (oObject, sVarName+".nEffectSubType");
    eReturn.nDurationType=  GetLocalInt     (oObject, sVarName+".nDurationType");
    eReturn.fDuration=      GetLocalFloat   (oObject, sVarName+".fDuration");
    eReturn.nVersesRace=    GetLocalInt     (oObject, sVarName+".nVersesRace");
    eReturn.nVersesTraps=   GetLocalInt     (oObject, sVarName+".nVersesTraps");
    eReturn.nVersesAlignmentOrder=GetLocalInt(oObject,sVarName+".nVersesAlignmentOrder");
    eReturn.nVersesAlignmentMoral=GetLocalInt(oObject,sVarName+".nVersesAlignmentMoral");
    eReturn.nLinkedCount=   GetLocalInt     (oObject, sVarName+".nLinkedCount");
    eReturn.nLinkedID=      GetLocalInt     (oObject, sVarName+".nLinkedID");
    eReturn.nSpellID=       GetLocalInt     (oObject, sVarName+".nSpellID");
    eReturn.nCasterLevel=   GetLocalInt     (oObject, sVarName+".nCasterLevel");
    eReturn.oCaster=        GetLocalObject  (oObject, sVarName+".oCaster");
    eReturn.nMetamagic=     GetLocalInt     (oObject, sVarName+".nMetamagic");
    eReturn.nSpellLevel=    GetLocalInt     (oObject, sVarName+".nSpellLevel");
    eReturn.nWeave=         GetLocalInt     (oObject, sVarName+".nWeave");
    eReturn.nVar1=          GetLocalInt     (oObject, sVarName+".nVar1");
    eReturn.nVar2=          GetLocalInt     (oObject, sVarName+".nVar2");
    eReturn.nVar3=          GetLocalInt     (oObject, sVarName+".nVar3");
    eReturn.nVar4=          GetLocalInt     (oObject, sVarName+".nVar4");
    eReturn.nVar5=          GetLocalInt     (oObject, sVarName+".nVar5");
    eReturn.nVar6=          GetLocalInt     (oObject, sVarName+".nVar6");
    eReturn.nVar7=          GetLocalInt     (oObject, sVarName+".nVar7");
    eReturn.nVar8=          GetLocalInt     (oObject, sVarName+".nVar8");
    eReturn.nVar9=          GetLocalInt     (oObject, sVarName+".nVar9");
    eReturn.oVar1=          GetLocalObject  (oObject, sVarName+".oVar1");
    eReturn.oVar2=          GetLocalObject  (oObject, sVarName+".oVar2");
    eReturn.oVar3=          GetLocalObject  (oObject, sVarName+".oVar3");
    eReturn.oVar4=          GetLocalObject  (oObject, sVarName+".oVar4");
    eReturn.oVar5=          GetLocalObject  (oObject, sVarName+".oVar5");
    eReturn.oVar6=          GetLocalObject  (oObject, sVarName+".oVar6");
    eReturn.oVar7=          GetLocalObject  (oObject, sVarName+".oVar7");
    eReturn.oVar8=          GetLocalObject  (oObject, sVarName+".oVar8");
    eReturn.oVar9=          GetLocalObject  (oObject, sVarName+".oVar9");
    eReturn.sVar1=          GetLocalString  (oObject, sVarName+".sVar1");
    eReturn.sVar2=          GetLocalString  (oObject, sVarName+".sVar2");
    eReturn.sVar3=          GetLocalString  (oObject, sVarName+".sVar3");
    eReturn.sVar4=          GetLocalString  (oObject, sVarName+".sVar4");
    eReturn.sVar5=          GetLocalString  (oObject, sVarName+".sVar5");
    eReturn.sVar6=          GetLocalString  (oObject, sVarName+".sVar6");
    eReturn.sVar7=          GetLocalString  (oObject, sVarName+".sVar7");
    eReturn.sVar8=          GetLocalString  (oObject, sVarName+".sVar8");
    eReturn.sVar9=          GetLocalString  (oObject, sVarName+".sVar9");
    eReturn.lVar1=          GetLocalLocation(oObject, sVarName+".lVar1");
    eReturn.lVar2=          GetLocalLocation(oObject, sVarName+".lVar2");
    eReturn.lVar3=          GetLocalLocation(oObject, sVarName+".lVar3");
    eReturn.lVar4=          GetLocalLocation(oObject, sVarName+".lVar4");
    eReturn.lVar5=          GetLocalLocation(oObject, sVarName+".lVar5");
    eReturn.lVar6=          GetLocalLocation(oObject, sVarName+".lVar6");
    eReturn.lVar7=          GetLocalLocation(oObject, sVarName+".lVar7");
    eReturn.lVar8=          GetLocalLocation(oObject, sVarName+".lVar8");
    eReturn.lVar9=          GetLocalLocation(oObject, sVarName+".lVar9");
    eReturn.fVar1=          GetLocalFloat   (oObject, sVarName+".fVar1");
    eReturn.fVar2=          GetLocalFloat   (oObject, sVarName+".fVar2");
    eReturn.fVar3=          GetLocalFloat   (oObject, sVarName+".fVar3");
    eReturn.fVar4=          GetLocalFloat   (oObject, sVarName+".fVar4");
    eReturn.fVar5=          GetLocalFloat   (oObject, sVarName+".fVar5");
    eReturn.fVar6=          GetLocalFloat   (oObject, sVarName+".fVar6");
    eReturn.fVar7=          GetLocalFloat   (oObject, sVarName+".fVar7");
    eReturn.fVar8=          GetLocalFloat   (oObject, sVarName+".fVar8");
    eReturn.fVar9=          GetLocalFloat   (oObject, sVarName+".fVar9");
    return eReturn;
}
void             DeleteLocalPRCEffect(object oObject, string sVarName)
{
    DeleteLocalInt     (oObject, sVarName+".nEffectType");
    DeleteLocalInt     (oObject, sVarName+".nEffectSubType");
    DeleteLocalInt     (oObject, sVarName+".nDurationType");
    DeleteLocalFloat   (oObject, sVarName+".fDuration");
    DeleteLocalInt     (oObject, sVarName+".nVersesRace");
    DeleteLocalInt     (oObject, sVarName+".nVersesTraps");
    DeleteLocalInt     (oObject, sVarName+".nVersesAlignmentOrder");
    DeleteLocalInt     (oObject, sVarName+".nVersesAlignmentMoral");
    DeleteLocalInt     (oObject, sVarName+".nLinkedCount");
    DeleteLocalInt     (oObject, sVarName+".nLinkedID");
    DeleteLocalInt     (oObject, sVarName+".nSpellID");
    DeleteLocalInt     (oObject, sVarName+".nCasterLevel");
    DeleteLocalObject  (oObject, sVarName+".oCaster");
    DeleteLocalInt     (oObject, sVarName+".nMetamagic");
    DeleteLocalInt     (oObject, sVarName+".nSpellLevel");
    DeleteLocalInt     (oObject, sVarName+".nWeave");
    DeleteLocalInt     (oObject, sVarName+".nVar1");
    DeleteLocalInt     (oObject, sVarName+".nVar2");
    DeleteLocalInt     (oObject, sVarName+".nVar3");
    DeleteLocalInt     (oObject, sVarName+".nVar4");
    DeleteLocalInt     (oObject, sVarName+".nVar5");
    DeleteLocalInt     (oObject, sVarName+".nVar6");
    DeleteLocalInt     (oObject, sVarName+".nVar7");
    DeleteLocalInt     (oObject, sVarName+".nVar8");
    DeleteLocalInt     (oObject, sVarName+".nVar9");
    DeleteLocalObject  (oObject, sVarName+".oVar1");
    DeleteLocalObject  (oObject, sVarName+".oVar2");
    DeleteLocalObject  (oObject, sVarName+".oVar3");
    DeleteLocalObject  (oObject, sVarName+".oVar1");
    DeleteLocalObject  (oObject, sVarName+".oVar5");
    DeleteLocalObject  (oObject, sVarName+".oVar6");
    DeleteLocalObject  (oObject, sVarName+".oVar7");
    DeleteLocalObject  (oObject, sVarName+".oVar8");
    DeleteLocalObject  (oObject, sVarName+".oVar9");
    DeleteLocalString  (oObject, sVarName+".sVar1");
    DeleteLocalString  (oObject, sVarName+".sVar2");
    DeleteLocalString  (oObject, sVarName+".sVar3");
    DeleteLocalString  (oObject, sVarName+".sVar4");
    DeleteLocalString  (oObject, sVarName+".sVar5");
    DeleteLocalString  (oObject, sVarName+".sVar6");
    DeleteLocalString  (oObject, sVarName+".sVar7");
    DeleteLocalString  (oObject, sVarName+".sVar8");
    DeleteLocalString  (oObject, sVarName+".sVar9");
    DeleteLocalLocation(oObject, sVarName+".lVar1");
    DeleteLocalLocation(oObject, sVarName+".lVar2");
    DeleteLocalLocation(oObject, sVarName+".lVar3");
    DeleteLocalLocation(oObject, sVarName+".lVar4");
    DeleteLocalLocation(oObject, sVarName+".lVar5");
    DeleteLocalLocation(oObject, sVarName+".lVar6");
    DeleteLocalLocation(oObject, sVarName+".lVar7");
    DeleteLocalLocation(oObject, sVarName+".lVar8");
    DeleteLocalLocation(oObject, sVarName+".lVar9");
    DeleteLocalFloat   (oObject, sVarName+".fVar1");
    DeleteLocalFloat   (oObject, sVarName+".fVar2");
    DeleteLocalFloat   (oObject, sVarName+".fVar3");
    DeleteLocalFloat   (oObject, sVarName+".fVar4");
    DeleteLocalFloat   (oObject, sVarName+".fVar5");
    DeleteLocalFloat   (oObject, sVarName+".fVar6");
    DeleteLocalFloat   (oObject, sVarName+".fVar7");
    DeleteLocalFloat   (oObject, sVarName+".fVar8");
    DeleteLocalFloat   (oObject, sVarName+".fVar9");

}
//default constructor
struct PRCeffect GetNewPRCEffectBase()
{
    //not sure if anything needs to be here at the moment
    return struct PRCeffect;
}