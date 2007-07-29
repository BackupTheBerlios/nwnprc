/**
 * @file
 * This file defines names of switches that can be used to modify
 * the behaviour of certain parts of the PRC pack.
 * It also contains functions for getting and setting the values of
 * these switches and in addition some functions dealing with the
 * implementation of certain switches.
 */

 /*

 Creating your personal switch settings
 For singleplayer, you can create a 2da file and place it in the overide
 Then via the PRC Options switch you can read that 2da and it will
 use it to set switches for you.
 This will not work in multiplayer.
 An example is below. Copy and paste it into a plain text file saved
 as personal_switch.2da

 If there is a file named personal_switchl.2da then it will be loaded
 at module load and the switches set accordingly.


2DA V2.0

    SwitchName                              SwitchType SwitchValue
0   FOO                                     float      3.14159
1   BAR                                     int        12321
2   BAZ                                     string     "Go For The Eyes Boo, Go For The Eyes!"
3   PRC_PNP_TRUESEEING                      int        1
4   PRC_TIMESTOP_LOCAL                      int        1
5   PRC_TIMESTOP_NO_HOSTILE                 int        1
6   PRC_TIMESTOP_BLANK_PC                   int        1
7   PRC_PNP_ELEMENTAL_SWARM                 int        1
8   PRC_PNP_TENSERS_TRANSFORMATION          int        1
9   PRC_PNP_BLACK_BLADE_OF_DISASTER         int        1
10  PRC_PNP_FIND_TRAPS                      int        1
11  PRC_PNP_DARKNESS                        int        1
12  PRC_PNP_DARKNESS_35ED                   int        1
13  PRC_PNP_ANIMATE_DEAD                    int        1
14  PRC_35ED_WORD_OF_FAITH                  int        1
15  PRC_CREATE_UNDEAD_UNCONTROLLED          int        1
16  PRC_CREATE_UNDEAD_PERMANENT             int        1
17  PRC_SLEEP_NO_HD_CAP                     int        1
18  PRC_USE_NEW_IMBUE_ARROW                 int        1
19  PRC_ORC_WARLORD_COHORT                  int        1
20  PRC_LICH_ALTER_SELF_DISABLE             int        1
21  PRC_TRUE_NECROMANCER_ALTERNATE_VISUAL   int        1
22  PRC_THRALLHERD_LEADERSHIP               int        1
23  PRC_PNP_UNIMPINGED                      int        1
24  PRC_PNP_IMPENETRABILITY                 int        1
25  PRC_PNP_DULLBLADES                      int        1
26  PRC_PNP_CHAMPIONS_VALOR                 int        1
27  PRC_STAFF_CASTER_LEVEL                  int        1
28  PRC_PNP_ABILITY_DAMAGE_EFFECTS          int        1
29  PRC_PNP_REST_HEALING                    int        1
30  PRC_PNP_SOMATIC_COMPOMENTS              int        1
31  PRC_PNP_SOMATIC_ITEMS                   int        1
32  PRC_MULTISUMMON                         int        1
33  PRC_SUMMON_ROUND_PER_LEVEL              int        1
34  PRC_PNP_FAMILIAR_FEEDING                int        1
35  PRC_PNP_HOLY_AVENGER_IPROP              int        1
36  PRC_PNP_SLINGS                          int        1
37  PRC_PNP_RACIAL_SPEED                    int        1
38  PRC_PNP_ARMOR_SPEED                     int        1
39  PRC_REMOVE_PLAYER_SPEED                 int        1
40  PRC_BREW_POTION_CASTER_LEVEL            int        1
41  PRC_SCRIBE_SCROLL_CASTER_LEVEL          int        1
42  PRC_CRAFT_WAND_CASTER_LEVEL             int        1
43  PRC_CRAFTING_BASE_ITEMS                 int        1
44  PRC_XP_USE_SIMPLE_LA                    int        1
45  PRC_XP_USE_SIMPLE_RACIAL_HD             int        1

 */

 /* This variable MUST be updated with every new version of the PRC!!! */

 const string PRC_VERSION                           = "PRC 3.1e Beta 2";


/******************************************************************************\
*                                  Spell switches                              *
\******************************************************************************/

/** Bioware True Seeing can see stealthed creatures.
 * This replaces the trueseeing effect with a See Invisible + Ultravision + Spot bonus.
 * This affects the spell and power True Seeing and the Dragon Disciple class
 */
const string PRC_PNP_TRUESEEING                      = "PRC_PNP_TRUESEEING";

/**
 * PRC_PNP_TRUESEEING must be on.
 * Value of spot skill bonus that True Seeing grants.
 * Defaults to +15 if not set.
 */
const string PRC_PNP_TRUESEEING_SPOT_BONUS           = "PRC_PNP_TRUESEEING_SPOT_BONUS";

/** Remove the cap PRC added to this spell */
const string PRC_BIOWARE_GRRESTORE                   = "PRC_BIOWARE_GRRESTORE";
/** Remove the cap PRC added to this spell */
const string PRC_BIOWARE_HEAL                        = "PRC_BIOWARE_HEAL";
/** Remove the cap PRC added to this spell */
const string PRC_BIOWARE_MASS_HEAL                   = "PRC_BIOWARE_MASS_HEAL";
/** Remove the cap PRC added to this spell */
const string PRC_BIOWARE_HARM                        = "PRC_BIOWARE_HARM";
/** Remove the cap PRC added to this spell */
const string PRC_BIOWARE_NEUTRALIZE_POISON           = "PRC_BIOWARE_NEUTRALIZE_POISON";
/** Remove the cap PRC added to this spell */
const string PRC_BIOWARE_REMOVE_DISEASE              = "PRC_BIOWARE_REMOVE_DISEASE";


/***
 * Timestop has Bioware durations (9 seconds or 18 for Greater Timestop) rather
 * than PnP durations (1d4+1 or 2d4+2)
 */
const string PRC_TIMESTOP_BIOWARE_DURATION           = "PRC_TIMESTOP_BIOWARE_DURATION";

/**
 * Timestop has only a local affect, i.e doesn't stop people on the other areas of the module.
 * Note that AOEs continue to act during a timestop, and durations/delayed events still occur.
 */
const string PRC_TIMESTOP_LOCAL                      = "PRC_TIMESTOP_LOCAL";

/**
 * PRC_TIMESTOP_LOCAL must be enabled.
 * Caster can't perform any hostile actions while in timestop.
 */
const string PRC_TIMESTOP_NO_HOSTILE                 = "PRC_TIMESTOP_NO_HOSTILE";

/**
 * PRC_TIMESTOP_LOCAL must be enabled.
 * PCs can't see anything while stopped.
 * This might look to the player like their game crashed.
 */
const string PRC_TIMESTOP_BLANK_PC                   = "PRC_TIMESTOP_BLANK_PC";

/**
 * Instead of Bioware's sequential summons it creates multiple elementals.
 * Only works if PRC_MULTISUMMON is on
 */
const string PRC_PNP_ELEMENTAL_SWARM                 = "PRC_PNP_ELEMENTAL_SWARM";

/**
 * If you pass a save, you can't be affected by that aura for 24h.
 * NOTE: Not implemented yet
 */
const string PRC_PNP_FEAR_AURAS                      = "PRC_PNP_FEAR_AURAS";

/**
 * Not a polymorph but ability bonuses instead.
 */
const string PRC_PNP_TENSERS_TRANSFORMATION          = "PRC_PNP_TENSERS_TRANSFORMATION";

/**
 * Less powerful, more PnP accurate version.
 * Caster must concentrate to maintain it.
 */
const string PRC_PNP_BLACK_BLADE_OF_DISASTER         = "PRC_PNP_BLACK_BLADE_OF_DISASTER";

/**
 * Traps are only shown, not disarmed
 */
const string PRC_PNP_FIND_TRAPS                      = "PRC_PNP_FIND_TRAPS";

/**
 * PnP Darkness
 * Is a mobile AOE based off an item
 */
const string PRC_PNP_DARKNESS                        = "PRC_PNP_DARKNESS";

/**
 * 3.5ed Darkness
 * Gives 20% concelement rather than bioware darkness
 */
const string PRC_PNP_DARKNESS_35ED                   = "PRC_PNP_DARKNESS_35ED";

/**
 * Undead summons are permanent, but can only have 4HD/casterlevel in total
 * Does not enforce the requirement for a corpse
 * Also applies to ghoul gauntlet which otherwise will create one ghoul
 * if you dont already have a summon
 */
const string PRC_PNP_ANIMATE_DEAD                    = "PRC_PNP_ANIMATE_DEAD";

/**
 * "Word of Faith" spells use 3.5 ed rules rather than 3.0ed
 * basically instead of 12+ / <12 / <8 / <4 its relative to caster level
 * at >=CL / <CL / <CL-5 / <CL-10
 * This basically makes it more powerful at higher levels
 */
const string PRC_35ED_WORD_OF_FAITH                  = "PRC_35ED_WORD_OF_FAITH";

/*
 * Undead created by Create Undead and Create Greater Undead are
 * not automatically under the casters control
 * If this is set, the undead are permanently created
 */
const string PRC_CREATE_UNDEAD_UNCONTROLLED          = "PRC_CREATE_UNDEAD_UNCONTROLLED";

/*
 * Undead created by Create Undead and Create Greater Undead are
 * not removed on resting etc
 */
const string PRC_CREATE_UNDEAD_PERMANENT             = "PRC_CREATE_UNDEAD_PERMANENT";

/*
 * Sleep and Deep Slumber dont have a limit on the
 * HD of a target to be effected.
 */
const string PRC_SLEEP_NO_HD_CAP                     = "PRC_SLEEP_NO_HD_CAP";

/**
 * By request, set this to use the 1.65 behaviour for implosion, phantasmal killer,
 * and weird, i.e. death immunity counts
 * This is in addition to the extra immunities 1.66 adds
 */
const string PRC_165_DEATH_IMMUNITY                  = "PRC_165_DEATH_IMMUNITY";

/*
 * This is for builders. It should not be set on the module, but should be set on players/creatures.
 * When this is set, it will override spell DC for all spells cast (including SLAs and items)
 * This will overrule all feats, racial bonuses, etc that would effect DC
*/
const string PRC_DC_TOTAL_OVERRIDE                   = "PRC_DC_TOTAL_OVERRIDE";

/*
 * This is for builders. It should not be set on the module, but should be set on players/creatures.
 * When this is set, it will override spell DC for all spells cast (including SLAs and items)
 * This will ony override base DC+spelllevel+statmod, feats race etc are added on top of this
 * If this is set to -1, DC is calculated including class & spell level
*/
const string PRC_DC_BASE_OVERRIDE                   = "PRC_DC_BASE_OVERRIDE";

/*
 * This is for builders. It should not be set on the module, but should be set on players/creatures.
 * When this is set, it will add to spell DC for all spells cast (including SLAs and items)
*/
const string PRC_DC_ADJUSTMENT                       = "PRC_DC_ADJUSTMENT";

/*
 * This is for builders. It should not be set on the module, but should be set on players/creatures.
 * When this is set, it will override spell casterlevel for all spells cast (including SLAs and items)
*/
const string PRC_CASTERLEVEL_OVERRIDE                = "PRC_CASTERLEVEL_OVERRIDE";

/*
 * This is for builders. It should not be set on the module, but should be set on players/creatures.
 * When this is set, it will add to spell casterlevel for all spells cast (including SLAs and items)
*/
const string PRC_CASTERLEVEL_ADJUSTMENT              = "PRC_CASTERLEVEL_ADJUSTMENT";

/*
 * Mostly internal, but builders may find a use for it
 * Used to override GetLastSpellCastClass();
*/
const string PRC_CASTERCLASS_OVERRIDE                = "PRC_CASTERCLASS_OVERRIDE";

/*
 * Mostly internal, but builders may find a use for it
 * Used to override PRCGetSpellTargetLocation();
 * To activate set a location and an int on the module
 * The int must be TRUE
*/
const string PRC_SPELL_TARGET_LOCATION_OVERRIDE      = "PRC_SPELL_TARGET_LOCATION_OVERRIDE";

/*
 * Mostly internal, but builders may find a use for it
 * Used to override PRCGetSpellTargetObject();
 * To activate set a object and an int on the module
 * The int must be TRUE
*/
const string PRC_SPELL_TARGET_OBJECT_OVERRIDE        = "PRC_SPELL_TARGET_OBJECT_OVERRIDE";

/**
 * Mostly internal
 * Used to override PRCGetSpellCastItem();
 */
const string PRC_SPELLCASTITEM_OVERRIDE              = "PRC_SPELLCASTITEM_OVERRIDE";

/*
 * This is for builders. It should not be set on the module, but should be set on players/creatures.
 * When this is set, it will add to spell metamagic. Not all spells may accept this.
 * Only use Empower, Extend, or Maximize.
 * Still, Silent, and Quicken wont work
*/
const string PRC_METAMAGIC_ADJUSTMENT                 = "PRC_METAMAGIC_ADJUSTMENT";

/*
 * Mostly internal, but builders may find a use for it
 * Used to override PRCGetMetaMagicFeat();
 * Only use Empower, Extend, or Maximize.
 * Still, Silent, and Quicken wont work
*/
const string PRC_METAMAGIC_OVERRIDE                   = "PRC_METAMAGIC_OVERRIDE";

/*
 * Override for SpellID for PRCGetSpellID()
 * Doesnt effect spellID from effects, or automatic 2da reads
 */
const string PRC_SPELLID_OVERRIDE                     = "PRC_SPELLID_OVERRIDE";

/*
 * This switch toggles whether items are destroyed by Claws of the Bebilith or
 * simply unequipped.
 */
 const string PRC_BEBILITH_CLAWS_DESTROY              = "PRC_BEBILITH_CLAWS_DESTROY";

/*
 * When on, unidentified items will automatically by identified when aquired
 * respecting normal lore skill rules.
 */
 const string PRC_AUTO_IDENTIFY_ON_ACQUIRE              = "PRC_AUTO_IDENTIFY_ON_ACQUIRE";

/*
 * When on, identified items will automatically by unidentified when aquired
 * provided the new owner is not a friend/neutral and not to/from a store
 */
 const string PRC_AUTO_UNIDENTIFY_ON_UNACQUIRE              = "PRC_AUTO_UNIDENTIFY_ON_UNACQUIRE";

/*
 * Extra damage switch for Apocalypse from the Sky
 * spell does 10d6 by default, 40d4 with this set
 */

const string PRC_AFTS_EXTRA_DAMAGE                         = "PRC_AFTS_EXTRA_DAMAGE";

/******************************************************************************\
*                                  Class switches                              *
\******************************************************************************/

/*
 * This turns on the new improved imbue arrow functionallity
 * so all the player has to do is cast the spell at an arrow in their inventory
 * If this is off, players get the default bioware imbue arrow as a bonus feat on their hides
*/
const string PRC_USE_NEW_IMBUE_ARROW                 = "PRC_USE_NEW_IMBUE_ARROW";

/*
 * If this is set, the Dragon Disciple size increases at level 15 and 25
 * will give ability increases matching the new size
 * In any case, DDs will benefit from increased natural damage
*/
const string PRC_DRAGON_DISCIPLE_SIZE_CHANGES        = "PRC_DRAGON_DISCIPLE_SIZE_CHANGES";

/*
 *   Start of samurai switches
 */

/*
 * This values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0
 */

/*
 *
 *
 *
 */
const string PRC_SAMURAI_                            = "PRC_SAMURAI_";

/*
 * This allows samurai to sacrifice stolen items
 */
const string PRC_SAMURAI_ALLOW_STOLEN_SACRIFICE      = "PRC_SAMURAI_ALLOW_STOLEN_SACRIFICE";

/*
 * This allows samurai to sacrifice unidentified items
 * They will get full value for them however
 */
const string PRC_SAMURAI_ALLOW_UNIDENTIFIED_SACRIFICE= "PRC_SAMURAI_ALLOW_UNIDENTIFIED_SACRIFICE";

/*
 * This scales the value of sacrificed items
 * This values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0
 */
const string PRC_SAMURAI_SACRIFICE_SCALAR_x100       = "PRC_SAMURAI_SACRIFICE_SCALAR_x100";

/*
 * This scales the maximum value a samurai can have
 * This values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0
 */
const string PRC_SAMURAI_VALUE_SCALAR_x100           = "PRC_SAMURAI_VALUE_SCALAR_x100";

/*
 * Stop and Itemproperty being addeable
 * This is just a prefix, they should be finished as
 * PRC_SAMURAI_BAN_[type]_[subtype]_[param1]_[value]
 * If an itemproperty is missing one of those, or you wish to ban all of a
 * particular type use * instead of a number.
 * Examples:
 * Not allowing divine damage :                         PRC_SAMURAI_BAN_16_8_*_*
 * Not allowing divine damage vs undead:                PRC_SAMURAI_BAN_18_24_8_*
 * Not allowing +20 encancement weapons                 PRC_SAMURAI_BAN_6_*_*_20
 * see also DoSamuraiBanDefaults at the end of this file for more examples
 *
 */
const string PRC_SAMURAI_BAN_                            = "PRC_SAMURAI_BAN_";

/*
 *  Normally, some bans on itemproperties are setup automatically.
 *  If this switch is set, then nothing is banned automatically
 *  thus giving admins full controll.
 */
const string PRC_SAMURAI_DISABLE_DEFAULT_BAN             = "PRC_SAMURAI_DISABLE_DEFAULT_BAN";

/*
 * Orc Warlord gets a single additional cohort that must be an orc of some sort instead
 * of multiple summons
 */
const string PRC_ORC_WARLORD_COHORT                  = "PRC_ORC_WARLORD_COHORT";

/*
 * Disables the Lichs Alter Self ability
 * This was original a fudge for the HotU fairy/wolf/elemental quest
 */
const string PRC_LICH_ALTER_SELF_DISABLE             = "PRC_LICH_ALTER_SELF_DISABLE";

/*
 * Reduces the True Necromancers aura visual effects
 * It continues to function the same though
 */
const string PRC_TRUE_NECROMANCER_ALTERNATE_VISUAL             = "PRC_TRUE_NECROMANCER_ALTERNATE_VISUAL";

/*
 * Thrallherd uses leadership system rather than its own summons
 * They still cannot use Leadership, Epic Leadership or Legendary Commander feats
 */
const string PRC_THRALLHERD_LEADERSHIP             = "PRC_THRALLHERD_LEADERSHIP";

/*
 * Prevents Spellfire wielders from absorbing their own
 * spells/powers
 */
const string PRC_SPELLFIRE_DISALLOW_CHARGE_SELF     = "PRC_SPELLFIRE_DISALLOW_CHARGE_SELF";

/*
 * Prevents Spellfire channelers from absorbing from
 * scrolls/potions
 */
const string PRC_SPELLFIRE_DISALLOW_DRAIN_SCROLL_POTION = "PRC_SPELLFIRE_DISALLOW_DRAIN_SCROLL_POTION";

/*
 * Disables the PRCs sorcerer newspelbook extension
 */
const string PRC_SORC_DISALLOW_NEWSPELLBOOK     = "PRC_SORC_DISALLOW_NEWSPELLBOOK";

/*
 * Disables the PRCs bards newspelbook extension
 */
const string PRC_BARD_DISALLOW_NEWSPELLBOOK     = "PRC_BARD_DISALLOW_NEWSPELLBOOK";

/**
 * By default, CW Samurai get a plain katana and a plain wakizashi (shortsword) at 1st level.
 * Setting this to non-zero value prevents that.
 */
const string PRC_CWSAMURAI_NO_HEIRLOOM_DAISHO = "PRC_CWSAMURAI_NO_HEIRLOOM_DAISHO";

/**
 * Determines the number of wight henchmen a Soul Eater can have via their Soul Slave
 * class ability.
 * Default: 4
 * Special: Due to it not being possible to differentiate between a set 0 and an unset 0,
 *          to prevent any wight henchmen, set the switch to -1. (0 counts as the default)
 */
const string PRC_SOUL_EATER_MAX_SLAVES       = "PRC_SOUL_EATER_MAX_SLAVES";


/******************************************************************************\
  *                               Template switches                            *
\******************************************************************************/

/**
 * Disable players selecting templates via PRC Options convo
 */
const string PRC_DISABLE_CONVO_TEMPLATE_GAIN = "PRC_DISABLE_CONVO_TEMPLATE_GAIN";



/******************************************************************************\
*                               Epic Spell switches                            *
\******************************************************************************/

/**
 * If set, then the switches below will not be set to default values.
 * Should be used if any customisation is done.
 */
const string PRC_EPIC_INGORE_DEFAULTS                = "PRC_EPIC_INGORE_DEFAULTS";

/**
 * Do epic spells cost XP to cast?
 * Defaults to: TRUE
 */
const string PRC_EPIC_XP_COSTS                       = "PRC_EPIC_XP_COSTS";

/**
 * Do casters take 10 when researching?
 * Defaults to: FALSE
 */
const string PRC_EPIC_TAKE_TEN_RULE                  = "PRC_EPIC_TAKE_TEN_RULE";

/**
 * Use caster's primary ability (divine casters Wis, arcane Int/Cha as appropriate)
 * Defaults to: FALSE
 */
const string PRC_EPIC_PRIMARY_ABILITY_MODIFIER_RULE  = "PRC_EPIC_PRIMARY_ABILITY_MODIFIER_RULE";

/**
 * Do epic spells do backlash damage if specified in the spell?
 * Defaults to: TRUE
 */
const string PRC_EPIC_BACKLASH_DAMAGE                = "PRC_EPIC_BACKLASH_DAMAGE";

/**
 * Do school foci change the research and casting DC?
 * Defaults to: TRUE
 */
const string PRC_EPIC_FOCI_ADJUST_DC                 = "PRC_EPIC_FOCI_ADJUST_DC";

/**
 * DC multiplier for gold to research.
 * Defaults to: 9000 as per PnP
 */
const string PRC_EPIC_GOLD_MULTIPLIER                = "PRC_EPIC_GOLD_MULTIPLIER";

/**
 * Amount the researched spell's gold cost is divided by to get it's XP cost.
 * Defaults to: 25
 */
const string PRC_EPIC_XP_FRACTION                    = "PRC_EPIC_XP_FRACTION";

/**
 * Proportion of research gold is lost in a failed attempt. The full cost is
 * divided by this value to get the amount lost.
 * Defaults to: 2 (i.e half)
 */
const string PRC_EPIC_FAILURE_FRACTION_GOLD          = "PRC_EPIC_FAILURE_FRACTION_GOLD";

/**
 * Probablity out of 100 of seeds being destroyed when learnt.
 * Defaults to: 50
 */
const string PRC_EPIC_BOOK_DESTRUCTION               = "PRC_EPIC_BOOK_DESTRUCTION";

/** 100% immunity and 20h duration instead of 50% and casterlevel+10 rounds. */
const string PRC_PNP_UNIMPINGED                      = "PRC_PNP_UNIMPINGED";

/** 100% immunity and 20h duration instead of 50% and casterlevel+10 rounds. */
const string PRC_PNP_IMPENETRABILITY                 = "PRC_PNP_IMPENETRABILITY";

/** 100% immunity and 20h duration instead of 50% and casterlevel+10 rounds. */
const string PRC_PNP_DULLBLADES                      = "PRC_PNP_DULLBLADES";

/** 20h instead of rounds per level */
const string PRC_PNP_CHAMPIONS_VALOR                  = "PRC_PNP_CHAMPIONS_VALOR";

/*
 * Disable learning epic spells via the PRC OPtions Convo
 * Does not need PRC_EPIC_INGORE_DEFAULTS to be set
 */
const string PRC_EPIC_CONVO_LEARNING_DISABLE         = "PRC_EPIC_CONVO_LEARNING_DISABLE";




/******************************************************************************\
*                                General switches                              *
\******************************************************************************/


/** DO NOT SET THIS SWITCH
 * If the PRC  is in use, this will be set automatically
 * It is only here to be used by other scripts
 * Bit surplus to requirements, since this very script is part of the PRC,
 * but fo completeness sake
 */
const string MARKER_PRC                              = "Marker_PRC";

/** DO NOT SET THIS SWITCH
 * The companion sets it automatically.
 * It is only here to be used by other scripts.
 */
const string MARKER_PRC_COMPANION                    = "Marker_PRCCompanion";

/** DO NOT SET THIS SWITCH
 * If CEP 1.68 and the PRC companion/merge is in use, this will be set automatically
 * It is only here to be used by other scripts
 */
