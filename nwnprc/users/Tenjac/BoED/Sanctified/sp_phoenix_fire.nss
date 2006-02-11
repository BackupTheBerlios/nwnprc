//::///////////////////////////////////////////////
//:: Name      Phoenix Fire
//:: FileName  sp_phoenix_fire.nss
//:://////////////////////////////////////////////
/** @file
Phoenix Fire
Necromancy [Fire, Good]
Level: Sanctified 7
Components: V,S,F,Sacrifice
Range: 15 feet
Area: 15 foot radius spread, centered on you
Duration: Instantaneous (see text)
Saving Throw: Reflex half (see text)
Spell Resistance: Yes (see text)

You immolate yourself, consuming your flesh in a
cloud of flame 20 feet high and 30 feet in diameter.
You die (no saving throw, and spell resistance does
not apply). Every evil creature within the cloud takes
2d6 points of damage per caster level (maximum 40d6).
Neutral characters take half damage (and a successful
Reflex save reduces that further in half), while good
characters take no damage at all. Half of the damage
dealt by the spell against any creature is fire; the
rest results directly from divine power and is 
therefore not subject to being reduced by resistance
to fire-based attacks, such as that granted by 
protection  from energy(fire), fire shield(chill 
shield), and similar magic.

After 10 minutes, you rise from the ashes as if restored
to life by a resurrection spell.

Sacrifice: Your death and the level you lose when you
return to life are the sacrifice cost for this spell.

*/
//  Author:   Tenjac
//  Created:  1/6/2006
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void Rebirth(object oPC)

	//Rebirth VFX
	
	//Resurrection
		
	//Level loss via death is going to be handled in different ways
	//in different modules, so I'm going to leave this out of the script
	//and opt to let the default death penalty of the module handle it
	//This provides continuity and ease of scripting.



void main()
{
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	//Define vars
	object oPC = OBJECT_SELF;
	object oTarget =GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nDam = 0;
	int nAlign;
		
	//Immolate VFX on caster
	
	//AoE VFX centered on you
					
	//Ash/smoke VFX at player's location
			
	//Kill player
	DeathlessFrenzyCheck();
			
	//Get first object in shape
	
	//While object valid
	while(GetIsObjectValid(oTarget))
	{
		//Get alignment
										
		//If alignment evil
		{
			//Spell Resistance
			{
				//Damage = 2d6/level
				
				//Reflex save for 1/2 damage
				
			}
		}
		
		//If alignment neutral
		{
			//Half damage for neutrality, Damage = 1d6
			nDam = d6(nCasterLvl)
			
			//Reflex for further 1/2
			
		}
		
		//Half divine, half fire
		
		//Apply damage
		
		//Get next object in shape
	}
	//Wait 10 minutes, then Rebirth
	DelayCommand(600.0f, Rebirth(oPC));
	
	SPSetSchool();
}
	
			
			
			
			

