//::///////////////////////////////////////////////
//:: Name default.nss
//:://////////////////////////////////////////////
/*
   PC's and their clones are created with "default" hard-coded as
   the script name in each and every event handler slot except
   OnConversation, which goes to nw_g0_conversat. In the normal game
   there is no script called "default" and, although these objects
   receive event signals, the signals evoke no scripted response.

   Because the same script is called by many different event signals
   and there is no inbuilt function resembling GetLastEventSignalled()
   it attempts to distinguish them according to context. It then
   simply passes the call on to an appropriate event-handling script.
*/
#include "prc_alterations"
#include "prc_inc_leadersh"

int IsBlocked();                // test GetBlockingDoor()
int IsCombatRoundEnd();         // Need to fake this
int IsConversation();           // uses localint set in nw_g0_conversat
int IsDamaged();                // test GetLastDamager()
int IsDeath();                  // test GetIsDead(OBJECT_SELF)
int IsDisturbed();              // test GetLastDisturbed()
int IsHeartbeat();              // test counter
int IsPerception();             // test GetLastPerceived()
int IsPhysicalAttacked();       // test GetLastAttacker()
int IsRested();                 // test GetIsResting(GetMaster())
int IsSpawn();                  // run once, never again
int IsSpellCastAt();            // test GetLastSpellCaster()
int IsUserDefined();            // test GetUserDefinedEventNumber()

int IsStringChanged(string sTest, string sName);
int IsIntChanged(int iTest, string sName);
int IsObjectChanged(object oTest, string sName);
void ClearChangeObject(string sName);
void ClearChangeInt(string sName);
void ClearChangeString(string sName);
void RunScript(string sEvent);

void OnSpawn()            { RunScript("spawned");   }
void OnDeath()            { RunScript("death");     }
void OnRested()           { RunScript("rested");    }
void OnHeartbeat()        { RunScript("heartbeat"); }
void OnPerception()       { RunScript("perception");}
void OnBlocked()          { RunScript("blockd");    }
void OnCombatRoundEnd()   { RunScript("combat");    }
void OnDisturbed()        { RunScript("disturbed"); }
void OnPhysicalAttacked() { RunScript("attacked");  }
void OnSpellCastAt()      { RunScript("spellcast"); }
void OnDamaged()          { RunScript("damaged");   }
void OnUserDefined()      { RunScript("user");      }
void OnConversation()     { RunScript("conv");      }

void main()
{
    if(!GetLocalInt(OBJECT_SELF, PRC_PC_EXEC_DEFAULT))
        return;
    if (IsBlocked())              OnBlocked();
    if (IsCombatRoundEnd())       OnCombatRoundEnd();
    if (IsConversation())         OnConversation();
    if (IsDamaged())              OnDamaged();
    if (IsDeath())                OnDeath();
    if (IsDisturbed())            OnDisturbed();
    if (IsHeartbeat())            OnHeartbeat();
    if (IsPerception())           OnPerception();
    if (IsPhysicalAttacked())     OnPhysicalAttacked();
    if (IsRested())               OnRested();
    if (IsSpawn())                OnSpawn();
    if (IsSpellCastAt())          OnSpellCastAt();
    if (IsUserDefined())          OnUserDefined();
}

int IsBlocked()
{
  DelayCommand(1.0, ClearChangeObject("BlockingDoor"));
  return IsObjectChanged(GetBlockingDoor(),"BlockingDoor");
}

int IsConversation()
{
    DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "default_conversation_event"));
    return GetLocalInt(OBJECT_SELF, "default_conversation_event");
}

int IsCombatRoundEnd()
{
    DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "default_combat_round_end_event"));
    return GetLocalInt(OBJECT_SELF, "default_combat_round_end_event");
}

int IsDamaged()
{
  DelayCommand(1.0, ClearChangeObject("LastDamager"));
  return IsObjectChanged(GetLastDamager(),"LastDamager");
}

int IsDeath()
{
  if (GetIsDead(OBJECT_SELF))
  {
    return TRUE;
  }
  else
  {
    return FALSE;
  }
}

int IsDisturbed()
{
  DelayCommand(1.0, ClearChangeObject("LastDisturbed"));
  return IsObjectChanged(GetLastDisturbed(),"LastDisturbed");
}

int IsHeartbeat()
{
    DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "default_heartbeat_event"));
    int nReturn = GetLocalInt(OBJECT_SELF, "default_heartbeat_event");
    if(nReturn && GetIsInCombat(OBJECT_SELF))
    {
        //trigger combat round end instead
        SetLocalInt(OBJECT_SELF, "default_combat_round_end_event", TRUE);
        ExecuteScript("default", OBJECT_SELF);
        return FALSE;
    }
    return nReturn;
}

