//
//	New function split in different logical places.
//	All scripts should be in their logical spot for optimum performance.
//
//	Heavily modified by Kaltor, mar 30 2004
//
//	NOTE:	Most classes are added to the arcane or divine section.
//			Check the progress rate and comments in code to determine
//			which class.  If a special rule is needed seek assistance
//			as required.
//

#include "prc_alterations"

const float CACHE_INVALIDATE_CASTER_LEVEL = 6.0;

//
//	Is this base class an Arcane Caster?
//
int
IsArcaneClass(int nClass)
{
    return nClass == CLASS_TYPE_WIZARD
		|| nClass == CLASS_TYPE_SORCERER
		|| nClass == CLASS_TYPE_BARD;
}

//
//	Is this base class a Divine Caster?
//
int
IsDivineClass(int nClass)
{
    return nClass == CLASS_TYPE_CLERIC
		|| nClass == CLASS_TYPE_DRUID
		|| nClass == CLASS_TYPE_PALADIN
		|| nClass == CLASS_TYPE_RANGER;
}

int
PractisedSpellCast( int nLevelBonus,int nCastingClass ,object oCaster)
{
   int DiffCasterLvl = GetHitDice(oCaster)-(GetCasterLevel(oCaster)+nLevelBonus);
   int nBonus ;
  
   if (DiffCasterLvl)
   {
    	int nFeat;
    	
       	if (nCastingClass == CLASS_TYPE_BARD)           nFeat = FEAT_PRACTISED_SPELLCASTER_BARD;    	
    	else if (nCastingClass == CLASS_TYPE_SORCERER)  nFeat = FEAT_PRACTISED_SPELLCASTER_SORCERER; 
       	else if (nCastingClass == CLASS_TYPE_WIZARD)    nFeat = FEAT_PRACTISED_SPELLCASTER_WIZARD; 
       	else if (nCastingClass == CLASS_TYPE_CLERIC)    nFeat = FEAT_PRACTISED_SPELLCASTER_CLERIC; 
       	else if (nCastingClass == CLASS_TYPE_DRUID)     nFeat = FEAT_PRACTISED_SPELLCASTER_DRUID; 
       	
       	if (GetHasFeat(nFeat,oCaster)){
           nBonus = DiffCasterLvl >4 ? 4:DiffCasterLvl;
        }
           

   }
   
   return nBonus;
	
}

