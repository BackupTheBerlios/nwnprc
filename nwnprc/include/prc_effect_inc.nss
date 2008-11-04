/**
 * @file
 * This file contains SPApplyEffectToObject(). This was in inc_dispel, but that include should only be in 
 * dispel-type spells and not the core spell engine.
 */

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

/**
 * A wrapper for ApplyEffectToObject() that takes PRC feats into account.
 *
 * @param nDurationType     One of the DURATION_TYPE_* constants
 * @param eEffect           The effect to apply
 * @param oTarget           The target of the effect
 * @param fDuration         The duration for temporary effects
 * @param bDispellable      TRUE if the effect should be dispellable, else FALSE
 * @param nSpellID          The Spell ID of the spell applying the effect. If default is used,
 *                          PRCGetSpellId() is used internally to get the spell ID.
 * @param nCasterLevel      The caster level that the spell is cast with. If default is used,
 *                          PRCGetCasterLevel() is used internally to get the caster level.
 * @param oCaster           The spell caster.
 */
void SPApplyEffectToObject(int nDurationType, effect eEffect, object oTarget, float fDuration = 0.0f,
    int bDispellable = TRUE, int nSpellID = -1, int nCasterLevel = -1, object oCaster = OBJECT_SELF);
    
/**
 * Removes all effects from target that are due to the given spell.
 *
 * Removes all effects caused by the spell nID regardless of caster. By
 * default only removes magical effects.
 *
 * @author Georg Zoeller (presumably copied from a bio script somewhere)
 *
 * @param nID                   The spell ID whose effects to remove.
 * @param oTarget               The object to remove the effects from.
 * @param bMagicalEffectsOnly   Whether to remove only magical effects (TRUE, the default)
 *                              or all effects (FALSE)
 */
void GZPRCRemoveSpellEffects(int nID,object oTarget, int bMagicalEffectsOnly = TRUE);

/**
 * Tests to make sure the data in the effect arrays still refers to an actual effect.
 *
 * Called from withing ReorderEffects() and DispelMagicBestMod() (in inc_dispel).  It's purpose
 * is to verify that the effect referred  to by an entry in the 3 arrays is still in effect, in 
 * case it has been dispelled or run out its duration since the data was put there.
 *
 * @param nSpellID  SpellID of the effect to test
 * @param oCaster   Caster of the spell that caused the effectbeing tested
 * @param oTarget   The object whose effect arrays are being looked at.
 *
 * @return          TRUE if the effect is still active, otherwise FALSE.
 */
int IsStillRealEffect(int nSpellID, object oCaster, object oTarget);

/**
 * Checks if target is a Frenzied Bersker with Deathless Frenzy Active
 * If so removes immortality flag so that the death effect from a
 * Death Spell can kill them
 *
 * @param oTarget Creature to test for Deathless Frenzy
 */
void DeathlessFrenzyCheck(object oTarget);
    
//////////////////////////////////////////////////
/* Include section                              */
//////////////////////////////////////////////////

#include "prc_inc_castlvl" // get prc_racial_const, prc_inc_nwscript, prc_inc_newip

//////////////////////////////////////////////////
/* Internal functions                           */
//////////////////////////////////////////////////

/**
 * Cleans up the 3 arrays used to store effect information on the object.
 *
 * Goes through the whole 3 stored lists of caster levels, spell id's, and casters,
 * deletes any that aren't real anymore (refer to an effect no longer present), then
 * builds a new list out of the ones that are still real/current (refer to effects that
 * are still present)
 * Thus, the list gets cleaned up every time it is added to.
 *
 * @param nSpellID  Spell ID of the spell being cast.
 * @param oTarget   Object to modify the effect arrays of.
 * @param oCaster   The caster of the spell.
 *
 * @return          The number of effects in the 3 new arrays
 */
