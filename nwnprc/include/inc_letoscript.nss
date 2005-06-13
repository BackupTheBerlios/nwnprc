#include "inc_2dacache"
#include "prc_inc_switch"
#include "inc_debug"

//defining directories
//must be changed to each install
//it will use a local string on the module named NWN_DIR if set


const string DB_NAME = "PRCNWNXLeto";
const string DB_GATEWAY_VAR = "PRCNWNXLeto";

//set this to true if using build 18 or earlier of letoscript.dll
//again this is a PRC switch


/*YOU MUST ADD THE FOLLOWING TO YOUR ON CLIENT EXIT EVENT

    object oPC = GetExitingObject();
    LetoPCExit(oPC);

*/

/*YOU MUST ADD THE FOLLOWING TO YOUR ON CLIENT ENTER EVENT

    object oPC = GetExitingObject();
    LetoPCEnter(oPC);

*/

//instanty runs the letoscript sScript
//for sType see abive
//if sType is POLL, PollThread is atomatically started
//and sPollScript is passed as the script name
string LetoScript(string sScript, string sType = "SCRIPT", string sPollScript = "");

//This command adds the script to the cuttent superscript
//to run the superscript use StackedLetoScripRun
void StackedLetoScript(string sScript);

//poll an existing thread
//when the thread is finished, script sScript is run
void PollThread(string sThreadID, string sScript);

//credit to demux
//gets a bicpath of a pc
//must be servervault to work
string GetBicPath(object oPC);

//credit to demux
//gets the filename of a PCs bic
//must be servervault
string GetBicFileName(object oPC);

//This will automatically add the required code before and after, and will
//adapt based on PC/NPC/etc.
//This overwites the existing object which will break stored references
//such as henchmen. The new object is returned.
//the result of the script is stored on the module in LetoResult for 1 second
//if nDestroyOriginal is set then PCs will be booted and non-pcs will be destroyed
object RunStackedLetoScriptOnObject(object oObject, string sLetoTag = "OBJECT",    string sType = "SCRIPT", string sPollScript = "", int nDestroyOriginal = TRUE);

const int DEBUG = TRUE;

string GetNWNDir()
{
    string sReturn = GetLocalString(GetModule(), PRC_LETOSCRIPT_NWN_DIR);
    /*
    if(GetStringRight(sReturn, 1) != "\"
        && GetStringRight(sReturn, 1) != "/")
        sReturn += "\";
        //" this is here so textpad doesnt go screwy becasue it escapes the quotes above.
        */
    return sReturn;
}

//credit to demux
string GetBicFileName(object oPC)
{
    string sChar, sBicName;
    string sPCName = GetStringLowerCase(GetName(oPC));
    int i, iNameLength = GetStringLength(sPCName);

    for(i=0; i < iNameLength; i++) {
        sChar = GetSubString(sPCName, i, 1);
        if (TestStringAgainstPattern("(*a|*n|*w|'|-|_)", sChar)) {
            if (sChar != " ") sBicName += sChar;
        }
    }
    return GetStringLeft(sBicName, 16);
}

//credit to demux
string GetBicPath(object oPC)
{
    // Gets a local var stored on oPC on "event client enter". I do this because
    // "on even client leave", function GetPCPlayerName() can not be used. Since
    // a .bic file can not be changed while the owner is logged in, it is typical
    // to execute leto scripts when the client leaves (on event client leave).
    string PlayerName = GetLocalString(oPC, "PlayerName");
    if(PlayerName == "")
        PlayerName = GetPCPlayerName(oPC);

    // Retruns the full path to a .bic file.
    return GetNWNDir()+"servervault/"+PlayerName+"/"+GetBicFileName(oPC)+".bic";
}

void VoidLetoScript(string sScript, string sType = "SCRIPT", string sPollScript = "")
{
    LetoScript(sScript,sType,sPollScript);
}

string LetoScript(string sScript, string sType = "SCRIPT", string sPollScript = "")
{
    string sAnswer;
    DoDebug(sType+" >: "+sScript);
    SetLocalString(GetModule(), "NWNX!LETO!"+sType, sScript);
    sAnswer = GetLocalString(GetModule(), "NWNX!LETO!"+sType);
    DoDebug(sType+" <: "+sAnswer);
    if(sType == "SPAWN")
        DelayCommand(1.0, PollThread(sAnswer, sPollScript));
    return sAnswer;
}

void LetoPCEnter(object oPC)
{
    SetLocalString(oPC, "Leto_Path", GetBicPath(oPC));
    SetLocalString(oPC, "PCPlayerName", GetPCPlayerName(oPC));
    DeleteLocalString(oPC, "LetoScript");
}

