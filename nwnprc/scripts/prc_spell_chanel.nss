#include "prc_alterations"
#include "prc_class_const"
#include "x2_inc_switches"
#include "x2_inc_spellhook"

const int SPELL_SPELLSWORD_CHANNELSPELL = 1700;


//This function runs whenever a spell is cast.
void main()
{
/*
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
    object oWeapon = PRCGetSpellTargetObject();


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
        int nClevel =PRCGetCasterLevel(oPC);
        int nFeat = PRCGetMetaMagicFeat();


        //If there are charges left for the day, we apply the temporary item property
        //on hit cast spell (with a 10 RL hours duration) and mark the weapon with a local int
        //so that we can find out if there is a spell stored on the weapon.
        float fDuration = HoursToSeconds(10.0);

        //Here we check if the spellsword has the multiple channel spell ability
        //and store the spell on the weapon with the StoreSpells function.
        //If there are multiple channels, we inform the function in which order
        //they are stored with the help of a local integer.
        if(iLevel >= 4 && iLevel < 10)
        {
            StoreSpell(fDuration, nSpell, oWeapon, oPC, nFeat);
        }
        else if(iLevel >= 10 && iLevel < 20)
        {
            int mSpell = GetLocalInt(oPC,"multispell");
            if(mSpell == 0)
            {
                StoreSpell(fDuration, nSpell, oWeapon, oPC, nFeat);
                SetLocalInt(oPC,"multispell",1);
            }
            else if(mSpell == 1)
            {
                StoreSpell(fDuration, nSpell, oWeapon, oPC, nFeat);
                SetLocalInt(oPC,"multispell",0);
            }
        }
        else if(iLevel >= 20 && iLevel < 30)
        {
            int mSpell = GetLocalInt(oPC,"multispell");
            if(mSpell == 0)
            {
                StoreSpell(fDuration, nSpell, oWeapon, oPC, nFeat);
                SetLocalInt(oPC,"multispell",1);
            }
            else if(mSpell == 1)
            {
                StoreSpell(fDuration, nSpell, oWeapon, oPC, nFeat);
                SetLocalInt(oPC,"multispell",2);
            }
            else if(mSpell == 2)
            {
                StoreSpell(fDuration, nSpell, oWeapon, oPC, nFeat);
                SetLocalInt(oPC,"multispell",0);
            }
        }
        else if(iLevel == 30)
        {
            int mSpell = GetLocalInt(oPC,"multispell");
            if(mSpell == 0)
            {
                StoreSpell(fDuration, nSpell, oWeapon, oPC, nFeat);
                SetLocalInt(oPC,"multispell",1);
            }
            else if(mSpell == 1)
            {
                StoreSpell(fDuration, nSpell, oWeapon, oPC, nFeat);
                SetLocalInt(oPC,"multispell",2);
            }
            else if(mSpell == 2)
            {
                StoreSpell(fDuration, nSpell, oWeapon, oPC, nFeat);
                SetLocalInt(oPC,"multispell",3);
            }
            else if(mSpell == 3)
            {
                StoreSpell(fDuration, nSpell, oWeapon, oPC, nFeat);
                SetLocalInt(oPC,"multispell",0);
            }
        }

        //This stops the original spellscript (and all craft item code)
        // from being executed.
        //PRCSetUserSpecificSpellScriptFinished();
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
        nUses -= 1;
        FloatingTextStringOnCreature("Spell stored, "+IntToString(nUses)+" uses remaining.",oPC);
        SetPersistantLocalInt(oPC, "spellswordchannelcharges", nUses);
    }
*/    
}
