// Spell switches
const string PRC_PNP_TRUESEEING                      = "PRC_PNP_TRUESEEING";
const string PRC_PNP_TRUESEEING_SPOT_BONUS           = "PRC_PNP_TRUESEEING_SPOT_BONUS";
const string PRC_BIOWARE_GRRESTORE                   = "PRC_BIOWARE_GRRESTORE";
const string PRC_BIOWARE_HEAL                        = "PRC_BIOWARE_HEAL";
const string PRC_BIOWARE_MASS_HEAL                   = "PRC_BIOWARE_MASS_HEAL";
const string PRC_BIOWARE_HARM                        = "PRC_BIOWARE_HARM";
const string PRC_BIOWARE_NEUTRALIZE_POISON           = "PRC_BIOWARE_NEUTRALIZE_POISON";
const string PRC_BIOWARE_REMOVE_DISEASE              = "PRC_BIOWARE_REMOVE_DISEASE";
const string PRC_TIMESTOP_BIOWARE_DURATION           = "PRC_TIMESTOP_BIOWARE_DURATION";
const string PRC_TIMESTOP_LOCAL                      = "PRC_TIMESTOP_LOCAL";
const string PRC_TIMESTOP_NO_HOSTILE                 = "PRC_TIMESTOP_NO_HOSTILE";
const string PRC_TIMESTOP_BLANK_PC                   = "PRC_TIMESTOP_BLANK_PC";
const string PRC_MUTLISUMMON                         = "PRC_MULTISUMMON";
const string PRC_SUMMON_ROUND_PER_LEVEL              = "PRC_SUMMON_ROUND_PER_LEVEL";
const string PRC_PNP_ELEMENTAL_SWARM                 = "PRC_PNP_ELEMENTAL_SWARM";

// Epic spell switches
const string PRC_EPIC_INGORE_DEFAULTS                = "PRC_EPIC_INGORE_DEFAULTS";
const string PRC_EPIC_XP_COSTS                       = "PRC_EPIC_XP_COSTS";
const string PRC_EPIC_TAKE_TEN_RULE                  = "PRC_EPIC_TAKE_TEN_RULE";
const string PRC_EPIC_PRIMARY_ABILITY_MODIFIER_RULE  = "PRC_EPIC_PRIMARY_ABILITY_MODIFIER_RULE";
const string PRC_EPIC_BACKLASH_DAMAGE                = "PRC_EPIC_BACKLASH_DAMAGE";
const string PRC_EPIC_FOCI_ADJUST_DC                 = "PRC_EPIC_FOCI_ADJUST_DC";
const string PRC_EPIC_GOLD_MULTIPLIER                = "PRC_EPIC_GOLD_MULTIPLIER";
const string PRC_EPIC_XP_FRACTION                    = "PRC_EPIC_XP_FRACTION";
const string PRC_EPIC_FAILURE_FRACTION_GOLD          = "PRC_EPIC_FAILURE_FRACTION_GOLD";
const string PRC_EPIC_BOOK_DESTRUCTION               = "PRC_EPIC_BOOK_DESTRUCTION";

// General switches
const string PRC_STAFF_CASTER_LEVEL                  = "PRC_STAFF_CASTER_LEVEL";
const string PRC_BREW_POTION_CASTER_LEVEL            = "PRC_BREW_POTION_CASTER_LEVEL";
const string PRC_SCRIBE_SCROLL_CASTER_LEVEL          = "PRC_SCRIBE_SCROLL_CASTER_LEVEL";
const string PRC_CRAFT_WAND_CASTER_LEVEL             = "PRC_CRAFT_WAND_CASTER_LEVEL";
const string PRC_NPC_HAS_PC_SPELLCASTING             = "PRC_NPC_HAS_PC_SPELLCASTING";
const string PRC_USE_DATABASE                        = "PRC_USE_DATABASE";

// Poison system switches
const string PRC_USE_TAGBASED_INDEX_FOR_POISON       = "USE_TAGBASED_INDEX_FOR_POISON";
const string PRC_USES_PER_ITEM_POISON_DIE            = "USES_PER_ITEM_POISON_DIE";
const string PRC_USES_PER_ITEM_POISON_COUNT          = "PRC_USES_PER_ITEM_POISON_COUNT";
const string PRC_ALLOW_ONLY_SHARP_WEAPONS            = "PRC_ALLOW_ONLY_SHARP_WEAPONS";
const string PRC_ALLOW_ALL_POISONS_ON_WEAPONS        = "PRC_ALLOW_ALL_POISONS_ON_WEAPONS";
const string PRC_USE_DEXBASED_WEAPON_POISONING_FAILURE_CHANCE = "PRC_USE_DEXBASED_WEAPON_POISONING_FAILURE_CHANCE";
const string PRC_USES_PER_WEAPON_POISON_DIE          = "PRC_USES_PER_WEAPON_POISON_DIE";
const string PRC_USES_PER_WEAPON_POISON_COUNT        = "PRC_USES_PER_WEAPON_POISON_COUNT";

// Psionics switches
const string PRC_PSI_ASTRAL_CONSTRUCT_USE_2DA        = "ASTRAL_CONSTRUCT_USE_2DA";
const string PRC_PNP_RAPID_METABOLISM                = "PRC_PNP_RAPID_METABOLISM";
const string PRC_PSI_IMP_METAPSIONICS_USE_SUM        = "PRC_PSI_IMP_METAPSIONICS_USE_SUM";

// Combat System Switches 
const string PRC_PNP_ELEMENTAL_DAMAGE = "PRC_PNP_ELEMENTAL_DAMAGE";

// Unarmed Damage
const string PRC_3_5e_FIST_DAMAGE = "PRC_3_5e_FIST_DAMAGE";
const string PRC_BRAWLER_SIZE = "PRC_BRAWLER_SIZE";


//Checks the state of a PRC switch
int GetPRCSwitch(string sSwitch);
//Sets a PRC switch state
void SetPRCSwitch(string sSwitch, int nState);

int GetPRCSwitch(string sSwitch)
{
    return GetLocalInt(GetModule(), sSwitch);
}

void SetPRCSwitch(string sSwitch, int nState)
{
    SetLocalInt(GetModule(), sSwitch, nState);
}

void MultisummonPreSummon(object oPC = OBJECT_SELF)
{
    if(!GetPRCSwitch(PRC_MUTLISUMMON))
        return;
    int i=1;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    while(GetIsObjectValid(oSummon))
    {
        AssignCommand(oSummon, SetIsDestroyable(FALSE, FALSE, FALSE));
        AssignCommand(oSummon, DelayCommand(0.1, SetIsDestroyable(TRUE, FALSE, FALSE)));
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    }
}

void DoEpicSpellDefaults()
{
    if(!GetPRCSwitch(PRC_EPIC_INGORE_DEFAULTS))
        return;
    SetPRCSwitch(PRC_EPIC_XP_COSTS, TRUE);        
    SetPRCSwitch(PRC_EPIC_BACKLASH_DAMAGE, TRUE);
    SetPRCSwitch(PRC_EPIC_FOCI_ADJUST_DC, TRUE);
    SetPRCSwitch(PRC_EPIC_GOLD_MULTIPLIER, 9000);
    SetPRCSwitch(PRC_EPIC_XP_FRACTION, 25);
    SetPRCSwitch(PRC_EPIC_FAILURE_FRACTION_GOLD, 2);
    SetPRCSwitch(PRC_EPIC_BOOK_DESTRUCTION, 50);
}