//::///////////////////////////////////////////////
//:: Name      Damning Darkness
//:: FileName  sp_damng_dark.nss
//:://////////////////////////////////////////////
/**@file Damning Darkness
Evocation [Darkness, Evil]
Level: Clr 4, Darkness 4, Sor/Wiz 4
Components: V
Casting Time: 1 action
Range: Touch
Target: Object touched
Duration: 10 minutes/level (D)
Saving Throw: None
Spell Resistance: No 

This spell is similar to darkness, except that those
within the area of darkness also take unholy damage.
Creatures of good alignment take 2d6 points of 
damage per round in the darkness, and creatures
neither good nor evil take 1d6 points of damage. As 
with the darkness spell, the area of darkness is a 
20-foot radius, and the object that serves as the 
spell's target can be shrouded to block the darkness
(and thus the dam­aging effect).

Damning darkness counters or dispels any light spell 
of equal or lower level.

Arcane Material Component: A dollop of pitch with a 
tiny needle hidden inside it.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);
            
    if(!X2PreSpellCastCode()) return;
    
    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_DAMNDARK);
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oItemTarget = oTarget;
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = (nCasterLvl * 600.0f);
    location lLoc = GetLocation(oTarget);
   
    //Make touch
    int nTouch = PRCDoMeleeTouchAttack(oTarget);
    
    if(nTouch > 0)
    {
            //Check Extend metamagic feat.
            if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
            {
                    fDuration = fDuration *2;    //Duration is +100%
            }
            
            //Create an instance of the AOE Object using the Apply Effect function
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLoc, fDuration);
        
    }
    
    SPEvilShift(oPC);
    
    PRCSetSchool();
    
}