#include "prc_alterations"

void main()
{
  object oWeapon = GetSpellCastItem();
  object oTarget = GetSpellTargetObject();
  if (GetAlignmentGoodEvil(oTarget)!=ALIGNMENT_EVIL) return;
  int nRacial = MyPRCGetRacialType(oTarget);

  effect eVis =EffectVisualEffect(VFX_IMP_POISON_S);
  effect ePoison = EffectPoison(100);
  int iCha = GetAbilityModifier(ABILITY_CHARISMA,OBJECT_SELF);
      iCha = (iCha >0)? iCha :0 ;

  if ( nRacial == RACIAL_TYPE_UNDEAD) iCha++;
  if ( nRacial == RACIAL_TYPE_ELEMENTAL) iCha++;
  if ( GetLevelByClass(CLASS_TYPE_CLERIC,oTarget))  iCha+=2;
  if ( nRacial ==RACIAL_TYPE_OUTSIDER) iCha+=2;

  ePoison = EffectLinkEffects(ePoison,EffectDamage(iCha));

  ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);




}
