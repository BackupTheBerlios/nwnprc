//::///////////////////////////////////////////////
//:: Arcane Eye
//:: sp_arcaneeye.nss
//:://////////////////////////////////////////////
/*
    You create an invisible magical sensor that sends you visual information. 
    You can create the arcane eye at any point you can see, but it can then travel 
    outside your line of sight without hindrance. An arcane eye travels at 30 feet per round 
    (300 feet per minute) if viewing an area ahead as a human would (primarily looking at the 
    floor) or 10 feet per round (100 feet per minute) if examining the ceiling and walls as well 
    as the floor ahead. It sees exactly as you would see if you were there.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: May 6, 2007
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_alterations"
#include "x2_inc_spellhook"
#include "prc_inc_scry"

void ApplyScryEffects(object oPC)
{
    if(DEBUG) DoDebug("prc_inc_scry: ApplyScryEffects():\n"
                    + "oPC = '" + GetName(oPC) + "'"
                      );
    // The Scryer is not supposed to be visible, nor can he move or cast
    // He also can't take damage from scrying
        effect eLink    = EffectSpellImmunity(SPELL_ALL_SPELLS);
        // Damage immunities
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID,        100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD,        100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE,      100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL,  100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE,        100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL,     100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC,       100));
        // Specific immunities
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEATH));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DISEASE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLOW));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SILENCE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_TRAP));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
       // Random stuff
       	       eLink      = EffectLinkEffects(eLink, EffectCutsceneGhost());
       	       //eLink      = EffectLinkEffects(eLink, EffectCutsceneImmobilize());
        effect eEth       = EffectLinkEffects(eLink, EffectEthereal());
       	       eLink      = EffectLinkEffects(eLink, EffectAttackDecrease(50));
       	       eLink      = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
       	       // Permanent until Scry ends
       	       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oPC, GetLocalFloat(oPC, "ScryDuration") + 6.0);
       	       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oPC, GetLocalFloat(oPC, "ScryDuration") + 6.0);

    // Create array for storing a list of the nerfed weapons in
    array_create(oPC, "Scry_Nerfed");

    object oWeapon;
    itemproperty ipNoDam = ItemPropertyNoDamage();
    oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if(IPGetIsMeleeWeapon(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
        }
        // Check left hand only if right hand had a weapon
        oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        if(IPGetIsMeleeWeapon(oWeapon)){
            if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
                //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
                AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
                array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
        }}
    }else if(IPGetIsRangedWeapon(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
    }}

    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
    }}
    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
    }}
    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
    }}
}

void main()
{
        object oPC = OBJECT_SELF;
        
DeleteLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_DIVINATION);

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

        //Declare major variables
        object oTarget;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nSpell = PRCGetSpellId();
        int nDC = PRCGetSaveDC(oTarget, oPC);
        float fDur = 60.0 * nCasterLvl;
        int nMetaMagic = PRCGetMetaMagicFeat();
    	//Make Metamagic check for extend
    	if ((nMetaMagic & METAMAGIC_EXTEND))
    	{
        	fDur = fDur * 2;
    	}                
        
        SetLocalInt(oPC, "ScryCasterLevel", nCasterLvl);
        SetLocalInt(oPC, "ScrySpellId", nSpell);
        SetLocalInt(oPC, "ScrySpellDC", nDC);
        SetLocalFloat(oPC, "ScryDuration", fDur);       
        
        // StartDynamicConversation("prc_scry_conv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);
        
        // Apply the immunity effects
        ApplyScryEffects(oPC);
        // Now do the rest of the spell.
        ScryMain(oPC, oPC);        

DeleteLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
