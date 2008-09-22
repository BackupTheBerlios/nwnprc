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

int GetVileFeats(object oTarget);

void main()
{
        object oPC = OBJECT_SELF;
        ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, 1, -1.0)
        int nBonus = GetVileFeats(oPC);
        
        if(
}

int GetVileFeats(object oTarget)
{
        int nCount;
        
        if(GetHasFeat(FEAT_