////////////////////////////////////////////////////////////////////////////////
//                                IMBUE ARROW                                 //
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  Script ran when the Imbue Arrow feat is used.                             //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
//Edited By   : Nailog                                                        //
//Last Edited : 7-26-2004                                                     //
////////////////////////////////////////////////////////////////////////////////

#include "prc_alterations"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    //modified by primogenitor
    //removed conversation etc, now in main spellhook instead
    //this feat will be applied as a bonus feat on the hide
    //when the switch PRC_USE_NEW_IMBUE_ARROW is off
    /*//Reroute feat to conversation, only for PCs.
    if (GetIsPC(OBJECT_SELF))
    {

        string sScript =  PRCGetUserSpecificSpellScript();
        if (sScript != "aa_spellhook")
        {
            SetLocalString(OBJECT_SELF,"temp_spell_at_inst",sScript);
            PRCSetUserSpecificSpellScript("aa_spellhook");
        }
        //If in combat, can't converse.
        if (GetIsInCombat())
        {
            FloatingTextStringOnCreature("* cast spell on arrow to Imbue *", OBJECT_SELF);
        }
        else
        {
            ActionStartConversation(OBJECT_SELF, "aa_imbuearrow", TRUE, FALSE);
        }
    }
    else
    {*/

    ////////////////////////////////////////////////////////////////////////////
    // DEFAULT IMBUE ARROW SCRIPT                                             //
    ////////////////////////////////////////////////////////////////////////////
    //                                                                        //
    //   Allow NPCs to continue using old imbue arrow, since writing AI to    //
    // handle new imbue would be a large task.                                //
    //                                                                        //
    ////////////////////////////////////////////////////////////////////////////

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER,oCaster); // * get a bonus of +10 to make this useful for arcane archer
    int nDamage;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 10)
    {
        nCasterLvl = 10 + ((nCasterLvl-10)/2);      // add some epic progression of 1d6 per 2 levels after 10
    }
    else // * preserve minimum damage of 10d6
    {
         nCasterLvl = 10;
    }
    object oTarget = GetSpellTargetObject();
    // * GZ: Add arrow damage if targeted on creature...
    if (GetIsObjectValid(oTarget ))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
          int nTouch = PRCDoRangedTouchAttack(oTarget);;
          if (nTouch > 0)
          {

            nDamage = ArcaneArcherDamageDoneByBow(nTouch ==2);

            int  nBonus = ArcaneArcherCalculateBonus() ;
            effect ePhysical = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING,IPGetDamagePowerConstantFromNumber(nBonus));
            effect eMagic = EffectDamage(nBonus, DAMAGE_TYPE_MAGICAL);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, ePhysical, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eMagic, oTarget);
          }
        }
    }

    //Apply the fireball explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) == TRUE)
        {

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId(), TRUE));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            if (!MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr(), fDelay))
            {
                //Roll damage for each target
                nDamage = d6(nCasterLvl);
                //Resolve metamagic
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_FIRE);
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
             }
        }
       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }

    ////////////////////////////////////////////////////////////////////////////
    // END DEFAULT                                                            //
    ////////////////////////////////////////////////////////////////////////////

    //}
}


