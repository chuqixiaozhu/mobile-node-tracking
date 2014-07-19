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
set opt(radius_f) 2                        ;# Sensing Radius of Fixed nodes
set opt(radius_m) 5                        ;# Sensing Radius of Mobile nodes

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
#        Nodes Definition
#===================================
# Settings for Random X positions
set rng_x [new RNG]
$rng_x seed 0
set r_x [new RandomVariable/Uniform]
$r_x use-rng $rng_x
$r_x set min_ 0
$r_x set max_ 100

# Settings for Random Y positions
set rng_y [new RNG]
$rng_y seed 0
set r_y [new RandomVariable/Uniform]
$r_y use-rng $rng_y
$r_y set min_ 0
$r_y set max_ 100

# Create Fixed nodes
for {set i 0} {$i < $opt(nfnode)} {incr i} {
    set fnode($i) [$ns node]
    $fnode($i) set X_ [$r_x value]
    $fnode($i) set Y_ [$r_y value]
    $fnode($i) set Z_ 0
    $fnode($i) random-motion 0
    $ns initial_node_pos $fnode($i) $opt(node_size)
}

# Create Mobile nodes
for {set i 0} {$i < $opt(nmnode)} {incr i} {
    set mnode($i) [$ns node]
    $mnode($i) set X_ [$r_x value]
    $mnode($i) set Y_ [$r_y value]
    $mnode($i) set Z_ 0
    $mnode($i) random-motion 0
    $ns initial_node_pos $mnode($i) $opt(node_size)
}

# Create the Target
set target [$ns node]
$target set X_ [$r_x value]
$target set Y_ [$r_y value]
$target set Z_ 0
$target random-motion 0
$ns initial_node_pos $target $opt(target_size)

#===================================
#        Generate movement
#===================================
#$ns at 0 " $n0 setdest 20 20 1 "
##$ns at 10 "$n0 setdest 300 200 10"
#$ns at 5 "puts \"**********Hello**********\""
##$n0 update_position
#$ns at 5 "$n0 update_position"
##$ns flush-trace
##$ns at 5.1 "global n0; $n0 update_position; puts \"5x = [$n0 set X_]\""
##$ns at 6 "puts \"6x = [$n0 set X_]\""
#set i 0
#$ns at 7 "set i [$n0 set X_]; puts \"i = $i\""
#$ns at 7.1 "puts [$n0 set X_]"
#set index 0
#proc test {node} {
#    upvar $node n
#    set t 0
#    #set t [$node set X_]
#    puts [$n set X_]
#    set t [$n set X_]
#    puts "t = $t"
#}
#$ns at 5 "test n$index"

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
$ns at $opt(stop).01 "finish"
$ns at $opt(stop).02 "puts \"Done.\"; $ns halt"
$ns run
