//::///////////////////////////////////////////////
//:: Magic descriptors and subschools include
//:: prc_inc_descrptr
//::///////////////////////////////////////////////
/** @file prc_inc_descrptr
    A set of constants and functions for managing
    spell's / power's / other stuffs's descriptors
    and sub{school|discipline|whatever}s.

    The functions SetDescriptor() and SetSubschool()
    should be called at the beginning of the
    spellscript, before spellhook or equivalent.

    The values are stored on the module object and
    are automatically cleaned up after script
    execution terminates (ie, DelayCommand(0.0f)).
    This is a potential gotcha, as the descriptor
    and subschool data will no longer be available
    during the spell's delayed operations. An
    ugly workaround would be to set the descriptor
    values again in such cases.
    If you come up with an elegant solution, please
    try to generalise it and change this as needed.


    @author Ornedan
    @date   Created - 2006.06.30
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

// The descriptor and subschool constants are bit flags for easy combination and lookup
const int DESCRIPTOR_ACID              = 0x00001;
const int DESCRIPTOR_AIR               = 0x00002;
const int DESCRIPTOR_CHAOTIC           = 0x00004;
const int DESCRIPTOR_COLD              = 0x00008;
const int DESCRIPTOR_DARKNESS          = 0x00010;
const int DESCRIPTOR_DEATH             = 0x00020;
const int DESCRIPTOR_EARTH             = 0x00040;
const int DESCRIPTOR_ELECTRICITY       = 0x00080;
const int DESCRIPTOR_EVIL              = 0x00100;
const int DESCRIPTOR_FEAR              = 0x00200;
const int DESCRIPTOR_FIRE              = 0x00400;
const int DESCRIPTOR_FORCE             = 0x00800;
const int DESCRIPTOR_GOOD              = 0x01000;
const int DESCRIPTOR_LANGUAGEDEPENDENT = 0x02000;
const int DESCRIPTOR_LAWFUL            = 0x04000;
const int DESCRIPTOR_LIGHT             = 0x08000;
const int DESCRIPTOR_MINDAFFECTING     = 0x10000;
const int DESCRIPTOR_SONIC             = 0x20000;
const int DESCRIPTOR_WATER             = 0x40000;

const int SUBSCHOOL_CALLING            = 0x00001;
const int SUBSCHOOL_CREATION           = 0x00002;
const int SUBSCHOOL_HEALING            = 0x00004;
const int SUBSCHOOL_SUMMONING          = 0x00008;
const int SUBSCHOOL_TELEPORTATION      = 0x00010;
const int SUBSCHOOL_SCRYING            = 0x00020;
const int SUBSCHOOL_CHARM              = 0x00040;
const int SUBSCHOOL_COMPULSION         = 0x00080;
const int SUBSCHOOL_FIGMENT            = 0x00100;
const int SUBSCHOOL_GLAMER             = 0x00200;
const int SUBSCHOOL_PATTERN            = 0x00400;
const int SUBSCHOOL_PHANTASM           = 0x00800;
const int SUBSCHOOL_SHADOW             = 0x01000;


const string PRC_DESCRIPTOR = "PRC_DescriptorFlagStore";
const string PRC_SUBSCHOOL  = "PRC_SubschoolFlagStore";


//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

/**
 * Sets the descriptor of currently being cast spell / power / whatever
 * to be the given value. This should be called before spellhook / powerhook
 * / whateverhook.
 *
 * If the magic in question has multiple descriptors, they should be OR'd together.
 * For example, Phantasmal Killer would call the function thus:
 *  SetDescriptor(DESCRIPTOR_FEAR | DESCRIPTOR_MINDAFFECTING);
 *
 * @param nfDescriptorFlags The descriptors of a spell / power / X being currently used
 */
void SetDescriptor(int nfDescriptorFlags);

/**
 * Sets the subschool / subdiscipline / subwhatever of currently being cast
 * spell / power / whatever to be the given value. This should be called before
 * spellhook / powerhook / whateverhook.
 *
 * If the magic in question has multiple descriptors, they should be OR'd together.
 * For example, Mislead would call the function thus:
 *  SetDescriptor(SUBSCHOOL_FIGMENT | SUBSCHOOL_GLAMER);
 *
 * @param nfSubschoolFlags The subschools of a spell / power / X being currently used
 */
void SetSubschool(int nfSubschoolFlags);

/**
 * Tests whether a magic being currently used has the given descriptor.
 *
 * NOTE: Multiple descriptors may be tested for at once. If so, the return value
 * will be true only if all the descriptors tested for are present. Doing so is
 * technically a misuse of this function.
 *
 *
 * @param nDescriptorFlag The descriptor to test for
 * @return                TRUE if the magic being used has the given descriptor(s), FALSE otherwise
 */
int GetHasDescriptor(int nDescriptorFlag);

/**
 * Tests whether a magic being currently used is of the given subschool.
 *
 * NOTE: Multiple subschools may be tested for at once. If so, the return value
 * will be true only if all the subschools tested for are present. Doing so is
 * technically a misuse of this function.
 *
 *
 * @param nDescriptorFlag The subschool to test for
 * @return                TRUE if the magic being used is of the given subschool(s), FALSE otherwise
 */
int GetIsOfSubschool(int nSubschoolFlag);

/**
 * Returns an integer value containing the bitflags set in the call to SetDescriptor() at the
 * beginning of the spellscript being currently executed.
 *
 * @return The raw integer value, as read from the module object
 */
int GetDescriptorFlags();

/**
 * Returns an integer value containing the bitflags set in the call to SetSubschool() at the
 * beginning of the spellscript being currently executed.
 *
 * @return The raw integer value, as read from the module object
 */
int GetSubschoolFlags();


//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

void SetDescriptor(int nfDescriptorFlags)
{
    object oModule = GetModule();
    // Store the value
    SetLocalInt(oModule, PRC_DESCRIPTOR, nfDescriptorFlags);

    // Queue cleanup. No duplicacy checks, this function is not particularly likely to be called more than once anyway
    DelayCommand(0.0f, DeleteLocalInt(oModule, PRC_DESCRIPTOR));
}

void SetSubschool(int nfSubschoolFlags)
{
    object oModule = GetModule();
    // Store the value
    SetLocalInt(oModule, PRC_SUBSCHOOL, nfSubschoolFlags);

    // Queue cleanup. No duplicacy checks, this function is not particularly likely to be called more than once anyway
    DelayCommand(0.0f, DeleteLocalInt(oModule, PRC_SUBSCHOOL));
}

int GetHasDescriptor(int nDescriptorFlag)
{
    // Normalise return value to TRUE / FALSE
    return !!(GetLocalInt(GetModule(), PRC_DESCRIPTOR) & nDescriptorFlag);
}

int GetIsOfSubschool(int nSubschoolFlag)
{
    // Normalise return value to TRUE / FALSE
    return !!(GetLocalInt(GetModule(), PRC_SUBSCHOOL) & nSubschoolFlag);
}

int GetDescriptorFlags()
{
    return GetLocalInt(GetModule(), PRC_DESCRIPTOR);
}

int GetSubschoolFlags()
{
    return GetLocalInt(GetModule(), PRC_SUBSCHOOL);
}

// Test main
//void main(){}
