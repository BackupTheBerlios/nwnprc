void main()
{
    object oCaster = OBJECT_SELF;
    SetLocalInt(oCaster, "Augment", 3);
    FloatingTextStringOnCreature("Augmentation Level Three", oCaster, FALSE);
}