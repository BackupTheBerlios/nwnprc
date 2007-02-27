//::///////////////////////////////////////////////
//:: Summon Creature Series
//:: NW_S0_Summon
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Carries out the summoning of the appropriate
    creature for the Summon Monster Series of spells
    1 to 9
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//:://////////////////////////////////////////////
//:: AFW-OEI 05/30/2006:
//::	Changed summon animals.
//::	Changed duration from 24 hours to 3 + 1 round/lvl.
//:://////////////////////////////////////////////
//:: BDF-OEI 06/27/2006:
//::	Added support for SPELL_SHADES_TARGET_GROUND in GetCreatureAnimalDomain
//::	Modified to allow 

effect SetSummonEffect(int nSpellID);
string GetCreature( int nSpellID );
string GetCreatureAnimalDomain( int nSpellID );
int GetEffectID( int nSpellID );

#include "prc_alterations"
#include "x2_inc_spellhook" 

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    int nSpellID = GetSpellId();
    int nDuration = PRCGetCasterLevel(OBJECT_SELF) + 3;
        effect eSummon = SetSummonEffect(nSpellID);

    //Make metamagic check for extend
    int nMetaMagic = PRCGetMetaMagicFeat();
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Apply the VFX impact and summon effect
    MultisummonPreSummon();

    float fDuration = RoundsToSeconds(nDuration);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), fDuration);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}

effect SetSummonEffect(int nSpellID)
{
 	int nFNF_Effect = GetEffectID( nSpellID );
  
    string sSummon = "c_cat";

	sSummon = GetCreatureAnimalDomain( nSpellID );
    effect eSummonedMonster = EffectSummonCreature(sSummon, nFNF_Effect);
    return eSummonedMonster;
}



string GetCreatureAnimalDomain( int nSpellID )
{
	int nRoll = d4();
	string sSummon = "c_dogwolf";
	
	switch (nSpellID)
	{
	case (SPELL_SUMMON_CREATURE_I):
       {
           sSummon = "c_dogwolf";
       }
	break;
	case (SPELL_SUMMON_CREATURE_II):
       {
           sSummon = "c_badgerdire";
       }
	break;
	case (SPELL_SUMMON_CREATURE_III):
       {
           sSummon = "c_dogwolfdire";
       }
	break;
	case (SPELL_SUMMON_CREATURE_IV):
       {
		   sSummon = "c_boardire";
       }
	break;
	case (SPELL_SUMMON_CREATURE_V):
       {
           sSummon = "c_dogshado";
       }
	break;
    case (SPELL_SUMMON_CREATURE_VI):
       {
           sSummon = "c_beardire";
       }
	break;
	case (SPELL_SUMMON_CREATURE_VII):
       {
           switch (nRoll)
           {
               case 1:	sSummon = "c_elmairhuge";		break;
               case 2:	sSummon = "c_elmfirehuge";		break;
               case 3:	sSummon = "c_elmearthhuge";		break;
               case 4:	sSummon = "c_elmwaterhuge";		break;
           }
       }
	break;
	case (SPELL_SUMMON_CREATURE_VIII):
  	case (SPELL_SHADES_TARGET_GROUND):
     {
           switch (nRoll)
           {
               case 1:	sSummon = "c_elmairgreater";		break;
               case 2:	sSummon = "c_elmfiregreater";		break;
               case 3:	sSummon = "c_elmearthgreater";		break;
               case 4:	sSummon = "c_elmwatergreater";		break;
           }
       }
	break;
	case (SPELL_SUMMON_CREATURE_IX):
       {
         switch (nRoll)
          {
               case 1:	sSummon = "c_elmairelder";		break;
               case 2:	sSummon = "c_elmfireelder";		break;
               case 3:	sSummon = "c_elmearthelder";		break;
               case 4:	sSummon = "c_elmwaterelder";		break;
           }
       }
	break;
	}
	return sSummon;
}


string GetCreature( int nSpellID )
{
	int nRoll = d3();
	string sSummon = "c_chicken";

	switch ( nSpellID )
	{
	case (SPELL_SUMMON_CREATURE_I):
        {
            sSummon = "c_badger";
        }
	break;
	case (SPELL_SUMMON_CREATURE_II):
		{
            sSummon = "c_boar";
        }
	break;
	case (SPELL_SUMMON_CREATURE_III):
        {
            sSummon = "c_dogwolf";
        }
	break;
	case (SPELL_SUMMON_CREATURE_IV):
        {
            sSummon = "c_bear";
        }
	break;
	case (SPELL_SUMMON_CREATURE_V):
        {
            sSummon = "c_doghell";
        }
	break;
	case (SPELL_SUMMON_CREATURE_VI):
        {
            sSummon = "c_bugbear";
        }
	break;
	case (SPELL_SUMMON_CREATURE_VII):
        {
            switch (nRoll)
            {
               case 1:	sSummon = "c_impfire";		break;
               case 2:	sSummon = "c_impice";		break;
               case 3:	sSummon = "c_ratdire";		break;
            }
        }
	break;
	case (SPELL_SUMMON_CREATURE_VIII):
  	case (SPELL_SHADES_TARGET_GROUND):
        {
            switch (nRoll)
            {
               case 1:	sSummon = "c_impfire";		break;
               case 2:	sSummon = "c_impice";		break;
               case 3:	sSummon = "c_ratdire";		break;
            }
        }
	break;
	case (SPELL_SUMMON_CREATURE_IX):
        {
            switch (nRoll)
            {
               case 1:	sSummon = "c_impfire";		break;
               case 2:	sSummon = "c_impice";		break;
               case 3:	sSummon = "c_ratdire";		break;
            }
        }
	break;
	}

	return sSummon;
}

int GetEffectID( int nSpellID )
{
	return VFX_HIT_SPELL_SUMMON_CREATURE;
}
