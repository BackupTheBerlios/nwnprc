#include "prc_drnknmstr"
#include "prc_class_const"
#include "prc_feat_const"

void main()
{
object oItem = GetSpellTargetObject();
if(GetTag(oItem) == "NW_IT_MPOTION021" || GetTag(oItem) == "NW_IT_MPOTION022" ||
   GetTag(oItem) == "NW_IT_MPOTION023" || GetTag(oItem) == "DragonsBreath")
    {
    //Destroy the choosen alcoholic drink:
    SetPlotFlag(oItem, FALSE);
    if(GetItemStackSize(oItem) > 1)
        {SetItemStackSize(oItem, GetItemStackSize(oItem) - 1);}
    else
        {DestroyObject(oItem);}

    //Cure Critical Wounds
    spellsCure(d8(6), 20, 32, VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_G, GetSpellId());
    FloatingTextStringOnCreature("Heal Potion Created", OBJECT_SELF);
    }
    else
    {
    FloatingTextStringOnCreature("This is not a valid alcoholic beverage", OBJECT_SELF);
    IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PRESTIGE_FOR_MEDICINAL_PURPOSES);
    }
}
