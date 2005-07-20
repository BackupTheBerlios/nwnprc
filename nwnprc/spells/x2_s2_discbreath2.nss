/*
This is the edited script I had made changes to before Silver reverted to 
the original. It has:

Round delays for metabreath/multiple uses
Line breath (working)
Pyroclastic being 50% of each
PRCGetReflexAdjustedDamage to interact better with other systems
Range dependant on size
Less code duplication by using dedicated functions. Easier to fix/find bugs.
Moved breath VFX so when different ones for different colors are done they can be easily implemented


Moved to a new script so its not lost permanently. Feel free to refer to this if you want.

Primogenitor



//::///////////////////////////////////////////////
//:: Breath Weapon for Dragon Disciple Class
//:: x2_s2_discbreath
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller (modified by Silver)
//:: Created On: June, 17, 2003 (June, 7, 2005)
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "NW_I0_SPELLS"
#include "inc_item_props" 

int IsLineBreath()
{
    if(GetHasFeat(FEAT_BLACK_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_BLUE_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_BRASS_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_BRONZE_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_COPPER_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_AMETHYST_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_BROWN_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_CHAOS_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_OCEANUS_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_RADIANT_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_RUST_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_STYX_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_TARTIAN_DRAGON, OBJECT_SELF)
        )
        return TRUE;
    return FALSE;       
}

float GetRangeFromSize(int nSize)
{
    float fRange = 10.0;
    switch(nSize)
    {
        case CREATURE_SIZE_FINE:        fRange = FeetToMeters(30.0); break;
        case CREATURE_SIZE_DIMINUTIVE:  fRange = FeetToMeters(30.0); break;
        case CREATURE_SIZE_TINY:        fRange = FeetToMeters(30.0); break;
        case CREATURE_SIZE_SMALL:       fRange = FeetToMeters(30.0); break;
        case CREATURE_SIZE_MEDIUM:      fRange = FeetToMeters(30.0); break;
        //PnP says 30, but I think this doesnt fit the progression so Ive made it 40
        //Primogenitor
        case CREATURE_SIZE_LARGE:       fRange = FeetToMeters(40.0); break; 
        case CREATURE_SIZE_HUGE:        fRange = FeetToMeters(50.0); break;
        case CREATURE_SIZE_GARGANTUAN:  fRange = FeetToMeters(60.0); break;
        case CREATURE_SIZE_COLOSSAL:    fRange = FeetToMeters(70.0); break;
    }
    return fRange;
}

//This is the main breath attack script.  33 out of 38 Dragon Disciple
//types use this script for breath attacks.  All basic breath attacks
//which deal 1 type of damage with a reflex saving throw.
void BreathAttack(object oPC ,object oSkin ,int DBREED ,int nSaveDC ,int nLevel ,int nDamage) 
{  
    //Sets what type of saving throw is to be made by those caught in the dragon disciples
    //breath weapon.
    int SAVETH = GetHasFeat(FEAT_RED_DRAGON, OBJECT_SELF)       ? SAVING_THROW_TYPE_FIRE : 
                 GetHasFeat(FEAT_BRASS_DRAGON, OBJECT_SELF)     ? SAVING_THROW_TYPE_FIRE : 
                 GetHasFeat(FEAT_GOLD_DRAGON, OBJECT_SELF)      ? SAVING_THROW_TYPE_FIRE : 
                 GetHasFeat(FEAT_LUNG_WANG_DRAGON, OBJECT_SELF) ? SAVING_THROW_TYPE_FIRE : 
                 GetHasFeat(FEAT_TIEN_LUNG_DRAGON, OBJECT_SELF) ? SAVING_THROW_TYPE_FIRE : 
                 GetHasFeat(FEAT_BLACK_DRAGON, OBJECT_SELF)     ? SAVING_THROW_TYPE_ACID : 
                 GetHasFeat(FEAT_GREEN_DRAGON, OBJECT_SELF)     ? SAVING_THROW_TYPE_ACID : 
                 GetHasFeat(FEAT_COPPER_DRAGON, OBJECT_SELF)    ? SAVING_THROW_TYPE_ACID : 
                 GetHasFeat(FEAT_BROWN_DRAGON, OBJECT_SELF)     ? SAVING_THROW_TYPE_ACID : 
                 GetHasFeat(FEAT_DEEP_DRAGON, OBJECT_SELF)      ? SAVING_THROW_TYPE_ACID : 
                 GetHasFeat(FEAT_RUST_DRAGON, OBJECT_SELF)      ? SAVING_THROW_TYPE_ACID : 
                 GetHasFeat(FEAT_STYX_DRAGON, OBJECT_SELF)      ? SAVING_THROW_TYPE_ACID : 
                 GetHasFeat(FEAT_SILVER_DRAGON, OBJECT_SELF)    ? SAVING_THROW_TYPE_COLD : 
                 GetHasFeat(FEAT_WHITE_DRAGON, OBJECT_SELF)     ? SAVING_THROW_TYPE_COLD : 
                 GetHasFeat(FEAT_BLUE_DRAGON, OBJECT_SELF)      ? SAVING_THROW_TYPE_ELECTRICITY : 
                 GetHasFeat(FEAT_BRONZE_DRAGON, OBJECT_SELF)    ? SAVING_THROW_TYPE_ELECTRICITY : 
                 GetHasFeat(FEAT_OCEANUS_DRAGON, OBJECT_SELF)   ? SAVING_THROW_TYPE_ELECTRICITY : 
                 GetHasFeat(FEAT_SONG_DRAGON, OBJECT_SELF)      ? SAVING_THROW_TYPE_ELECTRICITY : 
                 GetHasFeat(FEAT_EMERALD_DRAGON, OBJECT_SELF)   ? SAVING_THROW_TYPE_SONIC : 
                 GetHasFeat(FEAT_SAPPHIRE_DRAGON, OBJECT_SELF)  ? SAVING_THROW_TYPE_SONIC : 
                 GetHasFeat(FEAT_BATTLE_DRAGON, OBJECT_SELF)    ? SAVING_THROW_TYPE_SONIC : 
                 GetHasFeat(FEAT_HOWLING_DRAGON, OBJECT_SELF)   ? SAVING_THROW_TYPE_SONIC : 
                 GetHasFeat(FEAT_CRYSTAL_DRAGON, OBJECT_SELF)   ? SAVING_THROW_TYPE_POSITIVE : 
                 GetHasFeat(FEAT_AMETHYST_DRAGON, OBJECT_SELF)  ? SAVING_THROW_TYPE_NONE : 
                 GetHasFeat(FEAT_TOPAZ_DRAGON, OBJECT_SELF)     ? SAVING_THROW_TYPE_NONE : 
                 GetHasFeat(FEAT_ETHEREAL_DRAGON, OBJECT_SELF)  ? SAVING_THROW_TYPE_NONE : 
                 GetHasFeat(FEAT_RADIANT_DRAGON, OBJECT_SELF)   ? SAVING_THROW_TYPE_NONE : 
                 GetHasFeat(FEAT_TARTIAN_DRAGON, OBJECT_SELF)   ? SAVING_THROW_TYPE_NONE : 
                -1; // If none match, make the itemproperty invalid 
                
    //Sets visual effect for object struck, varying based on the element or nature of the
    //Dragon Disciples type.
    int VISUAL = GetHasFeat(FEAT_RED_DRAGON, OBJECT_SELF)       ? VFX_IMP_FLAME_M : 
                 GetHasFeat(FEAT_BRASS_DRAGON, OBJECT_SELF)     ? VFX_IMP_FLAME_M : 
                 GetHasFeat(FEAT_GOLD_DRAGON, OBJECT_SELF)      ? VFX_IMP_FLAME_M : 
                 GetHasFeat(FEAT_LUNG_WANG_DRAGON, OBJECT_SELF) ? VFX_IMP_FLAME_M : 
                 GetHasFeat(FEAT_TIEN_LUNG_DRAGON, OBJECT_SELF) ? VFX_IMP_FLAME_M : 
                 GetHasFeat(FEAT_BLACK_DRAGON, OBJECT_SELF)     ? VFX_IMP_ACID_S : 
                 GetHasFeat(FEAT_GREEN_DRAGON, OBJECT_SELF)     ? VFX_IMP_ACID_S : 
                 GetHasFeat(FEAT_COPPER_DRAGON, OBJECT_SELF)    ? VFX_IMP_ACID_S : 
                 GetHasFeat(FEAT_BROWN_DRAGON, OBJECT_SELF)     ? VFX_IMP_ACID_S : 
                 GetHasFeat(FEAT_DEEP_DRAGON, OBJECT_SELF)      ? VFX_IMP_ACID_S : 
                 GetHasFeat(FEAT_RUST_DRAGON, OBJECT_SELF)      ? VFX_IMP_ACID_S : 
                 GetHasFeat(FEAT_STYX_DRAGON, OBJECT_SELF)      ? VFX_IMP_ACID_S : 
                 GetHasFeat(FEAT_SILVER_DRAGON, OBJECT_SELF)    ? VFX_IMP_FROST_S : 
                 GetHasFeat(FEAT_WHITE_DRAGON, OBJECT_SELF)     ? VFX_IMP_FROST_S : 
                 GetHasFeat(FEAT_BLUE_DRAGON, OBJECT_SELF)      ? VFX_IMP_LIGHTNING_S : 
                 GetHasFeat(FEAT_BRONZE_DRAGON, OBJECT_SELF)    ? VFX_IMP_LIGHTNING_S : 
                 GetHasFeat(FEAT_OCEANUS_DRAGON, OBJECT_SELF)   ? VFX_IMP_LIGHTNING_S : 
                 GetHasFeat(FEAT_SONG_DRAGON, OBJECT_SELF)      ? VFX_IMP_LIGHTNING_S : 
                 GetHasFeat(FEAT_EMERALD_DRAGON, OBJECT_SELF)   ? VFX_IMP_SILENCE : 
                 GetHasFeat(FEAT_SAPPHIRE_DRAGON, OBJECT_SELF)  ? VFX_IMP_SILENCE : 
                 GetHasFeat(FEAT_BATTLE_DRAGON, OBJECT_SELF)    ? VFX_IMP_SILENCE : 
                 GetHasFeat(FEAT_HOWLING_DRAGON, OBJECT_SELF)   ? VFX_IMP_SILENCE : 
                 GetHasFeat(FEAT_CRYSTAL_DRAGON, OBJECT_SELF)   ? VFX_IMP_HOLY_AID : 
                 GetHasFeat(FEAT_AMETHYST_DRAGON, OBJECT_SELF)  ? VFX_IMP_KNOCK : 
                 GetHasFeat(FEAT_TOPAZ_DRAGON, OBJECT_SELF)     ? VFX_IMP_POISON_L : 
                 GetHasFeat(FEAT_ETHEREAL_DRAGON, OBJECT_SELF)  ? VFX_IMP_KNOCK : 
                 GetHasFeat(FEAT_RADIANT_DRAGON, OBJECT_SELF)   ? VFX_IMP_KNOCK : 
                 GetHasFeat(FEAT_TARTIAN_DRAGON, OBJECT_SELF)   ? VFX_IMP_KNOCK : 
                -1; // If none match, make the itemproperty invalid 
    

    
    //Declare major variables
    float fDelay;
    object oTarget;
    effect eVis, eBreath;

    int nPersonalDamage;

    float fRange = 10.0;//meters not feet!
    int nSize = PRCGetCreatureSize(OBJECT_SELF);
    fRange = GetRangeFromSize(nSize);
    
    int nBreathShape = SHAPE_SPELLCONE;
    
    //these are lines not cones
    if(IsLineBreath())
    {
        nBreathShape = SHAPE_SPELLCYLINDER;
        fRange *= 2.0; //double the range
    }

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(nBreathShape, fRange, GetSpellTargetLocation(), TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));

    while(GetIsObjectValid(oTarget))
    {
        nPersonalDamage = nDamage;
        if(oTarget != OBJECT_SELF && !GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            //Determine effect delay
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            nPersonalDamage = PRCGetReflexAdjustedDamage(nPersonalDamage, oTarget, nSaveDC, SAVETH);
            
            if (nPersonalDamage > 0)
            {
                //Set Damage and VFX
                eBreath = EffectDamage(nPersonalDamage, DBREED);
                eVis = EffectVisualEffect(VISUAL);
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(nBreathShape, fRange, GetSpellTargetLocation(), TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
    }
}





//This is the main breath attack script for the Chaos Dragon Disciple.
//It is almost exactly the same script as the main dragon disciples, 
//but the element caused by the breath attack is unpredictable to the
//player.  Each time they breath, a new element might results.
void RandomBreath(object oPC ,object oSkin ,int dChaos ,int nSaveDC ,int nLevel ,int nDamage)
{  
    int eleBreath;
    int chSaveth;
    int chVisual;
    int eleRoll;
    
    int nNumDice = d10();
    //Sets the random Element factor of the Chaos Dragons Breath Weapon.
    //Affects damage, saving throw, and impact visual.
    if (nNumDice==1)
    {
        eleBreath = DAMAGE_TYPE_COLD;
        chSaveth = SAVING_THROW_TYPE_COLD;
        chVisual = VFX_IMP_FROST_S;
    }
    else if (nNumDice==2)
    {
        eleBreath = DAMAGE_TYPE_COLD;
        chSaveth = SAVING_THROW_TYPE_COLD;
        chVisual = VFX_IMP_FROST_S;
    }
    else if (nNumDice==3)
    {
        eleBreath = DAMAGE_TYPE_ACID;
        chSaveth = SAVING_THROW_TYPE_ACID;
        chVisual = VFX_IMP_ACID_S;
    }
    else if (nNumDice==4)
    {
        eleBreath = DAMAGE_TYPE_ACID;
        chSaveth = SAVING_THROW_TYPE_ACID;
        chVisual = VFX_IMP_ACID_S;
    }
    else if (nNumDice==5)
    {
        eleBreath = DAMAGE_TYPE_FIRE;
        chSaveth = SAVING_THROW_TYPE_FIRE;
        chVisual = VFX_IMP_FLAME_M;
    }
    else if (nNumDice==6)
    {
        eleBreath = DAMAGE_TYPE_FIRE;
        chSaveth = SAVING_THROW_TYPE_FIRE;
        chVisual = VFX_IMP_FLAME_M;
    }
    else if (nNumDice==7)
    {
        eleBreath = DAMAGE_TYPE_SONIC;
        chSaveth = SAVING_THROW_TYPE_SONIC;
        chVisual = VFX_IMP_SILENCE;
    }
    else if (nNumDice==8)
    {
        eleBreath = DAMAGE_TYPE_SONIC;
        chSaveth = SAVING_THROW_TYPE_SONIC;
        chVisual = VFX_IMP_SILENCE;
    }
    else if (nNumDice==9)
    {
        eleBreath = DAMAGE_TYPE_ELECTRICAL;
        chSaveth = SAVING_THROW_TYPE_ELECTRICITY;
        chVisual = VFX_IMP_LIGHTNING_S;
    }
    else if (nNumDice==10)
    {
        eleBreath = DAMAGE_TYPE_ELECTRICAL;
        chSaveth = SAVING_THROW_TYPE_ELECTRICITY;
        chVisual = VFX_IMP_LIGHTNING_S;
    }

    //Declare major variables
    float fDelay;
    object oTarget;
    effect eVis, eBreath;

    int nPersonalDamage;
    
    float fRange = 10.0;//meters not feet!
    int nSize = PRCGetCreatureSize(OBJECT_SELF);
    fRange = GetRangeFromSize(nSize);
    
    int nBreathShape = SHAPE_SPELLCONE;
    
    //these are lines not cones
    if(IsLineBreath())
    {
        nBreathShape = SHAPE_SPELLCYLINDER;
        fRange *= 2.0; //double the range
    }

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(nBreathShape, fRange, GetSpellTargetLocation(), TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));

    while(GetIsObjectValid(oTarget))
    {
        nPersonalDamage = nDamage;
        if(oTarget != OBJECT_SELF && !GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            //Determine effect delay
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            nPersonalDamage = PRCGetReflexAdjustedDamage(nPersonalDamage, oTarget, nSaveDC, chSaveth);
            if (nPersonalDamage > 0)
            {
                //Set Damage and VFX
                eBreath = EffectDamage(nPersonalDamage, eleBreath);
                eVis = EffectVisualEffect(chVisual);
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(nBreathShape, fRange, GetSpellTargetLocation(), TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
    }
}









//Pyroclastic Dragons Breath Attack.  This should be half fire and half sonic damage
//But any attempts I made to produce that effect would not function properly.  Instead,
//for now, the Pyroclastic Dragon has a 50/50 chance of breathing either fire or sonic.
void sonfireBreath(object oPC ,object oSkin ,int dPyCla ,int nSaveDC ,int nLevel ,int nDamage) 
{           
    int pyclBreath;
    int chSaveth;
    int chVisual;
    int eleRoll;
    
    int nNumDice = d2();
    //Sets the random Element factor of the Chaos Dragons Breath Weapon.
    //Affects damage, saving throw, and impact visual.
    if (nNumDice==1)
    {
        pyclBreath = DAMAGE_TYPE_SONIC;
        chSaveth = SAVING_THROW_TYPE_SONIC;
        chVisual = VFX_IMP_SILENCE;
    }
    else if (nNumDice==2)
    {
        pyclBreath = DAMAGE_TYPE_FIRE;
        chSaveth = SAVING_THROW_TYPE_FIRE;
        chVisual = VFX_IMP_FLAME_M;
    }

    //Declare major variables
    float fDelay;
    object oTarget;
    effect eVis, eBreath;

    int nPersonalDamage;
    float fRange = 10.0;//meters not feet!
    int nSize = PRCGetCreatureSize(OBJECT_SELF);
    fRange = GetRangeFromSize(nSize);
    
    int nBreathShape = SHAPE_SPELLCONE;
    
    //these are lines not cones
    if(IsLineBreath())
    {
        nBreathShape = SHAPE_SPELLCYLINDER;
        fRange *= 2.0; //double the range
    }

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(nBreathShape, fRange, GetSpellTargetLocation(), TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));

    while(GetIsObjectValid(oTarget))
    {
        nPersonalDamage = nDamage;
        if(oTarget != OBJECT_SELF && !GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            //Determine effect delay
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            nPersonalDamage = PRCGetReflexAdjustedDamage(nPersonalDamage, oTarget, nSaveDC, chSaveth);
            if (nPersonalDamage > 0)
            {
                //Set Damage and VFX
                //eBreath = EffectDamage(nPersonalDamage, pyclBreath);
                effect eBreath1 = EffectDamage(nPersonalDamage/2, DAMAGE_TYPE_FIRE);
                effect eBreath2 = EffectDamage(nPersonalDamage/2, DAMAGE_TYPE_SONIC);
                eBreath = EffectLinkEffects(eBreath2, eBreath1);
                eVis = EffectVisualEffect(chVisual);
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(nBreathShape, fRange, GetSpellTargetLocation(), TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF);
    }
}

//Shadow Dragon Breath Attack.  Does not inflict damage, but rather bestows
//those caught in its breath with 1 negative level.  This is still a reflex save
//apparently.
void ShadowBreath(object oPC ,object oSkin ,int dShadow ,int nSaveDC ,int nLevel) 
{
    //Declare major variables
    float fDelay;
    object oTarget;
    effect eVis, sDrain;

    int shadowDrain;
    float fRange = 10.0;//meters not feet!
    int nSize = PRCGetCreatureSize(OBJECT_SELF);
    switch(nSize)
    {
        case CREATURE_SIZE_FINE:        fRange = FeetToMeters(30.0); break;
        case CREATURE_SIZE_DIMINUTIVE:  fRange = FeetToMeters(30.0); break;
        case CREATURE_SIZE_TINY:        fRange = FeetToMeters(30.0); break;
        case CREATURE_SIZE_SMALL:       fRange = FeetToMeters(30.0); break;
        case CREATURE_SIZE_MEDIUM:      fRange = FeetToMeters(30.0); break;
        //PnP says 30, but I think this doesnt fit the progression so Ive made it 40
        //Primogenitor
        case CREATURE_SIZE_LARGE:       fRange = FeetToMeters(40.0); break; 
        case CREATURE_SIZE_HUGE:        fRange = FeetToMeters(50.0); break;
        case CREATURE_SIZE_GARGANTUAN:  fRange = FeetToMeters(60.0); break;
        case CREATURE_SIZE_COLOSSAL:    fRange = FeetToMeters(70.0); break;
    }

    int nBreathShape = SHAPE_SPELLCONE;

    //these are lines not cones
    if(IsLineBreath())
    {
        nBreathShape = SHAPE_SPELLCYLINDER;
        fRange *= 2.0; //double the range
    }

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(nBreathShape, fRange, GetSpellTargetLocation(), TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));

    while(GetIsObjectValid(oTarget))
    {
        shadowDrain = 1;
        if(oTarget != oPC && !GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oPC, GetSpellId()));
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            //Determine effect delay
            fDelay = GetDistanceBetween(oPC, oTarget)/20;
            shadowDrain = PRCGetReflexAdjustedDamage(shadowDrain, oTarget, nSaveDC, SAVING_THROW_TYPE_NEGATIVE);
            if (shadowDrain > 0)
            {
                //Set Damage and VFX
                sDrain = EffectNegativeLevel(shadowDrain);
                eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, sDrain, oTarget));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(nBreathShape, fRange, GetSpellTargetLocation(), TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
    }
}

void main()
{

    //Declare main variables. 
    object oPC = OBJECT_SELF; 
    object oSkin = GetPCSkin(oPC); 
    if(GetLocalInt(oPC, "DragonDiscipleBreathLock"))
    {
        SendMessageToPC(oPC, "You cannot use your breath weapon again so soon");
        IncrementRemainingFeatUses(oPC, FEAT_DRAGON_DIS_BREATH);
        return;
    }   
    SetLocalInt(oPC, "DragonDiscipleBreathLock", TRUE);
    float fDelay = RoundsToSeconds(d4());
    //put metabreath delay calculation in here
    DelayCommand(fDelay, DeleteLocalInt(oPC, "DragonDiscipleBreathLock"));
    DelayCommand(fDelay, SendMessageToPC(oPC, "Your breath weapon is ready now"));
    
    int cBoost = GetAbilityModifier(ABILITY_CONSTITUTION)>0 ? GetAbilityModifier(ABILITY_CONSTITUTION):0;
    int nSaveDC;
    int nLevel = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE,oPC);
    int nDamageDice;
    
    
    //Sets the save DC for Dragon Breath attacks.  This is a reflex save to halve the damage.
    //Save is 10+CON+1/2 DD level.  Gains +1 at level 13, and every 3 levels after.
    if (nLevel <13)        nSaveDC = (10 + ((nLevel)/2) + cBoost);
    else if (nLevel <16)   nSaveDC = (11 + ((nLevel)/2) + cBoost);
    else if (nLevel <19)   nSaveDC = (12 + ((nLevel)/2) + cBoost);
    else if (nLevel <22)   nSaveDC = (13 + ((nLevel)/2) + cBoost);
    else if (nLevel <25)   nSaveDC = (14 + ((nLevel)/2) + cBoost);
    else if (nLevel <28)   nSaveDC = (15 + ((nLevel)/2) + cBoost);
    else                   nSaveDC = (16 + ((nLevel)/2) + cBoost);

    //Sets damage levels for Dragon Breath attacks.  2d10 at level 3, 
    //4d10 at level 7, and then an additional 2d10 every 3 levels (10, 13, 16, ect)
    if (nLevel <7)        nDamageDice = 2;
    else if (nLevel <10)  nDamageDice = 4;
    else if (nLevel <13)  nDamageDice = 6;
    else if (nLevel <16)  nDamageDice = 8;
    else if (nLevel <19)  nDamageDice = 10;
    else if (nLevel <22)  nDamageDice = 12;
    else if (nLevel <25)  nDamageDice = 14;
    else if (nLevel <28)  nDamageDice = 16;
    else                  nDamageDice = 18;
    int nDamage = d10(nDamageDice);

    //Only Dragons with Breath Weapons will have damage caused by their breath attack.
    //Any Dragon type not listed here will have a breath attack, but it will not
    //cause damage or create a visual effect.
    int DBREED = GetHasFeat(FEAT_RED_DRAGON, OBJECT_SELF)       ? DAMAGE_TYPE_FIRE : 
                 GetHasFeat(FEAT_BRASS_DRAGON, OBJECT_SELF)     ? DAMAGE_TYPE_FIRE : 
                 GetHasFeat(FEAT_GOLD_DRAGON, OBJECT_SELF)      ? DAMAGE_TYPE_FIRE : 
                 GetHasFeat(FEAT_LUNG_WANG_DRAGON, OBJECT_SELF) ? DAMAGE_TYPE_FIRE : 
                 GetHasFeat(FEAT_TIEN_LUNG_DRAGON, OBJECT_SELF) ? DAMAGE_TYPE_FIRE : 
                 GetHasFeat(FEAT_BLACK_DRAGON, OBJECT_SELF)     ? DAMAGE_TYPE_ACID : 
                 GetHasFeat(FEAT_GREEN_DRAGON, OBJECT_SELF)     ? DAMAGE_TYPE_ACID : 
                 GetHasFeat(FEAT_COPPER_DRAGON, OBJECT_SELF)    ? DAMAGE_TYPE_ACID : 
                 GetHasFeat(FEAT_BROWN_DRAGON, OBJECT_SELF)     ? DAMAGE_TYPE_ACID : 
                 GetHasFeat(FEAT_DEEP_DRAGON, OBJECT_SELF)      ? DAMAGE_TYPE_ACID : 
                 GetHasFeat(FEAT_RUST_DRAGON, OBJECT_SELF)      ? DAMAGE_TYPE_ACID : 
                 GetHasFeat(FEAT_STYX_DRAGON, OBJECT_SELF)      ? DAMAGE_TYPE_ACID : 
                 GetHasFeat(FEAT_SILVER_DRAGON, OBJECT_SELF)    ? DAMAGE_TYPE_COLD : 
                 GetHasFeat(FEAT_WHITE_DRAGON, OBJECT_SELF)     ? DAMAGE_TYPE_COLD : 
                 GetHasFeat(FEAT_BLUE_DRAGON, OBJECT_SELF)      ? DAMAGE_TYPE_ELECTRICAL : 
                 GetHasFeat(FEAT_BRONZE_DRAGON, OBJECT_SELF)    ? DAMAGE_TYPE_ELECTRICAL : 
                 GetHasFeat(FEAT_OCEANUS_DRAGON, OBJECT_SELF)   ? DAMAGE_TYPE_ELECTRICAL : 
                 GetHasFeat(FEAT_SONG_DRAGON, OBJECT_SELF)      ? DAMAGE_TYPE_ELECTRICAL : 
                 GetHasFeat(FEAT_EMERALD_DRAGON, OBJECT_SELF)   ? DAMAGE_TYPE_SONIC : 
                 GetHasFeat(FEAT_SAPPHIRE_DRAGON, OBJECT_SELF)  ? DAMAGE_TYPE_SONIC : 
                 GetHasFeat(FEAT_BATTLE_DRAGON, OBJECT_SELF)    ? DAMAGE_TYPE_SONIC : 
                 GetHasFeat(FEAT_HOWLING_DRAGON, OBJECT_SELF)   ? DAMAGE_TYPE_SONIC : 
                 GetHasFeat(FEAT_CRYSTAL_DRAGON, OBJECT_SELF)   ? DAMAGE_TYPE_POSITIVE : 
                 GetHasFeat(FEAT_AMETHYST_DRAGON, OBJECT_SELF)  ? DAMAGE_TYPE_MAGICAL : 
                 GetHasFeat(FEAT_TOPAZ_DRAGON, OBJECT_SELF)     ? DAMAGE_TYPE_MAGICAL : 
                 GetHasFeat(FEAT_ETHEREAL_DRAGON, OBJECT_SELF)  ? DAMAGE_TYPE_MAGICAL : 
                 GetHasFeat(FEAT_RADIANT_DRAGON, OBJECT_SELF)   ? DAMAGE_TYPE_MAGICAL : 
                 GetHasFeat(FEAT_TARTIAN_DRAGON, OBJECT_SELF)   ? DAMAGE_TYPE_MAGICAL : 
                -1; // If none match, make the itemproperty invalid 
                
                
    int dChaos = GetHasFeat(FEAT_CHAOS_DRAGON, OBJECT_SELF);
    int dPyCla = GetHasFeat(FEAT_PYROCLASTIC_DRAGON, OBJECT_SELF);
    int dShadow = GetHasFeat(FEAT_SHADOW_DRAGON, OBJECT_SELF);
    
    if (DBREED>0) BreathAttack(oPC,oSkin,DBREED,nSaveDC,nLevel,nDamage);
    if (dChaos>0) RandomBreath(oPC,oSkin,dChaos,nSaveDC,nLevel,nDamage);
    if (dPyCla>0) sonfireBreath(oPC,oSkin,dShadow,nSaveDC,nLevel,nDamage);
    if (dShadow>0) ShadowBreath(oPC,oSkin,dShadow,nSaveDC,nLevel);
    
    //breath VFX
    effect eVis = EffectVisualEffect(494);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVis,GetSpellTargetLocation());
}

*/