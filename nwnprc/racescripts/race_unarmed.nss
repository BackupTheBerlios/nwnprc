// :: race_unarmed
// :: by WodahsEht 9/27/04
// ::
// :: Determines the appropriate natural attacks for races.

#include "prc_inc_unarmed"
#include "prc_racialtypes_const"

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
         object oWeapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, OBJECT_SELF);

         UnarmedFeats(OBJECT_SELF);
         UnarmedFists(OBJECT_SELF);
         
         // The unarmed creature weapon we equip defaults to bludgeoning. (Centaur and Illithid)
         // piercing attacks.
         if (iRace == RACIAL_TYPE_TANARUKK || iRace == RACIAL_TYPE_MINOTAUR)
             AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyExtraMeleeDamageType(IP_CONST_DAMAGETYPE_PIERCING),oWeapL);

         // These guys have two attacks so I just went with their claws
         // slashing attacks.
         else if (iRace == RACIAL_TYPE_TROLL || iRace == RACIAL_TYPE_RAKSHASA || iRace == RACIAL_TYPE_LIZARDFOLK) // claws
             AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyExtraMeleeDamageType(IP_CONST_DAMAGETYPE_SLASHING),oWeapL);
    }
}