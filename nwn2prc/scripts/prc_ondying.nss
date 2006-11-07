//::///////////////////////////////////////////////
//:: OnPlayerDying eventscript
//:: prc_ondying
//:://////////////////////////////////////////////
#include "prc_alterations"

void main()
{
    object oDying = GetLastPlayerDying();

    // Telflammar Shadowlord Shadow Discorporation. If successfull, prevents the rest of the script from executing
    /// @todo TLK the feedback strings
    if(GetHasFeat(FEAT_SHADOWDISCOPOR, oDying) &&
       (GetIsAreaAboveGround(GetArea(oDying)) == AREA_UNDERGROUND ||
        GetIsNight()                                           ||
        GetHasEffect(EFFECT_TYPE_DARKNESS, oDying)
       ))
    {
        int nRoll    = d20();
        int nDC      = 5 + GetLocalInt(oDying, "PRC_LastDamageTaken");
        int bSuccess = nRoll + GetReflexSavingThrow(oDying) >= nDC;

        // Some informational spam
        string sFeedback = "*Reflex Save vs Death : "
                         + (bSuccess ? "*success*" : "*failure*")
                         + " :(" + IntToString(nRoll) + " + " + IntToString(GetReflexSavingThrow(oDying)) + " = " + IntToString(nRoll + GetReflexSavingThrow(oDying)) + " vs. DC:" + IntToString(nDC) + ")";
        FloatingTextStringOnCreature(sFeedback, oDying);

        // Handle keeping the character alive
        if(bSuccess)
        {// Resurrect the character. Necessary because the game considers them already dead at this point
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oDying);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(1 - (GetCurrentHitPoints(oDying))), oDying);
            SignalEvent(oDying, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));

            // Move the character to a random nearby location
            location locJump = GetRandomLocation(GetArea(oDying), oDying, 30.0f);
            AssignCommand(oDying, ClearAllActions(TRUE));
            AssignCommand(oDying, ActionJumpToLocation(locJump));

            // The character is not dying after all, so skip the rest of the script to avoid complications
            // Though, the module's own OnDying script may very well supply complications anyway
            return;
        }
    }

    // Code added by Oni5115 for Remain Concious
    if(GetHasFeat(FEAT_REMAIN_CONSCIOUS, oDying) && GetCurrentHitPoints(oDying) > -10)
    {
         int pc_Damage = (GetCurrentHitPoints(oDying) * -1) + 1;
         int prev_Damage = GetLocalInt(oDying, "PC_Damage");

         // Store damage taken in a local variable
         pc_Damage = pc_Damage + prev_Damage;
         SetLocalInt(oDying, "PC_Damage", pc_Damage);

         if(pc_Damage < 10)
         {
              ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(), oDying);
         }
         else
         {
              effect eDeath = EffectDeath(FALSE, FALSE);
              ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, GetLastPlayerDying());
              SetLocalInt(oDying, "PC_Damage", 0);
         }

         string sFeedback = GetName(oDying) + " : Current HP = " + IntToString(pc_Damage * -1);
         SendMessageToPC(oDying, sFeedback);
    }

    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oDying, EVENT_ONPLAYERDYING);
}
