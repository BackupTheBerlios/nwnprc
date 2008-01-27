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
}