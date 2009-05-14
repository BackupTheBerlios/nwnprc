/**
 * @file
 * Spellscript for a range of racial SLAs.
 *
 * Racial SLAs that use DoRacialSLA() are all grouped in this file.
 */
 
const int RACE_SLA_STONESKIN = 1957;
const int RACE_SLA_DARKNESS = 1958;
const int RACE_SLA_DAZE = 1959;
const int RACE_SLA_LIGHT = 1960;
const int RACE_SLA_BLINDNESS_AND_DEAFNESS = 1961;
const int RACE_SLA_DUERGAR_INVIS = 1962;
const int RACE_SLA_CHARM_MONSTER = 1963;
const int RACE_SLA_CHARM_PERSON = 1964;
const int RACE_SLA_ENERVATION = 1969;
const int RACE_SLA_ENTANGLE = 1970;
const int RACE_SLA_FEAR = 1971;
const int RACE_SLA_CLAIRAUDIENCE_AND_CLAIRVOYANCE = 1972;
const int RACE_SLA_NEUTRALIZE_POISON = 1973;
const int RACE_SLA_CONFUSION = 1974;
const int RACE_SLA_INVISIBILITY = 1975;
const int RACE_SLA_DISPEL_MAGIC = 1976;
const int RACE_SLA_CHILL_TOUCH = 1977;
const int RACE_SLA_SILENCE = 1989;
const int RACE_SLA_MAGE_HAND = 1990;
const int RACE_SLA_VAMPIRIC_TOUCH = 1996;
const int RACE_SLA_LIGHTNING_BOLT = 2917;
const int RACE_SLA_CURE_S_WOUNDS = 2918;
const int RACE_SLA_GUST_OF_WIND = 2919;
const int RACE_SLA_MIRROR_IMAGE = 2920;
const int RACE_SLA_FLARE = 2922;
const int RACE_SLA_AID = 2930;
const int RACE_SLA_CONTINUAL_FLAME = 2932;
const int RACE_SLA_TELEPORT = 2935;
const int RACE_SLA_TRUE_STRIKE = 2937;
const int RACE_SLA_EXP_RETREAT = 2943;
 
#include "prc_alterations"

