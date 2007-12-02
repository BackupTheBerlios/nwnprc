/*
    prc_feats

    This is the point all feat checks are routed through
    from EvalPRCFeats() in prc_inc_function.

    Done so that if anything applies custom feats as
    itemproperties (i.e. templates) the bonuses run

    Otherwise, the if() checks before the feat is applied
*/

#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;

    // Feats are checked here
    if(GetHasFeat(FEAT_SAC_VOW, oPC) >0)                         ExecuteScript("prc_vows", oPC);
    if(GetHasFeat(FEAT_LICHLOVED, oPC) >0)                       ExecuteScript("prc_lichloved", oPC);
    if(GetHasFeat(FEAT_EB_HAND, oPC)  ||
       GetHasFeat(FEAT_EB_HEAD, oPC)  ||
       GetHasFeat(FEAT_EB_CHEST, oPC) ||
       GetHasFeat(FEAT_EB_ARM, oPC)   ||
       GetHasFeat(FEAT_EB_NECK, oPC)    )                        ExecuteScript("prc_evilbrand", oPC);
    if(GetHasFeat(FEAT_VILE_WILL_DEFORM, oPC) ||
       GetHasFeat(FEAT_VILE_DEFORM_GAUNT, oPC)||
       GetHasFeat(FEAT_VILE_DEFORM_OBESE, oPC)  )                ExecuteScript("prc_vilefeats", oPC);
    if (GetHasFeat(FEAT_VIGIL_ARMOR, oPC))                       ExecuteScript("ft_vigil_armor", oPC);
    if(GetHasFeat(FEAT_BOWMASTERY, oPC)  ||
       GetHasFeat(FEAT_XBOWMASTERY, oPC) ||
       GetHasFeat(FEAT_SHURIKENMASTERY, oPC))                    ExecuteScript("prc_weapmas", oPC);

    //Delays for item bonuses
    if(GetHasFeat(FEAT_FORCE_PERSONALITY, oPC) ||
       GetHasFeat(FEAT_INSIGHTFUL_REFLEXES, oPC) ||
       GetHasFeat(FEAT_INTUITIVE_ATTACK, oPC) ||
       GetHasFeat(FEAT_RAVAGEGOLDENICE, oPC))                    DelayCommand(0.1, ExecuteScript("prc_ft_passive", oPC));
    if(GetHasFeat(FEAT_TACTILE_TRAPSMITH, oPC))                  DelayCommand(0.1, ExecuteScript("prc_ft_tacttrap", oPC));

    //Baelnorn & Undead
    if(GetHasFeat(FEAT_UNDEAD_HD, oPC))                          ExecuteScript("prc_ud_hitdice", oPC);
    if(GetHasFeat(FEAT_TURN_RESISTANCE, oPC))                    ExecuteScript("prc_turnres", oPC);
    if(GetHasFeat(FEAT_IMPROVED_TURN_RESISTANCE, oPC))           ExecuteScript("prc_imp_turnres", oPC);
    if(GetHasFeat(FEAT_IMMUNITY_ABILITY_DECREASE, oPC))          ExecuteScript("prc_ui_abildrain", oPC);
    if(GetHasFeat(FEAT_IMMUNITY_CRITICAL, oPC))                  ExecuteScript("prc_ui_critical", oPC);
    if(GetHasFeat(FEAT_IMMUNITY_DEATH, oPC))                     ExecuteScript("prc_ui_death", oPC);
    if(GetHasFeat(FEAT_IMMUNITY_DISEASE, oPC))                   ExecuteScript("prc_ui_disease", oPC);
    if(GetHasFeat(FEAT_IMMUNITY_MIND_SPELLS, oPC))               ExecuteScript("prc_ui_mind", oPC);
    if(GetHasFeat(FEAT_IMMUNITY_PARALYSIS, oPC))                 ExecuteScript("prc_ui_paral", oPC);
    if(GetHasFeat(FEAT_IMMUNITY_POISON, oPC))                    ExecuteScript("prc_ui_poison", oPC);
    if(GetHasFeat(FEAT_IMMUNITY_SNEAKATTACK, oPC))               ExecuteScript("prc_ui_snattack", oPC);
    if(GetHasFeat(FEAT_POSITIVE_ENERGY_RESISTANCE, oPC))         ExecuteScript("prc_ud_poe", oPC);

    if(GetHasFeat(FEAT_LINGERING_DAMAGE, oPC) >0)                ExecuteScript("ft_lingdmg", oPC);
    if(GetHasFeat(FEAT_MAGICAL_APTITUDE, oPC))                   ExecuteScript("prc_magaptitude", oPC);
    if(GetHasFeat(FEAT_ETERNAL_FREEDOM, oPC))                    ExecuteScript("etern_free", oPC);
    if(GetPersistantLocalInt(oPC, "EpicSpell_TransVital"))       ExecuteScript("trans_vital", oPC);
    if(GetHasFeat(FEAT_COMBAT_MANIFESTATION, oPC))               ExecuteScript("psi_combat_manif", oPC);
    if(GetHasFeat(FEAT_WILD_TALENT, oPC))                        ExecuteScript("psi_wild_talent", oPC);
    if(GetHasFeat(FEAT_RAPID_METABOLISM, oPC))                   ExecuteScript("prc_rapid_metab", oPC);
    if(GetHasFeat(FEAT_PSIONIC_HOLE, oPC))                       ExecuteScript("psi_psionic_hole", oPC);
    if(GetHasFeat(FEAT_POWER_ATTACK, oPC))                       ExecuteScript("prc_powatk_eval", oPC);
    if(GetHasFeat(FEAT_ENDURANCE, oPC)
        || GetHasFeat(FEAT_TRACK, oPC)
        || GetHasFeat(FEAT_ETHRAN, oPC))                         ExecuteScript("prc_wyzfeat", oPC);
    if(GetHasFeat(FAST_HEALING_1, oPC)
        || GetHasFeat(FAST_HEALING_2, oPC)
        || GetHasFeat(FAST_HEALING_3, oPC))                      ExecuteScript("prc_fastheal", oPC);

    if(GetHasFeat(FEAT_SPELLFIRE_WIELDER, oPC))                  ExecuteScript("prc_spellf_eval", oPC);
    if(GetHasFeat(FEAT_ULTRAVISION, oPC))                        ExecuteScript("prc_ultravis", oPC);
    if(GetHasFeat(FEAT_TWO_WEAPON_REND, oPC))                    ExecuteScript("prc_tw_rend", oPC);

    //Races of the Dragon feats
    if(GetHasFeat(FEAT_KOB_DRAGON_TAIL, oPC)
        || GetHasFeat(FEAT_KOB_DRAGON_WING_A, oPC)
        || GetHasFeat(FEAT_KOB_DRAGON_WING_BC, oPC)
        || GetHasFeat(FEAT_KOB_DRAGON_WING_BG, oPC)
        || GetHasFeat(FEAT_KOB_DRAGON_WING_BM, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BK, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BL, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GR, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_RD, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_WH, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_AM, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CR, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_EM, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SA, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_TP, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BS, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BZ, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CP, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GD, oPC)
        || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SR, oPC))              ExecuteScript("prc_rotdfeat", oPC);

    //Draconic Feats
    if(GetHasFeat(FEAT_DRACONIC_HERITAGE_BK, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_BL, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_GR, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_RD, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_WH, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_AM, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_CR, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_EM, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_SA, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_TP, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_BS, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_BZ, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_CP, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_GD, oPC)
        || GetHasFeat(FEAT_DRACONIC_HERITAGE_SR, oPC)
        || GetHasFeat(FEAT_DRACONIC_SENSES, oPC)
        || GetHasFeat(FEAT_DRAGONTOUCHED, oPC))                    ExecuteScript("prc_dracfeat", oPC);

    //Dragonfire xxxx Feats
    if(GetHasFeat(FEAT_DRAGONFIRE_STRIKE, oPC))                    ExecuteScript("prc_dragfire_atk", oPC);

    //Draconic Aura feats
    if(GetHasFeat(FEAT_DOUBLE_DRACONIC_AURA, oPC))                 ExecuteScript("prc_dbldracaura", oPC);
    if(GetHasFeat(FEAT_BONUS_AURA_INSIGHT, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_PRESENCE, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_RESISTACID, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_RESISTCOLD, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_RESISTELEC, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_RESISTFIRE, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_RESOLVE, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_STAMINA, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_SENSES, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_SWIFTNESS, oPC)
       || GetHasFeat(FEAT_BONUS_AURA_TOUGHNESS, oPC))             ExecuteScript("prc_xtradracaura", oPC);

    // Feats that require OnHitCastSpell: Unique on armor
    /* Commented out until needed
    if(GetHasFeat(FEAT_, oPC)
       )
    {
        AddEventScript(oPC, EVENT_ONPLAYEREQUIP,       "prc_keep_onhit_a", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_keep_onhit_a", TRUE, FALSE);
    }
    */
}