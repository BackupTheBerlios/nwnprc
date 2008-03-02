#include "nw_i0_invocatns"
#include "x2_inc_spellhook" 
#include "eldritchtheurgespells"

void main()
{

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();

    // Additional Effects: (Combust Effect)
    DoEssenceSpellblast(OBJECT_SELF, oTarget);
}