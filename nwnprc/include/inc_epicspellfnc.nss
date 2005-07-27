int GetDCForSpell(int nSpellID);
int GetFeatForSpell(int nSpellID);
int GetResearchFeatForSpell(int nSpellID);
int GetIPForSpell(int nSpellID);
int GetResearchIPForSpell(int nSpellID);
int GetCastXPForSpell(int nSpellID);
string GetSchoolForSpell(int nSpellID);
string GetNameForSpell(int nSpellID);
int GetR1ForSpell(int nSpellID);
int GetR2ForSpell(int nSpellID);
int GetR3ForSpell(int nSpellID);
int GetR4ForSpell(int nSpellID);
int GetSpellFromAbrev(string sAbrev);

/*Template
int TEST(int nSpellID)
{
    int nReturn;
    switch(nSpellID)
    {
    }
    return nReturn;
}
*/

int GetDCForSpell(int nSpellID)
{
    int nReturn;
    switch(nSpellID)
    {
        case SPELL_EPIC_A_STONE:
            nReturn = A_STONE_DC;
            break;
        case SPELL_EPIC_ACHHEEL:
            nReturn = ACHHEEL_DC;
            break;
        case SPELL_EPIC_AL_MART:
            nReturn = AL_MART_DC;
            break;
        case SPELL_EPIC_ALLHOPE:
            nReturn = ALLHOPE_DC;
            break;
        case SPELL_EPIC_ANARCHY:
            nReturn = ANARCHY_DC;
            break;
        case SPELL_EPIC_ANBLAST:
            nReturn = ANBLAST_DC;
            break;
        case SPELL_EPIC_ANBLIZZ:
            nReturn = ANBLIZZ_DC;
            break;
        case SPELL_EPIC_ARMY_UN:
            nReturn = ARMY_UN_DC;
            break;
        case SPELL_EPIC_BATTLEB:
            nReturn = BATTLEB_DC;
            break;
        case SPELL_EPIC_CELCOUN:
            nReturn = CELCOUN_DC;
            break;
        case SPELL_EPIC_CHAMP_V:
            nReturn = CHAMP_V_DC;
            break;
        case SPELL_EPIC_CON_RES:
            nReturn = CON_RES_DC;
            break;
        case SPELL_EPIC_CON_REU:
            nReturn = CON_REU_DC;
            break;
        case SPELL_EPIC_DEADEYE:
            nReturn = DEADEYE_DC;
            break;
        case SPELL_EPIC_DIREWIN:
            nReturn = DIREWIN_DC;
            break;
        case SPELL_EPIC_DREAMSC:
            nReturn = DREAMSC_DC;
            break;
        case SPELL_EPIC_DRG_KNI:
            nReturn = DRG_KNI_DC;
            break;
        case SPELL_EPIC_DTHMARK:
            nReturn = DTHMARK_DC;
            break;
        case SPELL_EPIC_DULBLAD:
            nReturn = DULBLAD_DC;
            break;
        case SPELL_EPIC_DWEO_TH:
            nReturn = DWEO_TH_DC;
            break;
        case SPELL_EPIC_ENSLAVE:
            nReturn = ENSLAVE_DC;
            break;
        case SPELL_EPIC_EP_M_AR:
            nReturn = EP_M_AR_DC;
            break;
        case SPELL_EPIC_EP_RPLS:
            nReturn = EP_RPLS_DC;
            break;
        case SPELL_EPIC_EP_SP_R:
            nReturn = EP_SP_R_DC;
            break;
        case SPELL_EPIC_EP_WARD:
            nReturn = EP_WARD_DC;
            break;
        case SPELL_EPIC_ET_FREE:
            nReturn = ET_FREE_DC;
            break;
        case SPELL_EPIC_FIEND_W:
            nReturn = FIEND_W_DC;
            break;
        case SPELL_EPIC_FLEETNS:
            nReturn = FLEETNS_DC;
            break;
        case SPELL_EPIC_GEMCAGE:
            nReturn = GEMCAGE_DC;
            break;
        case SPELL_EPIC_GODSMIT:
            nReturn = GODSMIT_DC;
            break;
        case SPELL_EPIC_GR_RUIN:
            nReturn = GR_RUIN_DC;
            break;
        case SPELL_EPIC_GR_SP_RE:
            nReturn = GR_SP_RE_DC;
            break;
        case SPELL_EPIC_GR_TIME:
            nReturn = GR_TIME_DC;
            break;
        case SPELL_EPIC_HELBALL:
            nReturn = HELBALL_DC;
            break;
        case SPELL_EPIC_HELSEND:
            nReturn = HELSEND_DC;
            break;
        case SPELL_EPIC_HERCALL:
            nReturn = HERCALL_DC;
            break;
        case SPELL_EPIC_HERCEMP:
            nReturn = HERCEMP_DC;
            break;
        case SPELL_EPIC_IMPENET:
            nReturn = IMPENET_DC;
            break;
        case SPELL_EPIC_LEECH_F:
            nReturn = LEECH_F_DC;
            break;
        case SPELL_EPIC_LEG_ART:
            nReturn = LEG_ART_DC;
            break;
        case SPELL_EPIC_LIFE_FT:
            nReturn = LIFE_FT_DC;
            break;
        case SPELL_EPIC_MAGMA_B:
            nReturn = MAGMA_B_DC;
            break;
        case SPELL_EPIC_MASSPEN:
            nReturn = MASSPEN_DC;
            break;
        case SPELL_EPIC_MORI:
            nReturn = MORI_DC;
            break;
        case SPELL_EPIC_MUMDUST:
            nReturn = MUMDUST_DC;
            break;
        case SPELL_EPIC_NAILSKY:
            nReturn = NAILSKY_DC;
            break;
        case SPELL_EPIC_NIGHTSU:
            nReturn = NIGHTSU_DC;
            break;
        case SPELL_EPIC_ORDER_R:
            nReturn = ORDER_R_DC;
            break;
        case SPELL_EPIC_PATHS_B:
            nReturn = PATHS_B_DC;
            break;
        case SPELL_EPIC_PEERPEN:
            nReturn = PEERPEN_DC;
            break;
        case SPELL_EPIC_PESTIL:
            nReturn = PESTIL_DC;
            break;
        case SPELL_EPIC_PIOUS_P:
            nReturn = PIOUS_P_DC;
            break;
        case SPELL_EPIC_PLANCEL:
            nReturn = PLANCEL_DC;
            break;
        case SPELL_EPIC_PSION_S:
            nReturn = PSION_S_DC;
            break;
        case SPELL_EPIC_RAINFIR:
            nReturn = RAINFIR_DC;
            break;
        case SPELL_EPIC_RISEN_R:
            nReturn = RISEN_R_DC;
            break;
        case SPELL_EPIC_RUINN:
            nReturn = RUIN_DC;
            break;
        case SPELL_EPIC_SINGSUN:
            nReturn = SINGSUN_DC;
            break;
        case SPELL_EPIC_SP_WORM:
            nReturn = SP_WORM_DC;
            break;
        case SPELL_EPIC_STORM_M:
            nReturn = STORM_M_DC;
            break;
        case SPELL_EPIC_SUMABER:
            nReturn = SUMABER_DC;
            break;
        case SPELL_EPIC_SUP_DIS:
            nReturn = SUP_DIS_DC;
            break;
        case SPELL_EPIC_SYMRUST:
            nReturn = SYMRUST_DC;
            break;
        case SPELL_EPIC_THEWITH:
            nReturn = THEWITH_DC;
            break;
        case SPELL_EPIC_TOLO_KW:
            nReturn = TOLO_KW_DC;
            break;
        case SPELL_EPIC_TRANVIT:
            nReturn = TRANVIT_DC;
            break;
        case SPELL_EPIC_TWINF:
            nReturn = TWINF_DC;
            break;
        case SPELL_EPIC_UNHOLYD:
            nReturn = UNHOLYD_DC;
            break;
        case SPELL_EPIC_UNIMPIN:
            nReturn = UNIMPIN_DC;
            break;
        case SPELL_EPIC_UNSEENW:
            nReturn = UNSEENW_DC;
            break;
        case SPELL_EPIC_WHIP_SH:
            nReturn = WHIP_SH_DC;
            break;
    }
    return nReturn;
}

