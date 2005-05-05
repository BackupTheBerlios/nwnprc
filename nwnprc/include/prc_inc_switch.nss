// Spell switches
const string PRC_PNP_TRUESEEING                      = "PRC_PNP_TRUESEEING";
//bioware trueseeing can see stealthed creatures
//this replaces the trueseeing effect with a seeinvisible + ultravision + spot bonus
const string PRC_PNP_TRUESEEING_SPOT_BONUS           = "PRC_PNP_TRUESEEING_SPOT_BONUS";
//prc_pnp_trueseeing must be on
//value of spot skill bonus that trueseeing grants
//defaults to +15 if not set
const string PRC_BIOWARE_GRRESTORE                   = "PRC_BIOWARE_GRRESTORE";
const string PRC_BIOWARE_HEAL                        = "PRC_BIOWARE_HEAL";
const string PRC_BIOWARE_MASS_HEAL                   = "PRC_BIOWARE_MASS_HEAL";
const string PRC_BIOWARE_HARM                        = "PRC_BIOWARE_HARM";
const string PRC_BIOWARE_NEUTRALIZE_POISON           = "PRC_BIOWARE_NEUTRALIZE_POISON";
const string PRC_BIOWARE_REMOVE_DISEASE              = "PRC_BIOWARE_REMOVE_DISEASE";
//removes the caps PRC added to these spells
const string PRC_TIMESTOP_BIOWARE_DURATION           = "PRC_TIMESTOP_BIOWARE_DURATION";
//timestop has bioware durations (9seconds or 18 for greater timestop) rather 
//than PnP durations (1d4+1 or 2d4+2)
const string PRC_TIMESTOP_LOCAL                      = "PRC_TIMESTOP_LOCAL";
//timestop has only a local affect, i.e doenst stop people on the other side of the server
//AOEs continue to act during a timestop, and durations/delayed events still occor
const string PRC_TIMESTOP_NO_HOSTILE                 = "PRC_TIMESTOP_NO_HOSTILE";
//prc_timestop_local must be enabled
//caster cant perform any hostile actions while in timestop
const string PRC_TIMESTOP_BLANK_PC                   = "PRC_TIMESTOP_BLANK_PC";
//prc_timestop_local must be enabled
//pcs cant see anything while stopped
//this might look to the player like their PC crashed
const string PRC_MUTLISUMMON                         = "PRC_MULTISUMMON";
//second or subsequent summons dont destroy the first
//can cause lag with high numbers of summons and/or tight spaces
const string PRC_SUMMON_ROUND_PER_LEVEL              = "PRC_SUMMON_ROUND_PER_LEVEL";
//summons last for a number of rounds equal to caster level, rather than 24h or other timings
const string PRC_PNP_ELEMENTAL_SWARM                 = "PRC_PNP_ELEMENTAL_SWARM";
//instead of biowares sequential summons it creates multiple elementals
//only works if prc_multisummon is on
const string PRC_PNP_FEAR_AURAS                      = "PRC_PNP_FEAR_AURAS";
//if you pass a save, you cant be affected by that aura for 24h
//not implemented yet
const string PRC_PNP_TENSERS_TRANSFORMATION          = "PRC_PNP_TENSERS_TRANSFORMATION";
//not a polymorph but ability bonuses instead


