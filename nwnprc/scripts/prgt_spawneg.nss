//An example OnHB script for an invisible placeable to spawn a ground trap

#include "prgt_inc"
void main()
{
    CreateTrap(GetLocation(OBJECT_SELF), CreateRandomTrap());
    DestroyObject(OBJECT_SELF);
}
