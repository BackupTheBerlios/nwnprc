void main()
{
    object oCaster = OBJECT_SELF;
    SetLocalInt(oCaster, "Augment", 4);
    FloatingTextStringOnCreature("Augmentation Level Four", oCaster, FALSE);
}