const string MARKER_CEP1                             = "Marker_CEP1";

/** DO NOT SET THIS SWITCH
 * If CEP 2 and the PRC companion/merge is in use, this will be set automatically
 * It is only here to be used by other scripts
 */
const string MARKER_CEP2                             = "Marker_CEP2";

/**
 * Spells cast from magic staffs use the wielder's casterlevel rather than the
 * item's if the wielder's casterlevel is higher.
 * This makes magic staffs more valuable to mages, especially at high levels.
 */
const string PRC_STAFF_CASTER_LEVEL                  = "PRC_STAFF_CASTER_LEVEL";

/**
 * NPCs go through spellhooking as if they are PCs.
 */
const string PRC_NPC_HAS_PC_SPELLCASTING             = "PRC_NPC_HAS_PC_SPELLCASTING";

/**
 * Stops players banking loads of XP without leveling by using the level they
 * would have with their current XP instead of whatever their level is.
 */
const string PRC_ECL_USES_XP_NOT_HD                  = "PRC_ECL_USES_XP_NOT_HD";

/**
 * Stops demilich, i.e. Lich class has only 4 levels
 */
const string PRC_DISABLE_DEMILICH                    = "PRC_DISABLE_DEMILICH";

/**
 * Defines the possible uses of the Epic Spell Laboratory. Values as follows:
 *
 * 0 = (default) Can teleport to the Epic Spell Laboratory, merchant sells all
 *     epic spells and new wizard scrolls.
 * 1 = Can teleport to the Epic Spell Laboratory, merchant sells only the epic
 *     spells available in HotU and new wizard scrolls.
 * 2 = Can teleport to the Epic Spell Laboratory, but the merchant is unavailable.
 * 3 = Cannot teleport to the Epic Spell Laboratory.
 */
const string PRC_SPELLSLAB                           = "PRC_SPELLSLAB";

/**
 * Disables the sale of scrolls from the epic spell laboratory.
 */
const string PRC_SPELLSLAB_NOSCROLLS                 = "PRC_SPELLSLAB_NOSCROLLS";

/**
 * Disables the sale of crafting recipes from the epic spell laboratory.
 */
const string PRC_SPELLSLAB_NORECIPES                 = "PRC_SPELLSLAB_NORECIPES";

/**
 * Makes reaching 0 in an ability score have the special effects it should have
 * according to PnP.
 *
 * @see inc_abil_damage.nss
 */
const string PRC_PNP_ABILITY_DAMAGE_EFFECTS          = "PRC_PNP_ABILITY_DAMAGE_EFFECTS";

/**
 * Turns on the included version of supply based rest by demitious
 * See inc_sbr_readme.nss for details
 */
const string PRC_SUPPLY_BASED_REST                   = "PRC_SUPPLY_BASED_REST";

/**
 * Charaters only gain a number of hitpoints equal to their level from resting.
 */
const string PRC_PNP_REST_HEALING                    = "PRC_PNP_REST_HEALING";

/**
 * Resting causes game time to advance.
 * See inc_time.nss for details
 */
const string PRC_PNP_REST_TIME                       = "PRC_PNP_REST_TIME";

/**
 * Wizards use PnP spellschools instead of Bioware's
 * They must be generalists, but there is no way to enforce that
 * If letoscript is enabled, then all wizards will be set to PnP Spellschool as their school
 * plus the ConvoCC will set it if this switch is on
 */
const string PRC_PNP_SPELL_SCHOOLS                   = "PRC_PNP_SPELL_SCHOOLS";

/**
 * Players have a variable tracking how far ahead of the module clock they are
 * and when all players are ahead, the module clock advances to catch up.
 * This includes 8 hours when resting and time spent crafting
 *
 * See inc_time for implementation
 *
 */
const string PRC_PLAYER_TIME                         = "PRC_PLAYER_TIME";

/**
 * You must have at least 1 hand free to cast spells with somatic components.
 * This means at most a small shield in the off hand and
 * no dual weilded weapons, though ranged and doublehanded are OK.
 */
const string PRC_PNP_SOMATIC_COMPOMENTS              = "PRC_PNP_SOMATIC_COMPOMENTS";

/**
 * You must have at least 1 hand free to use items that you do not have equipped.
 * This means at most a small shield in the off hand and
 * no dual weilded weapons, though ranged and doublehanded are OK.
 */
const string PRC_PNP_SOMATIC_ITEMS                   = "PRC_PNP_SOMATIC_ITEMS";

/**
 * Second or subsequent summons dont destroy the first.
 * Can cause lag with high numbers of summons and/or tight spaces
 */
const string PRC_MULTISUMMON                         = "PRC_MULTISUMMON";

/**
 * Summons last for a number of rounds equal to caster level, rather than 24h or other timings
 */
const string PRC_SUMMON_ROUND_PER_LEVEL              = "PRC_SUMMON_ROUND_PER_LEVEL";

/**
 * Familiars follow PnP rules rather than Bioware's.
 * This makes them a lot weaker and less suited for combat.
 * Includes bonded summoner familiars.
 */
const string PRC_PNP_FAMILIARS                       = "PRC_PNP_FAMILIARS";

/**
 * This disables the ability to heal Bioware familiars by feading them
 * through the conversation
 */
const string PRC_PNP_FAMILIAR_FEEDING                = "PRC_PNP_FAMILIAR_FEEDING";

/**
 * This disables the ability to reroll HP at levelup
 * It requires letoscript to work.
 */
const string PRC_NO_HP_REROLL                        = "PRC_NO_HP_REROLL";

/**
 * This disables the 2 free spells wizards get at levelup
 * The GUI still shows, but it does nothing or rather its effects are undone afterwards
 * It requires letoscript to work.
 * not implemented yet
 */
const string PRC_NO_FREE_WIZ_SPELLS                        = "PRC_NO_FREE_WIZ_SPELLS";

/**
 * Sets the behaviour of the PRC Power Attack. Set this to either
 * PRC_POWER_ATTACK_DISABLED or PRC_POWER_ATTACK_FULL_PNP if you give
 * it a value.
 *
 * Default: One cannot use a higher power attack setting than one could using
 *          Bioware Power Attack. ie, if one possessed PA, but not IPA, one
 *          can only use PA up to 5. And up to 10 with IPA.
 *
 * @see PRC_POWER_ATTACK_DISABLED
 * @see PRC_POWER_ATTACK_FULL_PNP
 */
const string PRC_POWER_ATTACK                        = "PRC_POWER_ATTACK";

/**
 * A possible value of PRC_POWER_ATTACK.
 * If this is used, PRC Power Attack is completely disabled. The feats will
 * not be granted to players and even if they somehow gain access to the feats,
 * they will have no effect.
 *
 * @see PRC_POWER_ATTACK
 */
const int PRC_POWER_ATTACK_DISABLED = -1;

/**
 * A possible value of PRC_POWER_ATTACK.
 * If this is used, PRC Power Attack behaves as the Pen and Paper version.
 * This means ability to sacrifice any amount of attack bonus, up to one's
 * BAB. The existence of Bioware IPA is ignored as a limiting factor, only
 * normal Power Attack is required.
 *
 * @see PRC_POWER_ATTACK
 */
const int PRC_POWER_ATTACK_FULL_PNP = 1;

/**
 * Sets the behaviour of the PRC Power Attack.
 * If this is set, the Bioware Power Attack modes are included in the
 * calculation against the characters BAB limit.
 * Default: PRC Power Attack ignores whether BW Power Attack is active or not,
 *          which may result in the character paying a total amount of AB
 *          greater than their BAB.
 */
const string PRC_POWER_ATTACK_STACK_WITH_BW          = "PRC_POWER_ATTACK_STACK_WITH_BW";


/*
 * Disabling specific feat and/or skills
 * Each of these has 2 parts. One part is a variable defining the size of the list
 * The other part is the list itself. The numbers are the row numbers in feat.2da or skills.2da
 * or spells.2da.
 * For example, if you want to disable Knockdown and Improved Knockdown you would set
 * the variables as follows:
 * PRC_DISABLE_FEAT_COUNT = 2
 * PRC_DISABLE_FEAT_1     = 23
 * PRC_DISABLE_FEAT_2     = 17
 */
const string PRC_DISABLE_FEAT_COUNT                  = "PRC_DISABLE_FEAT_COUNT";
const string PRC_DISABLE_FEAT_                       = "PRC_DISABLE_FEAT_";
const string PRC_DISABLE_SKILL_COUNT                 = "PRC_DISABLE_SKILL_COUNT";
const string PRC_DISABLE_SKILL_                      = "PRC_DISABLE_SKILL_";
const string PRC_DISABLE_SPELL_COUNT                 = "PRC_DISABLE_SPELL_COUNT";
const string PRC_DISABLE_SPELL_                      = "PRC_DISABLE_SPELL_";

/*
 * Setting this will stop the GUI automatically appearing when a player is petrified on
 * hardcore
 * You can use a script named "prc_pw_petrific" which will always be run at petrification
 * (regardless of this switch) on hardcore to pop up the GUI as you want it, rather than
 * being forced to use biowares
*/
const string PRC_NO_PETRIFY_GUI                      = "PRC_NO_PETRIFY_GUI";


/*
 * Set this to remove the switch changing convo feat.
 * This should be set for PWs to avoid players screwing around with switches
 * A value of zero allows anyone to change switches
 * A value of 1 allows only DMs to change switches
 * Any other value prohibits everyone from changing switches
 */

const string PRC_DISABLE_SWITCH_CHANGING_CONVO       = "PRC_DISABLE_SWITCH_CHANGING_CONVO";

/*
 * Set this to remove checks to enforce domains
 * e.g. Fire Gensai dont have to take the Fire domain, etc
 */

const string PRC_DISABLE_DOMAIN_ENFORCEMENT          = "PRC_DISABLE_DOMAIN_ENFORCEMENT";

/*
 * Set this to remove replace bioware HolyAvenger itemproperties
 * with PnP HolyAvenger itemprperties instead
 * (for paladins, +5 +2d6 divine vs evil, castspel:dispel magic @ casterlevel = paladinlevels)
 * (for non paladins, +2)
 */

const string PRC_PNP_HOLY_AVENGER_IPROP              = "PRC_PNP_HOLY_AVENGER_IPROP";

/* Set this to enable the permanent death and XP cost functionality
 * of Necrotic Termination spell.
 */

 const string PRC_NEC_TERM_PERMADEATH                = "PRC_NEC_TERM_PERMADEATH" ;

 /*
  * Set this to enable alignment changes for the casting of spells with the Evil/Good descriptor
  */
 const string PRC_SPELL_ALIGNMENT_SHIFT              = "PRC_SPELL_ALIGNMENT_SHIFT";


 /*
  * Set this to give a number of Free cohorts as with leadership
  * This can be used to simulate a party of players
  * Unlike normal cohorts, those granted through this switch
  * do not have the -2 level lag.
  */
 const string PRC_BONUS_COHORTS                      = "PRC_BONUS_COHORTS";

 /*
  * Disable the use of custom cohorts
  */
 const string PRC_DISABLE_CUSTOM_COHORTS                      = "PRC_DISABLE_CUSTOM_COHORTS";

 /*
  * Disable the use of standard cohorts
  */
 const string PRC_DISABLE_STANDARD_COHORTS                      = "PRC_DISABLE_STANDARD_COHORTS";

 /*
  * Disable registration of custom cohorts
  */
 const string PRC_DISABLE_REGISTER_COHORTS                      = "PRC_DISABLE_REGISTER_COHORTS";

 /*
  * Gives all slings equiped Mighty +20 for free
  * Simulates PnP rules where you can add strength to damage
  */
 const string PRC_PNP_SLINGS                      = "PRC_PNP_SLINGS";

 /*
  * This is a local variable set on NPCs that is converted to real XP
  * in the OnSpawn event. Used for epic spells and other XP-burning stuff
  */
 const string PRC_NPC_XP                             = "PRC_NPC_XP";

 /*
  * Applys speed increase/decrease effects
  * Simulates PnP rules where different races have different speeds
  */
 const string PRC_PNP_RACIAL_SPEED                      = "PRC_PNP_RACIAL_SPEED";

 /*
  * Applys speed increase/decrease effects
  * Simulates PnP rules where different armors have different speeds
  * Medium armor is a 25% speed reduction, Heavy is a 33% reduction
  */
 const string PRC_PNP_ARMOR_SPEED                      = "PRC_PNP_ARMOR_SPEED";

 /*
  * by Bioware rules, PCs have approximatly a 7th faster movement than NPCs
  * so they can outrun them quite easily.
  * This switch removes that so they are on even footings.
  */
 const string PRC_REMOVE_PLAYER_SPEED                      = "PRC_REMOVE_PLAYER_SPEED";

 /*
  * Enforces racial appearance as defined in racialtypes.2da
  */
 const string PRC_ENFORCE_RACIAL_APPEARANCE                = "PRC_ENFORCE_RACIAL_APPEARANCE";

 /*
  * by default, on aquire script for races only runs for NPCs if they have a PC as a master
  * This runs it for all NPCs, note this will take significantly more CPU time.
  */
 const string PRC_NPC_FORCE_RACE_ACQUIRE                      = "PRC_NPC_FORCE_RACE_ACQUIRE";

 /*
  * by default, if you acquire a pre-1.68 cloak it will be randomly recolored so that it
  * doenst look beiger than beige. This disables that if you realy want beige cloaks for some reason.
  */
 const string PRC_DYNAMIC_CLOAK_AUTOCOLOUR_DISABLE                      = "PRC_DYNAMIC_CLOAK_AUTOCOLOUR_DISABLE";

 /*
  * disable all the appearance-changing options on the PRC OPtions convo
  */
 const string PRC_APPEARNCE_CHANGE_DISABLE                      = "PRC_APPEARNCE_CHANGE_DISABLE";




/******************************************************************************\
*                               Death system                                   *
\******************************************************************************/
 /*
  * Turns on the PRC PnP Bleeding & Death system
  * see prc_inc_death for details
  * NOTE: This will only work if the module has no other scripts for
  * OnPlayerDying and OnPlayerDeath events. Otherwise those will interfere with
  * this system
  */
const string PRC_PNP_DEATH_ENABLE                           = "PRC_PNP_DEATH_ENABLE";

 /*
  *  if zero, dont bleed just die
  *  By PnP this would be 1 round, or 6 seconds
  */
const string PRC_DEATH_TIME_BETWEEN_BLEEDING       = "PRC_DEATH_TIME_BETWEEN_BLEEDING";

 /*
  *  if zero, dont stabilise
  *  By PnP this would be 1 hour, or 2 minutes/120
  *  seconds by default NWN settings
  */
const string PRC_DEATH_TIME_BETWEEN_STABLE         = "PRC_DEATH_TIME_BETWEEN_STABLE";

 /*
  *  if zero, dont disabled
  *  By PnP this would be 1 day, or 48 minutes/2880
  *  seconds by default NWN settings
  */
const string PRC_DEATH_TIME_BETWEEN_DISABLED       = "PRC_DEATH_TIME_BETWEEN_DISABLED";

 /*
  *  this is the checks once dead for raising
  */
const string PRC_DEATH_TIME_BETWEEN_DEATH          = "PRC_DEATH_TIME_BETWEEN_DEATH";

/*
 * Damage when bleeding
 * By PnP, this would be 1
 */
const string PRC_DEATH_DAMAGE_FROM_BLEEDING        = "PRC_DEATH_DAMAGE_FROM_BLEEDING";

/*
 * Damage when stable
 * By PnP, this would be 1
 */
const string PRC_DEATH_DAMAGE_FROM_STABLE          = "PRC_DEATH_DAMAGE_FROM_STABLE";

/*
 * Healing when bleeding
 * By PnP, this would be 0
 */
const string PRC_DEATH_HEAL_FROM_STABLE            = "PRC_DEATH_HEAL_FROM_STABLE";

/*
 * % chance to improve when bleeding
 * By PnP, this would be 10
 */
const string PRC_DEATH_BLEED_TO_STABLE_CHANCE      = "PRC_DEATH_BLEED_TO_STABLE_CHANCE";

/*
 * % chance to resume bleeding when stable
 * By PnP, this would be 0
 */
const string PRC_DEATH_STABLE_TO_BLEED_CHANCE      = "PRC_DEATH_STABLE_TO_BLEED_CHANCE";

/*
 * % chance to improve when stable
 * By PnP, this would be 10
 */
const string PRC_DEATH_STABLE_TO_DISABLED_CHANCE   = "PRC_DEATH_STABLE_TO_DISABLED_CHANCE";


/******************************************************************************\
*                               ACP switches                              *
\******************************************************************************/
/*
 * This is a set of settings for Ragnaroks Alternate Combat animations Pack (ACP)
 * Main hak:
 * http://nwvault.ign.com/View.php?view=hakpaks.Detail&id=5895
 * CEP heads:
 * http://nwvault.ign.com/View.php?view=hakpaks.Detail&id=5934
 * CEP robes:
 * http://nwvault.ign.com/View.php?view=hakpaks.Detail&id=5950
 * (credit to USAgreco66kg for those CEP files)
 *
 * Note on haks: You should NOT add the acp_2da hak if you have the PRC installed
 * Plus, once you press the OK button to add the ACP haks, make sure
 * you press cancel as soon as it appears. Otherwise, the toolset will crash
 * as it tries to compile the PRC scripts.
 *
 * If you are using CEP2, then you only need ragnaroks main package. Compatible robes
 * and heads are included within CEP2.
 *
 * As of NWN v1.67 there is no need to press the cancel button as the toolset no longer
 * attempts to compile scripts in haks.
 *
 */

/*
 * Set this to give players radial feats to change combat animations
 */
const string PRC_ACP_MANUAL                          = "PRC_ACP_MANUAL";

/*
 * Set this so that players will change combat animations automatically
 * based on weapons equiped and class
 */
const string PRC_ACP_AUTOMATIC                       = "PRC_ACP_AUTOMATIC";

/*
 * Set this so that NPCs will change combat animations automatically
 * based on weapons equiped and class
 * This can either be set on the module for a global setting
 * or set on individual NPCs for specific individuals
 */
const string PRC_ACP_NPC_AUTOMATIC                   = "PRC_ACP_NPC_AUTOMATIC";

/*
 * Set this for a number of minutes delay betwen changing animations
 * This is useful to stop people spamming the server with changes
 * If not set, it defaults to 90 seconds. To set to zero, set var to -1
 */
const string PRC_ACP_DELAY                           = "PRC_ACP_DELAY";


/******************************************************************************\
*                               File End switches                              *
\******************************************************************************/

/**
 * If this is set it will disable the defaults and the module builder must set
 * the values manually.
 * Otherwise it will set the automatically, and will take the PRC companion
 * into account, including CEP if its the CEP/PRC companion.
 */
const string FILE_END_MANUAL                         = "FILE_END_MANUAL";

/** Last line of classes.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_CLASSES                        = "FILE_END_CLASSES";

/** Last line of racialtypes.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_RACIALTYPES                    = "FILE_END_RACIALTYPES";

/** Last line of gender.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_GENDER                         = "FILE_END_GENDER";

/** Last line of portraits.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_PORTRAITS                      = "FILE_END_PORTRAITS";

/** Last line of skills.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_SKILLS                         = "FILE_END_SKILLS";

/** Defines the line after which none of the cls_feat_*.2da have entries.
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_CLASS_FEAT                     = "FILE_END_CLASS_FEAT";

/** Defines the line after which none of the cls_skill_*.2da have entries.
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_CLASS_SKILLS                   = "FILE_END_CLASS_SKILLS";

/** Defines the line after which none of the cls_psipw_*.2da have entries.
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_CLASS_POWER                    = "FILE_END_CLASS_POWER";

/** Defines the line after which none of the cls_spbk_*.2da have entries.
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
 const string FILE_END_CLASS_SPELLBOOK               = "FILE_END_CLASS_SPELLBOOK";

/** Last line of feat.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_FEAT                           = "FILE_END_FEAT";

/** Defines the line after which none of the cls_pres_*.2da have entries.
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_CLASS_PREREQ                   = "FILE_END_CLASS_PREREQ";

/** Last line of hen_familiar.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_FAMILIAR                       = "FILE_END_FAMILIAR";

/** Last line of hen_companion.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_ANIMALCOMP                     = "FILE_END_ANIMALCOMP";

/** Last line of domains.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_DOMAINS                        = "FILE_END_DOMAINS";

/** Last line of soundset.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_SOUNDSET                       = "FILE_END_SOUNDSET";

/** Last line of spells.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_SPELLS                         = "FILE_END_SPELLS";

/** Last line of spellschools.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_SPELLSCHOOL                    = "FILE_END_SPELLSCHOOL";

/** Last line of appearance.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_APPEARANCE                     = "FILE_END_APPEARANCE";

/** Last line of wingmodel.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_WINGS                          = "FILE_END_WINGS";

/** Last line of tailmodel.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_TAILS                          = "FILE_END_TAILS";

/** Last line of packages.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_PACKAGE                        = "FILE_END_PACKAGE";

/** Defines the line after which none of the race_feat_*.2da have entries.
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_RACE_FEAT                      = "FILE_END_RACE_FEAT";

/** Defines the line after which none of the race_feat_*.2da have entries.
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_IREQ                           = "FILE_END_IREQ";

/** Defines the line after which none of the race_feat_*.2da have entries.
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_ITEM_TO_IREQ                   = "FILE_END_ITEM_TO_IREQ";

/** Last line of baseitems.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_BASEITEMS                          = "FILE_END_BASEITEMS";



/******************************************************************************\
*                            Poison system switches                            *
\******************************************************************************/

/**
 * If this is set, uses the last three characters from the item's tag
 * instead of the local variable 'pois_idx' to define the poison the item
 * represents. The value is used as an index to poison.2da.
 */
const string PRC_USE_TAGBASED_INDEX_FOR_POISON       = "USE_TAGBASED_INDEX_FOR_POISON";

/**
 * Number of times the poisoned item works. Or if PRC_USES_PER_ITEM_POISON_DIE
 * is set, the number of dice rolled to determine it. Should be at least 1 if
 * set.
 * Default: 1
 */
const string PRC_USES_PER_ITEM_POISON_COUNT          = "PRC_USES_PER_ITEM_POISON_COUNT";

/**
 * Size of dice used to determine number of times the poisoned item works. Value
 * should be at least 2.
 * If value is less than 2, the die roll is skipped.
 * Default: No dice are rolled.
 */
const string PRC_USES_PER_ITEM_POISON_DIE            = "USES_PER_ITEM_POISON_DIE";

/**
 * If this is nonzero, only weapons that do slashing or piercing damage are allowed
 * to be poisoned.
 * Default: All weapons can be poisoned.
 */
const string PRC_ALLOW_ONLY_SHARP_WEAPONS            = "PRC_ALLOW_ONLY_SHARP_WEAPONS";

/**
 * If this is nonzero, inhaled and ingest poisons may be placed on weapons in
 * addition to contact and injury poisons.
 * Default: Only contact and injury poisons are allowed on weapons.
 */
const string PRC_ALLOW_ALL_POISONS_ON_WEAPONS        = "PRC_ALLOW_ALL_POISONS_ON_WEAPONS";

/**
 * If this is nonzero, a DEX check is rolled against Handle_DC in the poison's
 * column in poison.2da.
 * Possessing the Use Poison feat will always pass this check.
 * Default: A static 5% failure chance is used, as per the DMG.
 */
const string PRC_USE_DEXBASED_WEAPON_POISONING_FAILURE_CHANCE = "PRC_USE_DEXBASED_WEAPON_POISONING_FAILURE_CHANCE";

/**
 * Number of hits the poison will function on the weapon. Or if
 * PRC_USES_PER_WEAPON_POISON_DIE is set, the number of dice rolled.
 * If this is set, the value should be >= 1.
 * Default: 1
 */
const string PRC_USES_PER_WEAPON_POISON_COUNT        = "PRC_USES_PER_WEAPON_POISON_COUNT";

/**
 * Size of the die rolled when determining the amount of hits the poison will
 * work on. If this is set, the value should be at least 2.
 * Default: Dice aren't rolled.
 */
const string PRC_USES_PER_WEAPON_POISON_DIE          = "PRC_USES_PER_WEAPON_POISON_DIE";

/**
 * This is the name of the script to be run when someone attempts to poison food to
 * check if the targeted item is food. The default script returns FALSE for everything,
 * so you must define your own to have this functionality.
 *
 * This switch has string values instead of integers.
 *
 * Default: poison_is_food <- an example script, just returns false
 *
 * @see poison_is_food
 */
