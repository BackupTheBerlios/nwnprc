//::///////////////////////////////////////////////
//:: Name      Arrow of Dusk
//:: FileName  mys_arrow_dusk.nss
//:://////////////////////////////////////////////
/**@file ARROW OF DUSK
Fundamental
Level/School: 1st/Evocation
Range: Medium (100 ft. + 10 ft./level)
Effect: Ray
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

You must succeed on a ranged touch attack to deal 2d4 points of nonlethal damage to the target.
If you score a critical hit, triple the damage.

Author:    Tenjac
Created:   4/21/09
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "shd_inc_shdfunc"

void main()
{
        if(!X2PreSpellCastCode()) return;
        PRCSetSchool(SPELL_SCHOOL_EVOCATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nTouch = PRCDoRangedTouchAttack(oTarget);
        int nDam = d4(2);
        
        //metashadow block
        if(GetLocalInt(oPC, "PRC_METASHADOW_MAX"))
        {
                DeleteLocalInt(oPC, "PRC_METASHADOW_MAX");
                nDam = 8;
        }
        
        if(GetLocalInt(oPC, "PRC_METASHADOW_EMP"))
        {
                DeleteLocalInt(oPC, "PRC_METASHADOW_EMP");
                nDam += (nDam / 2);
        }        
        
        //Beam VFX.  Ornedan is my hero.
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_BLACK, oCaster, BODY_NODE_HAND, !nTouch), oTarget, 1.0f); 
        
        if(nTouch)
        {                
                if(nTouch = 2) nDam *=3;
                
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);
        }
        
        PRCSetSchool();
}