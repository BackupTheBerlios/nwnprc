//::///////////////////////////////////////////////
//:: Wall of Fire: On Enter
//:: NW_S0_WallFireA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "spinc_common"
#include "X0_I0_SPELLS"
#include "inv_inc_invfunc"

void main()
{

 ActionDoCommand(SetAllAoEInts(INVOKE_VFX_PER_WALLPERILFIRE,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nDamage;
    effect eDam;
    object oTarget;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());

    //Capture the first target object in the shape.
    oTarget = GetEnteringObject();
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_VFX_PER_WALLPERILFIRE));
        //Make SR check, and appropriate saving throw(s).
        if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
        {
            //Roll damage.
            nDamage = d6(4);
            nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF, FALSE);
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (PRCGetSaveDC(oTarget,GetAreaOfEffectCreator())), SAVING_THROW_TYPE_FIRE);
            if(nDamage > 0)
            {
                // Apply effects to the currently selected target.
                eDam = PRCEffectDamage(nDamage / 2, DAMAGE_TYPE_FIRE);
                eDam = PRCEffectDamage(nDamage / 2, DAMAGE_TYPE_MAGICAL);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                PRCBonusDamage(oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }

}
