//::///////////////////////////////////////////////
//:: Thread generation include
//:: inc_threads
//::///////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 14.03.2005
//:://////////////////////////////////////////////


//////////////////////////////////////////////////
/* Constant declarations                        */
//////////////////////////////////////////////////

const string PREFIX          = "prc_thread_";
const string SUFFIX_SCRIPT   = "_script";
const string SUFFIX_INTERVAL = "_interval";
const string CUR_THREAD      = "current_thread";
//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

// Return success or failure
int SpawnNewThread(string sName, string sScript, float fFiringInterval = 6.0f, object oToRunOn = OBJECT_INVALID);

int GetThreadExists(string sName, object oRunningOn = OBJECT_INVALID);

void TerminateThread(string sName, object oRunningOn = OBJECT_INVALID);

void TerminateCurrentThread();

// Return success or failure
int ChangeFiringInterval(string sName, float fNewInterval, object oRunningOn = OBJECT_INVALID);


void RunThread(string sName, object oRunningOn);


//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////


int SpawnNewThread(string sName, string sScript, float fFiringInterval = 6.0f, object oToRunOn = OBJECT_INVALID){
	if(oToRunOn == OBJECT_INVALID)
		oToRunOn = GetModule();
	
	// Check paramaeters for correctness
	if(sName   == ""           ||
	   sScript == ""           ||
	   fFiringInterval <= 0.0f ||
	  !GetIsObjectValid(oToRunOn))
		return FALSE;
	
	// Make sure there is no thread by this name already running
	if(GetLocalInt(oToRunOn, PREFIX + sName))
		return FALSE;
	
	// Set the thread variables
	SetLocalInt(oToRunOn, PREFIX + sName, TRUE);
	SetLocalString(oToRunOn, PREFIX + sName + SUFFIX_SCRIPT, sScript);
	SetLocalFloat(oToRunOn, PREFIX + sName + SUFFIX_INTERVAL, fFiringInterval);
	
	// Start thread execution
	DelayCommand(fFiringInterval, RunThread(sName, oToRunOn));
	
	// All done successfully
	return TRUE;
}


int GetThreadExists(string sName, object oRunningOn = OBJECT_INVALID){
	if(oRunningOn == OBJECT_INVALID)
		oRunningOn = GetModule();
	
	// Check paramaeters for correctness
	if(sName   == ""           ||
	  !GetIsObjectValid(oRunningOn))
		return FALSE;
	
	// Return the local determining if the thread exists
	return GetLocalInt(oRunningOn, PREFIX + sName);
}


void TerminateThread(string sName, object oRunningOn = OBJECT_INVALID){
	if(oRunningOn == OBJECT_INVALID)
		oRunningOn = GetModule();
	
	// Check paramaeters for correctness
	if(sName   == ""           ||
	  !GetIsObjectValid(oRunningOn))
		return;
	
	// Remove the thread variables
	DeleteLocalInt(oToRunOn, PREFIX + sName);
	DeleteLocalString(oToRunOn, PREFIX + sName + SUFFIX_SCRIPT);
	DeleteLocalFloat(oToRunOn, PREFIX + sName + SUFFIX_INTERVAL);
}


void TerminateCurrentThread(){
	TerminateThread(GetLocalString(GetModule(), PREFIX + CUR_THREAD),
	                GetLocalObject(GetModule(), PREFIX + CUR_THREAD)
		       );
}


int ChangeFiringInterval(string sName, float fNewInterval, object oRunningOn = OBJECT_INVALID){
	if(oRunningOn == OBJECT_INVALID)
		oRunningOn = GetModule();
	
	// Check paramaeters for correctness
	if(!GetThreadExists(sName, oRunningOn) ||
	   fNewInterval <= 0.0f ||)
		return FALSE;
	
	
	SetLocalFloat(oRunningOn, PREFIX + sName + SUFFIX_INTERVAL, fNewInterval);
	return true;
}


void RunThread(string sName, object oRunningOn){
	// Abort if the object we're running on has ceased to exist
	if(!GetIsObjectValid(oRunningOn))
		return;
	
	// Mark this thread as running
	SetLocalString(GetModule(), PREFIX + CUR_THREAD, sName);
	SetLocalObject(GetModule(), PREFIX + CUR_THREAD, oRunningOn);
	
	// Execute the threadscript
	string sScript = GetLocalString(oToRunOn, PREFIX + sName + SUFFIX_SCRIPT);
	ExecuteScript(sScript, oRunningOn);
	
	// Schedule next execution, unless we've been terminated
	if(GetThreadExists(sName, oRunningOn)){
		DelayCommand(GetLocalFloat(oToRunOn, PREFIX + sName + SUFFIX_INTERVAL), RunThread(sName, oRunningOn));
	
	// Clean up the module variables
	DeleteLocalString(GetModule(), PREFIX + CUR_THREAD);
	DeleteLocalObject(GetModule(), PREFIX + CUR_THREAD);
}