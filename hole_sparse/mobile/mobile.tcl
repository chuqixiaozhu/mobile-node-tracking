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
set opt(node_size) 1                       ;# Size of nodes
set opt(target_size) 2                     ;# Size of the target
set opt(radius_m) 15                       ;# Sensing Radius of Mobile nodes
set opt(mnode_speed) 1;                     # Velocity of Mobile nodes
set opt(target_speed_max) 3;                    # Mean velocity of the Target
#set opt(target_move_time_max) 20;           # Maxium time of the Target one movement
set opt(time_click) 1;                      # Duration of a time slice
#set MOVE_TIME 0;                            # global variable
#set opt(energy_comsumption) 0;              # Energy comsumption of fixed noded
#set opt(valid_time) 0;                      # Valid surveillance time
set opt(noise_avg) 0.1;                       # Noise average
set opt(noise_std) 0.2;                       # Noise standard deviation
set opt(source_signal_max) 5;              # Maximum of source singal
set opt(decay_factor) 2;                    # Decay factor
set opt(dist_threshold_f) 7               ;# Distance threshold of Fixed nodes
#set opt(dist_threshold_m) 6;               # Distance threshold of Mobile nodes
set opt(sen_intensity_threshold) 5;        # threshold of Sensing intensity
set opt(sys_proba_threshold) 0.8;           # System Sensing probability
set opt(normal) "normal.tcl";               # file for normal distribution
set tcl_precision 17;                       # Tcl variaty
set opt(trace_file) "out.tr"
set opt(nam_file) "out.nam"
set opt(hole_number) 5;                     # number of holes
set opt(hole_length) 30;                    # Length of a hole edge
set opt(dist_limit) 15;                  # Maximum distance from target to active nodes

