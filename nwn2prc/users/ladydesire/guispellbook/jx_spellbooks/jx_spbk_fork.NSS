#include "jx_inc_script_call"
#include "jx_inc_spbk_const"
#include "jx_inc_spbk_data"
#include "jx_inc_spbk_impl"

void main()
{
	// Get the list of parameters
	struct script_param_list paramList = JXScriptGetParameters();
	// Get the operation to perform
	int iOperation = JXScriptGetForkOperation();

	switch (iOperation)
	{
		// Call the implementation of JXImplGetSpellList() defined in "jx_inc_spbk_list"
		case JX_FORK_SPBK_SPELLLIST:
			JXScriptSetResponseString(
				JXSpellsKnownToString(
					JXImplGetSpellList(
						JXScriptGetParameterInt(paramList, 1),
						JXScriptGetParameterInt(paramList, 2))));
			break;
	}
}