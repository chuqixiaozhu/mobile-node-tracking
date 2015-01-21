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
set opt(nmnode) 20                         ;# number of mobile nodes
set opt(node_size) 1                       ;# Size of nodes
set opt(target_size) 2                     ;# Size of the target
set opt(radius_m) 15                       ;# Sensing Radius of Mobile nodes
set opt(mnode_speed) 1;                     # Velocity of Mobile nodes
set opt(target_speed_max) 3;                    # Mean velocity of the Target
#set opt(target_move_time_max) 20;   # Maxium time of the Target one movement
set opt(time_click) 1;                      # Duration of a time slice
#set MOVE_TIME 0;                            # global variable
set opt(energy_consumption) 0;           # Energy comsumption of fixed noded
#set opt(valid_time) 0;                      # Valid surveillance time
set opt(noise_avg) 0.01;                       # Noise average
set opt(noise_std) 0.1;                       # Noise standard deviation
set opt(source_signal_max) 5;              # Maximum of source singal
set opt(decay_factor) 2;                    # Decay factor
set opt(dist_threshold_f) 7             ;# Distance threshold of Fixed nodes
#set opt(dist_threshold_m) 6;            # Distance threshold of Mobile nodes
set opt(sen_intensity_threshold) 5;        # threshold of Sensing intensity
set opt(sys_proba_threshold) 0.8;           # System Sensing probability
set opt(normal) "normal.tcl";               # file for normal distribution
set tcl_precision 17;                       # Tcl variaty
set opt(trace_file) "out.tr"
set opt(nam_file) "out.nam"
set opt(hole_number) 2;                     # number of holes
set opt(hole_length) 30;                    # Length of a hole edge
set opt(dist_limit) 15;        # Maximum distance from target to active nodes
set opt(lag_time) [expr 2 * $opt(time_click)]
set opt(ntarget) 3;                         # number of targets
set opt(EC) 0;                              # Energy Consumption
set opt(weight_GT) 1;                # Weight of attracting force from target
set opt(weight_GM) 2;     # Weight of repulsive force from other mobile nodes
set opt(AVG_EMT) 0;           # Average Effective Monitoring Time of targets
#set opt(test) 0

source $opt(normal)
if {0 < $argc} {
    #set opt(nfnode) [lindex $argv 0]
    #set opt(nmnode) [lindex $argv 0]
    #set opt(hole_number) [lindex $argv 0]
    #set opt(target_speed_max) [lindex $argv 0]
    set opt(ntarget) [lindex $argv 0]
    set opt(result_file) [lindex $argv 1]
    #set opt(x) [lindex $argv 0]
    #set opt(y) [lindex $argv 1]
    #set opt(nfnode) [lindex $argv 2]
    #set opt(nmnode) [lindex $argv 3]
    #set opt(target_speed_max) [lindex $argv 4]
    #set opt(result_file) [lindex $argv 5]
    #set opt(dist_limit) \
    #set opt(dist_limit) 15
}
set opt(nn) \
    [expr $opt(ntarget) + $opt(nfnode) + $opt(nmnode)] ;# sum of nodes
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
$rd_target_speed set min_ 0.7
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
            }
        }
        default {
            set x 0
            set y 0
            puts "something wrong.";
        }
    }
}

# Create Fixed nodes
for {set i 0} {$i < $opt(nfnode)} {incr i} {
    set fnode($i) [$ns node]
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
    set lag([$fnode($i) id]) 0
    set sense_target($i) -1
}

# Create Mobile nodes
for {set i 0} {$i < $opt(nmnode)} {incr i} {
    set mnode($i) [$ns node]
    set xm [$rd_x value]
    set ym [$rd_y value]
    create_holes xm ym
    $mnode($i) set X_ $xm
    $mnode($i) set Y_ $ym
    $mnode($i) set Z_ 0
    $mnode($i) random-motion 0
    $ns initial_node_pos $mnode($i) $opt(node_size)
    $mnode($i) color "black"
    $mnode($i) shape "square"
    $ns at 0 "$mnode($i) color \"blue\""
    set lag([$mnode($i) id]) 0
    set to_target($i) -1
}

