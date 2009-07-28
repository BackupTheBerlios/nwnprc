Player Resource Consortium CEP1 Merge
=====================================

This contains the merges for combining PRC with the CEP1.

Merging the PRC with CEP 1.69 requires pstmarie's CEP 1.69 update and CEP 1.68. The update can be found here: http://nwvault.ign.com/View.php?view=Hakpaks.Detail&id=7517

Installation Instructions
-------------------------

The merge comes in two formats. Either a self-extracting version designed for windows users and a rar version for manual installation. It requires the PRC (3.2) and CEP (1.69 and/or 2.1) to be installed first.

Automatic Installation

The self-extracting file should automatically place the files in their correct locations.

Manual Installation

.hak & .hif files go in your hak directory
.tlk files go in your tlk directory

Adding the merge to a module
----------------------------

Once you have done the installation, the next step is to add the merge to your module. Note, this will not affect saved games only new ones.

Hak Installer method

The easiest way to add the merge to a module is using the PRC module updater directly. 
By default, it will be installed to NeverwinterNights\PRCPack\PRCModuleUpdater.exe
Once you run it, you will be presented with a range of options to use to install; these correspond to the .hif files you extracted earlier:

PRC Pack		This is the normal PRC installation
prc_ocfix		This is the PRC original campaign fix
prcc1			This is the PRC, CEP1 and the PRC/CEP1 merge
(prcc2			This is the PRC, CEP2 and the PRC/CEP2 merge)

Since the PRC is included in all of these files, you can run them on non-PRC versions of the module.

As a rough guide:

If you have a module with neither CEP or PRC in it, then running the hak installer and selecting prcc1 with it will install the core CEP + PRC + merge.

If you have a module with the CEP in it, then running the hak installer and selecting prcc1 with it will install the PRC + merge.

If you have a module with CEP + PRC in it, then running the hak installer and selecting prcc1 with it will install the PRC + merge.


Manual/toolset method

To manually add the merge, you need to associate the haks with the module, normally though the toolset.
The exact order that the haks are in is not that important. 
The key points are that:
A) The relevent merge hak (named as with the hif files above) must be the top hak
B) You must use prccep as your custom tlk file.