int GetFeatForSpell(int nSpellID)
{
    int nReturn;
    switch(nSpellID)
    {
        case SPELL_EPIC_A_STONE:
            nReturn = A_STONE_FE;
            break;
        case SPELL_EPIC_ACHHEEL:
            nReturn = ACHHEEL_FE;
            break;
        case SPELL_EPIC_AL_MART:
            nReturn = AL_MART_FE;
            break;
        case SPELL_EPIC_ALLHOPE:
            nReturn = ALLHOPE_FE;
            break;
        case SPELL_EPIC_ANARCHY:
            nReturn = ANARCHY_FE;
            break;
        case SPELL_EPIC_ANBLAST:
            nReturn = ANBLAST_FE;
            break;
        case SPELL_EPIC_ANBLIZZ:
            nReturn = ANBLIZZ_FE;
            break;
        case SPELL_EPIC_ARMY_UN:
            nReturn = ARMY_UN_FE;
            break;
        case SPELL_EPIC_BATTLEB:
            nReturn = BATTLEB_FE;
            break;
        case SPELL_EPIC_CELCOUN:
            nReturn = CELCOUN_FE;
            break;
        case SPELL_EPIC_CHAMP_V:
            nReturn = CHAMP_V_FE;
            break;
        case SPELL_EPIC_CON_RES:
            nReturn = CON_RES_FE;
            break;
        case SPELL_EPIC_CON_REU:
            nReturn = CON_REU_FE;
            break;
        case SPELL_EPIC_DEADEYE:
            nReturn = DEADEYE_FE;
            break;
        case SPELL_EPIC_DIREWIN:
            nReturn = DIREWIN_FE;
            break;
        case SPELL_EPIC_DREAMSC:
            nReturn = DREAMSC_FE;
            break;
        case SPELL_EPIC_DRG_KNI:
            nReturn = DRG_KNI_FE;
            break;
        case SPELL_EPIC_DTHMARK:
            nReturn = DTHMARK_FE;
            break;
        case SPELL_EPIC_DULBLAD:
            nReturn = DULBLAD_FE;
            break;
        case SPELL_EPIC_DWEO_TH:
            nReturn = DWEO_TH_FE;
            break;
        case SPELL_EPIC_ENSLAVE:
            nReturn = ENSLAVE_FE;
            break;
        case SPELL_EPIC_EP_M_AR:
            nReturn = EP_M_AR_FE;
            break;
        case SPELL_EPIC_EP_RPLS:
            nReturn = EP_RPLS_FE;
            break;
        case SPELL_EPIC_EP_SP_R:
            nReturn = EP_SP_R_FE;
            break;
        case SPELL_EPIC_EP_WARD:
            nReturn = EP_WARD_FE;
            break;
        case SPELL_EPIC_ET_FREE:
            nReturn = ET_FREE_FE;
            break;
        case SPELL_EPIC_FIEND_W:
            nReturn = FIEND_W_FE;
            break;
        case SPELL_EPIC_FLEETNS:
            nReturn = FLEETNS_FE;
            break;
        case SPELL_EPIC_GEMCAGE:
            nReturn = GEMCAGE_FE;
            break;
        case SPELL_EPIC_GODSMIT:
            nReturn = GODSMIT_FE;
            break;
        case SPELL_EPIC_GR_RUIN:
            nReturn = GR_RUIN_FE;
            break;
        case SPELL_EPIC_GR_SP_RE:
            nReturn = GR_SP_RE_FE;
            break;
        case SPELL_EPIC_GR_TIME:
            nReturn = GR_TIME_FE;
            break;
        case SPELL_EPIC_HELBALL:
            nReturn = HELBALL_FE;
            break;
        case SPELL_EPIC_HELSEND:
            nReturn = HELSEND_FE;
            break;
        case SPELL_EPIC_HERCALL:
            nReturn = HERCALL_FE;
            break;
        case SPELL_EPIC_HERCEMP:
            nReturn = HERCEMP_FE;
            break;
        case SPELL_EPIC_IMPENET:
            nReturn = IMPENET_FE;
            break;
        case SPELL_EPIC_LEECH_F:
            nReturn = LEECH_F_FE;
            break;
        case SPELL_EPIC_LEG_ART:
            nReturn = LEG_ART_FE;
            break;
        case SPELL_EPIC_LIFE_FT:
            nReturn = LIFE_FT_FE;
            break;
        case SPELL_EPIC_MAGMA_B:
            nReturn = MAGMA_B_FE;
            break;
        case SPELL_EPIC_MASSPEN:
            nReturn = MASSPEN_FE;
            break;
        case SPELL_EPIC_MORI:
            nReturn = MORI_FE;
            break;
        case SPELL_EPIC_MUMDUST:
            nReturn = MUMDUST_FE;
            break;
        case SPELL_EPIC_NAILSKY:
            nReturn = NAILSKY_FE;
            break;
        case SPELL_EPIC_NIGHTSU:
            nReturn = NIGHTSU_FE;
            break;
        case SPELL_EPIC_ORDER_R:
            nReturn = ORDER_R_FE;
            break;
        case SPELL_EPIC_PATHS_B:
            nReturn = PATHS_B_FE;
            break;
        case SPELL_EPIC_PEERPEN:
            nReturn = PEERPEN_FE;
            break;
        case SPELL_EPIC_PESTIL:
            nReturn = PESTIL_FE;
            break;
        case SPELL_EPIC_PIOUS_P:
            nReturn = PIOUS_P_FE;
            break;
        case SPELL_EPIC_PLANCEL:
            nReturn = PLANCEL_FE;
            break;
        case SPELL_EPIC_PSION_S:
            nReturn = PSION_S_FE;
            break;
        case SPELL_EPIC_RAINFIR:
            nReturn = RAINFIR_FE;
            break;
        case SPELL_EPIC_RISEN_R:
            nReturn = RISEN_R_FE;
            break;
        case SPELL_EPIC_RUINN:
            nReturn = RUIN_FE;
            break;
        case SPELL_EPIC_SINGSUN:
            nReturn = SINGSUN_FE;
            break;
        case SPELL_EPIC_SP_WORM:
            nReturn = SP_WORM_FE;
            break;
        case SPELL_EPIC_STORM_M:
            nReturn = STORM_M_FE;
            break;
        case SPELL_EPIC_SUMABER:
            nReturn = SUMABER_FE;
            break;
        case SPELL_EPIC_SUP_DIS:
            nReturn = SUP_DIS_FE;
            break;
        case SPELL_EPIC_SYMRUST:
            nReturn = SYMRUST_FE;
            break;
        case SPELL_EPIC_THEWITH:
            nReturn = THEWITH_FE;
            break;
        case SPELL_EPIC_TOLO_KW:
            nReturn = TOLO_KW_FE;
            break;
        case SPELL_EPIC_TRANVIT:
            nReturn = TRANVIT_FE;
            break;
        case SPELL_EPIC_TWINF:
            nReturn = TWINF_FE;
            break;
        case SPELL_EPIC_UNHOLYD:
            nReturn = UNHOLYD_FE;
            break;
        case SPELL_EPIC_UNIMPIN:
            nReturn = UNIMPIN_FE;
            break;
        case SPELL_EPIC_UNSEENW:
            nReturn = UNSEENW_FE;
            break;
        case SPELL_EPIC_WHIP_SH:
            nReturn = WHIP_SH_FE;
            break;
    }
    return nReturn;
}

int GetResearchFeatForSpell(int nSpellID)
{
    int nReturn;
    switch(nSpellID)
    {
        case SPELL_EPIC_A_STONE:
            nReturn = R_A_STONE_FE;
            break;
        case SPELL_EPIC_ACHHEEL:
            nReturn = R_ACHHEEL_FE;
            break;
        case SPELL_EPIC_AL_MART:
            nReturn = R_AL_MART_FE;
            break;
        case SPELL_EPIC_ALLHOPE:
            nReturn = R_ALLHOPE_FE;
            break;
        case SPELL_EPIC_ANARCHY:
            nReturn = R_ANARCHY_FE;
            break;
        case SPELL_EPIC_ANBLAST:
            nReturn = R_ANBLAST_FE;
            break;
        case SPELL_EPIC_ANBLIZZ:
            nReturn = R_ANBLIZZ_FE;
            break;
        case SPELL_EPIC_ARMY_UN:
            nReturn = R_ARMY_UN_FE;
            break;
        case SPELL_EPIC_BATTLEB:
            nReturn = R_BATTLEB_FE;
            break;
        case SPELL_EPIC_CELCOUN:
            nReturn = R_CELCOUN_FE;
            break;
        case SPELL_EPIC_CHAMP_V:
            nReturn = R_CHAMP_V_FE;
            break;
        case SPELL_EPIC_CON_RES:
            nReturn = R_CON_RES_FE;
            break;
        case SPELL_EPIC_CON_REU:
            nReturn = R_CON_REU_FE;
            break;
        case SPELL_EPIC_DEADEYE:
            nReturn = R_DEADEYE_FE;
            break;
        case SPELL_EPIC_DIREWIN:
            nReturn = R_DIREWIN_FE;
            break;
        case SPELL_EPIC_DREAMSC:
            nReturn = R_DREAMSC_FE;
            break;
        case SPELL_EPIC_DRG_KNI:
            nReturn = R_DRG_KNI_FE;
            break;
        case SPELL_EPIC_DTHMARK:
            nReturn = R_DTHMARK_FE;
            break;
        case SPELL_EPIC_DULBLAD:
            nReturn = R_DULBLAD_FE;
            break;
        case SPELL_EPIC_DWEO_TH:
            nReturn = R_DWEO_TH_FE;
            break;
        case SPELL_EPIC_ENSLAVE:
            nReturn = R_ENSLAVE_FE;
            break;
        case SPELL_EPIC_EP_M_AR:
            nReturn = R_EP_M_AR_FE;
            break;
        case SPELL_EPIC_EP_RPLS:
            nReturn = R_EP_RPLS_FE;
            break;
        case SPELL_EPIC_EP_SP_R:
            nReturn = R_EP_SP_R_FE;
            break;
        case SPELL_EPIC_EP_WARD:
            nReturn = R_EP_WARD_FE;
            break;
        case SPELL_EPIC_ET_FREE:
            nReturn = R_ET_FREE_FE;
            break;
        case SPELL_EPIC_FIEND_W:
            nReturn = R_FIEND_W_FE;
            break;
        case SPELL_EPIC_FLEETNS:
            nReturn = R_FLEETNS_FE;
            break;
        case SPELL_EPIC_GEMCAGE:
            nReturn = R_GEMCAGE_FE;
            break;
        case SPELL_EPIC_GODSMIT:
            nReturn = R_GODSMIT_FE;
            break;
        case SPELL_EPIC_GR_RUIN:
            nReturn = R_GR_RUIN_FE;
            break;
        case SPELL_EPIC_GR_SP_RE:
            nReturn = R_GR_SP_RE_FE;
            break;
        case SPELL_EPIC_GR_TIME:
            nReturn = R_GR_TIME_FE;
            break;
        case SPELL_EPIC_HELBALL:
            nReturn = R_HELBALL_FE;
            break;
        case SPELL_EPIC_HELSEND:
            nReturn = R_HELSEND_FE;
            break;
        case SPELL_EPIC_HERCALL:
            nReturn = R_HERCALL_FE;
            break;
        case SPELL_EPIC_HERCEMP:
            nReturn = R_HERCEMP_FE;
            break;
        case SPELL_EPIC_IMPENET:
            nReturn = R_IMPENET_FE;
            break;
        case SPELL_EPIC_LEECH_F:
            nReturn = R_LEECH_F_FE;
            break;
        case SPELL_EPIC_LEG_ART:
            nReturn = R_LEG_ART_FE;
            break;
        case SPELL_EPIC_LIFE_FT:
            nReturn = R_LIFE_FT_FE;
            break;
        case SPELL_EPIC_MAGMA_B:
            nReturn = R_MAGMA_B_FE;
            break;
        case SPELL_EPIC_MASSPEN:
            nReturn = R_MASSPEN_FE;
            break;
        case SPELL_EPIC_MORI:
            nReturn = R_MORI_FE;
            break;
        case SPELL_EPIC_MUMDUST:
            nReturn = R_MUMDUST_FE;
            break;
        case SPELL_EPIC_NAILSKY:
            nReturn = R_NAILSKY_FE;
            break;
        case SPELL_EPIC_NIGHTSU:
            nReturn = R_NIGHTSU_FE;
            break;
        case SPELL_EPIC_ORDER_R:
            nReturn = R_ORDER_R_FE;
            break;
        case SPELL_EPIC_PATHS_B:
            nReturn = R_PATHS_B_FE;
            break;
        case SPELL_EPIC_PEERPEN:
            nReturn = R_PEERPEN_FE;
            break;
        case SPELL_EPIC_PESTIL:
            nReturn = R_PESTIL_FE;
            break;
        case SPELL_EPIC_PIOUS_P:
            nReturn = R_PIOUS_P_FE;
            break;
        case SPELL_EPIC_PLANCEL:
            nReturn = R_PLANCEL_FE;
            break;
        case SPELL_EPIC_PSION_S:
            nReturn = R_PSION_S_FE;
            break;
        case SPELL_EPIC_RAINFIR:
            nReturn = R_RAINFIR_FE;
            break;
        case SPELL_EPIC_RISEN_R:
            nReturn = R_RISEN_R_FE;
            break;
        case SPELL_EPIC_RUINN:
            nReturn = R_RUIN_FE;
            break;
        case SPELL_EPIC_SINGSUN:
            nReturn = R_SINGSUN_FE;
            break;
        case SPELL_EPIC_SP_WORM:
            nReturn = R_SP_WORM_FE;
            break;
        case SPELL_EPIC_STORM_M:
            nReturn = R_STORM_M_FE;
            break;
        case SPELL_EPIC_SUMABER:
            nReturn = R_SUMABER_FE;
            break;
        case SPELL_EPIC_SUP_DIS:
            nReturn = R_SUP_DIS_FE;
            break;
        case SPELL_EPIC_SYMRUST:
            nReturn = R_SYMRUST_FE;
            break;
        case SPELL_EPIC_THEWITH:
            nReturn = R_THEWITH_FE;
            break;
        case SPELL_EPIC_TOLO_KW:
            nReturn = R_TOLO_KW_FE;
            break;
        case SPELL_EPIC_TRANVIT:
            nReturn = R_TRANVIT_FE;
            break;
        case SPELL_EPIC_TWINF:
            nReturn = R_TWINF_FE;
            break;
        case SPELL_EPIC_UNHOLYD:
            nReturn = R_UNHOLYD_FE;
            break;
        case SPELL_EPIC_UNIMPIN:
            nReturn = R_UNIMPIN_FE;
            break;
        case SPELL_EPIC_UNSEENW:
            nReturn = R_UNSEENW_FE;
            break;
        case SPELL_EPIC_WHIP_SH:
            nReturn = R_WHIP_SH_FE;
            break;
    }
    return nReturn;
}

