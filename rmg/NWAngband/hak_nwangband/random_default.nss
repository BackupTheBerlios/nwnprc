#include "prc_gateway"
#include "random_inc"

void main()
{
    int nValue = GetLocalInt(OBJECT_SELF, RANDOM_2DA_SEED);
    int nLevel = GetLocalInt(GetModule(), "RIG_LEVEL");
    if(nValue >= 1000 && nValue < 1100)
        //narrowband 2-sided at level;
        //   0  25  50  75 100  75  50  25   0
        nValue = 100-(25*abs(nLevel-(nValue-1000)));
    else if(nValue >= 1100 && nValue < 1200)
        //broadband 2-sided at level;
        //   0  10  20  30  40  50  60  70   80  90 100  90  80  70  60  50  40  30  20  10  0
        nValue = 100-(10*abs(nLevel-(nValue-1100)));
    else if(nValue >= 1200 && nValue < 1300)
        //greater than level
        if(nLevel >  (nValue-1200)) nValue = 100; else nValue = 0;
    else if(nValue >= 1300 && nValue < 1400)
        //less than level
        if(nLevel <  (nValue-1300)) nValue = 100; else nValue = 0;
    else if(nValue == 1500)
        //is epic
        if(nLevel > 20)
            nValue = 100;
        else
            nValue = 0;
    else if(nValue == 1501)
        //is not epic
        if(nLevel > 20)
            nValue = 0;
        else
            nValue = 100;
    else if(nValue >= 1600 && nValue < 1650)
        //fire once in this script for self
    {
        if(GetIsResultRun())
        {
            SetLocalInt(OBJECT_SELF, "random_oneshot_"+IntToString(nValue), TRUE);
            DelayCommand(0.0,
                DeleteLocalInt(OBJECT_SELF, "random_oneshot_"+IntToString(nValue)));
        }
        if(GetLocalInt(OBJECT_SELF, "random_oneshot_"+IntToString(nValue)))
            nValue = 0;
        else
            nValue = 100;
    }
    else if(nValue >= 1650 && nValue < 1700)
        //fire once within 10 seconds for self
    {
        if(GetIsResultRun())
        {
            SetLocalInt(OBJECT_SELF, "random_oneshot_"+IntToString(nValue), TRUE);
            DelayCommand(10.0,
                DeleteLocalInt(OBJECT_SELF, "random_oneshot_"+IntToString(nValue)));
        }
        if(GetLocalInt(OBJECT_SELF, "random_oneshot_"+IntToString(nValue)))
            nValue = 0;
        else
            nValue = 100;
    }
    else if(nValue >= 1700 && nValue < 1750)
        //fire once in this script for mod
    {
        if(GetIsResultRun())
        {
            SetLocalInt(GetModule(), "random_oneshot_"+IntToString(nValue), TRUE);
            AssignCommand(GetModule(),
                DeleteLocalInt(GetModule(), "random_oneshot_"+IntToString(nValue)));
        }
        if(GetLocalInt(GetModule(), "random_oneshot_"+IntToString(nValue)))
            nValue = 0;
        else
            nValue = 100;
    }
    else if(nValue >= 1750 && nValue < 1800)
        //fire once within 10 seconds for mod
    {
        if(GetIsResultRun())
        {
            SetLocalInt(GetModule(), "random_oneshot_"+IntToString(nValue), TRUE);
            AssignCommand(GetModule(),
                DelayCommand(10.0,
                    DeleteLocalInt(GetModule(), "random_oneshot_"+IntToString(nValue))));
        }
        if(GetLocalInt(GetModule(), "random_oneshot_"+IntToString(nValue)))
            nValue = 0;
        else
            nValue = 100;
    }

    //store this value for pass-back
    SetLocalInt(OBJECT_SELF, RANDOM_2DA_SEED, nValue);
}
