//::///////////////////////////////////////////////
//:: Summon Monster VII
//:: NW_S0_Summon7
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a Minogon to fight for the character
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_alterations"



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
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = PRCGetCasterLevel(OBJECT_SELF);
    effect eSummon;
    int nRoll = d4();
    if(GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER))
    {
        switch (nRoll)
        {
            case 1:
                eSummon = EffectSummonCreature("NW_S_AIRGREAT");
            break;

            case 2:
                eSummon = EffectSummonCreature("NW_S_WATERGREAT");
            break;

            case 3:
                eSummon = EffectSummonCreature("NW_S_EARTHGREAT");
            break;

            case 4:
                eSummon = EffectSummonCreature("NW_S_FIREGREAT");
            break;
        }
    }
    else
    {
        switch (nRoll)
        {
            case 1:
                eSummon = EffectSummonCreature("NW_S_AIRHUGE");
            break;

            case 2:
                eSummon = EffectSummonCreature("NW_S_WATERHUGE");
            break;

            case 3:
                eSummon = EffectSummonCreature("NW_S_EARTHHUGE");
            break;

            case 4:
                eSummon = EffectSummonCreature("NW_S_FIREHUGE");
            break;
        }
    }
    if(GetHasFeat(FEAT_SUMMON_ALIEN))
    {
        if(GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER))
        {
            switch (nRoll)
            {
                case 1:
                    eSummon = EffectSummonCreature("PSEUDOAIRGREAT");
                break;

                case 2:
                    eSummon = EffectSummonCreature("PSEUDOWATERGREAT");
                break;

                case 3:
                    eSummon = EffectSummonCreature("PSEUDOEARTHGREAT");
                break;

                case 4:
                    eSummon = EffectSummonCreature("PSEUDOFIREGREAT");
                break;
            }
        }
        else
        {
            switch (nRoll)
            {
                case 1:
                    eSummon = EffectSummonCreature("PSEUDOAIRHUGE");
                break;

                case 2:
                    eSummon = EffectSummonCreature("PSEUDOWATERHUGE");
                break;

                case 3:
                    eSummon = EffectSummonCreature("PSEUDOEARTHHUGE");
                break;

                case 4:
                    eSummon = EffectSummonCreature("PSEUDOFIREHUGE");
                break;
            }
        }
    }
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
    //Make metamagic check for extend
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Apply the VFX impact and summon effect
    MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, PRCGetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), TurnsToSeconds(nDuration));

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
