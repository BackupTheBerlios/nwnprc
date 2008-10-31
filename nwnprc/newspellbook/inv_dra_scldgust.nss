
#include "prc_inc_spells"

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{

    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    //Declare major variables
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    object oTarget;
    float fDelay;
    effect eDmg = EffectDamage(CasterLvl, DAMAGE_TYPE_FIRE);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    int nPenetr = CasterLvl + SPGetPenetr();
    
    //Get first target in the spell cylinder
    oTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, FeetToMeters(60.0), GetSpellTargetLocation(), 
                                   TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEAR));
            //Make SR Check
            if(!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr, fDelay))
            {   
            	if(PRCGetCreatureSize(oTarget) < CREATURE_SIZE_MEDIUM)
	     	     if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetInvocationSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_NONE))
                     {
                     	 effect eWindblown = EffectKnockdown();
                     	 DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWindblown, oTarget, 6.0));
                     }
                     
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
        //Get next target in the spell cylinder
        oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, FeetToMeters(60.0), GetSpellTargetLocation(), 
                                      TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
    }
    

}

