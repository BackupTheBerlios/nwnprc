/////////////////////////////////////////////////////////
/*
Chosen of Evil [Vile]
Your naked devotion to wickedness causes dark powers to
take an interest in your well-being.
Prerequisites: Con 13, any other vile feat.
Benefit: As an immediate action, you can take 1 point
of Constitution damage to gain an insight bonus equal
to the number of vile feats you have, including this one.
Until the end of your next turn, you can apply this bonus
to attack rolls, saving throws, or skill checks.*/
/////////////////////////////////////////////////////////
#include "prc_inc_spells"

int GetVileFeats(object oPC);

void main()
{
        object oPC = OBJECT_SELF;
        if(GetIsImmune(oPC, IMMUNITY_TYPE_ABILITY_DECREASE))
        {
                FloatingTextStringOnCreature("If you cannot take ability damage you cannot use this feat", oPC, FALSE);
                return;
        }
        ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, 1, -1.0);        
        int nBonus = GetVileFeats(oPC);
        int nSpell = GetSpellId();
        
        //VFX
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_EVIL_HELP), oPC);
        
        //Different effects
        if(nSpell == SPELL_CHOSEN_EVIL_ATTACK) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(nBonus), oPC, TurnsToSeconds(1));        
        else if(nSpell == SPELL_CHOSEN_EVIL_SAVE) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_ALL), oPC, TurnsToSeconds(1));        
        else if(nSpell == SPELL_CHOSEN_EVIL_SKILL) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus), oPC, TurnsToSeconds(1));
        
        //epic fail
        else if(DEBUG) DoDebug("Invalid SpellID: " + IntToString(nSpell));        
}

int GetVileFeats(object oPC)
{
        int nCount;
        
        if(GetHasFeat(FEAT_DARK_SPEECH, oTarget)) nCount++;
        if(GetHasFeat(FEAT_DEFORM_EYES, oTarget)) nCount++;
        if(GetHasFeat(FEAT_DEFORM_FACE, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_DEFORM_GAUNT, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_DEFORM_OBESE, oTarget)) nCount++;        
        if(GetHasFeat(FEAT_EB_HAND, oTarget)) nCount++;
        if(GetHasFeat(FEAT_EB_HEAD, oTarget)) nCount++;
        if(GetHasFeat(FEAT_EB_CHEST, oTarget)) nCount++;
        if(GetHasFeat(FEAT_EB_ARM, oTarget)) nCount++;
        if(GetHasFeat(FEAT_EB_NECK, oTarget)) nCount++;
        if(GetHasFeat(FEAT_LICHLOVED, oTarget)) nCount++;
        if(GetHasFeat(FEAT_THRALL_TO_DEMON, oTarget)) nCount++;
        if(GetHasFeat(FEAT_DISCIPLE_OF_DARKNESS, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_WILL_DEFORM, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_CLUB, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_DAGGER, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_MACE, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_MORNINGSTAR, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_QUATERSTAFF, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_SPEAR, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_SHORTSWORD, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_RAPIER, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_SCIMITAR, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_LONGSWORD, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_GREATSWORD, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_HANDAXE, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_BATTLEAXE, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_GREATAXE, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_HALBERD, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_LIGHTHAMMER, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_LIGHTFLAIL, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_WARHAMMER, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_HEAVYFLAIL, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_SCYTHE, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_KATANA, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_BASTARDSWORD, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_DIREMACE, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_DOUBLEAXE, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_TWOBLADED, oTarget)) nCount++;        
        if(GetHasFeat(FEAT_VILE_MARTIAL_KAMA, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_KUKRI, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_HEAVYCROSSBOW, oTarget)) nCount++;        
        if(GetHasFeat(FEAT_VILE_MARTIAL_LIGHTCROSSBOW, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_SLING, oTarget)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_LONGBOW, oTarget)) nCount++;      
        if(GetHasFeat(FEAT_VILE_MARTIAL_SHORTBOW, oTarget)) nCount++;     
        if(GetHasFeat(FEAT_VILE_MARTIAL_SHURIKEN, oTarget)) nCount++;     
        if(GetHasFeat(FEAT_VILE_MARTIAL_DART, oTarget)) nCount++;         
        if(GetHasFeat(FEAT_VILE_MARTIAL_SICKLE, oTarget)) nCount++;       
        if(GetHasFeat(FEAT_VILE_MARTIAL_DWAXE, oTarget)) nCount++;        
        if(GetHasFeat(FEAT_VILE_MARTIAL_MINDBLADE, oTarget)) nCount++;
        if(GetHasFeat(FEAT_APOSTATE, oTarget)) nCount++; 
        if(GetHasFeat(FEAT_DARK_WHISPERS, oTarget)) nCount++;
        if(GetHasFeat(FEAT_MASTERS_WILL, oTarget)) nCount++;
        if(GetHasFeat(FEAT_DEFORM_MADNESS, oTarget)) nCount++;
        if(GetHasFeat(FEAT_REFLEXIVE_PSYCHOSIS, oTarget)) nCount++;
        if(GetHasFeat(FEAT_CHOSEN_OF_EVIL, oTarget)) nCount++;
        //if(GetHasFeat(, oTarget)) nCount++;
        
        return nCount;
}