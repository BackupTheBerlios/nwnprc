void main()
{
   object oTarget;
   object oPC = OBJECT_SELF;
   object oWeap = GetFirstItemInInventory(oPC);

   object oItem1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
   object oItem2 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
   FloatingTextStringOnCreature("Right Exec",OBJECT_SELF);
   //Searches Inventory for Katana and Shortsword and Equips them
   while(!GetIsObjectValid(oItem1))
   {
              if(GetBaseItemType(oWeap) == BASE_ITEM_SHORTSWORD)
	{
		oItem1 = oWeap;
		ActionEquipItem(oWeap,INVENTORY_SLOT_LEFTHAND);
FloatingTextStringOnCreature("inside left hand loop",OBJECT_SELF);
	}
	oWeap = GetNextItemInInventory(oPC);
   }
}