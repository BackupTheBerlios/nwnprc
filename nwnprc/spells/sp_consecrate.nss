//::///////////////////////////////////////////////
//:: Consecrate
//:: sp_consecrate.nss
//:: //////////////////////////////////////////////
/* Consecrate  
Evocation [Good]
Level:  Clr 2
Components:     V, S
Casting time:   1 standard action
Range:  Close (25 ft. + 5 ft./2 levels)
Area:   20-ft.-radius emanation
Duration:       2 hours/level
Saving Throw:   None
Spell Resistance:       No

This spell blesses an area with positive energy. Each Charisma check made
to turn undead within this area gains a +3 sacred bonus. Every undead creature
entering a consecrated area suffers minor disruption, giving it a -1 penalty on
attack rolls, damage rolls, and saves. Undead cannot be created within or summoned
into a consecrated area.

Consecrate counters and dispels desecrate. 
*/
//:://////////////////////////////////////////////
//:: Created By: Soultaker
//:: Created On: ??????
//:://////////////////////////////////////////////

//:: rewritten by Tenjac  Sep 17, 2008 for correct functioning
#include "prc_inc_spells"

void main()
{
        PRCSetSchool(SPELL_SCHOOL_EVOCATION);    
        if (!X2PreSpellCastCode()) return;               
        
        //Declare major variables including Area of Effect Object
        object oPC = OBJECT_SELF;
        effect eAOE = EffectAreaOfEffect(115);       
        int nDuration = 2 * PRCGetCasterLevel(oPC);               
        int nMetaMagic = PRCGetMetaMagicFeat();
        location lLoc = GetSpellTargetLocation();
        int nDesecrate;
        string sTag = Get2DACache("vfx_persistent", "LABEL", 111); //111 is Desecrate
        
        //Make sure duration does no equal 0
        if (nDuration < 2)
        {
                nDuration = 2;
        }
        
        //Check Extend metamagic feat.
        if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND)) nDuration = nDuration *2;
        
        //If within area of Desecrate
        object oAoE = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(21.0), lLoc, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
        
        while(GetIsObjectValid(oAoE))
        {
                //if it is Desecrate
                if(GetTag(oAoE) == sTag)
                {
                        nDesecrate = 1;
                        FloatingTextStringOnCreature("You feel the desecration come to an end.", oPC, FALSE);
                        DestroyObject(oAoE);
                        break;
                }
                oAoE = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(21.0), lLoc, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
        }
        
        if(!nDesecrate)
        {
                //Create AoE
                ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLoc, HoursToSeconds(nDuration));
        }        
        PRCSetSchool();
}         