int GetIPForSpell(int nSpellID)
{
    int nReturn;
    switch(nSpellID)
    {
        case SPELL_EPIC_A_STONE:
            nReturn = A_STONE_IP;
            break;
        case SPELL_EPIC_ACHHEEL:
            nReturn = ACHHEEL_IP;
            break;
        case SPELL_EPIC_AL_MART:
            nReturn = AL_MART_IP;
            break;
        case SPELL_EPIC_ALLHOPE:
            nReturn = ALLHOPE_IP;
            break;
        case SPELL_EPIC_ANARCHY:
            nReturn = ANARCHY_IP;
            break;
        case SPELL_EPIC_ANBLAST:
            nReturn = ANBLAST_IP;
            break;
        case SPELL_EPIC_ANBLIZZ:
            nReturn = ANBLIZZ_IP;
            break;
        case SPELL_EPIC_ARMY_UN:
            nReturn = ARMY_UN_IP;
            break;
        case SPELL_EPIC_BATTLEB:
            nReturn = BATTLEB_IP;
            break;
        case SPELL_EPIC_CELCOUN:
            nReturn = CELCOUN_IP;
            break;
        case SPELL_EPIC_CHAMP_V:
            nReturn = CHAMP_V_IP;
            break;
        case SPELL_EPIC_CON_RES:
            nReturn = CON_RES_IP;
            break;
        case SPELL_EPIC_CON_REU:
            nReturn = CON_REU_IP;
            break;
        case SPELL_EPIC_DEADEYE:
            nReturn = DEADEYE_IP;
            break;
        case SPELL_EPIC_DIREWIN:
            nReturn = DIREWIN_IP;
            break;
        case SPELL_EPIC_DREAMSC:
            nReturn = DREAMSC_IP;
            break;
        case SPELL_EPIC_DRG_KNI:
            nReturn = DRG_KNI_IP;
            break;
        case SPELL_EPIC_DTHMARK:
            nReturn = DTHMARK_IP;
            break;
        case SPELL_EPIC_DULBLAD:
            nReturn = DULBLAD_IP;
            break;
        case SPELL_EPIC_DWEO_TH:
            nReturn = DWEO_TH_IP;
            break;
        case SPELL_EPIC_ENSLAVE:
            nReturn = ENSLAVE_IP;
            break;
        case SPELL_EPIC_EP_M_AR:
            nReturn = EP_M_AR_IP;
            break;
        case SPELL_EPIC_EP_RPLS:
            nReturn = EP_RPLS_IP;
            break;
        case SPELL_EPIC_EP_SP_R:
            nReturn = EP_SP_R_IP;
            break;
        case SPELL_EPIC_EP_WARD:
            nReturn = EP_WARD_IP;
            break;
        case SPELL_EPIC_ET_FREE:
            nReturn = ET_FREE_IP;
            break;
        case SPELL_EPIC_FIEND_W:
            nReturn = FIEND_W_IP;
            break;
        case SPELL_EPIC_FLEETNS:
            nReturn = FLEETNS_IP;
            break;
        case SPELL_EPIC_GEMCAGE:
            nReturn = GEMCAGE_IP;
            break;
        case SPELL_EPIC_GODSMIT:
            nReturn = GODSMIT_IP;
            break;
        case SPELL_EPIC_GR_RUIN:
            nReturn = GR_RUIN_IP;
            break;
        case SPELL_EPIC_GR_SP_RE:
            nReturn = GR_SP_RE_IP;
            break;
        case SPELL_EPIC_GR_TIME:
            nReturn = GR_TIME_IP;
            break;
        case SPELL_EPIC_HELBALL:
            nReturn = HELBALL_IP;
            break;
        case SPELL_EPIC_HELSEND:
            nReturn = HELSEND_IP;
            break;
        case SPELL_EPIC_HERCALL:
            nReturn = HERCALL_IP;
            break;
        case SPELL_EPIC_HERCEMP:
            nReturn = HERCEMP_IP;
            break;
        case SPELL_EPIC_IMPENET:
            nReturn = IMPENET_IP;
            break;
        case SPELL_EPIC_LEECH_F:
            nReturn = LEECH_F_IP;
            break;
        case SPELL_EPIC_LEG_ART:
            nReturn = LEG_ART_IP;
            break;
        case SPELL_EPIC_LIFE_FT:
            nReturn = LIFE_FT_IP;
            break;
        case SPELL_EPIC_MAGMA_B:
            nReturn = MAGMA_B_IP;
            break;
        case SPELL_EPIC_MASSPEN:
            nReturn = MASSPEN_IP;
            break;
        case SPELL_EPIC_MORI:
            nReturn = MORI_IP;
            break;
        case SPELL_EPIC_MUMDUST:
            nReturn = MUMDUST_IP;
            break;
        case SPELL_EPIC_NAILSKY:
            nReturn = NAILSKY_IP;
            break;
        case SPELL_EPIC_NIGHTSU:
            nReturn = NIGHTSU_IP;
            break;
        case SPELL_EPIC_ORDER_R:
            nReturn = ORDER_R_IP;
            break;
        case SPELL_EPIC_PATHS_B:
            nReturn = PATHS_B_IP;
            break;
        case SPELL_EPIC_PEERPEN:
            nReturn = PEERPEN_IP;
            break;
        case SPELL_EPIC_PESTIL:
            nReturn = PESTIL_IP;
            break;
        case SPELL_EPIC_PIOUS_P:
            nReturn = PIOUS_P_IP;
            break;
        case SPELL_EPIC_PLANCEL:
            nReturn = PLANCEL_IP;
            break;
        case SPELL_EPIC_PSION_S:
            nReturn = PSION_S_IP;
            break;
        case SPELL_EPIC_RAINFIR:
            nReturn = RAINFIR_IP;
            break;
        case SPELL_EPIC_RISEN_R:
            nReturn = RISEN_R_IP;
            break;
        case SPELL_EPIC_RUINN:
            nReturn = RUIN_IP;
            break;
        case SPELL_EPIC_SINGSUN:
            nReturn = SINGSUN_IP;
            break;
        case SPELL_EPIC_SP_WORM:
            nReturn = SP_WORM_IP;
            break;
        case SPELL_EPIC_STORM_M:
            nReturn = STORM_M_IP;
            break;
        case SPELL_EPIC_SUMABER:
            nReturn = SUMABER_IP;
            break;
        case SPELL_EPIC_SUP_DIS:
            nReturn = SUP_DIS_IP;
            break;
        case SPELL_EPIC_SYMRUST:
            nReturn = SYMRUST_IP;
            break;
        case SPELL_EPIC_THEWITH:
            nReturn = THEWITH_IP;
            break;
        case SPELL_EPIC_TOLO_KW:
            nReturn = TOLO_KW_IP;
            break;
        case SPELL_EPIC_TRANVIT:
            nReturn = TRANVIT_IP;
            break;
        case SPELL_EPIC_TWINF:
            nReturn = TWINF_IP;
            break;
        case SPELL_EPIC_UNHOLYD:
            nReturn = UNHOLYD_IP;
            break;
        case SPELL_EPIC_UNIMPIN:
            nReturn = UNIMPIN_IP;
            break;
        case SPELL_EPIC_UNSEENW:
            nReturn = UNSEENW_IP;
            break;
        case SPELL_EPIC_WHIP_SH:
            nReturn = WHIP_SH_IP;
            break;
    }
    return nReturn;
}

int GetResearchIPForSpell(int nSpellID)
{
    int nReturn;
    switch(nSpellID)
    {
            case SPELL_EPIC_A_STONE:
            nReturn = R_A_STONE_IP;
            break;
        case SPELL_EPIC_ACHHEEL:
            nReturn = R_ACHHEEL_IP;
            break;
        case SPELL_EPIC_AL_MART:
            nReturn = R_AL_MART_IP;
            break;
        case SPELL_EPIC_ALLHOPE:
            nReturn = R_ALLHOPE_IP;
            break;
        case SPELL_EPIC_ANARCHY:
            nReturn = R_ANARCHY_IP;
            break;
        case SPELL_EPIC_ANBLAST:
            nReturn = R_ANBLAST_IP;
            break;
        case SPELL_EPIC_ANBLIZZ:
            nReturn = R_ANBLIZZ_IP;
            break;
        case SPELL_EPIC_ARMY_UN:
            nReturn = R_ARMY_UN_IP;
            break;
        case SPELL_EPIC_BATTLEB:
            nReturn = R_BATTLEB_IP;
            break;
        case SPELL_EPIC_CELCOUN:
            nReturn = R_CELCOUN_IP;
            break;
        case SPELL_EPIC_CHAMP_V:
            nReturn = R_CHAMP_V_IP;
            break;
        case SPELL_EPIC_CON_RES:
            nReturn = R_CON_RES_IP;
            break;
        case SPELL_EPIC_CON_REU:
            nReturn = R_CON_REU_IP;
            break;
        case SPELL_EPIC_DEADEYE:
            nReturn = R_DEADEYE_IP;
            break;
        case SPELL_EPIC_DIREWIN:
            nReturn = R_DIREWIN_IP;
            break;
        case SPELL_EPIC_DREAMSC:
            nReturn = R_DREAMSC_IP;
            break;
        case SPELL_EPIC_DRG_KNI:
            nReturn = R_DRG_KNI_IP;
            break;
        case SPELL_EPIC_DTHMARK:
            nReturn = R_DTHMARK_IP;
            break;
        case SPELL_EPIC_DULBLAD:
            nReturn = R_DULBLAD_IP;
            break;
        case SPELL_EPIC_DWEO_TH:
            nReturn = R_DWEO_TH_IP;
            break;
        case SPELL_EPIC_ENSLAVE:
            nReturn = R_ENSLAVE_IP;
            break;
        case SPELL_EPIC_EP_M_AR:
            nReturn = R_EP_M_AR_IP;
            break;
        case SPELL_EPIC_EP_RPLS:
            nReturn = R_EP_RPLS_IP;
            break;
        case SPELL_EPIC_EP_SP_R:
            nReturn = R_EP_SP_R_IP;
            break;
        case SPELL_EPIC_EP_WARD:
            nReturn = R_EP_WARD_IP;
            break;
        case SPELL_EPIC_ET_FREE:
            nReturn = R_ET_FREE_IP;
            break;
        case SPELL_EPIC_FIEND_W:
            nReturn = R_FIEND_W_IP;
            break;
        case SPELL_EPIC_FLEETNS:
            nReturn = R_FLEETNS_IP;
            break;
        case SPELL_EPIC_GEMCAGE:
            nReturn = R_GEMCAGE_IP;
            break;
        case SPELL_EPIC_GODSMIT:
            nReturn = R_GODSMIT_IP;
            break;
        case SPELL_EPIC_GR_RUIN:
            nReturn = R_GR_RUIN_IP;
            break;
        case SPELL_EPIC_GR_SP_RE:
            nReturn = R_GR_SP_RE_IP;
            break;
        case SPELL_EPIC_GR_TIME:
            nReturn = R_GR_TIME_IP;
            break;
        case SPELL_EPIC_HELBALL:
            nReturn = R_HELBALL_IP;
            break;
        case SPELL_EPIC_HELSEND:
            nReturn = R_HELSEND_IP;
            break;
        case SPELL_EPIC_HERCALL:
            nReturn = R_HERCALL_IP;
            break;
        case SPELL_EPIC_HERCEMP:
            nReturn = R_HERCEMP_IP;
            break;
        case SPELL_EPIC_IMPENET:
            nReturn = R_IMPENET_IP;
            break;
        case SPELL_EPIC_LEECH_F:
            nReturn = R_LEECH_F_IP;
            break;
        case SPELL_EPIC_LEG_ART:
            nReturn = R_LEG_ART_IP;
            break;
        case SPELL_EPIC_LIFE_FT:
            nReturn = R_LIFE_FT_IP;
            break;
        case SPELL_EPIC_MAGMA_B:
            nReturn = R_MAGMA_B_IP;
            break;
        case SPELL_EPIC_MASSPEN:
            nReturn = R_MASSPEN_IP;
            break;
        case SPELL_EPIC_MORI:
            nReturn = R_MORI_IP;
            break;
        case SPELL_EPIC_MUMDUST:
            nReturn = R_MUMDUST_IP;
            break;
        case SPELL_EPIC_NAILSKY:
            nReturn = R_NAILSKY_IP;
            break;
        case SPELL_EPIC_NIGHTSU:
            nReturn = R_NIGHTSU_IP;
            break;
        case SPELL_EPIC_ORDER_R:
            nReturn = R_ORDER_R_IP;
            break;
        case SPELL_EPIC_PATHS_B:
            nReturn = R_PATHS_B_IP;
            break;
        case SPELL_EPIC_PEERPEN:
            nReturn = R_PEERPEN_IP;
            break;
        case SPELL_EPIC_PESTIL:
            nReturn = R_PESTIL_IP;
            break;
        case SPELL_EPIC_PIOUS_P:
            nReturn = R_PIOUS_P_IP;
            break;
        case SPELL_EPIC_PLANCEL:
            nReturn = R_PLANCEL_IP;
            break;
        case SPELL_EPIC_PSION_S:
            nReturn = R_PSION_S_IP;
            break;
        case SPELL_EPIC_RAINFIR:
            nReturn = R_RAINFIR_IP;
            break;
        case SPELL_EPIC_RISEN_R:
            nReturn = R_RISEN_R_IP;
            break;
        case SPELL_EPIC_RUINN:
            nReturn = R_RUIN_IP;
            break;
        case SPELL_EPIC_SINGSUN:
            nReturn = R_SINGSUN_IP;
            break;
        case SPELL_EPIC_SP_WORM:
            nReturn = R_SP_WORM_IP;
            break;
        case SPELL_EPIC_STORM_M:
            nReturn = R_STORM_M_IP;
            break;
        case SPELL_EPIC_SUMABER:
            nReturn = R_SUMABER_IP;
            break;
        case SPELL_EPIC_SUP_DIS:
            nReturn = R_SUP_DIS_IP;
            break;
        case SPELL_EPIC_SYMRUST:
            nReturn = R_SYMRUST_IP;
            break;
        case SPELL_EPIC_THEWITH:
            nReturn = R_THEWITH_IP;
            break;
        case SPELL_EPIC_TOLO_KW:
            nReturn = R_TOLO_KW_IP;
            break;
        case SPELL_EPIC_TRANVIT:
            nReturn = R_TRANVIT_IP;
            break;
        case SPELL_EPIC_TWINF:
            nReturn = R_TWINF_IP;
            break;
        case SPELL_EPIC_UNHOLYD:
            nReturn = R_UNHOLYD_IP;
            break;
        case SPELL_EPIC_UNIMPIN:
            nReturn = R_UNIMPIN_IP;
            break;
        case SPELL_EPIC_UNSEENW:
            nReturn = R_UNSEENW_IP;
            break;
        case SPELL_EPIC_WHIP_SH:
            nReturn = R_WHIP_SH_IP;
            break;
    }
    return nReturn;
}

