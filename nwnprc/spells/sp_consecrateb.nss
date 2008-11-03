//::///////////////////////////////////////////////
//:: Consecrate On Exit
//:: sp_consecrateb.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/* 
    
*/
//:://////////////////////////////////////////////
//:: Recreated By: Tenjac
//:: Created On: Sept 16, 2008
//:://////////////////////////////////////////////
#include "prc_inc_spells"
#include "prc_add_spell_dc"
#include "prc_spell_const"

void main()
{
        
        // End of Spell Cast Hook
        ActionDoCommand(SetAllAoEInts(SPELL_CONCECRATE,OBJECT_SELF, GetSpellSaveDC() ));        
        
        object oTarget = GetExitingObject();
        
        effect eAOE;
        if(GetHasSpellEffect(SPELL_CONCECRATE, oTarget))
        {
                //Search through the valid effects on the target.
                eAOE = GetFirstEffect(oTarget);
                while (GetIsEffectValid(eAOE))
                {
                        if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
                        {
                                //If the effect was created by consecrate then remove it
                                if(GetEffectSpellId(eAOE) == SPELL_CONCECRATE)
                                {
                                        RemoveEffect(oTarget, eAOE);
                                }
                        }
                        //Get next effect on the target
                        eAOE = GetNextEffect(oTarget);
                }
        }
}