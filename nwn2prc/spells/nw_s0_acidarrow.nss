//::///////////////////////////////////////////////
//:: Melf's Acid Arrow
//:: MelfsAcidArrow.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    An acidic arrow springs from the caster's hands
    and does 3d6 acid damage to the target.  For
    every 3 levels the caster has the target takes an
    additional 1d6 per round.
*/
/////////////////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Aidan Scanlan
//:: Created On: 01/09/01
//:://////////////////////////////////////////////
//:: Rewritten: Georg Zoeller, Oct 29, 2003
//:: Now uses VFX to track its own duration, cutting
//:: down the impact on the CPU to 1/6th
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, and 15, 2003
#include "spinc_common"
#include "prc_inc_sp_tch"
#include "x2_inc_spellhook"
#include "prc_alterations"



void RunImpact(object oTarget, object oCaster, int nMetamagic,int EleDmg);

void main()
{

    SPSetSchool(GetSpellSchool(PRCGetSpellId()));

    object oTarget = PRCGetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nSpellID = PRCGetSpellId();

    //--------------------------------------------------------------------------
    // Spellcast Hook Code
    // Added 2003-06-20 by Georg
    // If you want to make changes to all spells, check x2_inc_spellhook.nss to
    // find out more
    //--------------------------------------------------------------------------
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook


    //--------------------------------------------------------------------------
    // Calculate the duration
    //--------------------------------------------------------------------------
    int nMetaMagic = PRCGetMetaMagicFeat();
    
    int EleDmg = ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_ACID);
    int nDuration = (nCasterLevel/3);

    if (nMetaMagic & METAMAGIC_EXTEND)
    {
       nDuration = nDuration * 2;
    }

    if (nDuration < 1)
    {
        nDuration = 1;
    }


    //--------------------------------------------------------------------------
    // Setup VFX
    //--------------------------------------------------------------------------
    effect eVis      = EffectVisualEffect(VFX_HIT_SPELL_ACID);
    effect eDur      = EffectVisualEffect(VFX_DUR_SPELL_MELFS_ACID_ARROW);
    //effect eArrow = EffectVisualEffect(245);

    //--------------------------------------------------------------------------
    // Set the VFX to be non dispelable, because the acid is not magic
    //--------------------------------------------------------------------------
    eDur = ExtraordinaryEffect(eDur);
     // * Dec 2003- added the reaction check back i
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID));

        float fDist = GetDistanceToObject(oTarget);
        float fDelay = (fDist/25.0);//(3.0 * log(fDist) + 2.0);

        int iAttackRoll = PRCDoRangedTouchAttack(oTarget);
        if(iAttackRoll > 0)
        {
            if(!PRCMyResistSpell(OBJECT_SELF, oTarget, (nCasterLevel + SPGetPenetr())))
            {
                //--------------------------------------------------------------------------
                // This spell no longer stacks. If there is one of that type, thats ok
                //--------------------------------------------------------------------------
                // NWN2 change
                if (GetHasSpellEffect(nSpellID,oTarget))
                {
                    RemoveSpellEffects(nSpellID, oCaster, oTarget);
                }
                
                //----------------------------------------------------------------------
                // Do the initial 3d6 points of damage
                //----------------------------------------------------------------------
                int nDamage = PRCMaximizeOrEmpower(4,2,nMetaMagic);
                ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDamage, EleDmg);

                DelayCommand(fDelay,SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));

                //----------------------------------------------------------------------
                // Apply the VFX that is used to track the spells duration
                //----------------------------------------------------------------------
                DelayCommand(fDelay,SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oTarget,RoundsToSeconds(nDuration),FALSE));
                object oSelf = OBJECT_SELF; // because OBJECT_SELF is a function
                DelayCommand(6.0f,RunImpact(oTarget, oSelf,nMetaMagic,EleDmg));
            }
            else
            {
                //----------------------------------------------------------------------
                // Indicate Failure
                //----------------------------------------------------------------------
                effect eSmoke = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
                DelayCommand(fDelay+0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eSmoke,oTarget));
            }
         }
    }
    // SPApplyEffectToObject(DURATION_TYPE_INSTANT, eArrow, oTarget);

    SPSetSchool();

}


void RunImpact(object oTarget, object oCaster, int nMetaMagic,int EleDmg)
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(SPELL_MELFS_ACID_ARROW,oTarget,oCaster))
    {
        return;
    }

    if (GetIsDead(oTarget) == FALSE)
    {
        //----------------------------------------------------------------------
        // Calculate Damage
        //----------------------------------------------------------------------
        int nCasterLevel = PRCGetCasterLevel(oCaster);
        int nSpellID = PRCGetSpellId();
        int nDamage = PRCMaximizeOrEmpower(4,2,nMetaMagic);
        effect eDam = EffectDamage(nDamage, EleDmg);
        effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ACID);
        eDam = EffectLinkEffects(eVis,eDam); // flare up
        SPApplyEffectToObject (DURATION_TYPE_INSTANT,eDam,oTarget, 0.0f, TRUE, nSpellID, nCasterLevel);
        DelayCommand(6.0f,RunImpact(oTarget,oCaster,nMetaMagic,EleDmg));
    }
}

