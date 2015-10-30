script listPools.tcl {
# by Sean Jain Ellis <sellis@bandarji.com>
# Usage: ssh -l <user> <loadBalancer> 'tmsh run /cli script listPools.tcl'

proc script::run {} {
  foreach pool [tmsh::get_config /ltm pool] {
    puts "[tmsh::get_name ${pool}]"
  }
}

}
