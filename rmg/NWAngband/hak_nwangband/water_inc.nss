/*
I was thinking of implementing underwater rules for builders, now we have kelp,
sharks, etc. For reference, 3.5ed rules are:
http://www.d20srd.org/srd/wilderness.htm#aquaticTerrain

This would probably be implemented as follows:

Being underwater (or in some other thicker-than-air enviroment):

If you have Freedom Of Movement, you can move and act normally.

If you have a swim speed (which a few things do in NWN) you can move normally,
but have -2 to attack and a damage penalty (by PnP its 50% but that would have
to be a fixed amount in NWN) when using non-piercing weapons.

If you pass a DC 10 Swim Check (Id implement the Swim skill too) you can move
at 75% speed, but have -2 to attack and a damage penalty (by PnP its 50% but
that would have to be a fixed amount in NWN) when using non-piercing weapons.

Otherwise, move at 50% speed, but have -2 to attack and a damage penalty
(by PnP its 50% but that would have to be a fixed amount in NWN) when using
non-piercing weapons.

Drowning/suffocation/etc

If you can breath underwater, then your safe. This might be a racial ability
or a spell, which means adding Water Breathing and similar spells.

If you dont need to breathe at all (construct, undead, etc), then your safe.

You can hold your breath for a number of rounds equal to twice your Constitution
score. If you attack or cast a spell, the remainder of the duration for which
you can hold your breath is reduced by 1 round.

After that period of time, you must make a DC 10 Constitution check every round
to continue holding your breath. Each round, the DC for that check increases by 1.
If you fail the Constitution check, you begin to drown.

When a character drowning. Each round the character takes 90% of their current
HP as damage, minimum 1.


This lends itself to some optional switches too:

Firstly, giving everything that enters 100% Fire and/or Electrical immunity
(they dont work underwater)

Secondly, making it a fort save rather than a con check. This would allow
things to live a lot longer underwater, and exaggerates the difference between
creatures.
*/

const int DROWN_USE_FORT_NOT_CON = FALSE;

int CanMoveUnderwater(object oPC)
{
    //check spell effects
    if(GetHasSpellEffect(SPELL_FREEDOM_OF_MOVEMENT, oPC))
        return 1;
    //appearance
    int nAppearance = GetAppearanceType(oPC);
    switch(nAppearance)
    {
        case APPEARANCE_TYPE_ELEMENTAL_WATER:
        case APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER:
        case APPEARANCE_TYPE_MEPHIT_WATER:
        case APPEARANCE_TYPE_SHARK_GOBLIN:
        case APPEARANCE_TYPE_SHARK_HAMMERHEAD:
        case APPEARANCE_TYPE_SHARK_MAKO:
        case APPEARANCE_TYPE_SEA_HAG:
            return 2;
    }
    //check items
    int i;
    for(i=0;i<=NUM_INVENTORY_SLOTS;i++)
    {
        object oItem = GetItemInSlot(i, oPC);
        itemproperty ipTest = GetFirstItemProperty(oItem);
        while(GetIsItemPropertyValid(ipTest))
        {
            if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_FREEDOM_OF_MOVEMENT)
                return 1;
            ipTest = GetNextItemProperty(oItem);
        }
    }
    return FALSE;
}

void DoUnderwaterMoveHB()
{
    object oPC = OBJECT_SELF;
    //make sure they are underwater
    if(!GetLocalInt(oPC, "IsUnderwaterMove"))
        return;
    //make sure the HB only runs once per time
    if(GetLocalInt(oPC, "IsUnderwaterMoveHBRan"))
        return;
    SetLocalInt(oPC, "IsUnderwaterMoveHBRan", TRUE);
    DelayCommand(5.99, DeleteLocalInt(oPC, "IsUnderwaterMoveHBRan"));
    //see if they can swim
    int nSwim = CanMoveUnderwater(oPC);
    if(nSwim == TRUE)
    {
        //can move freely, do nothing
    }
    else if(nSwim == 2)
    {
        //has swim speed
        effect eAttack = EffectAttackDecrease(2);
        effect eDam1 = EffectDamageDecrease(5, DAMAGE_TYPE_BLUDGEONING);
        effect eDam2 = EffectDamageDecrease(5, DAMAGE_TYPE_SLASHING);
        effect eVis = EffectVisualEffect(VFX_DUR_BUBBLES);
        effect eLink;
        eLink = EffectLinkEffects(eAttack, eDam1);
        eLink = EffectLinkEffects(eLink, eDam2);
        eLink = EffectLinkEffects(eLink, eVis);
        //make it supernatural/non-dispellable
        eLink = SupernaturalEffect(eLink);
        //apply it
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 6.0);
    }
    else if(nSwim == 3)
    {
        //passed swim check
        effect eSpeed = EffectMovementSpeedDecrease(75);
        effect eAttack = EffectAttackDecrease(2);
        effect eDam1 = EffectDamageDecrease(5, DAMAGE_TYPE_BLUDGEONING);
        effect eDam2 = EffectDamageDecrease(5, DAMAGE_TYPE_SLASHING);
        effect eVis = EffectVisualEffect(VFX_DUR_BUBBLES);
        effect eLink;
        eLink = EffectLinkEffects(eSpeed, eAttack);
        eLink = EffectLinkEffects(eLink, eDam1);
        eLink = EffectLinkEffects(eLink, eDam2);
        eLink = EffectLinkEffects(eLink, eVis);
        //make it supernatural/non-dispellable
        eLink = SupernaturalEffect(eLink);
        //apply it
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 6.0);
    }
    else
    {
        //non-swimmer
        effect eSpeed = EffectMovementSpeedDecrease(50);
        effect eAttack = EffectAttackDecrease(2);
        effect eDam1 = EffectDamageDecrease(5, DAMAGE_TYPE_BLUDGEONING);
        effect eDam2 = EffectDamageDecrease(5, DAMAGE_TYPE_SLASHING);
        effect eVis = EffectVisualEffect(VFX_DUR_BUBBLES);
        effect eLink;
        eLink = EffectLinkEffects(eSpeed, eAttack);
        eLink = EffectLinkEffects(eLink, eDam1);
        eLink = EffectLinkEffects(eLink, eDam2);
        eLink = EffectLinkEffects(eLink, eVis);
        //make it supernatural/non-dispellable
        eLink = SupernaturalEffect(eLink);
        //apply it
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 6.0);
    }
    DelayCommand(6.0, DoUnderwaterMoveHB());
}

