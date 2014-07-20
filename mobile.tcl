# This script is created by NSG2 beta1
# <http://wushoupong.googlepages.com/nsg>
# modified by Piglet

#===================================
#     Simulation parameters setup
#===================================
set opt(chan)   Channel/WirelessChannel    ;# channel type
set opt(prop)   Propagation/TwoRayGround   ;# radio-propagation model
#set opt(netif)  Phy/WirelessPhy/802_15_4  ;# network interface type
#set opt(mac)    Mac/802_15_4              ;# MAC type
set opt(netif)  Phy/WirelessPhy            ;# network interface type
set opt(mac)    Mac/802_11                 ;# MAC type
set opt(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set opt(ll)     LL                         ;# link layer type
set opt(ant)    Antenna/OmniAntenna        ;# antenna model
set opt(ifqlen) 50                         ;# max packet in ifq
set opt(rp)     DSDV                       ;# routing protocol
set opt(x)      100                        ;# X dimension of topography
set opt(y)      100                        ;# Y dimension of topography
set opt(stop)   100                        ;# time of simulation end
set opt(nfnode) 100                        ;# number of fixed nodes
set opt(nmnode) 10                         ;# number of mobile nodes
set opt(nn) [expr 1 + $opt(nfnode) + $opt(nmnode)] ;# sum of nodes and a target
set opt(node_size) 1                       ;# Size of nodes
set opt(target_size) 2                     ;# Size of the target
set opt(radius_f) 15                       ;# Sensing Radius of Fixed nodes
set opt(radius_m) 20                       ;# Sensing Radius of Mobile nodes
set opt(mnode_speed) 2;                     # Velocity of Mobile nodes
set opt(target_speed) 5;                    # Mean velocity of the Target
set opt(target_move_time_max) 20;           # Maxium time of the Target one movement
set opt(time_click) 1;                      # Duration of a time slice
#set MOVE_TIME 0;                            # global variable

#===================================
#        Initialization
#===================================
#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo [new Topography]
$topo load_flatgrid $opt(x) $opt(y)
create-god $opt(nn)

#Open the NS trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $opt(x) $opt(y)
#set chan [new $opt(chan)];#Create wireless channel

#===================================
#     Node parameter setup
#===================================
$ns node-config -adhocRouting  $opt(rp) \
                -llType        $opt(ll) \
                -macType       $opt(mac) \
                -ifqType       $opt(ifq) \
                -ifqLen        $opt(ifqlen) \
                -antType       $opt(ant) \
                -propInstance  [new $opt(prop)] \
                -phyType       $opt(netif) \
                -channel       [new $opt(chan)] \
                -topoInstance  $topo \
                -agentTrace    OFF \
                -routerTrace   OFF \
                -macTrace      OFF \
                -movementTrace OFF

#===================================
#        Collection of Random
#===================================
# Settings for Random X positions
set rng_x [new RNG]
$rng_x seed 0
set rd_x [new RandomVariable/Uniform]
$rd_x use-rng $rng_x
$rd_x set min_ 0
$rd_x set max_ $opt(x)

# Settings for Random Y positions
set rng_y [new RNG]
$rng_y seed 0
set rd_y [new RandomVariable/Uniform]
$rd_y use-rng $rng_y
$rd_y set min_ 0
$rd_y set max_ $opt(y)

# Settings of random Time for Target one movement
set rng_target_time [new RNG]
$rng_target_time seed 0
set rd_target_time [new RandomVariable/Uniform]
$rd_target_time use-rng $rng_target_time
$rd_target_time set min_ 1
$rd_target_time set max_ $opt(target_move_time_max)

# Settings of random Speed for Target
set rng_target_speed [new RNG]
$rng_target_speed seed 0
set rd_target_speed [new RandomVariable/Normal]
$rd_target_speed use-rng $rng_target_speed
$rd_target_speed set avg_ $opt(target_speed)
$rd_target_speed set std_ 1

#===================================
#        Nodes Definition
#===================================
# Create Fixed nodes
for {set i 0} {$i < $opt(nfnode)} {incr i} {
    set fnode($i) [$ns node]
    $fnode($i) set X_ [$rd_x value]
    $fnode($i) set Y_ [$rd_y value]
    $fnode($i) set Z_ 0
    $fnode($i) random-motion 0
    $ns initial_node_pos $fnode($i) $opt(node_size)
}

# Create Mobile nodes
for {set i 0} {$i < $opt(nmnode)} {incr i} {
    set mnode($i) [$ns node]
    $mnode($i) set X_ [$rd_x value]
    $mnode($i) set Y_ [$rd_y value]
    $mnode($i) set Z_ 0
    $mnode($i) random-motion 0
    $ns initial_node_pos $mnode($i) $opt(node_size)
    $mnode($i) color "black"
    $ns at 0 "$mnode($i) color \"red\""
    #$ns color $mnode($i) "red"
}

# Create the Target
set target [$ns node]
$target set X_ [$rd_x value]
$target set Y_ [$rd_y value]
$target set Z_ 0
$target random-motion 0
$ns initial_node_pos $target $opt(target_size)
$target color "black"
$ns at 0 "$target color \"green\""

#===================================
#        Utilities
#===================================
## Schedule for Target stopping
#proc target_stop {time_stamp time_l} {
#    global MOVE_TIME
#    upvar 1 $time_l time_line
#    #set stop_time [expr int([$rd_target_time value] / 2)]
#    set stop_time [expr int($MOVE_TIME / 2)]
#    if {!$stop_time} {
#        set stop_time 1
#    }
#    incr time_line $stop_time
#    #incr time_line 5;      # test
#}
#
## Schedule for Target moving
#proc target_action {time_stamp time_l} {
#    global ns target MOVE_TIME
#    upvar 1 $time_l time_line
#
## Target position at present
#    $target update_position
#    set target_x [$target set X_]
#    set target_y [$target set Y_]
#
## Random Destination
#    set dest_x [$rd_x value]
#    set dest_y [$rd_y value]
#
## Random Velocity
#    set target_speed [$rd_target_speed value]
#
## Compute the time
#    set dx [expr dest_x - target_x]
#    set dy [expr dest_y - target_y]
#    set dist [expr sqrt($dx * $dx + $dy * $dy)]
#    set MOVE_TIME [expr floor($dist / $target_speed) + 1]
## Movement of the Target
#    $ns at $time_line "$target setdest $dest_x $dest_y $target_speed"
#    #set move_time [expr int([$rd_target_time value])]
#    puts "@254 MOVE_TIME = $MOVE_TIME"; # test
#    incr time_line $MOVE_TIME
#    #incr time_line 15;          # test
#}

# If node can sense the target
proc be_sensed {node target radius itime} {
    global ns
    #$ns at $itime "$node update_position"
    #$ns at $itime "$target update_position"
    $node update_position
    $target update_position
    set node_x [$node set X_]
    set node_y [$node set Y_]
    set target_x [$target set X_]
    set target_y [$target set Y_]
    set dx [expr $node_x - $target_x]
    set dy [expr $node_y - $target_y]
    set dist [expr sqrt($dx * $dx + $dy * $dy)]
    if {$dist <= $radius} {
        # test
        puts "@162 itime = $itime"
        puts "node = $node"
        puts "node = ($node_x, $node_y)"
        puts "target = ($target_x, $target_y)"
        # /test

        return 1
    } else {
        return 0
    }
}

# Set destination of the node to the target
proc set_destination {node target itime} {
    #global ns opt(mnode_speed)
    global ns opt
    #$ns at $itime "$node update_position"
    #$ns at $itime "$target update_position"
    $node update_position
    $target update_position
    set target_x [$target set X_]
    set target_y [$target set Y_]
    #$ns at $itime "$node setdest $target_x $target_y $opt(mnode_speed)"
    $node setdest $target_x $target_y $opt(mnode_speed)
    # test
    puts "@183 itime = $itime"
    puts "node = $node"
    puts "target = ($target_x, $target_y)"
    # /test
}

proc moblie_node_action {time_stamp} {
    # Choosing Mobile nodes, set them in the array moving_mnode_index
    global opt mnode target
    set num_mobile 0
    for {set i 0} {$i < $opt(nmnode)} {incr i} {
        if {[be_sensed $mnode($i) $target $opt(radius_m) $time_stamp]} {
            #if {[be_sensed mnode($i) $target $opt(radius_m) $time_stamp]} {}
            #$ns at time_line "$mnode($i) setdest $dest_x $dest_y $opt(mnode_speed)"
            set moving_mnode_index($num_mobile) $i
            incr num_mobile
        }
    }

    # Movement for those chosen Mobile nodes
    for {set i 0} {$i < $num_mobile} {incr i} {
        #puts "@225 time_stamp = $time_stamp"; # test
        set_destination $mnode($moving_mnode_index($i)) $target $time_stamp
        #$ns at time_stamp "$mnode($moving_mnode_index($i)) update_position"
        #$ns at time_stamp "$target update_position"
        #$mnode($moving_mnode_index($i))
        # Computing for Fixed nodes
        # to-do !!!! 20140719-22:48
    }
}

#===================================
#        Generate movement
#===================================
# Create time index
set time_line 0
set target_lx [$target set X_]
set target_ly [$target set Y_]

# the whole process of Movement, scheduled by Time
set to_move 1
while {$time_line < $opt(stop)} {
# Time-stamp
    set time_stamp $time_line
    puts "@275 time_line = $time_line"; # test

# a Stop after moving
    if {!$to_move} {
        set stop_time [expr int($move_time / 3)]
        puts "@282 stop_time = $stop_time"; # test
        if {!$stop_time} {
            set stop_time 1
        }
        $ns at $time_line "moblie_node_action $time_line"
        incr time_line $stop_time
        set to_move 1
        continue
    }

# Random Destination
    set dest_x [$rd_x value]
    set dest_y [$rd_y value]

# Random Velocity
    set target_speed [$rd_target_speed value]

# Compute the time
    set dx [expr $dest_x - $target_lx]
    set dy [expr $dest_y - $target_ly]
    set target_lx $dest_x
    set target_ly $dest_y
    set dist [expr sqrt($dx * $dx + $dy * $dy)]
    set move_time [expr int(floor($dist / $target_speed) + 1)]
# Movement of the Target
    $ns at $time_line "$target setdest $dest_x $dest_y $target_speed"
    puts "@307 move_time = $move_time"; # test
    incr time_line $move_time
    set to_move 0

# Movement of some Mobile nodes
    while {$time_stamp < $time_line} {
        $ns at $time_stamp "moblie_node_action $time_stamp"

    # Time slice goes on
        incr time_stamp $opt(time_click)
    }
}

#===================================
#        Agents Definition
#===================================
#===================================
#        Applications Definition
#===================================
#===================================
#        Termination
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    #exec nam out.nam &
    exit 0
}

# Reset nodes
$ns at $opt(stop) "$target reset"
for {set i 0} {$i < $opt(nmnode)} {incr i} {
    $ns at $opt(stop) "$mnode($i) reset"
}
for {set i 0} {$i < $opt(nfnode)} {incr i} {
    $ns at $opt(stop) "$fnode($i) reset"
}
#for {set i 0} {$i < $opt(nn) } { incr i } {
#    #$ns at $opt(stop) "\$n$i reset"
#}
#$ns at $opt(stop) "$n0 reset"

# Finish
$ns at $opt(stop) "$ns nam-end-wireless $opt(stop)"
$ns at $opt(stop) "finish"
$ns at $opt(stop) "puts \"Done.\"; $ns halt"
$ns run