int GetCastXPForSpell(int nSpellID)
{
    int nReturn;
    switch(nSpellID)
    {
        case SPELL_EPIC_A_STONE:
            nReturn = A_STONE_XP;
            break;
        case SPELL_EPIC_ACHHEEL:
            nReturn = ACHHEEL_XP;
            break;
        case SPELL_EPIC_AL_MART:
            nReturn = AL_MART_XP;
            break;
        case SPELL_EPIC_ALLHOPE:
            nReturn = ALLHOPE_XP;
            break;
        case SPELL_EPIC_ANARCHY:
            nReturn = ANARCHY_XP;
            break;
        case SPELL_EPIC_ANBLAST:
            nReturn = ANBLAST_XP;
            break;
        case SPELL_EPIC_ANBLIZZ:
            nReturn = ANBLIZZ_XP;
            break;
        case SPELL_EPIC_ARMY_UN:
            nReturn = ARMY_UN_XP;
            break;
        case SPELL_EPIC_BATTLEB:
            nReturn = BATTLEB_XP;
            break;
        case SPELL_EPIC_CELCOUN:
            nReturn = CELCOUN_XP;
            break;
        case SPELL_EPIC_CHAMP_V:
            nReturn = CHAMP_V_XP;
            break;
        case SPELL_EPIC_CON_RES:
            nReturn = CON_RES_XP;
            break;
        case SPELL_EPIC_CON_REU:
            nReturn = CON_REU_XP;
            break;
        case SPELL_EPIC_DEADEYE:
            nReturn = DEADEYE_XP;
            break;
        case SPELL_EPIC_DIREWIN:
            nReturn = DIREWIN_XP;
            break;
        case SPELL_EPIC_DREAMSC:
            nReturn = DREAMSC_XP;
            break;
        case SPELL_EPIC_DRG_KNI:
            nReturn = DRG_KNI_XP;
            break;
        case SPELL_EPIC_DTHMARK:
            nReturn = DTHMARK_XP;
            break;
        case SPELL_EPIC_DULBLAD:
            nReturn = DULBLAD_XP;
            break;
        case SPELL_EPIC_DWEO_TH:
            nReturn = DWEO_TH_XP;
            break;
        case SPELL_EPIC_ENSLAVE:
            nReturn = ENSLAVE_XP;
            break;
        case SPELL_EPIC_EP_M_AR:
            nReturn = EP_M_AR_XP;
            break;
        case SPELL_EPIC_EP_RPLS:
            nReturn = EP_RPLS_XP;
            break;
        case SPELL_EPIC_EP_SP_R:
            nReturn = EP_SP_R_XP;
            break;
        case SPELL_EPIC_EP_WARD:
            nReturn = EP_WARD_XP;
            break;
        case SPELL_EPIC_ET_FREE:
            nReturn = ET_FREE_XP;
            break;
        case SPELL_EPIC_FIEND_W:
            nReturn = FIEND_W_XP;
            break;
        case SPELL_EPIC_FLEETNS:
            nReturn = FLEETNS_XP;
            break;
        case SPELL_EPIC_GEMCAGE:
            nReturn = GEMCAGE_XP;
            break;
        case SPELL_EPIC_GODSMIT:
            nReturn = GODSMIT_XP;
            break;
        case SPELL_EPIC_GR_RUIN:
            nReturn = GR_RUIN_XP;
            break;
        case SPELL_EPIC_GR_SP_RE:
            nReturn = GR_SP_RE_XP;
            break;
        case SPELL_EPIC_GR_TIME:
            nReturn = GR_TIME_XP;
            break;
        case SPELL_EPIC_HELBALL:
            nReturn = HELBALL_XP;
            break;
        case SPELL_EPIC_HELSEND:
            nReturn = HELSEND_XP;
            break;
        case SPELL_EPIC_HERCALL:
            nReturn = HERCALL_XP;
            break;
        case SPELL_EPIC_HERCEMP:
            nReturn = HERCEMP_XP;
            break;
        case SPELL_EPIC_IMPENET:
            nReturn = IMPENET_XP;
            break;
        case SPELL_EPIC_LEECH_F:
            nReturn = LEECH_F_XP;
            break;
        case SPELL_EPIC_LEG_ART:
            nReturn = LEG_ART_XP;
            break;
        case SPELL_EPIC_LIFE_FT:
            nReturn = LIFE_FT_XP;
            break;
        case SPELL_EPIC_MAGMA_B:
            nReturn = MAGMA_B_XP;
            break;
        case SPELL_EPIC_MASSPEN:
            nReturn = MASSPEN_XP;
            break;
        case SPELL_EPIC_MORI:
            nReturn = MORI_XP;
            break;
        case SPELL_EPIC_MUMDUST:
            nReturn = MUMDUST_XP;
            break;
        case SPELL_EPIC_NAILSKY:
            nReturn = NAILSKY_XP;
            break;
        case SPELL_EPIC_NIGHTSU:
            nReturn = NIGHTSU_XP;
            break;
        case SPELL_EPIC_ORDER_R:
            nReturn = ORDER_R_XP;
            break;
        case SPELL_EPIC_PATHS_B:
            nReturn = PATHS_B_XP;
            break;
        case SPELL_EPIC_PEERPEN:
            nReturn = PEERPEN_XP;
            break;
        case SPELL_EPIC_PESTIL:
            nReturn = PESTIL_XP;
            break;
        case SPELL_EPIC_PIOUS_P:
            nReturn = PIOUS_P_XP;
            break;
        case SPELL_EPIC_PLANCEL:
            nReturn = PLANCEL_XP;
            break;
        case SPELL_EPIC_PSION_S:
            nReturn = PSION_S_XP;
            break;
        case SPELL_EPIC_RAINFIR:
            nReturn = RAINFIR_XP;
            break;
        case SPELL_EPIC_RISEN_R:
            nReturn = RISEN_R_XP;
            break;
        case SPELL_EPIC_RUINN:
            nReturn = RUIN_XP;
            break;
        case SPELL_EPIC_SINGSUN:
            nReturn = SINGSUN_XP;
            break;
        case SPELL_EPIC_SP_WORM:
            nReturn = SP_WORM_XP;
            break;
        case SPELL_EPIC_STORM_M:
            nReturn = STORM_M_XP;
            break;
        case SPELL_EPIC_SUMABER:
            nReturn = SUMABER_XP;
            break;
        case SPELL_EPIC_SUP_DIS:
            nReturn = SUP_DIS_XP;
            break;
        case SPELL_EPIC_SYMRUST:
            nReturn = SYMRUST_XP;
            break;
        case SPELL_EPIC_THEWITH:
            nReturn = THEWITH_XP;
            break;
        case SPELL_EPIC_TOLO_KW:
            nReturn = TOLO_KW_XP;
            break;
        case SPELL_EPIC_TRANVIT:
            nReturn = TRANVIT_XP;
            break;
        case SPELL_EPIC_TWINF:
            nReturn = TWINF_XP;
            break;
        case SPELL_EPIC_UNHOLYD:
            nReturn = UNHOLYD_XP;
            break;
        case SPELL_EPIC_UNIMPIN:
            nReturn = UNIMPIN_XP;
            break;
        case SPELL_EPIC_UNSEENW:
            nReturn = UNSEENW_XP;
            break;
        case SPELL_EPIC_WHIP_SH:
            nReturn = WHIP_SH_XP;
            break;
    }
    return nReturn;
}

