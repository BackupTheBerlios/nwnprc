void main()
{

object oPC = OBJECT_SELF;
object oScribe = GetFirstItemInInventory(oPC);

     while(GetIsObjectValid(oScribe))
      {
           if(GetResRef(oScribe) == "runescarreddagge")
           {
            SetLocalString(oScribe, "la_divfavor", "1");
           }
      oScribe = GetNextItemInInventory(oPC);
      }
}
