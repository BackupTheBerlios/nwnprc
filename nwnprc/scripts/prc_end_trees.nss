///////////////////////////////////////////
// End Tree Shape script
// prc_end_trees.nss
///////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        object oPC = OBJECT_SELF;
        
        string sTag = "Tree" + GetName(oPC);
        object oTree = GetObjectByTag(sTag);
        DestroyObject(oTree);
        
        PRCRemoveSpellEffects(SPELL_TREESHAPE, oPC, oPC);
}