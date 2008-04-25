//::///////////////////////////////////////////////
//:: Name      Heal Animal Companion
//:: FileName  sp_heal_anmcomp.nss
//:://////////////////////////////////////////////
/**@file HEAL ANIMAL COMPANION
Conjuration (Healing)
Level: Druid 5, ranger 3
Components: V, S
Casting Time: 1 standard action
Range: Touch
Target: Your animal companion
touched
Duration: Instantaneous
Saving Throw: Will negates
(harmless)
Spell Resistance: Yes (harmless)

This spell functions like heal (PH 239),
except that it affects only your animal
companion.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_CONJURATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        
        //Can only have one animal companion, so default is correct
        object oComp = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);
                
        //If it is your animal companion
        if(oTarget == oComp)
        {
                AssignCommand(oPC, ActionCastSpellAtObject(SPELL_HEAL, oComp, METAMAGIC_NONE, TRUE, PRCGetCasterLevel(oPC)));
        }
        PRCSetSchool();
}