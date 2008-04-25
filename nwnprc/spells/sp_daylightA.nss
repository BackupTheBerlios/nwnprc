///////////////////////////////////////////////////
// Daylight On Enter
// sp_daylightA.nss
////////////////////////////////////////////////////

void main()
{
        object oTarget = GetEnteringObject();
        int nLight = GetLocalInt(oTarget, "PRCInLight");
        nLight++;
        SetLocalInt(oTarget, "PRCInLight", nLight);
}
        
