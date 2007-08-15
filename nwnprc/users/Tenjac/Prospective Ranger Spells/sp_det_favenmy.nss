//::///////////////////////////////////////////////
//:: Name      Detect Favored Enemy
//:: FileName  sp_det_favenmy.nss
//:://////////////////////////////////////////////
/**@file Detect Favored Enemies
Divination
Level: Ranger 1
Components: V, S, DF
Casting Time: 1 standard action
Range: 60 ft.
Area: Quarter circle emanating from
you to the extreme of the range
Duration: Concentration, up to 10
minutes/level (D)
Saving Throw: None
Spell Resistance: No
Using your passion for fighting your foe, you
reach out with your magic and your mind
to sense the presence of your enemies.
You can sense the presence of a favored
enemy. The amount of information
revealed depends on how long you
study a particular area.
1st Round: Presence or absence of a
favored enemy in the area.
2nd Round: Types of favored enemies
in the area and the number of each
type.
3rd Round: The location and HD of
each individual present.
Note: Each round you can turn to
detect things in a new area. The spell
can penetrate barriers, but 1 foot of
stone, 1 inch of common metal, a thin
sheet of lead, or 3 feet of wood or dirt
blocks detection.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
        object oPC = OBJECT_SELF;
        int nCount = CountFavEnemies(oPC);
        
        //eval favored enemies
                        
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
int CountFavEnemies(object oPC)
{
        int nCount;
        
        if(GetHasFeat(FEAT_FAVORED_ENEMY_ABERRATION ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_ANIMAL ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_BEAST ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_CONSTRUCT ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_DRAGON ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_DWARF ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_ELEMENTAL ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_ELF ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_FEY ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_GIANT ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_GNOME ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_GOBLINOID ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_HALFELF ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_HALFLING ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_HALFORC ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_HUMAN ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_MAGICAL_BEAST ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_MONSTROUS ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_ORC ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_OUTSIDER ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_REPTILIAN ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_SHAPECHANGER ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_UNDEAD ,oPC)) nCount++;
        if(GetHasFeat(FEAT_FAVORED_ENEMY_VERMIN ,oPC)) nCount++;
}
        