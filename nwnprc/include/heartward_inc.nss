// VFX Persistant
const int VFX_MOB_CIRCEVIL_NODIS   = 110 ;

// Battleguard Tempus
const int TEMPUS_ABILITY_ENHANC1   = 1;
const int TEMPUS_ABILITY_ENHANC2   = 2;
const int TEMPUS_ABILITY_ENHANC3   = 3;
const int TEMPUS_ABILITY_FIRE1D6   = 4;
const int TEMPUS_ABILITY_COLD1D6   = 5;
const int TEMPUS_ABILITY_ELEC1D6   = 6;
const int TEMPUS_ABILITY_KEEN      = 7;
const int TEMPUS_ABILITY_ANARCHIC  = 8;
const int TEMPUS_ABILITY_AXIOMATIC = 9;
const int TEMPUS_ABILITY_HOLY      = 10;
const int TEMPUS_ABILITY_UNHOLY    = 11;
const int TEMPUS_ABILITY_VICIOUS   = 12;
const int TEMPUS_ABILITY_DISRUPTION= 13;
const int TEMPUS_ABILITY_WOUNDING  = 14;
const int TEMPUS_ABILITY_BARSKIN   = 15;
const int TEMPUS_ABILITY_CONECOLD  = 16;
const int TEMPUS_ABILITY_DARKNESS  = 17;
const int TEMPUS_ABILITY_FIREBALL  = 18;
const int TEMPUS_ABILITY_HASTE     = 19;
const int TEMPUS_ABILITY_IMPROVINV = 20;
const int TEMPUS_ABILITY_LIGHTBOLT = 21;
const int TEMPUS_ABILITY_MAGICMISSILE  = 22;
const int TEMPUS_ABILITY_WEB       = 23;
const int TEMPUS_ABILITY_VAMPIRE   = 24;

// Polymproh
const int POLY_SHAPEDRAGONGOLD  = 130;
const int POLY_SHAPEDRAGONRED   = 131;
const int POLY_SHAPEDRAGONPRYS  = 132;

//Vile
const int FEAT_VILE_MARTIAL_CLUB          = 3357;
const int FEAT_VILE_MARTIAL_DAGGER        = 3358;
const int FEAT_VILE_MARTIAL_MACE          = 3359;
const int FEAT_VILE_MARTIAL_MORNINGSTAR   = 3360;
const int FEAT_VILE_MARTIAL_QUATERSTAFF   = 3361;
const int FEAT_VILE_MARTIAL_SPEAR         = 3362;
const int FEAT_VILE_MARTIAL_SHORTSWORD    = 3363;
const int FEAT_VILE_MARTIAL_RAPIER        = 3364;
const int FEAT_VILE_MARTIAL_SCIMITAR      = 3365;
const int FEAT_VILE_MARTIAL_LONGSWORD     = 3366;
const int FEAT_VILE_MARTIAL_GREATSWORD    = 3367;
const int FEAT_VILE_MARTIAL_HANDAXE       = 3368;
const int FEAT_VILE_MARTIAL_BATTLEAXE     = 3369;
const int FEAT_VILE_MARTIAL_GREATAXE      = 3370;
const int FEAT_VILE_MARTIAL_HALBERD       = 3371;
const int FEAT_VILE_MARTIAL_LIGHTHAMMER   = 3372;
const int FEAT_VILE_MARTIAL_LIGHTFLAIL    = 3373;
const int FEAT_VILE_MARTIAL_WARHAMMER     = 3374;
const int FEAT_VILE_MARTIAL_HEAVYFLAIL    = 3375;
const int FEAT_VILE_MARTIAL_SCYTHE        = 3376;
const int FEAT_VILE_MARTIAL_KATANA        = 3377;
const int FEAT_VILE_MARTIAL_BASTARDSWORD  = 3378;
const int FEAT_VILE_MARTIAL_DIREMACE      = 3379;
const int FEAT_VILE_MARTIAL_DOUBLEAXE     = 3380;
const int FEAT_VILE_MARTIAL_TWOBLADED     = 3381;
const int FEAT_VILE_MARTIAL_KAMA          = 3382;
const int FEAT_VILE_MARTIAL_KUKRI         = 3383;
const int FEAT_VILE_MARTIAL_HEAVYCROSSBOW = 3384;
const int FEAT_VILE_MARTIAL_LIGHTCROSSBOW = 3385;
const int FEAT_VILE_MARTIAL_SLING         = 3386;
const int FEAT_VILE_MARTIAL_LONGBOW       = 3387;
const int FEAT_VILE_MARTIAL_SHORTBOW      = 3396;
const int FEAT_VILE_MARTIAL_SHURIKEN      = 3397;
const int FEAT_VILE_MARTIAL_DART          = 3398;
const int FEAT_VILE_MARTIAL_SICKLE        = 3399;
const int FEAT_VILE_MARTIAL_DWAXE         = 3452;


