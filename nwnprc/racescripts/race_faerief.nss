
//::///////////////////////////////////////////////
//:: Faerie Fire
//:: sp_faerie_fire
//:://////////////////////////////////////////////
/*
Faerie Fire
Evocation [Light]
Level: Drd 1
Components: V, S, DF
Casting Time: 1 standard action
Range: Long (400 ft. + 40 ft./level)
Area: Creatures and objects within a 5-ft.-radius burst
Duration: 1 min./level (D)
Saving Throw: None
Spell Resistance: Yes
A pale glow surrounds and outlines the subjects. Outlined subjects shed light
as candles. Outlined creatures do not benefit from the concealment normally
provided by darkness (though a 2nd-level or higher magical darkness effect
functions normally), blur, displacement, invisibility, or similar effects.
The light is too dim to have any special effect on undead or dark-dwelling
creatures vulnerable to light. The faerie fire can be blue, green, or violet,
according to your choice at the time of casting. The faerie fire does not
cause any harm to the objects or creatures thus outlined.

*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: Sept 22 , 2004
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oCaster = OBJECT_SELF;

    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nCasterLvl = CasterLvl;
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    effect eExplode = EffectVisualEffect(VFX_FNF_BLINDDEAF);
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();

    float fDuration = MinutesToSeconds(CasterLvl);
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        fDuration = fDuration * 2.0;    //Duration is +100%
    }

    CasterLvl +=SPGetPenetr();

    //Apply the fireball explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        effect eVis;
        switch(Random(3))
        {
            case 0:
                eVis = EffectVisualEffect(VFX_DUR_LIGHT_PURPLE_5);
                break;
            case 1:
                eVis = EffectVisualEffect(VFX_DUR_LIGHT_BLUE_5);
                break;
            case 2:
                eVis = EffectVisualEffect(VFX_DUR_LIGHT_RED_5);
                break;
        }
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FAERIE_FIRE));
        if (!MyPRCResistSpell(oCaster, oTarget,CasterLvl))
        {
            PRCSPApplyEffectToObject(SPELL_FAERIE_FIRE, CasterLvl, oCaster, DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);
            RemoveSpecificEffect(EFFECT_TYPE_IMPROVEDINVISIBILITY, oTarget);
            RemoveSpecificEffect(EFFECT_TYPE_INVISIBILITY, oTarget);
            RemoveSpecificEffect(EFFECT_TYPE_DARKNESS, oTarget);
            RemoveSpecificEffect(EFFECT_TYPE_CONCEALMENT, oTarget);
        }
        //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }



DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}