void LetoPCExit(object oPC)
{
    string sScript = GetLocalString(oPC, "LetoScript");
    if(sScript != "")
    {
        string sPath = GetLocalString(oPC, "Leto_Path");
        if(sPath == "")
            DoDebug("Path is Null");
        if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
        {
            //pheonix syntax
            sScript  = "<file:open CHAR <qq:"+sPath+">>"+sScript;
            sScript += "<file:save CHAR <qq:"+sPath+">>";
            sScript += "<file:close CHAR >";
        }
        else
        {
            if(GetPRCSwitch(PRC_LETOSCRIPT_GETNEWESTBIC))
            {
                sScript  = "%char =  FindNewestBic(qq{"+GetNWNDir()+"servervault/"+GetLocalString(oPC, "PCPlayerName")+"}); "+sScript;
                sScript += "%char = '>'; ";
                sScript += "close %char; ";
            }
            else
            {
                //unicorn syntax
                sScript  = "%char= qq{"+sPath+"}; "+sScript;
                sScript += "%char = '>'; ";
                sScript += "close %char; ";
            }
        }
        string sScriptResult = LetoScript(sScript);
        SetLocalString(GetModule(), "LetoResult", sScriptResult);
        AssignCommand(GetModule(), DelayCommand(1.0, DeleteLocalString(GetModule(), "LetoResult")));
    }
}

void StackedLetoScript(string sScript)
{
    DoDebug("SLS :"+sScript);
    SetLocalString(GetModule(), "LetoScript", GetLocalString(GetModule(), "LetoScript")+ sScript);
}

void PollThread(string sThreadID, string sScript)
{
    if(GetLocalInt(GetModule(), "StopThread"+sThreadID) == TRUE)
        return;
    DoDebug("Polling: "+sThreadID);
    //add blank space to capture error messages
    string sResult = LetoScript(sThreadID+"                                   "
        +"                                   "
        +"                                   "
        +"                                   "
        +"                                   "
        +"                                   "
        +"                                   "
        +"                                   "
        +"                                   ", "POLL");
    if(sResult == "Error: "+sThreadID+" not done.")
    {
        DelayCommand(1.0, PollThread(sThreadID, sScript));
        return;
    }
    else
    {
        DoDebug("Poll: Executing: "+sScript);
        SetLocalInt(GetModule(), "StopThread"+sThreadID, TRUE);
        DelayCommand(6.0, DeleteLocalInt(GetModule(), "StopThread"+sThreadID));
        location lLoc = GetLocalLocation(GetModule(), "Thread"+sThreadID+"_loc");
        DelayCommand(1.0, DeleteLocalLocation(GetModule(), "Thread"+sThreadID+"_loc"));
DoDebug("Thread"+sThreadID+"_loc");
DoDebug(GetName(GetAreaFromLocation(lLoc)));        
        object oReturn;
        if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
        {
            oReturn = RetrieveCampaignObject(DB_NAME, DB_GATEWAY_VAR, lLoc);
        }
        else
        {
            if(GetPRCSwitch(PRC_LETOSCRIPT_UNICORN_SQL))
            {
                string sSQL = "SELECT blob FROM "+DB_NAME+" WHERE "+DB_GATEWAY_VAR+"="+DB_GATEWAY_VAR+" LIMIT 1";
                SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);
                oReturn = RetrieveCampaignObject("NWNX", "-", lLoc);
            }
            else
            {
                oReturn = RetrieveCampaignObject(DB_NAME, DB_GATEWAY_VAR, lLoc);
            }
        }
DoDebug(GetName(oReturn));        
        SetLocalString(GetModule(), "LetoResult", sResult);
        AssignCommand(GetModule(), DelayCommand(1.0, DeleteLocalString(GetModule(), "LetoResult")));
        SetLocalObject(GetModule(), "LetoResultObject", oReturn);
        AssignCommand(GetModule(), DelayCommand(1.0, DeleteLocalObject(GetModule(), "LetoResultObject")));
        SetLocalString(GetModule(), "LetoResultThread", sThreadID);
        AssignCommand(GetModule(), DelayCommand(1.0, DeleteLocalString(GetModule(), "LetoResultThread")));
        ExecuteScript(sScript, OBJECT_SELF);
    }
}

void VoidRunStackedLetoScriptOnObject(object oObject, string sLetoTag = "OBJECT",
    string sType = "SCRIPT", string sPollScript = "", int nDestroyOriginal = TRUE)
{
    RunStackedLetoScriptOnObject(oObject,sLetoTag,sType,sPollScript,nDestroyOriginal);
}

