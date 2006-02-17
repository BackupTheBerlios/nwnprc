//::///////////////////////////////////////////////
//:: Name: Red Fester
//:: Filename: sp_red_fester.nss
//::///////////////////////////////////////////////
/**Red Fester
Necromancy [Evil]
Level: Corrupt 3
Components: V, S, Corrupt
Casting Time: 1 action
Range: Touch
Target: Creature touched
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

The subject's skin turns red and blisters. The 
blisters quickly turn into oozing wounds. Furthermore,
the subject's sense of self becomes strangely clouded,
diminishing her self-esteem. The subject takes 1d6 
points of Strength damage and 1d4 points of Charisma 
damage.

Corruption Cost: 1d6 points of Strength damage.
    
@author Written By: Tenjac
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void main()
{
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	//define vars
	
	
	
	SPRaiseSpellCastAt(oTarget, TRUE, SPELL_RED_FESTER, oPC);
	
	//Spell Resist
	{
		//Fort save
		{
			//1d6 STR
			
			//1d4 CHA
		}
	}
	
	//Corruption cost 1d6 STR
	
	
	SPSetSchool();
}