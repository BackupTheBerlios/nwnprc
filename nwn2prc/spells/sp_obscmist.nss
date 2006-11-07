//::///////////////////////////////////////////////
//:: Obscuring Mist
//:: sp_obscmist.nss
//:://////////////////////////////////////////////
/*
    All people within the AoE get 20% conceal.
*/
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables, including the Area of Effect object.
    effect eAOE = EffectAreaOfEffect(AOE_PER_OBSCURING_MIST);
    //Capture the spell target location so that the AoE object can be created.
    location lTarget = GetSpellTargetLocation();
    int nDuration = PRCGetCasterLevel(OBJECT_SELF);
    if(nDuration < 1)
    {
        nDuration = 1;
    }
    int nMetaMagic = GetMetaMagicFeat();
    //Check for metamagic extend
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Create the object at the location so that the objects scripts will start working.
    // Duration of 1 minute/level
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, (60.0 * nDuration));

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

