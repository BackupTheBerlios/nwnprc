#include "prc_inc_function"
#include "heartward_inc"


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

int GetCasterLvl(int iTypeSpell,object oCaster = OBJECT_SELF)
{


  
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  // This is the section where you declare any + 1 caster level prc's and the amount
  // of casting levels they should add
  //////////////////////////////////////////////////////////////////////////////////

  int nDivine;
  int nArcane;

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
      if (nPaladin>nRanger || nCleric>nRanger ||nDruid>nRanger  )      return nCleric;
      iTypeSpell = TYPE_DIVINE;
      break;	
    case TYPE_PALADIN:
      if (nDruid>nPaladin  ||nRanger>nPaladin   ||nCleric>nPaladin )   return nDruid;
      iTypeSpell = TYPE_DIVINE;
      break;	
  	
  	
  	
  }
  

  nDivine = (nDruid>nCleric)   ? nDruid :  nCleric ;
  nDivine = (nDivine>nPaladin) ? nDivine :  nPaladin ;
  nDivine = (nDivine>nRanger)  ? nDivine :  nRanger ;

  nArcane = (nSorcerer>nWizard)? nSorcerer :  nWizard ;
  nArcane = (nArcane>nBard)    ? nArcane   : nBard ;

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
               
            GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) / 2+ 
            GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster)/2+                
            GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster)/2+           
            GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster)/2+
            GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) / 2;


        // area for CLASS-specific code. Avoid if possible


		// Using nFirstClass does not look right
        if (nOozeMLevel) {
                          if (IsArcaneClass(nFirstClass) || (!IsDivineClass(nFirstClass)
					&& IsArcaneClass(GetClassByPosition(2, oCaster))))
                                         nArcane += nOozeMLevel / 2;
        }
               
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
                       
            GetLevelByClass(CLASS_TYPE_KNIGHT_CHALICE, oCaster)/2 +            
	    GetLevelByClass(CLASS_TYPE_OCULAR, oCaster)/2 +
	    GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster)/2+
	    GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster)/2;
	    
   
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
