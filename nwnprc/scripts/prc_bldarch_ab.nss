// Acidic Blood for the Bloodarcher by Zedium
#include "prc_alterations"
#include "prc_feat_const"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"


void main()
{
    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nDamage;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Apply the fireball explosion at the location captured above.
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            // neither spell ID is that of acid blood.
            // since there is no spell ID remove the if statement
            //if((GetSpellId() == 341) || GetSpellId() == 58)
            //{
                //Fire cast spell at event for the specified target
                //SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FIREBALL));
                
                //Get the distance between the explosion and the target to calculate delay
                //fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                
                if (GetLevelByClass(CLASS_TYPE_BLARCHER,OBJECT_SELF) == 0)
                {
                    //Roll damage for each target
                    nDamage = d6(1);
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_ACID));
                    if(nDamage > 0)
                    {
                        // Apply effects to the currently selected target.
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                        //This visual effect is applied to the target object not the location as above.
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    }
                 }
             //}
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}