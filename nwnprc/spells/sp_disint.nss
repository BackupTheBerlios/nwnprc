//::///////////////////////////////////////////////
//:: Name     Disintegrate
//:: FileName   sp_disint.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/** @file Disintegrate
School: Transmutation
Level: Destruction 7, Sor/Wiz 6
Components: V, S, M/DF
Casting Time: 1 action
Range: Medium (100 ft. + 10 ft/level)
Effect: Ray
Duration: Instantaneous
Saving Throw: Fortitude partial
Spell Resistance: Yes
 
A thin, green ray springs from your pointing finger.
You must make a successful ranged touch attack to hit.
Any creature struck by the ray takes 2d6 points of 
damage per caster level (to a maximum of 40d6). Any 
creature reduced to 0 or fewer hit points by this 
spell is entirely disintegrated, leaving behind only
a trace of fine dust. A disintegrated creature’s 
equipment is unaffected.

When used against an object, the ray simply 
disintegrates as much as one 10- foot cube of 
nonliving matter. Thus, the spell disintegrates only 
part of any very large object or structure targeted. 
The ray affects even objects constructed entirely of 
force, such as forceful hand or a wall of force, but
not magical effects such as a globe of invulnerability
or an antimagic field.

A creature or object that makes a successful Fortitude
save is partially affected, taking only 5d6 points of
damage. If this damage reduces the creature or object
to 0 or fewer hit points, it is entirely disintegrated.

Only the first creature or object struck can be 
affected; that is, the ray affects only one target per
casting.

Material Components: A lodestone and a pinch of dust.
*/
//:://////////////////////////////////////////////
//:: Created By: ????
//:: Created On: ????
//:: 
//:: Modified By: Tenjac 1/11/06
//:://////////////////////////////////////////////

#include "spinc_common"
#include "prc_inc_sp_tch"

void main()
{
     SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);

     // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
     if (!X2PreSpellCastCode()) return;
     
     object oPC = OBJECT_SELF;
     object oTarget = PRCGetSpellTargetObject();
     if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
     {
          // Fire cast spell at event for the specified target
          SPRaiseSpellCastAt(oTarget);

          // Make the touch attack.                 
          int nTouchAttack = PRCDoRangedTouchAttack(oTarget);
          if (nTouchAttack > 0)
          {
               // Make SR check
               if (!SPResistSpell(oPC, oTarget))
               {
                    // Generate the RTA beam.     
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, 
                    EffectBeam(VFX_BEAM_DISINTEGRATE, oPC, BODY_NODE_HAND), oTarget, 1.0,FALSE);
                    
                    //*/Added 1/11/06 by Tenjac: Check for Otiluke's Resilient Sphere.  
                    // If ORS present, end ORS without harming the target.
                    if(GetPersistantLocalInt(oTarget, "HAS_OTILUKES_RS"))
                    {
			    effect eLoop=GetFirstEffect(oPC);
			    int nEffectSpellID = SPELL_OTILUKES_RS;
			    
			    while(GetIsEffectValid(eLoop))
			    {
				    if(GetEffectSpellId(eLoop) == nEffectSpellID)
				    {
					    RemoveEffect(oTarget, eLoop);
					    return;
				    }
				    eLoop = GetNextEffect(oTarget);
			    }
		    }
		                      
                    // Fort save or die time, but we implement death by doing massive damage
                    // since disintegrate works on constructs, undead, etc.  At some point EffectDie()
                    // should be tested to see if it works on non-living targets, and if it does it should
                    // be used instead.
                    // Test done. Result: It does kill them.
                    int nDamage = 9999;
                    if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget,oPC), SAVING_THROW_TYPE_SPELL))
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
                    ApplyTouchAttackDamage(oPC, oTarget, nTouchAttack, nDamage, DAMAGE_TYPE_MAGICAL);
               }
          }
     }
     
     SPSetSchool();
}
