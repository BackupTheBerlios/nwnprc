/*
   =============================================
   PENTAGRAMS & SUMMONING CIRCLES          v1.30
   =============================================
   gaoneng                      January 17, 2005
   #include "inc_draw"

   last updated on February 8, 2005

   Draw geometric forms using a variety of media
   =============================================

   Edited on March 11, 2005 by Ornedan
   - Made all the functions that create placeables
     store references to created objects on a
     store-object that is then returned.
   - The object returned is to be used for garbage
     collection by calling DeleteVFXConstruct
     with it as parameter.
   - Added function DeleteVFXConstruct that
     takes an object returned by one of the
     Place* or Beam* functions.
     It sets all the objects referenced by the
     given store object as destroyable and
     calls DestroyObject on them. Then it does
     the same for itself.
*/

/*
   =============================================
   FUNCTIONS DECLARATION
   =============================================
*/
// Draws a circle around lCenter
// =============================
// nDurationType = DURATION_TYPE_* constant
// nVFX = the VFX_* constant to use.
// lCenter = the location of the center.
// fRadius = radius of circle in meters. (1 tile = 10.0m X 10.0m)
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the circle lasts before fading.         DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more effects are
//              generated and the closer they are to each other.   DEFAULT : 90
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the circle.              DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
void DrawCircle(int nDurationType, int nVFX, location lCenter, float fRadius, float fDuration=0.0f, int nFrequency=90, float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z");

// Draws a spiral around lCenter
// =============================
// nDurationType = DURATION_TYPE_* constant
// nVFX = the VFX_* constant to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of spiral in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of spiral in meters.                DEFAULT : 0.0
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the spiral lasts before fading.         DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more effects are
//              generated and the closer they are to each other.   DEFAULT : 90
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the spiral.              DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
void DrawSpiral(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fDuration=0.0f, int nFrequency=90, float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z");

// Draws a spring around lCenter
// =============================
// nDurationType = DURATION_TYPE_* constant
// nVFX = the VFX_* constant to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of spring in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of spring in meters.                DEFAULT : 0.0
// fHeightStart = starting height of the spring in meters.        DEFAULT : 0.0
// fHeightEnd = ending height of the spring in meters.            DEFAULT : 5.0
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the spring lasts before fading.         DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more effects are
//              generated and the closer they are to each other.   DEFAULT : 90
// fRev = number of revolutions.                                  DEFAULT : 5.0
// fTime = time in seconds taken to draw the spring.              DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
void DrawSpring(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, float fDuration=0.0f, int nFrequency=90, float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z");

// Draws a line towards lCenter
// ============================
// nDurationType = DURATION_TYPE_* constant
// nVFX = the VFX_* constant to use.
// lCenter = the location of the center.
// fLength = length of line in meters. (1 tile = 10.0m X 10.0m)
// fDirection = direction of line respective to normal.           DEFAULT : 0.0
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the spring lasts before fading.         DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more effects are
//              generated and the closer they are to each other.   DEFAULT : 90
// fTime = time in seconds taken to draw the line.                DEFAULT : 6.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
void DrawLineToCenter(int nDurationType, int nVFX, location lCenter, float fLength, float fDirection=0.0f, float fDuration=0.0f, int nFrequency=90, float fTime=6.0f, string sAxis="z");

// Draws a line from lCenter
// =========================
// nDurationType = DURATION_TYPE_* constant
// nVFX = the VFX_* constant to use.
// lCenter = the location of the center.
// fLength = length of line in meters. (1 tile = 10.0m X 10.0m)
// fDirection = direction of line respective to normal.           DEFAULT : 0.0
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the spring lasts before fading.         DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more effects are
//              generated and the closer they are to each other.   DEFAULT : 90
// fTime = time in seconds taken to draw the line.                DEFAULT : 6.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
void DrawLineFromCenter(int nDurationType, int nVFX, location lCenter, float fLength, float fDirection=0.0f, float fDuration=0.0f, int nFrequency=90, float fTime=6.0f, string sAxis="z");

// Draws a polygonal spring around lCenter
// =======================================
// nDurationType = DURATION_TYPE_* constant
// nVFX = the VFX_* constant to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of spring in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of spring in meters.                DEFAULT : 0.0
// fHeightStart = starting height of the spring in meters.        DEFAULT : 0.0
// fHeightEnd = ending height of the spring in meters.            DEFAULT : 5.0
// nSides = number of sides. nSides < 3 will default to 3.          DEFAULT : 3
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the spring lasts before fading.         DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more effects are
//              generated and the closer they are to each other.   DEFAULT : 90
// fRev = number of revolutions.                                  DEFAULT : 5.0
// fTime = time in seconds taken to draw the polygon.             DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
void DrawPolygonalSpring(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nSides=3, float fDuration=0.0f, int nFrequency=90, float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z");

// Draws a polygonal spiral around lCenter
// =======================================
// nDurationType = DURATION_TYPE_* constant
// nVFX = the VFX_* constant to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of spiral in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of spiral in meters.                DEFAULT : 0.0
// nSides = number of sides. nSides < 3 will default to 3.          DEFAULT : 3
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the spiral lasts before fading.         DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more effects are
//              generated and the closer they are to each other.   DEFAULT : 90
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the polygon.             DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
void DrawPolygonalSpiral(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, int nSides=3, float fDuration=0.0f, int nFrequency=90, float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z");

// Draws a polygon around lCenter
// ==============================
// nDurationType = DURATION_TYPE_* constant
// nVFX = the VFX_* constant to use.
// lCenter = the location of the center.
// fRadius = radius of polygon in meters. (1 tile = 10.0m X 10.0m)
// nSides = number of sides. nSides < 3 will default to 3.          DEFAULT : 3
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the polygon lasts before fading.        DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more effects are
//              generated and the closer they are to each other.   DEFAULT : 90
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the polygon.             DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
void DrawPolygon(int nDurationType, int nVFX, location lCenter, float fRadius, int nSides=3, float fDuration=0.0f, int nFrequency=90, float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z");

// Draws a pentacle (five-pointed star) around lCenter
// ===================================================
// nDurationType = DURATION_TYPE_* constant
// nVFX = the VFX_* constant to use.
// lCenter = the location of the center.
// fRadius = radius of pentacle in meters. (1 tile = 10.0m X 10.0m)
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the pentacle lasts before fading.       DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more effects are
//              generated and the closer they are to each other.   DEFAULT : 90
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the pentacle.            DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
void DrawPentacle(int nDurationType, int nVFX, location lCenter, float fRadius, float fDuration=0.0f, int nFrequency=90, float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z");

// Draws a pentaclic spiral around lCenter
// =======================================
// nDurationType = DURATION_TYPE_* constant
// nVFX = the VFX_* constant to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of spiral in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of spiral in meters.                DEFAULT : 0.0
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the pentacle lasts before fading.       DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more effects are
//              generated and the closer they are to each other.   DEFAULT : 90
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the pentacle.            DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
void DrawPentaclicSpiral(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fDuration=0.0f, int nFrequency=90, float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z");

// Draws a pentaclic spring around lCenter
// ===================================================
// nDurationType = DURATION_TYPE_* constant
// nVFX = the VFX_* constant to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of spring in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of spring in meters.                DEFAULT : 0.0
// fHeightStart = starting height of the spring in meters.        DEFAULT : 0.0
// fHeightEnd = ending height of the spring in meters.            DEFAULT : 5.0
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the pentacle lasts before fading.       DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more effects are
//              generated and the closer they are to each other.   DEFAULT : 90
// fRev = number of revolutions.                                  DEFAULT : 5.0
// fTime = time in seconds taken to draw the pentacle.            DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
void DrawPentaclicSpring(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, float fDuration=0.0f, int nFrequency=90, float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z");

// Draws a hemisphere around lCenter
// =================================
// nDurationType = DURATION_TYPE_* constant
// nVFX = the VFX_* constant to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of sphere in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of sphere in meters.                DEFAULT : 0.0
// fHeightStart = starting height of sphere in meters.            DEFAULT : 0.0
// fHeightEnd = ending height of sphere in meters.                DEFAULT : 5.0
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the sphere lasts before fading.         DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more effects are
//              generated and the closer they are to each other.   DEFAULT : 90
// fRev = number of revolutions.                                  DEFAULT : 5.0
// fTime = time in seconds taken to draw the sphere.              DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the central/normal axis.             DEFAULT : "z"
void DrawHemisphere(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, float fDuration=0.0f, int nFrequency=90, float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z");

// Draws a perfect sphere around lCenter
// =====================================
// nDurationType = DURATION_TYPE_* constant
// nVFX = the VFX_* constant to use.
// lCenter = the location of the center.
// fRadius = radius of sphere in meters. (1 tile = 10.0m X 10.0m)
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the sphere lasts before fading.         DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more effects are
//              generated and the closer they are to each other.   DEFAULT : 90
// fRev = number of revolutions.                                  DEFAULT : 5.0
// fTime = time in seconds taken to draw the sphere.              DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the central/normal axis.             DEFAULT : "z"
void DrawSphere(int nDurationType, int nVFX, location lCenter, float fRadius, float fDuration=0.0f, int nFrequency=90, float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z");

// Draws a polygonal hemisphere around lCenter
// ===========================================
// nDurationType = DURATION_TYPE_* constant
// nVFX = the VFX_* constant to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of sphere in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of sphere in meters.                DEFAULT : 0.0
// fHeightStart = starting height of sphere in meters.            DEFAULT : 0.0
// fHeightEnd = ending height of sphere in meters.                DEFAULT : 5.0
// nSides = number of sides. nSides < 3 will default to 3.          DEFAULT : 3
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the sphere lasts before fading.         DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more effects are
//              generated and the closer they are to each other.   DEFAULT : 90
// fRev = number of revolutions.                                  DEFAULT : 5.0
// fTime = time in seconds taken to draw the sphere.              DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the central/normal axis.             DEFAULT : "z"
void DrawPolygonalHemisphere(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nSides=3, float fDuration=0.0f, int nFrequency=90, float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z");

// Draws a toroidal spring around lCenter
// ======================================
// nDurationType = DURATION_TYPE_* constant
// nVFX = the VFX_* constant to use.
// lCenter = the location of the center.
// fRadiusStartOuter = starting outer radius of the torus in meters.
// fRadiusStartInner = starting inner radius of the torus in meters.
// fRadiusEndOuter = ending outer radius of the torus in meters.  DEFAULT : 0.0
// fRadiusEndInner = ending inner radius of the torus in meters.  DEFAULT : 0.0
// fHeightStart = starting height of the spring in meters.        DEFAULT : 0.0
// fHeightEnd = ending height of the spring in meters.            DEFAULT : 5.0
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the spring lasts before fading.         DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more effects are
//              generated and the closer they are to each other.   DEFAULT : 90
// fLoopsPerRev = number of loops per revolution.                DEFAULT : 36.0
// fRev = number of revolutions.                                  DEFAULT : 5.0
// fTime = time in seconds taken to draw the spring.              DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
void DrawToroidalSpring(int nDurationType, int nVFX, location lCenter, float fRadiusStartOuter, float fRadiusStartInner, float fRadiusEndOuter=0.0f, float fRadiusEndInner=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, float fDuration=0.0f, int nFrequency=90, float fLoopsPerRev=36.0f, float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z");

// Draws a toroidal spiral around lCenter
// ======================================
// nDurationType = DURATION_TYPE_* constant
// nVFX = the VFX_* constant to use.
// lCenter = the location of the center.
// fRadiusStartOuter = starting outer radius of the torus in meters.
// fRadiusStartInner = starting inner radius of the torus in meters.
// fRadiusEndOuter = ending outer radius of the torus in meters.  DEFAULT : 0.0
// fRadiusEndInner = ending inner radius of the torus in meters.  DEFAULT : 0.0
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the spring lasts before fading.         DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more effects are
//              generated and the closer they are to each other.   DEFAULT : 90
// fLoopsPerRev = number of loops per revolution.                DEFAULT : 36.0
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the spiral.              DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
void DrawToroidalSpiral(int nDurationType, int nVFX, location lCenter, float fRadiusStartOuter, float fRadiusStartInner, float fRadiusEndOuter=0.0f, float fRadiusEndInner=0.0f, float fDuration=0.0f, int nFrequency=90, float fLoopsPerRev=36.0f, float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z");

// Draws a standard torus around lCenter
// =====================================
// nDurationType = DURATION_TYPE_* constant
// nVFX = the VFX_* constant to use.
// lCenter = the location of the center.
// fRadiusOuter = outer radius of the torus in meters.
// fRadiusInner = inner radius of the torus in meters.
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the spring lasts before fading.         DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more effects are
//              generated and the closer they are to each other.   DEFAULT : 90
// fLoopsPerRev = number of loops per revolution.                DEFAULT : 36.0
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the spring.              DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
void DrawTorus(int nDurationType, int nVFX, location lCenter, float fRadiusOuter, float fRadiusInner, float fDuration=0.0f, int nFrequency=90, float fLoopsPerRev=36.0f, float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z");

// Places a circle around lCenter
// ==============================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fRadius = radius of circle in meters. (1 tile = 10.0m X 10.0m)
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the circle.             DEFAULT : 12.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlaceCircle(string sTemplate, location lCenter, float fRadius, int nFrequency=60, float fRev=1.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Places a spiral around lCenter
// ==============================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of spiral in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of spiral in meters.                DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the spiral.             DEFAULT : 12.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlaceSpiral(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, int nFrequency=60, float fRev=1.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Places a spring around lCenter
// ==============================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of spring in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of spring in meters.                DEFAULT : 0.0
// fHeightStart = starting height of the spring in meters.        DEFAULT : 0.0
// fHeightEnd = ending height of the spring in meters.            DEFAULT : 5.0
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fRev = number of revolutions.                                  DEFAULT : 5.0
// fTime = time in seconds taken to draw the spring.             DEFAULT : 12.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlaceSpring(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nFrequency=60, float fRev=5.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Places a line towards lCenter
// =============================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fLength = length of line in meters. (1 tile = 10.0m X 10.0m)
// fDirection = direction of line respective to normal.           DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fTime = time in seconds taken to draw the line.               DEFAULT : 12.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlaceLineToCenter(string sTemplate, location lCenter, float fLength, float fDirection=0.0f, int nFrequency=60, float fTime=12.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Places a line from lCenter
// ==========================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fLength = length of line in meters. (1 tile = 10.0m X 10.0m)
// fDirection = direction of line respective to normal.           DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fTime = time in seconds taken to draw the line.               DEFAULT : 12.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlaceLineFromCenter(string sTemplate, location lCenter, float fLength, float fDirection=0.0f, int nFrequency=60, float fTime=12.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Places a polygonal spring around lCenter
// ========================================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of spring in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of spring in meters.                DEFAULT : 0.0
// fHeightStart = starting height of the spring in meters.        DEFAULT : 0.0
// fHeightEnd = ending height of the spring in meters.            DEFAULT : 5.0
// nSides = number of sides. nSides < 3 will default to 3.          DEFAULT : 3
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fRev = number of revolutions.                                  DEFAULT : 5.0
// fTime = time in seconds taken to draw the polygon.            DEFAULT : 12.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlacePolygonalSpring(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nSides=3, int nFrequency=60, float fRev=5.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Places a polygonal spiral around lCenter
// ========================================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of spiral in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of spiral in meters.                DEFAULT : 0.0
// nSides = number of sides. nSides < 3 will default to 3.          DEFAULT : 3
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the polygon.            DEFAULT : 12.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlacePolygonalSpiral(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, int nSides=3, int nFrequency=60, float fRev=1.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Places a polygon around lCenter
// ===============================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fRadius = radius of polygon in meters. (1 tile = 10.0m X 10.0m)
// nSides = number of sides. nSides < 3 will default to 3.          DEFAULT : 3
// nFrequency = number of points, the higher the frequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the polygon.            DEFAULT : 12.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlacePolygon(string sTemplate, location lCenter, float fRadius, int nSides=3, int nFrequency=60, float fRev=1.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Places a pentacle (five-pointed star) around lCenter
// ====================================================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fRadius = radius of pentacle in meters. (1 tile = 10.0m X 10.0m)
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the pentacle.           DEFAULT : 12.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlacePentacle(string sTemplate, location lCenter, float fRadius, int nFrequency=60, float fRev=1.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Places a pentaclic spiral around lCenter
// ========================================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of spiral in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of spiral in meters.                DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the pentacle.           DEFAULT : 12.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlacePentaclicSpiral(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, int nFrequency=60, float fRev=1.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Places a pentaclic spring around lCenter
// ========================================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of spring in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of spring in meters.                DEFAULT : 0.0
// fHeightStart = starting height of the spring in meters.        DEFAULT : 0.0
// fHeightEnd = ending height of the spring in meters.            DEFAULT : 5.0
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fRev = number of revolutions.                                  DEFAULT : 5.0
// fTime = time in seconds taken to draw the pentacle.           DEFAULT : 12.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlacePentaclicSpring(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nFrequency=60, float fRev=5.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Places a hemisphere around lCenter
// ==================================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of sphere in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of sphere in meters.                DEFAULT : 0.0
// fHeightStart = starting height of the sphere in meters.        DEFAULT : 0.0
// fHeightEnd = ending height of the sphere in meters.            DEFAULT : 5.0
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fRev = number of revolutions.                                  DEFAULT : 5.0
// fTime = time in seconds taken to draw the sphere.             DEFAULT : 12.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the central/normal axis.             DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlaceHemisphere(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nFrequency=60, float fRev=5.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f, object oStore = OBJECT_INVALID);

// Places a perfect sphere around lCenter
// ======================================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fRadius = radius of sphere in meters. (1 tile = 10.0m X 10.0m)
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fRev = number of revolutions.                                  DEFAULT : 5.0
// fTime = time in seconds taken to draw the sphere.             DEFAULT : 12.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the central/normal axis.             DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlaceSphere(string sTemplate, location lCenter, float fRadius, int nFrequency=60, float fRev=5.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Places a polygonal hemisphere around lCenter
// ============================================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of sphere in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of sphere in meters.                DEFAULT : 0.0
// fHeightStart = starting height of the sphere in meters.        DEFAULT : 0.0
// fHeightEnd = ending height of the sphere in meters.            DEFAULT : 5.0
// nSides = number of sides. nSides < 3 will default to 3.          DEFAULT : 3
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fRev = number of revolutions.                                  DEFAULT : 5.0
// fTime = time in seconds taken to draw the sphere.             DEFAULT : 12.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the central/normal axis.             DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlacePolygonalHemisphere(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nSides=3, int nFrequency=60, float fRev=5.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Places a toroidal spring around lCenter
// =======================================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fRadiusStartOuter = starting outer radius of the torus in meters.
// fRadiusStartInner = starting inner radius of the torus in meters.
// fRadiusEndOuter = ending outer radius of the torus in meters.  DEFAULT : 0.0
// fRadiusEndInner = ending inner radius of the torus in meters.  DEFAULT : 0.0
// fHeightStart = starting height of the spring in meters.        DEFAULT : 0.0
// fHeightEnd = ending height of the spring in meters.            DEFAULT : 5.0
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fLoopsPerRev = number of loops per revolution.                DEFAULT : 36.0
// fRev = number of revolutions.                                  DEFAULT : 5.0
// fTime = time in seconds taken to draw the spring.             DEFAULT : 12.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlaceToroidalSpring(string sTemplate, location lCenter, float fRadiusStartOuter, float fRadiusStartInner, float fRadiusEndOuter=0.0f, float fRadiusEndInner=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nFrequency=60, float fLoopsPerRev=36.0f, float fRev=5.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Places a toroidal spiral around lCenter
// =======================================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fRadiusStartOuter = starting outer radius of the torus in meters.
// fRadiusStartInner = starting inner radius of the torus in meters.
// fRadiusEndOuter = ending outer radius of the torus in meters.  DEFAULT : 0.0
// fRadiusEndInner = ending inner radius of the torus in meters.  DEFAULT : 0.0
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fLoopsPerRev = number of loops per revolution.                DEFAULT : 36.0
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the spring.             DEFAULT : 12.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlaceToroidalSpiral(string sTemplate, location lCenter, float fRadiusStartOuter, float fRadiusStartInner, float fRadiusEndOuter=0.0f, float fRadiusEndInner=0.0f, int nFrequency=60, float fLoopsPerRev=36.0f, float fRev=1.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Places a standard torus around lCenter
// ======================================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fRadiusOuter = outer radius of the torus in meters.
// fRadiusInner = inner radius of the torus in meters.
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fLoopsPerRev = number of loops per revolution.                DEFAULT : 36.0
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the spring.             DEFAULT : 12.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlaceTorus(string sTemplate, location lCenter, float fRadiusOuter, float fRadiusInner, int nFrequency=60, float fLoopsPerRev=36.0f, float fRev=1.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Places a stella octangula above lCenter
// =======================================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fRadius = radius in meters. (1 tile = 10.0m X 10.0m)
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fTime = time in seconds taken to draw the pentacle.           DEFAULT : 12.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlaceStellaOctangula(string sTemplate, location lCenter, float fRadius, int nFrequency=60, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Places an icosahedron above lCenter
// ===================================
// sTemplate = blueprint resref of placeable to use.
// lCenter = the location of the center.
// fRadius = radius in meters. (1 tile = 10.0m X 10.0m)
// nFrequency = number of points, the higher nFrequency, the more placeables
//              are created and the closer they are to each other. DEFAULT : 60
// fTime = time in seconds taken to draw the pentacle.           DEFAULT : 12.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType = DURATION_TYPE_* constant if an additional visual effect is
//                 to be applied. Default invalid duration.        DEFAULT : -1
// nVFX = the VFX_* constant to use if an additional visual effect is to be
//        applied to the placeables. Default invalid effect.       DEFAULT : -1
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the effect lasts before fading.         DEFAULT : 0.0
// fWait = time in seconds to wait before applying visual effect. DEFAULT : 1.0
// fLifetime = if fLifetime is not 0.0, then this is time in seconds before the
//             placeables get destroyed.                          DEFAULT : 0.0
object PlaceIcosahedron(string sTemplate, location lCenter, float fRadius, int nFrequency=60, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f);

// Beams a polygonal hemisphere around lCenter
// ===========================================
// nDurationType = DURATION_TYPE_* constant.
// nVFX = the VFX_BEAM_* constant to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of sphere in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of sphere in meters.                DEFAULT : 0.0
// fHeightStart = starting height of the sphere in meters.        DEFAULT : 0.0
// fHeightEnd = ending height of the sphere in meters.            DEFAULT : 5.0
// nSides = number of sides.                                        DEFAULT : 3
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the beams lasts before fading.          DEFAULT : 0.0
// sTemplate = blueprint resref of placeable to use.       DEFAULT : "invisobj"
// fRev = number of revolutions.                                  DEFAULT : 5.0
// fTime = time in seconds taken to draw the sphere.              DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the central/normal axis.             DEFAULT : "z"
// nDurationType2 = DURATION_TYPE_* constant if an additional visual effect is
//                  to be applied. Default invalid duration.       DEFAULT : -1
// nVFX2 = the VFX_* constant to use if an additional visual effect is to be
//         applied to the placeable nodes. Default invalid effect. DEFAULT : -1
// fDuration2 = if nDurationType2 is DURATION_TYPE_TEMPORARY, this is the number
//              of seconds the effect lasts before fading.        DEFAULT : 0.0
// fWait2 = time in seconds to wait before applying nVFX2.        DEFAULT : 1.0
object BeamPolygonalHemisphere(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nSides=3, float fDuration=0.0f, string sTemplate="invisobj", float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f);

// Beams a polygonal spring around lCenter
// =======================================
// nDurationType = DURATION_TYPE_* constant.
// nVFX = the VFX_BEAM_* constant to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of spring in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of spring in meters.                DEFAULT : 0.0
// fHeightStart = starting height of the spring in meters.        DEFAULT : 0.0
// fHeightEnd = ending height of the spring in meters.            DEFAULT : 5.0
// nSides = number of sides.                                        DEFAULT : 3
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the beams lasts before fading.          DEFAULT : 0.0
// sTemplate = blueprint resref of placeable to use.       DEFAULT : "invisobj"
// fRev = number of revolutions.                                  DEFAULT : 5.0
// fTime = time in seconds taken to draw the polygon.             DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType2 = DURATION_TYPE_* constant if an additional visual effect is
//                  to be applied. Default invalid duration.       DEFAULT : -1
// nVFX2 = the VFX_* constant to use if an additional visual effect is to be
//         applied to the placeable nodes. Default invalid effect. DEFAULT : -1
// fDuration2 = if nDurationType2 is DURATION_TYPE_TEMPORARY, this is the number
//              of seconds the effect lasts before fading.        DEFAULT : 0.0
// fWait2 = time in seconds to wait before applying nVFX2.        DEFAULT : 1.0
object BeamPolygonalSpring(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nSides=3, float fDuration=0.0f, string sTemplate="invisobj", float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f);

// Beams a polygonal spiral around lCenter
// =======================================
// nDurationType = DURATION_TYPE_* constant.
// nVFX = the VFX_BEAM_* constant to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of spiral in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of spiral in meters.                DEFAULT : 0.0
// nSides = number of sides.                                        DEFAULT : 3
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the beams lasts before fading.          DEFAULT : 0.0
// sTemplate = blueprint resref of placeable to use.       DEFAULT : "invisobj"
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the polygon.             DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType2 = DURATION_TYPE_* constant if an additional visual effect is
//                  to be applied. Default invalid duration.       DEFAULT : -1
// nVFX2 = the VFX_* constant to use if an additional visual effect is to be
//         applied to the placeable nodes. Default invalid effect. DEFAULT : -1
// fDuration2 = if nDurationType2 is DURATION_TYPE_TEMPORARY, this is the number
//              of seconds the effect lasts before fading.        DEFAULT : 0.0
// fWait2 = time in seconds to wait before applying nVFX2.        DEFAULT : 1.0
object BeamPolygonalSpiral(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, int nSides=3, float fDuration=0.0f, string sTemplate="invisobj", float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f);

// Beams a polygon around lCenter
// ==============================
// nDurationType = DURATION_TYPE_* constant.
// nVFX = the VFX_BEAM_* constant to use.
// lCenter = the location of the center.
// fRadius = radius of polygon in meters. (1 tile = 10.0m X 10.0m)
// nSides = number of sides.                                        DEFAULT : 3
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the beams lasts before fading.          DEFAULT : 0.0
// sTemplate = blueprint resref of placeable to use.       DEFAULT : "invisobj"
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the polygon.             DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType2 = DURATION_TYPE_* constant if an additional visual effect is
//                  to be applied. Default invalid duration.       DEFAULT : -1
// nVFX2 = the VFX_* constant to use if an additional visual effect is to be
//         applied to the placeable nodes. Default invalid effect. DEFAULT : -1
// fDuration2 = if nDurationType2 is DURATION_TYPE_TEMPORARY, this is the number
//              of seconds the effect lasts before fading.        DEFAULT : 0.0
// fWait2 = time in seconds to wait before applying nVFX2.        DEFAULT : 1.0
object BeamPolygon(int nDurationType, int nVFX, location lCenter, float fRadius, int nSides=3, float fDuration=0.0f, string sTemplate="invisobj", float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f);

// Beams a pentacle around lCenter
// ===============================
// nDurationType = DURATION_TYPE_* constant.
// nVFX = the VFX_BEAM_* constant to use.
// lCenter = the location of the center.
// fRadius = radius of pentacle in meters. (1 tile = 10.0m X 10.0m)
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the beams lasts before fading.          DEFAULT : 0.0
// sTemplate = blueprint resref of placeable to use.       DEFAULT : "invisobj"
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the pentacle.            DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType2 = DURATION_TYPE_* constant if an additional visual effect is
//                  to be applied. Default invalid duration.       DEFAULT : -1
// nVFX2 = the VFX_* constant to use if an additional visual effect is to be
//         applied to the placeable nodes. Default invalid effect. DEFAULT : -1
// fDuration2 = if nDurationType2 is DURATION_TYPE_TEMPORARY, this is the number
//              of seconds the effect lasts before fading.        DEFAULT : 0.0
// fWait2 = time in seconds to wait before applying nVFX2.        DEFAULT : 1.0
object BeamPentacle(int nDurationType, int nVFX, location lCenter, float fRadius, float fDuration=0.0f, string sTemplate="invisobj", float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f);

// Beams a pentaclic spiral around lCenter
// =======================================
// nDurationType = DURATION_TYPE_* constant.
// nVFX = the VFX_BEAM_* constant to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of spiral in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of spiral in meters.                DEFAULT : 0.0
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the beams lasts before fading.          DEFAULT : 0.0
// sTemplate = blueprint resref of placeable to use.       DEFAULT : "invisobj"
// fRev = number of revolutions.                                  DEFAULT : 1.0
// fTime = time in seconds taken to draw the pentacle.            DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType2 = DURATION_TYPE_* constant if an additional visual effect is
//                  to be applied. Default invalid duration.       DEFAULT : -1
// nVFX2 = the VFX_* constant to use if an additional visual effect is to be
//         applied to the placeable nodes. Default invalid effect. DEFAULT : -1
// fDuration2 = if nDurationType2 is DURATION_TYPE_TEMPORARY, this is the number
//              of seconds the effect lasts before fading.        DEFAULT : 0.0
// fWait2 = time in seconds to wait before applying nVFX2.        DEFAULT : 1.0
object BeamPentaclicSpiral(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fDuration=0.0f, string sTemplate="invisobj", float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f);

// Beams a pentaclic spring around lCenter
// =======================================
// nDurationType = DURATION_TYPE_* constant.
// nVFX = the VFX_BEAM_* constant to use.
// lCenter = the location of the center.
// fRadiusStart = starting radius of spring in meters. (1 tile = 10.0m X 10.0m)
// fRadiusEnd = ending radius of spring in meters.                DEFAULT : 0.0
// fHeightStart = starting height of the spring in meters.        DEFAULT : 0.0
// fHeightEnd = ending height of the spring in meters.            DEFAULT : 5.0
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the beams lasts before fading.          DEFAULT : 0.0
// sTemplate = blueprint resref of placeable to use.       DEFAULT : "invisobj"
// fRev = number of revolutions.                                  DEFAULT : 5.0
// fTime = time in seconds taken to draw the pentacle.            DEFAULT : 6.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType2 = DURATION_TYPE_* constant if an additional visual effect is
//                  to be applied. Default invalid duration.       DEFAULT : -1
// nVFX2 = the VFX_* constant to use if an additional visual effect is to be
//         applied to the placeable nodes. Default invalid effect. DEFAULT : -1
// fDuration2 = if nDurationType2 is DURATION_TYPE_TEMPORARY, this is the number
//              of seconds the effect lasts before fading.        DEFAULT : 0.0
// fWait2 = time in seconds to wait before applying nVFX2.        DEFAULT : 1.0
object BeamPentaclicSpring(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, float fDuration=0.0f, string sTemplate="invisobj", float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f);

// Beams a line from lCenter
// =========================
// nDurationType = DURATION_TYPE_* constant.
// nVFX = the VFX_BEAM_* constant to use.
// lCenter = the location of the center.
// fLength = length of line in meters. (1 tile = 10.0m X 10.0m)
// fDirection = direction of line respective to normal.           DEFAULT : 0.0
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the beam lasts before fading.           DEFAULT : 0.0
// sTemplate = blueprint resref of placeable to use..      DEFAULT : "invisobj"
// fTime = time in seconds taken to draw the polygon.             DEFAULT : 6.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType2 = DURATION_TYPE_* constant if an additional visual effect is
//                  to be applied. Default invalid duration.       DEFAULT : -1
// nVFX2 = the VFX_* constant to use if an additional visual effect is to be
//         applied to the placeable nodes. Default invalid effect. DEFAULT : -1
// fDuration2 = if nDurationType2 is DURATION_TYPE_TEMPORARY, this is the number
//              of seconds the effect lasts before fading.        DEFAULT : 0.0
// fWait2 = time in seconds to wait before applying nVFX2.        DEFAULT : 1.0
object BeamLineFromCenter(int nDurationType, int nVFX, location lCenter, float fLength, float fDirection=0.0f, float fDuration=0.0f, string sTemplate="invisobj", float fTime=6.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f);

// Beams a line to lCenter
// =======================
// nDurationType = DURATION_TYPE_* constant.
// nVFX = the VFX_BEAM_* constant to use.
// lCenter = the location of the center.
// fLength = length of line in meters. (1 tile = 10.0m X 10.0m)
// fDirection = direction of line respective to normal.           DEFAULT : 0.0
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the beam lasts before fading.           DEFAULT : 0.0
// sTemplate = blueprint resref of placeable to use.       DEFAULT : "invisobj"
// fTime = time in seconds taken to draw the polygon.             DEFAULT : 6.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType2 = DURATION_TYPE_* constant if an additional visual effect is
//                  to be applied. Default invalid duration.       DEFAULT : -1
// nVFX2 = the VFX_* constant to use if an additional visual effect is to be
//         applied to the placeable nodes. Default invalid effect. DEFAULT : -1
// fDuration2 = if nDurationType2 is DURATION_TYPE_TEMPORARY, this is the number
//              of seconds the effect lasts before fading.        DEFAULT : 0.0
// fWait2 = time in seconds to wait before applying nVFX2.        DEFAULT : 1.0
object BeamLineToCenter(int nDurationType, int nVFX, location lCenter, float fLength, float fDirection=0.0f, float fDuration=0.0f, string sTemplate="invisobj", float fTime=6.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f);

// Beams a stella octangula above lCenter
// ======================================
// nDurationType = DURATION_TYPE_* constant.
// nVFX = the VFX_BEAM_* constant to use.
// lCenter = the location of the center.
// fRadius = radius in meters. (1 tile = 10.0m X 10.0m)
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the beams lasts before fading.          DEFAULT : 0.0
// sTemplate = blueprint resref of placeable to use.       DEFAULT : "invisobj"
// fTime = time in seconds taken to create the placeable nodes.   DEFAULT : 6.0
// fWait = time in seconds to wait before applying the beams.     DEFAULT : 1.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType2 = DURATION_TYPE_* constant if an additional visual effect is
//                  to be applied. Default invalid duration.       DEFAULT : -1
// nVFX2 = the VFX_* constant to use if an additional visual effect is to be
//         applied to the placeable nodes. Default invalid effect. DEFAULT : -1
// fDuration2 = if nDurationType2 is DURATION_TYPE_TEMPORARY, this is the number
//              of seconds the effect lasts before fading.        DEFAULT : 0.0
// fWait2 = time in seconds to wait before applying nVFX2.        DEFAULT : 1.0
object BeamStellaOctangula(int nDurationType, int nVFX, location lCenter, float fRadius, float fDuration=0.0f, string sTemplate="invisobj", float fTime=6.0f, float fWait=1.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f);

// Beams an icosahedron above lCenter
// ==================================
// nDurationType = DURATION_TYPE_* constant.
// nVFX = the VFX_BEAM_* constant to use.
// lCenter = the location of the center.
// fRadius = radius in meters. (1 tile = 10.0m X 10.0m)
// fDuration = if nDurationType is DURATION_TYPE_TEMPORARY, this is the number
//             of seconds the beams lasts before fading.          DEFAULT : 0.0
// sTemplate = blueprint resref of placeable to use.       DEFAULT : "invisobj"
// fTime = time in seconds taken to create the placeable nodes.   DEFAULT : 6.0
// fWait = time in seconds to wait before applying the beams.     DEFAULT : 1.0
// fRotate = the angle of rotation respective to normal.          DEFAULT : 0.0
// sAxis = ("x", "y" or "z") the normal axis.                     DEFAULT : "z"
// nDurationType2 = DURATION_TYPE_* constant if an additional visual effect is
//                  to be applied. Default invalid duration.       DEFAULT : -1
// nVFX2 = the VFX_* constant to use if an additional visual effect is to be
//         applied to the placeable nodes. Default invalid effect. DEFAULT : -1
// fDuration2 = if nDurationType2 is DURATION_TYPE_TEMPORARY, this is the number
//              of seconds the effect lasts before fading.        DEFAULT : 0.0
// fWait2 = time in seconds to wait before applying nVFX2.        DEFAULT : 1.0
object BeamIcosahedron(int nDurationType, int nVFX, location lCenter, float fRadius, float fDuration=0.0f, string sTemplate="invisobj", float fTime=6.0f, float fWait=1.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f);


// Destroys the vfx construct that was stored on oStore when created
// =================================================================
// oStore   object returned by either one of the Place*
//          or Beam* functions
void DeleteVFXConstruct(object oStore);

/*
   =============================================
   PRIVATE FUNCTIONS
   =============================================
   These are the private functions used either in constructing some of the
   shapes or for drawing some unreleased and unsupported complex forms. They
   are easy to use but too confusing to document, and I decided to not include
   them in the standard list. If you can read and understand these functions
   and want to use them, simply uncomment the lines.
*/
// Draws a straight line from vOne to vTwo
//void DrawLineFromVectorToVector(int nDurationType, int nVFX, object oArea, vector vOne, vector vTwo, float fDuration, int nFrequency, float fTime);

// Draws an inversed hemisphere, or a blackhole-like vortex
// NOT SUPPORTED ! USE AT YOUR OWN RISK
//void DrawNegativeHemisphere(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, float fDuration=0.0f, int nFrequency=90, float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z");

// Delayable CreateObject, automatically applies VFX if any
//void ActionCreateObject(string sTemplate, location lLocation, int nDurationType, int nVFX, float fDuration, float fWait);

// Places a straight line from vOne to vTwo, automatically applies VFX if any
//void PlaceLineFromVectorToVector(string sTemplate, object oArea, vector vOne, vector vTwo, int nFrequency, float fTime, int nDurationType, int nVFX, float fDuration, float fWait);

// Places an inversed hemisphere, or a blackhole-like vortex
// NOT SUPPORTED ! USE AT YOUR OWN RISK
//void PlaceNegativeHemisphere(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nFrequency=60, float fRev=5.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f);

// Delayable CreateObject, automatically sets created object as oBase's local object and applies VFX if any
//void ActionCreateLocalObject(string sTemplate, location lLocation, string sNumber, object oBase, int nDurationType, int nVFX, float fDuration, float fWait);

// Apply EffectBeam from oBase to its local object
//void ActionApplyBeamEffect(object oBase, string sNumber, int nDurationType, int nVFX, float fDuration);

// Apply EffectBeam between two of oBase's local objects
//void ActionApplyLocalBeamEffect(object oBase, string sNumber1, string sNumber2, int nDurationType, int nVFX, float fDuration);

/*
   =============================================
   FUNCTIONS DEFINITIONS
   =============================================
*/

/*
   =============================================
   DRAW* FUNCTIONS
   =============================================
*/

void DrawSpring(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, float fDuration=0.0f, int nFrequency=90, float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z")
{
   int i;
   if (nFrequency < 1) nFrequency = 90;
   if (fDuration<0.0) fDuration = 0.0;
   if (fTime<0.0) fTime = 6.0;
   float fTheta = 360.0*fRev/IntToFloat(nFrequency); // angle between each node
   float fDecay = (fRadiusStart - fRadiusEnd)/IntToFloat(nFrequency); // change in radius per node
   float fGrowth = (fHeightStart - fHeightEnd)/IntToFloat(nFrequency); // change in height per node
   float fDelay = fTime/IntToFloat(nFrequency);
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos;
   object oArea = GetAreaFromLocation(lCenter);
   location lPos;
   float f, x, y, z, fAngle;
   for (i=0; i<nFrequency; i++)
   {
      f = IntToFloat(i);
      fAngle = fTheta*f + fRotate;
      z = (fHeightStart-fGrowth*f);
      y = (fRadiusStart-fDecay*f)*sin(fAngle);
      x = (fRadiusStart-fDecay*f)*cos(fAngle);
      if (sAxis == "x")      vPos = vCenter + Vector(y, z, x);
      else if (sAxis == "y") vPos = vCenter + Vector(z, x, y);
      else                   vPos = vCenter + Vector(x, y, z);
      lPos = Location(oArea, vPos, 0.0);
      DelayCommand(f*fDelay, ApplyEffectAtLocation(nDurationType, EffectVisualEffect(nVFX), lPos, fDuration));
   }
}

void DrawSpiral(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fDuration=0.0f, int nFrequency=90, float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z")
{
   DrawSpring(nDurationType, nVFX, lCenter, fRadiusStart, fRadiusEnd, 0.0, 0.0, fDuration, nFrequency, fRev, fTime, fRotate, sAxis);
}

void DrawCircle(int nDurationType, int nVFX, location lCenter, float fRadius, float fDuration=0.0f, int nFrequency=90, float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z")
{
   DrawSpring(nDurationType, nVFX, lCenter, fRadius, fRadius, 0.0, 0.0, fDuration, nFrequency, fRev, fTime, fRotate, sAxis);
}

void DrawLineToCenter(int nDurationType, int nVFX, location lCenter, float fLength, float fDirection=0.0f, float fDuration=0.0f, int nFrequency=90, float fTime=6.0f, string sAxis="z")
{
   DrawSpring(nDurationType, nVFX, lCenter, fLength, 0.0, 0.0, 0.0, fDuration, nFrequency, 0.0, fTime, fDirection, sAxis);
}

void DrawLineFromCenter(int nDurationType, int nVFX, location lCenter, float fLength, float fDirection=0.0f, float fDuration=0.0f, int nFrequency=90, float fTime=6.0f, string sAxis="z")
{
   DrawSpring(nDurationType, nVFX, lCenter, 0.0, fLength, 0.0, 0.0, fDuration, nFrequency, 0.0, fTime, fDirection, sAxis);
}

void DrawLineFromVectorToVector(int nDurationType, int nVFX, object oArea, vector vOne, vector vTwo, float fDuration, int nFrequency, float fTime)
{
   int i;
   vector vResultant = vTwo - vOne;
   vector vUnit = VectorNormalize(vResultant);
   float fDelay = fTime/IntToFloat(nFrequency);
   float fLength = VectorMagnitude(vResultant);
   float fDelta = fLength/IntToFloat(nFrequency); // distance between each node
   vector vPos;
   location lPos;
   float f;
   for (i=0; i<nFrequency; i++)
   {
      f = IntToFloat(i);
      vPos = vOne + fDelta*f*vUnit;
      lPos = Location(oArea, vPos, 0.0);
      DelayCommand(f*fDelay, ApplyEffectAtLocation(nDurationType, EffectVisualEffect(nVFX), lPos, fDuration));
   }
}

void DrawPolygonalSpring(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nSides=5, float fDuration=0.0f, int nFrequency=90, float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z")
{
   int i;
   if (nSides<3) nSides = 3;
   if (nFrequency<1) nFrequency = 90;
   if (fDuration<0.0) fDuration = 0.0;
   if (fTime<0.0) fTime = 6.0;
   if (fRev==0.0) fRev = 5.0;
   float fEta = (fRev > 0.0) ? 360.0/IntToFloat(nSides) : -360.0/IntToFloat(nSides); // angle of segment
   float fSidesToDraw = (fRev > 0.0) ? fRev*IntToFloat(nSides) : -fRev*IntToFloat(nSides); // total number of sides to draw including revolutions as float value
   int nSidesToDraw = FloatToInt(fSidesToDraw); // total number of sides to draw including revolutions as int value
   int nFrequencyPerSide = FloatToInt(IntToFloat(nFrequency)/fSidesToDraw);
   float fDecay = (fRadiusStart - fRadiusEnd)/fSidesToDraw; // change in radius per side
   float fGrowth = (fHeightStart - fHeightEnd)/fSidesToDraw; // change in height per side
   float fDelayPerSide = fTime/fSidesToDraw;
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos1, vPos2;
   object oArea = GetAreaFromLocation(lCenter);
   float f, g, x1, y1, z1, fAngle1, x2, y2, z2, fAngle2;
   for (i=0; i<nSidesToDraw; i++)
   {
      f = IntToFloat(i);
      g = IntToFloat(i+1);
      fAngle1 = fEta*f + fRotate;
      fAngle2 = fEta*g + fRotate;
      z1 = (fHeightStart-fGrowth*f);
      z2 = (fHeightStart-fGrowth*g);
      y1 = (fRadiusStart-fDecay*f)*sin(fAngle1);
      y2 = (fRadiusStart-fDecay*g)*sin(fAngle2);
      x1 = (fRadiusStart-fDecay*f)*cos(fAngle1);
      x2 = (fRadiusStart-fDecay*g)*cos(fAngle2);
      if (sAxis == "x")
      {
         vPos1 = vCenter + Vector(y1, z1, x1);
         vPos2 = vCenter + Vector(y2, z2, x2);
      }
      else if (sAxis == "y")
      {
         vPos1 = vCenter + Vector(z1, x1, y1);
         vPos2 = vCenter + Vector(z2, x2, y2);
      }
      else
      {
         vPos1 = vCenter + Vector(x1, y1, z1);
         vPos2 = vCenter + Vector(x2, y2, z2);
      }
      DelayCommand(f*fDelayPerSide, DrawLineFromVectorToVector(nDurationType, nVFX, oArea, vPos1, vPos2, fDuration, nFrequencyPerSide, fDelayPerSide));
   }
}

void DrawPolygonalSpiral(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, int nSides=3, float fDuration=0.0f, int nFrequency=90, float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z")
{
   DrawPolygonalSpring(nDurationType, nVFX, lCenter, fRadiusStart, fRadiusEnd, 0.0, 0.0, nSides, fDuration, nFrequency, fRev, fTime, fRotate, sAxis);
}

void DrawPolygon(int nDurationType, int nVFX, location lCenter, float fRadius, int nSides=3, float fDuration=0.0f, int nFrequency=90, float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z")
{
   DrawPolygonalSpring(nDurationType, nVFX, lCenter, fRadius, fRadius, 0.0, 0.0, nSides, fDuration, nFrequency, fRev, fTime, fRotate, sAxis);
}

void DrawPentaclicSpring(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, float fDuration=0.0f, int nFrequency=90, float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z")
{
   int i;
   if (nFrequency<1) nFrequency = 90;
   if (fDuration<0.0) fDuration = 0.0;
   if (fTime<0.0) fTime = 6.0;
   if (fRev==0.0) fRev = 5.0;
   int nSidesToDraw = (fRev > 0.0) ? FloatToInt(fRev*5.0) : -FloatToInt(fRev*5.0); // total number of sides to draw including revolutions
   int nFrequencyPerSide = nFrequency/nSidesToDraw;
   float fDecay = (fRadiusStart - fRadiusEnd)/IntToFloat(nSidesToDraw); // change in radius per node
   float fGrowth = (fHeightStart - fHeightEnd)/IntToFloat(nSidesToDraw); // change in height per node
   float fDelayPerSide = fTime/IntToFloat(nSidesToDraw);
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos1, vPos2;
   object oArea = GetAreaFromLocation(lCenter);
   float f, g, x1, y1, z1, fAngle1, x2, y2, z2, fAngle2;
   float fStarangle = (fRev > 0.0) ? 144.0 : -144.0;
   for (i=0; i<nSidesToDraw; i++)
   {
      f = IntToFloat(i);
      g = IntToFloat(i+1);
      fAngle1 = fStarangle*f + fRotate;
      fAngle2 = fStarangle*g + fRotate;
      z1 = (fHeightStart-fGrowth*f);
      z2 = (fHeightStart-fGrowth*g);
      y1 = (fRadiusStart-fDecay*f)*sin(fAngle1);
      y2 = (fRadiusStart-fDecay*g)*sin(fAngle2);
      x1 = (fRadiusStart-fDecay*f)*cos(fAngle1);
      x2 = (fRadiusStart-fDecay*g)*cos(fAngle2);
      if (sAxis == "x")
      {
         vPos1 = vCenter + Vector(y1, z1, x1);
         vPos2 = vCenter + Vector(y2, z2, x2);
      }
      else if (sAxis == "y")
      {
         vPos1 = vCenter + Vector(z1, x1, y1);
         vPos2 = vCenter + Vector(z2, x2, y2);
      }
      else
      {
         vPos1 = vCenter + Vector(x1, y1, z1);
         vPos2 = vCenter + Vector(x2, y2, z2);
      }
      DelayCommand(f*fDelayPerSide, DrawLineFromVectorToVector(nDurationType, nVFX, oArea, vPos1, vPos2, fDuration, nFrequencyPerSide, fDelayPerSide));
   }
}

void DrawPentaclicSpiral(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fDuration=0.0f, int nFrequency=90, float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z")
{
   DrawPentaclicSpring(nDurationType, nVFX, lCenter, fRadiusStart, fRadiusEnd, 0.0, 0.0, fDuration, nFrequency, fRev, fTime, fRotate, sAxis);
}

void DrawPentacle(int nDurationType, int nVFX, location lCenter, float fRadius, float fDuration=0.0f, int nFrequency=90, float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z")
{
   DrawPentaclicSpring(nDurationType, nVFX, lCenter, fRadius, fRadius, 0.0, 0.0, fDuration, nFrequency, fRev, fTime, fRotate, sAxis);
}

void DrawHemisphere(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, float fDuration=0.0f, int nFrequency=90, float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z")
{
   int i;
   if (nFrequency < 1) nFrequency = 90;
   if (fDuration<0.0) fDuration = 0.0;
   if (fTime<0.0) fTime = 6.0;
   if (fRev==0.0) fRev = 5.0;
   float fTheta = 360.0*fRev/IntToFloat(nFrequency); // angle between each node
   float fDelay = fTime/IntToFloat(nFrequency);
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos;
   object oArea = GetAreaFromLocation(lCenter);
   location lPos;
   float f, x, y, z, fAngle, fSphereRadius, fSphereAngle;
   float fEffectiveHeight = fHeightEnd - fHeightStart;
   for (i=0; i<nFrequency; i++)
   {
      f = IntToFloat(i);
      fAngle = fTheta*f + fRotate;
      fSphereAngle = fAngle*0.25/fRev;
      fSphereRadius = fRadiusStart*cos(fSphereAngle) + fRadiusEnd*sin(fSphereAngle);
      z = fEffectiveHeight*sin(fSphereAngle) + fHeightStart;
      y = fSphereRadius*sin(fAngle);
      x = fSphereRadius*cos(fAngle);
      if (sAxis == "x")      vPos = vCenter + Vector(y, z, x);
      else if (sAxis == "y") vPos = vCenter + Vector(z, x, y);
      else                   vPos = vCenter + Vector(x, y, z);
      lPos = Location(oArea, vPos, 0.0);
      DelayCommand(f*fDelay, ApplyEffectAtLocation(nDurationType, EffectVisualEffect(nVFX), lPos, fDuration));
   }
}

void DrawNegativeHemisphere(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, float fDuration=0.0f, int nFrequency=90, float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z")
{
   int i;
   if (nFrequency < 1) nFrequency = 90;
   if (fDuration<0.0) fDuration = 0.0;
   if (fTime<0.0) fTime = 6.0;
   if (fRev==0.0) fRev = 5.0;
   float fTheta = 360.0*fRev/IntToFloat(nFrequency); // angle between each node
   float fDelay = fTime/IntToFloat(nFrequency);
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos;
   object oArea = GetAreaFromLocation(lCenter);
   location lPos;
   float f, x, y, z, fAngle, fSphereRadius, fSphereAngle;
   float fEffectiveHeight = fHeightEnd - fHeightStart;
   float fRev2 = (fRev>0.0) ? fRev : -fRev ;
   for (i=0; i<nFrequency; i++)
   {
      f = IntToFloat(i);
      fAngle = fTheta*f + fRotate;
      fSphereAngle = fTheta*f*0.25/fRev2;
      fSphereRadius = fRadiusStart*acos(fSphereAngle/90.0)/90.0 + fRadiusEnd*asin(fSphereAngle/90.0)/90.0;
      z = fEffectiveHeight*sin(fSphereAngle) + fHeightStart;
      y = fSphereRadius*sin(fAngle);
      x = fSphereRadius*cos(fAngle);
      if (sAxis == "x")      vPos = vCenter + Vector(y, z, x);
      else if (sAxis == "y") vPos = vCenter + Vector(z, x, y);
      else                   vPos = vCenter + Vector(x, y, z);
      lPos = Location(oArea, vPos, 0.0);
      DelayCommand(f*fDelay, ApplyEffectAtLocation(nDurationType, EffectVisualEffect(nVFX), lPos, fDuration));
   }
}

void DrawSphere(int nDurationType, int nVFX, location lCenter, float fRadius, float fDuration=0.0f, int nFrequency=90, float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z")
{
   if (nFrequency < 1) nFrequency = 90;
   if (fDuration<0.0) fDuration = 0.0;
   if (fTime<0.0) fTime = 6.0;
   if (fRev==0.0) fRev = 5.0;
   DrawHemisphere(nDurationType, nVFX, lCenter, fRadius, 0.0, fRadius, 0.0, fDuration, nFrequency/2, fRev/2.0, fTime, fRotate, sAxis);
   DrawHemisphere(nDurationType, nVFX, lCenter, fRadius, 0.0, fRadius, 2.0*fRadius, fDuration, nFrequency/2, -fRev/2.0, fTime, fRotate, sAxis);
}

void DrawPolygonalHemisphere(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nSides=3, float fDuration=0.0f, int nFrequency=90, float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z")
{
   int i;
   if (nSides<3) nSides = 3;
   if (nFrequency < 1) nFrequency = 90;
   if (fDuration<0.0) fDuration = 0.0;
   if (fTime<0.0) fTime = 6.0;
   if (fRev==0.0) fRev = 5.0;
   float fEta = (fRev > 0.0) ? 360.0/IntToFloat(nSides) : -360.0/IntToFloat(nSides); // angle of segment
   float fSidesToDraw = (fRev > 0.0) ? fRev*IntToFloat(nSides) : -fRev*IntToFloat(nSides); // total number of sides to draw including revolutions as float value
   int nSidesToDraw = FloatToInt(fSidesToDraw); // total number of sides to draw including revolutions as int value
   int nFrequencyPerSide = FloatToInt(IntToFloat(nFrequency)/fSidesToDraw);
   float fDelayPerSide = fTime/fSidesToDraw;
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos1, vPos2;
   object oArea = GetAreaFromLocation(lCenter);
   float f, g, x1, y1, z1, fAngle1, x2, y2, z2, fAngle2, fSphereRadius1, fSphereAngle1, fSphereRadius2, fSphereAngle2;
   float fEffectiveHeight = fHeightEnd - fHeightStart;
   for (i=0; i<nSidesToDraw; i++)
   {
      f = IntToFloat(i);
      g = IntToFloat(i+1);
      fAngle1 = fEta*f + fRotate;
      fSphereAngle1 = fEta*f*0.25/fRev;
      fSphereRadius1 = fRadiusStart*cos(fSphereAngle1) + fRadiusEnd*sin(fSphereAngle1);
      fAngle2 = fEta*g + fRotate;
      fSphereAngle2 = fEta*g*0.25/fRev;
      fSphereRadius2 = fRadiusStart*cos(fSphereAngle2) + fRadiusEnd*sin(fSphereAngle2);
      z1 = fEffectiveHeight*sin(fSphereAngle1) + fHeightStart;
      z2 = fEffectiveHeight*sin(fSphereAngle2) + fHeightStart;
      y1 = fSphereRadius1*sin(fAngle1);
      y2 = fSphereRadius2*sin(fAngle2);
      x1 = fSphereRadius1*cos(fAngle1);
      x2 = fSphereRadius2*cos(fAngle2);
      if (sAxis == "x")
      {
         vPos1 = vCenter + Vector(y1, z1, x1);
         vPos2 = vCenter + Vector(y2, z2, x2);
      }
      else if (sAxis == "y")
      {
         vPos1 = vCenter + Vector(z1, x1, y1);
         vPos2 = vCenter + Vector(z2, x2, y2);
      }
      else
      {
         vPos1 = vCenter + Vector(x1, y1, z1);
         vPos2 = vCenter + Vector(x2, y2, z2);
      }
      DelayCommand(f*fDelayPerSide, DrawLineFromVectorToVector(nDurationType, nVFX, oArea, vPos1, vPos2, fDuration, nFrequencyPerSide, fDelayPerSide));
   }
}

void DrawToroidalSpring(int nDurationType, int nVFX, location lCenter, float fRadiusStartOuter, float fRadiusStartInner, float fRadiusEndOuter=0.0f, float fRadiusEndInner=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, float fDuration=0.0f, int nFrequency=90, float fLoopsPerRev=36.0f, float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z")
{
   int i;
   if (nFrequency < 1) nFrequency = 90;
   if (fDuration<0.0) fDuration = 0.0;
   if (fTime<0.0) fTime = 6.0;
   float fRadiusStart = (fRadiusStartOuter + fRadiusStartInner)*0.5;
   float fRadiusEnd = (fRadiusEndOuter + fRadiusEndInner)*0.5;
   float fToricRadiusStart = (fRadiusStartOuter - fRadiusStartInner)*0.5;
   float fToricRadiusEnd = (fRadiusEndOuter - fRadiusEndInner)*0.5;
   float fTheta = 360.0*fRev/IntToFloat(nFrequency); // angle between each node
   float fDecay = (fRadiusStart - fRadiusEnd)/IntToFloat(nFrequency); // change in radius per node
   float fGrowth = (fHeightStart - fHeightEnd)/IntToFloat(nFrequency); // change in height per node
   float fToricDecay = (fToricRadiusStart - fToricRadiusEnd)/IntToFloat(nFrequency); // change in radius of torus per node
   float fDelay = fTime/IntToFloat(nFrequency);
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos;
   object oArea = GetAreaFromLocation(lCenter);
   location lPos;
   float f, x, y, z, fAngle, fToricAngle, fToricRadius;
   for (i=0; i<nFrequency; i++)
   {
      f = IntToFloat(i);
      fAngle = fTheta*f + fRotate;
      fToricAngle = fLoopsPerRev*fAngle;
      fToricRadius = (fToricRadiusStart - fToricDecay*f);
      z = (fHeightStart-fGrowth*f) + fToricRadius*sin(fToricAngle);
      y = (fRadiusStart-fDecay*f)*sin(fAngle) + fToricRadius*cos(fToricAngle)*sin(fAngle);
      x = (fRadiusStart-fDecay*f)*cos(fAngle) + fToricRadius*cos(fToricAngle)*cos(fAngle);
      if (sAxis == "x")      vPos = vCenter + Vector(y, z, x);
      else if (sAxis == "y") vPos = vCenter + Vector(z, x, y);
      else                   vPos = vCenter + Vector(x, y, z);
      lPos = Location(oArea, vPos, 0.0);
      DelayCommand(f*fDelay, ApplyEffectAtLocation(nDurationType, EffectVisualEffect(nVFX), lPos, fDuration));
   }
}

void DrawToroidalSpiral(int nDurationType, int nVFX, location lCenter, float fRadiusStartOuter, float fRadiusStartInner, float fRadiusEndOuter=0.0f, float fRadiusEndInner=0.0f, float fDuration=0.0f, int nFrequency=90, float fLoopsPerRev=36.0f, float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z")
{
   DrawToroidalSpring(nDurationType, nVFX, lCenter, fRadiusStartOuter, fRadiusStartInner, fRadiusEndOuter, fRadiusEndInner, 0.0, 0.0, fDuration, nFrequency, fLoopsPerRev, fRev, fTime, fRotate, sAxis);
}

void DrawTorus(int nDurationType, int nVFX, location lCenter, float fRadiusOuter, float fRadiusInner, float fDuration=0.0f, int nFrequency=90, float fLoopsPerRev=36.0f, float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z")
{
   DrawToroidalSpring(nDurationType, nVFX, lCenter, fRadiusOuter, fRadiusInner, fRadiusOuter, fRadiusInner, 0.0, 0.0, fDuration, nFrequency, fLoopsPerRev, fRev, fTime, fRotate, sAxis);
}

/*
   =============================================
   PLACE* FUNCTIONS
   =============================================
*/

void ActionCreateObject(string sTemplate, location lLocation, int nDurationType, int nVFX, float fDuration, float fWait, float fLifetime,
                        object oStore) // Added by Ornedan.
{                               // PRIVATE FUNCTION : creates placeable and applies effect
   if(!GetIsObjectValid(oStore) && fLifetime <= 0.0) return; // Do not create if destruction has already been called and the placing is supposed to be permanent - Ornedan
   object oPlaceable = CreateObject(OBJECT_TYPE_PLACEABLE, sTemplate, lLocation);
   if (nDurationType >= 0 && nVFX >= 0) AssignCommand(oPlaceable, ActionDoCommand(DelayCommand(fWait, ApplyEffectToObject(nDurationType, EffectVisualEffect(nVFX), oPlaceable, fDuration))));
   if (fLifetime > 0.0) AssignCommand(oPlaceable, ActionDoCommand(DestroyObject(oPlaceable, fLifetime)));
   // Added by Ornedan
   int i = GetLocalInt(oStore, "NumStoredObjects") + 1;
   SetLocalInt(oStore, "NumStoredObjects", i);
   SetLocalObject(oStore, "StoredObject_" + IntToString(i), oPlaceable);
   // /Added by Ornedan
}

object PlaceSpring(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nFrequency=60, float fRev=5.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   int i;
   if (nFrequency < 1) nFrequency = 60;
   if (fDuration<0.0) fDuration = 0.0;
   if (fTime<0.0) fTime = 12.0;
   if (fLifetime<0.0) fLifetime = 0.0;
   if (fWait<1.0) fWait = 1.0;
   float fTheta = 360.0*fRev/IntToFloat(nFrequency); // angle between each node
   float fDecay = (fRadiusStart - fRadiusEnd)/IntToFloat(nFrequency); // change in radius per node
   float fGrowth = (fHeightStart - fHeightEnd)/IntToFloat(nFrequency); // change in height per node
   float fDelay = fTime/IntToFloat(nFrequency);
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos;
   object oArea = GetAreaFromLocation(lCenter);
   location lPos;
   float f, x, y, z, fAngle;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan
   for (i=0; i<nFrequency; i++)
   {
      f = IntToFloat(i);
      fAngle = fTheta*f + fRotate;
      z = (fHeightStart-fGrowth*f);
      y = (fRadiusStart-fDecay*f)*sin(fAngle);
      x = (fRadiusStart-fDecay*f)*cos(fAngle);
      if (sAxis == "x")      vPos = vCenter + Vector(y, z, x);
      else if (sAxis == "y") vPos = vCenter + Vector(z, x, y);
      else                   vPos = vCenter + Vector(x, y, z);
      lPos = Location(oArea, vPos, fAngle);
      DelayCommand(f*fDelay, ActionCreateObject(sTemplate, lPos, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore)); // Modified by Ornedan
   }
   
   return oStore; // Added by Ornedan
}

object PlaceSpiral(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, int nFrequency=60, float fRev=1.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   return PlaceSpring(sTemplate, lCenter, fRadiusStart, fRadiusEnd, 0.0, 0.0, nFrequency, fRev, fTime, fRotate, sAxis, nDurationType, nVFX, fDuration, fWait, fLifetime);
}

object PlaceCircle(string sTemplate, location lCenter, float fRadius, int nFrequency=60, float fRev=1.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   return PlaceSpring(sTemplate, lCenter, fRadius, fRadius, 0.0, 0.0, nFrequency, fRev, fTime, fRotate, sAxis, nDurationType, nVFX, fDuration, fWait, fLifetime);
}

object PlaceLineToCenter(string sTemplate, location lCenter, float fLength, float fDirection=0.0f, int nFrequency=60, float fTime=12.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   return PlaceSpring(sTemplate, lCenter, fLength, 0.0, 0.0, 0.0, nFrequency, 0.0, fTime, fDirection, sAxis, nDurationType, nVFX, fDuration, fWait, fLifetime);
}

object PlaceLineFromCenter(string sTemplate, location lCenter, float fLength, float fDirection=0.0f, int nFrequency=60, float fTime=12.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   return PlaceSpring(sTemplate, lCenter, 0.0, fLength, 0.0, 0.0, nFrequency, 0.0, fTime, fDirection, sAxis, nDurationType, nVFX, fDuration, fWait, fLifetime);
}

void PlaceLineFromVectorToVector(string sTemplate, object oArea, vector vOne, vector vTwo, int nFrequency, float fTime, int nDurationType, int nVFX, float fDuration, float fWait, float fLifetime,
                                 object oStore)// Added by Ornedan
{                                       // PRIVATE FUNCTION : Places a line from vOne to vTwo
   int i;                               // this is used for polygonal functions
   vector vResultant = vTwo - vOne;
   vector vUnit = VectorNormalize(vResultant);
   float fDelay = fTime/IntToFloat(nFrequency);
   float fLength = VectorMagnitude(vResultant);
   float fTheta = fLength/IntToFloat(nFrequency); // distance between each node
   float fAngle = VectorToAngle(vUnit);
   vector vPos;
   location lPos;
   float f;
   for (i=0; i<nFrequency; i++)
   {
      f = IntToFloat(i);
      vPos = vOne + fTheta*f*vUnit;
      lPos = Location(oArea, vPos, fAngle);
      DelayCommand(f*fDelay, ActionCreateObject(sTemplate, lPos, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore));
   }
}

object PlacePolygonalSpring(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nSides=3, int nFrequency=60, float fRev=5.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   int i;
   if (nSides<3) nSides = 3;
   if (nFrequency<1) nFrequency = 60;
   if (fDuration<0.0) fDuration = 0.0;
   if (fWait<1.0) fWait = 1.0;
   if (fTime<0.0) fTime = 12.0;
   if (fLifetime<0.0) fLifetime = 0.0;
   if (fRev==0.0) fRev = 5.0;
   float fEta = (fRev > 0.0) ? 360.0/IntToFloat(nSides) : -360.0/IntToFloat(nSides); // angle of segment
   float fSidesToDraw = (fRev > 0.0) ? fRev*IntToFloat(nSides) : -fRev*IntToFloat(nSides); // total number of sides to draw including revolutions as float value
   int nSidesToDraw = FloatToInt(fSidesToDraw); // total number of sides to draw including revolutions as int value
   int nFrequencyPerSide = FloatToInt(IntToFloat(nFrequency)/fSidesToDraw);
   float fDecay = (fRadiusStart - fRadiusEnd)/fSidesToDraw; // change in radius per side
   float fGrowth = (fHeightStart - fHeightEnd)/fSidesToDraw; // change in height per side
   float fDelayPerSide = fTime/fSidesToDraw;
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos1, vPos2;
   object oArea = GetAreaFromLocation(lCenter);
   float f, g, x1, y1, z1, fAngle1, x2, y2, z2, fAngle2;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan
   for (i=0; i<nSidesToDraw; i++)
   {
      f = IntToFloat(i);
      g = IntToFloat(i+1);
      fAngle1 = fEta*f + fRotate;
      fAngle2 = fEta*g + fRotate;
      z1 = (fHeightStart-fGrowth*f);
      z2 = (fHeightStart-fGrowth*g);
      y1 = (fRadiusStart-fDecay*f)*sin(fAngle1);
      y2 = (fRadiusStart-fDecay*g)*sin(fAngle2);
      x1 = (fRadiusStart-fDecay*f)*cos(fAngle1);
      x2 = (fRadiusStart-fDecay*g)*cos(fAngle2);
      if (sAxis == "x")
      {
         vPos1 = vCenter + Vector(y1, z1, x1);
         vPos2 = vCenter + Vector(y2, z2, x2);
      }
      else if (sAxis == "y")
      {
         vPos1 = vCenter + Vector(z1, x1, y1);
         vPos2 = vCenter + Vector(z2, x2, y2);
      }
      else
      {
         vPos1 = vCenter + Vector(x1, y1, z1);
         vPos2 = vCenter + Vector(x2, y2, z2);
      }
      DelayCommand(f*fDelayPerSide, PlaceLineFromVectorToVector(sTemplate, oArea, vPos1, vPos2, nFrequencyPerSide, fDelayPerSide, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore)); // Modified by Ornedan
   }
   
   return oStore; // Added by Ornedan
}

object PlacePolygonalSpiral(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, int nSides=3, int nFrequency=60, float fRev=1.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   return PlacePolygonalSpring(sTemplate, lCenter, fRadiusStart, fRadiusEnd, 0.0, 0.0, nSides, nFrequency, fRev, fTime, fRotate, sAxis, nDurationType, nVFX, fDuration, fWait, fLifetime);
}

object PlacePolygon(string sTemplate, location lCenter, float fRadius, int nSides=3, int nFrequency=60, float fRev=1.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   return PlacePolygonalSpring(sTemplate, lCenter, fRadius, fRadius, 0.0, 0.0, nSides, nFrequency, fRev, fTime, fRotate, sAxis, nDurationType, nVFX, fDuration, fWait, fLifetime);
}

object PlacePentaclicSpring(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nFrequency=60, float fRev=5.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   int i;
   if (nFrequency<1) nFrequency = 60;
   if (fDuration<0.0) fDuration = 0.0;
   if (fWait<1.0) fWait = 1.0;
   if (fTime<0.0) fTime = 12.0;
   if (fLifetime<0.0) fLifetime = 0.0;
   if (fRev==0.0) fRev = 5.0;
   int nSidesToDraw = (fRev > 0.0) ? FloatToInt(fRev*5.0) : -FloatToInt(fRev*5.0); // total number of sides to draw including revolutions
   int nFrequencyPerSide = FloatToInt(IntToFloat(nFrequency)/IntToFloat(nSidesToDraw));
   float fDecay = (fRadiusStart - fRadiusEnd)/IntToFloat(nSidesToDraw); // change in radius per side
   float fGrowth = (fHeightStart - fHeightEnd)/IntToFloat(nSidesToDraw); // change in height per side
   float fDelayPerSide = fTime/IntToFloat(nSidesToDraw);
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos1, vPos2;
   object oArea = GetAreaFromLocation(lCenter);
   float f, g, x1, y1, z1, fAngle1, x2, y2, z2, fAngle2;
   float fStarangle = (fRev > 0.0) ? 144.0 : -144.0;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan
   for (i=0; i<nSidesToDraw; i++)
   {
      f = IntToFloat(i);
      g = IntToFloat(i+1);
      fAngle1 = fStarangle*f + fRotate;
      fAngle2 = fStarangle*g + fRotate;
      z1 = (fHeightStart-fGrowth*f);
      z2 = (fHeightStart-fGrowth*g);
      y1 = (fRadiusStart-fDecay*f)*sin(fAngle1);
      y2 = (fRadiusStart-fDecay*g)*sin(fAngle2);
      x1 = (fRadiusStart-fDecay*f)*cos(fAngle1);
      x2 = (fRadiusStart-fDecay*g)*cos(fAngle2);
      if (sAxis == "x")
      {
         vPos1 = vCenter + Vector(y1, z1, x1);
         vPos2 = vCenter + Vector(y2, z2, x2);
      }
      else if (sAxis == "y")
      {
         vPos1 = vCenter + Vector(z1, x1, y1);
         vPos2 = vCenter + Vector(z2, x2, y2);
      }
      else
      {
         vPos1 = vCenter + Vector(x1, y1, z1);
         vPos2 = vCenter + Vector(x2, y2, z2);
      }
      DelayCommand(f*fDelayPerSide, PlaceLineFromVectorToVector(sTemplate, oArea, vPos1, vPos2, nFrequencyPerSide, fDelayPerSide, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore)); // Modified by Ornedan
   }
   
   return oStore; // Added by Ornedan
}

object PlacePentaclicSpiral(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, int nFrequency=60, float fRev=1.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   return PlacePentaclicSpring(sTemplate, lCenter, fRadiusStart, fRadiusEnd, 0.0, 0.0, nFrequency, fRev, fTime, fRotate, sAxis, nDurationType, nVFX, fDuration, fWait, fLifetime);
}

object PlacePentacle(string sTemplate, location lCenter, float fRadius, int nFrequency=60, float fRev=1.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   return PlacePentaclicSpring(sTemplate, lCenter, fRadius, fRadius, 0.0, 0.0, nFrequency, fRev, fTime, fRotate, sAxis, nDurationType, nVFX, fDuration, fWait, fLifetime);
}

object PlaceHemisphere(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nFrequency=60, float fRev=5.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f,
                                      object oStore = OBJECT_INVALID) // Added by Ornedan
{
   int i;
   if (nFrequency < 1) nFrequency = 60;
   if (fDuration<0.0) fDuration = 0.0;
   if (fTime<0.0) fTime = 12.0;
   if (fLifetime<0.0) fLifetime = 0.0;
   if (fRev==0.0) fRev = 5.0;
   float fTheta = 360.0*fRev/IntToFloat(nFrequency); // angle between each node
   float fDecay = (fRadiusStart - fRadiusEnd)/IntToFloat(nFrequency); // change in radius per node
   float fDelay = fTime/IntToFloat(nFrequency);
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos;
   object oArea = GetAreaFromLocation(lCenter);
   location lPos;
   float f, x, y, z, fAngle, fSphereRadius, fSphereAngle;
   float fEffectiveHeight = fHeightEnd - fHeightStart;
   oStore = oStore == OBJECT_INVALID ? CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter) : oStore; // Added by Ornedan
   for (i=0; i<nFrequency; i++)
   {
      f = IntToFloat(i);
      fAngle = fTheta*f + fRotate;
      fSphereAngle = fTheta*f*0.25/fRev;
      fSphereRadius = fRadiusStart*cos(fSphereAngle) + fRadiusEnd*sin(fSphereAngle);
      z = fEffectiveHeight*sin(fSphereAngle) + fHeightStart;
      y = fSphereRadius*sin(fAngle);
      x = fSphereRadius*cos(fAngle);
      if (sAxis == "x")      vPos = vCenter + Vector(y, z, x);
      else if (sAxis == "y") vPos = vCenter + Vector(z, x, y);
      else                   vPos = vCenter + Vector(x, y, z);
      lPos = Location(oArea, vPos, fAngle);
      DelayCommand(f*fDelay, ActionCreateObject(sTemplate, lPos, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore)); // Modified by Ornedan
   }
   
   return oStore; // Added by Ornedan
}

object PlaceNegativeHemisphere(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nFrequency=60, float fRev=5.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   int i;
   if (nFrequency < 1) nFrequency = 60;
   if (fDuration<0.0) fDuration = 0.0;
   if (fTime<0.0) fTime = 12.0;
   if (fLifetime<0.0) fLifetime = 0.0;
   if (fRev==0.0) fRev = 5.0;
   float fTheta = 360.0*fRev/IntToFloat(nFrequency); // angle between each node
   float fDecay = (fRadiusStart - fRadiusEnd)/IntToFloat(nFrequency); // change in radius per node
   float fDelay = fTime/IntToFloat(nFrequency);
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos;
   object oArea = GetAreaFromLocation(lCenter);
   location lPos;
   float f, x, y, z, fAngle, fSphereRadius, fSphereAngle;
   float fEffectiveHeight = fHeightEnd - fHeightStart;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan
   for (i=0; i<nFrequency; i++)
   {
      f = IntToFloat(i);
      fAngle = fTheta*f + fRotate;
      fSphereAngle = fAngle*0.25/fRev;
      fSphereRadius = fRadiusStart*acos(fSphereAngle/90.0)/90.0 + fRadiusEnd*asin(fSphereAngle/90.0)/90.0;
      z = fEffectiveHeight*sin(fSphereAngle) + fHeightStart;
      y = fSphereRadius*sin(fAngle);
      x = fSphereRadius*cos(fAngle);
      if (sAxis == "x")      vPos = vCenter + Vector(y, z, x);
      else if (sAxis == "y") vPos = vCenter + Vector(z, x, y);
      else                   vPos = vCenter + Vector(x, y, z);
      lPos = Location(oArea, vPos, fAngle);
      DelayCommand(f*fDelay, ActionCreateObject(sTemplate, lPos, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore)); // Modified by Ornedan
   }
   
   return oStore; // Added by Ornedan
}

object PlaceSphere(string sTemplate, location lCenter, float fRadius, int nFrequency=60, float fRev=5.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   if (nFrequency < 1) nFrequency = 60;
   if (fDuration<0.0) fDuration = 0.0;
   if (fTime<0.0) fTime = 12.0;
   if (fRev==0.0) fRev = 5.0;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan
   PlaceHemisphere(sTemplate, lCenter, fRadius, 0.0, fRadius, 0.0, nFrequency/2, fRev/2.0, fTime/2.0, fRotate, sAxis, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore); // Modified by Ornedan
   PlaceHemisphere(sTemplate, lCenter, fRadius, 0.0, fRadius, 2.0*fRadius, nFrequency/2, -fRev/2.0, fTime/2.0, fRotate, sAxis, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore); // Modified by Ornedan
   return oStore; // Added by Ornedan
}

object PlacePolygonalHemisphere(string sTemplate, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nSides=3, int nFrequency=60, float fRev=5.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   int i;
   if (nSides<3) nSides = 3;
   if (nFrequency < 1) nFrequency = 90;
   if (fDuration<0.0) fDuration = 0.0;
   if (fTime<0.0) fTime = 12.0;
   if (fLifetime<0.0) fLifetime = 0.0;
   if (fRev==0.0) fRev = 5.0;
   float fEta = (fRev > 0.0) ? 360.0/IntToFloat(nSides) : -360.0/IntToFloat(nSides); // angle of segment
   float fSidesToDraw = (fRev > 0.0) ? fRev*IntToFloat(nSides) : -fRev*IntToFloat(nSides); // total number of sides to draw including revolutions as float value
   int nSidesToDraw = FloatToInt(fSidesToDraw); // total number of sides to draw including revolutions as int value
   int nFrequencyPerSide = FloatToInt(IntToFloat(nFrequency)/fSidesToDraw);
   float fDelayPerSide = fTime/fSidesToDraw;
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos1, vPos2;
   object oArea = GetAreaFromLocation(lCenter);
   float f, g, x1, y1, z1, fAngle1, x2, y2, z2, fAngle2, fSphereRadius1, fSphereAngle1, fSphereRadius2, fSphereAngle2;
   float fEffectiveHeight = fHeightEnd - fHeightStart;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan
   for (i=0; i<nSidesToDraw; i++)
   {
      f = IntToFloat(i);
      g = IntToFloat(i+1);
      fAngle1 = fEta*f + fRotate;
      fSphereAngle1 = fEta*f*0.25/fRev;
      fSphereRadius1 = fRadiusStart*cos(fSphereAngle1) + fRadiusEnd*sin(fSphereAngle1);
      fAngle2 = fEta*g + fRotate;
      fSphereAngle2 = fEta*g*0.25/fRev;
      fSphereRadius2 = fRadiusStart*cos(fSphereAngle2) + fRadiusEnd*sin(fSphereAngle2);
      z1 = fEffectiveHeight*sin(fSphereAngle1) + fHeightStart;
      z2 = fEffectiveHeight*sin(fSphereAngle2) + fHeightStart;
      y1 = fSphereRadius1*sin(fAngle1);
      y2 = fSphereRadius2*sin(fAngle2);
      x1 = fSphereRadius1*cos(fAngle1);
      x2 = fSphereRadius2*cos(fAngle2);
      if (sAxis == "x")
      {
         vPos1 = vCenter + Vector(y1, z1, x1);
         vPos2 = vCenter + Vector(y2, z2, x2);
      }
      else if (sAxis == "y")
      {
         vPos1 = vCenter + Vector(z1, x1, y1);
         vPos2 = vCenter + Vector(z2, x2, y2);
      }
      else
      {
         vPos1 = vCenter + Vector(x1, y1, z1);
         vPos2 = vCenter + Vector(x2, y2, z2);
      }
      DelayCommand(f*fDelayPerSide, PlaceLineFromVectorToVector(sTemplate, oArea, vPos1, vPos2, nFrequencyPerSide, fDelayPerSide, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore)); // Modified by Ornedan
   }
   
   return oStore; // Added by Ornedan
}

object PlaceToroidalSpring(string sTemplate, location lCenter, float fRadiusStartOuter, float fRadiusStartInner, float fRadiusEndOuter=0.0f, float fRadiusEndInner=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nFrequency=60, float fLoopsPerRev=36.0f, float fRev=5.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   int i;
   if (nFrequency < 1) nFrequency = 60;
   if (fDuration<0.0) fDuration = 0.0;
   if (fWait<1.0) fWait = 1.0;
   if (fTime<0.0) fTime = 12.0;
   if (fLifetime<0.0) fLifetime = 0.0;
   float fRadiusStart = (fRadiusStartOuter + fRadiusStartInner)*0.5;
   float fRadiusEnd = (fRadiusEndOuter + fRadiusEndInner)*0.5;
   float fToricRadiusStart = (fRadiusStartOuter - fRadiusStartInner)*0.5;
   float fToricRadiusEnd = (fRadiusEndOuter - fRadiusEndInner)*0.5;
   float fTheta = 360.0*fRev/IntToFloat(nFrequency); // angle between each node
   float fDecay = (fRadiusStart - fRadiusEnd)/IntToFloat(nFrequency); // change in radius per node
   float fGrowth = (fHeightStart - fHeightEnd)/IntToFloat(nFrequency); // change in height per node
   float fToricDecay = (fToricRadiusStart - fToricRadiusEnd)/IntToFloat(nFrequency); // change in radius of torus per node
   float fDelay = fTime/IntToFloat(nFrequency);
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos;
   object oArea = GetAreaFromLocation(lCenter);
   location lPos;
   float f, x, y, z, fAngle, fToricAngle, fToricRadius;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan
   for (i=0; i<nFrequency; i++)
   {
      f = IntToFloat(i);
      fAngle = fTheta*f + fRotate;
      fToricAngle = fLoopsPerRev*fAngle;
      fToricRadius = (fToricRadiusStart - fToricDecay*f);
      z = (fHeightStart-fGrowth*f) + fToricRadius*sin(fToricAngle);
      y = (fRadiusStart-fDecay*f)*sin(fAngle) + fToricRadius*cos(fToricAngle)*sin(fAngle);
      x = (fRadiusStart-fDecay*f)*cos(fAngle) + fToricRadius*cos(fToricAngle)*cos(fAngle);
      if (sAxis == "x")      vPos = vCenter + Vector(y, z, x);
      else if (sAxis == "y") vPos = vCenter + Vector(z, x, y);
      else                   vPos = vCenter + Vector(x, y, z);
      lPos = Location(oArea, vPos, fAngle);
      DelayCommand(f*fDelay, ActionCreateObject(sTemplate, lPos, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore)); // Modified by Ornedan
   }
   
   return oStore; // Added by Ornedan
}

object PlaceToroidalSpiral(string sTemplate, location lCenter, float fRadiusStartOuter, float fRadiusStartInner, float fRadiusEndOuter=0.0f, float fRadiusEndInner=0.0f, int nFrequency=60, float fLoopsPerRev=36.0f, float fRev=1.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   return PlaceToroidalSpring(sTemplate, lCenter, fRadiusStartOuter, fRadiusStartInner, fRadiusEndOuter, fRadiusEndInner, 0.0, 0.0, nFrequency, fLoopsPerRev, fRev, fTime, fRotate, sAxis, nDurationType, nVFX, fDuration, fWait, fLifetime);
}

object PlaceTorus(string sTemplate, location lCenter, float fRadiusOuter, float fRadiusInner, int nFrequency=60, float fLoopsPerRev=36.0f, float fRev=1.0f, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   return PlaceToroidalSpring(sTemplate, lCenter, fRadiusOuter, fRadiusInner, fRadiusOuter, fRadiusInner, 0.0, 0.0, nFrequency, fLoopsPerRev, fRev, fTime, fRotate, sAxis, nDurationType, nVFX, fDuration, fWait, fLifetime);
}

object PlaceStellaOctangula(string sTemplate, location lCenter, float fRadius, int nFrequency=60, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   int i;
   if (fDuration<0.0) fDuration = 0.0;
   if (fWait<1.0) fWait = 1.0;
   if (fTime<0.0) fTime = 6.0;
   if (nFrequency<1) nFrequency = 60;
   if (fLifetime<0.0) fLifetime = 0.0;
//   if (fRadius<0.0) fRadius = -fRadius;
   vector vCenter = GetPositionFromLocation(lCenter);
   object oArea = GetAreaFromLocation(lCenter);
   float fSigma = fRadius*2.0/3.0;
   float fEpsilon = fSigma*4.0/3.0/cos(19.47122063449069136924599933997);
   int nFrequencyPerSide = nFrequency/12;
   float fDelayPerSide = fTime/12.0;
   float f, x1, y1, z1, fAngle1, g, x2, y2, z2, fAngle2;
   vector vPos1, vPos2, vTop;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan
   if (sAxis == "x")      vTop = vCenter + Vector(0.0, 3.0*fSigma, 0.0);
   else if (sAxis == "y") vTop = vCenter + Vector(3.0*fSigma, 0.0, 0.0);
   else                   vTop = vCenter + Vector(0.0, 0.0, 3.0*fSigma);

   for (i=0; i<6; i++)
   {
      f = IntToFloat(i);
      g = IntToFloat(i+1);
      if (i<3)
      {
         fAngle1 = fRotate + 120.0*f;
         fAngle2 = fRotate + 120.0*g;
         z1 = 2.0*fSigma;
         z2 = 2.0*fSigma;
      }
      else
      {
         fAngle1 = fRotate + 120.0*f + 60.0 ;
         fAngle2 = fRotate + 120.0*g + 60.0 ;
         z1 = fSigma;
         z2 = fSigma;
      }
      x1 = fEpsilon*cos(fAngle1);
      x2 = fEpsilon*cos(fAngle2);
      y1 = fEpsilon*sin(fAngle1);
      y2 = fEpsilon*sin(fAngle2);
      if (sAxis == "x")
      {
         vPos1 = vCenter + Vector(y1, z1, x1);
         vPos2 = vCenter + Vector(y2, z2, x2);
      }
      else if (sAxis == "y")
      {
         vPos1 = vCenter + Vector(z1, x1, y1);
         vPos2 = vCenter + Vector(z2, x2, y2);
      }
      else
      {
         vPos1 = vCenter + Vector(x1, y1, z1);
         vPos2 = vCenter + Vector(x2, y2, z2);
      }

      if (i<3) DelayCommand(fDelayPerSide*f, PlaceLineFromVectorToVector(sTemplate, oArea, vCenter, vPos1, nFrequencyPerSide, fDelayPerSide, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore)); // Modified by Ornedan
      else     DelayCommand(fDelayPerSide*(f+6.0), PlaceLineFromVectorToVector(sTemplate, oArea, vTop, vPos1, nFrequencyPerSide, fDelayPerSide, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore)); // Modified by Ornedan
      DelayCommand(fDelayPerSide*(f+3.0), PlaceLineFromVectorToVector(sTemplate, oArea, vPos1, vPos2, nFrequencyPerSide, fDelayPerSide, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore)); // Modified by Ornedan
   }
   
   return oStore; // Added by Ornedan
}

object PlaceIcosahedron(string sTemplate, location lCenter, float fRadius, int nFrequency=60, float fTime=12.0f, float fRotate=0.0f, string sAxis="z", int nDurationType=-1, int nVFX=-1, float fDuration=0.0f, float fWait=1.0f, float fLifetime=0.0f)
{
   int i;
   if (fDuration<0.0) fDuration = 0.0;
   if (fWait<1.0) fWait = 1.0;
   if (fTime<0.0) fTime = 6.0;
   if (nFrequency<1) nFrequency = 60;
   if (fLifetime<0.0) fLifetime = 0.0;
   vector vCenter = GetPositionFromLocation(lCenter);
   object oArea = GetAreaFromLocation(lCenter);
   float fLengthOfSide = fRadius*1.0514622242382672120513381696952;
   float fSigma1 = fLengthOfSide*0.52573111211913360602566908484783;
   float fSigma2 = fLengthOfSide*0.85065080835203993218154049706411;
   float fEpsilon = fLengthOfSide/1.1755705045849462583374119092781;
   int nFrequencyPerSide = nFrequency/30;
   float fDelayPerSide = fTime/30.0;
   float f, x1, y1, z1, fAngle1, g, x2, y2, z2, fAngle2;
   vector vPos1, vPos2, vTop;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan
   if (sAxis == "x")      vTop = vCenter + Vector(0.0, 2.0*fSigma1 + fSigma2, 0.0);
   else if (sAxis == "y") vTop = vCenter + Vector(2.0*fSigma1 + fSigma2, 0.0, 0.0);
   else                   vTop = vCenter + Vector(0.0, 0.0, 2.0*fSigma1 + fSigma2);

   for (i=0; i<20; i++)
   {
      f = IntToFloat(i);
      g = IntToFloat(i+1);
      if (i<5)
      {
         fAngle1 = fRotate + f*72.0;
         fAngle2 = fRotate + g*72.0;
         z1 = fSigma1;
         z2 = fSigma1;
      }
      else if (i<10)
      {
         fAngle1 = fRotate + f*72.0;
         fAngle2 = fRotate + f*72.0 + 36.0;
         z1 = fSigma1;
         z2 = fSigma1 + fSigma2;
      }
      else if (i<15)
      {
         fAngle1 = fRotate + f*72.0;
         fAngle2 = fRotate + f*72.0 - 36.0;
         z1 = fSigma1;
         z2 = fSigma1 + fSigma2;
      }
      else
      {
         fAngle1 = fRotate + f*72.0 + 36.0;
         fAngle2 = fRotate + g*72.0 + 36.0;
         z1 = fSigma1 + fSigma2;
         z2 = fSigma1 + fSigma2;
      }
      x1 = fEpsilon*cos(fAngle1);
      x2 = fEpsilon*cos(fAngle2);
      y1 = fEpsilon*sin(fAngle1);
      y2 = fEpsilon*sin(fAngle2);
      if (sAxis == "x")
      {
         vPos1 = vCenter + Vector(y1, z1, x1);
         vPos2 = vCenter + Vector(y2, z2, x2);
      }
      else if (sAxis == "y")
      {
         vPos1 = vCenter + Vector(z1, x1, y1);
         vPos2 = vCenter + Vector(z2, x2, y2);
      }
      else
      {
         vPos1 = vCenter + Vector(x1, y1, z1);
         vPos2 = vCenter + Vector(x2, y2, z2);
      }

      if (i<5)
      {
         DelayCommand(fDelayPerSide*f, PlaceLineFromVectorToVector(sTemplate, oArea, vCenter, vPos1, nFrequencyPerSide, fDelayPerSide, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore)); // Modified by Ornedan
         DelayCommand(fDelayPerSide*(f+5.0), PlaceLineFromVectorToVector(sTemplate, oArea, vPos1, vPos2, nFrequencyPerSide, fDelayPerSide, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore)); // Modified by Ornedan
      }
      else if (i<10)
      {
         DelayCommand(fDelayPerSide*(f+5.0), PlaceLineFromVectorToVector(sTemplate, oArea, vPos1, vPos2, nFrequencyPerSide, fDelayPerSide, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore)); // Modified by Ornedan
      }
      else if (i<15)
      {
         DelayCommand(fDelayPerSide*(f+5.0), PlaceLineFromVectorToVector(sTemplate, oArea, vPos2, vPos1, nFrequencyPerSide, fDelayPerSide, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore)); // Modified by Ornedan
      }
      else
      {
         DelayCommand(fDelayPerSide*(f+10.0), PlaceLineFromVectorToVector(sTemplate, oArea, vTop, vPos1, nFrequencyPerSide, fDelayPerSide, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore)); // Modified by Ornedan
         DelayCommand(fDelayPerSide*(f+5.0), PlaceLineFromVectorToVector(sTemplate, oArea, vPos1, vPos2, nFrequencyPerSide, fDelayPerSide, nDurationType, nVFX, fDuration, fWait, fLifetime, oStore)); // Modified by Ornedan
      }
   }
   
   return oStore; // Added by Ornedan
}


/*
   =============================================
   BEAM FUNCTIONS
   =============================================
*/

// Added by Ornedan //
object CreateAndStoreObject(object oStore, int nObjectType, string sTemplate, location lLocation, int bUseAppearAnimation = FALSE, string sNewTag = "")
{
    object oToStore = CreateObject(nObjectType, sTemplate, lLocation, bUseAppearAnimation, sNewTag);
    int i = GetLocalInt(oStore, "NumStoredObjects") + 1;
    SetLocalInt(oStore, "NumStoredObjects", i);
    SetLocalObject(oStore, "StoredObject_" + IntToString(i), oToStore);
    return oToStore;
}
// /Added by Ornedan //

object BeamPolygonalSpring(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nSides=3, float fDuration=0.0f, string sTemplate="invisobj", float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f)
{
   int i;
   if (nSides<3) nSides = 3;
   if (fDuration<0.0) fDuration = 0.0;
   if (fDuration2<0.0) fDuration2 = 0.0;
   if (fWait2<1.0) fWait2 = 1.0;
   if (fTime<0.0) fTime = 6.0;
   if (fRev==0.0) fRev = 5.0;
   float fEta = (fRev > 0.0) ? 360.0/IntToFloat(nSides) : -360.0/IntToFloat(nSides); // angle of segment
   float fSidesToDraw = (fRev > 0.0) ? fRev*IntToFloat(nSides) : -fRev*IntToFloat(nSides); // total number of sides to draw including revolutions as float value
   int nSidesToDraw = FloatToInt(fSidesToDraw); // total number of sides to draw including revolutions as int value
   float fDecay = (fRadiusStart - fRadiusEnd)/fSidesToDraw; // change in radius per side
   float fGrowth = (fHeightStart - fHeightEnd)/fSidesToDraw; // change in height per side
   float fDelayPerSide = fTime/fSidesToDraw;
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos1, vPos2;
   object oArea = GetAreaFromLocation(lCenter);
   float g, x1, y1, z1, x2, y2, z2, fAngle2;
   object oPos1, oPos2;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan

   z1 = fHeightStart;           // creates the first point
   y1 = fRadiusStart*sin(fRotate);
   x1 = fRadiusStart*cos(fRotate);
   if (sAxis == "x")      vPos1 = vCenter + Vector(y1, z1, x1);
   else if (sAxis == "y") vPos1 = vCenter + Vector(z1, x1, y1);
   else                   vPos1 = vCenter + Vector(x1, y1, z1);
   oPos1 = CreateAndStoreObject(oStore, OBJECT_TYPE_PLACEABLE, sTemplate, Location(oArea, vPos1, fRotate)); // Modified by Ornedan
   if (nDurationType2>=0 && nVFX>=0) DelayCommand(fWait2, ApplyEffectToObject(nDurationType2, EffectVisualEffect(nVFX2), oPos1, fDuration2));

   for (i=0; i<nSidesToDraw; i++)
   {
      g = IntToFloat(i+1);
      fAngle2 = fEta*g + fRotate;
      z2 = (fHeightStart-fGrowth*g);
      y2 = (fRadiusStart-fDecay*g)*sin(fAngle2);
      x2 = (fRadiusStart-fDecay*g)*cos(fAngle2);
      if (sAxis == "x")      vPos2 = vCenter + Vector(y2, z2, x2);
      else if (sAxis == "y") vPos2 = vCenter + Vector(z2, x2, y2);
      else                   vPos2 = vCenter + Vector(x2, y2, z2);
      oPos2 = CreateAndStoreObject(oStore, OBJECT_TYPE_PLACEABLE, sTemplate, Location(oArea, vPos2, fAngle2)); // Modified by Ornedan
      if (nDurationType2>=0 && nVFX2>=0) DelayCommand(fWait2, ApplyEffectToObject(nDurationType2, EffectVisualEffect(nVFX2), oPos2, fDuration2));
      DelayCommand(g*fDelayPerSide, ApplyEffectToObject(nDurationType, EffectBeam(nVFX, oPos1, BODY_NODE_CHEST), oPos2, fDuration));
      oPos1 = oPos2;
   }
   
   return oStore; // Added by Ornedan
}

object BeamPolygonalSpiral(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, int nSides=3, float fDuration=0.0f, string sTemplate="invisobj", float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f)
{
   return BeamPolygonalSpring(nDurationType, nVFX, lCenter, fRadiusStart, fRadiusEnd, 0.0, 0.0, nSides, fDuration, sTemplate, fRev, fTime, fRotate, sAxis, nDurationType2, nVFX2, fDuration2, fWait2);
}

object BeamPolygon(int nDurationType, int nVFX, location lCenter, float fRadius, int nSides=3, float fDuration=0.0f, string sTemplate="invisobj", float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f)
{
   int i;
   if (nSides<3) nSides = 3;
   if (fDuration<0.0) fDuration = 0.0;
   if (fDuration2<0.0) fDuration2 = 0.0;
   if (fWait2<1.0) fWait2 = 1.0;
   if (fTime<0.0) fTime = 6.0;
   if (fRev==0.0) fRev = 1.0;
   float fEta = (fRev > 0.0) ? 360.0/IntToFloat(nSides) : -360.0/IntToFloat(nSides); // angle of segment
   float fSidesToDraw = (fRev > 0.0) ? fRev*IntToFloat(nSides) : -fRev*IntToFloat(nSides); // total number of sides to draw including revolutions as float value
   int nSidesToDraw = FloatToInt(fSidesToDraw); // total number of sides to draw including revolutions as int value
   float fDelayPerSide = fTime/fSidesToDraw;
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos1, vPos2;
   object oArea = GetAreaFromLocation(lCenter);
   float g, x1, y1, x2, y2, fAngle2;
   object oPos0, oPos1, oPos2;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan

   y1 = fRadius*sin(fRotate);
   x1 = fRadius*cos(fRotate);
   if (sAxis == "x")      vPos1 = vCenter + Vector(y1, 0.0, x1);
   else if (sAxis == "y") vPos1 = vCenter + Vector(0.0, x1, y1);
   else                   vPos1 = vCenter + Vector(x1, y1, 0.0);
   oPos0 = CreateAndStoreObject(oStore, OBJECT_TYPE_PLACEABLE, sTemplate, Location(oArea, vPos1, fRotate)); // Modified by Ornedan
   if (nDurationType2>=0 && nVFX>=0) DelayCommand(fWait2, ApplyEffectToObject(nDurationType2, EffectVisualEffect(nVFX2), oPos0, fDuration2));

   oPos1 = oPos0;

   for (i=0; i<nSidesToDraw; i++)
   {
      g = IntToFloat(i+1);
      fAngle2 = fEta*g + fRotate;
      y2 = fRadius*sin(fAngle2);
      x2 = fRadius*cos(fAngle2);
      if (sAxis == "x")      vPos2 = vCenter + Vector(y2, 0.0, x2);
      else if (sAxis == "y") vPos2 = vCenter + Vector(0.0, x2, y2);
      else                   vPos2 = vCenter + Vector(x2, y2, 0.0);
      oPos2 = (i+1 == nSidesToDraw) ? oPos0 : CreateAndStoreObject(oStore, OBJECT_TYPE_PLACEABLE, sTemplate, Location(oArea, vPos2, fAngle2)); // Modified by Ornedan
      if (nDurationType2>=0 && nVFX>=0 && i+1<nSidesToDraw) DelayCommand(fWait2, ApplyEffectToObject(nDurationType2, EffectVisualEffect(nVFX2), oPos2, fDuration2));
      DelayCommand(g*fDelayPerSide, ApplyEffectToObject(nDurationType, EffectBeam(nVFX, oPos1, BODY_NODE_CHEST), oPos2, fDuration));
      oPos1 = oPos2;
   }
   
   return oStore; // Added by Ornedan
}

object BeamPentaclicSpring(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, float fDuration=0.0f, string sTemplate="invisobj", float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f)
{
   int i;
   if (fWait2<1.0) fWait2 = 1.0;
   if (fTime<0.0) fTime = 6.0;
   if (fRev==0.0) fRev = 5.0;
   if (fDuration<0.0) fDuration = 0.0;
   if (fDuration2<0.0) fDuration2 = 0.0;
   int nSidesToDraw = (fRev > 0.0) ? FloatToInt(fRev*5.0) : -FloatToInt(fRev*5.0); // total number of sides to draw including revolutions
   float fSidesToDraw = IntToFloat(nSidesToDraw); // total number of sides to draw including revolutions as float value
   float fDecay = (fRadiusStart - fRadiusEnd)/fSidesToDraw; // change in radius per side
   float fGrowth = (fHeightStart - fHeightEnd)/fSidesToDraw; // change in height per side
   float fDelayPerSide = fTime/fSidesToDraw;
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos1, vPos2;
   object oArea = GetAreaFromLocation(lCenter);
   float g, x1, y1, z1, x2, y2, z2, fAngle2;
   float fStarangle = (fRev > 0.0) ? 144.0 : -144.0;
   object oPos1, oPos2;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan

   y1 = fRadiusStart*sin(fRotate);    // creates the first point
   x1 = fRadiusStart*cos(fRotate);
   if (sAxis == "x")      vPos1 = vCenter + Vector(y1, fHeightStart, x1);
   else if (sAxis == "y") vPos1 = vCenter + Vector(fHeightStart, x1, y1);
   else                   vPos1 = vCenter + Vector(x1, y1, fHeightStart);
   oPos1 = CreateAndStoreObject(oStore, OBJECT_TYPE_PLACEABLE, sTemplate, Location(oArea, vPos1, fRotate)); // Modified by Ornedan
   if (nDurationType2>=0 && nVFX2>=0) DelayCommand(fWait2, ApplyEffectToObject(nDurationType2, EffectVisualEffect(nVFX2), oPos1, fDuration2));

   for (i=0; i<nSidesToDraw; i++)
   {
      g = IntToFloat(i+1);
      fAngle2 = fStarangle*g + fRotate;
      z2 = (fHeightStart-fGrowth*g);
      y2 = (fRadiusStart-fDecay*g)*sin(fAngle2);
      x2 = (fRadiusStart-fDecay*g)*cos(fAngle2);
      if (sAxis == "x")      vPos2 = vCenter + Vector(y2, z2, x2);
      else if (sAxis == "y") vPos2 = vCenter + Vector(z2, x2, y2);
      else                   vPos2 = vCenter + Vector(x2, y2, z2);
      oPos2 = CreateAndStoreObject(oStore, OBJECT_TYPE_PLACEABLE, sTemplate, Location(oArea, vPos2, fAngle2)); // Modified by Ornedan
      if (nDurationType2>=0 && nVFX2>=0) DelayCommand(fWait2, ApplyEffectToObject(nDurationType2, EffectVisualEffect(nVFX2), oPos2, fDuration2));
      DelayCommand(g*fDelayPerSide, ApplyEffectToObject(nDurationType, EffectBeam(nVFX, oPos1, BODY_NODE_CHEST), oPos2, fDuration));
      oPos1 = oPos2;
   }
   
   return oStore; // Added by Ornedan
}

object BeamPentaclicSpiral(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fDuration=0.0f, string sTemplate="invisobj", float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f)
{
   return BeamPentaclicSpring(nDurationType, nVFX, lCenter, fRadiusStart, fRadiusEnd, 0.0, 0.0, fDuration, sTemplate, fRev, fTime, fRotate, sAxis, nDurationType2, nVFX2, fDuration2, fWait2);
}

object BeamPentacle(int nDurationType, int nVFX, location lCenter, float fRadius, float fDuration=0.0f, string sTemplate="invisobj", float fRev=1.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f)
{
   int i;
   if (fWait2<1.0) fWait2 = 1.0;
   if (fTime<0.0) fTime = 6.0;
   if (fDuration<0.0) fDuration = 0.0;
   if (fDuration2<0.0) fDuration2 = 0.0;
   if (fRev==0.0) fRev = 1.0;
   int nSidesToDraw = (fRev > 0.0) ? FloatToInt(fRev*5.0) : -FloatToInt(fRev*5.0); // total number of sides to draw including revolutions
   float fDelayPerSide = fTime/IntToFloat(nSidesToDraw);
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos1, vPos2;
   object oArea = GetAreaFromLocation(lCenter);
   float g, x1, y1, x2, y2, fAngle2;
   float fStarangle = (fRev > 0.0) ? 144.0 : -144.0;
   object oPos0, oPos1, oPos2;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan

   y1 = fRadius*sin(fRotate);    // creates the first point
   x1 = fRadius*cos(fRotate);
   if (sAxis == "x")      vPos1 = vCenter + Vector(y1, 0.0, x1);
   else if (sAxis == "y") vPos1 = vCenter + Vector(0.0, x1, y1);
   else                   vPos1 = vCenter + Vector(x1, y1, 0.0);
   oPos0 = CreateAndStoreObject(oStore, OBJECT_TYPE_PLACEABLE, sTemplate, Location(oArea, vPos1, fRotate)); // Modified by Ornedan
   if (nDurationType2>=0 && nVFX>=0) DelayCommand(fWait2, ApplyEffectToObject(nDurationType2, EffectVisualEffect(nVFX2), oPos0, fDuration2));

   oPos1 = oPos0;

   for (i=0; i<nSidesToDraw; i++)
   {
      g = IntToFloat(i+1);
      fAngle2 = fStarangle*g + fRotate;
      y2 = fRadius*sin(fAngle2);
      x2 = fRadius*cos(fAngle2);
      if (sAxis == "x")      vPos2 = vCenter + Vector(y2, 0.0, x2);
      else if (sAxis == "y") vPos2 = vCenter + Vector(0.0, x2, y2);
      else                   vPos2 = vCenter + Vector(x2, y2, 0.0);
      oPos2 = (i+1==nSidesToDraw) ? oPos0 : CreateAndStoreObject(oStore, OBJECT_TYPE_PLACEABLE, sTemplate, Location(oArea, vPos2, fAngle2)); // links final point back to first point // Modified by Ornedan
      if (nDurationType2>=0 && nVFX>=0 && i+1<nSidesToDraw) DelayCommand(fWait2, ApplyEffectToObject(nDurationType2, EffectVisualEffect(nVFX2), oPos2, fDuration2));
      DelayCommand(g*fDelayPerSide, ApplyEffectToObject(nDurationType, EffectBeam(nVFX, oPos1, BODY_NODE_CHEST), oPos2, fDuration));
      oPos1 = oPos2;
   }
   
   return oStore; // Added by Ornedan
}

object BeamLineFromCenter(int nDurationType, int nVFX, location lCenter, float fLength, float fDirection=0.0f, float fDuration=0.0f, string sTemplate="invisobj", float fTime=6.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f)
{
   if (fWait2<1.0) fWait2 = 1.0;
   if (fTime<0.0) fTime = 6.0;
   if (fDuration<0.0) fDuration = 0.0;
   if (fDuration2<0.0) fDuration2 = 0.0;
   object oArea = GetAreaFromLocation(lCenter);
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos = fLength*AngleToVector(fDirection);
   vector vPos2;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan

   if (sAxis == "x")      vPos2 = vCenter + Vector(vPos.y, vPos.z, vPos.x);
   else if (sAxis == "y") vPos2 = vCenter + Vector(vPos.z, vPos.x, vPos.y);
   else                   vPos2 = vCenter + Vector(vPos.x, vPos.y, vPos.z);

   object oCenter = CreateAndStoreObject(oStore, OBJECT_TYPE_PLACEABLE, sTemplate, lCenter); // Modified by Ornedan
   object oPos2 = CreateAndStoreObject(oStore, OBJECT_TYPE_PLACEABLE, sTemplate, Location(oArea, vPos2, fDirection)); // Modified by Ornedan
   if (nDurationType2>=0 && nVFX>=0)
   {
      DelayCommand(fWait2, ApplyEffectToObject(nDurationType2, EffectVisualEffect(nVFX2), oCenter, fDuration2));
      DelayCommand(fWait2, ApplyEffectToObject(nDurationType2, EffectVisualEffect(nVFX2), oPos2, fDuration2));
   }
   DelayCommand(fTime, ApplyEffectToObject(nDurationType, EffectBeam(nVFX, oCenter, BODY_NODE_CHEST), oPos2, fDuration));
   
   return oStore; // Added by Ornedan
}

object BeamLineToCenter(int nDurationType, int nVFX, location lCenter, float fLength, float fDirection=0.0f, float fDuration=0.0f, string sTemplate="invisobj", float fTime=6.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f)
{
   if (fWait2<1.0) fWait2 = 1.0;
   if (fTime<0.0) fTime = 6.0;
   if (fDuration<0.0) fDuration = 0.0;
   if (fDuration2<0.0) fDuration2 = 0.0;
   object oArea = GetAreaFromLocation(lCenter);
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos = fLength*AngleToVector(fDirection);
   vector vPos2;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan

   if (sAxis == "x")      vPos2 = vCenter + Vector(vPos.y, vPos.z, vPos.x);
   else if (sAxis == "y") vPos2 = vCenter + Vector(vPos.z, vPos.x, vPos.y);
   else                   vPos2 = vCenter + Vector(vPos.x, vPos.y, vPos.z);

   object oCenter = CreateAndStoreObject(oStore, OBJECT_TYPE_PLACEABLE, sTemplate, lCenter); // Modified by Ornedan
   object oPos2 = CreateAndStoreObject(oStore, OBJECT_TYPE_PLACEABLE, sTemplate, Location(oArea, vPos2, fDirection)); // Modified by Ornedan
   if (nDurationType2>=0 && nVFX>=0)
   {
      DelayCommand(fWait2, ApplyEffectToObject(nDurationType2, EffectVisualEffect(nVFX2), oCenter, fDuration2));
      DelayCommand(fWait2, ApplyEffectToObject(nDurationType2, EffectVisualEffect(nVFX2), oPos2, fDuration2));
   }
   DelayCommand(fTime, ApplyEffectToObject(nDurationType, EffectBeam(nVFX, oPos2, BODY_NODE_CHEST), oCenter, fDuration));
   
   return oStore; // Added by Ornedan
}

object BeamPolygonalHemisphere(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nSides=3, float fDuration=0.0f, string sTemplate="invisobj", float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f)
{
   int i;
   if (nSides<3) nSides = 3;
   if (fDuration<0.0) fDuration = 0.0;
   if (fDuration2<0.0) fDuration2 = 0.0;
   if (fWait2<1.0) fWait2 = 1.0;
   if (fTime<0.0) fTime = 6.0;
   if (fRev==0.0) fRev = 5.0;
   float fEta = (fRev > 0.0) ? 360.0/IntToFloat(nSides) : -360.0/IntToFloat(nSides); // angle of segment
   float fSidesToDraw = (fRev > 0.0) ? fRev*IntToFloat(nSides) : -fRev*IntToFloat(nSides); // total number of sides to draw including revolutions as float value
   int nSidesToDraw = FloatToInt(fSidesToDraw); // total number of sides to draw including revolutions as int value
   float fDelayPerSide = fTime/fSidesToDraw;
   vector vCenter = GetPositionFromLocation(lCenter);
   vector vPos1, vPos2;
   object oArea = GetAreaFromLocation(lCenter);
   float g, x1, y1, z1, x2, y2, z2, fAngle2, fSphereAngle2, fSphereRadius2;
   float fEffectiveHeight = fHeightEnd - fHeightStart;
   object oPos1, oPos2;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan

   z1 = fHeightStart;           // creates the first point
   y1 = fRadiusStart*sin(fRotate);
   x1 = fRadiusStart*cos(fRotate);
   if (sAxis == "x")      vPos1 = vCenter + Vector(y1, z1, x1);
   else if (sAxis == "y") vPos1 = vCenter + Vector(z1, x1, y1);
   else                   vPos1 = vCenter + Vector(x1, y1, z1);
   oPos1 = CreateAndStoreObject(oStore, OBJECT_TYPE_PLACEABLE, sTemplate, Location(oArea, vPos1, fRotate)); // Modified by Ornedan
   if (nDurationType2>=0 && nVFX>=0) DelayCommand(fWait2, ApplyEffectToObject(nDurationType2, EffectVisualEffect(nVFX2), oPos1, fDuration2));

   for (i=0; i<nSidesToDraw; i++)
   {
      g = IntToFloat(i+1);
      fAngle2 = fEta*g + fRotate;
      fSphereAngle2 = fEta*g*0.25/fRev;
      fSphereRadius2 = fRadiusStart*cos(fSphereAngle2) + fRadiusEnd*sin(fSphereAngle2);
      z2 = fEffectiveHeight*sin(fSphereAngle2) + fHeightStart;
      y2 = fSphereRadius2*sin(fAngle2);
      x2 = fSphereRadius2*cos(fAngle2);
      if (sAxis == "x")      vPos2 = vCenter + Vector(y2, z2, x2);
      else if (sAxis == "y") vPos2 = vCenter + Vector(z2, x2, y2);
      else                   vPos2 = vCenter + Vector(x2, y2, z2);
      object oPos2 = CreateAndStoreObject(oStore, OBJECT_TYPE_PLACEABLE, sTemplate, Location(oArea, vPos2, fAngle2)); // Modified by Ornedan
      if (nDurationType2>=0 && nVFX2>=0) DelayCommand(fWait2, ApplyEffectToObject(nDurationType2, EffectVisualEffect(nVFX2), oPos2, fDuration2));
      DelayCommand(g*fDelayPerSide, ApplyEffectToObject(nDurationType, EffectBeam(nVFX, oPos1, BODY_NODE_CHEST), oPos2, fDuration));
      oPos1 = oPos2;
   }
   
   return oStore; // Added by Ornedan
}

void ActionCreateLocalObject(string sTemplate, location lLocation, string sNumber, object oBase, int nDurationType, int nVFX, float fDuration, float fWait,
                             object oStore) // Added by Ornedan
{
   if(!GetIsObjectValid(oStore)) return; // Do not create if destruction has already been called - Ornedan
   object oObject = CreateAndStoreObject(oStore, OBJECT_TYPE_PLACEABLE, sTemplate, lLocation);
   AssignCommand(oObject, ActionDoCommand(SetLocalObject(oBase, sNumber, oObject)));
   if (nDurationType >= 0 && nVFX >= 0) DelayCommand(fWait, ApplyEffectToObject(nDurationType, EffectVisualEffect(nVFX), oObject, fDuration));
}

void ActionApplyBeamEffect(object oBase, string sNumber, int nDurationType, int nVFX, float fDuration)
{
   object oNode = GetLocalObject(oBase, sNumber);
   ApplyEffectToObject(nDurationType, EffectBeam(nVFX, oBase, BODY_NODE_CHEST), oNode, fDuration);
}

void ActionApplyLocalBeamEffect(object oBase, string sNumber1, string sNumber2, int nDurationType, int nVFX, float fDuration)
{
   object oNode1 = GetLocalObject(oBase, sNumber1);
   object oNode2 = GetLocalObject(oBase, sNumber2);
   ApplyEffectToObject(nDurationType, EffectBeam(nVFX, oNode1, BODY_NODE_CHEST), oNode2, fDuration);
}

object BeamStellaOctangula(int nDurationType, int nVFX, location lCenter, float fRadius, float fDuration=0.0f, string sTemplate="invisobj", float fTime=6.0f, float fWait=1.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f)
{
   int i;
   if (fDuration<0.0) fDuration = 0.0;
   if (fDuration2<0.0) fDuration2 = 0.0;
   if (fWait<1.0) fWait = 1.0;
   if (fWait2<1.0) fWait2 = 1.0;
   if (fTime<0.0) fTime = 6.0;
//   if (fRadius<0.0) fRadius = -fRadius;
   vector vCenter = GetPositionFromLocation(lCenter);
   object oArea = GetAreaFromLocation(lCenter);
   float fSigma = fRadius*2.0/3.0;
   float fEpsilon = fSigma*4.0/3.0/cos(19.47122063449069136924599933997);
   float fDelay = fTime/8.0;
   float f, x, y, z, fAngle;
   location lPos;
   string sNumber, sNumber1;
   vector vPos;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan

   object oBase = CreateAndStoreObject(oStore, OBJECT_TYPE_PLACEABLE, sTemplate, lCenter); // Modified by Ornedan
   if (nDurationType2>=0 && nVFX2>=0) DelayCommand(fWait2, ApplyEffectToObject(nDurationType2, EffectVisualEffect(nVFX2), oBase, fDuration2));

   for (i=0; i<7; i++)
   {
      f = IntToFloat(i);
      if (i<3)
      {
         z = 2.0*fSigma;
         fAngle = fRotate + 120.0*f;
      }
      else if (i<6)
      {
         z = fSigma;
         fAngle = fRotate + 120.0*f + 60.0;
      }
      else
      {
         z = 3.0*fSigma;
         fEpsilon = 0.0;
      }
      x = fEpsilon*cos(fAngle);
      y = fEpsilon*sin(fAngle);
      if (sAxis == "x")      vPos = vCenter + Vector(y, z, x);
      else if (sAxis == "y") vPos = vCenter + Vector(z, x, y);
      else                   vPos = vCenter + Vector(x, y, z);
      lPos = Location(oArea, vPos, fAngle);
      sNumber = "stella"+IntToString(i);
      DelayCommand(fDelay*(f+1.0), ActionCreateLocalObject(sTemplate, lPos, sNumber, oBase, nDurationType2, nVFX2, fDuration2, fWait2, oStore)); // Modified by Ornedan
   }

   for (i=0; i<3; i++)
   {
      f = IntToFloat(i);
      sNumber = "stella"+IntToString(i);
      DelayCommand(fDelay*f+fWait, ActionApplyBeamEffect(oBase, sNumber, nDurationType, nVFX, fDuration));
   }
   for (i=0; i<6; i++)
   {
      f = IntToFloat(i+3);
      sNumber = "stella"+IntToString(i);
      if (i==2)      sNumber1 = "stella0";
      else if (i==5) sNumber1 = "stella3";
      else           sNumber1 = "stella"+IntToString(i+1);
      DelayCommand(fDelay*f+fWait, ActionApplyLocalBeamEffect(oBase, sNumber, sNumber1, nDurationType, nVFX, fDuration));
   }
   for (i=3; i<6; i++)
   {
      f = IntToFloat(i+6);
      sNumber1 = "stella"+IntToString(i);
      sNumber = "stella6";
      DelayCommand(fDelay*f+fWait, ActionApplyLocalBeamEffect(oBase, sNumber, sNumber1, nDurationType, nVFX, fDuration));
   }
   
   return oStore; // Added by Ornedan
}

object BeamIcosahedron(int nDurationType, int nVFX, location lCenter, float fRadius, float fDuration=0.0f, string sTemplate="invisobj", float fTime=6.0f, float fWait=1.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f)
{
   int i;
   if (fDuration<0.0) fDuration = 0.0;
   if (fDuration2<0.0) fDuration2 = 0.0;
   if (fWait<1.0) fWait = 1.0;
   if (fWait2<1.0) fWait2 = 1.0;
   if (fTime<0.0) fTime = 6.0;
   vector vCenter = GetPositionFromLocation(lCenter);
   object oArea = GetAreaFromLocation(lCenter);
   float fLengthOfSide = fRadius*1.0514622242382672120513381696952;
   float fSigma1 = fLengthOfSide*0.52573111211913360602566908484783;
   float fSigma2 = fLengthOfSide*0.85065080835203993218154049706411;
   float fEpsilon = fLengthOfSide/1.1755705045849462583374119092781;
   float fDelay = fTime/30.0;
   float f, x, y, z, fAngle;
   location lPos;
   string sNumber, sNumber1;
   vector vPos;
   object oStore = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter); // Added by Ornedan

   object oBase = CreateAndStoreObject(oStore, OBJECT_TYPE_PLACEABLE, sTemplate, lCenter); // Modified by Ornedan
   if (nDurationType2>=0 && nVFX2>=0) DelayCommand(fWait2, ApplyEffectToObject(nDurationType2, EffectVisualEffect(nVFX2), oBase, fDuration2));

   for (i=0; i<11; i++)
   {
      f = IntToFloat(i);
      if (i<5)
      {
         fAngle = fRotate + f*72.0;
         z = fSigma1;
      }
      else if (i<10)
      {
         fAngle = fRotate + f*72.0 + 36.0;
         z = fSigma1 + fSigma2;
      }
      else
      {
         z = 2.0*fSigma1 + fSigma2;
         fEpsilon = 0.0;
      }
      x = fEpsilon*cos(fAngle);
      y = fEpsilon*sin(fAngle);
      if (sAxis == "x")      vPos = vCenter + Vector(y, z, x);
      else if (sAxis == "y") vPos = vCenter + Vector(z, x, y);
      else                   vPos = vCenter + Vector(x, y, z);
      lPos = Location(oArea, vPos, fAngle);
      sNumber = "icosa"+IntToString(i);
      DelayCommand(fDelay*(f+1.0), ActionCreateLocalObject(sTemplate, lPos, sNumber, oBase, nDurationType2, nVFX2, fDuration2, fWait2, oStore)); // Modified by Ornedan
   }

   for (i=0; i<5; i++)
   {
      f = IntToFloat(i);
      sNumber = "icosa"+IntToString(i);
      DelayCommand(fDelay*f+fWait, ActionApplyBeamEffect(oBase, sNumber, nDurationType, nVFX, fDuration));
   }
   for (i=0; i<10; i++)
   {
      f = IntToFloat(i+5);
      sNumber = "icosa"+IntToString(i);
      if (i==4)      sNumber1 = "icosa0";
      else if (i==9) sNumber1 = "icosa5";
      else           sNumber1 = "icosa"+IntToString(i+1);

      if (i<5) DelayCommand(fDelay*f+fWait, ActionApplyLocalBeamEffect(oBase, sNumber, sNumber1, nDurationType, nVFX, fDuration));
      else     DelayCommand(fDelay*(f+10.0)+fWait, ActionApplyLocalBeamEffect(oBase, sNumber, sNumber1, nDurationType, nVFX, fDuration));
   }
   for (i=0; i<10; i++)
   {
      f = IntToFloat(i+10);
      sNumber = "icosa"+IntToString(i);
      if (i<5)       sNumber1 = "icosa"+IntToString(i+5);
      else if (i==9) sNumber1 = "icosa0";
      else           sNumber1 = "icosa"+IntToString(i-4);

      DelayCommand(fDelay*f+fWait, ActionApplyLocalBeamEffect(oBase, sNumber, sNumber1, nDurationType, nVFX, fDuration));
   }
   for (i=5; i<10; i++)
   {
      f = IntToFloat(i+20);
      sNumber = "icosa10";
      sNumber1 = "icosa"+IntToString(i);
      DelayCommand(fDelay*f+fWait, ActionApplyLocalBeamEffect(oBase, sNumber, sNumber1, nDurationType, nVFX, fDuration));
   }
   
   return oStore; // Added by Ornedan
}

// Destroys the vfx construct that was stored on oStore when created
//
// oStore   object returned by either one of the Place*
//          or Beam* functions
void DeleteVFXConstruct(object oStore)
{
    object oDelete;
    int i = GetLocalInt(oStore, "NumStoredObjects");
    for(; i > 0; i--){
        oDelete = GetLocalObject(oStore, "StoredObject_" + IntToString(i));
        AssignCommand(oDelete, SetIsDestroyable(TRUE, FALSE, FALSE));
        AssignCommand(oDelete, DestroyObject(oStore));
    }
    AssignCommand(oStore, SetIsDestroyable(TRUE, FALSE, FALSE));
    AssignCommand(oStore, DestroyObject(oStore));
}


//void main(){}