string GetSchoolForSpell(int nSpellID)
{
    string sReturn;
    switch(nSpellID)
    {
        case SPELL_EPIC_A_STONE:
            sReturn = A_STONE_S;
            break;
        case SPELL_EPIC_ACHHEEL:
            sReturn = ACHHEEL_S;
            break;
        case SPELL_EPIC_AL_MART:
            sReturn = AL_MART_S;
            break;
        case SPELL_EPIC_ALLHOPE:
            sReturn = ALLHOPE_S;
            break;
        case SPELL_EPIC_ANARCHY:
            sReturn = ANARCHY_S;
            break;
        case SPELL_EPIC_ANBLAST:
            sReturn = ANBLAST_S;
            break;
        case SPELL_EPIC_ANBLIZZ:
            sReturn = ANBLIZZ_S;
            break;
        case SPELL_EPIC_ARMY_UN:
            sReturn = ARMY_UN_S;
            break;
        case SPELL_EPIC_BATTLEB:
            sReturn = BATTLEB_S;
            break;
        case SPELL_EPIC_CELCOUN:
            sReturn = CELCOUN_S;
            break;
        case SPELL_EPIC_CHAMP_V:
            sReturn = CHAMP_V_S;
            break;
        case SPELL_EPIC_CON_RES:
            sReturn = CON_RES_S;
            break;
        case SPELL_EPIC_CON_REU:
            sReturn = CON_REU_S;
            break;
        case SPELL_EPIC_DEADEYE:
            sReturn = DEADEYE_S;
            break;
        case SPELL_EPIC_DIREWIN:
            sReturn = DIREWIN_S;
            break;
        case SPELL_EPIC_DREAMSC:
            sReturn = DREAMSC_S;
            break;
        case SPELL_EPIC_DRG_KNI:
            sReturn = DRG_KNI_S;
            break;
        case SPELL_EPIC_DTHMARK:
            sReturn = DTHMARK_S;
            break;
        case SPELL_EPIC_DULBLAD:
            sReturn = DULBLAD_S;
            break;
        case SPELL_EPIC_DWEO_TH:
            sReturn = DWEO_TH_S;
            break;
        case SPELL_EPIC_ENSLAVE:
            sReturn = ENSLAVE_S;
            break;
        case SPELL_EPIC_EP_M_AR:
            sReturn = EP_M_AR_S;
            break;
        case SPELL_EPIC_EP_RPLS:
            sReturn = EP_RPLS_S;
            break;
        case SPELL_EPIC_EP_SP_R:
            sReturn = EP_SP_R_S;
            break;
        case SPELL_EPIC_EP_WARD:
            sReturn = EP_WARD_S;
            break;
        case SPELL_EPIC_ET_FREE:
            sReturn = ET_FREE_S;
            break;
        case SPELL_EPIC_FIEND_W:
            sReturn = FIEND_W_S;
            break;
        case SPELL_EPIC_FLEETNS:
            sReturn = FLEETNS_S;
            break;
        case SPELL_EPIC_GEMCAGE:
            sReturn = GEMCAGE_S;
            break;
        case SPELL_EPIC_GODSMIT:
            sReturn = GODSMIT_S;
            break;
        case SPELL_EPIC_GR_RUIN:
            sReturn = GR_RUIN_S;
            break;
        case SPELL_EPIC_GR_SP_RE:
            sReturn = GR_SP_RE_S;
            break;
        case SPELL_EPIC_GR_TIME:
            sReturn = GR_TIME_S;
            break;
        case SPELL_EPIC_HELBALL:
            sReturn = HELBALL_S;
            break;
        case SPELL_EPIC_HELSEND:
            sReturn = HELSEND_S;
            break;
        case SPELL_EPIC_HERCALL:
            sReturn = HERCALL_S;
            break;
        case SPELL_EPIC_HERCEMP:
            sReturn = HERCEMP_S;
            break;
        case SPELL_EPIC_IMPENET:
            sReturn = IMPENET_S;
            break;
        case SPELL_EPIC_LEECH_F:
            sReturn = LEECH_F_S;
            break;
        case SPELL_EPIC_LEG_ART:
            sReturn = LEG_ART_S;
            break;
        case SPELL_EPIC_LIFE_FT:
            sReturn = LIFE_FT_S;
            break;
        case SPELL_EPIC_MAGMA_B:
            sReturn = MAGMA_B_S;
            break;
        case SPELL_EPIC_MASSPEN:
            sReturn = MASSPEN_S;
            break;
        case SPELL_EPIC_MORI:
            sReturn = MORI_S;
            break;
        case SPELL_EPIC_MUMDUST:
            sReturn = MUMDUST_S;
            break;
        case SPELL_EPIC_NAILSKY:
            sReturn = NAILSKY_S;
            break;
        case SPELL_EPIC_NIGHTSU:
            sReturn = NIGHTSU_S;
            break;
        case SPELL_EPIC_ORDER_R:
            sReturn = ORDER_R_S;
            break;
        case SPELL_EPIC_PATHS_B:
            sReturn = PATHS_B_S;
            break;
        case SPELL_EPIC_PEERPEN:
            sReturn = PEERPEN_S;
            break;
        case SPELL_EPIC_PESTIL:
            sReturn = PESTIL_S;
            break;
        case SPELL_EPIC_PIOUS_P:
            sReturn = PIOUS_P_S;
            break;
        case SPELL_EPIC_PLANCEL:
            sReturn = PLANCEL_S;
            break;
        case SPELL_EPIC_PSION_S:
            sReturn = PSION_S_S;
            break;
        case SPELL_EPIC_RAINFIR:
            sReturn = RAINFIR_S;
            break;
        case SPELL_EPIC_RISEN_R:
            sReturn = RISEN_R_S;
            break;
        case SPELL_EPIC_RUINN:
            sReturn = RUIN_S;
            break;
        case SPELL_EPIC_SINGSUN:
            sReturn = SINGSUN_S;
            break;
        case SPELL_EPIC_SP_WORM:
            sReturn = SP_WORM_S;
            break;
        case SPELL_EPIC_STORM_M:
            sReturn = STORM_M_S;
            break;
        case SPELL_EPIC_SUMABER:
            sReturn = SUMABER_S;
            break;
        case SPELL_EPIC_SUP_DIS:
            sReturn = SUP_DIS_S;
            break;
        case SPELL_EPIC_SYMRUST:
            sReturn = SYMRUST_S;
            break;
        case SPELL_EPIC_THEWITH:
            sReturn = THEWITH_S;
            break;
        case SPELL_EPIC_TOLO_KW:
            sReturn = TOLO_KW_S;
            break;
        case SPELL_EPIC_TRANVIT:
            sReturn = TRANVIT_S;
            break;
        case SPELL_EPIC_TWINF:
            sReturn = TWINF_S;
            break;
        case SPELL_EPIC_UNHOLYD:
            sReturn = UNHOLYD_S;
            break;
        case SPELL_EPIC_UNIMPIN:
            sReturn = UNIMPIN_S;
            break;
        case SPELL_EPIC_UNSEENW:
            sReturn = UNSEENW_S;
            break;
        case SPELL_EPIC_WHIP_SH:
            sReturn = WHIP_SH_S;
            break;
    }
    return sReturn;
}
string GetNameForSpell(int nSpellID)
{
    string sReturn;
    switch(nSpellID)
    {
        case SPELL_EPIC_ACHHEEL:
            sReturn = "Achilles Heel";
            break;
        case SPELL_EPIC_ALLHOPE:
            sReturn = "All Hope Lost";
            break;
        case SPELL_EPIC_AL_MART:
            sReturn = "Allied Martyr";
            break;
        case SPELL_EPIC_ANARCHY:
            sReturn = "Anarchy's Call";
            break;
        case SPELL_EPIC_ANBLAST:
            sReturn = "Animus Blast";
            break;
        case SPELL_EPIC_ANBLIZZ:
            sReturn = "Animus Blizzard";
            break;
        case SPELL_EPIC_ARMY_UN:
            sReturn = "Army Unfallen";
            break;
        case SPELL_EPIC_A_STONE:
            sReturn = "Audience of Stone";
            break;
        case SPELL_EPIC_BATTLEB:
            sReturn = "Battle Bounding";
            break;
        case SPELL_EPIC_CELCOUN:
            sReturn = "Celestial Council";
            break;
        case SPELL_EPIC_CHAMP_V:
            sReturn = "Champion's Valor";
            break;
        case SPELL_EPIC_CON_RES:
            sReturn = "Contingent Resurrection";
            break;
        case SPELL_EPIC_CON_REU:
            sReturn = "Contingent Reunion";
            break;
        case SPELL_EPIC_DEADEYE:
            sReturn = "Deadeye Sense";
            break;
        case SPELL_EPIC_DTHMARK:
            sReturn = "Deathmark";
            break;
        case SPELL_EPIC_DIREWIN:
            sReturn = "Dire Winter";
            break;
        case SPELL_EPIC_DRG_KNI:
            sReturn = "Dragon Knight";
            break;
        case SPELL_EPIC_DREAMSC:
            sReturn = "Dreamscape";
            break;
        case SPELL_EPIC_DULBLAD:
            sReturn = "Dullblades";
            break;
        case SPELL_EPIC_DWEO_TH:
            sReturn = "Dweomer Thief";
            break;
        case SPELL_EPIC_ENSLAVE:
            sReturn = "Enslave";
            break;
        case SPELL_EPIC_EP_M_AR:
            sReturn = "Epic Mage Armor";
            break;
        case SPELL_EPIC_EP_RPLS:
            sReturn = "Epic Repulsion";
            break;
        case SPELL_EPIC_EP_SP_R:
            sReturn = "Epic Spell Reflection";
            break;
        case SPELL_EPIC_EP_WARD:
            sReturn = "Epic Warding";
            break;
        case SPELL_EPIC_ET_FREE:
            sReturn = "Eternal Freedom";
            break;
        case SPELL_EPIC_FIEND_W:
            sReturn = "Fiendish Words";
            break;
        case SPELL_EPIC_FLEETNS:
            sReturn = "Fleetness of Foot";
            break;
        case SPELL_EPIC_GEMCAGE:
            sReturn = "Gem Cage";
            break;
        case SPELL_EPIC_GODSMIT:
            sReturn = "Godsmite";
            break;
        case SPELL_EPIC_GR_RUIN:
            sReturn = "Greater Ruin";
            break;
        case SPELL_EPIC_GR_SP_RE:
            sReturn = "Greater Spell Resistance";
            break;
        case SPELL_EPIC_GR_TIME:
            sReturn = "Greater Timestop";
            break;
        case SPELL_EPIC_HELSEND:
            sReturn = "Hell Send";
            break;
        case SPELL_EPIC_HELBALL:
            sReturn = "Hellball";
            break;
        case SPELL_EPIC_HERCALL:
            sReturn = "Herculean Alliance";
            break;
        case SPELL_EPIC_HERCEMP:
            sReturn = "Herculean Empowerment";
            break;
        case SPELL_EPIC_IMPENET:
            sReturn = "Impenetrability";
            break;
        case SPELL_EPIC_LEECH_F:
            sReturn = "Leech Field";
            break;
        case SPELL_EPIC_LEG_ART:
            sReturn = "Legendary Artisan";
            break;
        case SPELL_EPIC_LIFE_FT:
            sReturn = "Life Force Transfer";
            break;
        case SPELL_EPIC_MAGMA_B:
            sReturn = "Magma Burst";
            break;
        case SPELL_EPIC_MASSPEN:
            sReturn = "Mass Penguin";
            break;
        case SPELL_EPIC_MORI:
            sReturn = "Momento Mori";
            break;
        case SPELL_EPIC_MUMDUST:
            sReturn = "Mummy Dust";
            break;
        case SPELL_EPIC_NAILSKY:
            sReturn = "Nailed to the Sky";
            break;
        case SPELL_EPIC_NIGHTSU:
            sReturn = "Night's Undoing";
            break;
        case SPELL_EPIC_ORDER_R:
            sReturn = "Order Restored";
            break;
        case SPELL_EPIC_PATHS_B:
            sReturn = "Paths Become Known";
            break;
        case SPELL_EPIC_PEERPEN:
            sReturn = "Peerless Penitence";
            break;
        case SPELL_EPIC_PESTIL:
            sReturn = "Pestilence";
            break;
        case SPELL_EPIC_PIOUS_P:
            sReturn = "Pious Parley";
            break;
        case SPELL_EPIC_PLANCEL:
            sReturn = "Planar Cell";
            break;
        case SPELL_EPIC_PSION_S:
            sReturn = "Psionic Salvo";
            break;
        case SPELL_EPIC_RAINFIR:
            sReturn = "Rain of Fire";
            break;
        case SPELL_EPIC_RISEN_R:
            sReturn = "Risen Reunited";
            break;
        case SPELL_EPIC_RUINN://nonstandard
            sReturn = "Ruin";
            break;
        case SPELL_EPIC_SINGSUN:
            sReturn = "Singular Sunder";
            break;
        case SPELL_EPIC_SP_WORM:
            sReturn = "Spell Worm";
            break;
        case SPELL_EPIC_STORM_M:
            sReturn = "Storm Mantle";
            break;
        case SPELL_EPIC_SUMABER:
            sReturn = "Summon Aberration";
            break;
        case SPELL_EPIC_SUP_DIS:
            sReturn = "Superb Dispelling";
            break;
        case SPELL_EPIC_SYMRUST:
            sReturn = "Symrustar's Spellbinding";
            break;
        case SPELL_EPIC_THEWITH:
            sReturn = "The Withering";
            break;
        case SPELL_EPIC_TOLO_KW:
            sReturn = "Tolodine's Killing Wind";
            break;
        case SPELL_EPIC_TRANVIT:
            sReturn = "Transcendent Vitality";
            break;
        case SPELL_EPIC_TWINF:
            sReturn = "Twinfiend";
            break;
        case SPELL_EPIC_UNHOLYD:
            sReturn = "Unholy Disciple";
            break;
        case SPELL_EPIC_UNIMPIN:
            sReturn = "Unimpinged";
            break;
        case SPELL_EPIC_UNSEENW:
            sReturn = "Unseen Wanderer";
            break;
        case SPELL_EPIC_WHIP_SH:
            sReturn = "Whip of Shar";
            break;
    }
    return sReturn;
}


