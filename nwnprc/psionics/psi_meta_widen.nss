void main()
{
    object oCaster = OBJECT_SELF;
    
    if (GetLocalInt(oCaster, "PsiMetaWiden") == TRUE)
    {
    	SetLocalInt(oCaster, "PsiMetaWiden", FALSE);
    	FloatingTextStringOnCreature("Widen Off", oCaster, FALSE);
    }
    if (GetLocalInt(oCaster, "PsiMetaWiden") == FALSE)
    {
    	SetLocalInt(oCaster, "PsiMetaWiden", TRUE);
    	FloatingTextStringOnCreature("Widen On", oCaster, FALSE);
    	
        if (GetLocalInt(oCaster, "PsiMetaChain") == TRUE)
	{
	    	SetLocalInt(oCaster, "PsiMetaChain", FALSE);
	   	FloatingTextStringOnCreature("Chain Power Off", oCaster, FALSE);
    	}
        if (GetLocalInt(oCaster, "PsiMetaExtend") == TRUE)
	{
	    	SetLocalInt(oCaster, "PsiMetaExtend", FALSE);
	   	FloatingTextStringOnCreature("Extend Off", oCaster, FALSE);
    	}
        if (GetLocalInt(oCaster, "PsiMetaMax") == TRUE)
	{
	    	SetLocalInt(oCaster, "PsiMetaMax", FALSE);
	   	FloatingTextStringOnCreature("Maximize Off", oCaster, FALSE);
    	}
        if (GetLocalInt(oCaster, "PsiMetaSplit") == TRUE)
	{
	    	SetLocalInt(oCaster, "PsiMetaSplit", FALSE);
	   	FloatingTextStringOnCreature("Split Psionic Ray Off", oCaster, FALSE);
    	}    	
        if (GetLocalInt(oCaster, "PsiMetaTwin") == TRUE)
	{
	    	SetLocalInt(oCaster, "PsiMetaTwin", FALSE);
	   	FloatingTextStringOnCreature("Twin Power Off", oCaster, FALSE);
    	}
        if (GetLocalInt(oCaster, "PsiMetaEmpower") == TRUE)
	{
	    	SetLocalInt(oCaster, "PsiMetaEmpower", FALSE);
	   	FloatingTextStringOnCreature("Empower Off", oCaster, FALSE);
    	}    	
    }    
}