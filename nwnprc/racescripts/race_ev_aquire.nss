/** @file
    This handles subraces and race restricted items.
    Drow should be able to use Elven only items for example.
*/

#include "prc_racial_const"
#include "prc_alterations"
#include "psi_inc_manifest"

void main()
{
    //object oCreature = GetModuleItemAcquiredBy();
    object oItem = GetModuleItemAcquired();
    //int nRace = GetRacialType(oCreature);

    // Only do this once per item
    if(GetLocalInt(oItem, "PRC_RacialRestrictionsExpanded"))
        return;
    SetLocalInt(oItem, "PRC_RacialRestrictionsExpanded", TRUE);

    // Ignore tokens and creature items
    string sResRef = GetStringLowerCase(GetResRef(oItem));
    if(sResRef == "base_prc_skin"                                  ||
       sResRef == "hidetoken"                                      ||
       sResRef == GetStringLowerCase(PRC_MANIFESTATION_TOKEN_NAME) ||
       GetIsPRCCreatureWeapon(oItem)
       )
        return;

    itemproperty ipTest = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ipTest))
    {
        if(GetItemPropertyType(ipTest)==ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE)
        {
            switch(GetItemPropertySubType(ipTest))
            {
                case RACIAL_TYPE_DWARF:
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_ARC_DWARF));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_AZER));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_DUERGAR));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GOLD_DWARF));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_URDINNIR));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_WILD_DWARF));
                    break;
                case RACIAL_TYPE_ELF:
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_AQELF));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_AVARIEL));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_DROW_FEMALE));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_DROW_MALE));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_FEYRI));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_SUN_ELF));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_WILD_ELF));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_WOOD_ELF));
                    break;
                case RACIAL_TYPE_GNOME:
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_FOR_GNOME));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_ROCK_GNOME));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_DEEP_GNOME));//aka SVIRFNEBLIN
                    break;
                case RACIAL_TYPE_HALFLING:
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_DEEP_HALFLING));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GHOSTWISE_HALFLING));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_STRONGHEART_HALFLING));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_TALLFELLOW_HALFLING));
                    break;
                case RACIAL_TYPE_HALFELF:
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_HALFDROW));
                    break;
                case RACIAL_TYPE_HALFORC:
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_ORC));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_OROG));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GRAYORC));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_TANARUKK));
                    break;
                case RACIAL_TYPE_HUMAN:
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_IMASKARI));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_AIR_GEN));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_EARTH_GEN));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_FIRE_GEN));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_WATER_GEN));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_TIEFLING));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_AASIMAR));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GITHZERAI));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GITHYANKI));
                    break;
                case RACIAL_TYPE_ABERRATION:
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_ILLITHID));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_PURE_YUAN));
                    break;
                case RACIAL_TYPE_ANIMAL:
                    break;
                case RACIAL_TYPE_BEAST:
                    break;
                case RACIAL_TYPE_CONSTRUCT:
                    break;
                case RACIAL_TYPE_DRAGON:
                    break;
                case RACIAL_TYPE_HUMANOID_GOBLINOID:
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GOBLIN));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_HOBGOBLIN));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_BUGBEAR));
                    break;
                case RACIAL_TYPE_HUMANOID_MONSTROUS:
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_MINOTAUR));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GNOLL));
                    break;
                case RACIAL_TYPE_HUMANOID_ORC:
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_ORC));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_OROG));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GRAYORC));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_TANARUKK));
                    break;
                case RACIAL_TYPE_HUMANOID_REPTILIAN:
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_LIZARDFOLK));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_KOBOLD));
                    break;
                case RACIAL_TYPE_ELEMENTAL:
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_AIR_GEN));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_EARTH_GEN));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_FIRE_GEN));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_WATER_GEN));
                    break;
                case RACIAL_TYPE_FEY:
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_PIXIE));
                    break;
                case RACIAL_TYPE_GIANT:
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_OGRE));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_HALFOGRE));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_TROLL));
                    break;
                case RACIAL_TYPE_MAGICAL_BEAST:
                    break;
                case RACIAL_TYPE_OUTSIDER:
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_TIEFLING));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_AASIMAR));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_TANARUKK));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_AZER));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_NERAPHIM));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_SHADOWSWYFT));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_PIXIE));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GITHZERAI));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GITHYANKI));
                    IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_FEYRI));
                    break;
                case RACIAL_TYPE_SHAPECHANGER:
                    break;
                case RACIAL_TYPE_UNDEAD:
                    break;
                case RACIAL_TYPE_VERMIN:
                    break;
            }
        }
        ipTest = GetNextItemProperty(oItem);
    }
}