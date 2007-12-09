/*
   ----------------
   Divine Surge, Greater, Increment

   tob_dvsp_dvnsrgg
   ----------------

   05/06/07 by Stratovarius
*/ /** @file

    Divine Surge, Greater

    Devoted Spirit (Strike)
    Level: Crusader 4
    Prerequisite: One Devoted Spirit Maneuver
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    Your body shakes and spasms as unfettered divine energy courses through it.
    This power sparks off your weapon and courses into your foe,
    devastating your enemy but leaving you drained.
    
    You make a single attack against an enemy. If this attack his, you deal 6d8 extra damage.
    For every point of constitution damage voluntarily taken, you gain a +1 bonus to attack and +2d8 damage.
    You can sacrifice a number of con points equal to your initiator level.
*/

void main()
{

	object oPC = OBJECT_SELF;
	string nMes = "";

	int nCount = GetLocalInt(oPC, "DVGreaterSurge");
	nCount += 1;
	if (nCount > 20) nCount = 20;
	SetLocalInt(oPC, "DVGreaterSurge", nCount);	
	nMes = "Divine Surge, Greater: Constitution damage set to " + IntToString(nCount);
	FloatingTextStringOnCreature(nMes, oPC, FALSE);
}