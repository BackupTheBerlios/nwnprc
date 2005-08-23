#include "prgt_inc"
#include "prc_inc_racial"

void main()
{
//SendMessageToPC(GetFirstPC(), "Firing Trap");
    object oTarget = GetLocalObject(OBJECT_SELF, "Target");
    struct trap tTrap = GetLocalTrap(OBJECT_SELF, "TrapSettings");
    if(tTrap.nSpellID)
    {
        SetLocalInt(OBJECT_SELF, PRC_CASTERLEVEL_OVERRIDE, tTrap.nSpellLevel);
        ActionCastSpellAtObject(tTrap.nSpellID, oTarget, METAMAGIC_NONE, TRUE);
        DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, PRC_CASTERLEVEL_OVERRIDE));
    }
    else
    {
        float fRadius = IntToFloat(tTrap.nRadius);

        effect eTrapVFX;
        if(tTrap.nTrapVFX)
            eTrapVFX = EffectVisualEffect(tTrap.nTrapVFX);
        if(GetIsEffectValid(eTrapVFX))
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eTrapVFX, GetLocation(OBJECT_SELF));

        effect eTargetVFX;
        if(tTrap.nTargetVFX)
            eTargetVFX = EffectVisualEffect(tTrap.nTargetVFX);

        effect eBeamVFX;
        if(tTrap.nBeamVFX)
            eBeamVFX = EffectBeam(tTrap.nBeamVFX, OBJECT_SELF, BODY_NODE_CHEST);

        int i = 1;
        object oVictim = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF), TRUE);
        if(fRadius == 0.0)
            oVictim = oTarget;

        while(GetIsObjectValid(oVictim))
        {

            int nDamage;
            int nDiceCount;
            while(nDiceCount < tTrap.nDamageDice)
            {
                nDamage += Random(tTrap.nDamageSize)+1;
                nDiceCount++;
            }
            effect eDamage = EffectDamage(nDamage, tTrap.nDamageType);
            if((tTrap.nDamageType = DAMAGE_TYPE_NEGATIVE
                && MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
                || (tTrap.nDamageType = DAMAGE_TYPE_POSITIVE
                && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD))
                eDamage = EffectHeal(nDamage);

            if(GetIsEffectValid(eTargetVFX))
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eTargetVFX, oVictim);
            if(GetIsEffectValid(eBeamVFX))
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eBeamVFX, oVictim);
            if(GetIsEffectValid(eDamage))
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oVictim);
            if(!tTrap.nFakeSpell)
                ActionCastFakeSpellAtObject(tTrap.nFakeSpell, oVictim);

            i++;
            if(fRadius == 0.0)
                oVictim = OBJECT_INVALID;
            else
                oVictim = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF), TRUE);
        }
    }
}
