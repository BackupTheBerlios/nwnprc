#include "x2_inc_craft"
#include "mh_instr_inc"

void main()
{
    //object oCaster = GetLastSpellCaster();
    object oCaster = OBJECT_SELF;

    if(GetLocalInt(oCaster,"use_CIMM"))
    {
        UnactiveModeCIMM(oCaster);
    }
    else
    {
        ActiveModeCIMM(oCaster);
    }
}
