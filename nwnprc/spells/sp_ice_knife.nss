//::///////////////////////////////////////////////
//:: Name      Ice Knife
//:: FileName  sp_ice_knife.nss
//:://////////////////////////////////////////////
/**@file Ice Knife
Conjuration (Creation) [Cold]
Level: Assassin 2, wu jen 2 (water),warmage 2
Components: S, M
Casting Time: 1 standard action
Range: Long (400 ft. + 40 ft./level)
Effect: One icy missile
Duration: Instantaneous
Saving Throw: See text
Spell Resistance: Yes

A magical shard of ice blasts from your
hand and speeds to its target. You must
succeed on a normal ranged attack to
hit (with a +2 bonus on the attack roll
for every two caster levels). If it hits, 
an ice knife deals 2d8 points of cold 
damage plus 2 points of Dexterity damage
(no Dexterity damage on a successful
Fortitude save). Creatures that have
immunity to cold damage also take no
Dexterity damage automatically.

A knife that misses creates a shower
of ice crystals in a 10-foot-radius burst.
The icy burst deals 1d8 points of cold
damage to all creatures within the area
of the effect (Reflex half).

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "x0_i0_position"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_CONJURATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        location lTarget = GetLocation(oTarget);
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nTouch = PRCDoRangedTouchAttack(oTarget);
        int nMetaMagic = PRCGetMetaMagicFeat();
        int nDC = PRCGetSaveDC(oTarget, oPC);
        int nDam;
        
        if(nTouch)
        {
                if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
                {
                        int nSave = PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_COLD);
                                          
                        //if failed, ability damage
                        if(nSave == 0) ApplyAbilityDamage(oTarget, ABILITY_DEXTERITY, 2, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);                                                                
                        
                        nDam = d8(2);
                        
                        if (nMetaMagic == METAMAGIC_MAXIMIZE) nDam = 16;
                        
                        if (nMetaMagic == METAMAGIC_EMPOWER) nDam += (nDam/2);
                        
                        //Apply damage even if they are immune - can't hurt
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_COLD), oTarget);
                }
        }
        
        else
        {
                //missed, so do AoE
                float fDistance = IntToFloat(Random(9));   //random distance for new loc
                float fAngle = IntToFloat(Random(359));   //random angle from original
                
                //Orientation doesn't matter, so make it 0.0f
                location lAoE = GenerateNewLocationFromLocation(lTarget, fDistance, fAngle, 0.0f);
                
                oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0f), lAoE, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
                
                while(GetIsObjectValid(oTarget))
                {
                        if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
                        {                               
                                nDam = d8(1);
                                
                                if (nMetaMagic == METAMAGIC_MAXIMIZE) nDam = 8;
                                
                                if (nMetaMagic == METAMAGIC_EMPOWER) nDam += (nDam/2);
                                
                                if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_COLD))  nDam = nDam/2;
                                
                                ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_COLD), oTarget);
                        }
                        
                        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0f), lAoE, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
                }
        }       
        PRCSetSchool();
}
                        