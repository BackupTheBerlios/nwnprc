//:://////////////////////////////////////////////
//:: FileName: "ss_ep_direwinter"
/*   Purpose: Dire Winter - turns entire area the spell was cast in into a
        winter-wonderland.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////

#include "x2_i0_spells"
#include "x2_inc_spellhook"
#include "inc_epicspells"
#include "x2_inc_toollib"
#include "prc_alterations"

void DoWinterCheck(object oArea, float fDuration);

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, DIREWIN_DC, DIREWIN_S, DIREWIN_XP))
    {
        object oArea = GetArea(OBJECT_SELF);
        float fDuration = HoursToSeconds(20) - 6.0;
        TLChangeAreaGroundTiles(oArea, X2_TL_GROUNDTILE_ICE, 32, 32, 0.3);
        SetWeather(oArea, WEATHER_SNOW);
        // Add icy look to all placeables in area.
        effect eIce = EffectVisualEffect(VFX_DUR_ICESKIN);
        object oItem = GetFirstObjectInArea(oArea);
        while (oItem != OBJECT_INVALID)
        {
            if (GetObjectType(oItem) == OBJECT_TYPE_PLACEABLE)
            {
                float fDelay = GetRandomDelay();
                DelayCommand(fDelay,
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        eIce, oItem, fDuration));
            }
            oItem = GetNextObjectInArea(oArea);
        }
        DelayCommand(6.0, DoWinterCheck(oArea, fDuration));
        DelayCommand(fDuration, SetWeather(oArea, WEATHER_USE_AREA_SETTINGS));
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

void DoWinterCheck(object oArea, float fDuration)
{
    int nDam;
    effect eDam;
    object oTarget = GetFirstObjectInArea(oArea);
    while (oTarget != OBJECT_INVALID)
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            nDam = d6(2);
            eDam = EffectDamage(nDam, DAMAGE_TYPE_COLD);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        }
        oTarget = GetNextObjectInArea(oArea);
    }
    fDuration -= 6.0;
    if (fDuration > 1.0)
        DelayCommand(6.0, DoWinterCheck(oArea, fDuration));
}