int IsPerception()
{
  // Tricky. This gets called an extra time with no change
  if (IsObjectChanged(GetLastPerceived(),"LastPerceived"))
  {
    SetLocalInt(OBJECT_SELF,CHANGE_PREFIX_LOCAL+"ChangedPerception",TRUE);
    return TRUE;
  }
  else if (GetLocalInt(OBJECT_SELF,CHANGE_PREFIX_LOCAL+"ChangedPerception"))
  {
    SetLocalInt(OBJECT_SELF,CHANGE_PREFIX_LOCAL+"ChangedPerception",FALSE);
    return TRUE;
  }
  else
  {
    return FALSE;
  }
}

int IsPhysicalAttacked()
{
  DelayCommand(1.0, ClearChangeObject("LastAttacker"));
  return IsObjectChanged(GetLastAttacker(),"LastAttacker");
}

int IsRested()
{
  // Goes TRUE when Master starts resting
  return GetIsResting(GetMaster());
}

void SpawnPseudoHB()
{
    SetLocalInt(OBJECT_SELF, "default_heartbeat_event", TRUE);
    ExecuteScript("default", OBJECT_SELF);
    DelayCommand(6.0, SpawnPseudoHB());
}

int IsSpawn()
{
  if (!GetLocalInt(OBJECT_SELF,CHANGE_PREFIX_LOCAL+"OnSpawn"))
  {
    SetLocalInt(OBJECT_SELF,CHANGE_PREFIX_LOCAL+"OnSpawn",TRUE);
    DelayCommand(6.0, SpawnPseudoHB());
    return TRUE;
  }
  else return FALSE;
}

int IsSpellCastAt()
{
  DelayCommand(1.0, ClearChangeObject("LastSpellCaster"));
  return IsObjectChanged(GetLastSpellCaster(),"LastSpellCaster");
}

int IsUserDefined()
{
  DelayCommand(1.0, ClearChangeInt("UserDefinedEventNumber"));
  return IsIntChanged(GetUserDefinedEventNumber(),"UserDefinedEventNumber");
}

void ClearChangeObject(string sName)
{
    DeleteLocalObject(OBJECT_SELF,CHANGE_PREFIX_LOCAL+sName);
}

void ClearChangeInt(string sName)
{
    DeleteLocalInt(OBJECT_SELF,CHANGE_PREFIX_LOCAL+sName);
}

void ClearChangeString(string sName)
{
    DeleteLocalString(OBJECT_SELF,CHANGE_PREFIX_LOCAL+sName);
}

int IsObjectChanged(object oTest, string sName)
{
  if (oTest != GetLocalObject(OBJECT_SELF,CHANGE_PREFIX_LOCAL+sName))
  {
    SetLocalObject(OBJECT_SELF,CHANGE_PREFIX_LOCAL+sName,oTest);
    return TRUE;
  }
  else
  {
    return FALSE;
  }
}

int IsIntChanged(int iTest, string sName)
{
  if (iTest != GetLocalInt(OBJECT_SELF,CHANGE_PREFIX_LOCAL+sName))
  {
    SetLocalInt(OBJECT_SELF,CHANGE_PREFIX_LOCAL+sName,iTest);
    return TRUE;
  }
  else
  {
    return FALSE;
  }
}

int IsStringChanged(string sTest, string sName)
{
  if (sTest != GetLocalString(OBJECT_SELF,CHANGE_PREFIX_LOCAL+sName))
  {
    SetLocalString(OBJECT_SELF,CHANGE_PREFIX_LOCAL+sName,sTest);
    return TRUE;
  }
  else
  {
    return FALSE;
  }
}

void RunScript(string sEvent)
{
    string sScript = GetLocalString(OBJECT_SELF, CHANGE_PREFIX_LOCAL+sEvent);
    if(sScript != "")
    {
        ExecuteScript(sScript, OBJECT_SELF);
        return;
    }
    //do the default script
    else if(sEvent == "attacked")
        sScript = "prc_ai_mob_attck";
    else if(sEvent == "blocked")
        sScript = "prc_ai_mob_block";
    else if(sEvent == "combat")
        sScript = "prc_ai_mob_combt";
    else if(sEvent == "conv")
        sScript = "prc_ai_mob_conv";
    else if(sEvent == "damaged")
        sScript = "prc_ai_mob_damag";
    else if(sEvent == "death")
        sScript = "prc_ai_mob_death";
    else if(sEvent == "disturbed")
        sScript = "prc_ai_mob_distb";
    else if(sEvent == "heartbeat")
        sScript = "prc_ai_mob_heart";
    else if(sEvent == "perception")
        sScript = "prc_ai_mob_percp";
    else if(sEvent == "rested")
        sScript = "prc_ai_mob_rest";
    else if(sEvent == "spawned")
        sScript = "prc_ai_mob_spawn";
    else if(sEvent == "spellcast")
        sScript = "prc_ai_mob_spell";
    else if(sEvent == "user")
        sScript = "prc_ai_mob_userd";
    //run it
    ExecuteScript(sScript, OBJECT_SELF);
}