int _ReorderEffects(int nSpellID, object oTarget, object oCaster = OBJECT_SELF)
{
   int nIndex = GetLocalInt(oTarget, "X2_Effects_Index_Number");
   int nEffectCastLevel;
   int nEffectSpellID;
   object oEffectCaster;
   int nWeave ;
   int nRealIndex = 0;
   int nPlace;

   for(nPlace = 0; nPlace <= nIndex; nPlace++)
   {
      nEffectSpellID = GetLocalInt(oTarget, " X2_Effect_Spell_ID_" + IntToString(nPlace));
      oEffectCaster = GetLocalObject(oTarget, " X2_Effect_Caster_" + IntToString(nPlace));
      nEffectCastLevel = GetLocalInt(oTarget, " X2_Effect_Cast_Level_" + IntToString(nPlace));
      nWeave =   GetLocalInt(oTarget, " X2_Effect_Weave_ID_" + IntToString(nPlace));

      DeleteLocalInt(oTarget, " X2_Effect_Spell_ID_" + IntToString(nPlace));
      DeleteLocalInt(oTarget, " X2_Effect_Cast_Level_" + IntToString(nPlace));
      DeleteLocalObject(oTarget, " X2_Effect_Caster_" + IntToString(nPlace));
      DeleteLocalInt(oTarget, " X2_Effect_Weave_ID_" + IntToString(nPlace));
      if(IsStillRealEffect(nEffectSpellID, oEffectCaster, oTarget))
      {
          if(nEffectSpellID != nSpellID || oEffectCaster != oCaster)
          // Take it out of the list if it's the spell now being cast, and by the same caster
          // This way spells that don't self dispel when they're recast don't flood the list.
          {
             SetLocalInt(oTarget, " X2_Effect_Spell_ID_" + IntToString(nRealIndex), nEffectSpellID);
             SetLocalInt(oTarget, " X2_Effect_Cast_Level_" + IntToString(nRealIndex), nEffectCastLevel);
             SetLocalObject(oTarget, " X2_Effect_Caster_" + IntToString(nRealIndex),oEffectCaster );
             SetLocalInt(oTarget, " X2_Effect_Weave_ID_" + IntToString(nRealIndex),nWeave);
             nRealIndex++;
          }// end of if is the same as the current spell and caster
      }// end of if is valid effect statement
   }// end of for statement
   return nRealIndex; // This is the number of values currently in all 3 arrays -1.
}// end of function

//////////////////////////////////////////////////
/* Function Definitions                         */
//////////////////////////////////////////////////

