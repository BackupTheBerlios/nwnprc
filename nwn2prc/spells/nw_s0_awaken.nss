/**@file Awaken
Transmutation
Level: 	Drd 5
Components: 	   V, S, DF, XP
Casting Time:      24 hours *changed to instant*
Range: 	           Touch
Target:            Animal or tree touched *animal companion only*
Duration: 	       Instantaneous
Saving Throw:  	   Will negates *removed*
Spell Resistance:  Yes

changed from the SRD to:

An awakened animal gets 3d6 Intelligence, +1d3 Charisma, and +2 HD.
The 2HD are added by granting +2 to attack and 2d8 HP.

XP Cost:  250 XP. *removed*
*/

/*
    nw_s0_awaken

    This spell makes an animal ally more
    powerful, intelligent and robust for the
    duration of the spell.  Requires the caster to
    make a Will save to succeed.

    By: Preston Watamaniuk
    Created: Aug 10, 2001
    Modified: Jun 12, 2006
*/

#include "prc_sp_func"


void main()
{

    SPSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nSpellID = PRCGetSpellId();
    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nInt = PRCMaximizeOrEmpower(6,3, nMetaMagic);
    int nCha = PRCMaximizeOrEmpower(3,1, nMetaMagic);
    effect eHP = EffectTemporaryHitpoints(d8(2)); // instead of 2HD
    effect eAttack = EffectAttackIncrease(2); // instead of 2 HD
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_AWAKEN);

    
    if(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION) == oTarget)
    {
        if(!GetHasSpellEffect(SPELL_AWAKEN))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));
            
            effect eInt = EffectAbilityIncrease(ABILITY_INTELLIGENCE, nInt);
            effect eCha = EffectAbilityIncrease(ABILITY_CHARISMA, nCha);
            effect eLink = EffectLinkEffects(eInt, eCha);
            eLink = EffectLinkEffects(eLink, eAttack);
            eLink = EffectLinkEffects(eLink, eHP);
            eLink = EffectLinkEffects(eLink, eVis);
            eLink = SupernaturalEffect(eLink);
            //Apply the VFX impact and effects
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget,0.0f,TRUE,nSpellID, nCasterLevel);
        }
    }
    
    SPSetSchool();
}