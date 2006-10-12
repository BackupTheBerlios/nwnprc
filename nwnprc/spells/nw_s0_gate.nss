//::///////////////////////////////////////////////
//:: Gate
//:: NW_S0_Gate.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: Summons a Balor to fight for the caster.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_alterations"
#include "x2_inc_spellhook"


void CreateBalor()
{
     CreateObject(OBJECT_TYPE_CREATURE, "NW_S_BALOR_EVIL", PRCGetSpellTargetLocation());
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


        if (!GetLocalInt(OBJECT_SELF, "DimAnchor"))
	{
		// Do the gating
        	float fDur     = RoundsToSeconds(PRCGetCasterLevel(OBJECT_SELF));
        	int nMetaMagic = PRCGetMetaMagicFeat();
        	if(nMetaMagic & METAMAGIC_EXTEND) fDur *= 2;
        	SetLocalFloat(OBJECT_SELF, "TrueGateDuration", fDur);
        	
        	StartDynamicConversation("true_gate_conv", OBJECT_SELF, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, OBJECT_SELF);
        }
        else
        {
        	FloatingTextStringOnCreature("You are under a Dimensional Anchor. Utterance fails.", OBJECT_SELF, FALSE);
        }

/*
if (!GetLocalInt(OBJECT_SELF, "DimAnchor"))
{

    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLevel;
    effect eSummon;
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
    //Make metamagic extend check
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Summon the Balor and apply the VFX impact
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, PRCGetSpellTargetLocation());
    location lSpellTargetLOC = PRCGetSpellTargetLocation();

    if(GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL) ||
       GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL) ||
       GetHasSpellEffect(SPELL_HOLY_AURA))
    {
        eSummon = EffectSummonCreature("NW_S_BALOR",VFX_FNF_SUMMON_GATE,3.0);
        float fSeconds = RoundsToSeconds(nDuration);
        if(GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
            fSeconds = RoundsToSeconds(nDuration*GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL));
        DelayCommand(6.0, MultisummonPreSummon());
        DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lSpellTargetLOC, fSeconds));

    }
    else
    {

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lSpellTargetLOC);
        DelayCommand(3.0, CreateBalor());
    }
}*/
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

