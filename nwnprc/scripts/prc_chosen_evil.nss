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
        ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);        
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
        
        if(GetHasFeat(FEAT_DARK_SPEECH, oPC)) nCount++;
        if(GetHasFeat(FEAT_DEFORM_EYES, oPC)) nCount++;
        if(GetHasFeat(FEAT_DEFORM_FACE, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_DEFORM_GAUNT, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_DEFORM_OBESE, oPC)) nCount++;        
        if(GetHasFeat(FEAT_EB_HAND, oPC)) nCount++;
        if(GetHasFeat(FEAT_EB_HEAD, oPC)) nCount++;
        if(GetHasFeat(FEAT_EB_CHEST, oPC)) nCount++;
        if(GetHasFeat(FEAT_EB_ARM, oPC)) nCount++;
        if(GetHasFeat(FEAT_EB_NECK, oPC)) nCount++;
        if(GetHasFeat(FEAT_LICHLOVED, oPC)) nCount++;
        if(GetHasFeat(FEAT_THRALL_TO_DEMON, oPC)) nCount++;
        if(GetHasFeat(FEAT_DISCIPLE_OF_DARKNESS, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_WILL_DEFORM, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_CLUB, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_DAGGER, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_MACE, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_MORNINGSTAR, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_QUATERSTAFF, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_SPEAR, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_SHORTSWORD, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_RAPIER, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_SCIMITAR, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_LONGSWORD, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_GREATSWORD, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_HANDAXE, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_BATTLEAXE, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_GREATAXE, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_HALBERD, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_LIGHTHAMMER, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_LIGHTFLAIL, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_WARHAMMER, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_HEAVYFLAIL, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_SCYTHE, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_KATANA, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_BASTARDSWORD, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_DIREMACE, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_DOUBLEAXE, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_TWOBLADED, oPC)) nCount++;        
        if(GetHasFeat(FEAT_VILE_MARTIAL_KAMA, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_KUKRI, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_HEAVYCROSSBOW, oPC)) nCount++;        
        if(GetHasFeat(FEAT_VILE_MARTIAL_LIGHTCROSSBOW, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_SLING, oPC)) nCount++;
        if(GetHasFeat(FEAT_VILE_MARTIAL_LONGBOW, oPC)) nCount++;      
        if(GetHasFeat(FEAT_VILE_MARTIAL_SHORTBOW, oPC)) nCount++;     
        if(GetHasFeat(FEAT_VILE_MARTIAL_SHURIKEN, oPC)) nCount++;     
        if(GetHasFeat(FEAT_VILE_MARTIAL_DART, oPC)) nCount++;         
        if(GetHasFeat(FEAT_VILE_MARTIAL_SICKLE, oPC)) nCount++;       
        if(GetHasFeat(FEAT_VILE_MARTIAL_DWAXE, oPC)) nCount++;        
        if(GetHasFeat(FEAT_VILE_MARTIAL_MINDBLADE, oPC)) nCount++;
        if(GetHasFeat(FEAT_APOSTATE, oPC)) nCount++; 
        if(GetHasFeat(FEAT_DARK_WHISPERS, oPC)) nCount++;
        if(GetHasFeat(FEAT_MASTERS_WILL, oPC)) nCount++;
        if(GetHasFeat(FEAT_DEFORM_MADNESS, oPC)) nCount++;
        if(GetHasFeat(FEAT_REFLEXIVE_PSYCHOSIS, oPC)) nCount++;
        if(GetHasFeat(FEAT_CHOSEN_OF_EVIL, oPC)) nCount++;
        //if(GetHasFeat(, oPC)) nCount++;
        
        return nCount;
}