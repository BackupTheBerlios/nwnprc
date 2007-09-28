//::///////////////////////////////////////////////
//:: Attune Gem
//:: 
/*
    Tells the maximum spell level the gem can be used for
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sept 28, 2007
//:://////////////////////////////////////////////

void main()
{
	object oItem = GetSpellTargetObject();
	int nGold = GetGoldPieceValue(oItem);
	int nLevel = nGold / 50;
	if (nLevel > 9) nLevel = 9;
	FloatingTextStringOnCreature("The maximum attunable spell level is " + IntToString(nLevel), OBJECT_SELF, FALSE);
}