object RunStackedLetoScriptOnObject(object oObject, string sLetoTag = "OBJECT",
    string sType = "SCRIPT", string sPollScript = "", int nDestroyOriginal = TRUE)
{
    if(!GetIsObjectValid(oObject))
    {
        WriteTimestampedLogEntry("ERROR: "+GetName(oObject)+"is invalid");
        WriteTimestampedLogEntry("Script was "+GetLocalString(GetModule(), "LetoScript"));
        return OBJECT_INVALID;
    }
    string sCommand;
    object oReturn;
    location lLoc;
    object oWPLimbo = GetObjectByTag("HeartOfChaos");
    location lLimbo;
    if(GetIsObjectValid(oWPLimbo))
        lLimbo = GetLocation(oWPLimbo);
    else
        lLimbo = GetStartingLocation();
    string sScript = GetLocalString(GetModule(), "LetoScript");
    DeleteLocalString(GetModule(), "LetoScript");
    string sScriptResult;
    //check if its a DM or PC
    //these use bic files
    if(GetIsPC(oObject) || GetIsDM(oObject))
    {
        if(!nDestroyOriginal)//dont boot
        {
            string sPath = GetLocalString(oObject, "Leto_Path");
            if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
            {
                sCommand = "<file:open '"+sLetoTag+"' <qq:"+sPath+">>";
                sScript = sCommand+sScript;
                sCommand = "<file:close '"+sLetoTag+"'>";
                sScript = sScript+sCommand;
                //unicorn
            }
            else
            {
                sCommand = "%"+sLetoTag+" = '"+sPath+"'; ";
                sScript = sCommand+sScript;
                sCommand = "close %"+sLetoTag+"; ";
                sScript = sScript+sCommand;
            }
            sScriptResult = LetoScript(sScript, sType, sPollScript);
        }
        else//boot
        {
            SetLocalString(oObject, "LetoScript", GetLocalString(oObject, "LetoScript")+sScript);
            if(GetLocalString(GetModule(), PRC_LETOSCRIPT_PORTAL_IP) == "")
            {
                BootPC(oObject);
            }
            else
            {
                ActivatePortal(oObject, 
                    GetLocalString(GetModule(), PRC_LETOSCRIPT_PORTAL_IP),
                    GetLocalString(GetModule(), PRC_LETOSCRIPT_PORTAL_PASSWORD),
                    "", //waypoint, may need to change
                    TRUE);
            }                
            return oReturn;
        }
    }
    //its an NPC/Placeable/Item, go through DB
    else if(GetObjectType(oObject) == OBJECT_TYPE_CREATURE
        || GetObjectType(oObject) == OBJECT_TYPE_ITEM
        || GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE
        || GetObjectType(oObject) == OBJECT_TYPE_STORE
        || GetObjectType(oObject) == OBJECT_TYPE_WAYPOINT)
    {
        if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
        {
            //Put object into DB
            StoreCampaignObject(DB_NAME, DB_GATEWAY_VAR, oObject);
            // Reaquire DB with new object in it
            sCommand += "<file:open FPT <qq:" + GetNWNDir() + "database/" + DB_NAME + ".fpt>>";
            //Extract object from DB
            sCommand += "<fpt:extract FPT '"+DB_GATEWAY_VAR+"' "+sLetoTag+">";
            sCommand += "<file:close FPT>";
            sCommand += "<file:use "+sLetoTag+">";
        }
        else
        {
            if(GetPRCSwitch(PRC_LETOSCRIPT_UNICORN_SQL))
            {
                //unicorn
                //Put object into DB
                string sSQL = "SELECT "+DB_GATEWAY_VAR+" FROM "+DB_NAME+" WHERE "+DB_GATEWAY_VAR+"="+DB_GATEWAY_VAR+" LIMIT 1";
                PRC_SQLExecDirect(sSQL);

                if (PRC_SQLFetch() == PRC_SQL_SUCCESS)
                {
                    // row exists
                    sSQL = "UPDATE "+DB_NAME+" SET val=%s WHERE "+DB_GATEWAY_VAR+"="+DB_GATEWAY_VAR;
                    SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);
                }
                else
                {
                    // row doesn't exist
                    // assume table doesnt exist too
                    sSQL = "CREATE TABLE "+DB_NAME+" ( "+DB_GATEWAY_VAR+" TEXT, blob BLOB )";
                    PRC_SQLExecDirect(sSQL);
                    sSQL = "INSERT INTO "+DB_NAME+" ("+DB_GATEWAY_VAR+", blob) VALUES" +
                        "("+DB_GATEWAY_VAR+", %s)";
                    SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);
                }
                StoreCampaignObject ("NWNX", "-", oObject);
                // Reaquire DB with new object in it
                //force data to be written to disk
                sSQL = "COMMIT";
                PRC_SQLExecDirect(sSQL);
                sCommand += "sql.connect 'root', '' or die $!; ";
                sCommand += "sql.query 'SELECT blob FROM "+DB_NAME+" WHERE "+DB_GATEWAY_VAR+"="+DB_GATEWAY_VAR+" LIMIT 1'; ";
                sCommand += "sql.retrieve %"+sLetoTag+"; ";
            }
            else
            {
                //Put object into DB
                StoreCampaignObject(DB_NAME, DB_GATEWAY_VAR, oObject);
                sCommand += "%"+sLetoTag+"; ";
                //Extract object from DB
                sCommand += "extract qq{"+GetNWNDir()+"database/"+DB_NAME+".fpt}, '"+DB_GATEWAY_VAR+"', %"+sLetoTag+" or die $!;";            
            }
        }
        //store their location
        lLoc = GetLocation(oObject);
        if(!GetIsObjectValid(GetAreaFromLocation(lLoc)))
            lLoc = GetStartingLocation();
            
        sScript = sCommand + sScript;
        sCommand = "";

        //destroy the original
        if(nDestroyOriginal)
        {
            AssignCommand(oObject, SetIsDestroyable(TRUE));
            DestroyObject(oObject);
        //its an NPC/Placeable/Item, go through DB
            if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
            {
                sCommand  = "<file:open FPT <qq:" + GetNWNDir() + "database/" + DB_NAME + ".fpt>>";
                sCommand += "<fpt:replace FPT '" +DB_GATEWAY_VAR+ "' "+sLetoTag+">";
                sCommand += "<file:save FPT>";
                sCommand += "<file:close FPT>";
                sCommand += "<file:close "+sLetoTag+">";
            }
            else
            {
                if(GetPRCSwitch(PRC_LETOSCRIPT_UNICORN_SQL))
                {
                    //unicorn
                    sCommand += "sql.query 'SELECT blob FROM "+DB_NAME+" WHERE "+DB_GATEWAY_VAR+"="+DB_GATEWAY_VAR+" LIMIT 1'; ";
                    sCommand += "sql.store %"+sLetoTag+"; ";
                    sCommand += "close %"+sLetoTag+"; ";
                }
                else
                {
                    sCommand += "inject qq{"+GetNWNDir()+"database/"+DB_NAME+".fpt}, '"+DB_GATEWAY_VAR+"', %"+sLetoTag+" or die $!;";
                    sCommand += "close %"+sLetoTag+"; ";
                }
            }
        }

        sScript = sScript + sCommand;
        sScriptResult = LetoScript(sScript, sType, sPollScript);

        if(nDestroyOriginal && sType != "SPAWN")
        {
            if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
            {
                if(GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
                {
                    oReturn = RetrieveCampaignObject(DB_NAME, DB_GATEWAY_VAR, lLimbo);
                    AssignCommand(oReturn, JumpToLocation(lLoc));
                }
                else
                    oReturn = RetrieveCampaignObject(DB_NAME, DB_GATEWAY_VAR, lLoc);
            }
            else
            {
                if(GetPRCSwitch(PRC_LETOSCRIPT_UNICORN_SQL))
                {
                    string sSQL = "SELECT blob FROM "+DB_NAME+" WHERE "+DB_GATEWAY_VAR+"="+DB_GATEWAY_VAR+" LIMIT 1";
                    SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);
                    if(GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
                    {
                        oReturn = RetrieveCampaignObject("NWNX", "-", lLimbo);
                        AssignCommand(oReturn, JumpToLocation(lLoc));
                    }
                    else
                        oReturn = RetrieveCampaignObject("NWNX", "-", lLoc);
                }       
                else
                {
                    if(GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
                    {
                        oReturn = RetrieveCampaignObject(DB_NAME, DB_GATEWAY_VAR, lLimbo);
                        AssignCommand(oReturn, JumpToLocation(lLoc));
                    }
                    else
                        oReturn = RetrieveCampaignObject(DB_NAME, DB_GATEWAY_VAR, lLoc);                    
                }
            }
        }
        else if(nDestroyOriginal && sType == "SPAWN")
        {
            SetLocalLocation(GetModule(), "Thread"+IntToString(StringToInt(sScriptResult))+"_loc", lLoc);            
DoDebug("Thread"+IntToString(StringToInt(sScriptResult))+"_loc");
        }
    }
    SetLocalString(GetModule(), "LetoResult", sScriptResult);
    AssignCommand(GetModule(), DelayCommand(1.0, DeleteLocalString(GetModule(), "LetoResult")));

    return oReturn;
}