// Epic spell switches
const string PRC_EPIC_INGORE_DEFAULTS                = "PRC_EPIC_INGORE_DEFAULTS";
//if set, then the switches below will not be set to default values
//shoudl be used if any customisation is done
const string PRC_EPIC_XP_COSTS                       = "PRC_EPIC_XP_COSTS";
//do epic spells cost XP to cast
const string PRC_EPIC_TAKE_TEN_RULE                  = "PRC_EPIC_TAKE_TEN_RULE";
//do casters take 10 when researching
const string PRC_EPIC_PRIMARY_ABILITY_MODIFIER_RULE  = "PRC_EPIC_PRIMARY_ABILITY_MODIFIER_RULE";
//use casters primary ability (divine casters wis, arcane int/cha as appropriate)
const string PRC_EPIC_BACKLASH_DAMAGE                = "PRC_EPIC_BACKLASH_DAMAGE";
//do epic spells do backlash damage
const string PRC_EPIC_FOCI_ADJUST_DC                 = "PRC_EPIC_FOCI_ADJUST_DC";
//do school foci change the research and casting DC
const string PRC_EPIC_GOLD_MULTIPLIER                = "PRC_EPIC_GOLD_MULTIPLIER";
//DC multiplier for gold to research. 
//Usually 9000 by default and by PnP
const string PRC_EPIC_XP_FRACTION                    = "PRC_EPIC_XP_FRACTION";
//gold cost divisor for XP to research. 
//Usually 25 by default and by PnP
const string PRC_EPIC_FAILURE_FRACTION_GOLD          = "PRC_EPIC_FAILURE_FRACTION_GOLD";
//what proportion of research gold is lost in a failed attempt
//usually 2 (i.e half) by default
const string PRC_EPIC_BOOK_DESTRUCTION               = "PRC_EPIC_BOOK_DESTRUCTION";
//probablity out of 100 of seeds being destroyed when learnt.
const string PRC_PNP_UNIMPINGED                      = "PRC_PNP_UNIMPINGED";
const string PRC_PNP_IMPENETRABILITY                 = "PRC_PNP_IMPENETRABILITY";
const string PRC_PNP_DULLBLADES                      = "PRC_PNP_DULLBLADES";
//100%immunity and 20hduration instead of 50% and casterlevel+10 rounds
const string PRC_PNP_CHAMPIONS_VALOR                  = "PRC_PNP_CHAMPIONS_VALOR";
//20h instead of rounds per level

// General switches
const string PRC_STAFF_CASTER_LEVEL                  = "PRC_STAFF_CASTER_LEVEL";
//spells cast from magic staffs use the wielders casterlevel rather than the
//items if the wielders casterlevel is higher.
//This makes magic staffs more valuable to mages, especially at high levels
const string PRC_BREW_POTION_CASTER_LEVEL            = "PRC_BREW_POTION_CASTER_LEVEL";
const string PRC_SCRIBE_SCROLL_CASTER_LEVEL          = "PRC_SCRIBE_SCROLL_CASTER_LEVEL";
const string PRC_CRAFT_WAND_CASTER_LEVEL             = "PRC_CRAFT_WAND_CASTER_LEVEL";
//these three switchs modify bioware crafting so that the items produced have the
//casterlevel of the spellcast who created them. Normally under bioware, it is possible
//for a level 3 caster to produce level 9 items and for a level 40 caster to only produce
//level 5 items.
const string PRC_NPC_HAS_PC_SPELLCASTING             = "PRC_NPC_HAS_PC_SPELLCASTING";
//NPCs go through spellhooking as if they are PCs
const string PRC_ECL_USES_XP_NOT_HD                  = "PRC_ECL_USES_XP_NOT_HD";
//stops players banking loads of XP without leveling
const string PRC_DISABLE_DEMILICH                    = "PRC_DISABLE_DEMILICH";
//stops demilich, i.e. lich class has only 4 levels
const string PRC_SPELLSLAB                           = "PRC_SPELLSLAB";
//0 = (default) Can teleport to the Epic Spell Laboratory, merchant sells all epic spells and new wizard scrolls. 
//1 = Can teleport to the Epic Spell Laboratory, merchant sells only the epic spells available in HotU and new wizard scrolls. 
//2 = Can teleport to the Epic Spell Laboratory, but the merchant is unavailable. 
//3 = Cannot teleport to the Epic Spell Laboratory.
const string PRC_SPELLSLAB_NOSCROLLS                 = "PRC_SPELLSLAB_NOSCROLLS";
//disables the sale of scrolls in the epic spell laboratory
const string PRC_PNP_ABILITY_DAMAGE_EFFECTS          = "PRC_PNP_ABILITY_DAMAGE_EFFECTS";
// Makes reaching 0 in an ability score have the special effects it should have according to PnP. See inc_abil_damage.nss for more info
const string PRC_SUPPLY_BASED_REST                   = "PRC_SUPPLY_BASED_REST";
//turns on the included version of supply based rest by demitious
//see inc_sbr_readme for details
const string PRC_PNP_SPELL_SCHOOLS                   = "PRC_PNP_SPELL_SCHOOLS";
//wizards use PnP spellschools instead of biowares
//must be generalists, but no way to enforce that
const string PRC_COMPANION_IN_USE                    = "PRC_COMPANION_IN_USE";
//DO NOT SET THIS SWITCH, the companion does it automatically
//it is only here to be used by other scripts
const string PRC_CEP_COMPANION_IN_USE                = "PRC_CEP_COMPANION_IN_USE";
//DO NOT SET THIS SWITCH, the companion does it automatically
//it is only here to be used by other scripts

