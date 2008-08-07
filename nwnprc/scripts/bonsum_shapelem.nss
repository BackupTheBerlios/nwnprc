
#include "pnp_shft_poly"

void main()
{

    int iType = GetHasFeat(FEAT_BONDED_AIR, OBJECT_SELF)   ? 1 : 0 ;
        iType = GetHasFeat(FEAT_BONDED_EARTH, OBJECT_SELF) ? 2 : iType ;
        iType = GetHasFeat(FEAT_BONDED_FIRE, OBJECT_SELF)  ? 3 : iType ;
        iType = GetHasFeat(FEAT_BONDED_WATER, OBJECT_SELF) ? 4 : iType ;


    int iPoly;

    if (iType==1)
    {
       iPoly = POLYMORPH_TYPE_ELDER_AIR_ELEMENTAL;
    }
    else if (iType==2)
    {
       iPoly = POLYMORPH_TYPE_ELDER_EARTH_ELEMENTAL;
    }
    else if (iType==3)
    {
       iPoly = POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL;
    }
    else if (iType==4)
    {
       iPoly = POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL;
    }

    // abort if mounted
    if (!GetLocalInt(GetModule(),"X3_NO_SHAPESHIFT_SPELL_CHECK"))
    { // check to see if abort due to being mounted
        if (PRCHorseGetIsMounted(OBJECT_SELF))
        { // abort
            if (GetIsPC(OBJECT_SELF)) FloatingTextStrRefOnCreature(111982,OBJECT_SELF,FALSE);
              return;
        } // abort
    } // check to see if abort due to being mounted
    
    //this command will make shore that polymorph plays nice with the shifter
    ShifterCheck(OBJECT_SELF);

        ClearAllActions(); // prevents an exploit
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectPolymorph(iPoly),OBJECT_SELF,HoursToSeconds(10));
    DelayCommand(1.5,ActionCastSpellOnSelf(SPELL_SHAPE_INCREASE_DAMAGE));
}