const string PRC_POISON_IS_FOOD_SCRIPT_NAME          = "PRC_POISON_IS_FOOD_SCRIPT_NAME";

/**
 * This switch determines whether a creature equipping a poisoned item is assumed to be
 * acting smartly in that it attempts to clean the item first. If it's not set, the
 * creature just directly equips the item and gets poisoned.
 *
 * Default: Off, the creature gets poisoned without any checks
 *
 * @see poison_onequip
 */
const string PRC_POISON_ALLOW_CLEAN_IN_EQUIP         = "PRC_POISON_ALLOW_CLEAN_IN_EQUIP";


/******************************************************************************\
*                             PRGT system switches                             *
\******************************************************************************/

//these three are strings not switches
const string PRC_PRGT_XP_SCRIPT_TRIGGERED            = "PRC_PRGT_XP_SCRIPT_TRIGGERED";
const string PRC_PRGT_XP_SCRIPT_DISARMED             = "PRC_PRGT_XP_SCRIPT_DISARMED";
const string PRC_PRGT_XP_SCRIPT_RECOVERED            = "PRC_PRGT_XP_SCRIPT_RECOVERED";

/**
 * @TODO: Write description.
 */
const string PRC_PRGT_XP_AWARD_FOR_TRIGGERED         = "PRC_PRGT_XP_AWARD_FOR_TRIGGERED";

/**
 * @TODO: Write description.
 */
const string PRC_PRGT_XP_AWARD_FOR_RECOVERED         = "PRC_PRGT_XP_AWARD_FOR_RECOVERED";

/**
 * @TODO: Write description.
 */
const string PRC_PRGT_XP_AWARD_FOR_DISARMED          = "PRC_PRGT_XP_AWARD_FOR_DISARMED";



/******************************************************************************\
*                               Psionics switches                              *
\******************************************************************************/

/**
 * If this is set, use ac_appearances.2da to determine an Astral Construct's
 * appearance instead of the values hardcoded into the script.
 */
const string PRC_PSI_ASTRAL_CONSTRUCT_USE_2DA        = "ASTRAL_CONSTRUCT_USE_2DA";

/**
 * Setting this switch active makes Psychic Reformation only allow one to
 * reselect psionic powers instead of fully rebuilding their character.
 *
 * Possible values:
 * 0              = Off, Psychic Reformation behaves as specified in the power
 *                  description. That is, the target is deleveled by a certain
 *                  amount and then releveled back to where they were.
 * Nonzero, not 2 = On, Psychic Reformation only nulls a selected number of
 *                  the target's selected powers and allows reselection.
 * 2              = On, and the XP cost is reduced to 25 per level reformed.
 */
const string PRC_PSI_PSYCHIC_REFORMATION_NERF        = "PRC_PSI_PSYCHIC_REFORMATION_NERF";

/**
 * Determines how Rapid Metabolism works.
 * When set, heals the feat possessor by their Hit Dice + Constitution modifier
 * every 24h.
 * Default: Heals the feat possessor by 1 + their Constitution modifier every
 *          turn (60s).
 */
const string PRC_PNP_RAPID_METABOLISM                = "PRC_PNP_RAPID_METABOLISM";

/**
 * Determines how the epic feat Improved Metapsionics works.
 * When set, the total cost of metapsionics applied to power being manifested is
 * summed and Improved Metapsionics cost reduction is applied to the sum.
 * Default: Improved Metapsionics cost reduction is applied separately to each
 *          metapsionic used with power being manifested.
 */
const string PRC_PSI_IMP_METAPSIONICS_USE_SUM        = "PRC_PSI_IMP_METAPSIONICS_USE_SUM";


/**
 * A switch a player can personally toggle. If this is set, their augmentation level
 * is considered to be the amount of PP they are willing to pay for augmentation.
 * Default: A player's augmentation level is the number of times to augment the power.
 */
const string PRC_PLAYER_SWITCH_AUGMENT_IS_PP         = "PRC_PLAYER_SWITCH_AUGMENT_IS_PP";

/**
 * A switch a player can personally toggle. If set, the metapsionics code attempts
 * to avoid exceeding the manifester level cap by skipping application of
 * such active metapsionic feats where the cost would cause manifester level cap to
 * be exceeded. Quicken Power is exempt from ever being skipped if it is active.
 */
const string PRC_PLAYER_SWITCH_AUTOMETAPSI           = "PRC_PLAYER_SWITCH_AUTOMETAPSI";

/******************************************************************************\
*                               PnP Polymorphing switches                      *
\******************************************************************************/

/**
 * These switches are used to limit the targets that can be used with the
 * PRC Polymorph / Shifting mechanics.
 *
 * Remember, mimicing uses the targetting instance, whereas
 * shifting into that form again later creats a new instance from
 * the resref. Thus if you modify creatures after they have been
 * placed from the palette, odd things may happen.
 *
 * Also if you give any monster the "Archetypal Form" feat, the players
 * will not be able to take that monsters shape.
 */

/**
 * If set, the system compares user HD to target CR.
 * Default: user HD is compared to target HD
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_USECR                     = "PNP_SHFT_USECR";

/**
 * If set, the system does not allow target creatures of size Huge or greater.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_S_HUGE                    = "PNP_SHFT_S_HUGE";

/**
 * If set, the system does not allow target creatures of size Large.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_S_LARGE                   = "PNP_SHFT_S_LARGE";

/**
 * If set, the system does not allow target creatures of size Medium.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_S_MEDIUM                  = "PNP_SHFT_S_MEDIUM";

/**
 * If set, the system does not allow target creatures of size Small.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_S_SMALL                   = "PNP_SHFT_S_SMALL";

/**
 * If set, the system does not allow target creatures of size Tiny or smaller.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_S_TINY                    = "PNP_SHFT_S_TINY";

/**
 * If set, the system does not allow target creatures of type Outsider.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_F_OUTSIDER                = "PNP_SHFT_F_OUTSIDER";

/**
 * If set, the system does not allow target creatures of type Elemental.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_F_ELEMENTAL               = "PNP_SHFT_F_ELEMENTAL";

/**
 * If set, the system does not allow target creatures of type Construct.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_F_CONSTRUCT               = "PNP_SHFT_F_CONSTRUCT";

/**
 * If set, the system does not allow target creatures of type Undead.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_F_UNDEAD                  = "PNP_SHFT_F_UNDEAD";

/**
 * If set, the system does not allow target creatures of type Dragon.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_F_DRAGON                  = "PNP_SHFT_F_DRAGON";

/**
 * If set, the system does not allow target creatures of type Aberration.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_F_ABERRATION              = "PNP_SHFT_F_ABERRATION";

/**
 * If set, the system does not allow target creatures of type Ooze.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_F_OOZE                    = "PNP_SHFT_F_OOZE";

/**
 * If set, the system does not allow target creatures of type Magical Beast.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_F_MAGICALBEAST            = "PNP_SHFT_F_MAGICALBEAST";

/**
 * If set, the system does not allow target creatures of type Giant.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_F_GIANT                   = "PNP_SHFT_F_GIANT";

/**
 * If set, the system does not allow target creatures of type Vermin.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_F_VERMIN                  = "PNP_SHFT_F_VERMIN";

/**
 * If set, the system does not allow target creatures of type Beast.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_F_BEAST                   = "PNP_SHFT_F_BEAST";

/**
 * If set, the system does not allow target creatures of type Animal.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_F_ANIMAL                  = "PNP_SHFT_F_ANIMAL";

/**
 * If set, the system does not allow target creatures of type Monstrous Humanoid.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_F_MONSTROUSHUMANOID       = "PNP_SHFT_F_MONSTROUSHUMANOID";

/**
 * If set, the system does not allow target creatures of type Humanoid.
 * Values: 0 is not set, anything else is set.
 */
const string PNP_SHFT_F_HUMANOID                = "PNP_SHFT_F_HUMANOID";

/******************************************************************************\
*                            Combat System Switches                            *
\******************************************************************************/

/**
 * TODO: Write description.
 */
const string PRC_PNP_ELEMENTAL_DAMAGE                = "PRC_PNP_ELEMENTAL_DAMAGE";

/**
 * TODO: Write description.
 */
const string PRC_SPELL_SNEAK_DISABLE                 = "PRC_SPELL_SNEAK_DISABLE";

/**
 * Use 3.5 edition unarmed damage progression instead of 3.0 edition.
 * Default: Use 3.0 unarmed damage progression.
 */
const string PRC_3_5e_FIST_DAMAGE                    = "PRC_3_5e_FIST_DAMAGE";

/**
 * Use a Brawler character's size as a part of determining their unarmed
 * damage.
 * Default: A Brawler's size is ignored.
 */
const string PRC_BRAWLER_SIZE                        = "PRC_BRAWLER_SIZE";

/**
 * Use appearance size rather than racial-determined size
 * This also means it includes bonuses from classes and spells
 */
const string PRC_APPEARANCE_SIZE                        = "PRC_APPEARANCE_SIZE";

/**
  * This reenables the Bioware Monk attack progression, with up to 6 monk attacks per round
*/
const string PRC_BIOWARE_MONK_ATTACKS                  ="PRC_BIOWARE_MONK_ATTACKS";

/**
 * This switch (if on) takes care that only light weapons (one size smaller than the creature size)
 * are finessable, meaning that small races can only finesse tiny weapons
 */
const string PRC_SMALL_CREATURE_FINESSE                  ="PRC_SMALL_CREATURE_FINESSE";

/**
 * turns on combat debugging for scripted combat,
 * similar to Bioware's dm_enablecombatdebugging 1
 * will show a lot of info about the attack and damage rolls
 */
const string PRC_COMBAT_DEBUG                        = "PRC_COMBAT_DEBUG";

/**
 * switches on Biowares Divine Power version (bonus atacks come at full AB)
 */
const string PRC_BIOWARE_DIVINE_POWER                = "PRC_BIOWARE_DIVINE_POWER";

/**
 * if True, allows us to select a better target in prc combat functions
 * by switching from one target to another (closer) target
 * only relevant for melee combat (we never switch targets on ranged combat)
 */
const string PRC_ALLOW_SWITCH_OF_TARGET                = "PRC_ALLOW_SWITCH_OF_TARGET";

/**
 * disable coup the grace on first attack in round
 */
const string PRC_DISABLE_COUP_DE_GRACE                = "PRC_DISABLE_COUP_DE_GRACE";

/**
 * limit to the (non-dice) damage of a flame weapon or darkfire spell
 * if the switch is not set or zero, non-dice damage of flame weapon or darkfire is limited to 10
 * it is recommended not to set these switches higher than 10
 */
const string PRC_FLAME_WEAPON_DAMAGE_MAX             = "PRC_FLAME_WEAPON_DAMAGE_MAX";
const string PRC_DARKFIRE_DAMAGE_MAX                 = "PRC_DARKFIRE_DAMAGE_MAX";


/******************************************************************************\
*                           Craft System Switches                           *
\******************************************************************************/

/*
 * Completely disable the PRC Crafting System
 */
const string PRC_DISABLE_CRAFT                       = "PRC_DISABLE_CRAFT";

/*
 * Disables epic crafting
 */
const string PRC_DISABLE_CRAFT_EPIC                  = "PRC_DISABLE_CRAFT_EPIC";

/*
 * Set this on an area to disable crafting within that area
 * Best used in conjunction with the time elapsing and no-rest
 * This applies to both PRC Crafting and biowares scroll/wand/potions
 */
const string PRC_AREA_DISABLE_CRAFTING               = "PRC_AREA_DISABLE_CRAFTING";

/*
 * Inverts the behavior of previous switch
 * Will disable crafting on all areas BUT ones with the
 * PRC_AREA_DISABLE_CRAFTING switch set
 * Only works for new crafting system
 */
const string PRC_AREA_DISABLE_CRAFTING_INVERT        = "PRC_AREA_DISABLE_CRAFTING_INVERT";

/*
 * Multiply the delay (in seconds) after the creation of an item in which a PC
 * can't craft anything. This is divided by 100 to get a float.
 * Normally, it's set to the market price of the item. Set
 * it to less than 100 to reduce it instead. (default: 0).
 *
 * This is independant of PRC_PLAYER_TIME
 *
 */
const string PRC_CRAFT_TIMER_MULTIPLIER              = "PRC_CRAFT_TIMER_MULTIPLIER";

/*
 * Absolute maximum delay (in seconds) where crafting is disabled for a PC,
 * regardless of the item's market price. By default it's 0 (meaning that there's
 * no delay at all).
 *
 * This is independant of PRC_PLAYER_TIME
 *
 */
const string PRC_CRAFT_TIMER_MAX                     = "PRC_CRAFT_TIMER_MAX";

/*
 * Absolute minimum delay (in seconds) where crafting is disabled for a PC,
 * regardless of the item's market price. By default it's 0 (meaning that there's
 * no delay at all).
 *
 * This is independant of PRC_PLAYER_TIME
 *
 */
const string PRC_CRAFT_TIMER_MIN                     = "PRC_CRAFT_TIMER_MIN";

/**
 * These three switches modify Bioware crafting so that the items produced have the
 * casterlevel of the spellcaster who created them. Normally under Bioware, it is possible
 * for a level 3 caster to produce level 9 items and for a level 40 caster to only produce
 * level 5 items.
 * This also allows metamagic to apply to crafting. i.e you produce a wand of maximized fireball
 *
 * @see PRC_SCRIBE_SCROLL_CASTER_LEVEL
 * @see PRC_CRAFT_WAND_CASTER_LEVEL
 */
const string PRC_BREW_POTION_CASTER_LEVEL            = "PRC_BREW_POTION_CASTER_LEVEL";

/**
 * These three switches modify Bioware crafting so that the items produced have the
 * casterlevel of the spellcaster who created them. Normally under Bioware, it is possible
 * for a level 3 caster to produce level 9 items and for a level 40 caster to only produce
 * level 5 items.
 * This also allows metamagic to apply to crafting. i.e you produce a wand of maximized fireball
 *
 * @see PRC_BREW_POTION_CASTER_LEVEL
 * @see PRC_CRAFT_WAND_CASTER_LEVEL
 */
const string PRC_SCRIBE_SCROLL_CASTER_LEVEL          = "PRC_SCRIBE_SCROLL_CASTER_LEVEL";

/**
 * These three switches modify Bioware crafting so that the items produced have the
 * casterlevel of the spellcaster who created them. Normally under Bioware, it is possible
 * for a level 3 caster to produce level 9 items and for a level 40 caster to only produce
 * level 5 items.
 * This also allows metamagic to apply to crafting. i.e you produce a wand of maximized fireball
 *
 * @see PRC_BREW_POTION_CASTER_LEVEL
 * @see PRC_SCRIBE_SCROLL_CASTER_LEVEL
 */
const string PRC_CRAFT_WAND_CASTER_LEVEL             = "PRC_CRAFT_WAND_CASTER_LEVEL";

/**
 * As above, except it applies to staffs
 */
const string PRC_CRAFT_STAFF_CASTER_LEVEL             = "PRC_CRAFT_STAFF_CASTER_LEVEL";

/*
 * Characters with a crafting feat always have the appropriate base item in their inventory
 */
const string PRC_CRAFTING_BASE_ITEMS               = "PRC_CRAFTING_BASE_ITEMS";

/*
 * Max level of spells brewed into potions
 * defaults to 3
 */
const string X2_CI_BREWPOTION_MAXLEVEL               = "X2_CI_BREWPOTION_MAXLEVEL";

/*
 * cost modifier of spells brewed into poitions
 * defaults to 50
 */
const string X2_CI_BREWPOTION_COSTMODIFIER           = "X2_CI_BREWPOTION_COSTMODIFIER";

/*
 * cost modifier of spells scribed into scrolls
 * defaults to 25
 */
const string X2_CI_SCRIBESCROLL_COSTMODIFIER         = "X2_CI_SCRIBESCROLL_COSTMODIFIER";

/*
 * Max level of spells crafted into wands
 * defaults to 4
 */
const string X2_CI_CRAFTWAND_MAXLEVEL                = "X2_CI_CRAFTWAND_MAXLEVEL";

/*
 * cost modifier of spells crafted into wands
 * defaults to 750
 */
const string X2_CI_CRAFTWAND_COSTMODIFIER            = "X2_CI_CRAFTWAND_COSTMODIFIER";

/*
 * cost modifier of spells crafted into staffs
 * note that adding a second spell costs 75% and 3 or more costs 50%
 * defaults to 750
 */
const string X2_CI_CRAFTSTAFF_COSTMODIFIER            = "X2_CI_CRAFTSTAFF_COSTMODIFIER";

/**
 * Allows the use of arbitrary itemproperties and uses NWN item costs
 *  ie. not PnP
 */
const string PRC_CRAFTING_ARBITRARY                 = "PRC_CRAFTING_ARBITRARY";

/**
 * Scales the item costs overall for the purposes of crafting
 * defaults to 100
 */
const string PRC_CRAFTING_COST_SCALE                 = "PRC_CRAFTING_COST_SCALE";

/**
 * Sets crafting time per 1000gp in market price:
 * 1 - off, no time required
 * 2 - round
 * 3 - turn
 * 4 - hour
 * 5 - day
 * defaults to 1 hour/1000gp
 */
const string PRC_CRAFTING_TIME_SCALE                 = "PRC_CRAFTING_TIME_SCALE";

/**
 * TO DISABLE SPECIFIC PROPERTIES:
 *
 * Set a switch with the name:
 *
 * PRC_CRAFT_DISABLE_<name of crafting 2da file>_<line number of property>
 *
 * where the 2da files are named craft_* (lower case)
 */

/******************************************************************************\
*                           Teleport System Switches                           *
\******************************************************************************/

/**
 * Defines the maximum number of teleport target locations a PC may store.
 * Default: 50
 */
const string PRC_TELEPORT_MAX_TARGET_LOCATIONS          = "PRC_TELEPORT_MAX_TARGET_LOCATIONS";

/**
 * If this is set, all spells/powers/effects with the [Teleportation] descriptor
 * (ie, their scripts use GetCanTeleport()) fail.
 *
 * Default: Off
 */
const string PRC_DISABLE_TELEPORTATION                  = "PRC_DISABLE_TELEPORTATION";

/**
 * If a local integer variable by this name is set on an area, certain
 * teleportation destinations are unavailable based on the value of the variable.
 * This affects the return value of GetCanTeleport() when the bMovesCreature parameter
 * is true.
 *
 * Possible values are a bitwise combinations of the following:
 * PRC_DISABLE_TELEPORTATION_FROM_AREA
 * PRC_DISABLE_TELEPORTATION_TO_AREA
 * PRC_DISABLE_TELEPORTATION_WITHIN_AREA
 */
const string PRC_DISABLE_TELEPORTATION_IN_AREA          = "PRC_DISABLE_TELEPORTATION_IN_AREA";

/**
 * A value of PRC_DISABLE_TELEPORTATION_IN_AREA. This disables teleporting
 * from the area in question to other areas.
 */
const int PRC_DISABLE_TELEPORTATION_FROM_AREA           = 0x1;

/**
 * A value of PRC_DISABLE_TELEPORTATION_IN_AREA. This disables teleporting
 * from other areas to the area in question.
 */
const int PRC_DISABLE_TELEPORTATION_TO_AREA             = 0x2;

/**
 * A value of PRC_DISABLE_TELEPORTATION_IN_AREA. This disables both teleporting
 * from area in question to another location in that same area.
 */
const int PRC_DISABLE_TELEPORTATION_WITHIN_AREA         = 0x4;

/**
 * Forces spells/powers/effects that use GetTeleportError() to behave in a
 * specific way when their destination is in an area on which this local
 * variable is set.
 * Based on the value of this variable, such a spell/power will always behave in
 * a way described by one of the entries of Teleport results table. This happens
 * even if the spell/power would normally ignore the table.
 *
 * Default: Each spell / power behaves by it's normal specification.
 *
 * Values:
 * PRC_FORCE_TELEPORTATION_RESULT_ONTARGET
 * PRC_FORCE_TELEPORTATION_RESULT_OFFTARGET
 * PRC_FORCE_TELEPORTATION_RESULT_WAYOFFTARGET
 * PRC_FORCE_TELEPORTATION_RESULT_MISHAP
 */
const string PRC_FORCE_TELEPORTATION_RESULT             = "PRC_FORCE_TELEPORTATION_RESULT";

/**
 * A value of PRC_FORCE_TELEPORTATION_RESULT. This makes the spells affected by
 * the variable always succeed.
 */
const int PRC_FORCE_TELEPORTATION_RESULT_ONTARGET       = 1;

/**
 * A value of PRC_FORCE_TELEPORTATION_RESULT. This makes the spells affected by
 * the variable always dump the target(s) in a random location in the same area.
 */
const int PRC_FORCE_TELEPORTATION_RESULT_OFFTARGET      = 2;

/**
 * A value of PRC_FORCE_TELEPORTATION_RESULT. This makes the spells affected by
 * the variable always dump the target(s) in a random location among the users's
 * stored teleport choices, or if there are no others, just stay where the user is.
 */
const int PRC_FORCE_TELEPORTATION_RESULT_WAYOFFTARGET   = 3;

/**
 * A value of PRC_FORCE_TELEPORTATION_RESULT. This makes the spells affected by
 * the variable always do the following:
 * // Mishap:
 * // You and anyone else teleporting with you have gotten “scrambled.”
 * // You each take 1d10 points of damage, and you reroll on the chart to see where you wind up.
 * // For these rerolls, roll 1d20+80. Each time “Mishap” comes up, the characters take more damage and must reroll.
 */
const int PRC_FORCE_TELEPORTATION_RESULT_MISHAP         = 4;

/**
 * If a variable by this name is non-zero on a creature, that creature cannot
 * teleport. If you use this in your own scripts, please do not set it to
 * a static value or directly remove it.
 * Instead, increase it's value by one when the disabling occurs and decrease
 * by one when the disabling turns off. This is required in order to be able to
 * handle overlapping sources of forbiddance.
 *
 * Note: This stops all effects with the [Teleportation] descriptor, by causing
 * GetCanTeleport() to always return FALSE.
 */
const string PRC_DISABLE_CREATURE_TELEPORT              = "PRC_DISABLE_CREATURE_TELEPORT";


/******************************************************************************\
*                          Persistent World switches                           *
\******************************************************************************/

/**
 * Persistant time tracking.
 * When the first player logs on, the clock is set forward to the last time that
 * player logged off.
 */
const string PRC_PW_TIME                             = "PRC_PW_TIME";

/**
 * Number of rounds between exporting all characters.
 */
const string PRC_PW_PC_AUTOEXPORT                    = "PRC_PW_PC_AUTOEXPORT";

/**
 * A player's HP is stored via persistant locals every HB and restored on logon.
 */
const string PRC_PW_HP_TRACKING                      = "PRC_PW_HP_TRACKING";

/**
 * A player's location is stored via persistant locals every HB and restored
 * on logon.
 */
const string PRC_PW_LOCATION_TRACKING                = "PRC_PW_LOCATION_TRACKING";

/**
 * Player places map pins are tracked via persistant locals and restored on logon
 */
const string PRC_PW_MAPPIN_TRACKING                   = "PRC_PW_MAPPIN_TRACKING";

/**
 * Being dead is stored via persistant locals and restored on logon.
 */
const string PRC_PW_DEATH_TRACKING                   = "PRC_PW_DEATH_TRACKING";

/**
 * Spells cast are tracked via persistant locals and restored on logon
 */
const string PRC_PW_SPELL_TRACKING                   = "PRC_PW_SPELL_TRACKING";

/**
 * Players cant logon for this many minutes after a server load
 */
const string PRC_PW_LOGON_DELAY                      = "PRC_PW_LOGON_DELAY";



/******************************************************************************\
*                             XP system switches                               *
\******************************************************************************/

/**
 * This modifies the amount of XP a character recieves based on Level Adjustment
 * - Doesn't take racial hit dice into account.
 * - Should work with any prior XP system.
 * - Use this on pre-exisitng modules.
 */
const string PRC_XP_USE_SIMPLE_LA                    = "PRC_XP_USE_SIMPLE_LA";

/**
 * Any new characters entering the module are automatically given racial hit dice
 * Unlike PnP, they do not get to select what feats/skills the racial HD grant
 * Instead the default bioware package will be used.
 * Do not use if the ConvoCCs racial hit dice option is in use.
 */
