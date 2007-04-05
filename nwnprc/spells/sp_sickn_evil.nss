//::///////////////////////////////////////////////
//:: Name      Sicken Evil
//:: FileName  sp_sickn_evil.nss
//:://////////////////////////////////////////////
/**@file Sicken Evil 
Necromancy [Good] 
Level: Sanctified 5 
Components: V, S, Sacrifice 
Casting Time: 1 standard action 
Range: Personal
Area: 20-ft.-radius emanation
Duration: 1 minute/level (D) 
Saving Throw: None
Spell Resistance: Yes

You emanate a powerful aura that sickens evil 
creatures within the specified area.

Sacrifice: 1d4 points of Strength damage.

 <Flaming_Sword> sickened: The character takes a -2 
 penalty on all attack rolls, saving throws, skill 
 checks and ability checks.

Author:    Tenjac
Created:   6/30/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        SPSetSchool(SPELL_SCHOOL_NECROMANCY);
        
        //Declare major variables including Area of Effect Object
        effect eAOE = EffectAreaOfEffect(VFX_PER_SICKEN_EVIL);
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        object oItemTarget = oTarget;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nMetaMagic = PRCGetMetaMagicFeat();
        float fDuration = (nCasterLvl * 600.0f);
                
        //Check Extend metamagic feat.
        if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
        {
                fDuration = fDuration *2;    //Duration is +100%
        }
        
        //Create an instance of the AOE Object using the Apply Effect function
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oPC, fDuration);
        
        //Sanctified spells get mandatory 10 pt good adjustment, regardless of switch
        AdjustAlignment(oPC, ALIGNMENT_GOOD, 10);
        
        SPGoodShift(oPC);
        DelayCommand(fDuration, DoCorruptionCost(oPC, ABILITY_STRENGTH, d4(), 0));
        SPSetSchool();
}