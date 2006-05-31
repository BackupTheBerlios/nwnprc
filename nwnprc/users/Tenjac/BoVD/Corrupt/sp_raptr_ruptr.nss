//::///////////////////////////////////////////////
//:: Name      Rapture of Rupture
//:: FileName  sp_rapt_rupt.nss
//:://////////////////////////////////////////////
/** @file
Rapture of Rupture
Transmutation [Evil]
Level: Corrupt 7
Components: V, S, Corrupt
Casting Time: 1 action
Range: Touch
Target: One living creature touched per level
Duration: Instantaneous
Saving Throw: Fortitude half
Spell Resistance: Yes

With this spell, the caster's touch deals grievous 
wounds to multiple targets. After rapture of rupture
is cast, the caster can touch one target per round 
until she has touched a number of targets equal to 
her caster level. The same creature cannot be 
affected twice by the same rapture of rupture. A 
creature with no discernible anatomy is unaffected by
this spell.

When the caster touches a subject, his flesh bursts 
open suddenly in multiple places. Each subject takes 
6d6 points of damage and is stunned for 1 round; a 
successful Fortitude save reduces damage by half and
negates the stun effect. Subjects who fail their 
Fortitude save continue to take 1d6 points of damage
per round until they receive magical healing, succeed
at a Heal check (DC 20), or die. If a subject takes 6
points of damage from rapture of rupture in a single 
round, he is stunned in the following round.

Corruption Cost: 1 point of Strength damage per target 
touched.

*/
//  Author:   Tenjac
//  Created:  5/31/2006
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
	
/*  
    <EXTRA NOTES>

    <BEGIN NOTES TO SCRIPTER - MAY BE DELETED LATER>
    Modify as necessary
    Most code should be put in DoSpell()

    PRC_SPELL_EVENT_ATTACK is set when a
        touch or ranged attack is used
    <END NOTES TO SCRIPTER>
*/

#include "spinc_common"
#include "prc_sp_func"


//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent, string sScript)
{
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr();
    float fMaxDuration = RoundsToSeconds(nCasterLevel); //modify if necessary
    string sCaster = GetLocalString(oCaster, "PRCRuptureID");
    string sTest = GetLocalString(oTarget, "PRCRuptureTargetID");

    int iAttackRoll = 0;    //placeholder

    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    if (iAttackRoll > 0)
    {
	    if(sCaster != sTest)
	    {
		    //Damage
		    int nDam = d6(6);
		    
		    if(nMetaMagic == METAMAGIC_MAXIMIZE)
		    {
			    nDam = 36;
		    }
		    
		    if(nMetaMagic == METAMAGIC_EMPOWER)
		    {
			    nDam += (nDam/2);
		    }
		    
		    //half damage for save
		    if(MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
		    {
			    nDam = (nDam/2);
		    }
		    
		    //if failed
		    else
		    {
			    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, 6.0f);
			    
			    //Bleeding
			    WoundLoop(oTarget, 0);		
		    }
		    
		    //Apply Damage
		    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, nDam), oTarget;	
		    
		    //Apply String
		    SetLocalString(oTarget, "PRCRuptureTargetID", sCaster);		    
		    
	    }
	    DoCorruptionCost(oPC, ABILITY_STRENGTH, 1, 0);
	    return iAttackRoll;    //return TRUE if spell charges should be decremented
    }
}

void WoundLoop(object oTarget, int nPrevious)
{
	if(nPrevious == 6)
	{
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, 6.0f);
	}
	
	int nDamage = d6();
		
	//Deal damage
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, nDamage), oTarget);
	
	int nPrevious = nDamage ;
	
	DelayCommand(6.0f, WoundLoop(oTarget, nPrevious));
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);

    if(GetRunningEvent() == EVENT_VIRTUAL_ONDAMAGED)
    {
        ConcentrationLossCode(oCaster, GetLocalObject(oCaster, PRC_SPELL_CONC_TARGET), nCasterLevel);
        return;
    }

    SPSetSchool(SPELL_SCHOOL_GENERAL);  //Put Spell School Here

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

    object oTarget = PRCGetSpellTargetObject();
    int nSpellID = GetSpellId();
    string sScript = Get2DACache("spells", "ImpactScript", nSpellID);

    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, PRCGetCasterLevel(oCaster));
            
            //SetLocalString for identification purposes
            string sLocal = GetName(oCaster) + IntToString(GetTimeMillisecond());
            SetLocalString(oCaster, "PRCRuptureID", sLocal);
            
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent, sScript);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent, sScript))
                DecrementSpellCharges(oCaster);
        }
    }
    
    SPEvilShift(oCaster);
    
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Getting rid of the local integer storing the spellschool name
}