const string PRC_XP_USE_SIMPLE_RACIAL_HD             = "PRC_XP_USE_SIMPLE_RACIAL_HD";

/**
 * Characters must earn their racial HD through the normal levelup process
 * Player must still take all their racial HD before they can take more
 * than one level in a non-racial class.
 * PRC_XP_USE_SIMPLE_RACIAL_HD must be on, and the convoCC racial hit dice option
 * must be off
 */
const string PRC_XP_USE_SIMPLE_RACIAL_HD_NO_FREE_XP  = "PRC_XP_USE_SIMPLE_RACIAL_HD_NO_FREE_XP";

/**
 * Characters are given racial HD via LevelupHenchman so can't select feats etc
 * Uses the default packages for each class, which are poor to say the least
 * PRC_XP_USE_SIMPLE_RACIAL_HD must be on, and the convoCC racial hit dice option
 * must be off
 */
const string PRC_XP_USE_SIMPLE_RACIAL_HD_NO_SELECTION  = "PRC_XP_USE_SIMPLE_RACIAL_HD_NO_SELECTION";

/**
 * Enables PRC XP system.
 * This may cause balance issues with pre-exisiting modules, so it is recomended
 * that only builders use this and do extensive playtesting and tweaking for
 * balance.
 *
 * Uses the dmgxp.2da file which is a copy of the XP tables in the DMG and ELH
 * these are based on the formula of 13.3333 encounters of CR = ECL to advance
 * a level.
 * Enconters of CR > ECL+8 or CR < ECL-8 dont give XP.
 * Tables are setup so that parties' levels will converge over time.
 */
const string PRC_XP_USE_PNP_XP                       = "PRC_XP_USE_PNP_XP";

/**
 * This value is divided by 100 when applied so a value of 100 is equivalent to 1.0
 * slider for PnP XP system, multiplier for final XP amount
 * This can also be set on individual PCs for the same result. If it is not set, then
 * it defaults to 1.0. If you want 0.0 then set it to -1
 */
const string PRC_XP_SLIDER_x100                      = "PRC_XP_SLIDER_x100";

/**
 * Use ECL for NPCs instead of CR.
 * Should be close, but I dont know how Bioware CR calculations work with the
 * PRC races.
 * Also note ECL is a measure of power in a campaign, wheras CR is measure of
 * power in a single encounter. Thus ECL weights use/day abilitieis more than
 * CR does.
 */
const string PRC_XP_USE_ECL_NOT_CR                   = "PRC_XP_USE_ECL_NOT_CR";

/**
 * If this is set, ECL = LA + racial hit dice
 * EVEN IF THE CHARACTER DOESNT HAVE ANY RACIAL HIT DICE!
 * So it penalizes the power races far more than PnP because they don't get any
 * of the other benefits of racial hit dice (BAB, HP, saves, skills, feats, etc)
 */
const string PRC_XP_INCLUDE_RACIAL_HIT_DIE_IN_LA     = "PRC_XP_INCLUDE_RACIAL_HIT_DIE_IN_LA";

/**
 * These values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0.
 * This is for purposes of party size for dividing XP awards by.
 * By PnP only PCs would count, and possibly henchmen too, but you might want to
 * tweak others for balance purposes, for example to hinder a solo wizard with
 * dozens of summons.
 */
const string PRC_XP_PC_PARTY_COUNT_x100              = "PRC_XP_PC_PARTY_COUNT_x100";

/**
 * These values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0.
 * This is for purposes of party size for dividing XP awards by.
 * By PnP only PCs would count, and possibly henchmen too, but you might want to
 * tweak others for balance purposes, for example to hinder a solo wizard with
 * dozens of summons.
 */
const string PRC_XP_HENCHMAN_PARTY_COUNT_x100        = "PRC_XP_HENCHMAN_PARTY_COUNT_x100";

/**
 * These values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0.
 * This is for purposes of party size for dividing XP awards by.
 * By PnP only PCs would count, and possibly henchmen too, but you might want to
 * tweak others for balance purposes, for example to hinder a solo wizard with
 * dozens of summons.
 */
const string PRC_XP_DOMINATED_PARTY_COUNT_x100       = "PRC_XP_DOMINATED_PARTY_COUNT_x100";

/**
 * These values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0.
 * This is for purposes of party size for dividing XP awards by.
 * By PnP only PCs would count, and possibly henchmen too, but you might want to
 * tweak others for balance purposes, for example to hinder a solo wizard with
 * dozens of summons.
 */
const string PRC_XP_ANIMALCOMPANION_PARTY_COUNT_x100 = "PRC_XP_ANIMALCOMPANION_PARTY_COUNT_x100";

/**
 * These values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0.
 * This is for purposes of party size for dividing XP awards by.
 * By PnP only PCs would count, and possibly henchmen too, but you might want to
 * tweak others for balance purposes, for example to hinder a solo wizard with
 * dozens of summons.
 */
const string PRC_XP_FAMILIAR_PARTY_COUNT_x100        = "PRC_XP_FAMILIAR_PARTY_COUNT_x100";

/**
 * These values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0.
 * This is for purposes of party size for dividing XP awards by.
 * By PnP only PCs would count, and possibly henchmen too, but you might want to
 * tweak others for balance purposes, for example to hinder a solo wizard with
 * dozens of summons.
 */
const string PRC_XP_SUMMONED_PARTY_COUNT_x100        = "PRC_XP_SUMMONED_PARTY_COUNT_x100";

/**
 * Use SetXP rather than GiveXP. Will bypass any possible Bioware interference.
 */
const string PRC_XP_USE_SETXP                        = "PRC_XP_USE_SETXP";

/**
 * Give XP to NPCs
 */
const string PRC_XP_GIVE_XP_TO_NPCS                  = "PRC_XP_GIVE_XP_TO_NPCS";

/**
 * PCs must be in the same area as the CR to gain XP.
 * Helps stop powerlevelling by detering low level characters hanging around
 * with 1 very strong char.
 */
const string PRC_XP_MUST_BE_IN_AREA                  = "PRC_XP_MUST_BE_IN_AREA";

/**
 * Maximum distance that a PC must be to gain XP.
 * Helps stop powerlevelling by detering low level characters hanging around
 * with 1 very strong char.
 */
const string PRC_XP_MAX_PHYSICAL_DISTANCE            = "PRC_XP_MAX_PHYSICAL_DISTANCE";

/**
 * Maximum level difference in levels between killer and PC being awarded XP.
 * Helps stop powerlevelling by detering low level characters hanging around
 * with 1 very strong char.
 */
const string PRC_XP_MAX_LEVEL_DIFF                   = "PRC_XP_MAX_LEVEL_DIFF";

/**
 * Gives XP to NPCs when no PCs are in their faction
 * This might cause lag if large numebrs of NPCs in the same faction.
 */
const string PRC_XP_GIVE_XP_TO_NON_PC_FACTIONS       = "PRC_XP_GIVE_XP_TO_NON_PC_FACTIONS";




/******************************************************************************\
*                      Database and Letoscript switches                        *
\******************************************************************************/

/**
 * Set this if you want to use the bioware db for 2da caching
 * the value is the number of Hbs between caching runs
 * Defaults to 300 (30 mins) if not set
 * cache will be flushed automatically when the PRC version changes
 * If this is set to -1 or lower, it is never stored for persistance over
 * module restarts.
 * The bioware database will bloat infinitely on Linux, due to biowares poor
 * handling.
 */
const string PRC_USE_BIOWARE_DATABASE                = "PRC_USE_BIOWARE_DATABASE";

/**
 * 2da caching code uses local variables on a token on a creatures inventory
 * This does not stop the creature being created or stored since the new spellbooks
 * and psionics need it. It mearly stops the 2das being cached on the creature as well
 * NOTE: a value of 0 is on by default, any other value is off
 */
const string PRC_2DA_CACHE_IN_CREATURE                = "PRC_2DA_CACHE_IN_CREATURE";

/**
 * 2da caching code will get/set directly in the bioware db
 * Off by default, gets are quite quick, sets much slower
 */
const string PRC_2DA_CACHE_IN_BIOWAREDB               = "PRC_2DA_CACHE_IN_BIOWAREDB";

/**
 * 2da caching code will get/set directly in a NWNX db
 * Must have PRC_USE_DATABASE turned on and a database setup
 * Must have a PRC_DB_* variable on to set what type of database to use
 */
const string PRC_2DA_CACHE_IN_NWNXDB                  = "PRC_2DA_CACHE_IN_NWNXDB";

/**
 * Set this if you are using NWNX and any sort of database.
 */
const string PRC_USE_DATABASE                        = "PRC_USE_DATABASE";

/**
 * Set this if you are using SQLite (the built-in database in NWNX-ODBC2).
 * This will use transactions and SQLite specific syntax.
 */
const string PRC_DB_SQLLITE                          = "PRC_DB_SQLLITE";

/**
 * This is the interval of each transaction. By default it is 600 seconds.
 * Shorter will mean slower, but less data lost in the event of a server crash.
 * Longer is visa versa.
 */
const string PRC_DB_SQLLITE_INTERVAL                 = "PRC_DB_SQLLITE_INTERVAL";

/**
 * Set this if you are using MySQL.
 * This will not use transactions and will use MySQL specific syntax
 */
const string PRC_DB_MYSQL                            = "PRC_DB_MYSQL";


/**
 * This will precache 2da files into the database.
 * The first time a module runs with this set it will lag a lot for a long time
 * as the game does 2da reads.
 * Afterwards it will be much faster.
 * This is a really, really long lag. Like days/weeks type length.
 * This is not the "normal" precaching that the spellbooks & psionics does.
 */
const string PRC_DB_PRECACHE                         = "PRC_DB_PRECACHE";

/**
 * TODO: Write description.
 */
const string PRC_USE_LETOSCRIPT                      = "PRC_USE_LETOSCRIPT";

/**
 * Set this to 1 if using build 18
 */
const string PRC_LETOSCRIPT_PHEONIX_SYNTAX           = "PRC_LETOSCRIPT_PHEONIX_SYNTAX";

/**
 * Set this to 1 to have Letoscript convert stat boosts on the hide to
 * permanent ones.
 */
const string PRC_LETOSCRIPT_FIX_ABILITIES            = "PRC_LETOSCRIPT_FIX_ABILITIES";

/**
 * Letoscript needs a string named PRC_LETOSCRIPT_NWN_DIR set to the
 * directory of NWN. If it doesnt work, try different slash options: // \\ / \
 */
const string PRC_LETOSCRIPT_NWN_DIR                  = "PRC_LETOSCRIPT_NWN_DIR";

/**
 * Switch so that Unicorn will use the SQL database for SCO/RCO
 * Must have the zeoslib.dlls installed for this
 *
 * UNTESTED!!!
 */
const string PRC_LETOSCRIPT_UNICORN_SQL              = "PRC_LETOSCRIPT_UNICORN_SQL";

/**
 * This is a string, not integer.
 * If the IP is set, Letoscript will use ActivatePortal instead of booting.
 * The IP and Password must be correct for your server or bad things will happen.
 * - If your IP is non-static make sure this is kept up to date.
 *
 * See the Lexicon entry on ActivatePortal for more information.
 *
 * @see PRC_LETOSCRIPT_PORTAL_PASSWORD
 */
const string PRC_LETOSCRIPT_PORTAL_IP                = "PRC_LETOSCRIPT_PORTAL_IP";

/**
 * This is a string, not integer.
 * If the IP is set, Letoscript will use ActivatePortal instead of booting.
 * The IP and Password must be correct for your server or bad things will happen.
 * - If your IP is non-static make sure this is kept up to date.
 *
 * See the Lexicon entry on ActivatePortal for more information.
 *
 * @see PRC_LETOSCRIPT_PORTAL_IP
 */
const string PRC_LETOSCRIPT_PORTAL_PASSWORD          = "PRC_LETOSCRIPT_PORTAL_PASSWORD";

/**
 * If set you must be using Unicorn.
 * Will use getnewest bic instead of filename reconstruction (which fails if
 * multiple characters have the same name)
 */
const string PRC_LETOSCRIPT_GETNEWESTBIC             = "PRC_LETOSCRIPT_GETNEWESTBIC";




/******************************************************************************\
*                              ConvoCC switches                                *
\******************************************************************************/

/**
 * Activates the ConvoCC.
 * This doesn't turn on the database and letoscript as well, which you must
 * do yourself.
 *
 * @see PRC_USE_DATABASE
 * @see PRC_USE_LETOSCRIPT
 */
const string PRC_CONVOCC_ENABLE                      = "PRC_CONVOCC_ENABLE";

/**
 * Avariel characters have bird wings.
 */
const string PRC_CONVOCC_AVARIEL_WINGS               = "PRC_CONVOCC_AVARIEL_WINGS";

/**
 * Fey'ri characters have bat wings.
 */
const string PRC_CONVOCC_FEYRI_WINGS                 = "PRC_CONVOCC_FEYRI_WINGS";

/**
 * Aasimar characters have the option of angel wings
 * Note: Not set by PRC_CONVOCC_ENFORCE_PNP_RACIAL as it isn't part of PnP
 */

const string PRC_CONVOCC_AASIMAR_WINGS               = "PRC_CONVOCC_AASIMAR_WINGS";

/**
 * Fey'ri characters have a demonic tail.
 */
const string PRC_CONVOCC_FEYRI_TAIL                  = "PRC_CONVOCC_FEYRI_TAIL";

/**
 * Teifling characters have the option of a demonic tail.
 */
const string PRC_CONVOCC_TIEFLING_TAIL               = "PRC_CONVOCC_TIEFLING_TAIL";

/**
 * Force Drow characters to be of the correct gender for their race.
 */
const string PRC_CONVOCC_DROW_ENFORCE_GENDER         = "PRC_CONVOCC_DROW_ENFORCE_GENDER";

/**
 * Force Genasi clerics to select the relevant elemental domain as one of
 * their feats.
 */
const string PRC_CONVOCC_GENASI_ENFORCE_DOMAINS      = "PRC_CONVOCC_GENASI_ENFORCE_DOMAINS";

/**
 * Female Rakshasa use the female rakshasa model. Use together with PRC_CONVOCC_USE_RACIAL_APPEARANCES
 * @see PRC_CONVOCC_USE_RACIAL_APPEARANCES
 */
const string PRC_CONVOCC_RAKSHASA_FEMALE_APPEARANCE = "PRC_CONVOCC_RAKSHASA_FEMALE_APPEARANCE";

/**
 * A combination switch to turn on all the racial enforcement settings.
 * @see PRC_CONVOCC_RAKSHASA_FEMALE_APPEARANCE
 * @see PRC_CONVOCC_GENASI_ENFORCE_DOMAINS
 * @see PRC_CONVOCC_DROW_ENFORCE_GENDER
 * @see PRC_CONVOCC_TIEFLING_TAIL
 * @see PRC_CONVOCC_FEYRI_TAIL
 * @see PRC_CONVOCC_FEYRI_WINGS
 * @see PRC_CONVOCC_AVARIEL_WINGS
 */
const string PRC_CONVOCC_ENFORCE_PNP_RACIAL          = "PRC_CONVOCC_ENFORCE_PNP_RACIAL";

/**
 * Note: feat enforcement switches don't do anything (TODO?)
 */

/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_BLOOD_OF_THE_WARLORD= "PRC_CONVOCC_ENFORCE_BLOOD_OF_THE_WARLORD";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_NIMBUSLIGHT    = "PRC_CONVOCC_ENFORCE_FEAT_NIMBUSLIGHT";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_HOLYRADIANCE   = "PRC_CONVOCC_ENFORCE_FEAT_HOLYRADIANCE";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_SERVHEAVEN     = "PRC_CONVOCC_ENFORCE_FEAT_SERVHEAVEN";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_SAC_VOW        = "PRC_CONVOCC_ENFORCE_FEAT_SAC_VOW";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_VOW_OBED       = "PRC_CONVOCC_ENFORCE_FEAT_VOW_OBED";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_THRALL_TO_DEMON= "PRC_CONVOCC_ENFORCE_FEAT_THRALL_TO_DEMON";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_DISCIPLE_OF_DARKNESS="PRC_CONVOCC_ENFORCE_FEAT_DISCIPLE_OF_DARKNESS";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_LICHLOVED      = "PRC_CONVOCC_ENFORCE_FEAT_LICHLOVED";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_EVIL_BRANDS    = "PRC_CONVOCC_ENFORCE_FEAT_EVIL_BRANDS";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_VILE_WILL_DEFORM="PRC_CONVOCC_ENFORCE_FEAT_VILE_WILL_DEFORM";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_OBESE="PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_OBESE";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_GAUNT="PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_GAUNT";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_LOLTHS_MEAT   = "PRC_CONVOCC_ENFORCE_FEAT_LOLTHS_MEAT";


/**
 * A combination switch to turn on all the feat enforcement settings. Doesn't do anything
 */
const string PRC_CONVOCC_ENFORCE_FEATS               = "PRC_CONVOCC_ENFORCE_FEATS";

/**
 * Stops players from changing their wings. Turning this on gives players only the "none" choice
 * at the wing stage of the convoCC. Use in conjuction with the wing switches.
 * @see PRC_CONVOCC_AVARIEL_WINGS
 * @see PRC_CONVOCC_FEYRI_WINGS
 * @see PRC_CONVOCC_AASIMAR_WINGS
 */
const string PRC_CONVOCC_DISALLOW_CUSTOMISE_WINGS    = "PRC_CONVOCC_DISALLOW_CUSTOMISE_WINGS";

/**
 * Stops players from changing their tail. Turning this on gives players only the "none" choice
 * at the tail stage of the convoCC. Use in conjuction with the tail switches.
 * @see PRC_CONVOCC_FEYRI_TAIL
 * @see PRC_CONVOCC_TIEFLING_TAIL
 */
const string PRC_CONVOCC_DISALLOW_CUSTOMISE_TAIL     = "PRC_CONVOCC_DISALLOW_CUSTOMISE_TAIL";

/**
 * Stops players from changing their model at all. Doesn't do anything
 */
const string PRC_CONVOCC_DISALLOW_CUSTOMISE_MODEL    = "PRC_CONVOCC_DISALLOW_CUSTOMISE_MODEL";

/**
 * Players are only given a choice of appearances that match their race. For most races, this is the
 * default appearance defined in racialtypes.2da.
 * @see PRC_CONVOCC_RAKSHASA_FEMALE_APPEARANCE
 */
const string PRC_CONVOCC_USE_RACIAL_APPEARANCES      = "PRC_CONVOCC_USE_RACIAL_APPEARANCES";
/**
 * Player can only choose a portrait that matches their race as in portraits.2da. Because
 * Bioware's elf, dwarf etc. subrace portraits are labelled as eg. 'elf' not 'drow' and because
 * half elves have no portraits, this is actually done on appearance and not on race for PCs using
 * Bioware's PC appearance models.
 */
const string PRC_CONVOCC_USE_RACIAL_PORTRAIT         = "PRC_CONVOCC_USE_RACIAL_PORTRAIT";

/**
 * Players can only select from the player voicesets. NPC voicesets are not
 * complete, so wont play sounds for many things such as emotes.
 */
const string PRC_CONVOCC_ONLY_PLAYER_VOICESETS       = "PRC_CONVOCC_ONLY_PLAYER_VOICESETS";

/**
 * Only allows players to select voiceset of the same gender as their character.
 */
const string PRC_CONVOCC_RESTRICT_VOICESETS_BY_SEX   = "PRC_CONVOCC_RESTRICT_VOICESETS_BY_SEX";

/**
 * Allow players to keep their exisiting voiceset.
 * The ConvoCC cannot allow players to select custom voiceset, so the only way
 * for players to have them is to select them in the Bioware character creator
 * and then select to keep them in the ConvoCC.
 */
const string PRC_CONVOCC_ALLOW_TO_KEEP_VOICESET      = "PRC_CONVOCC_ALLOW_TO_KEEP_VOICESET";

/**
 * Allow players to keep their exisiting portrait.
 * The ConvoCC cannot allow players to select custom portraits, so the only way
 * for players to have them is to select them in the Bioware character creator
 * and then select to keep them in the ConvoCC.
 */
const string PRC_CONVOCC_ALLOW_TO_KEEP_PORTRAIT      = "PRC_CONVOCC_ALLOW_TO_KEEP_PORTRAIT";

/**
 * Only allow players to select portraits of the same gender as their character.
 * Most of the NPC portraits do not have a gender so are also removed.
 */
const string PRC_CONVOCC_RESTRICT_PORTRAIT_BY_SEX    = "PRC_CONVOCC_RESTRICT_PORTRAIT_BY_SEX";

/**
 * This option give players the ability to start with racial hit dice for some
 * of the more powerful races. These are defined in ECL.2da.
 * For these races, players do not pick a class in the ConvoCC but instead
 * select 1 or more levels in a racial class (such as monsterous humanoid, or
 * outsider).
 * This is not a complete ECL system, it merely gives players the racial hit
 * dice component of their race. It does not make any measure of the Level
 * Adjustment component. For example, a pixie has no racial hit dice, but has a
 * +4 level adjustment. Doesn't do anything
 */
const string PRC_CONVOCC_ENABLE_RACIAL_HITDICE       = "PRC_CONVOCC_ENABLE_RACIAL_HITDICE";

/**
 * This option allows players to keep their skillpoints from one level to
 * the next, if they want to.
 */
const string PRC_CONVOCC_ALLOW_SKILL_POINT_ROLLOVER  = "PRC_CONVOCC_ALLOW_SKILL_POINT_ROLLOVER";

/**
 * This will identify new characters based on XP as in v1.3
 * This is less secure than using the encrypted key.
 * @see PRC_CONVOCC_ENCRYPTION_KEY
 */
const string PRC_CONVOCC_USE_XP_FOR_NEW_CHAR         = "PRC_CONVOCC_USE_XP_FOR_NEW_CHAR";

/**
 * This is the key used to encrypt characters' names if USE_XP_FOR_NEW_CHAR
 * is false in order to identify returning characters. It should be in the
 * range 1-100.
 * If USE_XP_FOR_NEW_CHAR is true along with this, then returning characters
 * will be encrypted too, so once everone has logged on at least once,
 * USE_XP_FOR_NEW_CHAR can be set to false for greater security.
 *
 * WARNING: Changing this value after some PCs have gone through the convoCC will
 * cause them to have to go through it again. The encryption uses the player's
 * public CD key, so they won't be able to log into their account from different
 * NWN installs as the key won't match using this system
 */
const string PRC_CONVOCC_ENCRYPTION_KEY              = "PRC_CONVOCC_ENCRYPTION_KEY";

/**
 * As requested, an option to alter the amount of points available in the stat
 * point-buy at character creation.
 * Default: 30
 */
const string PRC_CONVOCC_STAT_POINTS                 = "PRC_CONVOCC_STAT_POINTS";

/**
 * As requirested, if set this will give a number of bonus feats equal to this
 * value to each created character, similar to human Quick To Master feat.
 */
const string PRC_CONVOCC_BONUS_FEATS                 = "PRC_CONVOCC_BONUS_FEATS";

/**
 * As requested, this will cap the maximum a stat can start at, excluding racial
 * modifies.
 * Default: 18
 */
const string PRC_CONVOCC_MAX_STAT                    = "PRC_CONVOCC_MAX_STAT";

/**
 * As requested, this will change the skill point multplier at level 1.
 * Default: 4
 */
const string PRC_CONVOCC_SKILL_MULTIPLIER            = "PRC_CONVOCC_SKILL_MULTIPLIER";

/**
 * As requested, this will give a bonus to skill points after multiplication.
 */
const string PRC_CONVOCC_SKILL_BONUS                 = "PRC_CONVOCC_SKILL_BONUS";

/**
 * When set, the convoCC NO LONGER STARTS AUTOMATICALLY on logging in. It must be called
 * by a script in the module. This allows the module builder to start the convoCC from a
 * particular area or trigger's On Enter event. The script should call the convoCC with
 * ExecuteScript("prc_ccc_main", oPC) where oPC is the PC. It's advisable to check the
 * entering object is a PC and not a NPC or DM.
 */

const string PRC_CONVOCC_CUSTOM_START_LOCATION       = "PRC_CONVOCC_CUSTOM_START_LOCATION";

