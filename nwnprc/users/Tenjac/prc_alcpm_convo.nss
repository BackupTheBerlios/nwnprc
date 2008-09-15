////////////////////////////////////////////////////
// Craft Poison or Alchemical Item
// prc_alcpm_convo.nss
////////////////////////////////////////////////////


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY                           =   0;
const int STAGE_POISON                          =   1;
const int STAGE_ALCHEM                          =   2;



#include "inc_dynconv"

void main()
{
        object oPC = GetPCSpeaker();
        int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
        int nStage = GetStage(oPC);        
        
        if(nValue == DYNCONV_SETUP_STAGE)
        {
                if(!GetIsStageSetUp(nStage, oPC))
                {
                        if(nStage == STAGE_ENTRY)
                        {
                                SetHeader("What do you want to do?");
                                AddChoice("Craft a poison.", 1);
                                AddChoice("Craft an alchemical item.", 2);
                                
                                MarkStageSetUp(nStage, oPC);
                                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
                        }
                        
                        else if (nStage == STAGE_POISON)
                        {
                                //Poison                          
                                SetHeader("What type of poison would you like to craft?");
                                
                                //Poisons, alphabetically
                                AddChoice("Arsenic", 1);
                                AddChoice("Balor Bile", 2);
                                AddChoice("Bebilith Venom", 3);
                                AddChoice("Black Adder Venom", 4);
                                AddChoice("Black Lotus Extract", 5);
                                AddChoice("Bloodroot", 6);
                                AddChoice("Blue Whinnis", 7);
                                AddChoice("Burning Angel Wing Fumes", 8);
                                AddChoice("Burnt Othur Fumes", 9);
                                AddChoice("Carrion Crawler Brain Juice", 10);
                                AddChoice("Centipede Poison - Tiny", 11);
                                AddChoice("Centipede Poison - Small", 12);
                                AddChoice("Centipede Poison - Medium", 13);
                                AddChoice("Centipede Poison - Large", 14);
                                AddChoice("Centipede Poison - Huge", 15);
                                AddChoice("Centipede Poison - Gargantuan", 16);
                                AddChoice("Centipede Poison - Colossal", 17);
                                AddChoice("Chaos Mist", 18);
                                AddChoice("Dark Reaver Powder", 19);
                                AddChoice("Deathblade", 20);
                                AddChoice("Dragon Bile", 21);
                                AddChoice("Eyeblast", 22);
                                AddChoice("Giant Wasp Poison", 23);
                                AddChoice("Greenblood Oil", 24);
                                AddChoice("Id Moss", 25);
                                AddChoice("Ishentav", 26);
                                AddChoice("Lich Dust", 27);
                                AddChoice("Malyss Root Paste", 28);
                                AddChoice("Mist of Nourn", 29);
                                AddChoice("Nightshade", 30);
                                AddChoice("Nitharit", 31);
                                AddChoice("Oil of Taggit", 32);
                                AddChoice("Purple Worm Poison", 33);
                                AddChoice("Ravage - Celestial Ligthsblood", 34);
                                AddChoice("Ravage - Golden Ice", 35);
                                AddChoice("Ravage - Jade Water", 36);
                                AddChoice("Ravage - Purified Couatl Venom", 37);
                                AddChoice("Ravage - Unicorn Blood", 38);
                                AddChoice("Sasson Juice", 39);
                                AddChoice("Sasson Leaf Residue", 40);
                                AddChoice("Scorpion Vemon - Tiny", 41);
                                AddChoice("Scorpion Venom - Small", 42);
                                AddChoice("Scorpion Venom - Medium", 43);
                                AddChoice("Scorpion Venom - Large", 44);
                                AddChoice("Scorpion Venom - Huge", 45);
                                AddChoice("Scorpion Venom - Gargantuan", 46);
                                AddChoice("Scorpion Venom - Colossal", 47);
                                AddChoice("Shadow Essence", 48);
                                AddChoice("Spider Venom - Tiny", 49);
                                AddChoice("Spider Venom - Small", 50);
                                AddChoice("Spider Venom - Medium", 51);
                                AddChoice("Spider Venom - Large", 52);
                                AddChoice("Spider Venom - Huge", 53);
                                AddChoice("Spider Venom - Gargantuan", 54);
                                AddChoice("Spider Venom - Colossal", 55);
                                AddChoice("Striped Toadstool", 56);
                                AddChoice("Sufferfume", 57);
                                AddChoice("Terinav Root", 58);
                                AddChoice("Ungol Dust", 59);
                                AddChoice("Urthanyk", 60);
                                AddChoice("Vilestar", 61);
                                AddChoice("Wyvern Poison", 62);
                                AddChoice("Wyvern Poison - Epic", 63);
                                
                                MarkStageSetUp(nStage, oPC);
                                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values                                                       
                        }
                        
                        else if (nStage == STAGE_ALCHEM)
                        {
                                SetHeader("What alchemical item would you like to craft?");                              
                                
                                AddChoice("Acid Flask", 1);
                                AddChoice("Acidic Fire",2);
                                AddChoice("Agony",3);
                                AddChoice("Alchemical Sleep Gas",4);
                                AddChoice("Alchemist's Fire",5);
                                AddChoice("Alchemist's Frost",6);
                                AddChoice("Alchemist's Spark",7);
                                AddChoice("Antitoxin",8);
                                AddChoice("Baccaran",9);
                                AddChoice("Bile Droppings",10);
                                AddChoice("Blend Cream",11);
                                AddChoice("Brittlebone",12);
                                AddChoice("Crackle Powder",13);
                                AddChoice("Devilweed",14);
                                AddChoice("Embalming Fire",15);
                                AddChoice("Fareye Oil",16);
                                AddChoice("Festering Bomb",17);
                                AddChoice("Flash Pellet",18);
                                AddChoice("Healer's Balm",19);
                                AddChoice("Keenear Powder",20);
                                AddChoice("Lockslip Grease",21);
                                AddChoice("Luhix",22);
                                AddChoice("Mushroom Powder",23);
                                AddChoice("Nature's Draught",24);
                                AddChoice("Nerv",25);
                                AddChoice("Sannish",26);
                                AddChoice("Screaming Flask",27);
                                AddChoice("Shedden",28);
                                AddChoice("Shedden +2",29);
                                AddChoice("Shedden +3",30);
                                AddChoice("Shedden +4",31);
                                AddChoice("Shedden +5",32);
                                AddChoice("Softfoot",33);
                                AddChoice("Tanglefoot Bag",34);
                                AddChoice("Terran Brandy",35);
                                AddChoice("Thunderstone",36);
                                AddChoice("Vodare",37);
                                AddChoice("Weeping Stone",38);
                                
                                MarkStageSetUp(nStage, oPC);
                                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values                        
                        }                  
                }                
        }
        else if(nValue == DYNCONV_EXITED)
        {
                if(DEBUG) DoDebug("prc_alcom_convo: Running exit handler");
                // End of conversation cleanup
                DeleteLocalObject(oPC, PRC_CRAFT_ITEM);
                DeleteLocalInt(oPC, PRC_CRAFT_TYPE);
                DeleteLocalString(oPC, PRC_CRAFT_SUBTYPE);
                DeleteLocalInt(oPC, PRC_CRAFT_SUBTYPEVALUE);
                DeleteLocalString(oPC, PRC_CRAFT_COSTTABLE);
                DeleteLocalInt(oPC, PRC_CRAFT_COSTTABLEVALUE);
                DeleteLocalString(oPC, PRC_CRAFT_PARAM1);
                DeleteLocalInt(oPC, PRC_CRAFT_PARAM1VALUE);
                DeleteLocalInt(oPC, PRC_CRAFT_PROPLIST);
                DeleteLocalString(oPC, PRC_CRAFT_TAG);
                DeleteLocalInt(oPC, PRC_CRAFT_AC);
                DeleteLocalInt(oPC, PRC_CRAFT_BASEITEMTYPE);
                DeleteLocalInt(oPC, PRC_CRAFT_COST);
                DeleteLocalInt(oPC, PRC_CRAFT_XP);
                DeleteLocalInt(oPC, PRC_CRAFT_TIME);
                DeleteLocalInt(oPC, PRC_CRAFT_MATERIAL);
                DeleteLocalInt(oPC, PRC_CRAFT_MIGHTY);
                DeleteLocalInt(oPC, PRC_CRAFT_SCRIPT_STATE);
                DestroyObject(oNewItem, 0.1);
                DeleteLocalInt(oPC, PRC_CRAFT_TAG);
                DeleteLocalInt(oPC, PRC_CRAFT_MAGIC_ENHANCE);
                DeleteLocalInt(oPC, PRC_CRAFT_MAGIC_ADDITIONAL);
                DeleteLocalInt(oPC, PRC_CRAFT_MAGIC_EPIC);
                DeleteLocalInt(oPC, PRC_CRAFT_LINE);
                DeleteLocalString(oPC, PRC_CRAFT_FILE);
                DeleteLocalInt(oPC, PRC_CRAFT_SPECIAL_BANE);
                DeleteLocalInt(oPC, PRC_CRAFT_SPECIAL_BANE_RACE);
                DeleteLocalInt(oPC, PRC_CRAFT_TOKEN);
        }
        
        else
        {
                //Handle response
                int nChoice = GetChoice(oPC);
                switch(nStage)
                
                case STAGE_POISON:
                {
                         int nPoison = GetSkillRank(SKILL_CRAFT_POISON, oPC);
                         int nAlchem = GetSkillRank(SKILL_CRAFT_ALCHEMY, oPC);                                
                         int nSkill = SKILL_CRAFT_POISON;
                         if((nAlchem - nPoison) >4) nSkill = SKILL_CRAFT_ALCHEMY;
                         int nCost;
                         int nDC;
                         string sItem;
                         
                         if(nChoice == 1)
                         {
                                 sItem = "2dapoison023";
                                 nCost = 60;
                                 nDC = 15;
                         }
                         
                         else if(nChoice == 2)
                         {
                                 sItem = "2dapoison135";
                                 nCost = 500;
                                 nDC = 25;
                         }
                                                  
                         else if(nChoice == 3)
                         {
                                 sItem = "2dapoison029";
                                 nCost = 450;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 4)
                         {
                                 sItem = "2dapoison011";
                                 nCost = 60;
                                 nDC = 15;
                         }
                         
                         else if(nChoice == 5)
                         {
                                 sItem = "2dapoison019";
                                 nCost = 2250;
                                 nDC = 35;
                         }
                         
                         else if(nChoice == 6)
                         {
                                 sItem = "2dapoison004";
                                 nCost = 50;
                                 nDC = 15;
                         }                         
                         
                         else if(nChoice == 7)
                         {
                                 sItem = "2dapoison008";
                                 nCost = 60;
                                 nDC = 15;
                         }
                         
                         else if(nChoice == 8)
                         {
                                 sItem = "2dapoison142";
                                 nCost = 1400;
                                 nDC = 27;
                         }
                         
                         else if(nChoice == 9)
                         {
                                 sItem = "2dapoison027";
                                 nCost = 1050;
                                 nDC = 25;
                         }
                         
                         else if(nChoice == 10)
                         {
                                 sItem = "2dapoison018";
                                 nCost = 100;
                                 nDC = 15;
                         }
                         
                         else if(nChoice == 11)
                         {
                                 sItem = "2dapoison122";
                                 nCost = 20;
                                 nDC = 15;
                         }
                         
                         else if(nChoice == 12)
                         {
                                 sItem = "2dapoison001";
                                 nCost = 45;
                                 nDC = 15;
                         }
                         
                         else if(nChoice == 13)
                         {
                                 sItem = "2dapoison123";
                                 nCost = 55;
                                 nDC = 15;
                         }
                         
                         else if(nChoice == 14)
                         {
                                 sItem = "2dapoison124";
                                 nCost = 75;
                                 nDC = 18;
                         }
                         
                         else if(nChoice == 15)
                         {
                                 sItem = "2dapoison125";
                                 nCost = 105;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 16)
                         {
                                 sItem = "2dapoison126";
                                 nCost = 475;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 17)
                         {
                                 sItem = "2dapoison127";
                                 nCost = 1450;
                                 nDC = 30;
                         }
                         
                         else if(nChoice == 18)
                         {
                                 sItem = "2dapoison028";
                                 nCost = 400;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 19)
                         {
                                 sItem = "2dapoison025";
                                 nCost = 150;
                                 nDC = 25;
                         }
                         
                         else if(nChoice == 20)
                         {
                                 sItem = "2dapoison012";
                                 nCost = 900;
                                 nDC = 25;
                         }
                         
                         else if(nChoice == 21)
                         {
                                 sItem = "2dapoison015";
                                 nCost = 750;
                                 nDC = 30;
                         }                                                  
                         
                         else if(nChoice == 22)
                         {
                                 sItem = "2dapoison134";
                                 nCost = 250;
                                 nDC = 23;
                         }
                                                  
                         else if(nChoice == 23)
                         {
                                 sItem = "2dapoison009";
                                 nCost = 105;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 24)
                         {
                                 sItem = "2dapoison003";
                                 nCost = 50;
                                 nDC = 15;
                         }
                                                  
                         else if(nChoice == 25)
                         {
                                 sItem = "2dapoison021";
                                 nCost = 63;
                                 nDC = 15;
                         }
                         
                         else if(nChoice == 26)
                         {
                                 sItem = "2dapoison141";                                 
                                 nCost = 250;
                                 nDC = 25;
                         }
                         
                         else if(nChoice == 27)
                         {
                                 sItem = "2dapoison024";
                                 nCost = 125;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 28)
                         {
                                 sItem = "2dapoison013";
                                 nCost = 250;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 29)
                         {
                                 sItem = "2dapoison140";
                                 nCost = 3500;
                                 nDC = 35;
                         }
                         
                         else if(nChoice == 30)
                         {
                                 sItem = "2dapoison000";
                                 nCost = 50;
                                 nDC = 15;
                         }
                         
                         else if(nChoice == 31)
                         {
                                 sItem = "2dapoison014";
                                 nCost = 325;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 32)
                         {
                                 sItem = "2dapoison020";
                                 nCost = 45;
                                 nDC = 15;
                         }
                         
                         else if(nChoice == 33)
                         {
                                 sItem = "2dapoison005";
                                 nCost = 350;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 34)
                         {
                                 sItem = "2dapoison143";
                                 nCost = 1250;
                                 nDC = 28;
                         }
                         
                         else if(nChoice == 35)
                         {
                                 sItem = "2dapoison100";
                                 nCost = 600;
                                 nDC = 25;
                         }
                                 
                         else if(nChoice == 36)
                         {
                                 sItem = "2dapoison144";
                                 nCost = 175;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 37)
                         {
                                 sItem = "2dapoison145";
                                 nCost = 1500;
                                 nDC = 34;
                         }
                         
                         else if(nChoice == 38)
                         {
                                 sItem = "2dapoison146";
                                 nCost = 250;
                                 nDC = 20;
                         }
                                                  
                         else if(nChoice == 39)
                         {
                                 sItem = "2dapoison137";
                                 nCost = 250;
                                 nDC = 22;
                         }
                         
                         else if(nChoice == 40)
                         {
                                 sItem = "2dapoison016";
                                 nCost = 150;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 41)
                         {
                                 sItem = "2dapoison128";
                                 nCost = 45;
                                 nDC = 15;
                         }
                         
                         else if(nChoice == 42)
                         {
                                 sItem = "2dapoison129";
                                 nCost = 50;
                                 nDC = 15;
                         }
                         
                         else if(nChoice == 43)
                         {
                                 sItem = "2dapoison130";
                                 nCost = 88;
                                 nDC = 18;
                         }
                         
                         else if(nChoice == 44)
                         {
                                 sItem = "2dapoison006";
                                 nCost = 100;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 45)
                         {
                                 sItem = "2dapoison131";
                                 nCost = 600;
                                 nDC = 25;
                         }
                         
                         else if(nChoice == 46)
                         {
                                 sItem = "2dapoison132";
                                 nCost = 1500;
                                 nDC = 32;
                         }
                         
                         else if(nChoice == 47)
                         {
                                 sItem = "2dapoison133";
                                 nCost = 4500;
                                 nDC = 35;
                         }
                         
                         else if(nChoice == 48)
                         {
                                 sItem = "2dapoison010";
                                 nCost = 125;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 49)
                         {
                                 sItem = "2dapoison034";
                                 nCost = 45;
                                 nDC = 15;
                         }
                         
                         else if(nChoice == 50)
                         {
                                 sItem = "2dapoison035";
                                 nCost = 50;
                                 nDC = 15;
                         }
                         
                         else if(nChoice == 51)
                         {
                                 sItem = "2dapoison036";
                                 nCost = 75;
                                 nDC = 18;
                         }
                         
                         else if(nChoice == 52)
                         {
                                 sItem = "2dapoison037";
                                 nCost = 88;
                                 nDC = 18;
                         }
                         
                         else if(nChoice == 53)
                         {
                                 sItem = "2dapoison038";
                                 nCost = 500;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 54)
                         {
                                 sItem = "2dapoison039";
                                 nCost = 1250;
                                 nDC = 26;
                         }
                         
                         else if(nChoice == 55)
                         {
                                 sItem = "2dapoison040";
                                 nCost = 1500;
                                 nDC = 28;
                         }
                         
                         else if(nChoice == 56)
                         {
                                 sItem = "2dapoison022";
                                 nCost = 90;
                                 nDC = 15;
                         }
                         
                         else if(nChoice == 57)
                         {
                                 sItem = "2dapoison138";
                                 nCost = 600;
                                 nDC = 21;
                         }
                         
                         else if(nChoice == 58)
                         {
                                 sItem = "2dapoison017";
                                 nCost = 375;
                                 nDC = 25;
                         }
                         
                         else if(nChoice == 59)
                         {
                                 sItem = "2dapoison026";
                                 nCost = 500;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 60)
                         {
                                 sItem = "2dapoison139";
                                 nCost = 1000;
                                 nDC = 26;
                         }
                         
                         else if(nChoice == 61)
                         {
                                 sItem = "2dapoison136";
                                 nCost = 3000;
                                 nDC = 34;
                         }
                         
                         else if(nChoice == 62)
                         {
                                 sItem = "2dapoison007";
                                 nCost = 1500;
                                 nDC = 25;
                         }
                         
                         else if(nChoice == 63)
                         {
                                 sItem = "2dapoison044";
                                 nCost = 3000;
                                 nDC = 34;
                         }
                 }
                 case STAGE_ALCHEM:
                 {
                         
                         if(nChoice == 1)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 2)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 3)
                         {
                                 sItem = "";
                                 nCost = 100;
                                 nDC = 25;
                         }
                         
                         else if(nChoice == 4)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 5)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 6)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 7)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 8)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 9)
                         {
                                 sItem = "";
                                 nCost = 5;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 10)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 11)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 12)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 13)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 14)
                         {
                                 sItem = "";
                                 nCost = 3;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 15)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 16)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 17)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 18)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 19)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 20)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 21)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 22)
                         {
                                 sItem = "";
                                 nCost = 1000;
                                 nDC = 30;
                         }
                         
                         else if(nChoice == 23)
                         {
                                 sItem = "";
                                 nCost = 50;
                                 nDC = 25;
                         }
                         
                         else if(nChoice == 24)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 25)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 26)
                         {
                                 sItem = "";
                                 nCost = 8;
                                 nDC = 20;
                         }
                         
                         else if(nChoice == 27)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 28)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 29)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 30)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 31)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 32)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 33)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 34)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 35)
                         {
                                 sItem = "";
                                 nCost = 250;
                                 nDC = 30;
                         }
                         
                         else if(nChoice == 36)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }
                         
                         else if(nChoice == 37)
                         {
                                 sItem = "";
                                 nCost = 20;
                                 nDC = 15;
                         }
                         
                         else if(nChoice == 38)
                         {
                                 sItem = "";
                                 nCost = ;
                                 nDC = ;
                         }             
        }
}