void main()
{
    int nSpellID = GetSpellId();
    int nCasterLvl;
    int nDC;
    
    switch(nSpellID)
    {
        case RACE_SLA_STONESKIN: // urdinnir stoneskin
        {
            nCasterLvl = 4;
            DoRacialSLA(SPELL_STONESKIN, nCasterLvl);
            break;
        }
        case RACE_SLA_DARKNESS: // darkness
        {
            if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_TIEFLING) { nCasterLvl = GetHitDice(OBJECT_SELF); }
            else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_FEYRI) { nCasterLvl = GetHitDice(OBJECT_SELF); }
            else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_PURE_YUAN) { nCasterLvl = 3; }
            else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ABOM_YUAN) { nCasterLvl = 3; }
            else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_DROW_MALE) { nCasterLvl = 3; }
            else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_DROW_FEMALE) { nCasterLvl = 3; }
            else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_OMAGE) { nCasterLvl = 9; }
            DoRacialSLA(SPELL_DARKNESS, nCasterLvl);
            break;
        }
        case RACE_SLA_DAZE: // daze
        {
            if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_GITHYANKI || GetRacialType(OBJECT_SELF) == RACIAL_TYPE_GITHZERAI) { nCasterLvl = 3; }
            DoRacialSLA(SPELL_DAZE, nCasterLvl);
            break;
        }
        case RACE_SLA_LIGHT: // gloaming, aasimar, irda light
        {
            nCasterLvl = GetHitDice(OBJECT_SELF);
            DoRacialSLA(SPELL_LIGHT, nCasterLvl);
            break;
        }
        case RACE_SLA_BLINDNESS_AND_DEAFNESS: // deep gnome blindness/deafness
        {
            nCasterLvl = GetHitDice(OBJECT_SELF);
            // 10 + Spell level (2) + Racial bonus (4) + Cha Mod
            nDC = 16 + GetAbilityModifier(ABILITY_CHARISMA);
            DoRacialSLA(SPELL_BLINDNESS_AND_DEAFNESS, nCasterLvl, nDC);
            break;
        }
        case RACE_SLA_CHARM_MONSTER: // illithid charm monster
        {
            nCasterLvl = 8;
            DoRacialSLA(SPELL_CHARM_MONSTER, nCasterLvl);
            break;
        }
        case RACE_SLA_CHARM_PERSON: // charm person
        {
            if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_PURE_YUAN) { nCasterLvl = 3; }
            else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_NIXIE) { nCasterLvl = 4; }
            else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_FEYRI) { nCasterLvl = GetHitDice(OBJECT_SELF); }
            else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_BRALANI) { nCasterLvl = 6; }
            else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_OMAGE) { nCasterLvl = 9; }
            DoRacialSLA(SPELL_CHARM_PERSON, nCasterLvl);
            break;
        }
        case RACE_SLA_ENERVATION: // feyri enervation
        {
            nCasterLvl = GetHitDice(OBJECT_SELF);
            DoRacialSLA(SPELL_ENERVATION, nCasterLvl);
            break;
        }
        case RACE_SLA_ENTANGLE: // entangle
        {
            if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_PIXIE) { nCasterLvl = 8; }    
            else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_PURE_YUAN) { nCasterLvl = 3; }
            else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ABOM_YUAN) { nCasterLvl = 3; }
            else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_GRIG) { nCasterLvl = 9; }
            DoRacialSLA(SPELL_ENTANGLE, nCasterLvl);
            break;
        }
        case RACE_SLA_FEAR: // fear
        {
            if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_PURE_YUAN) { nCasterLvl = 3; }
            else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ABOM_YUAN) { nCasterLvl = 3; }
            DoRacialSLA(SPELL_FEAR, nCasterLvl);
            break;
        }
        case RACE_SLA_CLAIRAUDIENCE_AND_CLAIRVOYANCE: // feyri clairaudience and clairvoyance
        {
            nCasterLvl = GetHitDice(OBJECT_SELF);
            DoRacialSLA(SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, nCasterLvl);
            break;
        }
        case RACE_SLA_NEUTRALIZE_POISON: // yuan-ti neutralise poison
        {
            DoRacialSLA(SPELL_NEUTRALIZE_POISON);
            break;
        }
        case RACE_SLA_CONFUSION: // pixie confusion
        {
            nCasterLvl = 8;
            DoRacialSLA(SPELL_CONFUSION, nCasterLvl);
            break;
        }
        case RACE_SLA_INVISIBILITY: // pixie invisibility
        case RACE_SLA_DUERGAR_INVIS: // duergar invisibility
        {
            nCasterLvl = 8;
            if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_GRIG) { nCasterLvl = 9; }
            else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_DUERGAR) { nCasterLvl = (GetHitDice(OBJECT_SELF) * 2);}
            DoRacialSLA(SPELL_INVISIBILITY, nCasterLvl);
            break;
        }
        case RACE_SLA_DISPEL_MAGIC: // pixie dispel magic
        {
            nCasterLvl = 8;
            DoRacialSLA(SPELL_DISPEL_MAGIC, nCasterLvl);
            break;
        }
        case RACE_SLA_CHILL_TOUCH: // mortif, frost dwarf, zakya rakshasa chill touch
        {
            if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_MORTIF) { nCasterLvl = (GetHitDice(OBJECT_SELF))+2; }
            else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_FROST_DWARF) { nCasterLvl = GetHitDice(OBJECT_SELF); }
            else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ZAKYA_RAKSHASA) { nCasterLvl = 7; }
            DoRacialSLA(SPELL_CHILL_TOUCH, nCasterLvl);
            break;
        }
        case RACE_SLA_SILENCE: // whisper gnome silence
        {
            nCasterLvl = GetHitDice(OBJECT_SELF);
            DoRacialSLA(SPELL_SILENCE, nCasterLvl);
            break;
        }
        case RACE_SLA_MAGE_HAND: // whisper gnome and irda mage hand
        {
            nCasterLvl = GetHitDice(OBJECT_SELF);
            DoRacialSLA(SPELL_MAGE_HAND, nCasterLvl);
            break;
        }
        case RACE_SLA_VAMPIRIC_TOUCH: // zankya rakshasa vampiric touch
        {
            if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ZAKYA_RAKSHASA) { nCasterLvl = 7; }
            DoRacialSLA(SPELL_VAMPIRIC_TOUCH, nCasterLvl);
            break;
        }
        case SPELL_GRIG_PYROTECHNICS_FIREWORKS: // grig pyrotechnics
        {
            nCasterLvl = 9;
            DoRacialSLA(SPELL_PYROTECHNICS_FIREWORKS, nCasterLvl);
            break;
        }
        case SPELL_GRIG_PYROTECHNICS_SMOKE:
        {
            nCasterLvl = 9;
            DoRacialSLA(SPELL_PYROTECHNICS_SMOKE, nCasterLvl);
            break;
        }
        case RACE_SLA_LIGHTNING_BOLT: // bralani lightning bolt
        {
            nCasterLvl = 6;   
            DoRacialSLA(SPELL_LIGHTNING_BOLT, nCasterLvl);
            break;
        }
        case RACE_SLA_CURE_S_WOUNDS: // bralani cure serious wounds
        {
            nCasterLvl = 6;   
            DoRacialSLA(SPELL_CURE_SERIOUS_WOUNDS, nCasterLvl);
            break;
        }
        case RACE_SLA_GUST_OF_WIND: // bralani gust of wind
        {
            nCasterLvl = 6;   
            DoRacialSLA(SPELL_GUST_OF_WIND, nCasterLvl);
            break;
        }
        case RACE_SLA_MIRROR_IMAGE: // bralani mirror image
        {
            nCasterLvl = 6;   
            DoRacialSLA(SPELL_MIRROR_IMAGE, nCasterLvl);
            break;
        }
        case RACE_SLA_FLARE: // irda flare
        {
            nCasterLvl = GetHitDice(OBJECT_SELF);   
            DoRacialSLA(SPELL_FLARE, nCasterLvl);
            break;
        }
        case RACE_SLA_AID: // hound archon aid
        {
            nCasterLvl = 6;
            DoRacialSLA(SPELL_AID, nCasterLvl);
            break;
        }
        case RACE_SLA_CONTINUAL_FLAME: // hound archon continual flame
        {
            nCasterLvl = 6;
            DoRacialSLA(SPELL_CONTINUAL_FLAME, nCasterLvl);
        }
        case RACE_SLA_TELEPORT: // hound archon teleport
        {
            nCasterLvl = 6;
            DoRacialSLA(SPELL_GREATER_TELEPORT_SELF, nCasterLvl);
            break;
        }
        case RACE_SLA_TRUE_STRIKE: // zenthri true strike
        {
            nCasterLvl = GetHitDice(OBJECT_SELF);
            DoRacialSLA(SPELL_TRUE_STRIKE, nCasterLvl);
            break;
        }
        case SPELL_RACIAL_CIRCLE_VS_GOOD:
        {
            nCasterLvl = GetHitDice(OBJECT_SELF);
            DoRacialSLA(SPELL_MAGIC_CIRCLE_AGAINST_GOOD, nCasterLvl);
            break;
        }
        case SPELL_RACIAL_CIRCLE_VS_EVIL:
        {
            nCasterLvl = GetHitDice(OBJECT_SELF);
            DoRacialSLA(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, nCasterLvl);
            break;
        }
        case SPELL_RACIAL_CIRCLE_VS_LAW:
        {
            nCasterLvl = GetHitDice(OBJECT_SELF);
            DoRacialSLA(SPELL_MAGIC_CIRCLE_AGAINST_LAW, nCasterLvl);
            break;
        }
        case SPELL_RACIAL_CIRCLE_VS_CHAOS:
        {
            nCasterLvl = GetHitDice(OBJECT_SELF);
            DoRacialSLA(SPELL_MAGIC_CIRCLE_AGAINST_CHAOS, nCasterLvl);
            break;
        }
        case RACE_SLA_EXP_RETREAT: // nathri expeditious retreat
        {
            nCasterLvl = GetHitDice(OBJECT_SELF);
            DoRacialSLA(SPELL_EXPEDITIOUS_RETREAT, nCasterLvl);
            break;
        }
        case SPELL_NYMPH_DIMDOOR_SELF: // nymph dimension door
        {
            nCasterLvl = 7;
            DoRacialSLA(SPELL_DIMENSION_DOOR_SELF, nCasterLvl);
            break;
        }
        case SPELL_NYMPH_DIMDOOR_PARTY:
        {
            nCasterLvl = 7;
            DoRacialSLA(SPELL_DIMENSION_DOOR_PARTY, nCasterLvl);
            break;
        }
        case SPELL_NYMPH_DIMDOOR_DIST_SELF:
        {
            nCasterLvl = 7;
            DoRacialSLA(SPELL_DIMENSION_DOOR_DIRDIST_SELF, nCasterLvl);
            break;
        }
        case SPELL_NYMPH_DIMDOOR_DIST_PARTY:
        {
            nCasterLvl = 7;
            DoRacialSLA(SPELL_DIMENSION_DOOR_DIRDIST_PARTY, nCasterLvl);
            break;
        }
    }
}
