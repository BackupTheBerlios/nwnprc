#include "prc_inc_clsfunc"
#include "prc_class_const"
#include "prc_feat_const"
#include "prc_inc_breath"

void main()
{

    if(GetLocalInt(OBJECT_SELF, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE") == 1)
    {
        // PC is in Drunken Rage
        // Check for alcohol:
        if(UseAlcohol(OBJECT_SELF) == FALSE)
        {
            // PC has no drinks left, remove Drunken Rage effects for Breath of Flame:
            RemoveDrunkenRageEffects(OBJECT_SELF);
        }
    }
    else
    {
        //PC is NOT in a Drunken Rage, Check for alcohol:
        if(UseAlcohol(OBJECT_SELF) == FALSE)
        {
        // PC has no alcohol in inventory or in system, exit:
        FloatingTextStringOnCreature("Breath of Flame not possible", OBJECT_SELF);
        SendMessageToPC(OBJECT_SELF, "Breath of Flame not possible: You don't have any alcohol in your system or in your inventory.");
        return;
        }
    }

    // Breath of Flame:
    int nClass = GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, OBJECT_SELF);
    struct breath FlameBreath;

    effect eVis;

    eVis = EffectVisualEffect(494);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    
    FlameBreath = CreateBreath(OBJECT_SELF, FALSE, 20.0, DAMAGE_TYPE_FIRE, 12, 3, ABILITY_CONSTITUTION, nClass, BREATH_NORMAL, 0);
    
    ApplyBreath(FlameBreath, GetSpellTargetLocation());

}
