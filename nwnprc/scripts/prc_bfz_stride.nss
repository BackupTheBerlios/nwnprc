void main()
{
    location lTarget = GetSpellTargetLocation();
    effect eDoor = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eDoor, GetLocation(OBJECT_SELF));
    AssignCommand(OBJECT_SELF, JumpToLocation(lTarget));
    ClearAllActions();
    //JumpToLocation(lTarget);
    DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eDoor, GetLocation(OBJECT_SELF)));
//	AssignCommand(o2, JumpToLocation(loc1));
}

