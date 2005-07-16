void main()
{
    int nDamage = GetMaxHitPoints()-GetCurrentHitPoints();
    //heal the damage done
    effect eHeal = EffectHeal(GetMaxHitPoints());
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF);
    
    int nCurrentHP = GetLocalInt(OBJECT_SELF, "DoorHP");    
    //check if it hasnt been initialized
    if(nCurrentHP == 0)
    {
        //default HP to maximum
        nCurrentHP = GetLocalInt(OBJECT_SELF, "DoorMaxHP");
        //if its not set, check the reflex saving throw field
        if(nCurrentHP == 0)
            nCurrentHP = GetReflexSavingThrow(OBJECT_SELF);
        //if thats not set, default to 20HP    
        if(nCurrentHP == 0)
            nCurrentHP = 20;    
            
        //timer        
        float fDelay = GetLocalFloat(OBJECT_SELF, "DoorRespawnTime");
        if(fDelay == 0.0)
            fDelay = IntToFloat(GetWillSavingThrow(OBJECT_SELF))*60.0;
    }
    nCurrentHP -= nDamage;
    //check if it should be destroyed
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
        //unlock it and mark it as plot so it cant be further damaged
        SetLocked(OBJECT_SELF, FALSE);
        ActionOpenDoor(OBJECT_SELF);
        SetPlotFlag(OBJECT_SELF, TRUE);
        object oPC = GetLastDamager();
        AssignCommand(oPC, ClearAllActions());
        SetLocalInt(OBJECT_SELF, "DoorHP", -10);
        //respawn timer
        float fDelay = GetLocalFloat(OBJECT_SELF, "DoorRespawnTime");
        if(fDelay > 0.0)
        {
            DelayCommand(fDelay, SignalEvent(OBJECT_SELF, EventUserDefined(500)));
            DelayCommand(fDelay+0.1, SetLocked(OBJECT_SELF, TRUE));
        }
    }
    else
        SetLocalInt(OBJECT_SELF, "DoorHP", nCurrentHP);
}
