//::///////////////////////////////////////////////
//:: Name
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
        Ochre Jelly split on damage

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void main()
{
    object oOoze = OBJECT_SELF;
    //if it was pierce/slash/elec
    int nDamagePierce = GetDamageDealtByType(DAMAGE_TYPE_PIERCING);
    int nDamageSlash  = GetDamageDealtByType(DAMAGE_TYPE_SLASHING);
    int nDamageElect  = GetDamageDealtByType(DAMAGE_TYPE_ELECTRICAL);

    //remove previously stored amounts
    nDamagePierce -= GetLocalInt(oOoze, "DamagePiercingDone");
    nDamageSlash  -= GetLocalInt(oOoze, "DamageSlashingDone");
    nDamageElect  -= GetLocalInt(oOoze, "DamageElectricalDone");

    //update amounts stored
    SetLocalInt(oOoze, "DamagePiercingDone", GetDamageDealtByType(DAMAGE_TYPE_PIERCING));
    SetLocalInt(oOoze, "DamageSlashingDone", GetDamageDealtByType(DAMAGE_TYPE_SLASHING));
    SetLocalInt(oOoze, "DamageElectricalDone", GetDamageDealtByType(DAMAGE_TYPE_ELECTRICAL));

    //check if it was one of the 3 types
    if(nDamagePierce > 0
        || nDamageSlash > 0
        || nDamageElect > 0)
    {
        //heal it
        int nHeal = nDamagePierce+nDamageSlash+nDamageElect;
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oOoze);

        //split if
        //check if over 10HP
        if(GetCurrentHitPoints(oOoze) > 10)
        {
            object oNewOoze = CopyObject(oOoze, GetLocation(OBJECT_SELF));
            int nDam = GetCurrentHitPoints(oOoze)/2;
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam), oOoze);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam), oNewOoze);

            //do appearances
            int nAppear = APPEARANCE_TYPE_OCHRE_JELLY_LARGE;
            if(GetCurrentHitPoints(oOoze) < GetMaxHitPoints(oOoze)/4)
                nAppear = APPEARANCE_TYPE_OCHRE_JELLY_SMALL;
            else if(GetCurrentHitPoints(oOoze) < GetMaxHitPoints(oOoze)/2)
                nAppear = APPEARANCE_TYPE_OCHRE_JELLY_MEDIUM;
            else
                nAppear = APPEARANCE_TYPE_OCHRE_JELLY_LARGE;
            SetCreatureAppearanceType(oOoze, nAppear);
            SetCreatureAppearanceType(oNewOoze, nAppear);
        }
    }
}
