int StartingConditional()
{
    //setup time tokens
    //82001         part of day
    //82002         date
    //82003         month
    //82004         year
    if(GetIsDawn())
        SetCustomToken(82001, "dawn");
    else if(GetIsDusk())
        SetCustomToken(82001, "dusk");
    else if(GetIsNight())
        SetCustomToken(82001, "night");
    else if(GetIsDay() && GetTimeHour() < 12)
        SetCustomToken(82001, "morning");
    else if(GetIsDay() && GetTimeHour() >= 12)
        SetCustomToken(82001, "afternoon");

    int nDay = GetCalendarDay();
    string sDay = IntToString(nDay);
    if(nDay == 1
        || nDay == 21)
        sDay += "st";
    else if(nDay == 2
        || nDay == 22)
        sDay += "nd";
    else if(nDay == 3
        || nDay == 23)
        sDay += "rd";
    else
        sDay += "th";
    SetCustomToken(82002, sDay);

    string sMonth;
    switch(GetCalendarMonth())
    {
        case 1:  sMonth = "January";   break;
        case 2:  sMonth = "Febuary";   break;
        case 3:  sMonth = "March";     break;
        case 4:  sMonth = "April";     break;
        case 5:  sMonth = "May";       break;
        case 6:  sMonth = "June";      break;
        case 7:  sMonth = "July";      break;
        case 8:  sMonth = "August";    break;
        case 9:  sMonth = "September"; break;
        case 10: sMonth = "October";   break;
        case 11: sMonth = "November";  break;
        case 12: sMonth = "December";  break;
    }
    SetCustomToken(82003, sMonth);

    SetCustomToken(82004, IntToString(GetCalendarYear()));
    return TRUE;
}
