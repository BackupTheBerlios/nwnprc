void main()
{

object oPC = GetPCSpeaker();

AssignCommand(oPC, TakeGoldFromCreature(10000, oPC, TRUE));

CreateItemOnObject("shadowwalkerstok", oPC);

SetLocalInt(GetPCSpeaker(), "X1_AllowShaLow", 0);

}
