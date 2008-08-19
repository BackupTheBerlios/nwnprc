//::///////////////////////////////////////////////
//:: Name      Water Breathing
//:: FileName  sp_water_brth.nss
//:://////////////////////////////////////////////
/** @file Water Breathing
Transmutation
Level: Clr 3, Drd 3, Sor/Wiz 3
Components: V, S, M/DF
Casting Time: 1 standard action
Range: Touch
Target: You and every allied creature within a 10 foot radius
Duration: 2 hours/level
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

You and your allies can breathe water freely. The spell does not make creatures unable to breathe air.

Author:    Tenjac
Created:   8/14/08
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
        
        object oPC = OBJECT_SELF;
        object oTarget;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        
        effect eLink = EffectLinkEffects(EffectSpellImmunity(SPELL_DROWN), EffectSpellImmunity(SPELL_MASS_DROWN));
        
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);
        
        while(GetIsObjectValid(oTarget))
        {
                if(GetIsReactionTypeFriendly(oTarget, oPC))
                {
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nCasterLvl) * 2);                
                }                
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);
        }
        
        SPSetSchool();
}