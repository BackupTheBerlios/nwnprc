
//return a location that PCs will never be able to access
location PRC_GetLimbo()
{
    int i = 0;
	location lLimbo;

    while (1)
    {
	    object oLimbo = GetObjectByTag("Limbo", i++);
	
		if (oLimbo == OBJECT_INVALID) {
			PrintString("PRC ERROR: no Limbo area! (did you import the latest PRC .ERF file?)");
			return lLimbo;
		}

    	if (GetName(oLimbo) == "Limbo" && GetArea(oLimbo) == OBJECT_INVALID)
        {
            vector vLimbo = Vector(0.0f, 0.0f, 0.0f);
            lLimbo = Location(oLimbo, vLimbo, 0.0f);
        }
    }
	return lLimbo;		//never reached
}
