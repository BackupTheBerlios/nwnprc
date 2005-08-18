//An example OnHB script for an invisible placeable to spawn a ground trap

#include "prgt_inc"
void main()
{
    struct trap tTrap;
    tTrap = CreateRandomTrap();
    //add code in here to change things if you want to
    //for example, to set the detect DC to be 25 use:
    //tTrap.nDetectDC = 25;
    CreateTrap(GetLocation(OBJECT_SELF), tTrap);
    DestroyObject(OBJECT_SELF);
}
