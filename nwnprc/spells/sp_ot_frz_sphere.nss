//::///////////////////////////////////////////////
//:: Name      
//:: FileName  sp_.nss
//:://////////////////////////////////////////////
/**@file Otiluke's Freezing Sphere
Evocation [Cold]
Level: Sor/Wiz 6 
Components: V, S, F 
Casting Time: 1 standard action 
Range: Long (400 ft. + 40 ft./level) 
Target, Effect, or Area: See text
Duration: Instantaneous or 1 round/level; see text
Saving Throw: Reflex half; see text
Spell Resistance: Yes

Freezing sphere creates a frigid globe of cold energy 
that streaks from your fingertips to the location you
select, where it explodes in a 10-foot-radius burst, 
dealing 1d6 points of cold damage per caster level 
(maximum 15d6) to each creature in the area. An 
elemental (water) creature instead takes 1d8 points
of cold damage per caster level (maximum 15d8).

You can refrain from firing the globe after 
completing the spell, if you wish. Treat this as a
touch spell for which you are holding the charge. 
You can hold the charge for as long as 1 round per 
level, at the end of which time the freezing sphere
bursts centered on you (and you receive no saving 
throw to resist its effect). Firing the globe in a 
later round is a standard action.

Focus: A small crystal sphere.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_EVOCATION);
        
        object oPC = OBJECT_SELF;
        object oTarget; 
        location lTarget = PRCGetSpellTargetLocation();
        effect eVis = EffectVisualEffect(VFX_FNF_OTIL_COLDSPHERE);
        int nDC; 
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nDice = min(15, nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        int nDam;
        
        //VFX
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
        
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        
        while(GetIsObjectValid(oTarget))
        {
                if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nCasterLvl))
                {
                        nDC = PRCGetSaveDC(oTarget, oPC);
                        nDam = d6(nDice);
                        
                        if(nMetaMagic == METAMAGIC_MAXIMIZE) nDam = 6 * nDice;
                        
                        if(nMetaMagic == METAMAGIC_EMPOWER) nDam += (nDam/2);
                        
                        nDam = PRCGetReflexAdjustedDamage(nDam, oTarget, nDC, SAVING_THROW_TYPE_COLD);
                        
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_S), oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_COLD), oTarget);
                        
                }
                
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
        PRCSetSchool();
}
        
                  
                        
                
                
