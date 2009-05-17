//::///////////////////////////////////////////////
//:: Name      Plague of Undead
//:: FileName  sp_plaguedead.nss
//:://////////////////////////////////////////////
/**@file Plague of Undead
Necromancy [Evil]
Level: Clr 9, Dn 9, Wiz 9
Components: V, S
Casting Time: 1 standard action
Range: Close
Effect: Raise Undead
Duration: Permanent

You summon 4 Bone Warriors. These last until they are killed.

Author:    Stratovarius
Created:   5/17/2009
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
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
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = 24;
    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    effect eSummon = EffectSummonCreature("prc_sum_bonewar");
    string sResRef;
    int nHD = 10;
    //Metamagic extension if needed
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration * 2;  //Duration is +100%
    }
    MultisummonPreSummon();
    int i;
    for(i = 1; i <= 4; i++) // 4 monsters
    {
        int nMaxHD = nCasterLevel*4;
        if (GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, OBJECT_SELF) >= 8)
        {
        	nMaxHD = nCasterLevel * (4 + GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF));
        }
        int nTotalHD = GetControlledUndeadTotalHD();
        if((nTotalHD+nHD)<=nMaxHD)
        {        
            eSummon = SupernaturalEffect(eSummon);    
            ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSummon, PRCGetSpellTargetLocation());
        }
        else
            FloatingTextStringOnCreature("You cannot create more undead at this time.", OBJECT_SELF);
        FloatingTextStringOnCreature("Currently have "+IntToString(nTotalHD+nHD)+"HD out of "+IntToString(nMaxHD)+"HD.", OBJECT_SELF);
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}


