void main()
{
    int nDamage = GetMaxHitPoints()-GetCurrentHitPoints();
    effect eHeal = EffectHeal(GetMaxHitPoints());
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF);

    int nCurrentHP = GetLocalInt(OBJECT_SELF, "DoorHP");
    nCurrentHP -= nDamage;
    if(nCurrentHP <= 0)
    {
        effect eVFX = EffectVisualEffect(VFX_COM_CHUNK_STONE_MEDIUM);
        location lLoc = GetLocation(OBJECT_SELF);
        vector vPos = GetPositionFromLocation(lLoc);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lLoc);
        eVFX = EffectVisualEffect(VFX_COM_CHUNK_STONE_SMALL);
        location lTarget = Location(GetAreaFromLocation(lLoc),
            Vector(vPos.x, vPos.y, vPos.z), 0.0);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lTarget);
        lTarget = Location(GetAreaFromLocation(lLoc),
            Vector(vPos.x+1.0, vPos.y, vPos.z), 0.0);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lTarget);
        lTarget = Location(GetAreaFromLocation(lLoc),
            Vector(vPos.x-1.0, vPos.y, vPos.z), 0.0);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lTarget);
        lTarget = Location(GetAreaFromLocation(lLoc),
            Vector(vPos.x, vPos.y+1.0, vPos.z), 0.0);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lTarget);
        lTarget = Location(GetAreaFromLocation(lLoc),
            Vector(vPos.x, vPos.y-1.0, vPos.z), 0.0);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lTarget);
        effect eInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInvis, OBJECT_SELF);
        effect eGhost = EffectCutsceneGhost();
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, OBJECT_SELF);
        SetLocked(OBJECT_SELF, FALSE);
        ActionOpenDoor(OBJECT_SELF);
        SetPlotFlag(OBJECT_SELF, TRUE);
        object oPC = GetLastDamager();
        AssignCommand(oPC, ClearAllActions());
    }
    else
        SetLocalInt(OBJECT_SELF, "DoorHP", nCurrentHP);
}
