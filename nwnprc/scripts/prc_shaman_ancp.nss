#include "prc_alterations"
#include "x0_i0_assoc"

const int DISEASE_TALONAS_BLIGHT = 52;

void main()
{
   int nHD = GetHitDice(OBJECT_SELF);
   int nLevel = nHD / 2;

   object oCreature = CreateObject(OBJECT_TYPE_CREATURE, "prc_shamn_cat", GetSpellTargetLocation(), FALSE, "prc_shamn_cat");
   AddHenchman(OBJECT_SELF, oCreature);
   effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oCreature));

   int n;
   for(n=1;n<nLevel;n++)
   {
      LevelUpHenchman(oCreature, CLASS_TYPE_INVALID, TRUE);
   }
    //Exalted Companion
    string oCat = "prc_shamn_cat";
    if (GetHasFeat(FEAT_EXALTED_COMPANION) && GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
    {
        object oComp = GetObjectByTag(oCat);
        //Get the companion's skin
        object oCompSkin = GetPCSkin(oComp);
        if (GetMaster(oComp) == OBJECT_SELF)
        {
        int nHD = GetHitDice(oComp);
        int nResist;
        effect eDR;
        if (nHD >= 12)
        {
            eDR = EffectDamageReduction(10, DAMAGE_POWER_PLUS_THREE);
            nResist = 20;
        }
        else if (12 > nHD && nHD >= 8)
        {
            eDR = EffectDamageReduction(5, DAMAGE_POWER_PLUS_TWO);
            nResist = 20;
        }
        else if (8 > nHD && nHD >= 4)
        {
            eDR = EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE);
            nResist = 20;
        }
        else if (4 > nHD)
        {
            nResist = 5;
        }

        effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, nResist);
        effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, nResist);
        effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResist);
        effect eVis = EffectUltravision();
        effect eLink = EffectLinkEffects(eDR, eAcid);
        eLink = EffectLinkEffects(eLink, eCold);
        eLink = EffectLinkEffects(eLink, eElec);
        eLink = EffectLinkEffects(eLink, eVis);
        eLink = SupernaturalEffect(eLink);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oComp);
        itemproperty ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_CELESTIAL_SMITE_EVIL);
        IPSafeAddItemProperty(oCompSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }

    //Talontar Blightlord's Illmaster
    if (GetLevelByClass(CLASS_TYPE_BLIGHTLORD, OBJECT_SELF) >= 2)
    {
        //Get the companion
        object oComp = GetObjectByTag(oCat);
        //Get the companion's skin
        object oCompSkin = GetPCSkin(oComp);
        if (GetMaster(oComp) == OBJECT_SELF)
        {
        //Give the companion Str +4, Con +2, Wis -2, and Cha -2
        effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
        effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 2);
        effect eWis = EffectAbilityDecrease(ABILITY_WISDOM, 2);
        effect eCha = EffectAbilityDecrease(ABILITY_CHARISMA, 2);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStr, oCompSkin);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCon, oCompSkin);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eWis, oCompSkin);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCha, oCompSkin);
        //Get the companion's Hit Dice
        int iHD = GetHitDice(oComp);
        //Get the companion's constitution modifier
        int iCons = GetAbilityModifier(ABILITY_CONSTITUTION, oComp);
        //Compute the DC for this companion's blight touch
        int iDC = 10 + (iHD / 2) + iCons;
        //Create the onhit item property for causing the blight touch disease
        itemproperty ipBlightTouch = ItemPropertyOnHitProps(IP_CONST_ONHIT_DISEASE, iDC, DISEASE_TALONAS_BLIGHT);
        //Get the companion's creature weapons
        object oBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oComp);
        object oLClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oComp);
        object oRClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oComp);
        //Apply blight touch to each weapon
        if (GetIsObjectValid(oBite))
        {
            IPSafeAddItemProperty(oBite, ipBlightTouch);
        }
        if (GetIsObjectValid(oLClaw))
        {
            IPSafeAddItemProperty(oLClaw, ipBlightTouch);
        }
        if (GetIsObjectValid(oRClaw))
        {
            IPSafeAddItemProperty(oRClaw, ipBlightTouch);
        }
        //Get the companion's alignment
        int iCompLCA = GetAlignmentLawChaos(oComp);
        int iCompGEA = GetAlignmentGoodEvil(oComp);
        //Set PLANT immunities and add low light vision
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CHARM_PERSON), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_DOMINATE_PERSON), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_HOLD_PERSON), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_MASS_CHARM), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB), oCompSkin);
        //Feat 354 is FEAT_LOWLIGHTVISION
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(354), oCompSkin);
        if (iCompLCA != ALIGNMENT_NEUTRAL)
        {
            AdjustAlignment(oComp, ALIGNMENT_NEUTRAL, 50);
        }
        if (iCompGEA != ALIGNMENT_EVIL)
        {
            AdjustAlignment(oComp, ALIGNMENT_EVIL, 80);
        }
        }
    }
}