#include "jx_inc_spbk_const"


void main(string sDataString)
{
	object oPC = OBJECT_SELF;

	// Start the drag & drop process
	SetLocalString(oPC, JX_UI_MOUSESTARTDRAG, sDataString);
}