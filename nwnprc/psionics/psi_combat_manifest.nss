void main()
{
    if(GetHasFeat(FEAT_COMBAT_MANIFESTATION))
    {
        SetCompositeBonus(oSkin, "Combat_Mani", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_CONCENTRATION);
    }
}