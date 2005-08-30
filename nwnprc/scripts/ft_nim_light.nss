/*
   Nimbus of Light

   Shown a light with radius 5 feets and +2 circumstance bonus to
   persuade, taunt

   Created By: Starlight
   Created On: 2004-5-5
*/

#include "prc_feat_const"
#include "inc_item_props"
#include "x2_inc_itemprop"
#include "nw_i0_spells"

void main()
{
   object oPC = OBJECT_SELF;
   string nMes = "";
    RemoveSpellEffects(GetSpellId(), oPC, oPC);

   effect ePersuade = EffectSkillIncrease(SKILL_PERSUADE, 2);
   effect eTaunt = EffectSkillIncrease(SKILL_TAUNT, 2);
   effect eLight = EffectVisualEffect(VFX_DUR_LIGHT_WHITE_5);
   effect eLink = EffectLinkEffects(ePersuade, eTaunt);
   eLink = ExtraordinaryEffect(EffectLinkEffects(eLink, eLight));

   if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
   {
       if (!GetHasFeatEffect(FEAT_NIMBUSLIGHT))
       {
            // Apply the Light and Skill increase
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
            // Display the message
            nMes = "*Nimbus of Light Activated*";
       }
       else
       {
            // Display the message
            nMes = "*Nimbus of Light Deactivated*";
        }
    }
    else
    {
        nMes = "You cannot activate Nimbus of Light if you are not good";
    }
    FloatingTextStringOnCreature(nMes, oPC, FALSE);
}