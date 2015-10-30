script poolStatus.tcl {
# poolStatus.tcl
# by Sean Jain Ellis <sellis@bandarji.com>

proc script::run {} {
  if {$tmsh::argc != 3} {
    puts "Error: Supply a pool name" ; exit
  }
  set slb [lindex $tmsh::argv 1]
  set poolName [lindex $tmsh::argv 2]
  if {[catch {set poolCheck [tmsh::get_config /ltm pool ${poolName}]} error1]} {
    puts "\x7b" ; puts "  \x22slb\x22: \x22${slb}\x22," ; puts "  \x22pool\x22: \x22${poolName}\x22," ; puts "  \x22exists\x22: false" ; puts "\x7d" ; exit
  }
  if {${poolCheck} contains "members"} {
    set x 0
  } else {
    puts "\x7b" ; puts "  \x22slb\x22: \x22${slb}\x22," ; puts "  \x22pool\x22: \x22${poolName}\x22," ; puts "  \x22exists\x22: true" ; puts "\x7d" ; exit
  }
  foreach poolConfig [tmsh::get_config /ltm pool ${poolName} all-properties] {
    puts "\x7b"
    puts "  \x22slb\x22: \x22${slb}\x22,"
    puts "  \x22pool\x22: \x22${poolName}\x22,"
    puts "  \x22configuration\x22: \x7b"
    puts "    \x22monitor\x22: \x22[tmsh::get_field_value ${poolConfig} monitor]\x22,"
    puts "    \x22load-balancing-mode\x22: \x22[tmsh::get_field_value ${poolConfig} load-balancing-mode]\x22,"
    puts "    \x22min-active-members\x22: [tmsh::get_field_value ${poolConfig} min-active-members],"
    puts "    \x22slow-ramp-time\x22: [tmsh::get_field_value ${poolConfig} slow-ramp-time],"
    puts "    \x22members\x22: \x5b"
    foreach poolMemberConfig [tmsh::get_field_value ${poolConfig} members] {
      puts -nonewline "      \x7b \x22member\x22: \x22[tmsh::get_name ${poolMemberConfig}]\x22, \x22connection-limit\x22: [tmsh::get_field_value ${poolMemberConfig} connection-limit], "
      puts "\x22priority-group\x22: [tmsh::get_field_value ${poolMemberConfig} priority-group] \x7d,"
    }
    puts "      \x7b\x7d"
    puts "    \x5d"
    puts "  \x7d,"
    puts "  \x22status\x22: \x7b"
  }
  foreach poolStatus [tmsh::get_status /ltm pool ${poolName} detail raw] {
    puts "    \x22serverside.bits-in\x22: [tmsh::get_field_value ${poolStatus} serverside.bits-in], \x22serverside.bits-out\x22: [tmsh::get_field_value ${poolStatus} serverside.bits-out],"
    puts "    \x22serverside.cur-conns\x22: [tmsh::get_field_value ${poolStatus} serverside.cur-conns], \x22serverside.max-conns\x22: [tmsh::get_field_value ${poolStatus} serverside.max-conns],"
    puts "    \x22serverside.pkts-in\x22: [tmsh::get_field_value ${poolStatus} serverside.pkts-in], \x22serverside.pkts-out\x22: [tmsh::get_field_value ${poolStatus} serverside.pkts-out],"
    puts "    \x22serverside.tot-conns\x22: [tmsh::get_field_value ${poolStatus} serverside.tot-conns],"
    puts "    \x22status.availability-state\x22: \x22[tmsh::get_field_value ${poolStatus} pool.status.availability-state]\x22,"
    puts "    \x22status.enabled-state\x22: \x22[tmsh::get_field_value ${poolStatus} pool.status.enabled-state]\x22,"
    puts "    \x22status.status-reason\x22: \x22[tmsh::get_field_value ${poolStatus} pool.status.status-reason]\x22,"
    puts "    \x22members\x22: \x5b"
    foreach poolMemberStatus [tmsh::get_field_value ${poolStatus} members] {
      puts "      \x7b"
      puts "        \x22addr\x22: \x22[tmsh::get_field_value ${poolMemberStatus} addr]\x22, \x22port\x22: [tmsh::get_field_value ${poolMemberStatus} port],"
      puts "        \x22status.enabled-state\x22: \x22[tmsh::get_field_value ${poolMemberStatus} pool-member.status.enabled-state]\x22,"
      puts "        \x22status.availability-state\x22: \x22[tmsh::get_field_value ${poolMemberStatus} pool-member.status.availability-state]\x22,"
      puts "        \x22status.status-reason\x22: \x22[tmsh::get_field_value ${poolMemberStatus} pool-member.status.status-reason]\x22,"
      puts "        \x22serverside.bits-in\x22: [tmsh::get_field_value ${poolMemberStatus} serverside.bits-in], \x22serverside.bits-out\x22: [tmsh::get_field_value ${poolMemberStatus} serverside.bits-out],"
      puts "        \x22serverside.cur-conns\x22: [tmsh::get_field_value ${poolMemberStatus} serverside.cur-conns], \x22serverside.max-conns\x22: [tmsh::get_field_value ${poolMemberStatus} serverside.max-conns],"
      puts "        \x22serverside.pkts-in\x22: [tmsh::get_field_value ${poolMemberStatus} serverside.pkts-in], \x22serverside.pkts-out\x22: [tmsh::get_field_value ${poolMemberStatus} serverside.pkts-out],"
      puts "        \x22serverside.tot-conns\x22: [tmsh::get_field_value ${poolMemberStatus} serverside.tot-conns], \x22tot-requests\x22: [tmsh::get_field_value ${poolMemberStatus} tot-requests]"
      puts "      \x7d,"
    }
  puts "      \x7b\x7d"
  puts "    \x5d"
  puts "  \x7d"
  puts "\x7d"
  }
}

}