void SPApplyEffectToObject(int nDurationType, effect eEffect, object oTarget, float fDuration = 0.0f,
    int bDispellable = TRUE, int nSpellID = -1, int nCasterLevel = -1, object oCaster = OBJECT_SELF)
{
    //if it was cast from the new spellbook, remove previous effects
    if(GetLocalInt(OBJECT_SELF, "UsingActionCastSpell"))
        GZPRCRemoveSpellEffects(nSpellID, oTarget);

    // Instant duration effects can use BioWare code, the PRC code doesn't care about those
    if (DURATION_TYPE_INSTANT == nDurationType)
    {
        ApplyEffectToObject(nDurationType, eEffect, oTarget, fDuration);
    }
    else
    {
        // Extraordinary/Supernatural effects are not supposed to be dispellable.
        if (GetEffectSubType(eEffect) == SUBTYPE_EXTRAORDINARY
            || GetEffectSubType(eEffect) == SUBTYPE_SUPERNATURAL)
        {
            bDispellable = FALSE;
        }
        
        // We need the extra arguments for the PRC code, get them if defaults were passed in.
        if (-1 == nSpellID) nSpellID = PRCGetSpellId();
        if (-1 == nCasterLevel) nCasterLevel = PRCGetCasterLevel(oCaster);

        // Invoke the PRC apply function passing the extra data.
       int nIndex = _ReorderEffects(nSpellID, oTarget, oCaster);
       // Add this new effect to the slot after the last effect already on the character.

       //check if Master's Gift applies
       if(GetHasFeat(FEAT_MASTERS_GIFT, oTarget) && GetIsArcaneClass(PRCGetLastSpellCastClass(), oCaster))
       {
           int bHostileSpell = StringToInt(Get2DACache("spells", "HostileSetting", GetSpellId()));
           if(!bHostileSpell) fDuration = fDuration * 2;
       }
       //check if Fearsome Necromancy applies
       if(GetHasFeat(FEAT_FEARSOME_NECROMANCY, oCaster) && GetSpellSchool(PRCGetSpellId()) == SPELL_SCHOOL_NECROMANCY && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
       {
       		effect eReturn = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
            eReturn = EffectLinkEffects(eReturn, EffectAttackDecrease(2));
            eReturn = EffectLinkEffects(eReturn, EffectSavingThrowDecrease(SAVING_THROW_ALL,2));
    		eReturn = EffectLinkEffects(eReturn, EffectSkillDecrease(SKILL_ALL_SKILLS, 2));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eReturn, oTarget, 6.0);
       }       
       ApplyEffectToObject(nDurationType, eEffect, oTarget, fDuration);
       // may have code traverse the lists right here and not add the new effect
       // if an identical one already appears in the list somewhere

       SetLocalInt(oTarget, " X2_Effect_Spell_ID_" + IntToString(nIndex), nSpellID);
       SetLocalInt(oTarget, " X2_Effect_Cast_Level_" + IntToString(nIndex), nCasterLevel);
       SetLocalObject(oTarget, " X2_Effect_Caster_" + IntToString(nIndex), oCaster );
       if (GetHasFeat(FEAT_SHADOWWEAVE, oCaster))
         SetLocalInt(oTarget, " X2_Effect_Weave_ID_" + IntToString(nIndex), GetHasFeat(FEAT_TENACIOUSMAGIC,oCaster));
       else
         SetLocalInt(oTarget, " X2_Effect_Weave_ID_" + IntToString(nIndex), 0);

       //nIndex++;
       /// Set new index number to the character.
       DeleteLocalInt(oTarget, "X2_Effects_Index_Number");
       SetLocalInt(oTarget, "X2_Effects_Index_Number", nIndex);
    }
}

void GZPRCRemoveSpellEffects(int nID,object oTarget, int bMagicalEffectsOnly = TRUE)
{
    effect eEff = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEff))
    {
        if (GetEffectSpellId(eEff) == nID)
        {
            if (GetEffectSubType(eEff) != SUBTYPE_MAGICAL && bMagicalEffectsOnly)
            {
                // ignore
            }
            else
            {
                RemoveEffect(oTarget,eEff);
            }
        }
        eEff = GetNextEffect(oTarget);
    }
}

int IsStillRealEffect(int nSpellID, object oCaster, object oTarget)
{
   if(!GetHasSpellEffect(nSpellID, oTarget) || nSpellID == 0)
   {
      return FALSE;
   }

   effect eTestSubject = GetFirstEffect(oTarget);
   while(GetIsEffectValid(eTestSubject))
   {
      if(GetEffectSpellId(eTestSubject) == nSpellID)
      {
         if(GetEffectCreator(eTestSubject) == oCaster)
         {
            return TRUE;
         }// end of if originates from oCaster.
      }// end if originates from nSpellID.
      eTestSubject = GetNextEffect(oTarget);
   }
   return FALSE;
}

void DeathlessFrenzyCheck(object oTarget)
{
    //if its immune to death, e.g via items
    //then dont do this
    if(GetIsImmune( oTarget, IMMUNITY_TYPE_DEATH))
        return;
    if(GetHasFeat(FEAT_DEATHLESS_FRENZY, oTarget)
        && GetHasFeatEffect(FEAT_FRENZY, oTarget)
        && GetImmortal(oTarget))
          SetImmortal(oTarget, FALSE);
    //mark them as being magically killed for death system
    if(GetPRCSwitch(PRC_PNP_DEATH_ENABLE))
    {
        SetLocalInt(oTarget, "PRC_PNP_EfectDeathApplied",
            GetLocalInt(oTarget, "PRC_PNP_EfectDeathApplied")+1);
        AssignCommand(oTarget,
            DelayCommand(1.0,
                SetLocalInt(oTarget, "PRC_PNP_EfectDeathApplied",
                    GetLocalInt(oTarget, "PRC_PNP_EfectDeathApplied")-1)));
    }
}