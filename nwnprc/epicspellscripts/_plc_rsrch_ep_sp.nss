//:://////////////////////////////////////////////
//:: FileName: "_plc_rsrch_ep_sp"
/*   Purpose: This is the OnDisturbed event handler script for a placeable.
        When an epic spell's book is placed into the inventory, it will search
        and determine validity of the item, and then proceed with the proper
        researching functions.

*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
#include "nw_i0_spells"
#include "inc_epicspells"

// This constant sets who may or may not research spells from the placeable
//      this script is attached to. For example, if you only want arcane casters
//      to be able to research from a lab, and not druids or clerics, you must
//      determine the exclusivity for the placebale with this constant.
//
// You should save the script under a different name once constant is set....
//
// Keywords to use for this constant:
// For CLERICS ONLY ---- "CLERIC"
// For DRUIDS ONLY ---- "DRUID"
// For BOTH DRUIDS AND CLERICS ---- "DIVINE"
// For SORCERERS AND WIZARDS ONLY ---- "ARCANE"
// For EVERYONE ---- "ALL"
string WHO_CAN_RESEARCH = "ALL";

void main()
{
    if (GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_ADDED)
    {
        object oBook = GetInventoryDisturbItem();
        object oPC = GetLastDisturbed();
        string sBook = GetTag(oBook);
        int nDC, nIP, nFE, nR1, nR2, nR3, nR4;
        int nAllowed;
        string sSc;

        if (sBook == "A_STONE")
        {
            nDC = A_STONE_DC;
            nIP = R_A_STONE_IP;
            nFE = R_A_STONE_FE;
            nR1 = A_STONE_R1;
            nR2 = A_STONE_R2;
            nR3 = A_STONE_R3;
            nR4 = A_STONE_R4;
            sSc = A_STONE_S;
        }
        if (sBook == "ACHHEEL")
        {
            nDC = ACHHEEL_DC;
            nIP = R_ACHHEEL_IP;
            nFE = R_ACHHEEL_FE;
            nR1 = ACHHEEL_R1;
            nR2 = ACHHEEL_R2;
            nR3 = ACHHEEL_R3;
            nR4 = ACHHEEL_R4;
            sSc = ACHHEEL_S;
        }
        if (sBook == "AL_MART")
        {
            nDC = AL_MART_DC;
            nIP = R_AL_MART_IP;
            nFE = R_AL_MART_FE;
            nR1 = AL_MART_R1;
            nR2 = AL_MART_R2;
            nR3 = AL_MART_R3;
            nR4 = AL_MART_R4;
            sSc = AL_MART_S;
        }
        if (sBook == "ALLHOPE")
        {
            nDC = ALLHOPE_DC;
            nIP = R_ALLHOPE_IP;
            nFE = R_ALLHOPE_FE;
            nR1 = ALLHOPE_R1;
            nR2 = ALLHOPE_R2;
            nR3 = ALLHOPE_R3;
            nR4 = ALLHOPE_R4;
            sSc = ALLHOPE_S;
        }
        if (sBook == "ANARCHY")
        {
            nDC = ANARCHY_DC;
            nIP = R_ANARCHY_IP;
            nFE = R_ANARCHY_FE;
            nR1 = ANARCHY_R1;
            nR2 = ANARCHY_R2;
            nR3 = ANARCHY_R3;
            nR4 = ANARCHY_R4;
            sSc = ANARCHY_S;
        }
        if (sBook == "ANBLAST")
        {
            nDC = ANBLAST_DC;
            nIP = R_ANBLAST_IP;
            nFE = R_ANBLAST_FE;
            nR1 = ANBLAST_R1;
            nR2 = ANBLAST_R2;
            nR3 = ANBLAST_R3;
            nR4 = ANBLAST_R4;
            sSc = ANBLAST_S;
        }
        if (sBook == "ANBLIZZ")
        {
            nDC = ANBLIZZ_DC;
            nIP = R_ANBLIZZ_IP;
            nFE = R_ANBLIZZ_FE;
            nR1 = ANBLIZZ_R1;
            nR2 = ANBLIZZ_R2;
            nR3 = ANBLIZZ_R3;
            nR4 = ANBLIZZ_R4;
            sSc = ANBLIZZ_S;
        }
        if (sBook == "ARMY_UN")
        {
            nDC = ARMY_UN_DC;
            nIP = R_ARMY_UN_IP;
            nFE = R_ARMY_UN_FE;
            nR1 = ARMY_UN_R1;
            nR2 = ARMY_UN_R2;
            nR3 = ARMY_UN_R3;
            nR4 = ARMY_UN_R4;
            sSc = ARMY_UN_S;
        }
        if (sBook == "BATTLEB")
        {
            nDC = BATTLEB_DC;
            nIP = R_BATTLEB_IP;
            nFE = R_BATTLEB_FE;
            nR1 = BATTLEB_R1;
            nR2 = BATTLEB_R2;
            nR3 = BATTLEB_R3;
            nR4 = BATTLEB_R4;
            sSc = BATTLEB_S;
        }
        if (sBook == "CELCOUN")
        {
            nDC = CELCOUN_DC;
            nIP = R_CELCOUN_IP;
            nFE = R_CELCOUN_FE;
            nR1 = CELCOUN_R1;
            nR2 = CELCOUN_R2;
            nR3 = CELCOUN_R3;
            nR4 = CELCOUN_R4;
            sSc = CELCOUN_S;
        }
        if (sBook == "CHAMP_V")
        {
            nDC = CHAMP_V_DC;
            nIP = R_CHAMP_V_IP;
            nFE = R_CHAMP_V_FE;
            nR1 = CHAMP_V_R1;
            nR2 = CHAMP_V_R2;
            nR3 = CHAMP_V_R3;
            nR4 = CHAMP_V_R4;
            sSc = CHAMP_V_S;
        }
        if (sBook == "CON_RES")
        {
            nDC = CON_RES_DC;
            nIP = R_CON_RES_IP;
            nFE = R_CON_RES_FE;
            nR1 = CON_RES_R1;
            nR2 = CON_RES_R2;
            nR3 = CON_RES_R3;
            nR4 = CON_RES_R4;
            sSc = CON_RES_S;
        }
        if (sBook == "CON_REU")
        {
            nDC = CON_REU_DC;
            nIP = R_CON_REU_IP;
            nFE = R_CON_REU_FE;
            nR1 = CON_REU_R1;
            nR2 = CON_REU_R2;
            nR3 = CON_REU_R3;
            nR4 = CON_REU_R4;
            sSc = CON_REU_S;
        }
        if (sBook == "DEADEYE")
        {
            nDC = DEADEYE_DC;
            nIP = R_DEADEYE_IP;
            nFE = R_DEADEYE_FE;
            nR1 = DEADEYE_R1;
            nR2 = DEADEYE_R2;
            nR3 = DEADEYE_R3;
            nR4 = DEADEYE_R4;
            sSc = DEADEYE_S;
        }
        if (sBook == "DIREWIN")
        {
            nDC = DIREWIN_DC;
            nIP = R_DIREWIN_IP;
            nFE = R_DIREWIN_FE;
            nR1 = DIREWIN_R1;
            nR2 = DIREWIN_R2;
            nR3 = DIREWIN_R3;
            nR4 = DIREWIN_R4;
            sSc = DIREWIN_S;
        }
        if (sBook == "DREAMSC")
        {
            nDC = DREAMSC_DC;
            nIP = R_DREAMSC_IP;
            nFE = R_DREAMSC_FE;
            nR1 = DREAMSC_R1;
            nR2 = DREAMSC_R2;
            nR3 = DREAMSC_R3;
            nR4 = DREAMSC_R4;
            sSc = DREAMSC_S;
        }
        if (sBook == "DRG_KNI")
        {
            nDC = DRG_KNI_DC;
            nIP = R_DRG_KNI_IP;
            nFE = R_DRG_KNI_FE;
            nR1 = DRG_KNI_R1;
            nR2 = DRG_KNI_R2;
            nR3 = DRG_KNI_R3;
            nR4 = DRG_KNI_R4;
            sSc = DRG_KNI_S;
        }
        if (sBook == "DTHMARK")
        {
            nDC = DTHMARK_DC;
            nIP = R_DTHMARK_IP;
            nFE = R_DTHMARK_FE;
            nR1 = DTHMARK_R1;
            nR2 = DTHMARK_R2;
            nR3 = DTHMARK_R3;
            nR4 = DTHMARK_R4;
            sSc = DTHMARK_S;
        }
        if (sBook == "DULBLAD")
        {
            nDC = DULBLAD_DC;
            nIP = R_DULBLAD_IP;
            nFE = R_DULBLAD_FE;
            nR1 = DULBLAD_R1;
            nR2 = DULBLAD_R2;
            nR3 = DULBLAD_R3;
            nR4 = DULBLAD_R4;
            sSc = DULBLAD_S;
        }
        if (sBook == "DWEO_TH")
        {
            nDC = DWEO_TH_DC;
            nIP = R_DWEO_TH_IP;
            nFE = R_DWEO_TH_FE;
            nR1 = DWEO_TH_R1;
            nR2 = DWEO_TH_R2;
            nR3 = DWEO_TH_R3;
            nR4 = DWEO_TH_R4;
            sSc = DWEO_TH_S;
        }
        if (sBook == "ENSLAVE")
        {
            nDC = ENSLAVE_DC;
            nIP = R_ENSLAVE_IP;
            nFE = R_ENSLAVE_FE;
            nR1 = ENSLAVE_R1;
            nR2 = ENSLAVE_R2;
            nR3 = ENSLAVE_R3;
            nR4 = ENSLAVE_R4;
            sSc = ENSLAVE_S;
        }
        if (sBook == "EP_M_AR")
        {
            nDC = EP_M_AR_DC;
            nIP = R_EP_M_AR_IP;
            nFE = R_EP_M_AR_FE;
            nR1 = EP_M_AR_R1;
            nR2 = EP_M_AR_R2;
            nR3 = EP_M_AR_R3;
            nR4 = EP_M_AR_R4;
            sSc = EP_M_AR_S;
        }
        if (sBook == "EP_RPLS")
        {
            nDC = EP_RPLS_DC;
            nIP = R_EP_RPLS_IP;
            nFE = R_EP_RPLS_FE;
            nR1 = EP_RPLS_R1;
            nR2 = EP_RPLS_R2;
            nR3 = EP_RPLS_R3;
            nR4 = EP_RPLS_R4;
            sSc = EP_RPLS_S;
        }
        if (sBook == "EP_SP_R")
        {
            nDC = EP_SP_R_DC;
            nIP = R_EP_SP_R_IP;
            nFE = R_EP_SP_R_FE;
            nR1 = EP_SP_R_R1;
            nR2 = EP_SP_R_R2;
            nR3 = EP_SP_R_R3;
            nR4 = EP_SP_R_R4;
            sSc = EP_SP_R_S;
        }
        if (sBook == "EP_WARD")
        {
            nDC = EP_WARD_DC;
            nIP = R_EP_WARD_IP;
            nFE = R_EP_WARD_FE;
            nR1 = EP_WARD_R1;
            nR2 = EP_WARD_R2;
            nR3 = EP_WARD_R3;
            nR4 = EP_WARD_R4;
            sSc = EP_WARD_S;
        }
        if (sBook == "ET_FREE")
        {
            nDC = ET_FREE_DC;
            nIP = R_ET_FREE_IP;
            nFE = R_ET_FREE_FE;
            nR1 = ET_FREE_R1;
            nR2 = ET_FREE_R2;
            nR3 = ET_FREE_R3;
            nR4 = ET_FREE_R4;
            sSc = ET_FREE_S;
        }
        if (sBook == "FIEND_W")
        {
            nDC = FIEND_W_DC;
            nIP = R_FIEND_W_IP;
            nFE = R_FIEND_W_FE;
            nR1 = FIEND_W_R1;
            nR2 = FIEND_W_R2;
            nR3 = FIEND_W_R3;
            nR4 = FIEND_W_R4;
            sSc = FIEND_W_S;
        }
        if (sBook == "FLEETNS")
        {
            nDC = FLEETNS_DC;
            nIP = R_FLEETNS_IP;
            nFE = R_FLEETNS_FE;
            nR1 = FLEETNS_R1;
            nR2 = FLEETNS_R2;
            nR3 = FLEETNS_R3;
            nR4 = FLEETNS_R4;
            sSc = FLEETNS_S;
        }
        if (sBook == "GEMCAGE")
        {
            nDC = GEMCAGE_DC;
            nIP = R_GEMCAGE_IP;
            nFE = R_GEMCAGE_FE;
            nR1 = GEMCAGE_R1;
            nR2 = GEMCAGE_R2;
            nR3 = GEMCAGE_R3;
            nR4 = GEMCAGE_R4;
            sSc = GEMCAGE_S;
        }
        if (sBook == "GODSMIT")
        {
            nDC = GODSMIT_DC;
            nIP = R_GODSMIT_IP;
            nFE = R_GODSMIT_FE;
            nR1 = GODSMIT_R1;
            nR2 = GODSMIT_R2;
            nR3 = GODSMIT_R3;
            nR4 = GODSMIT_R4;
            sSc = GODSMIT_S;
        }
        if (sBook == "GR_RUIN")
        {
            nDC = GR_RUIN_DC;
            nIP = R_GR_RUIN_IP;
            nFE = R_GR_RUIN_FE;
            nR1 = GR_RUIN_R1;
            nR2 = GR_RUIN_R2;
            nR3 = GR_RUIN_R3;
            nR4 = GR_RUIN_R4;
            sSc = GR_RUIN_S;
        }
        if (sBook == "GR_SP_RE")
        {
            nDC = GR_SP_RE_DC;
            nIP = R_GR_SP_RE_IP;
            nFE = R_GR_SP_RE_FE;
            nR1 = GR_SP_RE_R1;
            nR2 = GR_SP_RE_R2;
            nR3 = GR_SP_RE_R3;
            nR4 = GR_SP_RE_R4;
            sSc = GR_SP_RE_S;
        }
        if (sBook == "GR_TIME")
        {
            nDC = GR_TIME_DC;
            nIP = R_GR_TIME_IP;
            nFE = R_GR_TIME_FE;
            nR1 = GR_TIME_R1;
            nR2 = GR_TIME_R2;
            nR3 = GR_TIME_R3;
            nR4 = GR_TIME_R4;
            sSc = GR_TIME_S;
        }
        if (sBook == "HELBALL")
        {
            nDC = HELBALL_DC;
            nIP = R_HELBALL_IP;
            nFE = R_HELBALL_FE;
            nR1 = HELBALL_R1;
            nR2 = HELBALL_R2;
            nR3 = HELBALL_R3;
            nR4 = HELBALL_R4;
            sSc = HELBALL_S;
        }
        if (sBook == "HELSEND")
        {
            nDC = HELSEND_DC;
            nIP = R_HELSEND_IP;
            nFE = R_HELSEND_FE;
            nR1 = HELSEND_R1;
            nR2 = HELSEND_R2;
            nR3 = HELSEND_R3;
            nR4 = HELSEND_R4;
            sSc = HELSEND_S;
        }
        if (sBook == "HERCALL")
        {
            nDC = HERCALL_DC - HERCEMP_DC; // The player only has to pay for upgrade
            nIP = R_HERCALL_IP;
            nFE = R_HERCALL_FE;
            nR1 = HERCALL_R1;
            nR2 = HERCALL_R2;
            nR3 = HERCALL_R3;
            nR4 = HERCALL_R4;
            sSc = HERCALL_S;
        }
        if (sBook == "HERCEMP")
        {
            nDC = HERCEMP_DC;
            nIP = R_HERCEMP_IP;
            nFE = R_HERCEMP_FE;
            nR1 = HERCEMP_R1;
            nR2 = HERCEMP_R2;
            nR3 = HERCEMP_R3;
            nR4 = HERCEMP_R4;
            sSc = HERCEMP_S;
        }
        if (sBook == "IMPENET")
        {
            nDC = IMPENET_DC;
            nIP = R_IMPENET_IP;
            nFE = R_IMPENET_FE;
            nR1 = IMPENET_R1;
            nR2 = IMPENET_R2;
            nR3 = IMPENET_R3;
            nR4 = IMPENET_R4;
            sSc = IMPENET_S;
        }
        if (sBook == "LEECH_F")
        {
            nDC = LEECH_F_DC;
            nIP = R_LEECH_F_IP;
            nFE = R_LEECH_F_FE;
            nR1 = LEECH_F_R1;
            nR2 = LEECH_F_R2;
            nR3 = LEECH_F_R3;
            nR4 = LEECH_F_R4;
            sSc = LEECH_F_S;
        }
        if (sBook == "LEG_ART")
        {
            nDC = LEG_ART_DC;
            nIP = R_LEG_ART_IP;
            nFE = R_LEG_ART_FE;
            nR1 = LEG_ART_R1;
            nR2 = LEG_ART_R2;
            nR3 = LEG_ART_R3;
            nR4 = LEG_ART_R4;
            sSc = LEG_ART_S;
        }
        if (sBook == "LIFE_FT")
        {
            nDC = LIFE_FT_DC;
            nIP = R_LIFE_FT_IP;
            nFE = R_LIFE_FT_FE;
            nR1 = LIFE_FT_R1;
            nR2 = LIFE_FT_R2;
            nR3 = LIFE_FT_R3;
            nR4 = LIFE_FT_R4;
            sSc = LIFE_FT_S;
        }
        if (sBook == "MAGMA_B")
        {
            nDC = MAGMA_B_DC;
            nIP = R_MAGMA_B_IP;
            nFE = R_MAGMA_B_FE;
            nR1 = MAGMA_B_R1;
            nR2 = MAGMA_B_R2;
            nR3 = MAGMA_B_R3;
            nR4 = MAGMA_B_R4;
            sSc = MAGMA_B_S;
        }
        if (sBook == "MASSPEN")
        {
            nDC = MASSPEN_DC;
            nIP = R_MASSPEN_IP;
            nFE = R_MASSPEN_FE;
            nR1 = MASSPEN_R1;
            nR2 = MASSPEN_R2;
            nR3 = MASSPEN_R3;
            nR4 = MASSPEN_R4;
            sSc = MASSPEN_S;
        }
        if (sBook == "MORI")
        {
            nDC = MORI_DC;
            nIP = R_MORI_IP;
            nFE = R_MORI_FE;
            nR1 = MORI_R1;
            nR2 = MORI_R2;
            nR3 = MORI_R3;
            nR4 = MORI_R4;
            sSc = MORI_S;
        }
        if (sBook == "MUMDUST")
        {
            nDC = MUMDUST_DC;
            nIP = R_MUMDUST_IP;
            nFE = R_MUMDUST_FE;
            nR1 = MUMDUST_R1;
            nR2 = MUMDUST_R2;
            nR3 = MUMDUST_R3;
            nR4 = MUMDUST_R4;
            sSc = MUMDUST_S;
        }
        if (sBook == "NAILSKY")
        {
            nDC = NAILSKY_DC;
            nIP = R_NAILSKY_IP;
            nFE = R_NAILSKY_FE;
            nR1 = NAILSKY_R1;
            nR2 = NAILSKY_R2;
            nR3 = NAILSKY_R3;
            nR4 = NAILSKY_R4;
            sSc = NAILSKY_S;
        }
        if (sBook == "NIGHTSU")
        {
            nDC = NIGHTSU_DC;
            nIP = R_NIGHTSU_IP;
            nFE = R_NIGHTSU_FE;
            nR1 = NIGHTSU_R1;
            nR2 = NIGHTSU_R2;
            nR3 = NIGHTSU_R3;
            nR4 = NIGHTSU_R4;
            sSc = NIGHTSU_S;
        }
        if (sBook == "ORDER_R")
        {
            nDC = ORDER_R_DC;
            nIP = R_ORDER_R_IP;
            nFE = R_ORDER_R_FE;
            nR1 = ORDER_R_R1;
            nR2 = ORDER_R_R2;
            nR3 = ORDER_R_R3;
            nR4 = ORDER_R_R4;
            sSc = ORDER_R_S;
        }
        if (sBook == "PATHS_B")
        {
            nDC = PATHS_B_DC;
            nIP = R_PATHS_B_IP;
            nFE = R_PATHS_B_FE;
            nR1 = PATHS_B_R1;
            nR2 = PATHS_B_R2;
            nR3 = PATHS_B_R3;
            nR4 = PATHS_B_R4;
            sSc = PATHS_B_S;
        }
        if (sBook == "PEERPEN")
        {
            nDC = PEERPEN_DC;
            nIP = R_PEERPEN_IP;
            nFE = R_PEERPEN_FE;
            nR1 = PEERPEN_R1;
            nR2 = PEERPEN_R2;
            nR3 = PEERPEN_R3;
            nR4 = PEERPEN_R4;
            sSc = PEERPEN_S;
        }
        if (sBook == "PESTIL")
        {
            nDC = PESTIL_DC;
            nIP = R_PESTIL_IP;
            nFE = R_PESTIL_FE;
            nR1 = PESTIL_R1;
            nR2 = PESTIL_R2;
            nR3 = PESTIL_R3;
            nR4 = PESTIL_R4;
            sSc = PESTIL_S;
        }
        if (sBook == "PIOUS_P")
        {
            nDC = PIOUS_P_DC;
            nIP = R_PIOUS_P_IP;
            nFE = R_PIOUS_P_FE;
            nR1 = PIOUS_P_R1;
            nR2 = PIOUS_P_R2;
            nR3 = PIOUS_P_R3;
            nR4 = PIOUS_P_R4;
            sSc = PIOUS_P_S;
        }
        if (sBook == "PLANCEL")
        {
            nDC = PLANCEL_DC;
            nIP = R_PLANCEL_IP;
            nFE = R_PLANCEL_FE;
            nR1 = PLANCEL_R1;
            nR2 = PLANCEL_R2;
            nR3 = PLANCEL_R3;
            nR4 = PLANCEL_R4;
            sSc = PLANCEL_S;
        }
        if (sBook == "PSION_S")
        {
            nDC = PSION_S_DC;
            nIP = R_PSION_S_IP;
            nFE = R_PSION_S_FE;
            nR1 = PSION_S_R1;
            nR2 = PSION_S_R2;
            nR3 = PSION_S_R3;
            nR4 = PSION_S_R4;
            sSc = PSION_S_S;
        }
        if (sBook == "RAINFIR")
        {
            nDC = RAINFIR_DC;
            nIP = R_RAINFIR_IP;
            nFE = R_RAINFIR_FE;
            nR1 = RAINFIR_R1;
            nR2 = RAINFIR_R2;
            nR3 = RAINFIR_R3;
            nR4 = RAINFIR_R4;
            sSc = RAINFIR_S;
        }
        if (sBook == "RISEN_R")
        {
            nDC = RISEN_R_DC;
            nIP = R_RISEN_R_IP;
            nFE = R_RISEN_R_FE;
            nR1 = RISEN_R_R1;
            nR2 = RISEN_R_R2;
            nR3 = RISEN_R_R3;
            nR4 = RISEN_R_R4;
            sSc = RISEN_R_S;
        }
        if (sBook == "RUIN")
        {
            nDC = RUIN_DC;
            nIP = R_RUIN_IP;
            nFE = R_RUIN_FE;
            nR1 = RUIN_R1;
            nR2 = RUIN_R2;
            nR3 = RUIN_R3;
            nR4 = RUIN_R4;
            sSc = RUIN_S;
        }
        if (sBook == "SINGSUN")
        {
            nDC = SINGSUN_DC;
            nIP = R_SINGSUN_IP;
            nFE = R_SINGSUN_FE;
            nR1 = SINGSUN_R1;
            nR2 = SINGSUN_R2;
            nR3 = SINGSUN_R3;
            nR4 = SINGSUN_R4;
            sSc = SINGSUN_S;
        }
        if (sBook == "SP_WORM")
        {
            nDC = SP_WORM_DC;
            nIP = R_SP_WORM_IP;
            nFE = R_SP_WORM_FE;
            nR1 = SP_WORM_R1;
            nR2 = SP_WORM_R2;
            nR3 = SP_WORM_R3;
            nR4 = SP_WORM_R4;
            sSc = SP_WORM_S;
        }
        if (sBook == "STORM_M")
        {
            nDC = STORM_M_DC;
            nIP = R_STORM_M_IP;
            nFE = R_STORM_M_FE;
            nR1 = STORM_M_R1;
            nR2 = STORM_M_R2;
            nR3 = STORM_M_R3;
            nR4 = STORM_M_R4;
            sSc = STORM_M_S;
        }
        if (sBook == "SUMABER")
        {
            nDC = SUMABER_DC;
            nIP = R_SUMABER_IP;
            nFE = R_SUMABER_FE;
            nR1 = SUMABER_R1;
            nR2 = SUMABER_R2;
            nR3 = SUMABER_R3;
            nR4 = SUMABER_R4;
            sSc = SUMABER_S;
        }
        if (sBook == "SUP_DIS")
        {
            nDC = SUP_DIS_DC;
            nIP = R_SUP_DIS_IP;
            nFE = R_SUP_DIS_FE;
            nR1 = SUP_DIS_R1;
            nR2 = SUP_DIS_R2;
            nR3 = SUP_DIS_R3;
            nR4 = SUP_DIS_R4;
            sSc = SUP_DIS_S;
        }
        if (sBook == "SYMRUST")
        {
            nDC = SYMRUST_DC;
            nIP = R_SYMRUST_IP;
            nFE = R_SYMRUST_FE;
            nR1 = SYMRUST_R1;
            nR2 = SYMRUST_R2;
            nR3 = SYMRUST_R3;
            nR4 = SYMRUST_R4;
            sSc = SYMRUST_S;
        }
        if (sBook == "THEWITH")
        {
            nDC = THEWITH_DC;
            nIP = R_THEWITH_IP;
            nFE = R_THEWITH_FE;
            nR1 = THEWITH_R1;
            nR2 = THEWITH_R2;
            nR3 = THEWITH_R3;
            nR4 = THEWITH_R4;
            sSc = THEWITH_S;
        }
        if (sBook == "TOLO_KW")
        {
            nDC = TOLO_KW_DC;
            nIP = R_TOLO_KW_IP;
            nFE = R_TOLO_KW_FE;
            nR1 = TOLO_KW_R1;
            nR2 = TOLO_KW_R2;
            nR3 = TOLO_KW_R3;
            nR4 = TOLO_KW_R4;
            sSc = TOLO_KW_S;
        }
        if (sBook == "TRANVIT")
        {
            nDC = TRANVIT_DC;
            nIP = R_TRANVIT_IP;
            nFE = R_TRANVIT_FE;
            nR1 = TRANVIT_R1;
            nR2 = TRANVIT_R2;
            nR3 = TRANVIT_R3;
            nR4 = TRANVIT_R4;
            sSc = TRANVIT_S;
        }
        if (sBook == "TWINF")
        {
            nDC = TWINF_DC;
            nIP = R_TWINF_IP;
            nFE = R_TWINF_FE;
            nR1 = TWINF_R1;
            nR2 = TWINF_R2;
            nR3 = TWINF_R3;
            nR4 = TWINF_R4;
            sSc = TWINF_S;
        }
        if (sBook == "UNHOLYD")
        {
            nDC = UNHOLYD_DC;
            nIP = R_UNHOLYD_IP;
            nFE = R_UNHOLYD_FE;
            nR1 = UNHOLYD_R1;
            nR2 = UNHOLYD_R2;
            nR3 = UNHOLYD_R3;
            nR4 = UNHOLYD_R4;
            sSc = UNHOLYD_S;
        }
        if (sBook == "UNIMPIN")
        {
            nDC = UNIMPIN_DC;
            nIP = R_UNIMPIN_IP;
            nFE = R_UNIMPIN_FE;
            nR1 = UNIMPIN_R1;
            nR2 = UNIMPIN_R2;
            nR3 = UNIMPIN_R3;
            nR4 = UNIMPIN_R4;
            sSc = UNIMPIN_S;
        }
        if (sBook == "UNSEENW")
        {
            nDC = UNSEENW_DC;
            nIP = R_UNSEENW_IP;
            nFE = R_UNSEENW_FE;
            nR1 = UNSEENW_R1;
            nR2 = UNSEENW_R2;
            nR3 = UNSEENW_R3;
            nR4 = UNSEENW_R4;
            sSc = UNSEENW_S;
        }
        if (sBook == "WHIP_SH")
        {
            nDC = WHIP_SH_DC;
            nIP = R_WHIP_SH_IP;
            nFE = R_WHIP_SH_FE;
            nR1 = WHIP_SH_R1;
            nR2 = WHIP_SH_R2;
            nR3 = WHIP_SH_R3;
            nR4 = WHIP_SH_R4;
            sSc = WHIP_SH_S;
        }
        // Make sure the player is allowed to research from this placeable.
        nAllowed = FALSE;
        if (WHO_CAN_RESEARCH == "CLERIC" && GetIsEpicCleric(oPC)) nAllowed = TRUE;
        if (WHO_CAN_RESEARCH == "DRUID" && GetIsEpicDruid(oPC)) nAllowed = TRUE;
        if (WHO_CAN_RESEARCH == "DIVINE" &&
            (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC))) nAllowed = TRUE;
        if (WHO_CAN_RESEARCH == "ARCANE" && GetIsEpicSorcerer(oPC)) nAllowed = TRUE;
        if (WHO_CAN_RESEARCH == "ARCANE" && GetIsEpicWizard(oPC)) nAllowed = TRUE;
        if (WHO_CAN_RESEARCH == "ALL" &&
            (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC) ||
            GetIsEpicSorcerer(oPC) || GetIsEpicWizard(oPC))) nAllowed = TRUE;
        if (nAllowed == TRUE)
        {
            // Make sure the player doesn't already know this spell.
            if (!GetHasFeat(nFE, oPC))
            {
                // If applicable, adjust the spell's DC.
                if (GetPRCSwitch(PRC_EPIC_FOCI_ADJUST_DC) == TRUE)
                    nDC -= GetDCSchoolFocusAdjustment(oPC, sSc);
                // Does the player have enough gold?
                if (GetHasEnoughGoldToResearch(oPC, nDC))
                {
                    // Does the player have enough extra experience?
                    if (GetHasEnoughExperienceToResearch(oPC, nDC))
                    {
                        // Does the player have all of the other requirements?
                        if (GetHasRequiredFeatsForResearch(oPC, nR1, nR2, nR3, nR4))
                        {
                            DoSpellResearch(oPC, nDC, nIP, sSc, oBook);
                        }
                        else
                            SendMessageToPC(oPC, MES_NOT_HAVE_REQ_FEATS);
                    }
                    else
                        SendMessageToPC(oPC, MES_NOT_ENOUGH_XP);
                }
                else
                    SendMessageToPC(oPC, MES_NOT_ENOUGH_GOLD);
            }
            else
                SendMessageToPC(oPC, MES_KNOW_SPELL);
        }
        else
            SendMessageToPC(oPC, MES_CANNOT_RESEARCH_HERE);
    }
}
