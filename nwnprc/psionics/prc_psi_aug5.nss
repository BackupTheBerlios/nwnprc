void main()
{
    object oCaster = OBJECT_SELF;
    SetLocalInt(oCaster, "Augment", 5);
    FloatingTextStringOnCreature("Augmentation Level Five", oCaster, FALSE);
}