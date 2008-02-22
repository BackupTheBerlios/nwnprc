//::///////////////////////////////////////////////
//:: Blinding Beauty Toggle
//:: race_blindbeaut.nss
//::///////////////////////////////////////////////
/*
    Toggles Blinding Beauty aura.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 21, 2008
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
     string sMes = "";
     object oPC = OBJECT_SELF;
     effect eAura = SupernaturalEffect(EffectAreaOfEffect(AOE_PER_NYMPH_BLINDING));
    
     if(!GetHasSpellEffect(SPELL_NYMPH_BLINDING_BEAUTY))
     {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAura, oPC);
            sMes = "*Blinding Beauty Activated*";
     }
     
     else     
     {
        // Removes effects
        RemoveSpellEffects(SPELL_NYMPH_BLINDING_BEAUTY, oPC, oPC);
        sMes = "*Blinding Beauty Deactivated*";
        //clear the old aura a second time to ensure it clears
        RemoveSpellEffects(SPELL_NYMPH_BLINDING_BEAUTY, oPC, oPC);
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}