//true form shifter class feat script
#include "pnp_shft_main"

void main()
{
    SetShiftTrueForm(OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_POLYMORPH),OBJECT_SELF);

    //re-equid creature items to get correct ip feats
    //(some were staying on even when they had been removed from the hide)
    object oHidePC = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);
    object oWeapCRPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,OBJECT_SELF);
    object oWeapCLPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,OBJECT_SELF);
    object oWeapCBPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,OBJECT_SELF);
    //mast not unequid the items, this would crash the game
    //but re-equiping the items when they are already equiped will
    //recheck what is on the hide
    DelayCommand(0.0,AssignCommand(OBJECT_SELF,ActionEquipItem(oHidePC,INVENTORY_SLOT_CARMOUR)));
    DelayCommand(0.0,AssignCommand(OBJECT_SELF,ActionEquipItem(oWeapCRPC,INVENTORY_SLOT_CWEAPON_R)));
    DelayCommand(0.0,AssignCommand(OBJECT_SELF,ActionEquipItem(oWeapCLPC,INVENTORY_SLOT_CWEAPON_L)));
    DelayCommand(0.0,AssignCommand(OBJECT_SELF,ActionEquipItem(oWeapCBPC,INVENTORY_SLOT_CWEAPON_B)));
    //all other script content has been moved to other places
}
