//::///////////////////////////////////////////////
//:: Name       Placeable Visual Effect Web Big
//:: FileName   plc_vfx_web_big
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void DoWeb()
{
    location lSpawn            = GetLocation(OBJECT_SELF);
    object oTest = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lSpawn, TRUE, OBJECT_TYPE_PLACEABLE);
    effect eWeb = EffectVisualEffect(VFX_DUR_WEB);
    while(GetIsObjectValid(oTest))
    {
        if(!GetLocalInt(oTest, "WalkablePlaceable"))
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eWeb, oTest);
        oTest = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lSpawn, TRUE, OBJECT_TYPE_PLACEABLE);
    }
}

void main()
{
WriteTimestampedLogEntry("plc_vfx_web_big running");
    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT,
        //EffectVisualEffect(VFX_DUR_WEB_MASS),
        EffectAreaOfEffect(AOE_PER_WEB),
        GetLocation(OBJECT_SELF));
    DelayCommand(6.0, DoWeb());
    DestroyObject(OBJECT_SELF, 6.1);
}
