//:://////////////////////////////////////////////
//:: FileName: "wander_unseen"
/*   Purpose: Wander Unseen - this is the ability that is granted to a player
        as the result of an Unseen Wanderer epic spell. Using this feat will
        either turn the player invisible, or if already in that state, visible
        again.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 13, 2004
//:://////////////////////////////////////////////

void main()
{
    object oPC = OBJECT_SELF;
    effect eX, eRem;
    int nIsInvis;

    eX = GetFirstEffect(oPC);
    while (GetIsEffectValid(eX))
    {
        if (GetEffectType(eX) == EFFECT_TYPE_INVISIBILITY ||
            GetEffectType(eX) == EFFECT_TYPE_IMPROVEDINVISIBILITY)
        {
            // Debug
            SendMessageToPC(oPC, "Invisible");
            nIsInvis = TRUE;
            eRem = eX;
        }
        eX = GetNextEffect(oPC);
    }

    if (nIsInvis == TRUE)
    {
        RemoveEffect(oPC, eRem);
    }
    else
    {
        effect eInv = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInv, oPC);
    }
}
