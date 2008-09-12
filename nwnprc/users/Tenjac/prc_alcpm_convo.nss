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
                                int nPoison = GetSkillRank(SKILL_CRAFT_POISON, oPC);
                                int nAlchem = GetSkillRank(SKILL_CRAFT_ALCHEMY, oPC);                                
                                int nSkill = SKILL_CRAFT_POISON;
                                if((nAlchem - nPoison) >4) nSkill = SKILL_CRAFT_ALCHEMY;
                                
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
                                
                                
                                
                                MarkStageSetUp(nStage, oPC);
                                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
                        
                        }
                }
        }
}