# Create the Target
for {set i 0} {$i < $opt(ntarget)} {incr i} {
    set target($i) [$ns node]
    $target($i) set X_ [$rd_x value]
    $target($i) set Y_ [$rd_y value]
    $target($i) set Z_ 0
    $target($i) random-motion 0
    $ns initial_node_pos $target($i) $opt(target_size)
    $target($i) color "black"
    $target($i) shape "hexagon"
    $ns at 0 "$target($i) color \"red\""
    set EMT($i) 0
}

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
    global ns opt
    $node update_position
    $target update_position
    set target_x [$target set X_]
    set target_y [$target set Y_]
    set node_x [$node set X_]
    set node_y [$node set Y_]
    set delta [expr ($opt(node_size) + $opt(target_size)) / 2.0]
    set dist [distance $node $target $itime]
    set sin_theta [expr ($target_x - $node_x) / $dist]
    set cos_theta [expr ($target_y - $node_y) / $dist]
    set dest_x [expr $target_x - $delta * $sin_theta]
    set dest_y [expr $target_y - $delta * $cos_theta]
    $node setdest $dest_x $dest_y $opt(mnode_speed)
    #$node setdest $target_x $target_y $opt(mnode_speed)
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

# Get the Attracting Force from target to mobile node
proc attracting_force {node target time_stamp} {
    global opt
    set dist [distance $node $target $time_stamp]
    if {!$dist} {
        set dist 0.001
    }
    set force [expr $opt(weight_GT) / pow($dist, 2)]
    return $force
}

# Get the Repulsive Force from other mobile nodes to the node
proc repulsive_force {node target index time_stamp} {
    global opt mnode
    set force 0.0
    set d_nt [distance $node $target $time_stamp]
    if {!$d_nt} {
        set d_nt 0.001
    }
    for {set i 0} {$i < $opt(nmnode)} {incr i} {
        if {$i == $index} {
            continue
        }
        set d_ni [distance $mnode($i) $node $time_stamp]
        if {$d_ni > $opt(radius_m)} {
            continue
        }
        if {!$d_ni} {
            set d_ni 0.001
        }
        set d_it [distance $mnode($i) $target $time_stamp]
        set cos_theta \
            [expr (pow($d_nt, 2) + pow($d_ni, 2) - pow($d_it, 2)) \
                 / (2 * $d_nt * $d_ni)]
        set ft [expr $cos_theta / pow($d_ni, 2)]
        set force [expr $force + $ft]
    }
    set force [expr -1 * $opt(weight_GM) * $force]
    return $force
}

# Get the Acting Force from target to mobile node
proc acting_force {node target index time_stamp} {
    global ns opt
    set force [expr [attracting_force $node $target $time_stamp] \
                   + [repulsive_force $node $target $index $time_stamp]]
    return $force
}

