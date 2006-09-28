//::///////////////////////////////////////////////
//:: Name      Dispelling Touch
//:: FileName  sp_dispell_tch.nss
//:://////////////////////////////////////////////
/**@file Dispelling Touch
Abjuration
Level: Duskblade 3, sorcerer/wizard 2
Components: V,S
Casting Time: 1 standard action
Range: Touch
Target: One touched creature, object, or spell
        effect
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

You can use dispelling touch to end an ongoing
spell that has been cast on a creature or object,
or a spell tha has a noticeable ongoing effect. You
mkae a dispel check (1d20 + your caster level, max
+10) against the spell effect with the highest
caster level. If that check fails, you make dispel
checks against progressively weaker spells until
you dispel one spell or you fail all your checks.
Magic items carried by a creature are not affected.
**/

/*
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
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nMetaMagic = PRCGetMetaMagicFeat();
    
    //INSERT SPELL CODE HERE
    int iAttackRoll = 0;    //placeholder

    iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    if (iAttackRoll > 0)
    {
	    AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_DISPEL_MAGIC, oTarget, nMetaMagic, TRUE, nCasterLevel, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
    }

    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    SPSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    SPSetSchool();
}
