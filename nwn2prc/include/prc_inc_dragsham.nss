
// Metabreath Feats - Not implemented yet. 
/** const int FEAT_CLINGING_BREATH         = 5000;
const int FEAT_LINGERING_BREATH        = 5001;
const int FEAT_ENLARGE_BREATH          = 5002;
const int FEAT_HEIGHTEN_BREATH         = 5003;
const int FEAT_MAXIMIZE_BREATH         = 5004;
const int FEAT_QUICKEN_BREATH          = 5005;
const int FEAT_RECOVER_BREATH          = 5006;
const int FEAT_SHAPE_BREATH            = 5007;
const int FEAT_SPLIT_BREATH            = 5008;
const int FEAT_SPREADING_BREATH        = 5009;
const int FEAT_EXTEND_SPREADING_BREATH = 5010;
const int FEAT_TEMPEST_BREATH          = 5011; **/

// Dragon Shaman Aura flag
const int DRAGON_SHAMAN_AURA_ACTIVE    = 5000;


// Dragon comparisons
const int DRAGON_TYPE_RED                         = 1;
const int DRAGON_TYPE_BLUE                        = 2;
const int DRAGON_TYPE_SILVER                      = 3;
const int DRAGON_TYPE_GREEN                       = 4;
const int DRAGON_TYPE_WHITE                       = 5;
const int DRAGON_TYPE_BLACK                       = 6;
const int DRAGON_TYPE_GOLD                        = 7;
const int DRAGON_TYPE_BRONZE                      = 8;
const int DRAGON_TYPE_BRASS                       = 9;
const int DRAGON_TYPE_COPPER                      = 10;
const int DRAGON_TYPE_INVALID                     = 11;

#include "nwn2_inc_spells"
#include "x2_inc_switches"
#include "prc_alterations"

// returns the type of dragon that the PC has a totem for. Checks for the presence of the
// various feats that are present indicating such. This is necessary for determining the type
// of breath weapon and the type of damage immunity.
int GetDragonType(object oPC);

// Used to create a flag on the caster and store the Aura currently being run.
int StartDragonShamanAura(object oCaster, int nSpellId);

// Does what it says, applies the aura to the friendlies in the area.
void ApplyFriendlyAuraEffectsToArea( object oCaster, int nSpellId, float fDuration,
                                     float fRadius, effect eLink );

// Applies any metabreath feats that the dragon shaman may have to his breathweapon
int ApplyMetaBreathFeatMods( int nDuration, object oCaster );

// Checks to see if target is valid to receive aura
int GetIsObjectValidAuraTarget( object oTarget );

int GetDragonType(object oPC)
{
	// set the returned int
	int nDragonType;
	
	if(GetHasFeat(FEAT_DRAGONSHAMAN_RED, oPC, TRUE)) { nDragonType = DRAGON_TYPE_RED; }
	else if(GetHasFeat(FEAT_DRAGONSHAMAN_BLUE,   oPC, TRUE)) { nDragonType = DRAGON_TYPE_BLUE; }
	else if(GetHasFeat(FEAT_DRAGONSHAMAN_SILVER, oPC, TRUE)) { nDragonType = DRAGON_TYPE_SILVER; }
	else if(GetHasFeat(FEAT_DRAGONSHAMAN_GREEN,  oPC, TRUE)) { nDragonType = DRAGON_TYPE_GREEN; }
	else if(GetHasFeat(FEAT_DRAGONSHAMAN_WHITE,  oPC, TRUE)) { nDragonType = DRAGON_TYPE_WHITE; }
	else if(GetHasFeat(FEAT_DRAGONSHAMAN_BLACK,  oPC, TRUE)) { nDragonType = DRAGON_TYPE_BLACK; }
	else if(GetHasFeat(FEAT_DRAGONSHAMAN_GOLD,   oPC, TRUE)) { nDragonType = DRAGON_TYPE_GOLD; }
	else if(GetHasFeat(FEAT_DRAGONSHAMAN_BRONZE, oPC, TRUE)) { nDragonType = DRAGON_TYPE_BRONZE; }
	else if(GetHasFeat(FEAT_DRAGONSHAMAN_BRASS,  oPC, TRUE)) { nDragonType = DRAGON_TYPE_BRASS; }
	else if(GetHasFeat(FEAT_DRAGONSHAMAN_COPPER, oPC, TRUE)) { nDragonType = DRAGON_TYPE_COPPER; }
	else { nDragonType = DRAGON_TYPE_INVALID; }
	
	return nDragonType;
}