// Poison system switches
const string PRC_USE_TAGBASED_INDEX_FOR_POISON       = "USE_TAGBASED_INDEX_FOR_POISON";
const string PRC_USES_PER_ITEM_POISON_DIE            = "USES_PER_ITEM_POISON_DIE";
const string PRC_USES_PER_ITEM_POISON_COUNT          = "PRC_USES_PER_ITEM_POISON_COUNT";
const string PRC_ALLOW_ONLY_SHARP_WEAPONS            = "PRC_ALLOW_ONLY_SHARP_WEAPONS";
const string PRC_ALLOW_ALL_POISONS_ON_WEAPONS        = "PRC_ALLOW_ALL_POISONS_ON_WEAPONS";
const string PRC_USE_DEXBASED_WEAPON_POISONING_FAILURE_CHANCE = "PRC_USE_DEXBASED_WEAPON_POISONING_FAILURE_CHANCE";
const string PRC_USES_PER_WEAPON_POISON_DIE          = "PRC_USES_PER_WEAPON_POISON_DIE";
const string PRC_USES_PER_WEAPON_POISON_COUNT        = "PRC_USES_PER_WEAPON_POISON_COUNT";

// PRGT system switches
//these three are strings not switches
const string PRC_PRGT_XP_SCRIPT_TRIGGERED            = "PRC_PRGT_XP_SCRIPT_TRIGGERED";
const string PRC_PRGT_XP_SCRIPT_DISARMED             = "PRC_PRGT_XP_SCRIPT_DISARMED";
const string PRC_PRGT_XP_SCRIPT_RECOVERED            = "PRC_PRGT_XP_SCRIPT_RECOVERED";

const string PRC_PRGT_XP_AWARD_FOR_TRIGGERED         = "PRC_PRGT_XP_AWARD_FOR_TRIGGERED";
const string PRC_PRGT_XP_AWARD_FOR_RECOVERED         = "PRC_PRGT_XP_AWARD_FOR_RECOVERED";
const string PRC_PRGT_XP_AWARD_FOR_DISARMED          = "PRC_PRGT_XP_AWARD_FOR_DISARMED";

// Psionics switches
const string PRC_PSI_ASTRAL_CONSTRUCT_USE_2DA        = "ASTRAL_CONSTRUCT_USE_2DA";
const string PRC_PNP_RAPID_METABOLISM                = "PRC_PNP_RAPID_METABOLISM";
const string PRC_PSI_IMP_METAPSIONICS_USE_SUM        = "PRC_PSI_IMP_METAPSIONICS_USE_SUM";

// Combat System Switches 
const string PRC_PNP_ELEMENTAL_DAMAGE                = "PRC_PNP_ELEMENTAL_DAMAGE";
const string PRC_SPELL_SNEAK_DISABLE                 = "PRC_SPELL_SNEAK_DISABLE";

// Unarmed Damage
const string PRC_3_5e_FIST_DAMAGE                    = "PRC_3_5e_FIST_DAMAGE";
const string PRC_BRAWLER_SIZE                        = "PRC_BRAWLER_SIZE";

