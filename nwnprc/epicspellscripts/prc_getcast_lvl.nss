#include "prc_class_const"
#include "prc_feat_const"


int IsArcaneClass(int nClass);
int IsDivineClass(int nClass);

const int  TYPE_ARCANE   = 1;
const int  TYPE_DIVINE   = 2;
const int  TYPE_SORCERER = 3;
const int  TYPE_WIZARD   = 4;
const int  TYPE_BARD     = 5;
const int  TYPE_CLERIC   = 6;
const int  TYPE_DRUID    = 7;
const int  TYPE_RANGER   = 8;
const int  TYPE_PALADIN  = 9;

int PractisedSpellGetCast( int nLevelBonus,int nCastingClass ,object oCaster);

int GetCasterLvl(int iTypeSpell,object oCaster = OBJECT_SELF);

int
PractisedSpellGetCast( int nLevelBonus,int nCastingClass ,object oCaster)
{
   int DiffCasterLvl = GetHitDice(oCaster)- nLevelBonus;
   int nBonus ;

   if (DiffCasterLvl)
   {
        int nFeat;

        if (nCastingClass == CLASS_TYPE_BARD)           nFeat = FEAT_PRACTISED_SPELLCASTER_BARD;
        else if (nCastingClass == CLASS_TYPE_SORCERER)  nFeat = FEAT_PRACTISED_SPELLCASTER_SORCERER;
        else if (nCastingClass == CLASS_TYPE_WIZARD)    nFeat = FEAT_PRACTISED_SPELLCASTER_WIZARD;
        else if (nCastingClass == CLASS_TYPE_CLERIC)    nFeat = FEAT_PRACTISED_SPELLCASTER_CLERIC;
        else if (nCastingClass == CLASS_TYPE_DRUID)     nFeat = FEAT_PRACTISED_SPELLCASTER_DRUID;

        if (GetHasFeat(nFeat,oCaster)){
           nBonus = DiffCasterLvl >4 ? 4:DiffCasterLvl;
        }

   }
   return nBonus;
}


