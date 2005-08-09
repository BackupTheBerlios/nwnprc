#include "x2_inc_itemprop"
#include "prc_class_const"
#include "prc_alterations"
#include "x2_inc_switches"
#include "x2_inc_spellhook"

const int SPELL_SPELLSWORD_CHANNELSPELL = 1700;

//This function gets the Spell ID of the stored spell, the caster level of the
//spellsword the weapon that stores the spell and if there are multiple channels,
//in witch order will they be released.

void StoreSpells (int nSpell ,
    int nClevel ,
    object oWeapon ,
    object oPC ,
    string sSpellString,
    int nFeat)
{


    //If there are charges left for the day, we apply the temporary item property
    //on hit cast spell (with a 10 RL hours duration) and mark the weapon with a local int
    //so that we can find out if there is a spell stored on the weapon.
    string sSpellScript = Get2DACache("spells","ImpactScript",nSpell);
    itemproperty ipTest = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,nClevel);
    IPSafeAddItemProperty(oWeapon,ipTest,36000.0);
    SetLocalInt(oWeapon,"spell",1);

    //we store the script of the spell channeled and its metamagic feat on the weapon.
    SetLocalString(oWeapon,"spellscript"+sSpellString,sSpellScript);
    SetLocalInt(oWeapon,"metamagic_feat_"+sSpellString,nFeat);

}


//This function runs whenever a spell is cast.
void main()
{
    object oPC = OBJECT_SELF;
    int iLevel = GetLevelByClass(CLASS_TYPE_SPELLSWORD,oPC);

    //If the caster is not a spellsword of at least fourth level we do nothing.
    if(iLevel < 4)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
        return;
    }

    //These are the channel spell charges for the day
    int nUses = GetPersistantLocalInt(oPC,"spellswordchannelcharges");
    if(nUses == 0)
    {
        FloatingTextStringOnCreature("You have no Channel Spell uses remaining.",oPC);
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
        return;    
    }
    //If the caster is a spellsword of at least fourth level, we get the
    //target of the spell casted.
    object oWeapon = GetSpellTargetObject();


    if ((oWeapon == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC) 
            || oWeapon == GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC))
        && !GetIsObjectValid(GetSpellCastItem()))
    {
        //weapon buffs are never stored
        if(X2CastOnItemWasAllowed(oWeapon))
        {            
            SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
            return;
        }    
        
        //If the target is an equiped ranged weapon, we inform the spellsword
        //that channeling doesnt work with ranged weapons and exit the function
        if(!IPGetIsMeleeWeapon(oWeapon))
        {
            FloatingTextStringOnCreature("Spell Channeling does not work with anything other than melee weapons",oPC);
            //DelayCommand(1.5,FloatingTextStringOnCreature("Equip a melee weapon and try again",oPC));
            //PRCSetUserSpecificSpellScriptFinished();
            SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
            return;
        }

        //If the target is an equiped melee weapon, we get the spell ID of the casted
        //spell the caster level of the spellsword and the metamagic feat.
        int nSpell = GetSpellId();
        int nClevel =(PRCGetCasterLevel(oPC));
        int nFeat = PRCGetMetaMagicFeat();



        //Here we check if the spellsword has the multiple channel spell ability
        //and store the spell on the weapon with the StoreSpells function.
        //If there are multiple channels, we inform the function in which order
        //they are stored with the help of a local integer.
        if(iLevel >= 4 && iLevel < 10)
        {
            StoreSpells (nSpell ,nClevel ,oWeapon , oPC,"1", nFeat);
        }
        else if(iLevel >= 10 && iLevel < 20)
        {
            int mSpell = GetLocalInt(oPC,"multispell");
            if(mSpell == 0)
            {
                StoreSpells(nSpell ,nClevel ,oWeapon , oPC,"1", nFeat);
                SetLocalInt(oPC,"multispell",1);
            }
            else if(mSpell == 1)
            {
                StoreSpells(nSpell ,nClevel ,oWeapon , oPC,"2", nFeat);
                SetLocalInt(oPC,"multispell",0);
            }
        }
        else if(iLevel >= 20 && iLevel < 30)
        {
            int mSpell = GetLocalInt(oPC,"multispell");
            if(mSpell == 0)
            {
                StoreSpells(nSpell ,nClevel ,oWeapon , oPC,"1", nFeat);
                SetLocalInt(oPC,"multispell",1);
            }
            else if(mSpell == 1)
            {
                StoreSpells(nSpell ,nClevel ,oWeapon , oPC,"2", nFeat);
                SetLocalInt(oPC,"multispell",2);
            }
            else if(mSpell == 2)
            {
                StoreSpells(nSpell ,nClevel ,oWeapon , oPC,"3", nFeat);
                SetLocalInt(oPC,"multispell",0);
            }
        }
        else if(iLevel == 30)
        {
            int mSpell = GetLocalInt(oPC,"multispell");
            if(mSpell == 0)
            {
                StoreSpells(nSpell ,nClevel ,oWeapon , oPC,"1", nFeat);
                SetLocalInt(oPC,"multispell",1);
            }
            else if(mSpell == 1)
            {
                StoreSpells(nSpell ,nClevel ,oWeapon , oPC,"2", nFeat);
                SetLocalInt(oPC,"multispell",2);
            }
            else if(mSpell == 2)
            {
                StoreSpells(nSpell ,nClevel ,oWeapon , oPC,"3", nFeat);
                SetLocalInt(oPC,"multispell",3);
            }
            else if(mSpell == 3)
            {
                StoreSpells(nSpell ,nClevel ,oWeapon , oPC,"4", nFeat);
                SetLocalInt(oPC,"multispell",0);
            }
        }
        /*
        effect eVis = GetFirstEffect(oPC);
        while(GetIsEffectValid(eVis))
        {
            if(GetEffectSpellId(eVis) == SPELL_SPELLSWORD_CHANNELSPELL) // prc_chan_feat.nss
            {
                RemoveEffect(oPC,eVis);
            }
            eVis = GetNextEffect(oPC);
        }*/


        //This stops the original spellscript (and all craft item code)
        // from being executed.
        //PRCSetUserSpecificSpellScriptFinished();
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
        nUses -= 1;
        FloatingTextStringOnCreature("Spell stored, "+IntToString(nUses)+" uses remaining.",oPC);
        SetPersistantLocalInt(oPC, "spellswordchannelcharges", nUses);
        //FloatingTextStringOnCreature("Channeling Deactivated",OBJECT_SELF);
        //PRCSetUserSpecificSpellScript(GetLocalString(OBJECT_SELF,"ovscript"));
    }
}
