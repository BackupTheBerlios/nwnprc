//:://////////////////////////////////////////////
//:: FileName: "activate_epspell"
/*   Purpose: This is the script that gets called by the OnItemActivated event
        when the item is one of the Epic Spell books. It essentially displays
        all relevant information on the epic spell, so that a player may make
        an informed decision on whether to research the spell or not.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
#include "inc_epicspells"
void main()
{
    object oBook = GetItemActivated();
    string sBook = GetTag(oBook);
    string sName, sDesc;
    string sSc;
    int nDC, nFE, nR1, nR2, nR3, nR4, nXC, nXP, nGP;

    if (sBook == "A_STONE")
    {
        nDC = A_STONE_DC;
        nFE = A_STONE_FE;
        nR1 = A_STONE_R1;
        nR2 = A_STONE_R2;
        nR3 = A_STONE_R3;
        nR4 = A_STONE_R4;
        nXC = A_STONE_XP;
        sSc = A_STONE_S;
    }
    if (sBook == "ACHHEEL")
    {
        nDC = ACHHEEL_DC;
        nFE = ACHHEEL_FE;
        nR1 = ACHHEEL_R1;
        nR2 = ACHHEEL_R2;
        nR3 = ACHHEEL_R3;
        nR4 = ACHHEEL_R4;
        nXC = ACHHEEL_XP;
        sSc = ACHHEEL_S;
    }
    if (sBook == "AL_MART")
    {
        nDC = AL_MART_DC;
        nFE = AL_MART_FE;
        nR1 = AL_MART_R1;
        nR2 = AL_MART_R2;
        nR3 = AL_MART_R3;
        nR4 = AL_MART_R4;
        nXC = AL_MART_XP;
        sSc = AL_MART_S;
    }
    if (sBook == "ALLHOPE")
    {
        nDC = ALLHOPE_DC;
        nFE = ALLHOPE_FE;
        nR1 = ALLHOPE_R1;
        nR2 = ALLHOPE_R2;
        nR3 = ALLHOPE_R3;
        nR4 = ALLHOPE_R4;
        nXC = ALLHOPE_XP;
        sSc = ALLHOPE_S;
    }
    if (sBook == "ANARCHY")
    {
        nDC = ANARCHY_DC;
        nFE = ANARCHY_FE;
        nR1 = ANARCHY_R1;
        nR2 = ANARCHY_R2;
        nR3 = ANARCHY_R3;
        nR4 = ANARCHY_R4;
        nXC = ANARCHY_XP;
        sSc = ANARCHY_S;
    }
    if (sBook == "ANBLAST")
    {
        nDC = ANBLAST_DC;
        nFE = ANBLAST_FE;
        nR1 = ANBLAST_R1;
        nR2 = ANBLAST_R2;
        nR3 = ANBLAST_R3;
        nR4 = ANBLAST_R4;
        nXC = ANBLAST_XP;
        sSc = ANBLAST_S;
    }
    if (sBook == "ANBLIZZ")
    {
        nDC = ANBLIZZ_DC;
        nFE = ANBLIZZ_FE;
        nR1 = ANBLIZZ_R1;
        nR2 = ANBLIZZ_R2;
        nR3 = ANBLIZZ_R3;
        nR4 = ANBLIZZ_R4;
        nXC = ANBLIZZ_XP;
        sSc = ANBLIZZ_S;
    }
    if (sBook == "ARMY_UN")
    {
        nDC = ARMY_UN_DC;
        nFE = ARMY_UN_FE;
        nR1 = ARMY_UN_R1;
        nR2 = ARMY_UN_R2;
        nR3 = ARMY_UN_R3;
        nR4 = ARMY_UN_R4;
        nXC = ARMY_UN_XP;
        sSc = ARMY_UN_S;
    }
    if (sBook == "BATTLEB")
    {
        nDC = BATTLEB_DC;
        nFE = BATTLEB_FE;
        nR1 = BATTLEB_R1;
        nR2 = BATTLEB_R2;
        nR3 = BATTLEB_R3;
        nR4 = BATTLEB_R4;
        nXC = BATTLEB_XP;
        sSc = BATTLEB_S;
    }
    if (sBook == "CELCOUN")
    {
        nDC = CELCOUN_DC;
        nFE = CELCOUN_FE;
        nR1 = CELCOUN_R1;
        nR2 = CELCOUN_R2;
        nR3 = CELCOUN_R3;
        nR4 = CELCOUN_R4;
        nXC = CELCOUN_XP;
        sSc = CELCOUN_S;
    }
    if (sBook == "CHAMP_V")
    {
        nDC = CHAMP_V_DC;
        nFE = CHAMP_V_FE;
        nR1 = CHAMP_V_R1;
        nR2 = CHAMP_V_R2;
        nR3 = CHAMP_V_R3;
        nR4 = CHAMP_V_R4;
        nXC = CHAMP_V_XP;
        sSc = CHAMP_V_S;
    }
    if (sBook == "CON_RES")
    {
        nDC = CON_RES_DC;
        nFE = CON_RES_FE;
        nR1 = CON_RES_R1;
        nR2 = CON_RES_R2;
        nR3 = CON_RES_R3;
        nR4 = CON_RES_R4;
        nXC = CON_RES_XP;
        sSc = CON_RES_S;
    }
    if (sBook == "CON_REU")
    {
        nDC = CON_REU_DC;
        nFE = CON_REU_FE;
        nR1 = CON_REU_R1;
        nR2 = CON_REU_R2;
        nR3 = CON_REU_R3;
        nR4 = CON_REU_R4;
        nXC = CON_REU_XP;
        sSc = CON_REU_S;
    }
    if (sBook == "DEADEYE")
    {
        nDC = DEADEYE_DC;
        nFE = DEADEYE_FE;
        nR1 = DEADEYE_R1;
        nR2 = DEADEYE_R2;
        nR3 = DEADEYE_R3;
        nR4 = DEADEYE_R4;
        nXC = DEADEYE_XP;
        sSc = DEADEYE_S;
    }
    if (sBook == "DIREWIN")
    {
        nDC = DIREWIN_DC;
        nFE = DIREWIN_FE;
        nR1 = DIREWIN_R1;
        nR2 = DIREWIN_R2;
        nR3 = DIREWIN_R3;
        nR4 = DIREWIN_R4;
        nXC = DIREWIN_XP;
        sSc = DIREWIN_S;
    }
    if (sBook == "DREAMSC")
    {
        nDC = DREAMSC_DC;
        nFE = DREAMSC_FE;
        nR1 = DREAMSC_R1;
        nR2 = DREAMSC_R2;
        nR3 = DREAMSC_R3;
        nR4 = DREAMSC_R4;
        nXC = DREAMSC_XP;
        sSc = DREAMSC_S;
    }
    if (sBook == "DRG_KNI")
    {
        nDC = DRG_KNI_DC;
        nFE = DRG_KNI_FE;
        nR1 = DRG_KNI_R1;
        nR2 = DRG_KNI_R2;
        nR3 = DRG_KNI_R3;
        nR4 = DRG_KNI_R4;
        nXC = DRG_KNI_XP;
        sSc = DRG_KNI_S;
    }
    if (sBook == "DTHMARK")
    {
        nDC = DTHMARK_DC;
        nFE = DTHMARK_FE;
        nR1 = DTHMARK_R1;
        nR2 = DTHMARK_R2;
        nR3 = DTHMARK_R3;
        nR4 = DTHMARK_R4;
        nXC = DTHMARK_XP;
        sSc = DTHMARK_S;
    }
    if (sBook == "DULBLAD")
    {
        nDC = DULBLAD_DC;
        nFE = DULBLAD_FE;
        nR1 = DULBLAD_R1;
        nR2 = DULBLAD_R2;
        nR3 = DULBLAD_R3;
        nR4 = DULBLAD_R4;
        nXC = DULBLAD_XP;
        sSc = DULBLAD_S;
    }
    if (sBook == "DWEO_TH")
    {
        nDC = DWEO_TH_DC;
        nFE = DWEO_TH_FE;
        nR1 = DWEO_TH_R1;
        nR2 = DWEO_TH_R2;
        nR3 = DWEO_TH_R3;
        nR4 = DWEO_TH_R4;
        nXC = DWEO_TH_XP;
        sSc = DWEO_TH_S;
    }
    if (sBook == "ENSLAVE")
    {
        nDC = ENSLAVE_DC;
        nFE = ENSLAVE_FE;
        nR1 = ENSLAVE_R1;
        nR2 = ENSLAVE_R2;
        nR3 = ENSLAVE_R3;
        nR4 = ENSLAVE_R4;
        nXC = ENSLAVE_XP;
        sSc = ENSLAVE_S;
    }
    if (sBook == "EP_M_AR")
    {
        nDC = EP_M_AR_DC;
        nFE = EP_M_AR_FE;
        nR1 = EP_M_AR_R1;
        nR2 = EP_M_AR_R2;
        nR3 = EP_M_AR_R3;
        nR4 = EP_M_AR_R4;
        nXC = EP_M_AR_XP;
        sSc = EP_M_AR_S;
    }
    if (sBook == "EP_RPLS")
    {
        nDC = EP_RPLS_DC;
        nFE = EP_RPLS_FE;
        nR1 = EP_RPLS_R1;
        nR2 = EP_RPLS_R2;
        nR3 = EP_RPLS_R3;
        nR4 = EP_RPLS_R4;
        nXC = EP_RPLS_XP;
        sSc = EP_RPLS_S;
    }
    if (sBook == "EP_SP_R")
    {
        nDC = EP_SP_R_DC;
        nFE = EP_SP_R_FE;
        nR1 = EP_SP_R_R1;
        nR2 = EP_SP_R_R2;
        nR3 = EP_SP_R_R3;
        nR4 = EP_SP_R_R4;
        nXC = EP_SP_R_XP;
        sSc = EP_SP_R_S;
    }
    if (sBook == "EP_WARD")
    {
        nDC = EP_WARD_DC;
        nFE = EP_WARD_FE;
        nR1 = EP_WARD_R1;
        nR2 = EP_WARD_R2;
        nR3 = EP_WARD_R3;
        nR4 = EP_WARD_R4;
        nXC = EP_WARD_XP;
        sSc = EP_WARD_S;
    }
    if (sBook == "ET_FREE")
    {
        nDC = ET_FREE_DC;
        nFE = ET_FREE_FE;
        nR1 = ET_FREE_R1;
        nR2 = ET_FREE_R2;
        nR3 = ET_FREE_R3;
        nR4 = ET_FREE_R4;
        nXC = ET_FREE_XP;
        sSc = ET_FREE_S;
    }
    if (sBook == "FIEND_W")
    {
        nDC = FIEND_W_DC;
        nFE = FIEND_W_FE;
        nR1 = FIEND_W_R1;
        nR2 = FIEND_W_R2;
        nR3 = FIEND_W_R3;
        nR4 = FIEND_W_R4;
        nXC = FIEND_W_XP;
        sSc = FIEND_W_S;
    }
    if (sBook == "FLEETNS")
    {
        nDC = FLEETNS_DC;
        nFE = FLEETNS_FE;
        nR1 = FLEETNS_R1;
        nR2 = FLEETNS_R2;
        nR3 = FLEETNS_R3;
        nR4 = FLEETNS_R4;
        nXC = FLEETNS_XP;
        sSc = FLEETNS_S;
    }
    if (sBook == "GEMCAGE")
    {
        nDC = GEMCAGE_DC;
        nFE = GEMCAGE_FE;
        nR1 = GEMCAGE_R1;
        nR2 = GEMCAGE_R2;
        nR3 = GEMCAGE_R3;
        nR4 = GEMCAGE_R4;
        nXC = GEMCAGE_XP;
        sSc = GEMCAGE_S;
    }
    if (sBook == "GODSMIT")
    {
        nDC = GODSMIT_DC;
        nFE = GODSMIT_FE;
        nR1 = GODSMIT_R1;
        nR2 = GODSMIT_R2;
        nR3 = GODSMIT_R3;
        nR4 = GODSMIT_R4;
        nXC = GODSMIT_XP;
        sSc = GODSMIT_S;
    }
    if (sBook == "GR_RUIN")
    {
        nDC = GR_RUIN_DC;
        nFE = GR_RUIN_FE;
        nR1 = GR_RUIN_R1;
        nR2 = GR_RUIN_R2;
        nR3 = GR_RUIN_R3;
        nR4 = GR_RUIN_R4;
        nXC = GR_RUIN_XP;
        sSc = GR_RUIN_S;
    }
    if (sBook == "GR_SP_RE")
    {
        nDC = GR_SP_RE_DC;
        nFE = GR_SP_RE_FE;
        nR1 = GR_SP_RE_R1;
        nR2 = GR_SP_RE_R2;
        nR3 = GR_SP_RE_R3;
        nR4 = GR_SP_RE_R4;
        nXC = GR_SP_RE_XP;
        sSc = GR_SP_RE_S;
    }
    if (sBook == "GR_TIME")
    {
        nDC = GR_TIME_DC;
        nFE = GR_TIME_FE;
        nR1 = GR_TIME_R1;
        nR2 = GR_TIME_R2;
        nR3 = GR_TIME_R3;
        nR4 = GR_TIME_R4;
        nXC = GR_TIME_XP;
        sSc = GR_TIME_S;
    }
    if (sBook == "HELBALL")
    {
        nDC = HELBALL_DC;
        nFE = HELBALL_FE;
        nR1 = HELBALL_R1;
        nR2 = HELBALL_R2;
        nR3 = HELBALL_R3;
        nR4 = HELBALL_R4;
        nXC = HELBALL_XP;
        sSc = HELBALL_S;
    }
    if (sBook == "HELSEND")
    {
        nDC = HELSEND_DC;
        nFE = HELSEND_FE;
        nR1 = HELSEND_R1;
        nR2 = HELSEND_R2;
        nR3 = HELSEND_R3;
        nR4 = HELSEND_R4;
        nXC = HELSEND_XP;
        sSc = HELSEND_S;
    }
    if (sBook == "HERCALL")
    {
        nDC = HERCALL_DC;
        nFE = HERCALL_FE;
        nR1 = HERCALL_R1;
        nR2 = HERCALL_R2;
        nR3 = HERCALL_R3;
        nR4 = HERCALL_R4;
        nXC = HERCALL_XP;
        sSc = HERCALL_S;
    }
    if (sBook == "HERCEMP")
    {
        nDC = HERCEMP_DC;
        nFE = HERCEMP_FE;
        nR1 = HERCEMP_R1;
        nR2 = HERCEMP_R2;
        nR3 = HERCEMP_R3;
        nR4 = HERCEMP_R4;
        nXC = HERCEMP_XP;
        sSc = HERCEMP_S;
    }
    if (sBook == "IMPENET")
    {
        nDC = IMPENET_DC;
        nFE = IMPENET_FE;
        nR1 = IMPENET_R1;
        nR2 = IMPENET_R2;
        nR3 = IMPENET_R3;
        nR4 = IMPENET_R4;
        nXC = IMPENET_XP;
        sSc = IMPENET_S;
    }
    if (sBook == "LEECH_F")
    {
        nDC = LEECH_F_DC;
        nFE = LEECH_F_FE;
        nR1 = LEECH_F_R1;
        nR2 = LEECH_F_R2;
        nR3 = LEECH_F_R3;
        nR4 = LEECH_F_R4;
        nXC = LEECH_F_XP;
        sSc = LEECH_F_S;
    }
    if (sBook == "LEG_ART")
    {
        nDC = LEG_ART_DC;
        nFE = LEG_ART_FE;
        nR1 = LEG_ART_R1;
        nR2 = LEG_ART_R2;
        nR3 = LEG_ART_R3;
        nR4 = LEG_ART_R4;
        nXC = LEG_ART_XP;
        sSc = LEG_ART_S;
    }
    if (sBook == "LIFE_FT")
    {
        nDC = LIFE_FT_DC;
        nFE = LIFE_FT_FE;
        nR1 = LIFE_FT_R1;
        nR2 = LIFE_FT_R2;
        nR3 = LIFE_FT_R3;
        nR4 = LIFE_FT_R4;
        nXC = LIFE_FT_XP;
        sSc = LIFE_FT_S;
    }
    if (sBook == "MAGMA_B")
    {
        nDC = MAGMA_B_DC;
        nFE = MAGMA_B_FE;
        nR1 = MAGMA_B_R1;
        nR2 = MAGMA_B_R2;
        nR3 = MAGMA_B_R3;
        nR4 = MAGMA_B_R4;
        nXC = MAGMA_B_XP;
        sSc = MAGMA_B_S;
    }
    if (sBook == "MASSPEN")
    {
        nDC = MASSPEN_DC;
        nFE = MASSPEN_FE;
        nR1 = MASSPEN_R1;
        nR2 = MASSPEN_R2;
        nR3 = MASSPEN_R3;
        nR4 = MASSPEN_R4;
        nXC = MASSPEN_XP;
        sSc = MASSPEN_S;
    }
    if (sBook == "MORI")
    {
        nDC = MORI_DC;
        nFE = MORI_FE;
        nR1 = MORI_R1;
        nR2 = MORI_R2;
        nR3 = MORI_R3;
        nR4 = MORI_R4;
        nXC = MORI_XP;
        sSc = MORI_S;
    }
    if (sBook == "MUMDUST")
    {
        nDC = MUMDUST_DC;
        nFE = MUMDUST_FE;
        nR1 = MUMDUST_R1;
        nR2 = MUMDUST_R2;
        nR3 = MUMDUST_R3;
        nR4 = MUMDUST_R4;
        nXC = MUMDUST_XP;
        sSc = MUMDUST_S;
    }
    if (sBook == "NAILSKY")
    {
        nDC = NAILSKY_DC;
        nFE = NAILSKY_FE;
        nR1 = NAILSKY_R1;
        nR2 = NAILSKY_R2;
        nR3 = NAILSKY_R3;
        nR4 = NAILSKY_R4;
        nXC = NAILSKY_XP;
        sSc = NAILSKY_S;
    }
    if (sBook == "NIGHTSU")
    {
        nDC = NIGHTSU_DC;
        nFE = NIGHTSU_FE;
        nR1 = NIGHTSU_R1;
        nR2 = NIGHTSU_R2;
        nR3 = NIGHTSU_R3;
        nR4 = NIGHTSU_R4;
        nXC = NIGHTSU_XP;
        sSc = NIGHTSU_S;
    }
    if (sBook == "ORDER_R")
    {
        nDC = ORDER_R_DC;
        nFE = ORDER_R_FE;
        nR1 = ORDER_R_R1;
        nR2 = ORDER_R_R2;
        nR3 = ORDER_R_R3;
        nR4 = ORDER_R_R4;
        nXC = ORDER_R_XP;
        sSc = ORDER_R_S;
    }
    if (sBook == "PATHS_B")
    {
        nDC = PATHS_B_DC;
        nFE = PATHS_B_FE;
        nR1 = PATHS_B_R1;
        nR2 = PATHS_B_R2;
        nR3 = PATHS_B_R3;
        nR4 = PATHS_B_R4;
        nXC = PATHS_B_XP;
        sSc = PATHS_B_S;
    }
    if (sBook == "PEERPEN")
    {
        nDC = PEERPEN_DC;
        nFE = PEERPEN_FE;
        nR1 = PEERPEN_R1;
        nR2 = PEERPEN_R2;
        nR3 = PEERPEN_R3;
        nR4 = PEERPEN_R4;
        nXC = PEERPEN_XP;
        sSc = PEERPEN_S;
    }
    if (sBook == "PESTIL")
    {
        nDC = PESTIL_DC;
        nFE = PESTIL_FE;
        nR1 = PESTIL_R1;
        nR2 = PESTIL_R2;
        nR3 = PESTIL_R3;
        nR4 = PESTIL_R4;
        nXC = PESTIL_XP;
        sSc = PESTIL_S;
    }
    if (sBook == "PIOUS_P")
    {
        nDC = PIOUS_P_DC;
        nFE = PIOUS_P_FE;
        nR1 = PIOUS_P_R1;
        nR2 = PIOUS_P_R2;
        nR3 = PIOUS_P_R3;
        nR4 = PIOUS_P_R4;
        nXC = PIOUS_P_XP;
        sSc = PIOUS_P_S;
    }
    if (sBook == "PLANCEL")
    {
        nDC = PLANCEL_DC;
        nFE = PLANCEL_FE;
        nR1 = PLANCEL_R1;
        nR2 = PLANCEL_R2;
        nR3 = PLANCEL_R3;
        nR4 = PLANCEL_R4;
        nXC = PLANCEL_XP;
        sSc = PLANCEL_S;
    }
    if (sBook == "PSION_S")
    {
        nDC = PSION_S_DC;
        nFE = PSION_S_FE;
        nR1 = PSION_S_R1;
        nR2 = PSION_S_R2;
        nR3 = PSION_S_R3;
        nR4 = PSION_S_R4;
        nXC = PSION_S_XP;
        sSc = PSION_S_S;
    }
    if (sBook == "RAINFIR")
    {
        nDC = RAINFIR_DC;
        nFE = RAINFIR_FE;
        nR1 = RAINFIR_R1;
        nR2 = RAINFIR_R2;
        nR3 = RAINFIR_R3;
        nR4 = RAINFIR_R4;
        nXC = RAINFIR_XP;
        sSc = RAINFIR_S;
    }
    if (sBook == "RISEN_R")
    {
        nDC = RISEN_R_DC;
        nFE = RISEN_R_FE;
        nR1 = RISEN_R_R1;
        nR2 = RISEN_R_R2;
        nR3 = RISEN_R_R3;
        nR4 = RISEN_R_R4;
        nXC = RISEN_R_XP;
        sSc = RISEN_R_S;
    }
    if (sBook == "RUIN")
    {
        nDC = RUIN_DC;
        nFE = RUIN_FE;
        nR1 = RUIN_R1;
        nR2 = RUIN_R2;
        nR3 = RUIN_R3;
        nR4 = RUIN_R4;
        nXC = RUIN_XP;
        sSc = RUIN_S;
    }
    if (sBook == "SINGSUN")
    {
        nDC = SINGSUN_DC;
        nFE = SINGSUN_FE;
        nR1 = SINGSUN_R1;
        nR2 = SINGSUN_R2;
        nR3 = SINGSUN_R3;
        nR4 = SINGSUN_R4;
        nXC = SINGSUN_XP;
        sSc = SINGSUN_S;
    }
    if (sBook == "SP_WORM")
    {
        nDC = SP_WORM_DC;
        nFE = SP_WORM_FE;
        nR1 = SP_WORM_R1;
        nR2 = SP_WORM_R2;
        nR3 = SP_WORM_R3;
        nR4 = SP_WORM_R4;
        nXC = SP_WORM_XP;
        sSc = SP_WORM_S;
    }
    if (sBook == "STORM_M")
    {
        nDC = STORM_M_DC;
        nFE = STORM_M_FE;
        nR1 = STORM_M_R1;
        nR2 = STORM_M_R2;
        nR3 = STORM_M_R3;
        nR4 = STORM_M_R4;
        nXC = STORM_M_XP;
        sSc = STORM_M_S;
    }
    if (sBook == "SUMABER")
    {
        nDC = SUMABER_DC;
        nFE = SUMABER_FE;
        nR1 = SUMABER_R1;
        nR2 = SUMABER_R2;
        nR3 = SUMABER_R3;
        nR4 = SUMABER_R4;
        nXC = SUMABER_XP;
        sSc = SUMABER_S;
    }
    if (sBook == "SUP_DIS")
    {
        nDC = SUP_DIS_DC;
        nFE = SUP_DIS_FE;
        nR1 = SUP_DIS_R1;
        nR2 = SUP_DIS_R2;
        nR3 = SUP_DIS_R3;
        nR4 = SUP_DIS_R4;
        nXC = SUP_DIS_XP;
        sSc = SUP_DIS_S;
    }
    if (sBook == "SYMRUST")
    {
        nDC = SYMRUST_DC;
        nFE = SYMRUST_FE;
        nR1 = SYMRUST_R1;
        nR2 = SYMRUST_R2;
        nR3 = SYMRUST_R3;
        nR4 = SYMRUST_R4;
        nXC = SYMRUST_XP;
        sSc = SYMRUST_S;
    }
    if (sBook == "THEWITH")
    {
        nDC = THEWITH_DC;
        nFE = THEWITH_FE;
        nR1 = THEWITH_R1;
        nR2 = THEWITH_R2;
        nR3 = THEWITH_R3;
        nR4 = THEWITH_R4;
        nXC = THEWITH_XP;
        sSc = THEWITH_S;
    }
    if (sBook == "TOLO_KW")
    {
        nDC = TOLO_KW_DC;
        nFE = TOLO_KW_FE;
        nR1 = TOLO_KW_R1;
        nR2 = TOLO_KW_R2;
        nR3 = TOLO_KW_R3;
        nR4 = TOLO_KW_R4;
        nXC = TOLO_KW_XP;
        sSc = TOLO_KW_S;
    }
    if (sBook == "TRANVIT")
    {
        nDC = TRANVIT_DC;
        nFE = TRANVIT_FE;
        nR1 = TRANVIT_R1;
        nR2 = TRANVIT_R2;
        nR3 = TRANVIT_R3;
        nR4 = TRANVIT_R4;
        nXC = TRANVIT_XP;
        sSc = TRANVIT_S;
    }
    if (sBook == "TWINF")
    {
        nDC = TWINF_DC;
        nFE = TWINF_FE;
        nR1 = TWINF_R1;
        nR2 = TWINF_R2;
        nR3 = TWINF_R3;
        nR4 = TWINF_R4;
        nXC = TWINF_XP;
        sSc = TWINF_S;
    }
    if (sBook == "UNHOLYD")
    {
        nDC = UNHOLYD_DC;
        nFE = UNHOLYD_FE;
        nR1 = UNHOLYD_R1;
        nR2 = UNHOLYD_R2;
        nR3 = UNHOLYD_R3;
        nR4 = UNHOLYD_R4;
        nXC = UNHOLYD_XP;
        sSc = UNHOLYD_S;
    }
    if (sBook == "UNIMPIN")
    {
        nDC = UNIMPIN_DC;
        nFE = UNIMPIN_FE;
        nR1 = UNIMPIN_R1;
        nR2 = UNIMPIN_R2;
        nR3 = UNIMPIN_R3;
        nR4 = UNIMPIN_R4;
        nXC = UNIMPIN_XP;
        sSc = UNIMPIN_S;
    }
    if (sBook == "UNSEENW")
    {
        nDC = UNSEENW_DC;
        nFE = UNSEENW_FE;
        nR1 = UNSEENW_R1;
        nR2 = UNSEENW_R2;
        nR3 = UNSEENW_R3;
        nR4 = UNSEENW_R4;
        nXC = UNSEENW_XP;
        sSc = UNSEENW_S;
    }
    if (sBook == "WHIP_SH")
    {
        nDC = WHIP_SH_DC;
        nFE = WHIP_SH_FE;
        nR1 = WHIP_SH_R1;
        nR2 = WHIP_SH_R2;
        nR3 = WHIP_SH_R3;
        nR4 = WHIP_SH_R4;
        nXC = WHIP_SH_XP;
        sSc = WHIP_SH_S;
    }
    // If applicable, adjust the spell's DC.
    if (FOCI_ADJUST_DC == TRUE)
        nDC -= GetDCSchoolFocusAdjustment(OBJECT_SELF, sSc);

    nGP = nDC * GOLD_MULTIPLIER;
    nXP = nGP / XP_FRACTION;
    sName = GetStringByStrRef(StringToInt
        (Get2DAString("feat", "feat", nFE)));
    sDesc = GetStringByStrRef(StringToInt
        (Get2DAString("feat", "description", nFE)));

    // Information message sent to player about the Epic Spell.
    SendMessageToPC(OBJECT_SELF, "-------------------------------------------");
    SendMessageToPC(OBJECT_SELF, "Requirements for the research of the " +
        sName + ":");
    SendMessageToPC(OBJECT_SELF, " - You must be an epic level spellcaster.");
    SendMessageToPC(OBJECT_SELF, " - The DC for you to research/cast is " +
        IntToString(nDC) + ".");
    SendMessageToPC(OBJECT_SELF, " - The XP cost for you to research is " +
        IntToString(nXP) + ".");
    SendMessageToPC(OBJECT_SELF, " - The gold cost for you to research is " +
        IntToString(nGP) + ".");
    if (nR1 != 0)
        SendMessageToPC(OBJECT_SELF, " - " + GetStringByStrRef(StringToInt
        (Get2DAString("feat", "feat", nR1))));
    if (nR2 != 0)
        SendMessageToPC(OBJECT_SELF, " - " + GetStringByStrRef(StringToInt
        (Get2DAString("feat", "feat", nR2))));
    if (nR3 != 0)
        SendMessageToPC(OBJECT_SELF, " - " + GetStringByStrRef(StringToInt
        (Get2DAString("feat", "feat", nR3))));
    if (nR4 != 0)
        SendMessageToPC(OBJECT_SELF, " - " + GetStringByStrRef(StringToInt
        (Get2DAString("feat", "feat", nR4))));
    if (nXC != 0 && XP_COSTS == TRUE)
        SendMessageToPC(OBJECT_SELF, " - Additionally, " + IntToString(nXC) +
            " experience points are spent per casting.");
    SendMessageToPC(OBJECT_SELF, " ");
    SendMessageToPC(OBJECT_SELF, "Spell Description:");
    SendMessageToPC(OBJECT_SELF, sDesc);
    SendMessageToPC(OBJECT_SELF, "-------------------------------------------");

}
