void main()
{
   object oTarget;
   object oPC = OBJECT_SELF;
   object oWeap = GetFirstItemInInventory(oPC);

   object oItem1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
   object oItem2 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
   FloatingTextStringOnCreature("Left Exec",OBJECT_SELF);
   //Searches Inventory for Katana and Shortsword and Equips them
   while(!GetIsObjectValid(oItem2))
   {
   	if(GetBaseItemType(oWeap) == BASE_ITEM_KATANA)
	{
     		oItem2 = oWeap;
		ActionEquipItem(oWeap,INVENTORY_SLOT_RIGHTHAND);
	}      
	oWeap = GetNextItemInInventory(oPC);
   }
//ExecuteScript("prc_cwsm_right", oPC);
}