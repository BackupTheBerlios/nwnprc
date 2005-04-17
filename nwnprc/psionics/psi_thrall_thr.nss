/**
 * Thrallherd: Thrallherd
 * 16/04/2005
 * Stratovarius
 */

#include "prc_class_const"
#include "prc_feat_const"
#include "nw_o2_coninclude"
#include "x2_i0_spells"
#include "inc_rand_equip"

void CleanCopy(object oImage)
{     
     SetLootable(oImage, FALSE);
     object oItem = GetFirstItemInInventory(oImage);
     while(GetIsObjectValid(oItem))
     {
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
        oItem = GetNextItemInInventory(oImage);
     }
     int i;
     for(i=0;i<NUM_INVENTORY_SLOTS;i++)//equipment
     {
        oItem = GetItemInSlot(i, oImage);
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
     }
     TakeGoldFromCreature(GetGold(oImage), oImage, TRUE);
}

void main()
{
    if (GetIsObjectValid(GetLocalObject(OBJECT_SELF, "Thrallherd"))) return;
    int nMax = GetMaxHenchmen();
    
    int i = 1;
    object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, OBJECT_SELF, i);
    
    while (GetIsObjectValid(oHench))
    {
    	i += 1;
    	oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, OBJECT_SELF, i);
    }
    
    if (i >= nMax) SetMaxHenchmen(i+1);
    
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    
   int nHD = GetHitDice(OBJECT_SELF);
   int nClass = GetLevelByClass(CLASS_TYPE_THRALLHERD, OBJECT_SELF);
   int nCha = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);

   int nLead = nHD + nClass + nCha;
   int nLevel;
   
   if (nLead = 1) nLevel = 0;
   if (nLead = 2) nLevel = 1;
   if (nLead = 3) nLevel = 2;
   if (nLead = 4) nLevel = 3;
   if (nLead = 5) nLevel = 3;
   if (nLead = 6) nLevel = 4;
   if (nLead = 7) nLevel = 5;
   if (nLead = 8) nLevel = 5;
   if (nLead = 9) nLevel = 6;
   if (nLead = 10) nLevel = 7;
   if (nLead = 11) nLevel = 7;
   if (nLead = 12) nLevel = 8;
   if (nLead = 13) nLevel = 9;
   if (nLead = 14) nLevel = 10;
   if (nLead = 15) nLevel = 10;
   if (nLead = 16) nLevel = 11;
   if (nLead = 17) nLevel = 12;
   if (nLead = 18) nLevel = 12;
   if (nLead = 19) nLevel = 13;
   if (nLead = 20) nLevel = 14;
   if (nLead = 21) nLevel = 15;
   if (nLead = 22) nLevel = 15;
   if (nLead = 23) nLevel = 16;
   if (nLead = 24) nLevel = 17;
   if (nLead >= 25) nLevel = 17;
   
   FloatingTextStringOnCreature("Leadship Score: " + IntToString(nLead), OBJECT_SELF, FALSE);
   
   object oCreature = CreateObject(OBJECT_TYPE_CREATURE, "psi_thrall_rogue", GetSpellTargetLocation(), FALSE, "psi_thrall_thrall");
   AddHenchman(OBJECT_SELF, oCreature);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
   SetLocalObject(oCreature, "Thrallherd", OBJECT_SELF);
   
   int n;
   for(n=1;n<nLevel;n++)
   {
   	LevelUpHenchman(oCreature, CLASS_TYPE_INVALID, TRUE);
   }   
   for(n=1;n<3;n++)
   {
   	GenerateBossTreasure(oCreature);
   }    
   
   EquipWeapon(oCreature);
   EquipArmor(oCreature);
   EquipMisc(oCreature);
   
   CleanCopy(oCreature);
   
   SetMaxHenchmen(nMax);
}
