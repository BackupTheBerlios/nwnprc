//::///////////////////////////////////////////////
//:: Wall of Fire: Heartbeat
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
    object oCaster = GetAreaOfEffectCreator();
    int nCasterLvl = GetInvokerLevel(oCaster, CLASS_TYPE_WARLOCK);
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    //Capture the first target object in the shape.

    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    int CasterLvl = GetInvokerLevel(OBJECT_SELF, CLASS_TYPE_WARLOCK);
    
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator(),CasterLvl);

    oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Declare the spell shape, size and the location.
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_WALL_OF_PERILOUS_FLAME));
            //Make SR check, and appropriate saving throw(s).
            if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
            {
                //Roll damage.
                nDamage = d6(2 + nCasterLvl);
                
                nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF, FALSE);
                
                int nDC = GetInvocationSaveDC(oTarget,GetAreaOfEffectCreator(),INVOKE_WALL_OF_PERILOUS_FLAME);

                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (nDC), SAVING_THROW_TYPE_FIRE);
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    eDam = PRCEffectDamage(nDamage / 2, DAMAGE_TYPE_FIRE);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    eDam = PRCEffectDamage(nDamage / 2, DAMAGE_TYPE_MAGICAL);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    PRCBonusDamage(oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 1.0,FALSE);
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    
}
