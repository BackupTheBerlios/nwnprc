//::///////////////////////////////////////////////
//:: Name      
//:: FileName  sp_.nss
//:://////////////////////////////////////////////
/**@file Prismatic Sphere
Abjuration
Level: Protection 9, Sor/Wiz 9, Sun 9 
Components: V 
Range: 10 ft. 
Effect: 10-ft.-radius sphere centered on you

This spell functions like prismatic wall, except you
conjure up an immobile, opaque globe of shimmering, 
multicolored light that surrounds you and protects
you from all forms of attack. The sphere flashes in
all colors of the visible spectrum.

The sphere�s blindness effect on creatures with less 
than 8 HD lasts 2d4x10 minutes.

You can pass into and out of the prismatic sphere and
remain near it without harm. However, when you�re 
inside it, the sphere blocks any attempt to project 
something through the sphere (including spells). Other
creatures that attempt to attack you or pass through 
suffer the effects of each color, one at a time.

Typically, only the upper hemisphere of the globe will
exist, since you are at the center of the sphere, so 
the lower half is usually excluded by the floor surface
you are standing on.

The colors of the sphere have the same effects as the
colors of a prismatic wall.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void main()
{
        object oTarget = GetExitingObject();
        
        //Passing out of the sphere
        DeleteLocalInt(oTarget, "PRC_INSIDE_PRISMATIC_SPHERE");
}