void EnterUnderwaterMovement(object oPC)
{
    SetLocalInt(oPC, "IsUnderwaterMove", GetLocalInt(oPC, "IsUnderwaterMove")+1);
    //if this is the first underwater area, start the pseudoHB
    if(GetLocalInt(oPC, "IsUnderwaterMove") == 1)
        AssignCommand(oPC, DoUnderwaterMoveHB());
}

void ExitUnderwaterMovement(object oPC)
{
    SetLocalInt(oPC, "IsUnderwaterMove", GetLocalInt(oPC, "IsUnderwaterMove")-1);
}

int CanBreatheUnderwater(object oPC)
{
    //things that dont breathe at all
    if(GetRacialType(oPC) == RACIAL_TYPE_CONSTRUCT
        || GetRacialType(oPC) == RACIAL_TYPE_ELEMENTAL
        || GetRacialType(oPC) == RACIAL_TYPE_UNDEAD)
        return TRUE;
    //anything else
    return FALSE;
}

void DoUnderwaterDrownHB()
{
    object oPC = OBJECT_SELF;
    //make sure they are underwater
    if(!GetLocalInt(oPC, "IsUnderwaterDrown"))
    {
        //out of water, catch breath
        DeleteLocalInt(oPC, "IsUnderwaterDrownDC");
        return;
    }
    //make sure the HB only runs once per time
    if(GetLocalInt(oPC, "IsUnderwaterDrownHBRan"))
        return;
    SetLocalInt(oPC, "IsUnderwaterDrownHBRan", TRUE);
    DelayCommand(5.99, DeleteLocalInt(oPC, "IsUnderwaterDrownHBRan"));
    //see if they can swim
    int nSwim = CanBreatheUnderwater(oPC);
    if(nSwim == TRUE)
    {
        //can breath freely, do nothing
    }
    else
    {
        //cant breathe
        int nDC = GetLocalInt(oPC, "IsUnderwaterDrownDC");
        //entered water
        if(nDC == 0)
        {
            nDC = GetAbilityScore(oPC, ABILITY_CONSTITUTION);
            nDC *= -2;
        }
        //holding breath
        else if(nDC < 0)
        {
            nDC++;
            //check doing something strenuous
            if(GetCurrentAction(oPC) == ACTION_ATTACKOBJECT
                || GetCurrentAction(oPC) == ACTION_CASTSPELL
                || GetCurrentAction(oPC) == ACTION_OPENLOCK
                || GetCurrentAction(oPC) == ACTION_SETTRAP
                || GetCurrentAction(oPC) == ACTION_FLAGTRAP
                || GetCurrentAction(oPC) == ACTION_RECOVERTRAP
                || GetCurrentAction(oPC) == ACTION_PICKPOCKET)
                nDC++;
            //check if run out of breath
            if(nDC >= 0)
                nDC = 10;
        }
        //still holding breath
        else if(nDC > 0)
        {
            int nScore = d20()+GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
            if(DROWN_USE_FORT_NOT_CON)
                nScore = d20()+GetFortitudeSavingThrow(oPC);
            if(nScore <= nDC)
            {
                //kept breath
                nDC++;
            }
            else
            {
                //drowning or starting to drown
                nDC = 999;
                int nDam = FloatToInt(IntToFloat(GetCurrentHitPoints(oPC))*0.9);
                if(nDam < 1)
                    nDam = 1;
                effect eDam = EffectDamage(nDam);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
            }
        }
        SetLocalInt(oPC, "IsUnderwaterDrownDC", nDC);
    }
    DelayCommand(6.0, DoUnderwaterDrownHB());
}

void EnterUnderwaterDrown(object oPC)
{
    SetLocalInt(oPC, "IsUnderwaterDrown", GetLocalInt(oPC, "IsUnderwaterDrown")+1);
    //if this is the first underwater area, start the pseudoHB
    if(GetLocalInt(oPC, "IsUnderwaterDrown") == 1)
        AssignCommand(oPC, DoUnderwaterDrownHB());
}

void ExitUnderwaterDrown(object oPC)
{
    SetLocalInt(oPC, "IsUnderwaterDrown", GetLocalInt(oPC, "IsUnderwaterDrown")-1);
}
