Player Resource Consortium Companion
------------------------------------

This is an optional additional hak to the PRC that contains the best of the vault combined together.
When used, the PRC code will auto-detect its presence and swap to useing the content automatically.


===================================

various source readmes

===================================

DOA Base Item Model Set
Den, Project Lead at Carpe Terra (http://carpeterra.com)
version 2.0

Be rid of generic loot bags for everything other than miscellaneous items and containers. Now includes drop item models for all Bioware craftable components. Special thanks to Kinarr Greycloak for providing most of the metallic craft component and new PLT dye pot models, and to rabbithail for the hide model.

The DOA Base Item Model Set includes new models for the following base items: 

::Equipment::
  belt (doa_belt)
  boots (doa_boots)
  bracers (doa_bracer)
  cloak (doa_cloak)
  gloves/gauntlets (doa_glove)

::Jewelry::
  amulet (doa_amulet)
  ring (doa_ring)

::Miscellaneous::
  book (doa_book)
  gems (doa_gem, it_smlmisc_049, it_smlmisc_073, it_smlmisc_079, it_smlmisc_080)
  healer's kit (doa_healkit)
  key (doa_key)
  thieves' tools (doa_thtools)
  trap (it_trap_001)

::Metal Craft Components::
  iron bar (it_midmisc_105)
  steel bar (it_midmisc_107)
  mitral bar (it_midmisc_106)
  adamantine bar (it_midmisc_104)
  iron rings (it_smlmisc_086)
  iron bands (it_smlmisc_082)
  iron chain (it_smlmisc_083)
  iron orb (it_smlmisc_085)
  iron spikes (it_smlmisc_087)
  iron hammer head (it_smlmisc_084)
  
::Non-Metal Craft Components::
  large bone (it_midmisc_111)
  feathers (it_smlmisc_053)
  leather hide (it_midmisc_006)
  leather patches (it_smlmisc_089)
  leather strings (it_smlmisc_090)
  bolt of cloth (it_midmisc_108)
  woolen cloth (it_smlmisc_093)
  oaken pole (it_midmisc_114)
  planks (it_midmisc_117)

::Semi-Finished Craft Components::
  cloth/leather torso armor (it_midmisc_112)
  steel chain armor (it_midmisc_120)
  steel plated armor (it_midmisc_119)
  helmet (it_midmisc_110)
  oaken shield body (it_midmisc_115)
  steel shield body (it_midmisc_121)
  small/large steel blade (it_smlmisc_091)
  steel axe head (it_smlmisc_092)
  weapon grip/shaft (it_midmisc_116)
  bow shaft (it_midmisc_109)
  crossbow shelf (it_midmisc_113)
  projectile shaft (it_midmisc_118)

::Dyes and Poison::
  venom (it_smlmisc_081)
  dye pot** (it_smlmisc_088, dye_001, dye_metal_001)


Most items were ripped from Bioware tileset, placeable, or armor/weapon models. Default textures were used where ever possible. Parenthesis indicates the model name(s) in the hak.

All items have been re-scaled to human size. This will make smaller items, such as rings or gems, more difficult to locate when dropped to the ground, but we believe this is a feature rather than a flaw. We also resized the trap, but otherwise did not change it.

**OPTIONAL: New WYSIWYG dye pot models are included in this hak. Import the wysiwyg_dyes ERF to use the WYSIWYG dye pots which will add 192 custom crafting material items (64 each for cloth, leather and metal). The dropped item model of the WYSIWYG dye pots indicates the color of the dye, making armor coloration an easy process.

This ERF is *optional* to the DOA Base Item Model Set 2.0. If you choose not to import this ERF, use the Bioware default dye items which will still have a drop model, but the pot color will be the same for every dye.

::Revision::
2.0  REQUIRES HOU for the craftable component drop item models
1.2  compatible with 1.61/HoU, removed doa_scroll, trap model renamed, added misc small models for gem (ioun stone) icons
1.1  compatible with 1.30/SoU


Notes on Usage _____________________
Place this hak in your HAK directory and then under Module Properties from the Edit menu, select the hak on the Advanced tab. 

Note to HAK Distributors ____________
If you wish to include this in your combined "mega" hak for other than a world or module-specific distribution, we ask that you also include this readme in your distribution so that modelers get full credit for their work. The excuse "I forgot where I got that" just doesn't cut it.

===================================
