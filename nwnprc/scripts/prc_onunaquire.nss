//
// Stub function for possible later use.
//

void main()
{
    object oItem = GetModuleItemLost();
    itemproperty ip = GetFirstItemProperty(oItem);
   
    // Remove all temporary item properties when dropped/given away/stolen/sold.
    if (GetIsObjectValid(oItem))
    {
        while (GetIsItemPropertyValid(ip))
        {
            if (GetItemPropertyDurationType(ip) == DURATION_TYPE_TEMPORARY)
            {
                RemoveItemProperty(oItem, ip);
            }
            ip = GetNextItemProperty(oItem);
        }
    }
}