int GetR1ForSpell(int nSpellID)
{
    int nReturn;
    switch(nSpellID)
    {
        case SPELL_EPIC_ACHHEEL:
            nReturn = AFFLICT_FE;
            break;
        case SPELL_EPIC_ALLHOPE:
            nReturn = COMPEL_FE;
            break;
        case SPELL_EPIC_AL_MART:
            nReturn = HEAL_FE;
            break;
        case SPELL_EPIC_ANARCHY:
            nReturn = OPPOSIT_FE;
            break;
        case SPELL_EPIC_ANBLAST:
            nReturn = ENERGY_FE;
            break;
        case SPELL_EPIC_ANBLIZZ:
            nReturn = ENERGY_FE;
            break;
        case SPELL_EPIC_ARMY_UN:
            nReturn = LIFE_FE;
            break;
        case SPELL_EPIC_A_STONE:
            nReturn = TRANSFO_FE;
            break;
        case SPELL_EPIC_BATTLEB:
            nReturn = WARD_FE;
            break;
        case SPELL_EPIC_CELCOUN:
            nReturn = CONTACT_FE;
            break;
        case SPELL_EPIC_CHAMP_V:
            nReturn = FORTIFY_FE;
            break;
        case SPELL_EPIC_CON_RES:
            nReturn = LIFE_FE;
            break;
        case SPELL_EPIC_CON_REU:
            nReturn = TRANSPO_FE;
            break;
        case SPELL_EPIC_DEADEYE:
            nReturn = FORTIFY_FE;
            break;
        case SPELL_EPIC_DTHMARK:
            nReturn = SLAY_FE;
            break;
        case SPELL_EPIC_DIREWIN:
            nReturn = ENERGY_FE;
            break;
        case SPELL_EPIC_DRG_KNI:
            nReturn = SUMMON_FE;
            break;
        case SPELL_EPIC_DREAMSC:
            nReturn = TRANSPO_FE;
            break;
        case SPELL_EPIC_DULBLAD:
            nReturn = WARD_FE;
            break;
        case SPELL_EPIC_DWEO_TH:
            nReturn = REVEAL_FE;
            break;
        case SPELL_EPIC_ENSLAVE:
            nReturn = COMPEL_FE;
            break;
        case SPELL_EPIC_EP_M_AR:
            nReturn = ARMOR_FE;
            break;
        case SPELL_EPIC_EP_RPLS:
            nReturn = WARD_FE;
            break;
        case SPELL_EPIC_EP_SP_R:
            nReturn = REFLECT_FE;
            break;
        case SPELL_EPIC_EP_WARD:
            nReturn = WARD_FE;
            break;
        case SPELL_EPIC_ET_FREE:
            nReturn = WARD_FE;
            break;
        case SPELL_EPIC_FIEND_W:
            nReturn = CONTACT_FE;
            break;
        case SPELL_EPIC_FLEETNS:
            nReturn = FORTIFY_FE;
            break;
        case SPELL_EPIC_GEMCAGE:
            nReturn = TRANSFO_FE;
            break;
        case SPELL_EPIC_GODSMIT:
            nReturn = DESTROY_FE;
            break;
        case SPELL_EPIC_GR_RUIN:
            nReturn = DESTROY_FE;
            break;
        case SPELL_EPIC_GR_SP_RE:
            nReturn = FORTIFY_FE;
            break;
        case SPELL_EPIC_GR_TIME:
            nReturn = TIME_FE;
            break;
        case SPELL_EPIC_HELSEND:
            nReturn = TRANSPO_FE;
            break;
        case SPELL_EPIC_HELBALL:
            nReturn = ENERGY_FE;
            break;
        case SPELL_EPIC_HERCALL:
            nReturn = FORTIFY_FE;
            break;
        case SPELL_EPIC_HERCEMP:
            nReturn = FORTIFY_FE;
            break;
        case SPELL_EPIC_IMPENET:
            nReturn = WARD_FE;
            break;
        case SPELL_EPIC_LEECH_F:
            nReturn = HEAL_FE;
            break;
        case SPELL_EPIC_LEG_ART:
            nReturn = TRANSFO_FE;
            break;
        case SPELL_EPIC_LIFE_FT:
            //nReturn = ;
            break;
        case SPELL_EPIC_MAGMA_B:
            nReturn = ENERGY_FE;
            break;
        case SPELL_EPIC_MASSPEN:
            nReturn = TRANSFO_FE;
            break;
        case SPELL_EPIC_MORI:
            nReturn = SLAY_FE;
            break;
        case SPELL_EPIC_MUMDUST:
            nReturn = ANIDEAD_FE;
            break;
        case SPELL_EPIC_NAILSKY:
            nReturn = FORESEE_FE;
            break;
        case SPELL_EPIC_NIGHTSU:
            nReturn = LIGHT_FE;
            break;
        case SPELL_EPIC_ORDER_R:
            nReturn = OPPOSIT_FE;
            break;
        case SPELL_EPIC_PATHS_B:
            nReturn = FORESEE_FE;
            break;
        case SPELL_EPIC_PEERPEN:
            nReturn = HEAL_FE;
            break;
        case SPELL_EPIC_PESTIL:
            nReturn = AFFLICT_FE;
            break;
        case SPELL_EPIC_PIOUS_P:
            nReturn = CONTACT_FE;
            break;
        case SPELL_EPIC_PLANCEL:
            nReturn = TRANSPO_FE;
            break;
        case SPELL_EPIC_PSION_S:
            nReturn = AFFLICT_FE;
            break;
        case SPELL_EPIC_RAINFIR:
            nReturn = ENERGY_FE;
            break;
        case SPELL_EPIC_RISEN_R:
            nReturn = TRANSPO_FE;
            break;
        case SPELL_EPIC_RUINN:
            nReturn = DESTROY_FE;
            break;
        case SPELL_EPIC_SINGSUN:
            nReturn = DESTROY_FE;
            break;
        case SPELL_EPIC_SP_WORM:
            nReturn = COMPEL_FE;
            break;
        case SPELL_EPIC_STORM_M:
            nReturn = WARD_FE;
            break;
        case SPELL_EPIC_SUMABER:
            nReturn = SUMMON_FE;
            break;
        case SPELL_EPIC_SUP_DIS:
            nReturn = DISPEL_FE;
            break;
        case SPELL_EPIC_SYMRUST:
            //nReturn = ;
            break;
        case SPELL_EPIC_THEWITH:
            nReturn = AFFLICT_FE;
            break;
        case SPELL_EPIC_TOLO_KW:
            nReturn = AFFLICT_FE;
            break;
        case SPELL_EPIC_TRANVIT:
            nReturn = FORTIFY_FE;
            break;
        case SPELL_EPIC_TWINF:
            nReturn = SUMMON_FE;
            break;
        case SPELL_EPIC_UNHOLYD:
            nReturn = SUMMON_FE;
            break;
        case SPELL_EPIC_UNIMPIN:
            nReturn = WARD_FE;
            break;
        case SPELL_EPIC_UNSEENW:
            nReturn = CONCEAL_FE;
            break;
        case SPELL_EPIC_WHIP_SH:
            nReturn = SHADOW_FE;
            break;
    }
    return nReturn;
}

