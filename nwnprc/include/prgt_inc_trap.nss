const int VFX_PER_5M_INVIS  = 190;
const int VFX_PER_10M_INVIS = 191;
const int VFX_PER_15M_INVIS = 192;
const int VFX_PER_20M_INVIS = 193;
const int VFX_PER_25M_INVIS = 194;
const int VFX_PER_30M_INVIS = 195;
const int VFX_PER_35M_INVIS = 196;
const int VFX_PER_40M_INVIS = 197;
const int VFX_PER_45M_INVIS = 198;
const int VFX_PER_50M_INVIS = 199;

struct trap
{
    int nDetectDC;
    int nDisarmDC;
    int nDetectAOE;
    int nTrapAOE;
    string sResRef;
    string sTriggerScript;
    int nSpellID;
    int nSpellLevel;
    int nDamageType;
    int nRadius;
    int nDamageDice;
    int nDamageSize;
    int nTargetVFX;
    int nTrapVFX;
    int nFakeSpell;
    int nBeamVFX;
    int nCR;
};

struct trap GetLocalTrap(object oObject, string sVarName);
void SetLocalTrap(object oObject, string sVarName, struct trap tTrap);
void DeleteLocalTrap(object oObject, string sVarName);
struct trap CreateRandomTrap();

struct trap CreateRandomTrap()
{
    struct trap tReturn;
    switch(Random(26))
    {
        case 0: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
        case 1: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
        case 2: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
        case 3: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
        case 4: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
        case 5: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
        case 6: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
        case 7: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
        case 8: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
        case 9: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
        case 10: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
        case 11: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
        case 12: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
        case 13: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
        case 14: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
        case 15: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
        case 16: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
        case 17: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
        case 18: tReturn.nDamageType = DAMAGE_TYPE_FIRE; break;
        case 19: tReturn.nDamageType = DAMAGE_TYPE_FIRE; break;
        case 20: tReturn.nDamageType = DAMAGE_TYPE_COLD; break;
        case 21: tReturn.nDamageType = DAMAGE_TYPE_COLD; break;
        case 22: tReturn.nDamageType = DAMAGE_TYPE_ELECTRICAL; break;
        case 23: tReturn.nDamageType = DAMAGE_TYPE_ELECTRICAL; break;
        case 24: tReturn.nDamageType = DAMAGE_TYPE_ACID; break;
        case 25: tReturn.nDamageType = DAMAGE_TYPE_SONIC; break;
    }

    tReturn.nRadius = 5;
    tReturn.nDamageDice = 2;
    tReturn.nDamageSize = 6;
    tReturn.nDetectDC = 10;
    tReturn.nDisarmDC = 20;
    tReturn.nDetectAOE = VFX_PER_15M_INVIS;
    tReturn.nTrapAOE = VFX_PER_5M_INVIS;
    tReturn.nCR = 4;
    tReturn.sResRef = "prgt_invis";
    tReturn.sTriggerScript = "prgt_trap_fire";

    switch(tReturn.nDamageType)
    {
        case DAMAGE_TYPE_BLUDGEONING:
            tReturn.nFakeSpell = 773; //bolder tossing
            tReturn.nRadius /= 2;
            tReturn.nDamageDice *= 2;
            break;
        case DAMAGE_TYPE_SLASHING:
            tReturn.nTrapVFX = VFX_FNF_SWINGING_BLADE;
            tReturn.nRadius /= 2;
            tReturn.nDamageSize *= 2;
            break;
        case DAMAGE_TYPE_PIERCING:
            tReturn.nTargetVFX = VFX_IMP_SPIKE_TRAP;
            tReturn.nRadius /= 4;
            tReturn.nDamageSize *= 2;
            tReturn.nDamageDice *= 2;
            break;
        case DAMAGE_TYPE_COLD:
            tReturn.nTrapVFX = VFX_FNF_ICESTORM;
            tReturn.nTargetVFX = VFX_IMP_FROST_S;
            tReturn.nRadius *= 2;
            tReturn.nDamageSize /= 2;
            tReturn.nDamageDice /= 2;
            break;
        case DAMAGE_TYPE_FIRE:
            tReturn.nTrapVFX = VFX_FNF_FIREBALL;
            tReturn.nTargetVFX = VFX_IMP_FLAME_S;
            tReturn.nRadius *= 2;
            tReturn.nDamageSize /= 2;
            tReturn.nDamageDice /= 2;
            break;
        case DAMAGE_TYPE_ELECTRICAL:
            tReturn.nBeamVFX = VFX_BEAM_LIGHTNING;
            tReturn.nTargetVFX = VFX_IMP_LIGHTNING_S;
            tReturn.nRadius /= 4;
            tReturn.nDamageSize *= 2;
            tReturn.nDamageDice *= 2;
            break;
        case DAMAGE_TYPE_SONIC:
            tReturn.nTrapVFX = VFX_FNF_SOUND_BURST;
            tReturn.nTargetVFX = VFX_IMP_SONIC;
            tReturn.nRadius *= 2;
            tReturn.nDamageSize /= 2;
            tReturn.nDamageDice /= 2;
            break;
        case DAMAGE_TYPE_ACID:
            tReturn.nTrapVFX = VFX_FNF_GAS_EXPLOSION_ACID;
            tReturn.nTargetVFX = VFX_IMP_ACID_S;
            tReturn.nRadius *= 2;
            tReturn.nDamageSize /= 2;
            tReturn.nDamageDice /= 2;
            break;
    }
    return tReturn;
}

