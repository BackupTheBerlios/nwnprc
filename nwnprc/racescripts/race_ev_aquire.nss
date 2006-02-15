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
    int nBaseItem  = GetBaseItemType(oItem);
    string sResRef = GetStringLowerCase(GetResRef(oItem));
    if(nBaseItem == BASE_ITEM_CBLUDGWEAPON                         ||
       nBaseItem == BASE_ITEM_CPIERCWEAPON                         ||
       nBaseItem == BASE_ITEM_CREATUREITEM                         ||
       nBaseItem == BASE_ITEM_CSLASHWEAPON                         ||
       nBaseItem == BASE_ITEM_CSLSHPRCWEAP                         ||
       sResRef == "hidetoken"                                      ||
       sResRef == GetStringLowerCase(PRC_MANIFESTATION_TOKEN_NAME)
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
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_ARC_DWARF)   ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_AZER)        ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_DUERGAR)     ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GOLD_DWARF)  ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_URDINNIR)    ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_WILD_DWARF)  ));
                    break;
                case RACIAL_TYPE_ELF:
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_AQELF)      ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_AVARIEL)    ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_DROW_FEMALE)));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_DROW_MALE)  ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_FEYRI)      ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_SUN_ELF)    ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_WILD_ELF)   ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_WOOD_ELF)   ));
                    break;
                case RACIAL_TYPE_GNOME:
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_FOR_GNOME)   ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_ROCK_GNOME)  ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_DEEP_GNOME)  ));//aka SVIRFNEBLIN
                    break;
                case RACIAL_TYPE_HALFLING:
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_DEEP_HALFLING)       ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GHOSTWISE_HALFLING)  ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_STRONGHEART_HALFLING)));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_TALLFELLOW_HALFLING) ));
                    break;
                case RACIAL_TYPE_HALFELF:
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_HALFDROW)));
                    break;
                case RACIAL_TYPE_HALFORC:
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_ORC)     ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_OROG)    ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GRAYORC) ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_TANARUKK)));
                    break;
                case RACIAL_TYPE_HUMAN:
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_IMASKARI)    ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_AIR_GEN)     ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_EARTH_GEN)   ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_FIRE_GEN)    ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_WATER_GEN)   ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_TIEFLING)    ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_AASIMAR)     ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GITHZERAI)   ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GITHYANKI)   ));
                    break;
                case RACIAL_TYPE_ABERRATION:
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_ILLITHID)    ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_PURE_YUAN)   ));
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
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GOBLIN)      ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_HOBGOBLIN)   ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_BUGBEAR)     ));
                    break;
                case RACIAL_TYPE_HUMANOID_MONSTROUS:
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_MINOTAUR)));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GNOLL)   ));
                    break;
                case RACIAL_TYPE_HUMANOID_ORC:
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_ORC)     ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_OROG)    ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GRAYORC) ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_TANARUKK)));
                    break;
                case RACIAL_TYPE_HUMANOID_REPTILIAN:
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_LIZARDFOLK)  ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_KOBOLD)      ));
                    break;
                case RACIAL_TYPE_ELEMENTAL:
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_AIR_GEN)     ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_EARTH_GEN)   ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_FIRE_GEN)    ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_WATER_GEN)   ));
                    break;
                case RACIAL_TYPE_FEY:
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_PIXIE)));
                    break;
                case RACIAL_TYPE_GIANT:
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_OGRE)    ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_HALFOGRE)));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_TROLL)   ));
                    break;
                case RACIAL_TYPE_MAGICAL_BEAST:
                    break;
                case RACIAL_TYPE_OUTSIDER:
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_TIEFLING)    ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_AASIMAR)     ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_TANARUKK)    ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_AZER)        ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_NERAPHIM)    ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_SHADOWSWYFT) ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_PIXIE)       ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GITHZERAI)   ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_GITHYANKI)   ));
                    DelayCommand(0.0f, IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(RACIAL_TYPE_FEYRI)       ));
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