// XP system switches 
const string PRC_XP_USE_SIMPLE_LA                    = "PRC_XP_USE_SIMPLE_LA";
//this modifies the amount of XP a character recieves based on LA
//doesnt take racial hit dice into account
//should work with any prior XP system
//use this on pre-exisitng modules
const string PRC_XP_USE_PNP_XP                       = "PRC_XP_USE_PNP_XP";
//enables PRC XP system
//this may cause balance issues with pre-exisiting modules
//it is recomended that only builders use this and do extensive
//playtesting and tweaking for balance
//Uses the dmgxp.2da file which is a copy of the XP tables in the DMG and ELH
//these are based on 13.3333 enconters of CR = ECL to advance
//enconters of CR>ECL+8 or CR<ECL-8 dont give XP
//tables are setup so that parties levels will converge over time.
const string PRC_XP_SLIDER_x100                      = "PRC_XP_SLIDER_x100";
//this value is divided by 100 when applied so a value of 100 is equivalent to 1.0
//slider for PnP XP system, multiplier for final XP amount
const string PRC_XP_USE_ECL_NOT_CR                   = "PRC_XP_USE_ECL_NOT_CR";
//use ECL for NPCs instead of CR
//should be close, but I dont know how bioware CR calculations work with the PRC races
//Also note ECL is a measure of power in a campaign, wheras CR is measure of power in a 
//single encounter. Thus ECL weights use/day abilitieis more than CR does.
const string PRC_XP_INCLUDE_RACIAL_HIT_DIE_IN_LA     = "PRC_XP_INCLUDE_RACIAL_HIT_DIE_IN_LA";
//If this is on ECL = LA+racial hit dice EVEN IF THE CHARACTER DOESNT HAVE ANY RACIAL HIT DICE
//so it penalizes the power races far more than PnP because they dont get any of the other 
//benefits of racial hit dice (BAB, HP, saves, skills, feats, etc)
const string PRC_XP_PC_PARTY_COUNT_x100              = "PRC_XP_PC_PARTY_COUNT_x100";
const string PRC_XP_HENCHMAN_PARTY_COUNT_x100        = "PRC_XP_HENCHMAN_PARTY_COUNT_x100";
const string PRC_XP_DOMINATED_PARTY_COUNT_x100       = "PRC_XP_DOMINATED_PARTY_COUNT_x100";
const string PRC_XP_ANIMALCOMPANION_PARTY_COUNT_x100 = "PRC_XP_ANIMALCOMPANION_PARTY_COUNT_x100";
const string PRC_XP_FAMILIAR_PARTY_COUNT_x100        = "PRC_XP_FAMILIAR_PARTY_COUNT_x100";
const string PRC_XP_SUMMONED_PARTY_COUNT_x100        = "PRC_XP_SUMMONED_PARTY_COUNT_x100";
//these values are divided by 100 when applied so a value of 100 is equivalent to 1.0
//This is for purposes of party size for dividing XP awards by.
//By PnP only PCs would count, and possibly henchmen too, but you might want to tweak others 
//for balance purposes, for example to hinder a solo wizard with dozens of summons
const string PRC_XP_USE_SETXP                        = "PRC_XP_USE_SETXP";
//use SetXP rather than GiveXP. Will bypass any possible bioware interfereance.
const string PRC_XP_GIVE_XP_TO_NPCS                  = "PRC_XP_GIVE_XP_TO_NPCS";
//Give XP to NPCs via a local int variable on the NPC named "NPC_XP"
//this is used for epic spells that require XP and could also be 
//hooked into henchmen levelling systems
const string PRC_XP_MUST_BE_IN_AREA                  = "PRC_XP_MUST_BE_IN_AREA";
//PCs must be in the same area as the CR to gain XP
//Helps stop powerlevelling by detering low level characters hanging around with 1 very stron char
const string PRC_XP_MAX_PHYSICAL_DISTANCE            = "PRC_XP_MAX_PHYSICAL_DISTANCE";
//Maximum distance that a PC must be to gain XP. 
//Helps stop powerlevelling by detering low level characters hanging around with 1 very stron char
const string PRC_XP_MAX_LEVEL_DIFF                   = "PRC_XP_MAX_LEVEL_DIFF";
//maximum level difference in levels between killer and PC being awarded XP
//Helps stop powerlevelling by detering low level characters hanging around with 1 very stron char
const string PRC_XP_GIVE_XP_TO_NON_PC_FACTIONS       = "PRC_XP_GIVE_XP_TO_NON_PC_FACTIONS";
//Gives XP to NPCs when no PCs are in their faction
//this might cause lag if large numebrs of NPCs in the same faction.

