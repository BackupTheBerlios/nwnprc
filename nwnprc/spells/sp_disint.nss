#include "spinc_common"
#include "prc_inc_sp_tch"

void main()
{
     SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);

     // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
     if (!X2PreSpellCastCode()) return;
     
     
     object oTarget = PRCGetSpellTargetObject();
     if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
     {
          // Fire cast spell at event for the specified target
          SPRaiseSpellCastAt(oTarget);

          // Make the touch attack.                 
          int nTouchAttack = PRCDoRangedTouchAttack(oTarget);;
          if (nTouchAttack > 0)
          {
               // Make SR check
               if (!SPResistSpell(OBJECT_SELF, oTarget))
               {
                    // Generate the RTA beam.     
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, 
                    EffectBeam(VFX_BEAM_DISINTEGRATE, OBJECT_SELF, BODY_NODE_HAND), oTarget, 1.0,FALSE);

                    // Fort save or die time, but we implement death by doing massive damage
                    // since disintegrate works on constructs, undead, etc.  At some point EffectDie()
                    // should be tested to see if it works on non-living targets, and if it does it should
                    // be used instead.
                    // Test done. Result: It does kill them.
                    int nDamage = 9999;
                    if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget,OBJECT_SELF), SAVING_THROW_TYPE_SPELL))
                    {
                         nDamage = SPGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL, 1 == nTouchAttack ? 5 : 10, 6); 
                    }
                    else
                    {
                         // If FB passes saving throw it survives, else it dies
                         DeathlessFrenzyCheck(oTarget);
                         
                         // For targets with > 9999 HP. Uncomment if you have such in your module and would like Disintegrate
                         // to be sure to blast them
                         //DelayCommand(0.30, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget));
                    }
                    
                    // Apply damage effect and VFX impact, and if the target is dead then apply
                    // the fancy rune circle too.
                    if (nDamage >= GetCurrentHitPoints (oTarget)) 
                         DelayCommand(0.25, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2), oTarget));
                    //DelayCommand(0.25, SPApplyEffectToObject(DURATION_TYPE_INSTANT, SPEffectDamage(nDamage, DAMAGE_TYPE_MAGICAL), oTarget));
                    DelayCommand(0.25, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGBLUE), oTarget));
                    ApplyTouchAttackDamage(OBJECT_SELF, oTarget, nTouchAttack, nDamage, DAMAGE_TYPE_MAGICAL);
               }
          }
     }
     
     SPSetSchool();
}