# Compute local probability
proc local_probability {dist dist_threshold} {
    global opt normal
    if {$dist > $dist_threshold} {
        set decay \
            [expr pow((double($dist) / $dist_threshold), $opt(decay_factor))]
        set source_intensity [expr double($opt(source_signal_max)) / $decay]
    } else {
        set source_intensity $opt(source_signal_max)
    }
    set member \
        [expr $opt(sen_intensity_threshold) \
            - ($source_intensity + $opt(noise_avg))]
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

# Computing the effective monitoring time for targets
proc tracking_target_computing {m_m_index_ s_f_index_ time_stamp} {
    global opt mnode fnode target ns lag EMT
    set m_proba_tmp 1.0
    set sys_proba_tmp 1.0
    upvar 1 $m_m_index_ moving_mnode_index
    upvar 1 $s_f_index_ sensing_fnode_index
    set active_fnode_num 0
    for {set target_index 0} \
        {$target_index < $opt(ntarget)} {incr target_index} {
# Mobile nodes tracking contribution
        set num_moving_mnode [llength $moving_mnode_index($target_index)]
        if {0 < $num_moving_mnode} {
            foreach i_d $moving_mnode_index($target_index) {
                set i [lindex $i_d 0]
                set dist [lindex $i_d 1]
                set m_local_proba \
                    [local_probability $dist $opt(dist_threshold_f)]
                set m_proba_tmp [expr $m_proba_tmp * (1.0 - $m_local_proba)]
            }
            set sys_proba_tmp [expr $sys_proba_tmp * $m_proba_tmp]
            set sys_proba [expr 1.0 - $sys_proba_tmp]
            if {$opt(sys_proba_threshold) <= $sys_proba} {
                incr EMT($target_index) $opt(time_click)
                continue
            }
        }

# Fixed nodes tracing contribution
        set num_sensing_fnode [llength $sensing_fnode_index($target_index)]
        if {$num_sensing_fnode > 0} {
            set fnode_list \
                [lsort -real -index 1 $sensing_fnode_index($target_index)]
            foreach i_d $fnode_list {
                incr active_fnode_num
                set i [lindex $i_d 0]
                set dist [lindex $i_d 1]
                $fnode($i) color "green"
                set f_local_proba \
                    [local_probability $dist $opt(dist_threshold_f)]
                set sys_proba_tmp \
                    [expr $sys_proba_tmp * (1.0 - $f_local_proba)]
                set sys_proba [expr 1.0 - $sys_proba_tmp]
                if {$opt(sys_proba_threshold) <= $sys_proba} {
                    incr EMT($target_index) $opt(time_click)
                    break
                }
            }
        }
    }
    incr opt(energy_consumption) [expr $active_fnode_num * $opt(time_click)]
}

# Computing the valid surveillance time and energy comsumption
proc fixed_node_action {m_m_index_ time_stamp} {
# Preparation for mobile nodes
    global opt mnode fnode target ns lag EMT
    upvar 1 $m_m_index_ moving_mnode_index
    for {set i 0} {$i < $opt(ntarget)} {incr i} {
        set sensing_fnode_index($i) ""
    }
# For every fixed node, choose a taraget
    for {set i 0} {$i < $opt(nfnode)} {incr i} {
        set switch_on 0
        set distance_min [expr 2 * $opt(x)]
        $fnode($i) color "black"
        for {set j 0} {$j < $opt(ntarget)} {incr j} {
            set dist [distance $fnode($i) $target($j) $time_stamp]
            if {$dist > $opt(dist_limit)} {
                continue
            }
            if {!$switch_on} {
                set switch_on 1
                incr lag([$fnode($i) id]) $opt(time_click)
            }
            if {$lag([$fnode($i) id])  <= $opt(lag_time)} {
                break
            }

# Computing the distance, choose the shortest
            if {$dist < $distance_min} {
                set distance_min $dist
                set sense_target($i) $j
                set dist_target $dist
            }
        }
        if {$switch_on} {
            if {$distance_min < 2 * $opt(x)} {
                lappend sensing_fnode_index($sense_target($i)) \
                        [list $i $dist_target]
            }
        } else {
            set sense_target($i) -1
            set lag([$fnode($i) id]) 0
        }
    }

# Computing the tracking results of targets
    tracking_target_computing \
        moving_mnode_index sensing_fnode_index $time_stamp
}

# Scheduling mobile node actions
proc mobile_node_action {time_stamp} {
    global opt mnode target lag to_target
    for {set i 0} {$i < $opt(ntarget)} {incr i} {
        set moving_mnode_index($i) ""
    }
# For every mobile node, choose a target
    for {set i 0} {$i < $opt(nmnode)} {incr i} {
        set switch_on 0
        #set force_max 0
        set distance_min [expr 2 * $opt(x)]
        for {set j 0} {$j < $opt(ntarget)} {incr j} {
            set dist [distance $mnode($i) $target($j) $time_stamp]
            if {$dist > $opt(radius_m)} {
                continue
            }
            if {!$switch_on} {
                incr lag([$mnode($i) id]) $opt(time_click)
                set switch_on 1
            }
            if {$lag([$mnode($i) id]) <= $opt(lag_time)} {
                break
            }

# Computing the force from this target($j)
            #set force [acting_force $mnode($i) $target($j) $i $time_stamp]
            if {$dist < $distance_min} {
                set distance_min $dist
                set to_target($i) $j
                set dist_target $dist
            }
        }
        if {$switch_on} {
            if {$distance_min < [expr 2 * $opt(x)]} {
                lappend moving_mnode_index($to_target($i)) \
                        [list $i $dist_target]
                set_destination \
                    $mnode($i) $target($to_target($i)) $time_stamp
            }
        } else {
            set to_target($i) -1
            set lag([$mnode($i) id]) 0
        }
    }
    fixed_node_action moving_mnode_index $time_stamp
}

#===================================
#        Generate movement
#===================================
# The schedule of Targets' Movement
for {set i 0}  {$i < $opt(ntarget)} {incr i} {
    set time_line 0
    set target_lx [$target($i) set X_]
    set target_ly [$target($i) set Y_]
    set to_move 1
    while {$time_line < $opt(stop)} {
        set time_stamp $time_line

# A Stop after a movement
        if {!$to_move} {
            set stop_time [expr int($move_time / 3)]
            if {!$stop_time} {
                set stop_time 1
            }
            if {$opt(stop) <= [expr $time_line + $stop_time]} {
                set stop_time [expr $opt(stop) - $time_line]
            }
            incr time_line $stop_time
            set to_move 1
            continue
        }

# A Movement of this Target
        set dest_x [$rd_x value]
        set dest_y [$rd_y value]
        set target_speed [$rd_target_speed value]
        set dx [expr $dest_x - $target_lx]
        set dy [expr $dest_y - $target_ly]
        set target_lx $dest_x
        set target_ly $dest_y
        set dist [expr sqrt(pow($dx, 2) + pow($dy, 2))]
        set move_time [expr int(floor(double($dist) / $target_speed) + 1)]
        if {$opt(stop) <= [expr $time_line + $move_time]} {
            set move_time [expr $opt(stop) - $time_line]
        }
        $ns at $time_line "$target($i) setdest $dest_x $dest_y $target_speed"
        incr time_line $move_time
        set to_move 0
    }
}

# The schedule of Mobile Nodes' Movement
set time_line 0
while {$time_line < $opt(stop)} {
    $ns at $time_line "mobile_node_action $time_line"
    incr time_line $opt(time_click)
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

# Calculate Averaget Effective Monitoring Time of targets
proc average_emt {} {
    global EMT opt
    set sum 0
    for {set i 0} {$i < $opt(ntarget)} {incr i} {
        incr sum $EMT($i)
    }
    set opt(AVG_EMT) [expr 1.0 * $sum / $opt(ntarget)]
}

# Calculate the results
proc getting_results {} {
    average_emt
}

# Define a 'finish' procedure
proc output_file {} {
    global ns opt
    set result_file [open $opt(result_file) a]
    puts $result_file \
         "$opt(ntarget) \
          $opt(AVG_EMT) \
          $opt(energy_consumption)"
    flush $result_file
    close $result_file
}
proc finish {} {
    global ns tracefile namfile opt argc
    getting_results
    puts "average_effective_monitoring_time = $opt(AVG_EMT)"
    #puts "energy_consumption = [$ns set energy_consumption]"
    puts "energy_consumption = $opt(energy_consumption)"
    $ns flush-trace
    if {0 < $argc} {
        output_file
    }
    $ns at $opt(stop) "$ns nam-end-wireless $opt(stop)"
    close $tracefile
    close $namfile
    #exec nam out.nam &
    exit 0
}

# Reset nodes
for {set i 0} {$i < $opt(ntarget)} {incr i} {
    $ns at $opt(stop) "$target($i) reset"
}
for {set i 0} {$i < $opt(nmnode)} {incr i} {
    $ns at $opt(stop) "$mnode($i) reset"
}
for {set i 0} {$i < $opt(nfnode)} {incr i} {
    $ns at $opt(stop) "$fnode($i) reset"
}

# Finish
#$ns at $opt(stop) "$ns nam-end-wireless $opt(stop)"
$ns at $opt(stop) "finish"
$ns at $opt(stop) "puts \"Done.\"; $ns halt"
$ns run
