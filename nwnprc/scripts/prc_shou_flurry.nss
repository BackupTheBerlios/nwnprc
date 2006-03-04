//::///////////////////////////////////////////////
//:: Shou Disciple - Martial Flurry
//:://////////////////////////////////////////////
/*
    Gives and removes extra attack from PC
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Aug 23, 2004
//:://////////////////////////////////////////////

#include "nw_i0_spells"

void main()
{
     object oPC = OBJECT_SELF;
     string nMes = "";
     
     if(!GetHasSpellEffect(SPELL_MARTIAL_FLURRY_ALL) && !GetHasSpellEffect(SPELL_MARTIAL_FLURRY_LIGHT))
     {
            if (GetLevelByClass(CLASS_TYPE_SHOU, oPC) == 5)
            {
          	RemoveEffectsFromSpell(oPC, SPELL_MARTIAL_FLURRY_LIGHT);
          	RemoveEffectsFromSpell(oPC, SPELL_MARTIAL_FLURRY_ALL);
                ActionCastSpellOnSelf(SPELL_MARTIAL_FLURRY_ALL);
                nMes = "*Martial Flurry All Activated*";
            }
            else if (GetLevelByClass(CLASS_TYPE_SHOU, oPC) >= 3  && GetLevelByClass(CLASS_TYPE_SHOU, oPC) < 5)
            {
            	RemoveEffectsFromSpell(oPC, SPELL_MARTIAL_FLURRY_LIGHT);
          	RemoveEffectsFromSpell(oPC, SPELL_MARTIAL_FLURRY_ALL);
                ActionCastSpellOnSelf(SPELL_MARTIAL_FLURRY_LIGHT);
                nMes = "*Martial Flurry Light Activated*";
            }
     }
     else
     {
          // Removes effects
          RemoveEffectsFromSpell(oPC, SPELL_MARTIAL_FLURRY_LIGHT);
          RemoveEffectsFromSpell(oPC, SPELL_MARTIAL_FLURRY_ALL);

          // Display message to player
          nMes = "*Martial Flurry Deactivated*";
          FloatingTextStringOnCreature(nMes, oPC, FALSE);
     }

}