int GetR2ForSpell(int nSpellID)
{
    int nReturn;
    switch(nSpellID)
    {
        case SPELL_EPIC_ALLHOPE:
            //nReturn = ;
            break;
        case SPELL_EPIC_A_STONE:
            //nReturn = ;
            break;
        case SPELL_EPIC_CELCOUN:
            //nReturn = ;
            break;
        case SPELL_EPIC_CHAMP_V:
            //nReturn = ;
            break;
        case SPELL_EPIC_CON_RES:
            //nReturn = ;
            break;
        case SPELL_EPIC_DEADEYE:
            //nReturn = ;
            break;
        case SPELL_EPIC_DIREWIN:
            //nReturn = ;
            break;
        case SPELL_EPIC_DRG_KNI:
            //nReturn = ;
            break;
        case SPELL_EPIC_DREAMSC:
            //nReturn = ;
            break;
        case SPELL_EPIC_DULBLAD:
            //nReturn = ;
            break;
        case SPELL_EPIC_ENSLAVE:
            //nReturn = ;
            break;
        case SPELL_EPIC_EP_M_AR:
            //nReturn = ;
            break;
        case SPELL_EPIC_EP_RPLS:
            //nReturn = ;
            break;
        case SPELL_EPIC_EP_SP_R:
            //nReturn = ;
            break;
        case SPELL_EPIC_EP_WARD:
            //nReturn = ;
            break;
        case SPELL_EPIC_ET_FREE:
            //nReturn = ;
            break;
        case SPELL_EPIC_FIEND_W:
            //nReturn = ;
            break;
        case SPELL_EPIC_FLEETNS:
            //nReturn = ;
            break;
        case SPELL_EPIC_GR_RUIN:
            //nReturn = ;
            break;
        case SPELL_EPIC_GR_SP_RE:
            //nReturn = ;
            break;
        case SPELL_EPIC_GR_TIME:
            //nReturn = ;
            break;
        case SPELL_EPIC_HELSEND:
            //nReturn = ;
            break;
        case SPELL_EPIC_HELBALL:
            //nReturn = ;
            break;
        case SPELL_EPIC_HERCEMP:
            //nReturn = ;
            break;
        case SPELL_EPIC_IMPENET:
            //nReturn = ;
            break;
        case SPELL_EPIC_LEECH_F:
            //nReturn = ;
            break;
        case SPELL_EPIC_LIFE_FT:
            //nReturn = ;
            break;
        case SPELL_EPIC_MASSPEN:
            //nReturn = ;
            break;
        case SPELL_EPIC_MORI:
            //nReturn = ;
            break;
        case SPELL_EPIC_MUMDUST:
            //nReturn = ;
            break;
        case SPELL_EPIC_NIGHTSU:
            //nReturn = ;
            break;
        case SPELL_EPIC_PESTIL:
            //nReturn = ;
            break;
        case SPELL_EPIC_PIOUS_P:
            //nReturn = ;
            break;
        case SPELL_EPIC_PLANCEL:
            //nReturn = ;
            break;
        case SPELL_EPIC_PSION_S:
            //nReturn = ;
            break;
        case SPELL_EPIC_RAINFIR:
            //nReturn = ;
            break;
        case SPELL_EPIC_RUINN:
            //nReturn = ;
            break;
        case SPELL_EPIC_SP_WORM:
            //nReturn = ;
            break;
        case SPELL_EPIC_STORM_M:
            //nReturn = ;
            break;
        case SPELL_EPIC_SUMABER:
            //nReturn = ;
            break;
        case SPELL_EPIC_SUP_DIS:
            //nReturn = ;
            break;
        case SPELL_EPIC_SYMRUST:
            //nReturn = ;
            break;
        case SPELL_EPIC_THEWITH:
            //nReturn = ;
            break;
        case SPELL_EPIC_TWINF:
            //nReturn = ;
            break;
        case SPELL_EPIC_UNHOLYD:
            //nReturn = ;
            break;
        case SPELL_EPIC_UNIMPIN:
            //nReturn = ;
            break;
        case SPELL_EPIC_UNSEENW:
            //nReturn = ;
            break;
        case SPELL_EPIC_HERCALL:
            //nReturn = ;
            break;
        case SPELL_EPIC_ANBLAST:
            nReturn = ANIDEAD_FE;
            break;
        case SPELL_EPIC_ANBLIZZ:
            nReturn = ANIDEAD_FE;
            break;
        case SPELL_EPIC_ANARCHY:
            nReturn = COMPEL_FE;
            break;
        case SPELL_EPIC_ORDER_R:
            nReturn = COMPEL_FE;
            break;
        case SPELL_EPIC_DWEO_TH:
            nReturn = COMPEL_FE;
            break;
        case SPELL_EPIC_WHIP_SH:
            nReturn = CONJURE_FE;
            break;
        case SPELL_EPIC_RISEN_R:
            nReturn = CONTACT_FE;
            break;
        case SPELL_EPIC_SINGSUN:
            nReturn = DISPEL_FE;
            break;
        case SPELL_EPIC_AL_MART:
            nReturn = FORESEE_FE;
            break;
        case SPELL_EPIC_CON_REU:
            nReturn = FORESEE_FE;
            break;
        case SPELL_EPIC_LEG_ART:
            nReturn = FORTIFY_FE;
            break;
        case SPELL_EPIC_TRANVIT:
            nReturn = HEAL_FE;
            break;
        case SPELL_EPIC_ARMY_UN:
            nReturn = HEAL_FE;
            break;
        case SPELL_EPIC_GODSMIT:
            nReturn = OPPOSIT_FE;
            break;
        case SPELL_EPIC_PEERPEN:
            nReturn = OPPOSIT_FE;
            break;
        case SPELL_EPIC_PATHS_B:
            nReturn = REVEAL_FE;
            break;
        case SPELL_EPIC_TOLO_KW:
            nReturn = SLAY_FE;
            break;
        case SPELL_EPIC_DTHMARK:
            nReturn = TIME_FE;
            break;
        case SPELL_EPIC_MAGMA_B:
            nReturn = TRANSFO_FE;
            break;
        case SPELL_EPIC_BATTLEB:
            nReturn = TRANSPO_FE;
            break;
        case SPELL_EPIC_GEMCAGE:
            nReturn = TRANSPO_FE;
            break;
        case SPELL_EPIC_NAILSKY:
            nReturn = TRANSPO_FE;
            break;
        case SPELL_EPIC_ACHHEEL:
            nReturn = WARD_FE;
            break;
    }
    return nReturn;
}

int GetR3ForSpell(int nSpellID)
{
    int nReturn;
    switch(nSpellID)
    {
        case SPELL_EPIC_ALLHOPE:
            //nReturn =;
            break;
        case SPELL_EPIC_A_STONE:
            //nReturn =;
            break;
        case SPELL_EPIC_CELCOUN:
            //nReturn =;
            break;
        case SPELL_EPIC_CHAMP_V:
            //nReturn =;
            break;
        case SPELL_EPIC_CON_RES:
            //nReturn =;
            break;
        case SPELL_EPIC_DEADEYE:
            //nReturn =;
            break;
        case SPELL_EPIC_DIREWIN:
            //nReturn =;
            break;
        case SPELL_EPIC_DRG_KNI:
            //nReturn =;
            break;
        case SPELL_EPIC_DREAMSC:
            //nReturn =;
            break;
        case SPELL_EPIC_DULBLAD:
            //nReturn =;
            break;
        case SPELL_EPIC_ENSLAVE:
            //nReturn =;
            break;
        case SPELL_EPIC_EP_M_AR:
            //nReturn =;
            break;
        case SPELL_EPIC_EP_RPLS:
            //nReturn =;
            break;
        case SPELL_EPIC_EP_SP_R:
            //nReturn =;
            break;
        case SPELL_EPIC_EP_WARD:
            //nReturn =;
            break;
        case SPELL_EPIC_ET_FREE:
            //nReturn =;
            break;
        case SPELL_EPIC_FIEND_W:
            //nReturn =;
            break;
        case SPELL_EPIC_FLEETNS:
            //nReturn =;
            break;
        case SPELL_EPIC_GR_RUIN:
            //nReturn =;
            break;
        case SPELL_EPIC_GR_SP_RE:
            //nReturn =;
            break;
        case SPELL_EPIC_GR_TIME:
            //nReturn =;
            break;
        case SPELL_EPIC_HELSEND:
            //nReturn =;
            break;
        case SPELL_EPIC_HELBALL:
            //nReturn =;
            break;
        case SPELL_EPIC_HERCEMP:
            //nReturn =;
            break;
        case SPELL_EPIC_IMPENET:
            //nReturn =;
            break;
        case SPELL_EPIC_LEECH_F:
            //nReturn =;
            break;
        case SPELL_EPIC_LIFE_FT:
            //nReturn =;
            break;
        case SPELL_EPIC_MASSPEN:
            //nReturn =;
            break;
        case SPELL_EPIC_MORI:
            //nReturn =;
            break;
        case SPELL_EPIC_MUMDUST:
            //nReturn =;
            break;
        case SPELL_EPIC_NIGHTSU:
            //nReturn =;
            break;
        case SPELL_EPIC_PESTIL:
            //nReturn =;
            break;
        case SPELL_EPIC_PIOUS_P:
            //nReturn =;
            break;
        case SPELL_EPIC_PLANCEL:
            //nReturn =;
            break;
        case SPELL_EPIC_PSION_S:
            //nReturn =;
            break;
        case SPELL_EPIC_RAINFIR:
            //nReturn =;
            break;
        case SPELL_EPIC_RUINN:
            //nReturn =;
            break;
        case SPELL_EPIC_SP_WORM:
            //nReturn =;
            break;
        case SPELL_EPIC_STORM_M:
            //nReturn =;
            break;
        case SPELL_EPIC_SUMABER:
            //nReturn =;
            break;
        case SPELL_EPIC_SUP_DIS:
            //nReturn =;
            break;
        case SPELL_EPIC_SYMRUST:
            //nReturn =;
            break;
        case SPELL_EPIC_THEWITH:
            //nReturn =;
            break;
        case SPELL_EPIC_TWINF:
            //nReturn =;
            break;
        case SPELL_EPIC_UNHOLYD:
            //nReturn =;
            break;
        case SPELL_EPIC_UNIMPIN:
            //nReturn =;
            break;
        case SPELL_EPIC_UNSEENW:
            //nReturn =;
            break;
        case SPELL_EPIC_HERCALL:
            //nReturn =;
            break;
        case SPELL_EPIC_ANBLAST:
            //nReturn =;
            break;
        case SPELL_EPIC_ANBLIZZ:
            //nReturn =;
            break;
        case SPELL_EPIC_ANARCHY:
            //nReturn =;
            break;
        case SPELL_EPIC_ORDER_R:
            //nReturn =;
            break;
        case SPELL_EPIC_DWEO_TH:
            nReturn =REFLECT_FE;
            break;
        case SPELL_EPIC_WHIP_SH:
            nReturn =TRANSFO_FE;
            break;
        case SPELL_EPIC_RISEN_R:
            nReturn =LIFE_FE;
            break;
        case SPELL_EPIC_SINGSUN:
            //nReturn =;
            break;
        case SPELL_EPIC_AL_MART:
            //nReturn =;
            break;
        case SPELL_EPIC_CON_REU:
            //nReturn =;
            break;
        case SPELL_EPIC_LEG_ART:
            nReturn =ENERGY_FE;
            break;
        case SPELL_EPIC_TRANVIT:
            //nReturn =;
            break;
        case SPELL_EPIC_ARMY_UN:
            nReturn =WARD_FE;
            break;
        case SPELL_EPIC_GODSMIT:
            //nReturn =;
            break;
        case SPELL_EPIC_PEERPEN:
            nReturn =DESTROY_FE;
            break;
        case SPELL_EPIC_PATHS_B:
            //nReturn =;
            break;
        case SPELL_EPIC_TOLO_KW:
            //nReturn =;
            break;
        case SPELL_EPIC_DTHMARK:
            nReturn =AFFLICT_FE;
            break;
        case SPELL_EPIC_MAGMA_B:
            //nReturn =;
            break;
        case SPELL_EPIC_BATTLEB:
            //nReturn =;
            break;
        case SPELL_EPIC_GEMCAGE:
            //nReturn =;
            break;
        case SPELL_EPIC_NAILSKY:
            //nReturn =;
            break;
        case SPELL_EPIC_ACHHEEL:
            //nReturn =;
            break;
    }
    return nReturn;
}