//Database and Letoscript switches
const string PRC_USE_DATABASE                        = "PRC_USE_DATABASE";
//set this if you are using NWNX and any sort of database
const string PRC_DB_PRECACHE                         = "PRC_DB_PRECACHE";
//this will precache 2da files into the database
//the first time this runs it will lag a lot for a long time
//after than it will be much faster
const string PRC_DB_SQLLITE                          = "PRC_DB_SQLLITE";
//set this if you are using SQLite (the built-in database in NWNX-ODBC2)
//this will use transactions
const string PRC_DB_SQLLITE_INTERVAL                 = "PRC_DB_SQLLITE_INTERVAL";
//this is the interval of each transaction. By default it is 600 seconds.
//shorter will mean slower, but less data lost in the event of a server crash.
//longer is visa versa.
const string PRC_USE_LETOSCRIPT                      = "PRC_USE_LETOSCRIPT";
const string PRC_LETOSCRIPT_PHEONIX_SYNTAX           = "PRC_LETOSCRIPT_PHEONIX_SYNTAX";
const string PRC_LETOSCRIPT_FIX_ABILITIES            = "PRC_LETOSCRIPT_FIX_ABILITIES";
// letoscript needs a string named PRC_LETOSCRIPT_NWN_DIR set to the directory of NWN
// if it doesnt work, try different slash options // \\ / \
const string PRC_LETOSCRIPT_NWN_DIR                  = "PRC_LETOSCRIPT_NWN_DIR";

