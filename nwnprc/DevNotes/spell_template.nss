/*
    <SCRIPT NAME>

    <DESCRIPTION>

    By:
    Created:
    Modified:

    <EXTRA NOTES>

    <BEGIN NOTES TO SCRIPTER - MAY BE DELETED LATER>
    Modify as necessary
    Most code should be put in DoSpell()

    PRC_SPELL_EVENT_ATTACK is set when a
        touch or ranged attack is used
    <END NOTES TO SCRIPTER>
*/

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

    //INSERT SPELL CODE HERE
    int iAttackRoll = 0;    //placeholder

    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    if (iAttackRoll > 0)
    {
        //Touch attack code goes here
    }

    return iAttackRoll;    //return TRUE if spell charges should be decremented
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
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
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

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Getting rid of the local integer storing the spellschool name
}
