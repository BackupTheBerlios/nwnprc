#include "prc_spell_const"
#include "nw_i0_spells"
#include "inc_item_props"

void SetCompositeBonusTemp(object oItem, int iVal, int iType, int iSubType = -1);

void SetCompositeBonusTemp(object oItem, int iVal, int iType, int iSubType = -1)
{

    int iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
    if ((iCurVal + iVal)  > 20)
    {
       iCurVal = 20;
       iVal = 0;
    }
    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDecreaseAbility(iSubType, iCurVal + iVal), oItem,HoursToSeconds(2));

}


void main()
{
  int nSpell = GetSpellId();
  int iStig = 2;
  if (nSpell == SPELL_STIGMATA3) iStig = 3;
  else if (nSpell == SPELL_STIGMATA4) iStig = 4;
  else if (nSpell == SPELL_STIGMATA5) iStig = 5;

  int iStigs = GetLocalInt(OBJECT_SELF,"Stigmata");

  object oPC = OBJECT_SELF;
  if (GetAlignmentGoodEvil(oPC)!= ALIGNMENT_GOOD) return;


  object oSkin = GetPCSkin(oPC);

  object oTarget = GetSpellTargetObject();
  
  if (!spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
  {
      FloatingTextStringOnCreature("Only works on Allies",OBJECT_SELF);
      return ;	
  }

  if ( GetHasSpellEffect(SPELL_STIGMATA2,oTarget)||GetHasSpellEffect(SPELL_STIGMATA3,oTarget)||
       GetHasSpellEffect(SPELL_STIGMATA4,oTarget)||GetHasSpellEffect(SPELL_STIGMATA5,oTarget))
         return;

  if ( !iStigs )
  {
    SetLocalInt(OBJECT_SELF,"Stigmata",iStig);
    SetLocalInt(OBJECT_SELF,"StigmataMax",iStig);
    iStigs = iStig;
    SetCompositeBonusTemp(oSkin,iStig,ITEM_PROPERTY_DECREASED_ABILITY_SCORE,IP_CONST_ABILITY_CON);
  }

  int iMaxStig =GetLocalInt(OBJECT_SELF,"Stigmata");
  int iCure = GetHitDice(oTarget)*iMaxStig/2;



  effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_X);
  effect eHeal;

 
  eHeal = EffectHeal(iCure);
  ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectLinkEffects(eHeal,eHealVis), oTarget);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR), oTarget,HoursToSeconds(2));

  SetLocalInt(OBJECT_SELF,"Stigmata",iStigs-1);

  DelayCommand(220.0,DeleteLocalInt(oPC,"Stigmata"));

  effect eff = GetFirstEffect(oTarget);
  while(GetIsEffectValid(eff))
  {
    if (GetEffectType(eff) == EFFECT_TYPE_DISEASE )
    {
       if (d100() < 51) RemoveEffect(oTarget,eff);
    }
    eff = GetNextEffect(oTarget);
  }
}