//ConvoCC switches
const string PRC_CONVOCC_ENABLE                      = "PRC_CONVOCC_ENABLE";
//this doesnt turn on the database and letoscript as well. 
//you should do that yourself
const string PRC_CONVOCC_AVARIEL_WINGS               = "PRC_CONVOCC_AVARIEL_WINGS";
//Avariel characters have bird wings
const string PRC_CONVOCC_FEYRI_WINGS                 = "PRC_CONVOCC_FEYRI_WINGS";
//Fey'ri characters have bat wings
const string PRC_CONVOCC_FEYRI_TAIL                  = "PRC_CONVOCC_FEYRI_TAIL";
//Fey'ri characters have a demonic tail
const string PRC_CONVOCC_DROW_ENFORCE_GENDER         = "PRC_CONVOCC_DROW_ENFORCE_GENDER";
//Force Drow characters to be of the correct gender for their race
const string PRC_CONVOCC_GENSAI_ENFORCE_DOMAINS      = "PRC_CONVOCC_GENSAI_ENFORCE_DOMAINS";
/*Force Gensai clerics to select the relevant elemental
domain as one of their feats*/
const string PRC_CONVOCC_ENFORCE_BLOOD_OF_THE_WARLORD= "PRC_CONVOCC_ENFORCE_BLOOD_OF_THE_WARLORD";
const string PRC_CONVOCC_ENFORCE_FEAT_NIMBUSLIGHT    = "PRC_CONVOCC_ENFORCE_FEAT_NIMBUSLIGHT";
const string PRC_CONVOCC_ENFORCE_FEAT_HOLYRADIANCE   = "PRC_CONVOCC_ENFORCE_FEAT_HOLYRADIANCE";
const string PRC_CONVOCC_ENFORCE_FEAT_SERVHEAVEN     = "PRC_CONVOCC_ENFORCE_FEAT_SERVHEAVEN";
const string PRC_CONVOCC_ENFORCE_FEAT_SAC_VOW        = "PRC_CONVOCC_ENFORCE_FEAT_SAC_VOW";
const string PRC_CONVOCC_ENFORCE_FEAT_VOW_OBED       = "PRC_CONVOCC_ENFORCE_FEAT_VOW_OBED";
const string PRC_CONVOCC_ENFORCE_FEAT_THRALL_TO_DEMON= "PRC_CONVOCC_ENFORCE_FEAT_THRALL_TO_DEMON";
const string PRC_CONVOCC_ENFORCE_FEAT_DISCIPLE_OF_DARKNESS="PRC_CONVOCC_ENFORCE_FEAT_DISCIPLE_OF_DARKNESS";
const string PRC_CONVOCC_ENFORCE_FEAT_LICHLOVED      = "PRC_CONVOCC_ENFORCE_FEAT_LICHLOVED";
const string PRC_CONVOCC_ENFORCE_FEAT_EVIL_BRANDS    = "PRC_CONVOCC_ENFORCE_FEAT_EVIL_BRANDS";
const string PRC_CONVOCC_ENFORCE_FEAT_VILE_WILL_DEFORM="PRC_CONVOCC_ENFORCE_FEAT_VILE_WILL_DEFORM";
const string PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_OBESE="PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_OBESE";
const string PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_GAUNT="PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_GAUNT";
//enforce feats seaparately
const string PRC_CONVOCC_ENFORCE_FEATS               = "PRC_CONVOCC_ENFORCE_FEATS";
//enforce all the feats together
const string PRC_CONVOCC_RAKSHASHA_FEMALE_APPEARANCE = "PRC_CONVOCC_RAKSHASHA_FEMALE_APPEARANCE";
//Female rakshasha use the female rakshasha model
const string PRC_CONVOCC_DRIDER_FEMALE_APPEARANCE    = "PRC_CONVOCC_DRIDER_FEMALE_APPEARANCE";
//Female drider use the female drider model
const string PRC_CONVOCC_DISALLOW_CUSTOMISE_WINGS    = "PRC_CONVOCC_DISALLOW_CUSTOMISE_WINGS";
//Stops players changing their wings
const string PRC_CONVOCC_DISALLOW_CUSTOMISE_TAIL     = "PRC_CONVOCC_DISALLOW_CUSTOMISE_TAIL";
//Stops players changing their tail
const string PRC_CONVOCC_DISALLOW_CUSTOMISE_MODEL    = "PRC_CONVOCC_DISALLOW_CUSTOMISE_MODEL";
//Stops players changing their model at all
const string PRC_CONVOCC_USE_RACIAL_APPEARANCES      = "PRC_CONVOCC_USE_RACIAL_APPEARANCES";
const string PRC_CONVOCC_USE_RACIAL_PORTRAIT         = "PRC_CONVOCC_USE_RACIAL_PORTRAIT";
const string PRC_CONVOCC_USE_RACIAL_SOUNDSET         = "PRC_CONVOCC_USE_RACIAL_SOUNDSET";
/*Players can only change their model / portrait / soundset
to alternatives of the same race. If you have extra
content (e.g. from CEP) you must add them to
SetupRacialAppearances or SetupRacialPortraits or
SetupRacialSoundsets in prc_ccc_inc_e in order for
them to be shown on the list.*/
const string PRC_CONVOCC_ONLY_PLAYER_VOICESETS       = "PRC_CONVOCC_ONLY_PLAYER_VOICESETS";
/*Players can only select from the player voicesets
NPC voicesets are not complete, so wont play sounds
for many things such as emotes.*/
const string PRC_CONVOCC_RESTRICT_VOICESETS_BY_SEX   = "PRC_CONVOCC_RESTRICT_VOICESETS_BY_SEX";
//Only allows players to select voiceset of the same gender*/
const string PRC_CONVOCC_FORCE_KEEP_VOICESET         = "PRC_CONVOCC_FORCE_KEEP_VOICESET";
/*Skips the select a voiceset step entirely, and players
have to keep their current voiceset*/
const string PRC_CONVOCC_ALLOW_TO_KEEP_VOICESET      = "PRC_CONVOCC_ALLOW_TO_KEEP_VOICESET";
const string PRC_CONVOCC_USE_RACIAL_VOICESET         = "PRC_CONVOCC_USE_RACIAL_VOICESET";
const string PRC_CONVOCC_ALLOW_TO_KEEP_PORTRAIT      = "PRC_CONVOCC_ALLOW_TO_KEEP_PORTRAIT";
/*Allow players to keep their exisiting portrait
The ConvoCC cannot allow players to select custom
portriats, so the only way for players to have them
is to select them in the bioware character creator
and then select to keep them in the ConvoCC.*/
const string PRC_CONVOCC_FORCE_KEEP_PORTRAIT         = "PRC_CONVOCC_FORCE_KEEP_PORTRAIT";
/*Skips the select a portrait step entirely, and players
have to keep their current portrait*/
const string PRC_CONVOCC_RESTRICT_PORTRAIT_BY_SEX    = "PRC_CONVOCC_RESTRICT_PORTRAIT_BY_SEX";
/*Only allow players to select portraits of the same gender.
Most of the NPC portraits do not have a gender so are also
removed.*/
const string PRC_CONVOCC_ENABLE_RACIAL_HITDICE       = "PRC_CONVOCC_ENABLE_RACIAL_HITDICE";
/*This option give players the ability to start with racial
hit dice for some of the more powerful races. These are
defined in ECL.2da For these races, players do not pick
a class in the ConvoCC but instead select 1 or more levels
in a racial class (such as monsterous humanoid, or outsider).
This is not a complete ECL system, it mearly gives players
the racial hit dice component. It does not make any measure
of the Level Adjustment component. For example, a pixie has
no racial hit dice, but has a +4 level adjustment.*/
const string PRC_CONVOCC_ALLOW_HIDDEN_SKIN_COLOURS   = "PRC_CONVOCC_ALLOW_HIDDEN_SKIN_COLOURS";
const string PRC_CONVOCC_ALLOW_HIDDEN_HAIR_COLOURS   = "PRC_CONVOCC_ALLOW_HIDDEN_HAIR_COLOURS";
const string PRC_CONVOCC_ALLOW_HIDDEN_TATTOO_COLOURS = "PRC_CONVOCC_ALLOW_HIDDEN_TATTOO_COLOURS";
/*These enable players to select the hidden skin, hair,
and tattoo colours (metalics, matt black, matt white).*/
const string PRC_CONVOCC_ALLOW_SKILL_POINT_ROLLOVER  = "PRC_CONVOCC_ALLOW_SKILL_POINT_ROLLOVER";
/*This option allows players to keep their skillpoints
from one level to the next, if they want to. */
const string PRC_CONVOCC_USE_XP_FOR_NEW_CHAR         = "PRC_CONVOCC_USE_XP_FOR_NEW_CHAR";
/*This will identify new characters based on X which is
the same as v1.3 but less secure. */
const string PRC_CONVOCC_ENCRYPTION_KEY              = "PRC_CONVOCC_ENCRYPTION_KEY";
/*This is the key used to encrypt characters names if
USE_XP_FOR_NEW_CHAR is false in order to identify
returning characters. It should be in the range 1-100.
If USE_XP_FOR_NEW_CHAR is true, then returning
characters will be encrypted too, so once everone has
logged on at least once, USE_XP_FOR_NEW_CHAR can be
set to false for greater security. */
const string PRC_CONVOCC_STAT_POINTS                 = "PRC_CONVOCC_STAT_POINTS";
//as requested, an option to alter the inital 30 points
//at character creation


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


void MultisummonPreSummon(object oPC = OBJECT_SELF, int bOverride = FALSE)
{
    if(!GetPRCSwitch(PRC_MUTLISUMMON) && !bOverride)
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
    if(GetPRCSwitch(PRC_EPIC_INGORE_DEFAULTS))
        return;
    SetPRCSwitch(PRC_EPIC_XP_COSTS, TRUE);        
    SetPRCSwitch(PRC_EPIC_BACKLASH_DAMAGE, TRUE);
    SetPRCSwitch(PRC_EPIC_FOCI_ADJUST_DC, TRUE);
    SetPRCSwitch(PRC_EPIC_GOLD_MULTIPLIER, 9000);
    SetPRCSwitch(PRC_EPIC_XP_FRACTION, 25);
    SetPRCSwitch(PRC_EPIC_FAILURE_FRACTION_GOLD, 2);
    SetPRCSwitch(PRC_EPIC_BOOK_DESTRUCTION, 50);
}