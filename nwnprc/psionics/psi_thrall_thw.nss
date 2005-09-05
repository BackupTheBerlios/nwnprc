/**
 * Thrallherd: Thrallherd
 * 16/04/2005
 * Stratovarius
 
 Type of Feat: Class Specific
 Prerequisite: Thrallherd level 1.
 Specifics: A thrallherd who has just entered the class sends out a subtle psychic call for servants, and that call is answered. 
 The thrall who answers the call has a level equal to the following chart. Leadership score is calculated by adding Thrallherd's 
 total level to its Cha modifier and its Thrallherd level. A level 5 Psion/5 thrallherd, with a +5 Cha modifier, has a leadership 
 score of 20. A thrallherd can use this power 1/day and may only have 1 Thrall from this power.
 
 Leadership   Thrall Level
 1                   0
 2                   1
 3                   2
 4                   3
 5                   3
 6                   4
 7                   5
 8                   5
 9                   6
 10                 7
 11                 7
 12                 8
 13                 9
 14                 10
 15                 10
 16                 11
 17                 12
 18                 12
 19                 13
 20                 14
 21                 15
 22                 15
 23                 16
 24                 17
 25+               17
Use: Selected.
 
 */

#include "prc_class_const"
#include "prc_feat_const"
#include "nw_o2_coninclude"
#include "x2_i0_spells"
#include "inc_utility"

void CleanCopy(object oImage)
{     
     SetLootable(oImage, FALSE);
     object oItem = GetFirstItemInInventory(oImage);
     while(GetIsObjectValid(oItem))
     {
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_80_PERCENT), oItem);
        oItem = GetNextItemInInventory(oImage);
     }
     int i;
     for(i=0;i<NUM_INVENTORY_SLOTS;i++)//equipment
     {
        oItem = GetItemInSlot(i, oImage);
        SetDroppableFlag(oItem, FALSE);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_80_PERCENT), oItem);
        SetItemCursedFlag(oItem, TRUE);
     }
     TakeGoldFromCreature(GetGold(oImage), oImage, TRUE);
}

void main()
{
    int nMax = GetMaxHenchmen();
    
    int i = 1;
    object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, OBJECT_SELF, i);
    
    if (GetTag(oHench) == "psi_thrall_thrall")
    {
    	FloatingTextStringOnCreature("You already have a thrall", OBJECT_SELF, FALSE);
    	return;
    }
    
    while (GetIsObjectValid(oHench))
    {
    	i += 1;
    	oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, OBJECT_SELF, i);
        if (GetTag(oHench) == "psi_thrall_thrall")
	{
	    	FloatingTextStringOnCreature("You already have a thrall", OBJECT_SELF, FALSE);
	    	return;
    	}
    }
    
    if (i >= nMax) SetMaxHenchmen(i+1);
    
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    
   int nHD = GetHitDice(OBJECT_SELF);
   int nClass = GetLevelByClass(CLASS_TYPE_THRALLHERD, OBJECT_SELF);
   int nCha = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);

   int nLead = nHD + nClass + nCha;
   int nLevel;
   
   if (nLead == 1) nLevel = 0;
   if (nLead == 2) nLevel = 1;
   if (nLead == 3) nLevel = 2;
   if (nLead == 4) nLevel = 3;
   if (nLead == 5) nLevel = 3;
   if (nLead == 6) nLevel = 4;
   if (nLead == 7) nLevel = 5;
   if (nLead == 8) nLevel = 5;
   if (nLead == 9) nLevel = 6;
   if (nLead == 10) nLevel = 7;
   if (nLead == 11) nLevel = 7;
   if (nLead == 12) nLevel = 8;
   if (nLead == 13) nLevel = 9;
   if (nLead == 14) nLevel = 10;
   if (nLead == 15) nLevel = 10;
   if (nLead == 16) nLevel = 11;
   if (nLead == 17) nLevel = 12;
   if (nLead == 18) nLevel = 12;
   if (nLead == 19) nLevel = 13;
   if (nLead == 20) nLevel = 14;
   if (nLead == 21) nLevel = 15;
   if (nLead == 22) nLevel = 15;
   if (nLead == 23) nLevel = 16;
   if (nLead == 24) nLevel = 17;
   if (nLead >= 25) nLevel = 17;
   
   FloatingTextStringOnCreature("Leadship Score: " + IntToString(nLead), OBJECT_SELF, FALSE);
   
   object oCreature = CreateObject(OBJECT_TYPE_CREATURE, "psi_thrall_wiz", GetSpellTargetLocation(), FALSE, "psi_thrall_thrall");
   AddHenchman(OBJECT_SELF, oCreature);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
   
   int n;
   for(n=1;n<nLevel;n++)
   {
   	LevelUpHenchman(oCreature, CLASS_TYPE_INVALID, TRUE);
   }   
   for(n=1;n<nLevel;n++)
   {
   	GenerateBossTreasure(oCreature);
   }    
   
   EquipWeapon(oCreature);
   EquipArmor(oCreature);
   EquipMisc(oCreature);
   
   CleanCopy(oCreature);
   
   SetMaxHenchmen(nMax);
}