int GetR4ForSpell(int nSpellID)
{
    int nReturn;
    switch(nSpellID)
    {
        case SPELL_EPIC_ALLHOPE:
            //nReturn =;
            break;
        case SPELL_EPIC_A_STONE:
            //nReturn =;
            break;
        case SPELL_EPIC_CELCOUN:
            //nReturn =;
            break;
        case SPELL_EPIC_CHAMP_V:
            //nReturn =;
            break;
        case SPELL_EPIC_CON_RES:
            //nReturn =;
            break;
        case SPELL_EPIC_DEADEYE:
            //nReturn =;
            break;
        case SPELL_EPIC_DIREWIN:
            //nReturn =;
            break;
        case SPELL_EPIC_DRG_KNI:
            //nReturn =;
            break;
        case SPELL_EPIC_DREAMSC:
            //nReturn =;
            break;
        case SPELL_EPIC_DULBLAD:
            //nReturn =;
            break;
        case SPELL_EPIC_ENSLAVE:
            //nReturn =;
            break;
        case SPELL_EPIC_EP_M_AR:
            //nReturn =;
            break;
        case SPELL_EPIC_EP_RPLS:
            //nReturn =;
            break;
        case SPELL_EPIC_EP_SP_R:
            //nReturn =;
            break;
        case SPELL_EPIC_EP_WARD:
            //nReturn =;
            break;
        case SPELL_EPIC_ET_FREE:
            //nReturn =;
            break;
        case SPELL_EPIC_FIEND_W:
            //nReturn =;
            break;
        case SPELL_EPIC_FLEETNS:
            //nReturn =;
            break;
        case SPELL_EPIC_GR_RUIN:
            //nReturn =;
            break;
        case SPELL_EPIC_GR_SP_RE:
            //nReturn =;
            break;
        case SPELL_EPIC_GR_TIME:
            //nReturn =;
            break;
        case SPELL_EPIC_HELSEND:
            //nReturn =;
            break;
        case SPELL_EPIC_HELBALL:
            //nReturn =;
            break;
        case SPELL_EPIC_HERCEMP:
            //nReturn =;
            break;
        case SPELL_EPIC_IMPENET:
            //nReturn =;
            break;
        case SPELL_EPIC_LEECH_F:
            //nReturn =;
            break;
        case SPELL_EPIC_LIFE_FT:
            //nReturn =;
            break;
        case SPELL_EPIC_MASSPEN:
            //nReturn =;
            break;
        case SPELL_EPIC_MORI:
            //nReturn =;
            break;
        case SPELL_EPIC_MUMDUST:
            //nReturn =;
            break;
        case SPELL_EPIC_NIGHTSU:
            //nReturn =;
            break;
        case SPELL_EPIC_PESTIL:
            //nReturn =;
            break;
        case SPELL_EPIC_PIOUS_P:
            //nReturn =;
            break;
        case SPELL_EPIC_PLANCEL:
            //nReturn =;
            break;
        case SPELL_EPIC_PSION_S:
            //nReturn =;
            break;
        case SPELL_EPIC_RAINFIR:
            //nReturn =;
            break;
        case SPELL_EPIC_RUINN:
            //nReturn =;
            break;
        case SPELL_EPIC_SP_WORM:
            //nReturn =;
            break;
        case SPELL_EPIC_STORM_M:
            //nReturn =;
            break;
        case SPELL_EPIC_SUMABER:
            //nReturn =;
            break;
        case SPELL_EPIC_SUP_DIS:
            //nReturn =;
            break;
        case SPELL_EPIC_SYMRUST:
            //nReturn =;
            break;
        case SPELL_EPIC_THEWITH:
            //nReturn =;
            break;
        case SPELL_EPIC_TWINF:
            //nReturn =;
            break;
        case SPELL_EPIC_UNHOLYD:
            //nReturn =;
            break;
        case SPELL_EPIC_UNIMPIN:
            //nReturn =;
            break;
        case SPELL_EPIC_UNSEENW:
            //nReturn =;
            break;
        case SPELL_EPIC_HERCALL:
            //nReturn =;
            break;
        case SPELL_EPIC_ANBLAST:
            //nReturn =;
            break;
        case SPELL_EPIC_ANBLIZZ:
            //nReturn =;
            break;
        case SPELL_EPIC_ANARCHY:
            //nReturn =;
            break;
        case SPELL_EPIC_ORDER_R:
            //nReturn =;
            break;
        case SPELL_EPIC_DWEO_TH:
            //nReturn =;
            break;
        case SPELL_EPIC_WHIP_SH:
            //nReturn =;
            break;
        case SPELL_EPIC_RISEN_R:
            //nReturn =;
            break;
        case SPELL_EPIC_SINGSUN:
            //nReturn =;
            break;
        case SPELL_EPIC_AL_MART:
            //nReturn =;
            break;
        case SPELL_EPIC_CON_REU:
            //nReturn =;
            break;
        case SPELL_EPIC_LEG_ART:
            nReturn =CONJURE_FE;
            break;
        case SPELL_EPIC_TRANVIT:
            //nReturn =;
            break;
        case SPELL_EPIC_ARMY_UN:
            //nReturn =;
            break;
        case SPELL_EPIC_GODSMIT:
            //nReturn =;
            break;
        case SPELL_EPIC_PEERPEN:
            //nReturn =;
            break;
        case SPELL_EPIC_PATHS_B:
            //nReturn =;
            break;
        case SPELL_EPIC_TOLO_KW:
            //nReturn =;
            break;
        case SPELL_EPIC_DTHMARK:
            //nReturn =;
            break;
        case SPELL_EPIC_MAGMA_B:
            //nReturn =;
            break;
        case SPELL_EPIC_BATTLEB:
            //nReturn =;
            break;
        case SPELL_EPIC_GEMCAGE:
            //nReturn =;
            break;
        case SPELL_EPIC_NAILSKY:
            //nReturn =;
            break;
        case SPELL_EPIC_ACHHEEL:
            //nReturn =;
            break;
    }
    return nReturn;
}

int GetSpellFromAbrev(string sAbrev)
{
    int nReturn;
    if(sAbrev == "ALLHOPE")
            nReturn = SPELL_EPIC_ALLHOPE;
        else if(sAbrev == "A_STONE")
            nReturn = SPELL_EPIC_A_STONE;
        else if(sAbrev == "CELCOUN")
            nReturn = SPELL_EPIC_CELCOUN;
        else if(sAbrev == "CHAMP_V")
            nReturn = SPELL_EPIC_CHAMP_V;
        else if(sAbrev == "CON_RES")
            nReturn = SPELL_EPIC_CON_RES;
        else if(sAbrev == "DEADEYE")
            nReturn = SPELL_EPIC_DEADEYE;
        else if(sAbrev == "DIREWIN")
            nReturn = SPELL_EPIC_DIREWIN;
        else if(sAbrev == "DRG_KNI")
            nReturn = SPELL_EPIC_DRG_KNI;
        else if(sAbrev == "DREAMSC")
            nReturn = SPELL_EPIC_DREAMSC;
        else if(sAbrev == "DULBLAD")
            nReturn = SPELL_EPIC_DULBLAD;
        else if(sAbrev == "ENSLAVE")
            nReturn = SPELL_EPIC_ENSLAVE;
        else if(sAbrev == "EP_M_AR")
            nReturn = SPELL_EPIC_EP_M_AR;
        else if(sAbrev == "EP_RPLS")
            nReturn = SPELL_EPIC_EP_RPLS;
        else if(sAbrev == "EP_SP_R")
            nReturn = SPELL_EPIC_EP_SP_R;
        else if(sAbrev == "EP_WARD")
            nReturn = SPELL_EPIC_EP_WARD;
        else if(sAbrev == "ET_FREE")
            nReturn = SPELL_EPIC_ET_FREE;
        else if(sAbrev == "FIEND_W")
            nReturn = SPELL_EPIC_FIEND_W;
        else if(sAbrev == "FLEETNS")
            nReturn = SPELL_EPIC_FLEETNS;
        else if(sAbrev == "GR_RUIN")
            nReturn = SPELL_EPIC_GR_RUIN;
        else if(sAbrev == "GR_SP_RE")
            nReturn = SPELL_EPIC_GR_SP_RE;
        else if(sAbrev == "GR_TIME")
            nReturn = SPELL_EPIC_GR_TIME;
        else if(sAbrev == "HELSEND")
            nReturn = SPELL_EPIC_HELSEND;
        else if(sAbrev == "HELBALL")
            nReturn = SPELL_EPIC_HELBALL;
        else if(sAbrev == "HERCEMP")
            nReturn = SPELL_EPIC_HERCEMP;
        else if(sAbrev == "IMPENET")
            nReturn = SPELL_EPIC_IMPENET;
        else if(sAbrev == "LEECH_F")
            nReturn = SPELL_EPIC_LEECH_F;
        else if(sAbrev == "LIFE_FT")
            nReturn = SPELL_EPIC_LIFE_FT;
        else if(sAbrev == "MASSPEN")
            nReturn = SPELL_EPIC_MASSPEN;
        else if(sAbrev == "MORI")
            nReturn = SPELL_EPIC_MORI;
        else if(sAbrev == "MUMDUST")
            nReturn = SPELL_EPIC_MUMDUST;
        else if(sAbrev == "NIGHTSU")
            nReturn = SPELL_EPIC_NIGHTSU;
        else if(sAbrev == "PESTIL")
            nReturn = SPELL_EPIC_PESTIL;
        else if(sAbrev == "PIOUS_P")
            nReturn = SPELL_EPIC_PIOUS_P;
        else if(sAbrev == "PLANCEL")
            nReturn = SPELL_EPIC_PLANCEL;
        else if(sAbrev == "PSION_S")
            nReturn = SPELL_EPIC_PSION_S;
        else if(sAbrev == "RAINFIR")
            nReturn = SPELL_EPIC_RAINFIR;
        else if(sAbrev == "RUIN")
            nReturn = SPELL_EPIC_RUINN;//nonstandard
        else if(sAbrev == "SP_WORM")
            nReturn = SPELL_EPIC_SP_WORM;
        else if(sAbrev == "STORM_M")
            nReturn = SPELL_EPIC_STORM_M;
        else if(sAbrev == "SUMABER")
            nReturn = SPELL_EPIC_SUMABER;
        else if(sAbrev == "SUP_DIS")
            nReturn = SPELL_EPIC_SUP_DIS;
        else if(sAbrev == "SYMRUST")
            nReturn = SPELL_EPIC_SYMRUST;
        else if(sAbrev == "THEWITH")
            nReturn = SPELL_EPIC_THEWITH;
        else if(sAbrev == "TWINF")
            nReturn = SPELL_EPIC_TWINF;
        else if(sAbrev == "UNHOLYD")
            nReturn = SPELL_EPIC_UNHOLYD;
        else if(sAbrev == "UNIMPIN")
            nReturn = SPELL_EPIC_UNIMPIN;
        else if(sAbrev == "UNSEENW")
            nReturn = SPELL_EPIC_UNSEENW;
        else if(sAbrev == "HERCALL")
            nReturn = SPELL_EPIC_HERCALL;
        else if(sAbrev == "ANBLAST")
            nReturn = SPELL_EPIC_ANBLAST;
        else if(sAbrev == "ANBLIZZ")
            nReturn = SPELL_EPIC_ANBLIZZ;
        else if(sAbrev == "ANARCHY")
            nReturn = SPELL_EPIC_ANARCHY;
        else if(sAbrev == "ORDER_R")
            nReturn = SPELL_EPIC_ORDER_R;
        else if(sAbrev == "DWEO_TH")
            nReturn = SPELL_EPIC_DWEO_TH;
        else if(sAbrev == "WHIP_SH")
            nReturn = SPELL_EPIC_WHIP_SH;
        else if(sAbrev == "RISEN_R")
            nReturn = SPELL_EPIC_RISEN_R;
        else if(sAbrev == "SINGSUN")
            nReturn = SPELL_EPIC_SINGSUN;
        else if(sAbrev == "AL_MART")
            nReturn = SPELL_EPIC_AL_MART;
        else if(sAbrev == "CON_REU")
            nReturn = SPELL_EPIC_CON_REU;
        else if(sAbrev == "LEG_ART")
            nReturn = SPELL_EPIC_LEG_ART;
        else if(sAbrev == "TRANVIT")
            nReturn = SPELL_EPIC_TRANVIT;
        else if(sAbrev == "ARMY_UN")
            nReturn = SPELL_EPIC_ARMY_UN;
        else if(sAbrev == "GODSMIT")
            nReturn = SPELL_EPIC_GODSMIT;
        else if(sAbrev == "PEERPEN")
            nReturn = SPELL_EPIC_PEERPEN;
        else if(sAbrev == "PATHS_B")
            nReturn = SPELL_EPIC_PATHS_B;
        else if(sAbrev == "TOLO_KW")
            nReturn = SPELL_EPIC_TOLO_KW;
        else if(sAbrev == "DTHMARK")
            nReturn = SPELL_EPIC_DTHMARK;
        else if(sAbrev == "MAGMA_B")
            nReturn = SPELL_EPIC_MAGMA_B;
        else if(sAbrev == "BATTLEB")
            nReturn = SPELL_EPIC_BATTLEB;
        else if(sAbrev == "GEMCAGE")
            nReturn = SPELL_EPIC_GEMCAGE;
        else if(sAbrev == "NAILSKY")
            nReturn = SPELL_EPIC_NAILSKY;
        else if(sAbrev == "ACHHEEL")
            nReturn = SPELL_EPIC_ACHHEEL;
    return nReturn;
}
