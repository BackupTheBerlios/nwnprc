/*

    prc_inc_natweap.nss
    
    Natural Weapon include
    
    This include controlls natural weapons.
    These are different to unarmed weapons.
    
    From the SRD:
    
    Natural Weapons
    
    Natural weapons are weapons that are physically a part of a creature. A creature making a melee attack with 
    a natural weapon is considered armed and does not provoke attacks of opportunity. Likewise, it threatens any 
    space it can reach. Creatures do not receive additional attacks from a high base attack bonus when using 
    natural weapons. The number of attacks a creature can make with its natural weapons depends on the type of 
    the attackl generally, a creature can make one bite attack, one attack per claw or tentacle, one gore attack, 
    one sting attack, or one slam attack (although Large creatures with arms or arm-like limbs can make a slam 
    attack with each arm). Refer to the individual monster descriptions.
    
    Unless otherwise noted, a natural weapon threatens a critical hit on a natural attack roll of 20.
    
    When a creature has more than one natural weapon, one of them (or sometimes a pair or set of them) is the 
    primary weapon. All the creature’s remaining natural weapons are secondary.
    
    The primary weapon is given in the creature’s Attack entry, and the primary weapon or weapons is given first 
    in the creature’s Full Attack entry. A creature’s primary natural weapon is its most effective natural attack, 
    usually by virtue of the creature’s physiology, training, or innate talent with the weapon. An attack with a 
    primary natural weapon uses the creature’s full attack bonus. Attacks with secondary natural weapons are less 
    effective and are made with a -5 penalty on the attack roll, no matter how many there are. (Creatures with the 
    Multiattack feat take only a -2 penalty on secondary attacks.) This penalty applies even when the creature 
    makes a single attack with the secondary weapon as part of the attack action or as an attack of opportunity. 
    
    Natural weapons have types just as other weapons do. The most common are summarized below.
     
    Bite
    The creature attacks with its mouth, dealing piercing, slashing, and bludgeoning damage.
    
    Claw or Talon
    The creature rips with a sharp appendage, dealing piercing and slashing damage.
    
    Gore
    The creature spears the opponent with an antler, horn, or similar appendage, dealing piercing damage.
    
    Slap or Slam
    The creature batters opponents with an appendage, dealing bludgeoning damage.
    
    Sting
    The creature stabs with a stinger, dealing piercing damage. Sting attacks usually deal damage from poison in 
    addition to hit point damage.
    
    Tentacle    
    The creature flails at opponents with a powerful tentacle, dealing bludgeoning (and sometimes slashing) damage. 
    
    The main differences are:
    
    *) There are primary and secondary natural weapons.
    
    *) Natural weapons do not get additional attacks at higher BAB
    
    *) Primary natural weapon is at full BAB with full str bonus
    
    *) Secondary natural weaponss are at -5 (or -2 with Multiattack, or no penalty for Improved Multiattack) 
       with half strength bonus
    
    *) If a creature has a weapon in its "hands", it may still use non-claw attacks. For example, a double axe 
       plus a bite.
    
    *) A creature with both natural claw weapons and unarmed attacks, for example a Monk Werewolf, can choose
       to either use natural claw weapons or unarmed attacks, but not both.
       
       
    Implementation notes:
    
    *) Primary natural weapons use the creature inventory slots so the animation works
    
    *) Secondary natural weapons use the heartbeat and the scripted combat engine
    
    *) Since bioware divides the 6 second combat round into 3 flurries, secondary weapons try to respect those
       flurries.
       
    *) The target for secondary weapons GetAttackTarget() is used.
    
    *) Since initiative is hardcoded, we cant use that at all. Relies on heartbeat scripts instead.
*/