int GetDragonDamageType(object oPC)
{

	//set variables
	int nDragonDamageType;
	int nDragonType; 
	
	if     (GetDragonType(oPC) == DRAGON_TYPE_RED)    { nDragonDamageType = DAMAGE_TYPE_FIRE; }
	else if(GetDragonType(oPC) == DRAGON_TYPE_BLUE)   { nDragonDamageType = DAMAGE_TYPE_ELECTRICAL; }
	else if(GetDragonType(oPC) == DRAGON_TYPE_SILVER) { nDragonDamageType = DAMAGE_TYPE_COLD; }
	else if(GetDragonType(oPC) == DRAGON_TYPE_GREEN)  { nDragonDamageType = DAMAGE_TYPE_ACID; }
	else if(GetDragonType(oPC) == DRAGON_TYPE_WHITE)  { nDragonDamageType = DAMAGE_TYPE_COLD; }
	else if(GetDragonType(oPC) == DRAGON_TYPE_BLACK)  { nDragonDamageType = DAMAGE_TYPE_ACID; }
	else if(GetDragonType(oPC) == DRAGON_TYPE_GOLD)   { nDragonDamageType = DAMAGE_TYPE_FIRE; }
	else if(GetDragonType(oPC) == DRAGON_TYPE_BRONZE) { nDragonDamageType = DAMAGE_TYPE_ELECTRICAL; }
	else if(GetDragonType(oPC) == DRAGON_TYPE_BRASS)  { nDragonDamageType = DAMAGE_TYPE_FIRE; }
	else if(GetDragonType(oPC) == DRAGON_TYPE_COPPER) { nDragonDamageType = DAMAGE_TYPE_ACID; }
	else                                              { nDragonDamageType = -1; }
	
	return nDragonDamageType;

}

int StartDragonShamanAura(object oCaster, int nSpellId)
{
	// Check to see if we are cancelling the current aura 
	if(GetLocalInt(oCaster, "DRAGON_SHAMAN_AURA_ACTIVE") == nSpellId)
	{	
		//if so, delete the flag so that the effect will stop running.
		DeleteLocalInt(oCaster, "DRAGON_SHAMAN_AURA_ACTIVE");
		return TRUE;
	}
	// Check the caster to see if they already have an aura running...
	else if(GetLocalInt(oCaster, "DRAGON_SHAMAN_AURA_ACTIVE") != nSpellId)
	{
		// if so, remove it.
		DeleteLocalInt(oCaster, "DRAGON_SHAMAN_AURA_ACTIVE");
		
		// Set the new flag with the correct spellId
		SetLocalInt(oCaster, "DRAGON_SHAMAN_AURA_ACTIVE", nSpellId);
		return TRUE;
	}
	else // all other conditions
	{
		SetLocalInt(oCaster, "DRAGON_SHAMAN_AURA_ACTIVE", nSpellId);
		return TRUE;
	}
	return FALSE;
}

int GetIsObjectValidAuraTarget( object oTarget )
{
	if ( GetRacialType( oTarget ) == RACIAL_TYPE_INVALID )	
	{
		// Can't inspire a rock
		return FALSE;	
	}

	if ( GetIsDead(oTarget) )	
	{
		return FALSE;
	}

	return TRUE;
}

void ApplyFriendlyAuraEffectsToArea( object oCaster, int nSpellId, float fDuration, float fRadius, effect eLink )
{
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
	// Check to see if the caster already has the aura effect on him. Workaround due to the fact that there may be
	// more than one effect present due to multiple casters.
	int bCasterAlreadyHasShamanAuraEffects = FALSE;
	string sEffect = "DRAGON_SHAMAN_AURA_ACTIVE";
	
	if (GetLocalInt(oCaster, "DRAGON_SHAMAN_AURA_ACTIVE") == nSpellId &&
		GetLocalString(oCaster, "DRAGON_SHAMAN_AURA_ACTIVE") != sEffect)
	{
		bCasterAlreadyHasShamanAuraEffects = TRUE;
	}
	
    while(GetIsObjectValid(oTarget))
    {
		if ( GetIsObjectValidAuraTarget(oTarget) )
		{
        	if( (!GetHasSpellEffect(nSpellId,oTarget)) || 
				(oTarget == oCaster && !bCasterAlreadyHasShamanAuraEffects) )
	        {
	             if ( spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster) )
	                {
		                //Fire cast spell at event for the specified target
		                SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, FALSE));
	                    eLink = SetEffectSpellId( eLink, nSpellId );
	                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	                }
	        }
	        else
	        {
	            // Refresh the duration
	            RefreshSpellEffectDurations(oTarget, nSpellId, fDuration);
	        }
		}
	    oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
    }
}