source $opt(normal)
if {0 < $argc} {
    set opt(nfnode) [lindex $argv 0]
    set opt(nmnode) [lindex $argv 1]
    set opt(hole_number) [lindex $argv 2]
    set opt(target_speed_max) [lindex $argv 3]
    set opt(result_file) [lindex $argv 4]
    #set opt(x) [lindex $argv 0]
    #set opt(y) [lindex $argv 1]
    #set opt(nfnode) [lindex $argv 2]
    #set opt(nmnode) [lindex $argv 3]
    #set opt(target_speed_max) [lindex $argv 4]
    #set opt(result_file) [lindex $argv 5]
}
set opt(nn) [expr 1 + $opt(nfnode) + $opt(nmnode)] ;# sum of nodes and a target
#puts "@59 hole_number = $opt(hole_number)"; # test
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
set tracefile [open $opt(trace_file) w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open $opt(nam_file) w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $opt(x) $opt(y)

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

## Settings of random Time for Target one movement
#set rng_target_time [new RNG]
#$rng_target_time seed 0
#set rd_target_time [new RandomVariable/Uniform]
#$rd_target_time use-rng $rng_target_time
#$rd_target_time set min_ 1
#$rd_target_time set max_ $opt(target_move_time_max)

# Settings of random Speed for Target
set rng_target_speed [new RNG]
$rng_target_speed seed 0
set rd_target_speed [new RandomVariable/Uniform]
$rd_target_speed use-rng $rng_target_speed
$rd_target_speed set min_ 0
$rd_target_speed set max_ $opt(target_speed_max)

#===================================
#        Nodes Definition
#===================================
# Create holes
proc create_holes {x_ y_} {
    global opt rd_x rd_y
    upvar 1 $x_ x
    upvar 1 $y_ y
    set h $opt(hole_length)
    set g [expr ($opt(x) - 3 * $h) / 4.0]
    set p1 $g
    set p2 [expr $g + $h]
    set p3 [expr 2.0 * $g + $h]
    #set x [$rd_x value]
    #set y [$rd_y value]
    #puts "@144 ($x, $y)";       # test
    switch -exact -- $opt(hole_number) {
        1 {
            while {$p1 <= $x && $x <= $p2 && \
                   $p1 <= $y && $y <= $p2} {
                set x [$rd_x value]
                set y [$rd_y value]
            }
        }
        2 {
            while {$p1 <= $x && $x <= $p2 && \
                   $p1 <= $y && $y <= $p2 \
                || [expr 100 - $p2] <= $x && $x <= [expr 100 - $p1] && \
                   $p1 <= $y && $y <= $p2} {
                set x [$rd_x value]
                set y [$rd_y value]
            }
        }
        3 {
            while {$p1 <= $x && $x <= $p2 && \
                   $p1 <= $y && $y <= $p2 \
                || [expr 100 - $p2] <= $x && $x <= [expr 100 - $p1] && \
                   $p1 <= $y && $y <= $p2 \
                || $p3 <= $x && $x <= [expr 100 - $p3] && \
                   $p3 <= $y && $y <= [expr 100 - $p3]}  {
                set x [$rd_x value]
                set y [$rd_y value]
            }
        }
        4 {
            while {$p1 <= $x && $x <= $p2 && \
                   $p1 <= $y && $y <= $p2 \
                || [expr 100 - $p2] <= $x && $x <= [expr 100 - $p1] && \
                   $p1 <= $y && $y <= $p2 \
                || $p3 <= $x && $x <= [expr 100 - $p3] && \
                   $p3 <= $y && $y <= [expr 100 - $p3]  \
                || $p1 <= $x && $x <= $p2 && \
                   [expr 100 - $p2] <= $y && $y <= [expr 100 - $p1]} {
                set x [$rd_x value]
                set y [$rd_y value]
            }
        }
        5 {
            while {$p1 <= $x && $x <= $p2 && \
                   $p1 <= $y && $y <= $p2 \
                || [expr 100 - $p2] <= $x && $x <= [expr 100 - $p1] && \
                   $p1 <= $y && $y <= $p2 \
                || $p3 <= $x && $x <= [expr 100 - $p3] && \
                   $p3 <= $y && $y <= [expr 100 - $p3]  \
                || $p1 <= $x && $x <= $p2 && \
                   [expr 100 - $p2] <= $y && $y <= [expr 100 - $p1] \
                || [expr 100 - $p2] <= $x && $x <= [expr 100 - $p1] && \
                   [expr 100 - $p2] <= $y && $y <= [expr 100 - $p1]} {
                set x [$rd_x value]
                set y [$rd_y value]
                #puts "($x, $y)"; # test
            }
        }
        default {
            set x 0
            set y 0
            puts "something wrong."; # test
        }
    }
}

# Create Fixed nodes
for {set i 0} {$i < $opt(nfnode)} {incr i} {
    set fnode($i) [$ns node]
    #$fnode($i) set X_ [$rd_x value]
    #$fnode($i) set Y_ [$rd_y value]
    set xf [$rd_x value]
    set yf [$rd_y value]
    create_holes xf yf
    $fnode($i) set X_ $xf
    $fnode($i) set Y_ $yf
    $fnode($i) set Z_ 0
    $fnode($i) random-motion 0
    $ns initial_node_pos $fnode($i) $opt(node_size)
    $fnode($i) color "black"
    $fnode($i) shape "circle"
}

# Create Mobile nodes
for {set i 0} {$i < $opt(nmnode)} {incr i} {
    set mnode($i) [$ns node]
    #$mnode($i) set X_ [$rd_x value]
    #$mnode($i) set Y_ [$rd_y value]
    set xm [$rd_x value]
    set ym [$rd_y value]
    create_holes xm ym
    #puts "@219 mobile ($xm, $ym)"
    $mnode($i) set X_ $xm
    $mnode($i) set Y_ $ym
    $mnode($i) set Z_ 0
    $mnode($i) random-motion 0
    $ns initial_node_pos $mnode($i) $opt(node_size)
    $mnode($i) color "black"
    $mnode($i) shape "square"
    $ns at 0 "$mnode($i) color \"blue\""
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
$target shape "hexagon"
$ns at 0 "$target color \"red\""

#===================================
#        Utilities
#===================================

# If node can sense the target
proc be_sensed {node target radius itime} {
    global ns
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
        return 1
    } else {
        return 0
    }
}

# Set destination of the node to the target
proc set_destination {node target itime} {
    #global ns opt(mnode_speed)
    global ns opt
    $node update_position
    $target update_position
    set target_x [$target set X_]
    set target_y [$target set Y_]
    $node setdest $target_x $target_y $opt(mnode_speed)
}

# Scheduling mobile node actions
proc mobile_node_action {time_stamp} {
# Choosing Mobile nodes, set them in the array moving_mnode_index
    global opt mnode target
    set num_mobile 0
    for {set i 0} {$i < $opt(nmnode)} {incr i} {
        if {[be_sensed $mnode($i) $target $opt(radius_m) $time_stamp]} {
            set moving_mnode_index($num_mobile) $i
            incr num_mobile
        }
    }

# Movement for those chosen Mobile nodes
    for {set i 0} {$i < $num_mobile} {incr i} {
        set_destination $mnode($moving_mnode_index($i)) $target $time_stamp
    }

# Computing the consumption of Fiexed nodes, as well as valid surveillance time
    if {0 < $num_mobile} {
        fixed_node_computing moving_mnode_index $num_mobile $time_stamp
    } else {
        fixed_node_computing "" 0 $time_stamp
    }
}

# Compute the distance bewteen node and target
proc distance {node target time_stamp} {
    $node update_position
    $target update_position
    set target_x [$target set X_]
    set target_y [$target set Y_]
    set node_x [$node set X_]
    set node_y [$node set Y_]
    set dx [expr $node_x - $target_x]
    set dy [expr $node_y - $target_y]
    set dist [expr sqrt($dx * $dx + $dy * $dy)]
    return $dist
}

# Compute local probability
proc local_probability {dist dist_threshold} {
    global opt normal
    if {$dist > $dist_threshold} {
        set decay [expr pow((double($dist) / $dist_threshold), $opt(decay_factor))]
        set source_intensity [expr double($opt(source_signal_max)) / $decay]
    } else {
        set source_intensity $opt(source_signal_max)
    }
    set member \
        [expr $opt(sen_intensity_threshold) - ($source_intensity + $opt(noise_avg))]
    set y [expr double($member) / $opt(noise_std)]
    if {$y < 0} {
        if {[string length $y] == 2} {
            append y ".00"
        } elseif {[string length $y] ==4} {
            append y "0"
        }
        set y [string range $y 1 4]
        if {$y > 4.99} {
            set y "4.99"
        }
        set np $normal($y)
        set np [expr 1 - $np]
    } else {
        if {[string length $y] == 1} {
            append y ".00"
        } elseif {[string length $y] == 3} {
            append y "0"
        }
        set y [string range $y 0 3]
        if {$y > 4.99} {
            set y "4.99"
        }
        set np $normal($y)
    }
    set local_proba [expr 1.0 - $np]
    return $local_proba
}

# Computing the valid surveillance time and energy comsumption
proc fixed_node_computing {m_m_index num_m_m time_stamp} {
# Preparation for mobile nodes
    global opt mnode fnode target ns
    set m_proba_tmp 1.0
    set sys_proba_tmp 1.0
    for {set i 0} {$i < $opt(nfnode)} {incr i} {
        $fnode($i) color "black"
    }
    if {0 < $num_m_m} {
        upvar 1 $m_m_index moving_mnode_index
        for {set i 0} {$i < $num_m_m} {incr i} {
            set dist [distance $mnode($moving_mnode_index($i)) $target $time_stamp]
            set m_local_proba [local_probability $dist $opt(dist_threshold_f)]
            set m_proba_tmp [expr $m_proba_tmp * (1.0 - $m_local_proba)]
        }
        set sys_proba_tmp [expr $sys_proba_tmp * $m_proba_tmp]
        set sys_proba [expr 1.0 - $sys_proba_tmp]
        if {$opt(sys_proba_threshold) <= $sys_proba} {
            $ns set valid_sur_time [expr [$ns set valid_sur_time] + $opt(time_click)]
            return
        }
    }

# Sorting the fixed node distances
    set fnode_list ""
    for {set i 0} {$i < $opt(nfnode)} {incr i} {
        #lappend fnode_list [list [distance $fnode($i) $target $time_stamp] $i]
        lappend fnode_list [distance $fnode($i) $target $time_stamp]
    }
    #set fnode_list [lsort -real -index 0 $fnode_list]
    set fnode_list [lsort -real $fnode_list]

# Compute the system probability and energy comsumption
    set f_node_act_num 0
    foreach f_node $fnode_list {
        #set index [lindex $f_node 1]
        #$fnode($index) color "green"
        #set dist [lindex $f_node 0]
        set dist $f_node
        if {$dist > $opt(dist_limit)} {
            break
        }
        incr f_node_act_num
        set f_local_proba [local_probability $dist $opt(dist_threshold_f)]
        set sys_proba_tmp [expr $sys_proba_tmp * (1.0 - $f_local_proba)]
        set sys_proba [expr 1.0 - $sys_proba_tmp]
        if {$opt(sys_proba_threshold) <= $sys_proba} {
            $ns set valid_sur_time [expr [$ns set valid_sur_time] + $opt(time_click)]
            #$ns set energy_consumption \
            #    [expr [$ns set energy_consumption] + $f_node_act_num * $opt(time_click)]
            #return
            break
        }
    }
    $ns set energy_consumption \
        [expr [$ns set energy_consumption] + $f_node_act_num * $opt(time_click)]
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
    set time_stamp $time_line

# a Stop after moving
    if {!$to_move} {
        set stop_time [expr int($move_time / 3)]
        if {!$stop_time} {
            set stop_time 1
        }
        if {$opt(stop) <= [expr $time_line + $stop_time]} {
            set stop_time [expr $opt(stop) - $time_line]
        }
        set time_line [expr $time_line + $stop_time]
        set to_move 1
        while {$time_stamp < $time_line} {
            $ns at $time_stamp "mobile_node_action $time_stamp"
            set time_stamp [expr $time_stamp + $opt(time_click)]
        }
        continue
    }

# Movement of the Target
    set dest_x [$rd_x value]
    set dest_y [$rd_y value]
    set target_speed [$rd_target_speed value]
    set dx [expr $dest_x - $target_lx]
    set dy [expr $dest_y - $target_ly]
    set target_lx $dest_x
    set target_ly $dest_y
    set dist [expr sqrt($dx * $dx + $dy * $dy)]
    set move_time [expr int(floor(double($dist) / $target_speed) + 1)]
    if {$opt(stop) <= [expr $time_line + $move_time]} {
        set move_time [expr $opt(stop) - $time_line];
    }
    $ns at $time_line "$target setdest $dest_x $dest_y $target_speed"
    set time_line [expr $time_line + $move_time]
    set to_move 0

# Movement of some Mobile nodes
    while {$time_stamp < $time_line} {
        $ns at $time_stamp "mobile_node_action $time_stamp"
        set time_stamp [expr $time_stamp + $opt(time_click)]

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
proc output_file {} {
    global ns opt
    set result_file [open $opt(result_file) a]
    puts $result_file \
         "$opt(hole_number) \
          [$ns set valid_sur_time] \
          [$ns set energy_consumption]"
    flush $result_file
    close $result_file
}
proc finish {} {
    global ns tracefile namfile opt argc
    puts "valid_time = [$ns set valid_sur_time]"
    puts "energy_comsumption = [$ns set energy_consumption]"
    $ns flush-trace
    if {0 < $argc} {
        output_file
    }
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

# Finish
$ns at $opt(stop) "$ns nam-end-wireless $opt(stop)"
$ns at $opt(stop) "finish"
$ns at $opt(stop) "puts \"Done.\"; $ns halt"
$ns run
