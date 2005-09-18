

/////////////////////////////////////////////////////////////////////
//
// Firestorm - Burst of fire centered on the caster doing 1d8/lvl,
// max 5d8
//
/////////////////////////////////////////////////////////////////////
//: Burning Light
#include "spinc_common"
#include "spinc_burst"
#include "prc_class_const"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

if(GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF) && GetHasFeatEffect(FEAT_PIERCE_SHADOWS, OBJECT_SELF))   
{
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
    int nCasterLvl = GetLevelByClass(CLASS_TYPE_SHADOWBANE_INQUISITOR, OBJECT_SELF);
    int nDice = 4;

    // Acid storm is a huge burst doing 1d6 / lvl acid damage (15 cap)
    DoBurst (nCasterLvl,6, 0, nDice,
        VFX_IMP_SUNSTRIKE, VFX_IMP_SUNSTRIKE,
        RADIUS_SIZE_MEDIUM, DAMAGE_TYPE_DIVINE, DAMAGE_TYPE_DIVINE, SAVING_THROW_TYPE_NONE, TRUE);
}
}