/**
 * When set, this switch causes a custom script to be used to determine whether a PC should go
 * through the convoCC or not.
 * The script must:
 * - be called "ccc_custom_enter"
 * - set the local int "CONVOCC_LAST_STATUS" on the PC (OBJECT_SELF)
 * - include prc_ccc_const (for the constants the local int can be set to)
 * otherwise the PC will always be booted
 *
 * possible values for CONVOCC_LAST_STATUS:
 * CONVOCC_ENTER_BOOT_PC (causes the PC to get kicked)
 * CONVOCC_ENTER_NEW_PC (causes the PC to go through the convoCC)
 * CONVOCC_ENTER_RETURNING_PC (causes the PC to skip the convoCC)
 *
 * This switch will completely bypass the convoCC methods for determining whether to run the
 * convoCC on an entering PC, so if necessary, your custom marker for 'done' would be set
 * in 'ccc_custom_exit'
 * @see PRC_CONVOCC_CUSTOM_EXIT_SCRIPT
 */
const string PRC_CONVOCC_CUSTOM_ENTER_SCRIPT          = "PRC_CONVOCC_CUSTOM_ENTER_SCRIPT";

/**
 * When set, this switch causes a custom script to be executed at the last stage of the convoCC,
 * just before booting the player. The script must be named 'ccc_custom_exit'.
 * Possible uses include: giving PCs gold and/or equipment, giving PCs PW items
 * (even plot items get removed at the start of the convoCC), setting a new persistant location,
 * setting a custom marker for having done the convoCC in conjunction with
 * 'ccc_custom_enter'
 * @see PRC_CONVOCC_CUSTOM_ENTER_SCRIPT
 */

const string PRC_CONVOCC_CUSTOM_EXIT_SCRIPT          = "PRC_CONVOCC_CUSTOM_EXIT_SCRIPT";

/******************************************************************************\
*                              Truenaming switches                             *
\******************************************************************************/

/**
 * Sets the CR Multiplier for Evolving Mind utterances
 * This is divided by 100 to get a float.
 * Ex: To multiply by 1.5, set this value to 150
 *
 * The formula used is (CR * Multiplier) + 15
 *
 * defaults to PnP: (CR * 2) + 15
 */
const string PRC_TRUENAME_CR_MULTIPLIER              = "PRC_TRUENAME_CR_MULTIPLIER";

/**
 * Gives a bonus based on Truenamer level
 * PC Truenamer level is divided by this value
 * Ex: To give a bonus equal to 1/2 Truenamer level, set this to 2
 *
 * The formula used is (CR * Multiplier) + 15 - Bonus
 *
 * defaults to PnP: 0/No bonus
 */
const string PRC_TRUENAME_LEVEL_BONUS                = "PRC_TRUENAME_LEVEL_BONUS";

/**
 * Sets the Constant value added to the DC
 * Ex: To make the constant 10, simply set this value to 10
 *
 * The formula used is (CR * Multiplier) + Constant
 *
 * defaults to PnP: +15.
 */
const string PRC_TRUENAME_DC_CONSTANT                = "PRC_TRUENAME_DC_CONSTANT";

/**
 * Sets the Constant value added to the DC
 * Ex: To make the constant 10, simply set this value to 10
 *
 * The formula used is Constant + (2 * Utterance Level)
 *
 * defaults to PnP: +25.
 */
const string PRC_PERFECTED_MAP_CONSTANT              = "PRC_PERFECTED_MAP_CONSTANT";

/**
 * Sets the Multiplier value added to the DC
 * Ex: To make the multiplier 4, simply set this value to 4
 *
 * The formula used is 25 + (Multiplier * Utterance Level)
 *
 * defaults to PnP: 2.
 */
const string PRC_PERFECTED_MAP_MULTIPLIER            = "PRC_PERFECTED_MAP_MULTIPLIER";


/******************************************************************************\
*                             Debugging Switches                               *
\******************************************************************************/

/**
 * Toggles everything guarded by "if(DEBUG)". Mostly calls to DoDebug().
 */
const string PRC_DEBUG                               = "PRC_DEBUG";




///////////////////////
// Function protypes //
///////////////////////


/**
 * Checks the state of a PRC switch.
 * NOTE: This will only work with switches that use integer values. You
 * must get the value of non-integer-valued switches manually.
 *
 * @param sSwitch  One of the PRC_* constant strings defined in prc_inc_switch
 * @return         The value of the switch queried
 */
int GetPRCSwitch(string sSwitch);

/**
 * Sets a PRC switch state.
 * NOTE: As this will only set switches with integer values, you will need
 * to manually set the (few) switches that should have a value other than
 * integer.
 *
 * @param sSwitch  One of the PRC_* constant strings defined in prc_inc_switch
 * @param nState   The integer value to set the switch to
 */
void SetPRCSwitch(string sSwitch, int nState);

/**
 * Multisummon code, to be run before the summoning effect is applied.
 * Normally, this will only perform the multisummon trick of setting
 * pre-existing summons indestructable if PRC_MULTISUMMON is set.
 *
 * @param oPC          The creature casting the summoning spell
 * @param bOverride    If this is set, ignores the value of PRC_MULTISUMMON switch
 */
void MultisummonPreSummon(object oPC = OBJECT_SELF, int bOverride = FALSE);


/**
 * Sets the epic spell switches to their default values.
 *
 * If PRC_EPIC_INGORE_DEFAULTS is set, this does nothing.
 */
void DoEpicSpellDefaults();

/**
 * Sets the file end markers to their default values.
 *
 * If FILE_END_MANUAL is set, this does nothing.
 */
void SetDefaultFileEnds();

/*
 * This creates an array of all switch names on a waypoint
 * It is used for the switch setting convo to loop over switches easily
 */
void CreateSwitchNameArray();


//////////////////////////////////////////////////
/* Include section                              */
//////////////////////////////////////////////////

#include "inc_array" // Needs direct include instead of inc_utility
#include "prc_inc_fileend"


//////////////////////////
// Function definitions //
//////////////////////////

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
    if(!GetPRCSwitch(PRC_MULTISUMMON) && !bOverride)
        return;
    int i=1;
    int nCount = GetPRCSwitch(PRC_MULTISUMMON);
    if(bOverride)
        nCount = bOverride;
    if(nCount < 0
        || nCount == 1)
        nCount = 99;
    if(nCount > 99)
        nCount = 99;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    while(GetIsObjectValid(oSummon) && i < nCount)
    {
        AssignCommand(oSummon, SetIsDestroyable(FALSE, FALSE, FALSE));
        AssignCommand(oSummon, DelayCommand(0.3, SetIsDestroyable(TRUE, FALSE, FALSE)));
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    }
}

