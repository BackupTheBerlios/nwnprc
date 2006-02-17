//::///////////////////////////////////////////////
//:: Name: Seething Eyebane
//:: Filename: sp_seeth_eyebn.nss
//::///////////////////////////////////////////////
/**Seething Eyebane
Transmutation [Evil, Acid]
Level: Corrupt 1
Components: V, S, Corrupt
Casting Time: 1 action
Range: Touch
Target: Creature touched
Duration: Instantaneous
Saving Throw: Fortitude negates (see text)
Spell Resistance: Yes

The subject's eyes burst, spraying acid upon everyone
within 5 feet. The subject is blinded and takes 1d6
points of acid damage. Those sprayed take 1d6 points
of acid damage (Reflex save for half). Creatures 
without eyes can't be blinded, but they might take 
acid damage if someone nearby is the subject of 
seething eyebane.

Corruption Cost: 1d6 points of Constitution damage

@author Written By: Tenjac
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void main()
{
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION)
	//define vars
	
	
	SPRaiseSpellCastAt(oTarget, TRUE, SPELL_SEETHING_EYEBANE, oPC);
	
	//Spell Resistance
	{
		//Fort save
		{
			//Blind target permanently
			
			//nDam = 1d6 acid
			
			//apply damage
			
			//GetFirstObjectInShape
			
			//While object valid
			{
				//nDam 1d6 acid recalculated each time
			}
			
		}
	}
	//Corruption cost 1d6 CON regardless of success
	
	
	SPSetSchool();
}