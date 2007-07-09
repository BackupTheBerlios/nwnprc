//::///////////////////////////////////////////////
//:: Name      Prismatic Ray
//:: FileName  sp_prismat_ray.nss
//:://////////////////////////////////////////////
/**@file Prismatic Ray
Evocation
Level: Sorcerer/wizard 5
Components: V, S
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Effect: Ray
Duration: Instantaneous
Saving Throw: See text
Spell Resistance: Yes

A single beam of brilliantly colored
light shoots from your outstretched
hand. You must succeed on a ranged touch
attack with the ray to strike a target.
On a successful attack, a creature with
6 Hit Dice or fewer is blinded for 2d4
rounds by the prismatic ray in addition
to suffering a randomly determined
effect:

1d8    Color of Beam       Effect

1      Red                 20 points fire damage(Reflex half)
2      Orange              40 points acid damage(Reflex half)
3      Yellow              80 points electricity damage (Reflex half)
4      Green               Poison (Kills; Fortitude partial, take 1d6 Con damage instead)
5      Blue                Turned to stone(Fortitude negates)
6      Indigo              Insane, as insanity spell (Will negates)
7      Violet              Sent to another plane(Will negates)
8      Two effects; roll twice more, ignoring any '8' results

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void DoRay(object oTarget, int nSaveDC, int nRoll);

#include "spinc_common"

void main()
{
       if(!X2PreSpellCastCode()) return;
       
       SPSetSchool(SPELL_SCHOOL_EVOCATION);
       
       object oPC = OBJECT_SELF;
       object oTarget = PRCGetSpellTargetObject();
       int nCasterLvl = PRCGetCasterLevel(oPC);
       int nRoll = d8(1);
       int bTwoRolls = FALSE;
       int nBeamVisualEffect;  
       int nSaveDC = SPGetSpellSaveDC(oTarget, oPC);
       int nTouch = PRCDoRangedTouchAttack(oTarget);
       
       switch(nRoll)
       {
               case 1: nBeamVisualEffect = VFX_BEAM_EVIL;
                       break;
               
               case 2: nBeamVisualEffect = VFX_BEAM_FIRE;
                       break;
               
               case 3: nBeamVisualEffect = VFX_BEAM_SILENT_HOLY;
                       break;
                       
               case 4: nBeamVisualEffect = VFX_BEAM_DISINTEGRATE;
                       break;
                       
               case 5: nBeamVisualEffect = VFX_BEAM_SILENT_COLD;
                       break;
                       
               case 6: nBeamVisualEffect = VFX_BEAM_ODD;
                       break;
                       
               case 7: nBeamVisualEffect = VFX_BEAM_MIND; 
                       break;
                       
               case 8: break; 
                       
                       
       }
       
       //VFX
       effect eVis = EffectBeam(nBeamVisualEffect, oPC, BODY_NODE_HAND, !nTouch);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
               
       if(nTouch)
       {
                //SR check
                if(!MyPRCResistSpell(oPC, oTarget, (nCasterLvl + SPGetPenetr()))
                {
                        
                        //blind
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, RoundsToSeconds(d4(2)));
                        
                        if nRoll = 8;
                        {
                                bTwoRolls = TRUE;
                                int nRoll2 = d(8);
                                
                                while(nRoll = 8)
                                {
                                        nRoll = d8(1);
                                }
                                while (nRoll2 = 8)
                                {
                                        nRoll2 = d8(1);
                                }
                        }
                        
                        DoRay(oTarget, nSaveDC, nRoll);
                        
                        if(bTwoRolls == TRUE)
                        {                                 
                                if(!GetIsDead(oTarget)) //because let's face it; chances are good they are....
                                {
                                        DoRay(oTarget, nSaveDC, nRoll2);
                                }
                        }
                }
        }
        SPSetSchool();
}

void DoRay(object oTarget, int nSaveDC, int nRoll)
{
        int nDam;
        switch(nRoll)
        {
                case 1:
                {
                        nDam = 20;
                        
                        if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nSaveDC, SAVING_THROW_TYPE_FIRE))
                        {
                                nDam = nDam/2;
                        }
                        
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_FIRE), oTarget);
                        break;
                }
                
                case 2: 
                {
                        nDam = 40;
                        
                        if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nSaveDC, SAVING_THROW_TYPE_ACID))
                        {
                                nDam = nDam/2;
                        }
                        
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_ACID), oTarget);
                        break;                
                }
                
                case 3: 
                {
                        nDam = 80;
                        
                        if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nSaveDC, SAVING_THROW_TYPE_ELECTRICITY))
                        {
                                nDam = nDam/2;
                        }
                        
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_ELECTRICAL), oTarget);
                        break;
                }
                
                case 4: 
                {
                        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL))
                        {
                                DeathlessFrenzyCheck();
                                ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), oTarget);                                        
                        }
                        
                        else ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, d6(1), DURATION_TYPE_TEMPORARY, -1.0f, FALSE, 
                        break;   
                }
                
                case 5: 
                {
                        DoPetrification(nCasterLvl, oPC, oTarget, SPELL_PRISMATIC_RAY, nSaveDC);
                        break;
                }
                        
                case 6: 
                {
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL))
                        {
                                effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
                                effect eConfuse = EffectConfused();
                                effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
                                effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                                effect eLink = EffectLinkEffects(eMind, eConfuse);
                                       eLink = EffectLinkEffects(eLink, eDur);
                                       eLink = SupernaturalEffect(eLink);
                                       
                                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0, TRUE,-1,nCasterLvl);
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        }
                }
                
                case 7: 
                {
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL))
                        {
                                ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oTarget);
                                ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oTarget);
                                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oTarget);
                                
                                int nMessage = d6(1);
                                string sMessage;
                                
                                switch(nMessage)
                                {
                                        case 1:
                                        {
                                                sMessage = GetStringByStrRef(1729332);
                                                break;
                                        }
                                        
                                        case 2:
                                        {
                                                sMessage = GetStringByStrRef(1729333);
                                                break;
                                        }
                                        
                                        case 3:
                                        {
                                                sMessage = GetStringByStrRef(1729334);
                                                break;
                                        }
                                        
                                        case 4:
                                        {
                                                sMessage = GetStringByStrRef(1729335);
                                                break;
                                        }
                                        
                                        case 5:
                                        {
                                                sMessage = GetStringByStrRef(1729336);
                                                break;
                                        }
                                        
                                        case 6:
                                        {
                                                sMessage = GetStringByStrRef(1729337);
                                                break;
                                        }
                                }
                                
                                //Death Popup
                                DelayCommand(2.75, PopUpDeathGUIPanel(oTarget, FALSE , TRUE, sMessage));                                                 
                                DelayCommand(2.75, ExecuteScript("prc_ondeath", oTarget));                                        
                        }
                }
        }
}  