void main()
{
    object oCaster = OBJECT_SELF;
    SetLocalInt(oCaster, "Augment", 2);
    FloatingTextStringOnCreature("Augmentation Level Two", oCaster, FALSE);
}