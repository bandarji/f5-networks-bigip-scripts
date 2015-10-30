script poolStatus.tcl {
# poolStatus.tcl
# by Sean Jain Ellis <sellis@bandarji.com>

proc script::run {} {
  if {$tmsh::argc != 3} { puts "Error: Supply a pool name" ; exit }
  set slb [lindex $tmsh::argv 1]
  set poolName [lindex $tmsh::argv 2]
  if {[catch {set poolCheck [tmsh::get_config /ltm pool ${poolName}]} error1]} { puts "\{" ; puts "  \"slb\": \"${slb}\"," ; puts "  \"pool\": \"${poolName}\"," ; puts "  \"exists\": false" ; puts "\}" ; exit }
  if {${poolCheck} contains "members"} { } else { puts "\{" ; puts "  \"slb\": \"${slb}\"," ; puts "  \"pool\": \"${poolName}\"," ; puts "  \"exists\": true" ; puts "\}" ; exit }
  foreach poolConfig [tmsh::get_config /ltm pool ${poolName} all-properties] {
    puts "\{"
    puts "  \"slb\": \"${slb}\","
    puts "  \"pool\": \"${poolName}\","
    puts "  \"configuration\": \{"
    puts "    \"monitor\": \"[string map {"/Common/" " "} [tmsh::get_field_value ${poolConfig} monitor]]\","
    puts "    \"load-balancing-mode\": \"[tmsh::get_field_value ${poolConfig} load-balancing-mode]\","
    puts "    \"min-active-members\": [tmsh::get_field_value ${poolConfig} min-active-members],"
    puts "    \"slow-ramp-time\": [tmsh::get_field_value ${poolConfig} slow-ramp-time],"
    puts "    \"members\": \["
    foreach poolMemberConfig [tmsh::get_field_value ${poolConfig} members] {
      puts -nonewline "      \{ \"member\": \"[tmsh::get_name ${poolMemberConfig}]\", \"connection-limit\": [tmsh::get_field_value ${poolMemberConfig} connection-limit], "
      puts "\"priority-group\": [tmsh::get_field_value ${poolMemberConfig} priority-group] \},"
    }
    puts "      \{\}"
    puts "    \]"
    puts "  \},"
    puts "  \"status\": \{"
  }
  foreach poolStatus [tmsh::get_status /ltm pool ${poolName} detail raw] {
    puts "    \"active-member-cnt\": [tmsh::get_field_value ${poolStatus} active-member-cnt],"
    puts "    \"serverside.bits-in\": [tmsh::get_field_value ${poolStatus} serverside.bits-in], \"serverside.bits-out\": [tmsh::get_field_value ${poolStatus} serverside.bits-out],"
    puts "    \"serverside.cur-conns\": [tmsh::get_field_value ${poolStatus} serverside.cur-conns], \"serverside.max-conns\": [tmsh::get_field_value ${poolStatus} serverside.max-conns],"
    puts "    \"serverside.pkts-in\": [tmsh::get_field_value ${poolStatus} serverside.pkts-in], \"serverside.pkts-out\": [tmsh::get_field_value ${poolStatus} serverside.pkts-out],"
    puts "    \"serverside.tot-conns\": [tmsh::get_field_value ${poolStatus} serverside.tot-conns], \"tot-requests\": [tmsh::get_field_value ${poolStatus} tot-requests],"
    puts "    \"status.availability-state\": \"[tmsh::get_field_value ${poolStatus} status.availability-state]\","
    puts "    \"status.enabled-state\": \"[tmsh::get_field_value ${poolStatus} status.enabled-state]\","
    puts "    \"status.status-reason\": \"[tmsh::get_field_value ${poolStatus} status.status-reason]\","
    puts "    \"members\": \["
    foreach poolMemberStatus [tmsh::get_field_value ${poolStatus} members] {
      puts "      \{"
      puts "        \"addr\": \"[tmsh::get_field_value ${poolMemberStatus} addr]\", \"port\": [tmsh::get_field_value ${poolMemberStatus} port],"
      puts "        \"monitor-status\": \"[tmsh::get_field_value ${poolMemberStatus} monitor-status]\","
      puts "        \"session-status\": \"[tmsh::get_field_value ${poolMemberStatus} session-status]\","
      puts "        \"status.enabled-state\": \"[tmsh::get_field_value ${poolMemberStatus} status.enabled-state]\","
      puts "        \"status.availability-state\": \"[tmsh::get_field_value ${poolMemberStatus} status.availability-state]\","
      puts "        \"status.status-reason\": \"[tmsh::get_field_value ${poolMemberStatus} status.status-reason]\","
      puts "        \"serverside.bits-in\": [tmsh::get_field_value ${poolMemberStatus} serverside.bits-in], \"serverside.bits-out\": [tmsh::get_field_value ${poolMemberStatus} serverside.bits-out],"
      puts "        \"serverside.cur-conns\": [tmsh::get_field_value ${poolMemberStatus} serverside.cur-conns], \"serverside.max-conns\": [tmsh::get_field_value ${poolMemberStatus} serverside.max-conns],"
      puts "        \"serverside.pkts-in\": [tmsh::get_field_value ${poolMemberStatus} serverside.pkts-in], \"serverside.pkts-out\": [tmsh::get_field_value ${poolMemberStatus} serverside.pkts-out],"
      puts "        \"serverside.tot-conns\": [tmsh::get_field_value ${poolMemberStatus} serverside.tot-conns], \"tot-requests\": [tmsh::get_field_value ${poolMemberStatus} tot-requests]"
      puts "      \},"
    }
  puts "      \{\}"
  puts "    \]"
  puts "  \}"
  puts "\}"
  }
}

}
