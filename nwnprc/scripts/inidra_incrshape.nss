#include "soul_inc"
#include "NW_I0_GENERIC"
#include "nw_i0_spells"

void main()
{
        
   if (GetHasEffect(EFFECT_TYPE_POLYMORPH)== FALSE)
   {
   	RemoveSpellEffects(SPELL_SHAPE_INCREASE_DAMAGE,OBJECT_SELF,OBJECT_SELF);
   	return;
   }
   
   if(GetHasSpellEffect(SPELL_SHAPE_INCREASE_DAMAGE) == FALSE)
   {
        AddIniDmg(OBJECT_SELF) ;
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectVisualEffect(VFX_DUR_LIGHT_BLUE_10),OBJECT_SELF);     
   }
   
}