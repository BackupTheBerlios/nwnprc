// :: race_unarmed
// :: by WodahsEht 9/27/04
// ::
// :: Determines the appropriate natural attacks for races.

#include "prc_inc_unarmed"
#include "prc_racial_const"

void main ()
{
    int iRace = GetRacialType(OBJECT_SELF);
    
    if (iRace == RACIAL_TYPE_MINOTAUR ||
        iRace == RACIAL_TYPE_TANARUKK ||
        iRace == RACIAL_TYPE_TROLL ||
        iRace == RACIAL_TYPE_RAKSHASA ||
        iRace == RACIAL_TYPE_CENTAUR ||
        iRace == RACIAL_TYPE_ILLITHID ||
        iRace == RACIAL_TYPE_LIZARDFOLK)
    {
         UnarmedFeats(OBJECT_SELF);
         UnarmedFists(OBJECT_SELF);

         object oWeapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, OBJECT_SELF);
         int iUseRacial = GetLocalInt(OBJECT_SELF, "UsesRacialAttack");
         
         // The unarmed creature weapon we equip defaults to bludgeoning. (Centaur and Illithid)
         
         // piercing attacks.
         if ((iRace == RACIAL_TYPE_TANARUKK || iRace == RACIAL_TYPE_MINOTAUR) && iUseRacial)
             AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyExtraMeleeDamageType(IP_CONST_DAMAGETYPE_PIERCING),oWeapL);

         // slashing attacks.
         else if ((iRace == RACIAL_TYPE_TROLL || iRace == RACIAL_TYPE_RAKSHASA || iRace == RACIAL_TYPE_LIZARDFOLK) && iUseRacial)
             AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyExtraMeleeDamageType(IP_CONST_DAMAGETYPE_SLASHING),oWeapL);
    }
}