struct trap GetLocalTrap(object oObject, string sVarName)
{
    struct trap tReturn;
    tReturn.nDetectDC       = GetLocalInt(oObject, sVarName+".nDetectDC");
    tReturn.nDisarmDC       = GetLocalInt(oObject, sVarName+".nDisarmDC");
    tReturn.nDetectAOE  = GetLocalInt(oObject, sVarName+".nDetectAOE");
    tReturn.nTrapAOE        = GetLocalInt(oObject, sVarName+".nTrapAOE");
    tReturn.sResRef         = GetLocalString(oObject, sVarName+".sResRef");
    tReturn.sTriggerScript  = GetLocalString(oObject, sVarName+".sTriggerScript");
    tReturn.nSpellID        = GetLocalInt(oObject, sVarName+".nSpellID");
    tReturn.nSpellLevel     = GetLocalInt(oObject, sVarName+".nSpellLevel");
    tReturn.nDamageType     = GetLocalInt(oObject, sVarName+".nDamageType");
    tReturn.nRadius         = GetLocalInt(oObject, sVarName+".nRadius");
    tReturn.nDamageDice     = GetLocalInt(oObject, sVarName+".nDamageDice");
    tReturn.nDamageSize     = GetLocalInt(oObject, sVarName+".nDamageSize");
    tReturn.nTargetVFX      = GetLocalInt(oObject, sVarName+".nTargetVFX");
    tReturn.nTrapVFX        = GetLocalInt(oObject, sVarName+".nTrapVFX");
    tReturn.nFakeSpell      = GetLocalInt(oObject, sVarName+".nFakeSpell");
    tReturn.nBeamVFX        = GetLocalInt(oObject, sVarName+".nBeamVFX");
    tReturn.nCR             = GetLocalInt(oObject, sVarName+".nCR");
    return tReturn;
}
void SetLocalTrap(object oObject, string sVarName, struct trap tTrap)
{
    SetLocalInt(oObject, sVarName+".nDetectDC", tTrap.nDetectDC);
    SetLocalInt(oObject, sVarName+".nDisarmDC", tTrap.nDisarmDC);
    SetLocalInt(oObject, sVarName+".nDetectAOE", tTrap.nDetectAOE);
    SetLocalInt(oObject, sVarName+".nTrapAOE", tTrap.nTrapAOE);
    SetLocalString(oObject, sVarName+".sResRef", tTrap.sResRef);
    SetLocalString(oObject, sVarName+".sTriggerScript", tTrap.sTriggerScript);
    SetLocalInt(oObject, sVarName+".nSpellID", tTrap.nSpellID);
    SetLocalInt(oObject, sVarName+".nSpellLevel", tTrap.nSpellLevel);
    SetLocalInt(oObject, sVarName+".nDamageType", tTrap.nDamageType);
    SetLocalInt(oObject, sVarName+".nRadius", tTrap.nRadius);
    SetLocalInt(oObject, sVarName+".nDamageDice", tTrap.nDamageDice);
    SetLocalInt(oObject, sVarName+".nDamageSize", tTrap.nDamageSize);
    SetLocalInt(oObject, sVarName+".nTargetVFX", tTrap.nTargetVFX);
    SetLocalInt(oObject, sVarName+".nTrapVFX", tTrap.nTrapVFX);
    SetLocalInt(oObject, sVarName+".nFakeSpell", tTrap.nFakeSpell);
    SetLocalInt(oObject, sVarName+".nBeamVFX", tTrap.nBeamVFX);
    SetLocalInt(oObject, sVarName+".nCR", tTrap.nCR);
}
void DeleteLocalTrap(object oObject, string sVarName)
{
    DeleteLocalInt(oObject, sVarName+".nDetectDC");
    DeleteLocalInt(oObject, sVarName+".nDisarmDC");
    DeleteLocalInt(oObject, sVarName+".nDetectAOE");
    DeleteLocalInt(oObject, sVarName+".nTrapAOE");
    DeleteLocalString(oObject, sVarName+".sResRef");
    DeleteLocalString(oObject, sVarName+".sTriggerScript");
    DeleteLocalInt(oObject, sVarName+".nSpellID");
    DeleteLocalInt(oObject, sVarName+".nSpellLevel");
    DeleteLocalInt(oObject, sVarName+".nDamageType");
    DeleteLocalInt(oObject, sVarName+".nRadius");
    DeleteLocalInt(oObject, sVarName+".nDamageDice");
    DeleteLocalInt(oObject, sVarName+".nDamageSize");
    DeleteLocalInt(oObject, sVarName+".nTargetVFX");
    DeleteLocalInt(oObject, sVarName+".nTrapVFX");
    DeleteLocalInt(oObject, sVarName+".nFakeSpell");
    DeleteLocalInt(oObject, sVarName+".nBeamVFX");
    DeleteLocalInt(oObject, sVarName+".nCR");
}