int Vile_Feat(int iTypeWeap)
{
       switch(iTypeWeap)
            {
                case BASE_ITEM_BASTARDSWORD: return GetHasFeat(FEAT_VILE_MARTIAL_BASTARDSWORD);
                case BASE_ITEM_BATTLEAXE: return GetHasFeat(FEAT_VILE_MARTIAL_BATTLEAXE);
                case BASE_ITEM_CLUB: return GetHasFeat(FEAT_VILE_MARTIAL_CLUB);
                case BASE_ITEM_DAGGER: return GetHasFeat(FEAT_VILE_MARTIAL_DAGGER);
                case BASE_ITEM_DART: return GetHasFeat(FEAT_VILE_MARTIAL_DART);
                case BASE_ITEM_DIREMACE: return GetHasFeat(FEAT_VILE_MARTIAL_DIREMACE);
                case BASE_ITEM_DOUBLEAXE: return GetHasFeat(FEAT_VILE_MARTIAL_DOUBLEAXE);
                case BASE_ITEM_DWARVENWARAXE: return GetHasFeat(FEAT_VILE_MARTIAL_DWAXE);
                case BASE_ITEM_GREATAXE: return GetHasFeat(FEAT_VILE_MARTIAL_GREATAXE);
                case BASE_ITEM_GREATSWORD: return GetHasFeat(FEAT_VILE_MARTIAL_GREATSWORD);
                case BASE_ITEM_HALBERD: return GetHasFeat(FEAT_VILE_MARTIAL_HALBERD);
                case BASE_ITEM_HANDAXE: return GetHasFeat(FEAT_VILE_MARTIAL_HANDAXE);
                case BASE_ITEM_HEAVYCROSSBOW: return GetHasFeat(FEAT_VILE_MARTIAL_HEAVYCROSSBOW);
                case BASE_ITEM_HEAVYFLAIL: return GetHasFeat(FEAT_VILE_MARTIAL_HEAVYFLAIL);
                case BASE_ITEM_KAMA: return GetHasFeat(FEAT_VILE_MARTIAL_KAMA);
                case BASE_ITEM_KATANA: return GetHasFeat(FEAT_VILE_MARTIAL_KATANA);
                case BASE_ITEM_KUKRI: return GetHasFeat(FEAT_VILE_MARTIAL_KUKRI);
                case BASE_ITEM_LIGHTCROSSBOW: return GetHasFeat(FEAT_VILE_MARTIAL_LIGHTCROSSBOW);
                case BASE_ITEM_LIGHTFLAIL: return GetHasFeat(FEAT_VILE_MARTIAL_LIGHTFLAIL);
                case BASE_ITEM_LIGHTHAMMER: return GetHasFeat(FEAT_VILE_MARTIAL_LIGHTHAMMER);
                case BASE_ITEM_LIGHTMACE: return GetHasFeat(FEAT_VILE_MARTIAL_MACE);
                case BASE_ITEM_LONGBOW: return GetHasFeat(FEAT_VILE_MARTIAL_LONGBOW);
                case BASE_ITEM_LONGSWORD: return GetHasFeat(FEAT_VILE_MARTIAL_LONGSWORD);
                case BASE_ITEM_MORNINGSTAR: return GetHasFeat(FEAT_VILE_MARTIAL_MORNINGSTAR);
                case BASE_ITEM_QUARTERSTAFF: return GetHasFeat(FEAT_VILE_MARTIAL_QUATERSTAFF);
                case BASE_ITEM_RAPIER: return GetHasFeat(FEAT_VILE_MARTIAL_RAPIER);
                case BASE_ITEM_SCIMITAR: return GetHasFeat(FEAT_VILE_MARTIAL_SCIMITAR);
                case BASE_ITEM_SCYTHE: return GetHasFeat(FEAT_VILE_MARTIAL_SCYTHE);
                case BASE_ITEM_SHORTBOW: return GetHasFeat(FEAT_VILE_MARTIAL_SHORTBOW);
                case BASE_ITEM_SHORTSPEAR: return GetHasFeat(FEAT_VILE_MARTIAL_SPEAR);
                case BASE_ITEM_SHORTSWORD: return GetHasFeat(FEAT_VILE_MARTIAL_SHORTSWORD);
                case BASE_ITEM_SHURIKEN: return GetHasFeat(FEAT_VILE_MARTIAL_SHURIKEN);
                case BASE_ITEM_SLING: return GetHasFeat(FEAT_VILE_MARTIAL_SLING);
                case BASE_ITEM_SICKLE: return GetHasFeat(FEAT_VILE_MARTIAL_SICKLE);
                case BASE_ITEM_TWOBLADEDSWORD: return GetHasFeat(FEAT_VILE_MARTIAL_TWOBLADED);
                case BASE_ITEM_WARHAMMER: return GetHasFeat(FEAT_VILE_MARTIAL_WARHAMMER);
                case BASE_ITEM_WHIP: return GetHasFeat(FEAT_VILE_MARTIAL_SLING);
            }
    return 0;
}