int GetCasterLvl(int iTypeSpell,object oCaster = OBJECT_SELF)
{


  
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  // This is the section where you declare any + 1 caster level prc's and the amount
  // of casting levels they should add
  //////////////////////////////////////////////////////////////////////////////////

  int nDivine;
  int nArcane;
  int CastingClassDiv,CastingClassArc;


  int nDruid=GetLevelByClass(CLASS_TYPE_DRUID, oCaster);
  int nCleric=GetLevelByClass(CLASS_TYPE_CLERIC, oCaster);
  int nPaladin=GetLevelByClass(CLASS_TYPE_PALADIN, oCaster)/2;
  int nRanger=GetLevelByClass(CLASS_TYPE_RANGER, oCaster)/2;

  int nSorcerer=GetLevelByClass(CLASS_TYPE_SORCERER, oCaster);
  int nWizard=GetLevelByClass(CLASS_TYPE_WIZARD, oCaster);
  int nBard=GetLevelByClass(CLASS_TYPE_BARD, oCaster);
  
  switch (iTypeSpell)
  {
    case TYPE_SORCERER:
      if (nWizard>nSorcerer ||nBard>nSorcerer) return nSorcerer;
      iTypeSpell = TYPE_ARCANE;
      break;	
    case TYPE_WIZARD:
      if (nSorcerer>nWizard ||nBard>nWizard)   return nWizard;
      iTypeSpell = TYPE_ARCANE;
      break;	
    case TYPE_BARD:
      if (nWizard>nBard ||nSorcerer>nBard)     return nBard;
      iTypeSpell = TYPE_ARCANE;
      break;	
    case TYPE_CLERIC:
      if (nPaladin>nCleric || nRanger>nCleric ||nDruid>nCleric  )      return nCleric;
      iTypeSpell = TYPE_DIVINE;
      break;	
    case TYPE_DRUID:
      if (nPaladin>nDruid  ||nRanger>nDruid   ||nCleric>nDruid )       return nDruid;
      iTypeSpell = TYPE_DIVINE;
      break;	
    case TYPE_RANGER:
      if (nPaladin>nRanger || nCleric>nRanger ||nDruid>nRanger  )      return nRanger;
      iTypeSpell = TYPE_DIVINE;
      break;	
    case TYPE_PALADIN:
      if (nDruid>nPaladin  ||nRanger>nPaladin   ||nCleric>nPaladin )   return nPaladin;
      iTypeSpell = TYPE_DIVINE;
      break;	
  	
  	
  	
  }
  

  nDivine = nCleric ; CastingClassDiv = CLASS_TYPE_CLERIC;

  if (nDruid>nCleric)  { nDivine = nDruid;   CastingClassDiv = CLASS_TYPE_DRUID;}
  if (nPaladin>nDivine){ nDivine = nPaladin; CastingClassDiv = CLASS_TYPE_PALADIN;}
  if (nRanger>nDivine) { nDivine = nRanger;  CastingClassDiv = CLASS_TYPE_RANGER;}

  nArcane = nWizard; CastingClassArc = CLASS_TYPE_WIZARD;

  if (nSorcerer>nWizard){ nArcane = nSorcerer; CastingClassArc = CLASS_TYPE_SORCERER;}
  if (nBard>nArcane)    { nArcane = nBard;     CastingClassArc = CLASS_TYPE_BARD;}


  int nOozeMLevel = GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);
  int nFirstClass = GetClassByPosition(1, oCaster);


    if( iTypeSpell == TYPE_ARCANE ){


        nArcane+=
         
            GetHasFeat(FEAT_FIRE_ADEPT, oCaster) + 
            GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster)+ 
            
            GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster)+
            GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster)+
            GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster)+
            GetLevelByClass(CLASS_TYPE_ES_FIRE, oCaster)+
            GetLevelByClass(CLASS_TYPE_ES_COLD, oCaster)+
            GetLevelByClass(CLASS_TYPE_ES_ELEC, oCaster)+
            GetLevelByClass(CLASS_TYPE_ES_ACID, oCaster)+
            GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster)+  
            GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster)+            
            GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster)+            
            GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster)+
            GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster)+
               
            (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2+ 
            (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2+          
            (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) / 2+     
            (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2+ 
            (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2+ 
            (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) / 2;


        // area for CLASS-specific code. Avoid if possible


		// Using nFirstClass does not look right
        if (nOozeMLevel) {
                          if (IsArcaneClass(nFirstClass) || (!IsDivineClass(nFirstClass)
					&& IsArcaneClass(GetClassByPosition(2, oCaster))))
                                         nArcane += nOozeMLevel / 2;
        }
        
         nArcane+= PractisedSpellGetCast(nArcane,CastingClassArc,oCaster);
               
        if (GetHasFeat(FEAT_SPELL_POWER_I)){
            nArcane+=1;
            if (GetHasFeat(FEAT_SPELL_POWER_II)){
                nArcane+=1;
                if (GetHasFeat(FEAT_SPELL_POWER_III)){
                    nArcane+=1;
                    if (GetHasFeat(FEAT_SPELL_POWER_IV)){
                        nArcane+=1;
                        if (GetHasFeat(FEAT_SPELL_POWER_V)){
                            nArcane+=1;
                        }}}}
        }
    }//end of arcane spell part
    
    else if( iTypeSpell == TYPE_DIVINE){

 
        nDivine+=
            GetLevelByClass(CLASS_TYPE_DIVESA, oCaster)+
            GetLevelByClass(CLASS_TYPE_DIVESC, oCaster)+
            GetLevelByClass(CLASS_TYPE_DIVESE, oCaster)+
            GetLevelByClass(CLASS_TYPE_DIVESF, oCaster)+
            GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster)+
            GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster)+
            GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster)+
            GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster)+
            GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster)+
            GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster)+
            GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster)+
                       
            (GetLevelByClass(CLASS_TYPE_KNIGHT_CHALICE, oCaster) + 1) /  2+       
	    (GetLevelByClass(CLASS_TYPE_OCULAR, oCaster) + 1) / 2+ 
	    (GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster) + 1) / 2+ 
	    (GetLevelByClass(CLASS_TYPE_BFZ, oCaster) + 1) / 2+ 
            (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2+ 
	    (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2; 

            if ( !GetHasFeat(FEAT_SF_CODE, oCaster))
                nDivine += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
	    
          nDivine+= PractisedSpellGetCast(nDivine,CastingClassDiv,oCaster);


	    
   
        //class-specific code. Avoid if at all possible

	// Using nFirstClass does not look right
        if (nOozeMLevel) {
            if (IsDivineClass(nFirstClass) || (!IsArcaneClass(nFirstClass)
					&& IsDivineClass(GetClassByPosition(2, oCaster))))
                nDivine += nOozeMLevel / 2;
        }

    }//end of divine spell part

  

 if (iTypeSpell == TYPE_ARCANE)
   return nArcane;
 else
   return nDivine;

}// end function

int IsArcaneClass(int nClass){
    return (    nClass==CLASS_TYPE_WIZARD ||
                nClass==CLASS_TYPE_SORCERER ||
                nClass==CLASS_TYPE_BARD);
}

int IsDivineClass(int nClass){
    return (    nClass==CLASS_TYPE_CLERIC ||
                nClass==CLASS_TYPE_DRUID);
}