void main()
{
	// Items do not have PRC classes.
	if (GetSpellCastItem() != OBJECT_INVALID)
		return;

	int nPrevious = GetLocalInt(OBJECT_SELF, CASTER_LEVEL_TAG);
	if (nPrevious > 0) {
		SetLocalInt(OBJECT_SELF,"X2_L_LAST_RETVAR", nPrevious);
		return;
	}

	object oCaster = OBJECT_SELF;
	int nCastingClass = GetLastSpellCastClass();

	// Verify that an arcane or divine spell was cast
	int bIsArcane = IsArcaneClass(nCastingClass);
	int bIsDivine = IsDivineClass(nCastingClass);
	if (!bIsArcane && !bIsDivine)
		return;

	// Keep a running total of the bonus.
        int nLevelBonus = 0;

	// I am so not sure this nFirstClass does the right thing.
	int nFirstClass = GetClassByPosition(1, oCaster);

	// These calculations are performed and used more than once
	int nOozeMLevel = GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);

	//
	//	Calculate for feats that boost caster level regardless of spell type
	//

	// Adjust for FIRE_ADEPT
	if (GetHasFeat(FEAT_FIRE_ADEPT, oCaster)
			&& lookup_spell_type(GetSpellId()) == "Fire")
		++nLevelBonus;
	
	//
	//	Calculate improvements for the Arcane Casters
	//
    if (bIsArcane) {
		// I am not sure what use this line has
        if (nFirstClass != nCastingClass && IsArcaneClass(nFirstClass))
            return;

        nLevelBonus += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster)
			+ GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster)
			+ GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster)
			+ GetLevelByClass(CLASS_TYPE_ES_ACID, oCaster)
			+ GetLevelByClass(CLASS_TYPE_ES_COLD, oCaster)
			+ GetLevelByClass(CLASS_TYPE_ES_ELEC, oCaster)
			+ GetLevelByClass(CLASS_TYPE_ES_FIRE, oCaster)
			+ GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster)
			+ GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster)
			+ GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster)
                        + GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster)
                        + GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster)
			+ GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster);

		// This section of code tests for half progression classes.
		// Leave the integer div-by two where it is, it is not distributive.
		nLevelBonus += GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) / 2
			+ GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) / 2
			+ GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) / 2
			+ GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) / 2
			+ GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) / 2
			+ GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) / 2;

		//
		//	Class specific code for Arcane Casters
		//
		// Using nFirstClass does not look right
        if (nOozeMLevel) {
            if (IsArcaneClass(nFirstClass) || (!IsDivineClass(nFirstClass)
					&& IsArcaneClass(GetClassByPosition(2, oCaster))))
                nLevelBonus += nOozeMLevel / 2;
        }

        nLevelBonus += PractisedSpellCast(nLevelBonus,nCastingClass,oCaster);
        
		// Calculate feat specific improvements specific to Arcane Casting
		// This is an optimizated sequence of code.
        if (GetHasFeat(FEAT_SPELL_POWER_I)) {
            nLevelBonus += 1;
			if (GetHasFeat(FEAT_SPELL_POWER_V))
				nLevelBonus += 4;
			else if (GetHasFeat(FEAT_SPELL_POWER_IV))
				nLevelBonus += 3;
			else if (GetHasFeat(FEAT_SPELL_POWER_III))
				nLevelBonus += 2;
            else if (GetHasFeat(FEAT_SPELL_POWER_II))
				nLevelBonus += 1;
        }

		// Add in the other caster class when casting necro spells
        if (lookup_spell_school(GetSpellId()) == "N")
			nLevelBonus += GetLevelByClass(CLASS_TYPE_CLERIC, oCaster);

    }
	//
	//	Calculate bonus for Divine Casters
	//
    else if (bIsDivine) {

		// Again, I am not sure this is correct
        if (nFirstClass != nCastingClass && IsDivineClass(nFirstClass))
            return;

		// This section accounts for full progression classes
        nLevelBonus += GetLevelByClass(CLASS_TYPE_DIVESA, oCaster)
			+ GetLevelByClass(CLASS_TYPE_DIVESC, oCaster)
			+ GetLevelByClass(CLASS_TYPE_DIVESE, oCaster)
			+ GetLevelByClass(CLASS_TYPE_DIVESF, oCaster)
			+ GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster)
			+ GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster)
			+ GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster)
			+ GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster)
			+ GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster)
			+ GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster)
			+ GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);

		// This section of code tests for half progression classes.
		// Leave the integer div-by two where it is, it is not distributive.
		nLevelBonus += GetLevelByClass(CLASS_TYPE_KNIGHT_CHALICE, oCaster) / 2
			+ GetLevelByClass(CLASS_TYPE_OCULAR, oCaster) / 2
			+ GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster) / 2
			+ GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) / 2
			+ (GetLevelByClass(CLASS_TYPE_BFZ, oCaster) + 1) / 2
			+ (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;

                if ( !GetHasFeat(FEAT_SF_CODE, oCaster))
                        nLevelBonus += (GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster) + 1) / 2;

		//
		//	Class specific code for Divine Casters
		//
		
				// Using nFirstClass does not look right
        if (nOozeMLevel) {
            if (IsDivineClass(nFirstClass) || (!IsArcaneClass(nFirstClass)
					&& IsDivineClass(GetClassByPosition(2, oCaster))))
                nLevelBonus += nOozeMLevel / 2;
        }

        nLevelBonus += PractisedSpellCast(nLevelBonus,nCastingClass,oCaster);
        
		// Add in the other caster class when casting necro spells
        if (lookup_spell_school(GetSpellId()) == "N")
			nLevelBonus += GetLevelByClass(CLASS_TYPE_WIZARD, oCaster);
			nLevelBonus += GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster);

    }

 

	// Cache the bonus
    SetLocalInt(oCaster, CASTER_LEVEL_TAG, nLevelBonus);
    DelayCommand(CACHE_INVALIDATE_CASTER_LEVEL,
		DeleteLocalInt(oCaster, CASTER_LEVEL_TAG));

	// Set the return value
    SetLocalInt(oCaster,"X2_L_LAST_RETVAR", nLevelBonus);
}
