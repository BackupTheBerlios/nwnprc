#include "inc_utility"

int PRCGetFileEnd(string sTable)
{
    sTable = GetStringLowerCase(sTable);
    if(sTable == "ammunitiontypes") return 46;
    if(sTable == "appearance") return 481;
    if(sTable == "appearancesndset") return 28;
    if(sTable == "areaeffects") return 2;
    if(sTable == "armor") return 9;
    if(sTable == "armorparts") return 1;
    if(sTable == "armourtypes") return 42;
    if(sTable == "baseitems") return 112;
    if(sTable == "bodybag") return 6;
    if(sTable == "caarmorclass") return 7;
    if(sTable == "capart") return 18;
    if(sTable == "categories") return 24;
    if(sTable == "catype") return 4;
    if(sTable == "classes") return 254;
    if(sTable == "cloakmodel") return 15;
    if(sTable == "cls_psbk_foz") return 39;
    if(sTable == "cls_psbk_psion") return 39;
    if(sTable == "cls_psbk_psywar") return 59;
    if(sTable == "cls_psbk_warmnd") return 39;
    if(sTable == "cls_psbk_wilder") return 59;
    if(sTable == "cls_psipw_foz") return 92;
    if(sTable == "cls_psipw_psion") return 253;
    if(sTable == "cls_psipw_psywar") return 97;
    if(sTable == "cls_psipw_warmnd") return 92;
    if(sTable == "cls_psipw_wilder") return 164;
    if(sTable == "cls_spbk_antipl") return 39;
    if(sTable == "cls_spbk_asasin") return 39;
    if(sTable == "cls_spbk_bard") return 59;
    if(sTable == "cls_spbk_blkgrd") return 39;
    if(sTable == "cls_spbk_favsol") return 59;
    if(sTable == "cls_spbk_hexbl") return 39;
    if(sTable == "cls_spbk_kchal") return 39;
    if(sTable == "cls_spbk_kotmc") return 39;
    if(sTable == "cls_spbk_ocu") return 29;
    if(sTable == "cls_spbk_sol") return 39;
    if(sTable == "cls_spbk_sorc") return 59;
    if(sTable == "cls_spbk_suel") return 29;
    if(sTable == "cls_spbk_tfshad") return 39;
    if(sTable == "cls_spbk_vassal") return 39;
    if(sTable == "cls_spbk_vigil") return 39;
    if(sTable == "cls_spcr_antipl") return 18;
    if(sTable == "cls_spcr_asasin") return 31;
    if(sTable == "cls_spcr_bard") return 101;
    if(sTable == "cls_spcr_blkgrd") return 20;
    if(sTable == "cls_spcr_favsol") return 156;
    if(sTable == "cls_spcr_hexbl") return 40;
    if(sTable == "cls_spcr_kchal") return 24;
    if(sTable == "cls_spcr_kotmc") return 12;
    if(sTable == "cls_spcr_ocu") return 103;
    if(sTable == "cls_spcr_sol") return 21;
    if(sTable == "cls_spcr_sorc") return 268;
    if(sTable == "cls_spcr_suel") return 65;
    if(sTable == "cls_spcr_tfshad") return 21;
    if(sTable == "cls_spcr_vassal") return 13;
    if(sTable == "cls_spcr_vigil") return 8;
    if(sTable == "cls_spell_antipl") return 67;
    if(sTable == "cls_spell_asasin") return 126;
    if(sTable == "cls_spell_bard") return 418;
    if(sTable == "cls_spell_blkgrd") return 69;
    if(sTable == "cls_spell_favsol") return 791;
    if(sTable == "cls_spell_hexbl") return 145;
    if(sTable == "cls_spell_kchal") return 94;
    if(sTable == "cls_spell_kotmc") return 40;
    if(sTable == "cls_spell_ocu") return 416;
    if(sTable == "cls_spell_sol") return 73;
    if(sTable == "cls_spell_sorc") return 1957;
    if(sTable == "cls_spell_suel") return 293;
    if(sTable == "cls_spell_tfshad") return 77;
    if(sTable == "cls_spell_vassal") return 51;
    if(sTable == "cls_spell_vigil") return 31;
    if(sTable == "cls_spgn_bard") return 60;
    if(sTable == "cls_spgn_cler") return 60;
    if(sTable == "cls_spgn_dru") return 60;
    if(sTable == "cls_spgn_pal") return 60;
    if(sTable == "cls_spgn_rang") return 60;
    if(sTable == "cls_spgn_sorc") return 60;
    if(sTable == "cls_spgn_wiz") return 60;
    if(sTable == "cls_spkn_asasin") return 39;
    if(sTable == "cls_spkn_bard") return 60;
    if(sTable == "cls_spkn_favsol") return 47;
    if(sTable == "cls_spkn_hexbl") return 39;
    if(sTable == "cls_spkn_sorc") return 60;
    if(sTable == "cls_spkn_suel") return 39;
    if(sTable == "cls_true_known") return 39;
    if(sTable == "cls_true_maxlvl") return 39;
    if(sTable == "cls_true_utter") return 8;
    if(sTable == "combatmodes") return 4;
    if(sTable == "craft_armour") return 63;
    if(sTable == "craft_ring") return 41;
    if(sTable == "craft_weapon") return 42;
    if(sTable == "craft_wondrous") return 115;
    if(sTable == "creaturesize") return 5;
    if(sTable == "creaturespeed") return 7;
    if(sTable == "crtemplates") return 10;
    if(sTable == "cursors") return 10;
    if(sTable == "damagehitvisual") return 11;
    if(sTable == "damagelevels") return 6;
    if(sTable == "defaultacsounds") return 8;
    if(sTable == "des_blumburg") return 17;
    if(sTable == "des_conf_treas") return 1;
    if(sTable == "des_crft_amat") return 1;
    if(sTable == "des_crft_aparts") return 18;
    if(sTable == "des_crft_appear") return 54;
    if(sTable == "des_crft_armor") return 41;
    if(sTable == "des_crft_bmat") return 13;
    if(sTable == "des_crft_drop") return 476;
    if(sTable == "des_crft_mat") return 2;
    if(sTable == "des_crft_poison") return 100;
    if(sTable == "des_crft_props") return 27;
    if(sTable == "des_crft_scroll") return 3223;
    if(sTable == "des_crft_spells") return 15588;
    if(sTable == "des_crft_weapon") return 29;
    if(sTable == "des_cutconvdur") return 26;
    if(sTable == "des_feat2item") return 1000;
    if(sTable == "des_matcomp") return 510;
    if(sTable == "des_mechupgrades") return 6;
    if(sTable == "des_pcstart_arm") return 1;
    if(sTable == "des_pcstart_weap") return 1;
    if(sTable == "des_prayer") return 10;
    if(sTable == "des_restsystem") return 21;
    if(sTable == "des_treas_ammo") return 28;
    if(sTable == "des_treas_disp") return 446;
    if(sTable == "des_treas_enh") return 60;
    if(sTable == "des_treas_gold") return 8;
    if(sTable == "des_treas_items") return 15;
    if(sTable == "des_xp_rewards") return 221;
    if(sTable == "diffsettings") return 6;
    if(sTable == "disease") return 62;
    if(sTable == "dmgxp") return 59;
    if(sTable == "domains") return 58;
    if(sTable == "doortype") return 2;
    if(sTable == "doortypes") return 181;
    if(sTable == "ECL") return 254;
    if(sTable == "effectanim") return 0;
    if(sTable == "effecticons") return 129;
    if(sTable == "encdifficulty") return 4;
    if(sTable == "encumbrance") return 100;
    if(sTable == "environment") return 23;
    if(sTable == "epicattacks") return 61;
    if(sTable == "epicsaves") return 60;
    if(sTable == "epicspells") return 70;
    if(sTable == "epicspellseeds") return 27;
    if(sTable == "excitedduration") return 2;
    if(sTable == "exptable") return 41;
    if(sTable == "feat") return 23600;
    if(sTable == "fileends") return 20;
    if(sTable == "footstepsounds") return 16;
    if(sTable == "fractionalcr") return 3;
    if(sTable == "gamespyrooms") return 12;
    if(sTable == "gender") return 4;
    if(sTable == "genericdoors") return 12;
    if(sTable == "hen_companion") return 8;
    if(sTable == "hen_familiar") return 11;
    if(sTable == "inventorysnds") return 82;
    if(sTable == "iprp_abilities") return 5;
    if(sTable == "iprp_acmodtype") return 4;
    if(sTable == "iprp_aligngrp") return 5;
    if(sTable == "iprp_alignment") return 8;
    if(sTable == "iprp_ammocost") return 15;
    if(sTable == "iprp_ammotype") return 2;
    if(sTable == "iprp_amount") return 4;
    if(sTable == "iprp_aoe") return 5;
    if(sTable == "iprp_arcspell") return 19;
    if(sTable == "iprp_base1") return -1;
    if(sTable == "iprp_bladecost") return 5;
    if(sTable == "iprp_bonuscost") return 12;
    if(sTable == "iprp_casterlvl") return 60;
    if(sTable == "iprp_chargecost") return 13;
    if(sTable == "iprp_color") return 6;
    if(sTable == "iprp_combatdam") return 2;
    if(sTable == "iprp_costtable") return 36;
    if(sTable == "iprp_damagecost") return 70;
    if(sTable == "iprp_damagetype") return 13;
    if(sTable == "iprp_damvulcost") return 7;
    if(sTable == "iprp_decvalue1") return 9;
    if(sTable == "iprp_decvalue2") return 9;
    if(sTable == "iprp_feats") return 390;  //17300; //overridden to prevent TMI
    if(sTable == "iprp_immuncost") return 7;
    if(sTable == "iprp_immunity") return 9;
    if(sTable == "iprp_incvalue1") return 9;
    if(sTable == "iprp_incvalue2") return 9;
    if(sTable == "iprp_kitcost") return 50;
    if(sTable == "iprp_lightcost") return 4;
    if(sTable == "iprp_maxpp") return 8;
    if(sTable == "iprp_meleecost") return 20;
    if(sTable == "iprp_metamagic") return 6;
    if(sTable == "iprp_monstcost") return 58;
    if(sTable == "iprp_monsterdam") return 14;
    if(sTable == "iprp_monsterhit") return 12;
    if(sTable == "iprp_neg10cost") return 11;
    if(sTable == "iprp_neg5cost") return 10;
    if(sTable == "iprp_onhit") return 29;
    if(sTable == "iprp_onhitcost") return 70;
    if(sTable == "iprp_onhitdur") return 27;
    if(sTable == "iprp_onhitspell") return 209;
    if(sTable == "iprp_paramtable") return 11;
    if(sTable == "iprp_poison") return 5;
    if(sTable == "iprp_protection") return 19;
    if(sTable == "iprp_redcost") return 5;
    if(sTable == "iprp_resistcost") return 24;
    if(sTable == "iprp_saveelement") return 21;
    if(sTable == "iprp_savingthrow") return 3;
    if(sTable == "iprp_skillcost") return 50;
    if(sTable == "iprp_slotscost") return -1;
    if(sTable == "iprp_soakcost") return 50;
    if(sTable == "iprp_speed_dec") return 9;
    if(sTable == "iprp_speed_enh") return 9;
    if(sTable == "iprp_spellcost") return 243;
    if(sTable == "iprp_spellcstr") return 42;
    if(sTable == "iprp_spelllvcost") return 9;
    if(sTable == "iprp_spelllvlimm") return 9;
    if(sTable == "iprp_spells") return 539; //1291; //overridden to prevent TMI
    if(sTable == "iprp_spellshl") return 7;
    if(sTable == "iprp_srcost") return 61;
    if(sTable == "iprp_staminacost") return -1;
    if(sTable == "iprp_storedpp") return 16;
    if(sTable == "iprp_terraintype") return -1;
    if(sTable == "iprp_trapcost") return 11;
    if(sTable == "iprp_traps") return 4;
    if(sTable == "iprp_trapsize") return 3;
    if(sTable == "iprp_visualfx") return 7;
    if(sTable == "iprp_walk") return 1;
    if(sTable == "iprp_weightcost") return 6;
    if(sTable == "iprp_weightinc") return 5;
    if(sTable == "itempropdef") return 199;
    if(sTable == "itemprops") return 199;
    if(sTable == "itemvalue") return 59;
    if(sTable == "lightcolor") return 33;
    if(sTable == "masterfeats") return 111;
    if(sTable == "metamagic") return 6;
    if(sTable == "nwconfig") return 6;
    if(sTable == "nwconfig2") return 6;
    if(sTable == "packages") return 130;
    if(sTable == "packeqbarb1") return 5;
    if(sTable == "packeqbarb3") return 7;
    if(sTable == "packeqbarb4") return 4;
    if(sTable == "packeqbarb5") return 5;
    if(sTable == "packeqbard1") return 11;
    if(sTable == "packeqcler1") return 6;
    if(sTable == "packeqcler2") return 6;
    if(sTable == "packeqcler3") return 6;
    if(sTable == "packeqcler4") return 6;
    if(sTable == "packeqcler5") return 6;
    if(sTable == "packeqdruid1") return 5;
    if(sTable == "packeqfight1") return 5;
    if(sTable == "packeqfight2") return 7;
    if(sTable == "packeqfight6") return 5;
    if(sTable == "packeqfightc") return 5;
    if(sTable == "packeqmonk1") return 5;
    if(sTable == "packeqmonk2") return 6;
    if(sTable == "packeqmonk4") return 5;
    if(sTable == "packeqmonk5") return 6;
    if(sTable == "packeqpala1") return 6;
    if(sTable == "packeqpala2") return 7;
    if(sTable == "packeqpala3") return 8;
    if(sTable == "packeqrang1") return 8;
    if(sTable == "packeqrang2") return 8;
    if(sTable == "packeqrang3") return 8;
    if(sTable == "packeqrang4") return 8;
    if(sTable == "packeqrang5") return 8;
    if(sTable == "packeqrog1") return 8;
    if(sTable == "packeqrog2") return 8;
    if(sTable == "packeqrog3") return 8;
    if(sTable == "packeqrog5") return 8;
    if(sTable == "packeqrogd") return 8;
    if(sTable == "packeqsor1") return 11;
    if(sTable == "packeqwiz1") return 11;
    if(sTable == "packeqwizb") return 11;
    if(sTable == "packftarch") return 168;
    if(sTable == "packftassa") return 220;
    if(sTable == "packftbarb1") return 220;
    if(sTable == "packftbarb2") return 217;
    if(sTable == "packftbarb3") return 218;
    if(sTable == "packftbarb4") return 220;
    if(sTable == "packftbarb5") return 219;
    if(sTable == "packftbarbf") return 37;
    if(sTable == "packftbard1") return 177;
    if(sTable == "packftbard2") return 173;
    if(sTable == "packftbard3") return 176;
    if(sTable == "packftbard4") return 169;
    if(sTable == "packftbard5") return 168;
    if(sTable == "packftbard6") return 67;
    if(sTable == "packftbardg") return 123;
    if(sTable == "packftblck") return 329;
    if(sTable == "packftcler1") return 160;
    if(sTable == "packftcler2") return 165;
    if(sTable == "packftcler3") return 164;
    if(sTable == "packftcler4") return 164;
    if(sTable == "packftcler5") return 162;
    if(sTable == "packftcler6") return 159;
    if(sTable == "packftclere") return 124;
    if(sTable == "packftcrea1") return 173;
    if(sTable == "packftdrdis") return 254;
    if(sTable == "packftdruid1") return 196;
    if(sTable == "packftdruid2") return 204;
    if(sTable == "packftdruid3") return 199;
    if(sTable == "packftdruid4") return 198;
    if(sTable == "packftdruid5") return 198;
    if(sTable == "packftdruid6") return 196;
    if(sTable == "packftdwdef") return 331;
    if(sTable == "packftfight1") return 375;
    if(sTable == "packftfight2") return 376;
    if(sTable == "packftfight3") return 376;
    if(sTable == "packftfight4") return 376;
    if(sTable == "packftfight5") return 375;
    if(sTable == "packftfight6") return 376;
    if(sTable == "packftfightc") return 188;
    if(sTable == "packftharp") return 188;
    if(sTable == "packftmonk1") return 272;
    if(sTable == "packftmonk2") return 272;
    if(sTable == "packftmonk3") return 272;
    if(sTable == "packftmonk4") return 272;
    if(sTable == "packftmonk5") return 274;
    if(sTable == "packftmonk6") return 272;
    if(sTable == "packftpala1") return 210;
    if(sTable == "packftpala2") return 210;
    if(sTable == "packftpala3") return 209;
    if(sTable == "packftpala4") return 209;
    if(sTable == "packftpalah") return 32;
    if(sTable == "packftrang1") return 155;
    if(sTable == "packftrang2") return 159;
    if(sTable == "packftrang3") return 158;
    if(sTable == "packftrang4") return 159;
    if(sTable == "packftrang5") return 158;
    if(sTable == "packftrang6") return 157;
    if(sTable == "packftrog1") return 298;
    if(sTable == "packftrog2") return 303;
    if(sTable == "packftrog3") return 302;
    if(sTable == "packftrog5") return 322;
    if(sTable == "packftrog6") return 315;
    if(sTable == "packftrog7") return 321;
    if(sTable == "packftrogd") return 178;
    if(sTable == "packftshad") return 287;
    if(sTable == "packftshift") return 148;
    if(sTable == "packftsor1") return 174;
    if(sTable == "packftsor2") return 157;
    if(sTable == "packftsor3") return 157;
    if(sTable == "packftsor4") return 157;
    if(sTable == "packftsor5") return 157;
    if(sTable == "packftsor6") return 172;
    if(sTable == "packftsor7") return 170;
    if(sTable == "packftsor8") return 174;
    if(sTable == "packftsor9") return 199;
    if(sTable == "packftsora") return 174;
    if(sTable == "packfttorm") return 354;
    if(sTable == "packftwiz1") return 174;
    if(sTable == "packftwiz2") return 157;
    if(sTable == "packftwiz3") return 157;
    if(sTable == "packftwiz4") return 157;
    if(sTable == "packftwiz5") return 157;
    if(sTable == "packftwiz6") return 172;
    if(sTable == "packftwiz7") return 170;
    if(sTable == "packftwiz8") return 176;
    if(sTable == "packftwiz9") return 199;
    if(sTable == "packftwiza") return 174;
    if(sTable == "packftwizb") return 43;
    if(sTable == "packftwm") return 255;
    if(sTable == "packskarch") return 13;
    if(sTable == "packskassa") return 13;
    if(sTable == "packskbarb1") return 21;
    if(sTable == "packskbarb2") return 30;
    if(sTable == "packskbarb3") return 20;
    if(sTable == "packskbarb4") return 20;
    if(sTable == "packskbarb5") return 20;
    if(sTable == "packskbarb6") return 21;
    if(sTable == "packskbarb7") return 20;
    if(sTable == "packskbard1") return 22;
    if(sTable == "packskbard2") return 23;
    if(sTable == "packskbard3") return 22;
    if(sTable == "packskbard4") return 25;
    if(sTable == "packskbard5") return 24;
    if(sTable == "packskbard6") return 22;
    if(sTable == "packskbard7") return 22;
    if(sTable == "packskblck") return 13;
    if(sTable == "packskcler1") return 29;
    if(sTable == "packskcler2") return 31;
    if(sTable == "packskcler3") return 30;
    if(sTable == "packskcler4") return 29;
    if(sTable == "packskcler5") return 32;
    if(sTable == "packskcrea1") return 8;
    if(sTable == "packskdrdis") return 10;
    if(sTable == "packskdruid1") return 37;
    if(sTable == "packskdruid2") return 39;
    if(sTable == "packskdruid3") return 36;
    if(sTable == "packskdruid4") return 36;
    if(sTable == "packskdruid5") return 42;
    if(sTable == "packskdwdef") return 10;
    if(sTable == "packskfight1") return 24;
    if(sTable == "packskfight2") return 20;
    if(sTable == "packskfight3") return 21;
    if(sTable == "packskfight5") return 20;
    if(sTable == "packskfight6") return 24;
    if(sTable == "packskharp") return 11;
    if(sTable == "packskmonk1") return 23;
    if(sTable == "packskmonk6") return 23;
    if(sTable == "packskpala1") return 24;
    if(sTable == "packskpala4") return 19;
    if(sTable == "packskpalah") return 24;
    if(sTable == "packskrang1") return 26;
    if(sTable == "packskrang2") return 24;
    if(sTable == "packskrang3") return 24;
    if(sTable == "packskrog1") return 27;
    if(sTable == "packskrog2") return 23;
    if(sTable == "packskrog3") return 24;
    if(sTable == "packskrog4") return 22;
    if(sTable == "packskrog5") return 21;
    if(sTable == "packskrog6") return 21;
    if(sTable == "packskrog7") return 27;
    if(sTable == "packskshad") return 11;
    if(sTable == "packsksor10") return 22;
    if(sTable == "packsktorm") return 30;
    if(sTable == "packskwiz1") return 22;
    if(sTable == "packskwizb") return 25;
    if(sTable == "packspbar1") return 67;
    if(sTable == "packspbar2") return 47;
    if(sTable == "packspbar3") return 34;
    if(sTable == "packspcleric1") return 63;
    if(sTable == "packspcleric2") return 63;
    if(sTable == "packspdruid1") return 63;
    if(sTable == "packspnpc1") return 101;
    if(sTable == "packsppala1") return 70;
    if(sTable == "packsprang1") return 63;
    if(sTable == "packspwiz1") return 146;
    if(sTable == "packspwiz2") return 47;
    if(sTable == "packspwiz3") return 47;
    if(sTable == "packspwiz4") return 50;
    if(sTable == "packspwiz5") return 48;
    if(sTable == "packspwiz6") return 48;
    if(sTable == "packspwiz7") return 48;
    if(sTable == "packspwiz8") return 50;
    if(sTable == "packspwiz9") return 45;
    if(sTable == "packspwizb") return 35;
    if(sTable == "parts_belt") return 17;
    if(sTable == "parts_bicep") return 16;
    if(sTable == "parts_chest") return 55;
    if(sTable == "parts_foot") return 17;
    if(sTable == "parts_forearm") return 24;
    if(sTable == "parts_hand") return 10;
    if(sTable == "parts_legs") return 18;
    if(sTable == "parts_neck") return 8;
    if(sTable == "parts_pelvis") return 38;
    if(sTable == "parts_robe") return 8;
    if(sTable == "parts_shin") return 22;
    if(sTable == "parts_shoulder") return 26;
    if(sTable == "phenotype") return 8;
    if(sTable == "placeableobjsnds") return 48;
    if(sTable == "placeables") return 496;
    if(sTable == "placeabletypes") return 9;
    if(sTable == "poison") return 146;
    if(sTable == "poisontypedef") return 3;
    if(sTable == "polymorph") return 150;
    if(sTable == "portraits") return 1068;
    if(sTable == "prc_craft_gen_it") return 201;
    if(sTable == "prc_rune_craft") return 4;
    if(sTable == "pregen") return 79;
    if(sTable == "prioritygroups") return 21;
    if(sTable == "pvpsettings") return 3;
    if(sTable == "racialtypes") return 254;
    if(sTable == "ranges") return 13;
    if(sTable == "repadjust") return 3;
    if(sTable == "replacetexture") return 2;
    if(sTable == "repute") return 3;
    if(sTable == "resistancecost") return -1;
    if(sTable == "restduration") return 63;
    if(sTable == "rrf_nss") return 19;
    if(sTable == "rrf_wav") return 40;
    if(sTable == "shifterlist") return 30;
    if(sTable == "shifter_abilitie") return 116;
    if(sTable == "shifter_feats") return 424;
    if(sTable == "skills") return 29;
    if(sTable == "skillvsitemcost") return 55;
    if(sTable == "skyboxes") return 7;
    if(sTable == "soundset") return 453;
    if(sTable == "soundsettype") return 3;
    if(sTable == "soundtypes") return 2;
    if(sTable == "spells") return 17300;
    if(sTable == "spellschools") return 9;
    if(sTable == "statescripts") return 35;
    if(sTable == "stringtokens") return 56;
    if(sTable == "surfacemat") return 30;
    if(sTable == "swearfilter") return 164;
    if(sTable == "tailmodel") return 3;
    if(sTable == "templates") return 104;
    if(sTable == "traps") return 101;
    if(sTable == "treasurescale") return 4;
    if(sTable == "unarmed_dmg") return 15;
    if(sTable == "vfx_fire_forget") return 16;
    if(sTable == "vfx_persistent") return 223;
    if(sTable == "videoquality") return 10;
    if(sTable == "visualeffects") return 1326;
    if(sTable == "waypoint") return 5;
    if(sTable == "weaponsounds") return 21;
    if(sTable == "wingmodel") return 6;
    if(sTable == "xpbaseconst") return 17;
    if(sTable == "xptable") return 51;

    if(DEBUG) DoDebug("PRCGetFileEnd: Unrecognised 2da file: " + sTable);
    return 0;
}