//::///////////////////////////////////////////////
//:: Call Lightning
//:: NW_S0_CallLghtn.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spells smites an area around the caster
    with bolts of lightning which strike all enemies.
    Bolts do 1d10 per level up 10d10
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    int nSpellID = PRCGetSpellId();
    SPSetSchool(GetSpellSchool(nSpellID));

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nCasterLvl = PRCGetCasterLevel(oCaster);

    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDamage;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
	effect eVis2 = EffectVisualEffect(916); //VFX_SPELL_HIT_CALL_LIGHTNING
	effect eDur = EffectVisualEffect(915); //VFX_SPELL_DUR_CALL_LIGHTNING
	effect eLink = EffectLinkEffects(eVis, eVis2);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    
    int EleDmg = ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_ELECTRICAL);
    
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
           //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetRandomDelay(0.4, 1.75);
            if (!MyPRCResistSpell(OBJECT_SELF, oTarget,(nCasterLvl + SPGetPenetr()), fDelay))
            {
                //Limit Caster level for the purposes of damage
                if (nCasterLvl > 10)
                {
                    nCasterLvl = 10;
                }
                
                //Roll damage for each target
                nDamage = d6(nCasterLvl);
                //Resolve metamagic
                if (nMetaMagic & METAMAGIC_MAXIMIZE)
                {
                    nDamage = 6 * nCasterLvl;
                }
                else if (nMetaMagic & METAMAGIC_EMPOWER)
                {
                   nDamage = nDamage + nDamage / 2;
                }
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_ELECTRICITY);
                //Set the damage effect
                eDam = EffectDamage(nDamage, EleDmg);
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target. 
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
             }
        }
       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    SPSetSchool();

}
