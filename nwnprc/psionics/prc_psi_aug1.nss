void main()
{
    object oCaster = OBJECT_SELF;
    SetLocalInt(oCaster, "Augment", 1);
    FloatingTextStringOnCreature("Augmentation Level One", oCaster, FALSE);
}