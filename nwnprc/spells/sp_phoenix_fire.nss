//::///////////////////////////////////////////////
//:: Name      Phoenix Fire
//:: FileName  sp_phoenix_fire.nss
//:://////////////////////////////////////////////
/** @file
Phoenix Fire
Necromancy [Fire, Good]
Level: Sanctified 7
Components: V,S,F,Sacrifice
Range: 15 feet
Area: 15 foot radius spread, centered on you
Duration: Instantaneous (see text)
Saving Throw: Reflex half (see text)
Spell Resistance: Yes (see text)

You immolate yourself, consuming your flesh in a
cloud of flame 20 feet high and 30 feet in diameter.
You die (no saving throw, and spell resistance does
not apply). Every evil creature within the cloud takes
2d6 points of damage per caster level (maximum 40d6).
Neutral characters take half damage (and a successful
Reflex save reduces that further in half), while good
characters take no damage at all. Half of the damage
dealt by the spell against any creature is fire; the
rest results directly from divine power and is 
therefore not subject to being reduced by resistance
to fire-based attacks, such as that granted by 
protection  from energy(fire), fire shield(chill 
shield), and similar magic.

After 10 minutes, you rise from the ashes as if restored
to life by a resurrection spell.

Sacrifice: Your death and the level you lose when you
return to life are the sacrifice cost for this spell.

*/
//  Author:   Tenjac
//  Created:  1/6/2006
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


void Rebirth(object oPC);

const int ERROR_CODE_5_FIX_AGAIN = 1;

#include "prc_alterations"
#include "spinc_common"

void main()
{
    if(!X2PreSpellCastCode()) return;
    
    SPSetSchool(SPELL_SCHOOL_NECROMANCY);
    
    //Define vars
    object oPC = OBJECT_SELF;
    location lLoc = GetLocation(oPC);   
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nDam;
    
        
    //Immolate VFX on caster - VFX_IMP_HOLY_AID for casting VFX
    effect eFire = EffectVisualEffect(VFX_FNF_FIREBALL);
    effect eDivine = EffectVisualEffect(VFX_FNF_STRIKE_HOLY);
        
    DelayCommand(0.3f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oPC));
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDivine, oPC);
                            
    //Ash/smoke VFX at player's location?
            
    //Kill player
    DeathlessFrenzyCheck(oPC);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
            
    //Get first object in shape
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLoc, TRUE, OBJECT_TYPE_CREATURE);
    
    //While object valid
    while(GetIsObjectValid(oTarget))
    {
        if (!MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
        {
            int nDC = SPGetSpellSaveDC(oTarget, oPC);
            
            //If alignment evil
            if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
            {
                //Damage = 2d6/level
                nDam = d6(min(40, (2 * nCasterLvl)));
                
                //Reflex save for 1/2 damage
                if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_GOOD))
                {
                    nDam = nDam/2;
                }
            }
            //If alignment neutral
            if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL)
            {
                //Half damage for neutrality, Damage = 1d6
                nDam = d6(min(20,nCasterLvl));
                
                //Reflex for further 1/2
                if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_GOOD))
                {
                    nDam = nDam/2;
                }               
            }
            
            //Half divine, half fire
            int nDiv = nDam/2;
            nDam = nDam - nDiv;
            
            //Apply damage
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_DIVINE, nDiv), oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_FIRE, nDam), oTarget);            
        }
        //Get next object in shape
        object oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLoc, TRUE, OBJECT_TYPE_CREATURE);
    }
    
    //Wait 10 minutes, then rebirth
    DelayCommand(600.0f, Rebirth(oPC));
    
    SPSetSchool();
    SPGoodShift(oPC);
}
    
void Rebirth(object oPC)
{
    //Rebirth VFX ?
    
    //Resurrection
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
        
    //Level loss via death is going to be handled in different ways
    //in different modules, so I'm going to leave this out of the script
    //and opt to let the default death penalty of the module handle it
    //This provides continuity and ease of scripting.
}

