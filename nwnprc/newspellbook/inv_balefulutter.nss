
//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"
#include "prc_alterations"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode())
    {
        return;
    }
    // End of Spell Cast Hook

    effect   eVis         = EffectVisualEffect( VFX_IMP_DESTRUCTION );
    int      nCasterLvl   = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    object   oTarget      = PRCGetSpellTargetObject();
    int nDC = SPGetSpellSaveDC(oTarget, OBJECT_SELF);

    
    if(GetIsObjectValid(oTarget) 
        && (GetObjectType(oTarget) == OBJECT_TYPE_DOOR || GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE))
    {
        effect eDamage = EffectDamage(9999, DAMAGE_TYPE_MAGICAL);
        effect eLink = EffectLinkEffects(eDamage, eVis);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
    }
    
    if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
		{
		    int i;
		    object oItem;
		    for(i = 0; i < NUM_INVENTORY_SLOTS; i++)
		    {
		        if(i != INVENTORY_SLOT_CARMOUR && i != INVENTORY_SLOT_CWEAPON_B &&
		           i != INVENTORY_SLOT_CWEAPON_L && i != INVENTORY_SLOT_CWEAPON_R)
		        {
		            oItem = GetItemInSlot(i, oTarget);
		            if(!GetIsItemPropertyValid(GetFirstItemProperty(oItem)))
		            {
		                DestroyObject(oItem);
		                i = NUM_INVENTORY_SLOTS;
		                effect eDaze = EffectDazed();
		                effect eDeaf = EffectDeaf();
		                effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
		                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, RoundsToSeconds(1),TRUE,-1,nCasterLvl);
		                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, TurnsToSeconds(1),TRUE,-1,nCasterLvl);
		                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		            }
		        }
		    }
		}
    }
}
