void main()
{
    location lTarget = GetSpellTargetLocation();
    effect eDoor = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eDoor, GetLocation(OBJECT_SELF));
    JumpToLocation(lTarget);
    DelayCommand(0.5f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eDoor, GetLocation(OBJECT_SELF)));
}