void DoSamuraiBanDefaults()
{
    if(GetPRCSwitch(PRC_SAMURAI_DISABLE_DEFAULT_BAN))
        return;
    //remove all penalty iprops
    SetPRCSwitch(PRC_SAMURAI_BAN_+"10_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"21_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"24_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"27_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"28_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"29_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"47_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"49_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"50_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"60_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"62_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"63_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"64_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"65_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"66_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"81_*_*_*", TRUE);
    //PRCs restrictions
    SetPRCSwitch(PRC_SAMURAI_BAN_+"86_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"87_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"88_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"89_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"90_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"91_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"120_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"121_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"122_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"123_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"124_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"125_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"126_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"127_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"134_*_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"150_*_*_*", TRUE);
    //only allow elemental damages 6,7,9,10,13
    //damage
    SetPRCSwitch(PRC_SAMURAI_BAN_+"16_5_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"16_8_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"16_11_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"16_12_*_*", TRUE);
    //damage vs race
    SetPRCSwitch(PRC_SAMURAI_BAN_+"17_*_5_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"17_*_8_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"17_*_11_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"17_*_12_*", TRUE);
    //damage vs alignment
    SetPRCSwitch(PRC_SAMURAI_BAN_+"18_*_5_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"18_*_8_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"18_*_11_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"18_*_12_*", TRUE);
    //damage vs specific alignment
    SetPRCSwitch(PRC_SAMURAI_BAN_+"19_*_5_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"19_*_8_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"19_*_11_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"19_*_12_*", TRUE);
    //damage immunity
    SetPRCSwitch(PRC_SAMURAI_BAN_+"20_5_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"20_8_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"20_11_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"20_12_*_*", TRUE);
    //damage resist
    SetPRCSwitch(PRC_SAMURAI_BAN_+"20_5_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"20_8_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"20_11_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"20_12_*_*", TRUE);
    //slays
    SetPRCSwitch(PRC_SAMURAI_BAN_+"48_21_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"48_22_*_*", TRUE);
    SetPRCSwitch(PRC_SAMURAI_BAN_+"48_23_*_*", TRUE);
    //vorpal
    SetPRCSwitch(PRC_SAMURAI_BAN_+"48_24_*_*", TRUE);
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

int PRCGetFileEnd(string sTable)
{
    sTable = GetStringLowerCase(sTable);
    return GetPRCSwitch("PRC_FILE_END_" + sTable);
}

void SetDefaultFileEnds()
{
    //START AUTO-GENERATED FILEENDS
    SetPRCSwitch("PRC_FILE_END_ammunitiontypes", 46);
    SetPRCSwitch("PRC_FILE_END_appearance", 481);
    SetPRCSwitch("PRC_FILE_END_appearancesndset", 28);
    SetPRCSwitch("PRC_FILE_END_areaeffects", 2);
    SetPRCSwitch("PRC_FILE_END_armor", 9);
    SetPRCSwitch("PRC_FILE_END_armorparts", 1);
    SetPRCSwitch("PRC_FILE_END_armourtypes", 42);
    SetPRCSwitch("PRC_FILE_END_baseitems", 201);
    SetPRCSwitch("PRC_FILE_END_caarmorclass", 7);
    SetPRCSwitch("PRC_FILE_END_capart", 18);
    SetPRCSwitch("PRC_FILE_END_catype", 4);
    SetPRCSwitch("PRC_FILE_END_classes", 254);
    SetPRCSwitch("PRC_FILE_END_cloakmodel", 15);
    SetPRCSwitch("PRC_FILE_END_cls_atk_1", 60);
    SetPRCSwitch("PRC_FILE_END_cls_atk_2", 61);
    SetPRCSwitch("PRC_FILE_END_cls_atk_3", 61);
    SetPRCSwitch("PRC_FILE_END_cls_atk_4", 59);
    SetPRCSwitch("PRC_FILE_END_cls_atk_5", 59);
    SetPRCSwitch("PRC_FILE_END_cls_atk_adst", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_adst", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_alag", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_alienist", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_aots", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_arch", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_archer", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_arclb", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_arctrk", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_asasin", 67);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_baal", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_barb", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_bard", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_bereft", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_bfz", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_blades", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_blarch", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_blkgrd", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_blmagu", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_bltl", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_bonded", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_brage", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_brawl", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_brimst", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_cbtmed", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_cereb", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_cler", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_cntmp", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_coc", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_crusdr", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_cwsm", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_diabol", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_dirge", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_disp", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_divcha", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_doa", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_dradis", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_drnkn", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_drowj", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_drslyr", 49);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_dru", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_duel", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_duskbl", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_dwdef", 61);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_eldkni", 58);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_enlfis", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_eog", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_favsol", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_fh", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_fight", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_fistra", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_fom", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_foz", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_frebzk", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_gfkill", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_harper", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_hath", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_havocm", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_healer", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_heartw", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_hexbl", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_hextor", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_hiero", 4);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_hmage", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_hnshn", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_hosp", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_iaij", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_irnmnd", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_kchal", 10);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_kensei", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_knight", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_kord", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_kotmc", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_lasher", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_lgdr", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_lich", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_maestr", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_magek", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_manat", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_marsh", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_meph", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_mharp", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_minstr", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_monk", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_mos", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_mystic", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_ninjca", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_ocu", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_ollam", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_ootbi", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_ooze", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_orcus", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_orcwar", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_pal", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_palema", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_parch", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_pdk", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_psion", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_psych", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_psywar", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_rang", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_rava", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_redav", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_redwiz", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_rog", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_rune", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_runec", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_sacfis", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_samur", 58);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_savant", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_sbheir", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_scout", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_shadow", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_shiftr", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_shou", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_shugen", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_sklcln", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_sleat", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_sncmnd", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_sod", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_sohei", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_sol", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_sorc", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_soulkn", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_spellf", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_spells", 58);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_storml", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_suel", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_swash", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_swdsge", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_tempst", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_tempus", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_tfshad", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_thaykt", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_thrall", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_tnecro", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_tog", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_true", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_urang", 58);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_vassal", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_vigil", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_virt", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_warbld", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_warchf", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_wardrk", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_warmnd", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_wilder", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_wiz", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_wm", 60);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_wrmage", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_wrslng", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_wwoc", 59);
    SetPRCSwitch("PRC_FILE_END_cls_bfeat_wwolf", 59);
    SetPRCSwitch("PRC_FILE_END_cls_feat_aber", 228);
    SetPRCSwitch("PRC_FILE_END_cls_feat_adst", 15);
    SetPRCSwitch("PRC_FILE_END_cls_feat_alag", 223);
    SetPRCSwitch("PRC_FILE_END_cls_feat_alienist", 36);
    SetPRCSwitch("PRC_FILE_END_cls_feat_antipl", 597);
    SetPRCSwitch("PRC_FILE_END_cls_feat_aots", 129);
    SetPRCSwitch("PRC_FILE_END_cls_feat_arch", 39);
    SetPRCSwitch("PRC_FILE_END_cls_feat_archer", 63);
    SetPRCSwitch("PRC_FILE_END_cls_feat_arclb", 269);
    SetPRCSwitch("PRC_FILE_END_cls_feat_arctrk", 99);
    SetPRCSwitch("PRC_FILE_END_cls_feat_asasin", 204);
    SetPRCSwitch("PRC_FILE_END_cls_feat_baal", 18);
    SetPRCSwitch("PRC_FILE_END_cls_feat_baeln", 22);
    SetPRCSwitch("PRC_FILE_END_cls_feat_barb", 344);
    SetPRCSwitch("PRC_FILE_END_cls_feat_bard", 856);
    SetPRCSwitch("PRC_FILE_END_cls_feat_bereft", 4);
    SetPRCSwitch("PRC_FILE_END_cls_feat_bfz", 31);
    SetPRCSwitch("PRC_FILE_END_cls_feat_blades", 109);
    SetPRCSwitch("PRC_FILE_END_cls_feat_blarch", 17);
    SetPRCSwitch("PRC_FILE_END_cls_feat_blkgrd", 339);
    SetPRCSwitch("PRC_FILE_END_cls_feat_blmagus", 35);
    SetPRCSwitch("PRC_FILE_END_cls_feat_bltl", 11);
    SetPRCSwitch("PRC_FILE_END_cls_feat_bonded", 47);
    SetPRCSwitch("PRC_FILE_END_cls_feat_brage", 178);
    SetPRCSwitch("PRC_FILE_END_cls_feat_brawl", 487);
    SetPRCSwitch("PRC_FILE_END_cls_feat_brimst", 5);
    SetPRCSwitch("PRC_FILE_END_cls_feat_cbtmed", 7);
    SetPRCSwitch("PRC_FILE_END_cls_feat_cereb", 213);
    SetPRCSwitch("PRC_FILE_END_cls_feat_chaban", 343);
    SetPRCSwitch("PRC_FILE_END_cls_feat_cheat", 37);
    SetPRCSwitch("PRC_FILE_END_cls_feat_cler", 683);
    SetPRCSwitch("PRC_FILE_END_cls_feat_cntmp", 52);
    SetPRCSwitch("PRC_FILE_END_cls_feat_coc", 384);
    SetPRCSwitch("PRC_FILE_END_cls_feat_comm", 41);
    SetPRCSwitch("PRC_FILE_END_cls_feat_corup", 388);
    SetPRCSwitch("PRC_FILE_END_cls_feat_crea", 287);
    SetPRCSwitch("PRC_FILE_END_cls_feat_crusdr", 163);
    SetPRCSwitch("PRC_FILE_END_cls_feat_cwsm", 527);
    SetPRCSwitch("PRC_FILE_END_cls_feat_diabol", 117);
    SetPRCSwitch("PRC_FILE_END_cls_feat_dirge", 4);
    SetPRCSwitch("PRC_FILE_END_cls_feat_disp", 19);
    SetPRCSwitch("PRC_FILE_END_cls_feat_divcha", 342);
    SetPRCSwitch("PRC_FILE_END_cls_feat_doa", 11);
    SetPRCSwitch("PRC_FILE_END_cls_feat_dradis", 152);
    SetPRCSwitch("PRC_FILE_END_cls_feat_drag", 285);
    SetPRCSwitch("PRC_FILE_END_cls_feat_drnkn", 18);
    SetPRCSwitch("PRC_FILE_END_cls_feat_drowj", 43);
    SetPRCSwitch("PRC_FILE_END_cls_feat_drslyr", 221);
    SetPRCSwitch("PRC_FILE_END_cls_feat_druid", 670);
    SetPRCSwitch("PRC_FILE_END_cls_feat_duel", 66);
    SetPRCSwitch("PRC_FILE_END_cls_feat_duskbl", 626);
    SetPRCSwitch("PRC_FILE_END_cls_feat_dwdef", 198);
    SetPRCSwitch("PRC_FILE_END_cls_feat_eldkni", 283);
    SetPRCSwitch("PRC_FILE_END_cls_feat_enlfis", 168);
    SetPRCSwitch("PRC_FILE_END_cls_feat_eog", 16);
    SetPRCSwitch("PRC_FILE_END_cls_feat_favsol", 1453);
    SetPRCSwitch("PRC_FILE_END_cls_feat_fey", 41);
    SetPRCSwitch("PRC_FILE_END_cls_feat_fh", 34);
    SetPRCSwitch("PRC_FILE_END_cls_feat_fight", 521);
    SetPRCSwitch("PRC_FILE_END_cls_feat_fistra", 342);
    SetPRCSwitch("PRC_FILE_END_cls_feat_fom", 37);
    SetPRCSwitch("PRC_FILE_END_cls_feat_foz", 257);
    SetPRCSwitch("PRC_FILE_END_cls_feat_frebzk", 25);
    SetPRCSwitch("PRC_FILE_END_cls_feat_gfkill", 26);
    SetPRCSwitch("PRC_FILE_END_cls_feat_gian", 286);
    SetPRCSwitch("PRC_FILE_END_cls_feat_harper", 88);
    SetPRCSwitch("PRC_FILE_END_cls_feat_hath", 77);
    SetPRCSwitch("PRC_FILE_END_cls_feat_havocm", 0);
    SetPRCSwitch("PRC_FILE_END_cls_feat_healer", 662);
    SetPRCSwitch("PRC_FILE_END_cls_feat_heartw", 108);
    SetPRCSwitch("PRC_FILE_END_cls_feat_hexbl", 464);
    SetPRCSwitch("PRC_FILE_END_cls_feat_hextor", 201);
    SetPRCSwitch("PRC_FILE_END_cls_feat_hiero", 44);
    SetPRCSwitch("PRC_FILE_END_cls_feat_hmage", 78);
    SetPRCSwitch("PRC_FILE_END_cls_feat_hnshn", 33);
    SetPRCSwitch("PRC_FILE_END_cls_feat_hosp", 298);
    SetPRCSwitch("PRC_FILE_END_cls_feat_iaij", 199);
    SetPRCSwitch("PRC_FILE_END_cls_feat_inidra", 118);
    SetPRCSwitch("PRC_FILE_END_cls_feat_irnmnd", 10);
    SetPRCSwitch("PRC_FILE_END_cls_feat_kchal", 176);
    SetPRCSwitch("PRC_FILE_END_cls_feat_kensei", 39);
    SetPRCSwitch("PRC_FILE_END_cls_feat_knight", 197);
    SetPRCSwitch("PRC_FILE_END_cls_feat_kord", 3);
    SetPRCSwitch("PRC_FILE_END_cls_feat_kotmc", 247);
    SetPRCSwitch("PRC_FILE_END_cls_feat_lasher", 248);
    SetPRCSwitch("PRC_FILE_END_cls_feat_lgdr", 211);
    SetPRCSwitch("PRC_FILE_END_cls_feat_lich", 29);
    SetPRCSwitch("PRC_FILE_END_cls_feat_maestr", 10);
    SetPRCSwitch("PRC_FILE_END_cls_feat_magek", 141);
    SetPRCSwitch("PRC_FILE_END_cls_feat_manat", 247);
    SetPRCSwitch("PRC_FILE_END_cls_feat_marsh", 347);
    SetPRCSwitch("PRC_FILE_END_cls_feat_meph", 22);
    SetPRCSwitch("PRC_FILE_END_cls_feat_mharp", 160);
    SetPRCSwitch("PRC_FILE_END_cls_feat_minstr", 45);
    SetPRCSwitch("PRC_FILE_END_cls_feat_monk", 297);
    SetPRCSwitch("PRC_FILE_END_cls_feat_mos", 85);
    SetPRCSwitch("PRC_FILE_END_cls_feat_mystic", 111);
    SetPRCSwitch("PRC_FILE_END_cls_feat_nights", 66);
    SetPRCSwitch("PRC_FILE_END_cls_feat_ninja", 72);
    SetPRCSwitch("PRC_FILE_END_cls_feat_ninjca", 251);
    SetPRCSwitch("PRC_FILE_END_cls_feat_ocu", 630);
    SetPRCSwitch("PRC_FILE_END_cls_feat_ollam", 2);
    SetPRCSwitch("PRC_FILE_END_cls_feat_ootbi", 43);
    SetPRCSwitch("PRC_FILE_END_cls_feat_ooze", 43);
    SetPRCSwitch("PRC_FILE_END_cls_feat_orcus", 39);
    SetPRCSwitch("PRC_FILE_END_cls_feat_orcwar", 11);
    SetPRCSwitch("PRC_FILE_END_cls_feat_outs", 2004);
    SetPRCSwitch("PRC_FILE_END_cls_feat_pal", 390);
    SetPRCSwitch("PRC_FILE_END_cls_feat_palema", 83);
    SetPRCSwitch("PRC_FILE_END_cls_feat_parch", 21);
    SetPRCSwitch("PRC_FILE_END_cls_feat_pdk", 12);
    SetPRCSwitch("PRC_FILE_END_cls_feat_pnpsfr", 140);
    SetPRCSwitch("PRC_FILE_END_cls_feat_psion", 840);
    SetPRCSwitch("PRC_FILE_END_cls_feat_psych", 213);
    SetPRCSwitch("PRC_FILE_END_cls_feat_psywar", 548);
    SetPRCSwitch("PRC_FILE_END_cls_feat_rang", 303);
    SetPRCSwitch("PRC_FILE_END_cls_feat_rava", 208);
    SetPRCSwitch("PRC_FILE_END_cls_feat_redav", 143);
    SetPRCSwitch("PRC_FILE_END_cls_feat_redwiz", 195);
    SetPRCSwitch("PRC_FILE_END_cls_feat_rog", 265);
    SetPRCSwitch("PRC_FILE_END_cls_feat_rune", 22);
    SetPRCSwitch("PRC_FILE_END_cls_feat_runec", 33);
    SetPRCSwitch("PRC_FILE_END_cls_feat_sacfis", 176);
    SetPRCSwitch("PRC_FILE_END_cls_feat_samur", 551);
    SetPRCSwitch("PRC_FILE_END_cls_feat_savanta", 92);
    SetPRCSwitch("PRC_FILE_END_cls_feat_savantc", 92);
    SetPRCSwitch("PRC_FILE_END_cls_feat_savante", 92);
    SetPRCSwitch("PRC_FILE_END_cls_feat_savantf", 92);
    SetPRCSwitch("PRC_FILE_END_cls_feat_sbheir", 201);
    SetPRCSwitch("PRC_FILE_END_cls_feat_scout", 390);
    SetPRCSwitch("PRC_FILE_END_cls_feat_shadep", 109);
    SetPRCSwitch("PRC_FILE_END_cls_feat_shadow", 57);
    SetPRCSwitch("PRC_FILE_END_cls_feat_shdwinq", 19);
    SetPRCSwitch("PRC_FILE_END_cls_feat_shdwstl", 10);
    SetPRCSwitch("PRC_FILE_END_cls_feat_shiftr", 100);
    SetPRCSwitch("PRC_FILE_END_cls_feat_shou", 60);
    SetPRCSwitch("PRC_FILE_END_cls_feat_shugen", 446);
    SetPRCSwitch("PRC_FILE_END_cls_feat_sklcln", 6);
    SetPRCSwitch("PRC_FILE_END_cls_feat_sleat", 4);
    SetPRCSwitch("PRC_FILE_END_cls_feat_sncmnd", 5);
    SetPRCSwitch("PRC_FILE_END_cls_feat_sod", 64);
    SetPRCSwitch("PRC_FILE_END_cls_feat_sohei", 517);
    SetPRCSwitch("PRC_FILE_END_cls_feat_sol", 327);
    SetPRCSwitch("PRC_FILE_END_cls_feat_sorc", 2324);
    SetPRCSwitch("PRC_FILE_END_cls_feat_soulkn", 638);
    SetPRCSwitch("PRC_FILE_END_cls_feat_spellf", 14);
    SetPRCSwitch("PRC_FILE_END_cls_feat_spells", 475);
    SetPRCSwitch("PRC_FILE_END_cls_feat_storml", 105);
    SetPRCSwitch("PRC_FILE_END_cls_feat_suel", 434);
    SetPRCSwitch("PRC_FILE_END_cls_feat_swash", 449);
    SetPRCSwitch("PRC_FILE_END_cls_feat_swdsge", 161);
    SetPRCSwitch("PRC_FILE_END_cls_feat_tempst", 143);
    SetPRCSwitch("PRC_FILE_END_cls_feat_tempus", 84);
    SetPRCSwitch("PRC_FILE_END_cls_feat_tfshad", 103);
    SetPRCSwitch("PRC_FILE_END_cls_feat_thaykt", 116);
    SetPRCSwitch("PRC_FILE_END_cls_feat_thrall", 187);
    SetPRCSwitch("PRC_FILE_END_cls_feat_tnecro", 90);
    SetPRCSwitch("PRC_FILE_END_cls_feat_tog", 113);
    SetPRCSwitch("PRC_FILE_END_cls_feat_true", 306);
    SetPRCSwitch("PRC_FILE_END_cls_feat_urang", 420);
    SetPRCSwitch("PRC_FILE_END_cls_feat_vassal", 390);
    SetPRCSwitch("PRC_FILE_END_cls_feat_vigil", 162);
    SetPRCSwitch("PRC_FILE_END_cls_feat_virt", 124);
    SetPRCSwitch("PRC_FILE_END_cls_feat_warbld", 161);
    SetPRCSwitch("PRC_FILE_END_cls_feat_warchf", 112);
    SetPRCSwitch("PRC_FILE_END_cls_feat_wardark", 20);
    SetPRCSwitch("PRC_FILE_END_cls_feat_warmnd", 375);
    SetPRCSwitch("PRC_FILE_END_cls_feat_warpr", 69);
    SetPRCSwitch("PRC_FILE_END_cls_feat_wilder", 849);
    SetPRCSwitch("PRC_FILE_END_cls_feat_wiz", 679);
    SetPRCSwitch("PRC_FILE_END_cls_feat_wm", 177);
    SetPRCSwitch("PRC_FILE_END_cls_feat_wrmage", 1002);
    SetPRCSwitch("PRC_FILE_END_cls_feat_wrslng", 2);
    SetPRCSwitch("PRC_FILE_END_cls_feat_wwoc", 23);
    SetPRCSwitch("PRC_FILE_END_cls_feat_wwolf", 23);
    SetPRCSwitch("PRC_FILE_END_cls_move_crusdr", 3);
    SetPRCSwitch("PRC_FILE_END_cls_mvkn_crusdr", 59);
    SetPRCSwitch("PRC_FILE_END_cls_mvkn_swdsge", 59);
    SetPRCSwitch("PRC_FILE_END_cls_mvkn_warbld", 59);
    SetPRCSwitch("PRC_FILE_END_cls_pres_aber", 1);
    SetPRCSwitch("PRC_FILE_END_cls_pres_adst", 7);
    SetPRCSwitch("PRC_FILE_END_cls_pres_alag", 13);
    SetPRCSwitch("PRC_FILE_END_cls_pres_alienist", 7);
    SetPRCSwitch("PRC_FILE_END_cls_pres_ani", 1);
    SetPRCSwitch("PRC_FILE_END_cls_pres_antipl", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_aots", 2);
    SetPRCSwitch("PRC_FILE_END_cls_pres_arch", 12);
    SetPRCSwitch("PRC_FILE_END_cls_pres_archer", 16);
    SetPRCSwitch("PRC_FILE_END_cls_pres_archr", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_arctrk", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_asasin", 11);
    SetPRCSwitch("PRC_FILE_END_cls_pres_baal", 4);
    SetPRCSwitch("PRC_FILE_END_cls_pres_baeln", 16);
    SetPRCSwitch("PRC_FILE_END_cls_pres_barb", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_bard", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_beast", 1);
    SetPRCSwitch("PRC_FILE_END_cls_pres_bereft", 1);
    SetPRCSwitch("PRC_FILE_END_cls_pres_bfz", 8);
    SetPRCSwitch("PRC_FILE_END_cls_pres_blades", 23);
    SetPRCSwitch("PRC_FILE_END_cls_pres_blarch", 7);
    SetPRCSwitch("PRC_FILE_END_cls_pres_blkgrd", 11);
    SetPRCSwitch("PRC_FILE_END_cls_pres_blmagus", 4);
    SetPRCSwitch("PRC_FILE_END_cls_pres_bltl", 4);
    SetPRCSwitch("PRC_FILE_END_cls_pres_bonded", 3);
    SetPRCSwitch("PRC_FILE_END_cls_pres_brage", 14);
    SetPRCSwitch("PRC_FILE_END_cls_pres_brawl", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_brimst", 3);
    SetPRCSwitch("PRC_FILE_END_cls_pres_cbtmed", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_cereb", 4);
    SetPRCSwitch("PRC_FILE_END_cls_pres_chaban", 2);
    SetPRCSwitch("PRC_FILE_END_cls_pres_cler", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_cntmp", 2);
    SetPRCSwitch("PRC_FILE_END_cls_pres_coc", 23);
    SetPRCSwitch("PRC_FILE_END_cls_pres_con", 1);
    SetPRCSwitch("PRC_FILE_END_cls_pres_corup", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_crusdr", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_cwsm", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_diabol", 9);
    SetPRCSwitch("PRC_FILE_END_cls_pres_dirge", 4);
    SetPRCSwitch("PRC_FILE_END_cls_pres_disp", 4);
    SetPRCSwitch("PRC_FILE_END_cls_pres_divcha", 41);
    SetPRCSwitch("PRC_FILE_END_cls_pres_divsav", 2);
    SetPRCSwitch("PRC_FILE_END_cls_pres_doa", 10);
    SetPRCSwitch("PRC_FILE_END_cls_pres_dradis", 9);
    SetPRCSwitch("PRC_FILE_END_cls_pres_drag", 1);
    SetPRCSwitch("PRC_FILE_END_cls_pres_drnkn", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_drowj", 10);
    SetPRCSwitch("PRC_FILE_END_cls_pres_dru", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_dslyr", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_duel", 9);
    SetPRCSwitch("PRC_FILE_END_cls_pres_duskbl", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_dwdef", 10);
    SetPRCSwitch("PRC_FILE_END_cls_pres_eldkni", 2);
    SetPRCSwitch("PRC_FILE_END_cls_pres_ele", 1);
    SetPRCSwitch("PRC_FILE_END_cls_pres_enlfis", 7);
    SetPRCSwitch("PRC_FILE_END_cls_pres_eog", 9);
    SetPRCSwitch("PRC_FILE_END_cls_pres_favsol", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_fey", 1);
    SetPRCSwitch("PRC_FILE_END_cls_pres_fh", 43);
    SetPRCSwitch("PRC_FILE_END_cls_pres_fight", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_fistra", 7);
    SetPRCSwitch("PRC_FILE_END_cls_pres_fom", 9);
    SetPRCSwitch("PRC_FILE_END_cls_pres_foz", 4);
    SetPRCSwitch("PRC_FILE_END_cls_pres_frebzk", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_gfkill", 7);
    SetPRCSwitch("PRC_FILE_END_cls_pres_giant", 1);
    SetPRCSwitch("PRC_FILE_END_cls_pres_harper", 12);
    SetPRCSwitch("PRC_FILE_END_cls_pres_hath", 6);
    SetPRCSwitch("PRC_FILE_END_cls_pres_havocm", 3);
    SetPRCSwitch("PRC_FILE_END_cls_pres_heal", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_healer", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_heartw", 8);
    SetPRCSwitch("PRC_FILE_END_cls_pres_hexbl", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_hextor", 7);
    SetPRCSwitch("PRC_FILE_END_cls_pres_hiero", 8);
    SetPRCSwitch("PRC_FILE_END_cls_pres_hmage", 7);
    SetPRCSwitch("PRC_FILE_END_cls_pres_hnshn", 3);
    SetPRCSwitch("PRC_FILE_END_cls_pres_hosp", 3);
    SetPRCSwitch("PRC_FILE_END_cls_pres_hum", 1);
    SetPRCSwitch("PRC_FILE_END_cls_pres_iaij", 4);
    SetPRCSwitch("PRC_FILE_END_cls_pres_inidra", 7);
    SetPRCSwitch("PRC_FILE_END_cls_pres_irnmnd", 6);
    SetPRCSwitch("PRC_FILE_END_cls_pres_kchal", 3);
    SetPRCSwitch("PRC_FILE_END_cls_pres_kensei", 35);
    SetPRCSwitch("PRC_FILE_END_cls_pres_knight", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_kord", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_kotmc", 3);
    SetPRCSwitch("PRC_FILE_END_cls_pres_lasher", 4);
    SetPRCSwitch("PRC_FILE_END_cls_pres_lgdr", 44);
    SetPRCSwitch("PRC_FILE_END_cls_pres_lich", 4);
    SetPRCSwitch("PRC_FILE_END_cls_pres_maestr", 13);
    SetPRCSwitch("PRC_FILE_END_cls_pres_magbst", 1);
    SetPRCSwitch("PRC_FILE_END_cls_pres_magek", 6);
    SetPRCSwitch("PRC_FILE_END_cls_pres_manat", 34);
    SetPRCSwitch("PRC_FILE_END_cls_pres_marsh", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_meph", 2);
    SetPRCSwitch("PRC_FILE_END_cls_pres_mharp", 8);
    SetPRCSwitch("PRC_FILE_END_cls_pres_mharpd", 8);
    SetPRCSwitch("PRC_FILE_END_cls_pres_minstr", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_mon", 1);
    SetPRCSwitch("PRC_FILE_END_cls_pres_monk", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_mos", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_mystic", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_nights", 6);
    SetPRCSwitch("PRC_FILE_END_cls_pres_ninja", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_ninjca", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_ocular", 2);
    SetPRCSwitch("PRC_FILE_END_cls_pres_ollam", 9);
    SetPRCSwitch("PRC_FILE_END_cls_pres_ootbi", 7);
    SetPRCSwitch("PRC_FILE_END_cls_pres_ooze", 3);
    SetPRCSwitch("PRC_FILE_END_cls_pres_orcus", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_orcwar", 13);
    SetPRCSwitch("PRC_FILE_END_cls_pres_out", 1);
    SetPRCSwitch("PRC_FILE_END_cls_pres_pal", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_palema", 1);
    SetPRCSwitch("PRC_FILE_END_cls_pres_parch", 6);
    SetPRCSwitch("PRC_FILE_END_cls_pres_pdk", 6);
    SetPRCSwitch("PRC_FILE_END_cls_pres_pnpasasin", 2);
    SetPRCSwitch("PRC_FILE_END_cls_pres_pnpblkgrd", 3);
    SetPRCSwitch("PRC_FILE_END_cls_pres_pnpsfr", 4);
    SetPRCSwitch("PRC_FILE_END_cls_pres_psion", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_psych", 4);
    SetPRCSwitch("PRC_FILE_END_cls_pres_psywar", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_rang", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_rava", 7);
    SetPRCSwitch("PRC_FILE_END_cls_pres_redav", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_redwiz", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_rog", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_rune", 9);
    SetPRCSwitch("PRC_FILE_END_cls_pres_runec", 4);
    SetPRCSwitch("PRC_FILE_END_cls_pres_sacfis", 7);
    SetPRCSwitch("PRC_FILE_END_cls_pres_samur", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_savant", 2);
    SetPRCSwitch("PRC_FILE_END_cls_pres_sbheir", 4);
    SetPRCSwitch("PRC_FILE_END_cls_pres_scout", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_shadep", 11);
    SetPRCSwitch("PRC_FILE_END_cls_pres_shadow", 11);
    SetPRCSwitch("PRC_FILE_END_cls_pres_shape", 1);
    SetPRCSwitch("PRC_FILE_END_cls_pres_shdwinq", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_shdwstl", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_shiftr", 17);
    SetPRCSwitch("PRC_FILE_END_cls_pres_shou", 6);
    SetPRCSwitch("PRC_FILE_END_cls_pres_shugen", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_sklcln", 3);
    SetPRCSwitch("PRC_FILE_END_cls_pres_sleat", 6);
    SetPRCSwitch("PRC_FILE_END_cls_pres_sncmnd", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_sod", 42);
    SetPRCSwitch("PRC_FILE_END_cls_pres_sohei", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_sol", 3);
    SetPRCSwitch("PRC_FILE_END_cls_pres_sorc", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_soulkn", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_spellf", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_spells", 8);
    SetPRCSwitch("PRC_FILE_END_cls_pres_storml", 4);
    SetPRCSwitch("PRC_FILE_END_cls_pres_suel", 8);
    SetPRCSwitch("PRC_FILE_END_cls_pres_swash", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_swdsge", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_tempst", 38);
    SetPRCSwitch("PRC_FILE_END_cls_pres_tempus", 39);
    SetPRCSwitch("PRC_FILE_END_cls_pres_tfshad", 9);
    SetPRCSwitch("PRC_FILE_END_cls_pres_thaykt", 7);
    SetPRCSwitch("PRC_FILE_END_cls_pres_thrall", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_tnecro", 4);
    SetPRCSwitch("PRC_FILE_END_cls_pres_tog", 6);
    SetPRCSwitch("PRC_FILE_END_cls_pres_tog_a", 6);
    SetPRCSwitch("PRC_FILE_END_cls_pres_tog_d", 6);
    SetPRCSwitch("PRC_FILE_END_cls_pres_true", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_undead", 1);
    SetPRCSwitch("PRC_FILE_END_cls_pres_urang", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_vassal", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_vermin", 1);
    SetPRCSwitch("PRC_FILE_END_cls_pres_vigil", 6);
    SetPRCSwitch("PRC_FILE_END_cls_pres_virt", 3);
    SetPRCSwitch("PRC_FILE_END_cls_pres_warbld", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_warchf", 2);
    SetPRCSwitch("PRC_FILE_END_cls_pres_wardark", 3);
    SetPRCSwitch("PRC_FILE_END_cls_pres_warmnd", 3);
    SetPRCSwitch("PRC_FILE_END_cls_pres_warpr", 8);
    SetPRCSwitch("PRC_FILE_END_cls_pres_wilder", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_wiz", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_wm", 37);
    SetPRCSwitch("PRC_FILE_END_cls_pres_wrmage", 0);
    SetPRCSwitch("PRC_FILE_END_cls_pres_wrslng", 19);
    SetPRCSwitch("PRC_FILE_END_cls_pres_wwoc", 5);
    SetPRCSwitch("PRC_FILE_END_cls_pres_wwolf", 3);
    SetPRCSwitch("PRC_FILE_END_cls_psbk_foz", 39);
    SetPRCSwitch("PRC_FILE_END_cls_psbk_psion", 39);
    SetPRCSwitch("PRC_FILE_END_cls_psbk_psywar", 59);
    SetPRCSwitch("PRC_FILE_END_cls_psbk_warmnd", 39);
    SetPRCSwitch("PRC_FILE_END_cls_psbk_wilder", 59);
    SetPRCSwitch("PRC_FILE_END_cls_psipw_foz", 92);
    SetPRCSwitch("PRC_FILE_END_cls_psipw_psion", 253);
    SetPRCSwitch("PRC_FILE_END_cls_psipw_psywar", 97);
    SetPRCSwitch("PRC_FILE_END_cls_psipw_warmnd", 92);
    SetPRCSwitch("PRC_FILE_END_cls_psipw_wilder", 164);
    SetPRCSwitch("PRC_FILE_END_cls_savthr_barb", 60);
    SetPRCSwitch("PRC_FILE_END_cls_savthr_bard", 61);
    SetPRCSwitch("PRC_FILE_END_cls_savthr_cler", 60);
    SetPRCSwitch("PRC_FILE_END_cls_savthr_cons", 60);
    SetPRCSwitch("PRC_FILE_END_cls_savthr_dru", 60);
    SetPRCSwitch("PRC_FILE_END_cls_savthr_fight", 60);
    SetPRCSwitch("PRC_FILE_END_cls_savthr_lich", 59);
    SetPRCSwitch("PRC_FILE_END_cls_savthr_monk", 60);
    SetPRCSwitch("PRC_FILE_END_cls_savthr_pal", 60);
    SetPRCSwitch("PRC_FILE_END_cls_savthr_rang", 60);
    SetPRCSwitch("PRC_FILE_END_cls_savthr_rog", 60);
    SetPRCSwitch("PRC_FILE_END_cls_savthr_sorc", 60);
    SetPRCSwitch("PRC_FILE_END_cls_savthr_wild", 60);
    SetPRCSwitch("PRC_FILE_END_cls_savthr_wiz", 60);
    SetPRCSwitch("PRC_FILE_END_cls_skill_adst", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_alag", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_alienist", 24);
    SetPRCSwitch("PRC_FILE_END_cls_skill_antipl", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_aots", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_arch", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_archer", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_arclb", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_arctrk", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_asasin", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_baal", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_barb", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_bard", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_bereft", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_bfz", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_blades", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_blarch", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_blkgrd", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_blmagu", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_bltl", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_bonded", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_brage", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_brawl", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_brimst", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_cbtmed", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_cereb", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_chaban", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_cler", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_cntmp", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_coc", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_corup", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_crea", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_crusdr", 29);
    SetPRCSwitch("PRC_FILE_END_cls_skill_diabol", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_dirge", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_disp", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_divcha", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_doa", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_dradis", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_drkwar", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_drnkn", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_drowj", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_drslyr", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_dru", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_duel", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_duskbl", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_dwdef", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_eldkni", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_enlfis", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_eog", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_favsol", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_fh", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_fight", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_fistra", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_fom", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_foz", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_frebzk", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_gfkill", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_harper", 23);
    SetPRCSwitch("PRC_FILE_END_cls_skill_hath", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_havocm", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_healer", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_heartw", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_hexbl", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_hextor", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_hiero", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_hmage", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_hnshn", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_hosp", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_iaij", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_inidra", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_irnmnd", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_kchal", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_kensei", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_knight", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_kord", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_kotmc", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_lasher", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_lgdr", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_maestr", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_magek", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_manat", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_marsh", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_meph", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_mharp", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_minstr", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_monk", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_mos", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_mystic", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_nights", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_ninja", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_ninjca", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_ocular", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_ollam", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_ootbi", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_ooze", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_orcus", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_orcwar", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_pal", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_palema", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_parch", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_pdk", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_psion", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_psych", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_psywar", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_rang", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_rava", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_redav", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_redwiz", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_rog", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_rune", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_runec", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_sacfis", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_samur", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_savant", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_sbheir", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_scout", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_shadep", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_shadow", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_shdwin", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_shdwst", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_shiftr", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_shou", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_shugen", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_sklcln", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_sleat", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_sncmnd", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_sod", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_sohei", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_sol", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_sorc", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_soulkn", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_spellf", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_spells", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_storml", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_suel", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_swash", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_swdsge", 29);
    SetPRCSwitch("PRC_FILE_END_cls_skill_tempst", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_tempus", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_tfshad", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_thaykt", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_thrall", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_tnecro", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_tog", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_true", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_vassal", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_vigil", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_virt", 28);
    SetPRCSwitch("PRC_FILE_END_cls_skill_warbld", 29);
    SetPRCSwitch("PRC_FILE_END_cls_skill_warchf", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_warmnd", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_warpr", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_waygde", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_wilder", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_wiz", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_wm", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_wrmage", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_wrslng", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_wwoc", 27);
    SetPRCSwitch("PRC_FILE_END_cls_skill_wwolf", 27);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_antipl", 39);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_asasin", 39);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_bard", 59);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_blkgrd", 39);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_duskbl", 39);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_favsol", 59);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_healer", 59);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_hexbl", 39);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_kchal", 39);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_kotmc", 39);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_ocu", 29);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_sod", 39);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_sohei", 39);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_sol", 39);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_sorc", 59);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_suel", 29);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_tfshad", 39);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_vassal", 39);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_vigil", 39);
    SetPRCSwitch("PRC_FILE_END_cls_spbk_wrmage", 59);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_antipl", 26);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_asasin", 45);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_bard", 143);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_blkgrd", 35);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_duskbl", 62);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_favsol", 244);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_healer", 54);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_hexbl", 45);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_kchal", 34);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_kotmc", 19);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_ocu", 155);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_sod", 22);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_sohei", 41);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_sol", 30);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_sorc", 356);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_suel", 98);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_tfshad", 27);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_vassal", 22);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_vigil", 17);
    SetPRCSwitch("PRC_FILE_END_cls_spcr_wrmage", 62);
    SetPRCSwitch("PRC_FILE_END_cls_spell_antipl", 89);
    SetPRCSwitch("PRC_FILE_END_cls_spell_asasin", 104);
    SetPRCSwitch("PRC_FILE_END_cls_spell_bard", 583);
    SetPRCSwitch("PRC_FILE_END_cls_spell_blkgrd", 139);
    SetPRCSwitch("PRC_FILE_END_cls_spell_duskbl", 326);
    SetPRCSwitch("PRC_FILE_END_cls_spell_favsol", 1273);
    SetPRCSwitch("PRC_FILE_END_cls_spell_healer", 234);
    SetPRCSwitch("PRC_FILE_END_cls_spell_hexbl", 164);
    SetPRCSwitch("PRC_FILE_END_cls_spell_kchal", 117);
    SetPRCSwitch("PRC_FILE_END_cls_spell_kotmc", 55);
    SetPRCSwitch("PRC_FILE_END_cls_spell_ocu", 668);
    SetPRCSwitch("PRC_FILE_END_cls_spell_SOD", 58);
    SetPRCSwitch("PRC_FILE_END_cls_spell_sohei", 123);
    SetPRCSwitch("PRC_FILE_END_cls_spell_sol", 94);
    SetPRCSwitch("PRC_FILE_END_cls_spell_sorc", 1957);
    SetPRCSwitch("PRC_FILE_END_cls_spell_suel", 470);
    SetPRCSwitch("PRC_FILE_END_cls_spell_tfshad", 62);
    SetPRCSwitch("PRC_FILE_END_cls_spell_vassal", 72);
    SetPRCSwitch("PRC_FILE_END_cls_spell_vigil", 52);
    SetPRCSwitch("PRC_FILE_END_cls_spell_wrmage", 313);
    SetPRCSwitch("PRC_FILE_END_cls_spgn_bard", 60);
    SetPRCSwitch("PRC_FILE_END_cls_spgn_cler", 60);
    SetPRCSwitch("PRC_FILE_END_cls_spgn_dru", 60);
    SetPRCSwitch("PRC_FILE_END_cls_spgn_pal", 60);
    SetPRCSwitch("PRC_FILE_END_cls_spgn_rang", 60);
    SetPRCSwitch("PRC_FILE_END_cls_spgn_sorc", 60);
    SetPRCSwitch("PRC_FILE_END_cls_spgn_wiz", 60);
    SetPRCSwitch("PRC_FILE_END_cls_spkn_asasin", 39);
    SetPRCSwitch("PRC_FILE_END_cls_spkn_bard", 60);
    SetPRCSwitch("PRC_FILE_END_cls_spkn_duskbl", 39);
    SetPRCSwitch("PRC_FILE_END_cls_spkn_favsol", 47);
    SetPRCSwitch("PRC_FILE_END_cls_spkn_hexbl", 39);
    SetPRCSwitch("PRC_FILE_END_cls_spkn_sorc", 60);
    SetPRCSwitch("PRC_FILE_END_cls_spkn_suel", 39);
    SetPRCSwitch("PRC_FILE_END_cls_spkn_wrmage", 53);
    SetPRCSwitch("PRC_FILE_END_cls_true_known", 39);
    SetPRCSwitch("PRC_FILE_END_cls_true_maxlvl", 39);
    SetPRCSwitch("PRC_FILE_END_cls_true_utter", 166);
    SetPRCSwitch("PRC_FILE_END_colours", 175);
    SetPRCSwitch("PRC_FILE_END_combatmodes", 4);
    SetPRCSwitch("PRC_FILE_END_craft_armour", 63);
    SetPRCSwitch("PRC_FILE_END_craft_ring", 41);
    SetPRCSwitch("PRC_FILE_END_craft_weapon", 42);
    SetPRCSwitch("PRC_FILE_END_craft_wondrous", 115);
    SetPRCSwitch("PRC_FILE_END_creaturesize", 5);
    SetPRCSwitch("PRC_FILE_END_crtemplates", 10);
    SetPRCSwitch("PRC_FILE_END_damagehitvisual", 11);
    SetPRCSwitch("PRC_FILE_END_des_crft_amat", 1);
    SetPRCSwitch("PRC_FILE_END_des_crft_aparts", 18);
    SetPRCSwitch("PRC_FILE_END_des_crft_armor", 41);
    SetPRCSwitch("PRC_FILE_END_des_crft_bmat", 13);
    SetPRCSwitch("PRC_FILE_END_des_crft_drop", 476);
    SetPRCSwitch("PRC_FILE_END_des_crft_mat", 2);
    SetPRCSwitch("PRC_FILE_END_des_crft_poison", 100);
    SetPRCSwitch("PRC_FILE_END_des_crft_props", 27);
    SetPRCSwitch("PRC_FILE_END_des_crft_scroll", 3661);
    SetPRCSwitch("PRC_FILE_END_des_crft_spells", 17300);
    SetPRCSwitch("PRC_FILE_END_des_crft_weapon", 29);
    SetPRCSwitch("PRC_FILE_END_des_feat2item", 1000);
    SetPRCSwitch("PRC_FILE_END_des_matcomp", 510);
    SetPRCSwitch("PRC_FILE_END_des_mechupgrades", 6);
    SetPRCSwitch("PRC_FILE_END_des_pcstart_arm", 1);
    SetPRCSwitch("PRC_FILE_END_des_pcstart_weap", 1);
    SetPRCSwitch("PRC_FILE_END_des_prayer", 10);
    SetPRCSwitch("PRC_FILE_END_disease", 62);
    SetPRCSwitch("PRC_FILE_END_dmgxp", 59);
    SetPRCSwitch("PRC_FILE_END_domains", 58);
    SetPRCSwitch("PRC_FILE_END_ECL", 254);
    SetPRCSwitch("PRC_FILE_END_encumbrance", 100);
    SetPRCSwitch("PRC_FILE_END_epicattacks", 61);
    SetPRCSwitch("PRC_FILE_END_epicsaves", 60);
    SetPRCSwitch("PRC_FILE_END_epicspells", 70);
    SetPRCSwitch("PRC_FILE_END_epicspellseeds", 27);
    SetPRCSwitch("PRC_FILE_END_excitedduration", 2);
    SetPRCSwitch("PRC_FILE_END_exptable", 41);
    SetPRCSwitch("PRC_FILE_END_feat", 23600);
    SetPRCSwitch("PRC_FILE_END_fileends", 20);
    SetPRCSwitch("PRC_FILE_END_gender", 4);
    SetPRCSwitch("PRC_FILE_END_hen_companion", 8);
    SetPRCSwitch("PRC_FILE_END_hen_familiar", 11);
    SetPRCSwitch("PRC_FILE_END_iprp_abilities", 5);
    SetPRCSwitch("PRC_FILE_END_iprp_acmodtype", 4);
    SetPRCSwitch("PRC_FILE_END_iprp_aligngrp", 5);
    SetPRCSwitch("PRC_FILE_END_iprp_alignment", 8);
    SetPRCSwitch("PRC_FILE_END_iprp_ammocost", 15);
    SetPRCSwitch("PRC_FILE_END_iprp_ammotype", 2);
    SetPRCSwitch("PRC_FILE_END_iprp_amount", 4);
    SetPRCSwitch("PRC_FILE_END_iprp_aoe", 5);
    SetPRCSwitch("PRC_FILE_END_iprp_arcspell", 19);
    SetPRCSwitch("PRC_FILE_END_iprp_bladecost", 5);
    SetPRCSwitch("PRC_FILE_END_iprp_bonuscost", 12);
    SetPRCSwitch("PRC_FILE_END_iprp_casterlvl", 60);
    SetPRCSwitch("PRC_FILE_END_iprp_chargecost", 13);
    SetPRCSwitch("PRC_FILE_END_iprp_color", 6);
    SetPRCSwitch("PRC_FILE_END_iprp_combatdam", 2);
    SetPRCSwitch("PRC_FILE_END_iprp_costtable", 36);
    SetPRCSwitch("PRC_FILE_END_iprp_damagecost", 70);
    SetPRCSwitch("PRC_FILE_END_iprp_damagetype", 13);
    SetPRCSwitch("PRC_FILE_END_iprp_damvulcost", 7);
    SetPRCSwitch("PRC_FILE_END_iprp_decvalue1", 9);
    SetPRCSwitch("PRC_FILE_END_iprp_decvalue2", 9);
    SetPRCSwitch("PRC_FILE_END_iprp_feats", 390);  //17300); //overridden to prevent TMI
    SetPRCSwitch("PRC_FILE_END_iprp_immuncost", 7);
    SetPRCSwitch("PRC_FILE_END_iprp_immunity", 9);
    SetPRCSwitch("PRC_FILE_END_iprp_incvalue1", 9);
    SetPRCSwitch("PRC_FILE_END_iprp_incvalue2", 9);
    SetPRCSwitch("PRC_FILE_END_iprp_kitcost", 50);
    SetPRCSwitch("PRC_FILE_END_iprp_lightcost", 4);
    SetPRCSwitch("PRC_FILE_END_iprp_maxpp", 8);
    SetPRCSwitch("PRC_FILE_END_iprp_meleecost", 20);
    SetPRCSwitch("PRC_FILE_END_iprp_metamagic", 6);
    SetPRCSwitch("PRC_FILE_END_iprp_monstcost", 58);
    SetPRCSwitch("PRC_FILE_END_iprp_monsterdam", 14);
    SetPRCSwitch("PRC_FILE_END_iprp_monsterhit", 12);
    SetPRCSwitch("PRC_FILE_END_iprp_neg10cost", 11);
    SetPRCSwitch("PRC_FILE_END_iprp_neg5cost", 10);
    SetPRCSwitch("PRC_FILE_END_iprp_onhit", 29);
    SetPRCSwitch("PRC_FILE_END_iprp_onhitcost", 70);
    SetPRCSwitch("PRC_FILE_END_iprp_onhitdur", 27);
    SetPRCSwitch("PRC_FILE_END_iprp_onhitspell", 209);
    SetPRCSwitch("PRC_FILE_END_iprp_paramtable", 11);
    SetPRCSwitch("PRC_FILE_END_iprp_poison", 5);
    SetPRCSwitch("PRC_FILE_END_iprp_protection", 19);
    SetPRCSwitch("PRC_FILE_END_iprp_redcost", 5);
    SetPRCSwitch("PRC_FILE_END_iprp_resistcost", 28);
    SetPRCSwitch("PRC_FILE_END_iprp_saveelement", 21);
    SetPRCSwitch("PRC_FILE_END_iprp_savingthrow", 3);
    SetPRCSwitch("PRC_FILE_END_iprp_skillcost", 50);
    SetPRCSwitch("PRC_FILE_END_iprp_soakcost", 50);
    SetPRCSwitch("PRC_FILE_END_iprp_speed_dec", 9);
    SetPRCSwitch("PRC_FILE_END_iprp_speed_enh", 9);
    SetPRCSwitch("PRC_FILE_END_iprp_spellcost", 243);
    SetPRCSwitch("PRC_FILE_END_iprp_spellcstr", 42);
    SetPRCSwitch("PRC_FILE_END_iprp_spelllvcost", 9);
    SetPRCSwitch("PRC_FILE_END_iprp_spelllvlimm", 9);
    SetPRCSwitch("PRC_FILE_END_iprp_spells", 539); //1336); //overridden to prevent TMI
    SetPRCSwitch("PRC_FILE_END_iprp_spellshl", 7);
    SetPRCSwitch("PRC_FILE_END_iprp_srcost", 61);
    SetPRCSwitch("PRC_FILE_END_iprp_storedpp", 16);
    SetPRCSwitch("PRC_FILE_END_iprp_trapcost", 11);
    SetPRCSwitch("PRC_FILE_END_iprp_traps", 4);
    SetPRCSwitch("PRC_FILE_END_iprp_trapsize", 3);
    SetPRCSwitch("PRC_FILE_END_iprp_visualfx", 7);
    SetPRCSwitch("PRC_FILE_END_iprp_walk", 1);
    SetPRCSwitch("PRC_FILE_END_iprp_weightcost", 6);
    SetPRCSwitch("PRC_FILE_END_iprp_weightinc", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_adverobe", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ammyreac", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ammyrecd", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ammyreel", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ammyrefr", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_amularvr", 12);
    SetPRCSwitch("PRC_FILE_END_ireq_amulharp", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_amullich", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_amulnat1", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_amulnat2", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_amulnat3", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_amulnat4", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_amulnat5", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_amulnat6", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_amulnat7", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_amulturn", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_amywill1", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_amywill2", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_amywill3", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_amywill4", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_amywill5", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_amywill6", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_amywill7", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_arrow001", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_arrow002", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_arrow003", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_arrow004", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_arrow005", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_baghold0", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bandmai1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bandmai2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bandmai3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bandmai4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bandmai5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bandmai6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bandmai7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bastard1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bastard2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bastard3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bastard4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bastard5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bastard6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bastard7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_battlea1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_battlea2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_battlea3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_battlea4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_battlea5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_battlea6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_battlea7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_beltagi1", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_beltagi2", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_beltagi3", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_beltagi4", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_beltagi5", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_beltagi6", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_beltagi7", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_beltgiac", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_beltgiaf", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_beltgiah", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_beltgiar", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_beltgias", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_beltlion", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_beltmonk", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_beltpmtk", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_beltpmtm", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_beltpmts", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_beltpmwk", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_beltpmwm", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_beltpmws", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_bolt0001", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bolt0002", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bolt0003", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bolt0004", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bolt0005", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bootelvn", 10);
    SetPRCSwitch("PRC_FILE_END_ireq_boothar1", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_boothar2", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_boothar3", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bootref1", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bootref2", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bootref3", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bootref4", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bootref5", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bootref6", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bootref7", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bootspee", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bootstr1", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bootstr2", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bootstr3", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bootstr4", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bootstr5", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bootstr6", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bootstr7", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bootsun1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bootsun2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bootsun3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bootsun4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bootsun5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bootwint", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bowlwatr", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bracarch", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bracarm0", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_bracarm1", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_bracarm2", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_bracarm3", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_bracarm4", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_bracarm5", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_bracarm6", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_bracarm7", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_bracarm8", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_bracarm9", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_bracblnd", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_brazfire", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_breastp1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_breastp2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_breastp3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_breastp4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_breastp5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_breastp6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_breastp7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_brooshld", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_bullet01", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bullet02", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bullet03", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bullet04", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_bullet05", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_capefire", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_capewint", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_censair", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_chainma1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_chainma2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_chainma3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_chainma4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_chainma5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_chainma6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_chainma7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_chainsh1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_chainsh2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_chainsh3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_chainsh4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_chainsh5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_chainsh6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_chainsh7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_challath", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_chimopen", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_circblag", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_circblal", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clkfort1", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clkfort2", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clkfort3", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clkfort4", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clkfort5", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clkprot1", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clkprot2", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clkprot3", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clkprot4", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clkprot5", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clkprot6", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clkprot7", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_cloakmov", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clokarac", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_clokbat1", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_clokblfl", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clokcha1", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clokcha2", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clokcha3", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clokcha4", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clokcha5", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clokcha6", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clokcha7", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clokdisp", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_clokelvn", 11);
    SetPRCSwitch("PRC_FILE_END_ireq_clokres1", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_clokres2", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_clokres3", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_clokres4", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_clokres5", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_clongbo1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_clongbo2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_clongbo3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_clongbo4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_clongbo5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_clongbo6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_clongbo7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_club0001", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_club0002", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_club0003", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_club0004", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_club0005", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_club0006", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_club0007", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_cowlward", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_cshortb1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_cshortb2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_cshortb3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_cshortb4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_cshortb5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_cshortb6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_cshortb7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dagger01", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dagger02", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dagger03", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dagger04", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dagger05", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dagger06", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dagger07", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dart0001", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dart0002", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dart0003", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dart0004", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dart0005", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dart0006", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dart0007", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_diremac1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_diremac2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_diremac3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_diremac4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_diremac5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_diremac6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_diremac7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_doublea1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_doublea2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_doublea3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_doublea4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_doublea5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_doublea6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_doublea7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dustappr", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_dustdisa", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_dwarven1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dwarven2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dwarven3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dwarven4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dwarven5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dwarven6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_dwarven7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_elixhoru", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_eyeschrm", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_eyesdoom", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_eyeseagl", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_eyespetr", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_fullpla1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_fullpla2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_fullpla3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_fullpla4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_fullpla5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_fullpla6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_fullpla7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_fulpla5a", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_fulpla6a", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_gargboot", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_gaunfury", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_gaunogre", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_gaunogrl", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_gembrite", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_gemsee", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovdex0", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovdex1", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovdex2", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovdex3", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovdex4", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovdex5", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovdex6", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovdex7", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovdex8", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovdex9", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovehf1", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovehf2", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovehf3", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovehf4", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovehf5", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovehf6", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovehf7", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_gloveld1", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_gloveld2", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_gloveld3", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_gloveld4", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_gloveld5", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_gloveld6", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_gloveld7", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_gloveyr1", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_gloveyr2", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_gloveyr3", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_gloveyr4", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_gloveyr5", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_gloveyr6", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_gloveyr7", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_glovligh", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_goggmsee", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_goggnite", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_adam", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_adam_55", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_adam_60", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_adam_65", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_adam_70", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_adam_75", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_adam_80", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_clay", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_clay_12", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_clay_17", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_clay_22", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_clay_27", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_clay_32", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_fles", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_fles_10", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_fles_15", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_fles_20", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_fles_25", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_iron", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_iron_19", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_iron_24", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_iron_29", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_iron_34", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_iron_39", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_iron_44", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_iron_49", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_iron_54", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_mith", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_mith_37", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_mith_42", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_mith_47", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_mith_52", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_mith_57", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_mith_62", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_mith_67", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_mith_72", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_ston", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_ston_15", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_ston_20", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_ston_25", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_ston_30", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_ston_35", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_gol_ston_40", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_greatax1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_greatax2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_greatax3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_greatax4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_greatax5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_greatax6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_greatax7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_greatsw1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_greatsw2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_greatsw3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_greatsw4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_greatsw5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_greatsw6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_greatsw7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_halberd1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_halberd2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_halberd3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_halberd4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_halberd5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_halberd6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_halberd7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_halfpla1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_halfpla2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_halfpla3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_halfpla4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_halfpla5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_halfpla6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_halfpla7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_handaxe1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_handaxe2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_handaxe3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_handaxe4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_handaxe5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_handaxe6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_handaxe7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_harpchrm", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_harpdove", 6);
    SetPRCSwitch("PRC_FILE_END_ireq_harpjant", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_hartbeas", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_hbndbeho", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_hbndbind", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_hbndint2", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_hbndint4", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_hbndint6", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_heavycr1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_heavycr2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_heavycr3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_heavycr4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_heavycr5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_heavycr6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_heavycr7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_heavyfl1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_heavyfl2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_heavyfl3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_heavyfl4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_heavyfl5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_heavyfl6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_heavyfl7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_helmbril", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_helmdark", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_hidearm1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_hidearm2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_hidearm3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_hidearm4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_hidearm5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_hidearm6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_hidearm7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_hornblst", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_horngdev", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_instanst", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_instcana", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_instclil", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_instdoss", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_instfoch", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_instmacf", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_instolam", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_instwind", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_kama0001", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_kama0002", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_kama0003", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_kama0004", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_kama0005", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_kama0006", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_kama0007", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_katana01", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_katana02", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_katana03", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_katana04", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_katana05", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_katana06", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_katana07", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_kukri001", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_kukri002", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_kukri003", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_kukri004", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_kukri005", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_kukri006", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_kukri007", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lantreve", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_largesh1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_largesh2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_largesh3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_largesh4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_largesh5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_largesh6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_largesh7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_leather1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_leather2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_leather3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_leather4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_leather5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_leather6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_leather7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lensdete", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_lightcr1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightcr2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightcr3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightcr4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightcr5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightcr6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightcr7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightfl1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightfl2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightfl3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightfl4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightfl5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightfl6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightfl7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightha1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightha2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightha3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightha4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightha5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightha6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_lightha7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_longbow1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_longbow2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_longbow3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_longbow4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_longbow5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_longbow6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_longbow7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_longswo1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_longswo2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_longswo3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_longswo4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_longswo5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_longswo6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_longswo7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_mace0001", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_mace0002", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_mace0003", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_mace0004", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_mace0005", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_mace0006", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_mace0007", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_mantsrep", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_mantsrgr", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_masadvrb", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_maskskul", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_morning1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_morning2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_morning3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_morning4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_morning5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_morning6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_morning7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_neckfblg", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_neckfbll", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_neckpray", 6);
    SetPRCSwitch("PRC_FILE_END_ireq_neckulul", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_paddeda1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_paddeda2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_paddeda3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_paddeda4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_paddeda5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_paddeda6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_paddeda7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_periwis0", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_periwis1", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_periwis2", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_periwis3", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_periwis4", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_periwis5", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_periwis6", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_periwis7", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_periwis8", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_periwis9", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_poison000", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison001", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison003", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison004", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison005", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison006", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison007", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison008", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison009", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison010", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison011", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison012", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison013", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison014", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison015", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison016", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison017", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison018", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison019", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison020", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison021", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison022", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison023", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison024", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison025", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison026", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison027", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison028", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison029", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison034", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison035", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison036", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison037", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison038", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison039", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison040", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison044", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison100", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison122", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison123", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison124", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison125", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison126", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison127", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison128", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison129", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison130", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison131", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison132", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison133", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison134", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison135", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison136", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison137", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison138", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison139", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison140", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison141", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison142", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison143", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison144", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison145", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_poison146", 1);
    SetPRCSwitch("PRC_FILE_END_ireq_quarter1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_quarter2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_quarter3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_quarter4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_quarter5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_quarter6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_quarter7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_rapier01", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_rapier02", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_rapier03", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_rapier04", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_rapier05", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_rapier06", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_rapier07", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_ringcth1", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringcth2", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringcth3", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringcth4", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringcth5", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringcth6", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringcth7", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringfree", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringfrt1", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringfrt2", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringfrt3", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringfrt4", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringfrt5", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringfrt6", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringfrt7", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringhide", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringinsi", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringinvs", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringnine", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringofmd", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_ringpro1", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringpro2", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringpro3", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringpro4", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringpro5", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringpro6", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringpro7", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_ringscho", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_robblend", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_robearcb", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_robearcg", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_robearcw", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_robeeyeg", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_robeeyel", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_robescin", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_robessh1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_robessh2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_robessh3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_robessh4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_robessh5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_robessh6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_robessh7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_rodofbeg", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_rodofgho", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_rodofres", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_rodofrev", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_rodoftal", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_rodofter", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_scalem5a", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scalema1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scalema2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scalema3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scalema4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scalema5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scalema6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scalema7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scimita1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scimita2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scimita3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scimita4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scimita5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scimita6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scimita7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scrbprot", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_scythe01", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scythe02", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scythe03", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scythe04", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scythe05", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scythe06", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_scythe07", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shortbo1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shortbo2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shortbo3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shortbo4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shortbo5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shortbo6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shortbo7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shortsw1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shortsw2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shortsw3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shortsw4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shortsw5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shortsw6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shortsw7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shurike1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shurike2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shurike3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shurike4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shurike5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shurike6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_shurike7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_sickle01", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_sickle02", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_sickle03", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_sickle04", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_sickle05", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_sickle06", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_sickle07", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_sling001", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_sling002", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_sling003", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_sling004", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_sling005", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_sling006", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_sling007", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_smallsh1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_smallsh2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_smallsh3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_smallsh4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_smallsh5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_smallsh6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_smallsh7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_soulgem", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_spear001", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_spear002", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_spear003", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_spear004", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_spear005", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_spear006", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_spear007", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_splintm1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_splintm2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_splintm3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_splintm4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_splintm5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_splintm6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_splintm7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_staffabj", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_staffcom", 6);
    SetPRCSwitch("PRC_FILE_END_ireq_staffcon", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_staffdef", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_staffdiv", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_staffenc", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_staffevo", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_stafffir", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_stafffro", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_staffhea", 6);
    SetPRCSwitch("PRC_FILE_END_ireq_staffhly", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_staffill", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_staffilm", 6);
    SetPRCSwitch("PRC_FILE_END_ireq_stafflif", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_staffmgi", 9);
    SetPRCSwitch("PRC_FILE_END_ireq_staffnec", 7);
    SetPRCSwitch("PRC_FILE_END_ireq_staffpow", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_stafftde", 10);
    SetPRCSwitch("PRC_FILE_END_ireq_stafftpo", 11);
    SetPRCSwitch("PRC_FILE_END_ireq_stafftra", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_staffval", 5);
    SetPRCSwitch("PRC_FILE_END_ireq_staffwoo", 8);
    SetPRCSwitch("PRC_FILE_END_ireq_stoneart", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_studded1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_studded2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_studded3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_studded4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_studded5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_studded6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_studded7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_throwax1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_throwax2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_throwax3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_throwax4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_throwax5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_throwax6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_throwax7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_towersh1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_towersh2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_towersh3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_towersh4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_towersh5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_towersh6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_towersh7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_twoblad1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_twoblad2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_twoblad3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_twoblad4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_twoblad5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_twoblad6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_twoblad7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_vestescp", 4);
    SetPRCSwitch("PRC_FILE_END_ireq_vestfait", 3);
    SetPRCSwitch("PRC_FILE_END_ireq_warhamm1", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_warhamm2", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_warhamm3", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_warhamm4", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_warhamm5", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_warhamm6", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_warhamm7", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_whip0001", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_whip0002", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_whip0003", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_whip0004", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_whip0005", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_whip0006", 2);
    SetPRCSwitch("PRC_FILE_END_ireq_whip0007", 2);
    SetPRCSwitch("PRC_FILE_END_ireq__template", 2);
    SetPRCSwitch("PRC_FILE_END_itempropdef", 199);
    SetPRCSwitch("PRC_FILE_END_itemprops", 199);
    SetPRCSwitch("PRC_FILE_END_itemvalue", 59);
    SetPRCSwitch("PRC_FILE_END_item_compare", 199);
    SetPRCSwitch("PRC_FILE_END_item_to_ireq", 790);
    SetPRCSwitch("PRC_FILE_END_masterfeats", 113);
    SetPRCSwitch("PRC_FILE_END_material", 3223);
    SetPRCSwitch("PRC_FILE_END_metamagic", 6);
    SetPRCSwitch("PRC_FILE_END_phenotype", 8);
    SetPRCSwitch("PRC_FILE_END_poison", 146);
    SetPRCSwitch("PRC_FILE_END_poisontypedef", 3);
    SetPRCSwitch("PRC_FILE_END_polymorph", 155);
    SetPRCSwitch("PRC_FILE_END_portraits", 1068);
    SetPRCSwitch("PRC_FILE_END_prc_craft_gen_it", 201);
    SetPRCSwitch("PRC_FILE_END_prc_rune_craft", 4);
    SetPRCSwitch("PRC_FILE_END_precacherows", 9464);
    SetPRCSwitch("PRC_FILE_END_race_feat_aas", 8);
    SetPRCSwitch("PRC_FILE_END_race_feat_agen", 4);
    SetPRCSwitch("PRC_FILE_END_race_feat_aqelf", 8);
    SetPRCSwitch("PRC_FILE_END_race_feat_arcdw", 13);
    SetPRCSwitch("PRC_FILE_END_race_feat_asabi", 6);
    SetPRCSwitch("PRC_FILE_END_race_feat_aunu", 1);
    SetPRCSwitch("PRC_FILE_END_race_feat_avar", 10);
    SetPRCSwitch("PRC_FILE_END_race_feat_ayuan", 15);
    SetPRCSwitch("PRC_FILE_END_race_feat_azer", 6);
    SetPRCSwitch("PRC_FILE_END_race_feat_baaz", 5);
    SetPRCSwitch("PRC_FILE_END_race_feat_brecht", 1);
    SetPRCSwitch("PRC_FILE_END_race_feat_browni", 15);
    SetPRCSwitch("PRC_FILE_END_race_feat_bugb", 6);
    SetPRCSwitch("PRC_FILE_END_race_feat_buom", 4);
    SetPRCSwitch("PRC_FILE_END_race_feat_calib", 1);
    SetPRCSwitch("PRC_FILE_END_race_feat_cent", 6);
    SetPRCSwitch("PRC_FILE_END_race_feat_dae", 6);
    SetPRCSwitch("PRC_FILE_END_race_feat_ddwar", 15);
    SetPRCSwitch("PRC_FILE_END_race_feat_deep", 15);
    SetPRCSwitch("PRC_FILE_END_race_feat_dhalf", 10);
    SetPRCSwitch("PRC_FILE_END_race_feat_dogp", 3);
    SetPRCSwitch("PRC_FILE_END_race_feat_drow", 12);
    SetPRCSwitch("PRC_FILE_END_race_feat_dsgian", 3);
    SetPRCSwitch("PRC_FILE_END_race_feat_duerg", 18);
    SetPRCSwitch("PRC_FILE_END_race_feat_dwarf", 10);
    SetPRCSwitch("PRC_FILE_END_race_feat_egen", 3);
    SetPRCSwitch("PRC_FILE_END_race_feat_elf", 7);
    SetPRCSwitch("PRC_FILE_END_race_feat_feyri", 19);
    SetPRCSwitch("PRC_FILE_END_race_feat_fgen", 3);
    SetPRCSwitch("PRC_FILE_END_race_feat_fgnome", 10);
    SetPRCSwitch("PRC_FILE_END_race_feat_flind", 2);
    SetPRCSwitch("PRC_FILE_END_race_feat_gdwa", 10);
    SetPRCSwitch("PRC_FILE_END_race_feat_gfolk", 2);
    SetPRCSwitch("PRC_FILE_END_race_feat_ghalf", 7);
    SetPRCSwitch("PRC_FILE_END_race_feat_gldwar", 4);
    SetPRCSwitch("PRC_FILE_END_race_feat_gloam", 5);
    SetPRCSwitch("PRC_FILE_END_race_feat_gnoll", 2);
    SetPRCSwitch("PRC_FILE_END_race_feat_gnome", 8);
    SetPRCSwitch("PRC_FILE_END_race_feat_gobl", 3);
    SetPRCSwitch("PRC_FILE_END_race_feat_goelf", 8);
    SetPRCSwitch("PRC_FILE_END_race_feat_gorc", 4);
    SetPRCSwitch("PRC_FILE_END_race_feat_grelf", 7);
    SetPRCSwitch("PRC_FILE_END_race_feat_gyank", 5);
    SetPRCSwitch("PRC_FILE_END_race_feat_gzer", 4);
    SetPRCSwitch("PRC_FILE_END_race_feat_hagsp", 3);
    SetPRCSwitch("PRC_FILE_END_race_feat_half", 6);
    SetPRCSwitch("PRC_FILE_END_race_feat_hdro", 6);
    SetPRCSwitch("PRC_FILE_END_race_feat_hfelf", 5);
    SetPRCSwitch("PRC_FILE_END_race_feat_hforc", 0);
    SetPRCSwitch("PRC_FILE_END_race_feat_hobgo", 2);
    SetPRCSwitch("PRC_FILE_END_race_feat_hogre", 3);
    SetPRCSwitch("PRC_FILE_END_race_feat_human", 0);
    SetPRCSwitch("PRC_FILE_END_race_feat_hyl", 7);
    SetPRCSwitch("PRC_FILE_END_race_feat_illith", 7);
    SetPRCSwitch("PRC_FILE_END_race_feat_imask", 3);
    SetPRCSwitch("PRC_FILE_END_race_feat_kag", 6);
    SetPRCSwitch("PRC_FILE_END_race_feat_kalash", 3);
    SetPRCSwitch("PRC_FILE_END_race_feat_kend", 7);
    SetPRCSwitch("PRC_FILE_END_race_feat_khaas", 9);
    SetPRCSwitch("PRC_FILE_END_race_feat_khin", 1);
    SetPRCSwitch("PRC_FILE_END_race_feat_khogre", 2);
    SetPRCSwitch("PRC_FILE_END_race_feat_kobo", 6);
    SetPRCSwitch("PRC_FILE_END_race_feat_lizar", 6);
    SetPRCSwitch("PRC_FILE_END_race_feat_mazt", 1);
    SetPRCSwitch("PRC_FILE_END_race_feat_minot", 10);
    SetPRCSwitch("PRC_FILE_END_race_feat_neand", 3);
    SetPRCSwitch("PRC_FILE_END_race_feat_nei", 7);
    SetPRCSwitch("PRC_FILE_END_race_feat_neraph", 5);
    SetPRCSwitch("PRC_FILE_END_race_feat_nezu", 6);
    SetPRCSwitch("PRC_FILE_END_race_feat_ogre", 8);
    SetPRCSwitch("PRC_FILE_END_race_feat_orc", 3);
    SetPRCSwitch("PRC_FILE_END_race_feat_orog", 8);
    SetPRCSwitch("PRC_FILE_END_race_feat_pdusk", 7);
    SetPRCSwitch("PRC_FILE_END_race_feat_pixie", 14);
    SetPRCSwitch("PRC_FILE_END_race_feat_pyuan", 12);
    SetPRCSwitch("PRC_FILE_END_race_feat_raka", 5);
    SetPRCSwitch("PRC_FILE_END_race_feat_raks", 9);
    SetPRCSwitch("PRC_FILE_END_race_feat_rgnome", 9);
    SetPRCSwitch("PRC_FILE_END_race_feat_rjur", 1);
    SetPRCSwitch("PRC_FILE_END_race_feat_scro", 3);
    SetPRCSwitch("PRC_FILE_END_race_feat_shalf", 7);
    SetPRCSwitch("PRC_FILE_END_race_feat_sidhe", 8);
    SetPRCSwitch("PRC_FILE_END_race_feat_snelf", 8);
    SetPRCSwitch("PRC_FILE_END_race_feat_stelf", 7);
    SetPRCSwitch("PRC_FILE_END_race_feat_svelf", 8);
    SetPRCSwitch("PRC_FILE_END_race_feat_svirf", 16);
    SetPRCSwitch("PRC_FILE_END_race_feat_swyft", 5);
    SetPRCSwitch("PRC_FILE_END_race_feat_taer", 5);
    SetPRCSwitch("PRC_FILE_END_race_feat_tanar", 7);
    SetPRCSwitch("PRC_FILE_END_race_feat_tasloi", 4);
    SetPRCSwitch("PRC_FILE_END_race_feat_tgn", 5);
    SetPRCSwitch("PRC_FILE_END_race_feat_tgnome", 13);
    SetPRCSwitch("PRC_FILE_END_race_feat_thalf", 8);
    SetPRCSwitch("PRC_FILE_END_race_feat_tief", 8);
    SetPRCSwitch("PRC_FILE_END_race_feat_tnhalf", 7);
    SetPRCSwitch("PRC_FILE_END_race_feat_troll", 7);
    SetPRCSwitch("PRC_FILE_END_race_feat_urdin", 12);
    SetPRCSwitch("PRC_FILE_END_race_feat_vana", 4);
    SetPRCSwitch("PRC_FILE_END_race_feat_vos", 1);
    SetPRCSwitch("PRC_FILE_END_race_feat_wdwarf", 11);
    SetPRCSwitch("PRC_FILE_END_race_feat_wemic", 6);
    SetPRCSwitch("PRC_FILE_END_race_feat_wgen", 4);
    SetPRCSwitch("PRC_FILE_END_race_feat_wielf", 8);
    SetPRCSwitch("PRC_FILE_END_race_feat_woelf", 8);
    SetPRCSwitch("PRC_FILE_END_race_feat_yuan", 4);
    SetPRCSwitch("PRC_FILE_END_racialappear", 254);
    SetPRCSwitch("PRC_FILE_END_racialappearance", 2);
    SetPRCSwitch("PRC_FILE_END_racialtypes", 254);
    SetPRCSwitch("PRC_FILE_END_ranges", 13);
    SetPRCSwitch("PRC_FILE_END_reg", 8);
    SetPRCSwitch("PRC_FILE_END_reg_r", 9);
    SetPRCSwitch("PRC_FILE_END_reg_raceclass", 254);
    SetPRCSwitch("PRC_FILE_END_rig_affix", 1654);
    SetPRCSwitch("PRC_FILE_END_rig_affix_r", 299);
    SetPRCSwitch("PRC_FILE_END_rig_armor", 8);
    SetPRCSwitch("PRC_FILE_END_rig_armor_r", 9);
    SetPRCSwitch("PRC_FILE_END_rig_a_r", 350);
    SetPRCSwitch("PRC_FILE_END_rig_color_r", 3);
    SetPRCSwitch("PRC_FILE_END_rig_colour", 28);
    SetPRCSwitch("PRC_FILE_END_rig_ip", 1243);
    SetPRCSwitch("PRC_FILE_END_rig_root", 69);
    SetPRCSwitch("PRC_FILE_END_rig_root_r", 52);
    SetPRCSwitch("PRC_FILE_END_rng_data", 254);
    SetPRCSwitch("PRC_FILE_END_rng_names", 1999);
    SetPRCSwitch("PRC_FILE_END_shifterlist", 30);
    SetPRCSwitch("PRC_FILE_END_shifter_abilitie", 116);
    SetPRCSwitch("PRC_FILE_END_shifter_feats", 424);
    SetPRCSwitch("PRC_FILE_END_skills", 31);
    SetPRCSwitch("PRC_FILE_END_skillvsitemcost", 55);
    SetPRCSwitch("PRC_FILE_END_soundset", 453);
    SetPRCSwitch("PRC_FILE_END_spells", 17300);
    SetPRCSwitch("PRC_FILE_END_spellschools", 9);
    SetPRCSwitch("PRC_FILE_END_statescripts", 35);
    SetPRCSwitch("PRC_FILE_END_stringtokens", 56);
    SetPRCSwitch("PRC_FILE_END_tailmodel", 3);
    SetPRCSwitch("PRC_FILE_END_templates", 104);
    SetPRCSwitch("PRC_FILE_END_traps", 101);
    SetPRCSwitch("PRC_FILE_END_unarmed_dmg", 15);
    SetPRCSwitch("PRC_FILE_END_vfx_fire_forget", 16);
    SetPRCSwitch("PRC_FILE_END_vfx_persistent", 223);
    SetPRCSwitch("PRC_FILE_END_visualeffects", 1326);
    SetPRCSwitch("PRC_FILE_END_wingmodel", 6);
    //END AUTO-GENERATED FILEENDS


    //there is also the fileends.2da file, but that
    //isnt read in here yet. may be later though
    if(GetPRCSwitch(FILE_END_MANUAL))
        return;
    SetPRCSwitch(FILE_END_CLASSES,         PRCGetFileEnd("classes"));
    SetPRCSwitch(FILE_END_RACIALTYPES,     PRCGetFileEnd("racialtypes"));
    SetPRCSwitch(FILE_END_GENDER,          1);//overriden to 1 for convoCC m/f only choice
    SetPRCSwitch(FILE_END_PORTRAITS,       PRCGetFileEnd("portraits"));
    SetPRCSwitch(FILE_END_SKILLS,          PRCGetFileEnd("skills"));
    SetPRCSwitch(FILE_END_CLASS_FEAT,      600);
    SetPRCSwitch(FILE_END_CLASS_SKILLS,    50);
    SetPRCSwitch(FILE_END_CLASS_POWER,     300);
    SetPRCSwitch(FILE_END_CLASS_SPELLBOOK, PRCGetFileEnd("cls_spell_sorc")); //sorc is 1957
    SetPRCSwitch(FILE_END_FEAT,            PRCGetFileEnd("feat"));
    SetPRCSwitch(FILE_END_CLASS_PREREQ,    25);
    SetPRCSwitch(FILE_END_FAMILIAR,        PRCGetFileEnd("hen_familiar"));
    SetPRCSwitch(FILE_END_ANIMALCOMP,      PRCGetFileEnd("hen_companion"));
    SetPRCSwitch(FILE_END_DOMAINS,         PRCGetFileEnd("domains"));
    SetPRCSwitch(FILE_END_SOUNDSET,        PRCGetFileEnd("soundset"));
    SetPRCSwitch(FILE_END_SPELLS,          PRCGetFileEnd("spells"));
    SetPRCSwitch(FILE_END_SPELLSCHOOL,     PRCGetFileEnd("spellschools"));
    SetPRCSwitch(FILE_END_APPEARANCE,      PRCGetFileEnd("appearance"));
    SetPRCSwitch(FILE_END_WINGS,           PRCGetFileEnd("wingmodel"));
    SetPRCSwitch(FILE_END_TAILS,           PRCGetFileEnd("tailmodel"));
    SetPRCSwitch(FILE_END_PACKAGE,         PRCGetFileEnd("packages"));
    SetPRCSwitch(FILE_END_RACE_FEAT,       30);
    SetPRCSwitch(FILE_END_IREQ,            50);
    SetPRCSwitch(FILE_END_ITEM_TO_IREQ,    PRCGetFileEnd("item_to_ireq"));
    SetPRCSwitch(FILE_END_BASEITEMS,       PRCGetFileEnd("baseitems"));
}

void CreateSwitchNameArray()
{
    object oWP = GetWaypointByTag("PRC_Switch_Name_WP");
    if(!GetIsObjectValid(oWP))
        oWP = CreateObject(OBJECT_TYPE_WAYPOINT, "NW_WAYPOINT001", GetStartingLocation(), FALSE, "PRC_Switch_Name_WP");
    if(!GetIsObjectValid(oWP))
        PrintString("CreateSwitchNameArray: Problem creating waypoint.");
    array_create(oWP, "Switch_Name");
    //if you add more switches, add them to this list
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_TRUESEEING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_TRUESEEING_SPOT_BONUS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BIOWARE_GRRESTORE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BIOWARE_HEAL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BIOWARE_MASS_HEAL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BIOWARE_HARM);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BIOWARE_NEUTRALIZE_POISON);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BIOWARE_REMOVE_DISEASE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_TIMESTOP_BIOWARE_DURATION);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_TIMESTOP_LOCAL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_TIMESTOP_NO_HOSTILE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_TIMESTOP_BLANK_PC);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_ELEMENTAL_SWARM);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_FEAR_AURAS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_TENSERS_TRANSFORMATION);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_BLACK_BLADE_OF_DISASTER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_FIND_TRAPS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_DARKNESS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_DARKNESS_35ED);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_ANIMATE_DEAD);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CREATE_UNDEAD_PERMANENT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CREATE_UNDEAD_UNCONTROLLED);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_NEC_TERM_PERMADEATH);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SPELL_ALIGNMENT_SHIFT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_35ED_WORD_OF_FAITH);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SLEEP_NO_HD_CAP);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_165_DEATH_IMMUNITY);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USE_NEW_IMBUE_ARROW);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DRAGON_DISCIPLE_SIZE_CHANGES);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SAMURAI_ALLOW_STOLEN_SACRIFICE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SAMURAI_ALLOW_UNIDENTIFIED_SACRIFICE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SAMURAI_SACRIFICE_SCALAR_x100);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SAMURAI_VALUE_SCALAR_x100);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_ORC_WARLORD_COHORT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_LICH_ALTER_SELF_DISABLE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_TRUE_NECROMANCER_ALTERNATE_VISUAL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_THRALLHERD_LEADERSHIP);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_XP_COSTS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_TAKE_TEN_RULE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_PRIMARY_ABILITY_MODIFIER_RULE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_BACKLASH_DAMAGE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_FOCI_ADJUST_DC);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_GOLD_MULTIPLIER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_XP_FRACTION);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_FAILURE_FRACTION_GOLD);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_BOOK_DESTRUCTION);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_UNIMPINGED);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_IMPENETRABILITY);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_DULLBLADES);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_CHAMPIONS_VALOR);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_CONVO_LEARNING_DISABLE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_STAFF_CASTER_LEVEL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_NPC_HAS_PC_SPELLCASTING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_ECL_USES_XP_NOT_HD);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DISABLE_DEMILICH);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SPELLSLAB);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SPELLSLAB_NOSCROLLS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SPELLSLAB_NORECIPES);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_ABILITY_DAMAGE_EFFECTS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SUPPLY_BASED_REST);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_REST_HEALING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_REST_TIME);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_SPELL_SCHOOLS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PLAYER_TIME);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_SOMATIC_COMPOMENTS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_SOMATIC_ITEMS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_MULTISUMMON);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SUMMON_ROUND_PER_LEVEL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_FAMILIARS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_FAMILIAR_FEEDING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_NO_HP_REROLL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_NO_FREE_WIZ_SPELLS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_POWER_ATTACK);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_POWER_ATTACK_STACK_WITH_BW);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_NO_PETRIFY_GUI);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DISABLE_SWITCH_CHANGING_CONVO);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DISABLE_DOMAIN_ENFORCEMENT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BONUS_COHORTS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DISABLE_CUSTOM_COHORTS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DISABLE_STANDARD_COHORTS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DISABLE_REGISTER_COHORTS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_SLINGS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BEBILITH_CLAWS_DESTROY);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_AUTO_IDENTIFY_ON_ACQUIRE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_AUTO_UNIDENTIFY_ON_UNACQUIRE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SPELLFIRE_DISALLOW_CHARGE_SELF);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SPELLFIRE_DISALLOW_DRAIN_SCROLL_POTION);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SORC_DISALLOW_NEWSPELLBOOK);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BARD_DISALLOW_NEWSPELLBOOK);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CWSAMURAI_NO_HEIRLOOM_DAISHO);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DISABLE_CONVO_TEMPLATE_GAIN);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_ARMOR_SPEED);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_RACIAL_SPEED);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_REMOVE_PLAYER_SPEED);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_ENFORCE_RACIAL_APPEARANCE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_NPC_FORCE_RACE_ACQUIRE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DYNAMIC_CLOAK_AUTOCOLOUR_DISABLE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DEATH_STABLE_TO_DISABLED_CHANCE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DEATH_STABLE_TO_BLEED_CHANCE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DEATH_BLEED_TO_STABLE_CHANCE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DEATH_HEAL_FROM_STABLE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DEATH_DAMAGE_FROM_STABLE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DEATH_DAMAGE_FROM_BLEEDING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DEATH_TIME_BETWEEN_DEATH);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DEATH_TIME_BETWEEN_DISABLED);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DEATH_TIME_BETWEEN_STABLE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DEATH_TIME_BETWEEN_BLEEDING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_DEATH_ENABLE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_ACP_MANUAL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_ACP_AUTOMATIC);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_ACP_NPC_AUTOMATIC);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_ACP_DELAY);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USE_TAGBASED_INDEX_FOR_POISON);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USES_PER_ITEM_POISON_COUNT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USES_PER_ITEM_POISON_DIE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_ALLOW_ONLY_SHARP_WEAPONS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_ALLOW_ALL_POISONS_ON_WEAPONS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USE_DEXBASED_WEAPON_POISONING_FAILURE_CHANCE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USES_PER_WEAPON_POISON_COUNT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USES_PER_WEAPON_POISON_DIE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_POISON_ALLOW_CLEAN_IN_EQUIP);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PSI_ASTRAL_CONSTRUCT_USE_2DA);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_RAPID_METABOLISM);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PSI_IMP_METAPSIONICS_USE_SUM);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_USECR);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_S_HUGE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_S_LARGE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_S_MEDIUM);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_S_SMALL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_S_TINY);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_OUTSIDER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_ELEMENTAL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_CONSTRUCT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_UNDEAD);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_DRAGON);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_ABERRATION);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_OOZE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_MAGICALBEAST);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_GIANT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_VERMIN);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_BEAST);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_ANIMAL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_MONSTROUSHUMANOID);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_HUMANOID);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_ELEMENTAL_DAMAGE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SPELL_SNEAK_DISABLE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_3_5e_FIST_DAMAGE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BRAWLER_SIZE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_APPEARANCE_SIZE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BIOWARE_MONK_ATTACKS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SMALL_CREATURE_FINESSE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BIOWARE_DIVINE_POWER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_ALLOW_SWITCH_OF_TARGET);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DISABLE_COUP_DE_GRACE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_FLAME_WEAPON_DAMAGE_MAX);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DARKFIRE_DAMAGE_MAX);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DISABLE_CRAFT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CRAFT_TIMER_MULTIPLIER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CRAFT_TIMER_MAX);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CRAFT_TIMER_MIN);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BREW_POTION_CASTER_LEVEL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SCRIBE_SCROLL_CASTER_LEVEL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CRAFT_WAND_CASTER_LEVEL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CRAFTING_BASE_ITEMS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), X2_CI_BREWPOTION_MAXLEVEL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), X2_CI_BREWPOTION_COSTMODIFIER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), X2_CI_SCRIBESCROLL_COSTMODIFIER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), X2_CI_CRAFTWAND_MAXLEVEL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), X2_CI_CRAFTWAND_COSTMODIFIER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CRAFTING_ARBITRARY);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CRAFTING_COST_SCALE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CRAFTING_TIME_SCALE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_TELEPORT_MAX_TARGET_LOCATIONS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DISABLE_TELEPORTATION);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PW_TIME);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PW_PC_AUTOEXPORT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PW_HP_TRACKING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PW_LOCATION_TRACKING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PW_MAPPIN_TRACKING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PW_DEATH_TRACKING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PW_SPELL_TRACKING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_XP_USE_SIMPLE_LA);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_XP_USE_SIMPLE_RACIAL_HD);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_XP_USE_SIMPLE_RACIAL_HD_NO_FREE_XP);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_XP_USE_SIMPLE_RACIAL_HD_NO_SELECTION);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_XP_USE_SETXP);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USE_DATABASE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USE_BIOWARE_DATABASE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DB_PRECACHE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DB_SQLLITE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DB_SQLLITE_INTERVAL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DB_MYSQL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USE_LETOSCRIPT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_LETOSCRIPT_PHEONIX_SYNTAX);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_LETOSCRIPT_FIX_ABILITIES);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_LETOSCRIPT_UNICORN_SQL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_LETOSCRIPT_GETNEWESTBIC);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ENABLE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_AVARIEL_WINGS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_FEYRI_WINGS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_AASIMAR_WINGS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_FEYRI_TAIL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_TIEFLING_TAIL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_DROW_ENFORCE_GENDER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_GENASI_ENFORCE_DOMAINS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_RAKSHASA_FEMALE_APPEARANCE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ENFORCE_PNP_RACIAL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ENFORCE_FEATS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_DISALLOW_CUSTOMISE_WINGS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_DISALLOW_CUSTOMISE_TAIL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_DISALLOW_CUSTOMISE_MODEL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_USE_RACIAL_APPEARANCES);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_USE_RACIAL_PORTRAIT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ONLY_PLAYER_VOICESETS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_RESTRICT_VOICESETS_BY_SEX);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ALLOW_TO_KEEP_VOICESET);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ALLOW_TO_KEEP_PORTRAIT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_RESTRICT_PORTRAIT_BY_SEX);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ENABLE_RACIAL_HITDICE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ALLOW_SKILL_POINT_ROLLOVER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_USE_XP_FOR_NEW_CHAR);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ENCRYPTION_KEY);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_STAT_POINTS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_BONUS_FEATS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_MAX_STAT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_SKILL_MULTIPLIER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_SKILL_BONUS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_CUSTOM_EXIT_SCRIPT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_TRUENAME_CR_MULTIPLIER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_TRUENAME_LEVEL_BONUS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_TRUENAME_DC_CONSTANT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PERFECTED_MAP_CONSTANT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PERFECTED_MAP_MULTIPLIER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DEBUG);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_COMBAT_DEBUG);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SPELLCASTITEM_OVERRIDE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_AFTS_EXTRA_DAMAGE);
}