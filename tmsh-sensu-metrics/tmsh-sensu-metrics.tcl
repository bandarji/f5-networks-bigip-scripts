cli script sensu.tcl {
  # Traffic Manager Shell Script to collect metrics for Sensu
  # by Sean Jain Ellis <sellis@bandarji.com>
  #
  # tmsh run /cli script sensu.tcl <timeStamp> <sensuScheme>
  #
  proc script::run {} {
    set timeStamp 00000000
    if {[tmsh::version] starts_with "10."} { set version10 1 } else { set version10 0 }
    foreach {objPool} [tmsh::get_config /ltm pool] {
      set poolName [tmsh::get_name ${objPool}]
      foreach {objPoolMetrics} [tmsh::get_status /ltm pool ${poolName} raw] {
        set outputPoolName [string map {{.} {_}} ${poolName}]
        puts "stats.bigip.pool.${outputPoolName}.bits-in\x09[tmsh::get_field_value ${objPoolMetrics} serverside.bits-in]\x09${timeStamp}"
        puts "stats.bigip.pool.${outputPoolName}.bits-out\x09[tmsh::get_field_value ${objPoolMetrics} serverside.bits-out]\x09${timeStamp}"
        puts "stats.bigip.pool.${outputPoolName}.pkts-in\x09[tmsh::get_field_value ${objPoolMetrics} serverside.pkts-in]\x09${timeStamp}"
        puts "stats.bigip.pool.${outputPoolName}.pkts-out\x09[tmsh::get_field_value ${objPoolMetrics} serverside.pkts-out]\x09${timeStamp}"
        puts "stats.bigip.pool.${outputPoolName}.cur-conns\x09[tmsh::get_field_value ${objPoolMetrics} serverside.cur-conns]\x09${timeStamp}"
        puts "stats.bigip.pool.${outputPoolName}.max-conns\x09[tmsh::get_field_value ${objPoolMetrics} serverside.max-conns]\x09${timeStamp}"
        puts "stats.bigip.pool.${outputPoolName}.tot-conns\x09[tmsh::get_field_value ${objPoolMetrics} serverside.tot-conns]\x09${timeStamp}"
        # v10 pool.status.availability-state v11 status.availability-state
        if {$version10} {
          if {[tmsh::get_field_value ${objPoolMetrics} pool.status.availability-state] == "available"} { set toggle "1" } else { set toggle "0" }
          puts "stats.bigip.pool.${outputPoolName}.available\x09${toggle}\x09${timeStamp}"
          if {[tmsh::get_field_value ${objPoolMetrics} pool.status.enabled-state] == "enabled"} { set toggle "1" } else { set toggle "0" }
          puts "stats.bigip.pool.${outputPoolName}.enabled\x09${toggle}\x09${timeStamp}"
        } else {
          if {[tmsh::get_field_value ${objPoolMetrics} status.availability-state] == "available"} { set toggle "1" } else { set toggle "0" }
          puts "stats.bigip.pool.${outputPoolName}.available\x09${toggle}\x09${timeStamp}"
          if {[tmsh::get_field_value ${objPoolMetrics} status.enabled-state] == "enabled"} { set toggle "1" } else { set toggle "0" }
          puts "stats.bigip.pool.${outputPoolName}.enabled\x09${toggle}\x09${timeStamp}"
        }
      }
      # catch { unset objPool }
      # if {[info exists objPool]} { unset objPool }
      unset -nocomplain objPool objPoolMetrics poolName
    }
    foreach {objVirtual} [tmsh::get_config /ltm virtual] {
      set virtualName [tmsh::get_name ${objVirtual}]
      foreach {objVirtualMetrics} [tmsh::get_status /ltm virtual ${virtualName} raw] {
        set outputVirtualName [string map {{.} {_}} ${virtualName}]
        puts "stats.bigip.virtual.${outputVirtualName}.clientside-bits-in\x09[tmsh::get_field_value ${objVirtualMetrics} clientside.bits-in]\x09${timeStamp}"
        puts "stats.bigip.virtual.${outputVirtualName}.clientside-bits-out\x09[tmsh::get_field_value ${objVirtualMetrics} clientside.bits-out]\x09${timeStamp}"
        puts "stats.bigip.virtual.${outputVirtualName}.clientside-cur-conns\x09[tmsh::get_field_value ${objVirtualMetrics} clientside.cur-conns]\x09${timeStamp}"
        puts "stats.bigip.virtual.${outputVirtualName}.clientside-max-conns\x09[tmsh::get_field_value ${objVirtualMetrics} clientside.max-conns]\x09${timeStamp}"
        puts "stats.bigip.virtual.${outputVirtualName}.clientside-pkts-in\x09[tmsh::get_field_value ${objVirtualMetrics} clientside.pkts-in]\x09${timeStamp}"
        puts "stats.bigip.virtual.${outputVirtualName}.clientside-pkts-out\x09[tmsh::get_field_value ${objVirtualMetrics} clientside.pkts-out]\x09${timeStamp}"
        puts "stats.bigip.virtual.${outputVirtualName}.clientside-tot-conns\x09[tmsh::get_field_value ${objVirtualMetrics} clientside.tot-conns]\x09${timeStamp}"
        puts "stats.bigip.virtual.${outputVirtualName}.cs-max-conn-dur\x09[tmsh::get_field_value ${objVirtualMetrics} cs-max-conn-dur]\x09${timeStamp}"
        puts "stats.bigip.virtual.${outputVirtualName}.cs-mean-conn-dur\x09[tmsh::get_field_value ${objVirtualMetrics} cs-mean-conn-dur]\x09${timeStamp}"
        puts "stats.bigip.virtual.${outputVirtualName}.cs-min-conn-dur\x09[tmsh::get_field_value ${objVirtualMetrics} cs-min-conn-dur]\x09${timeStamp}"
        puts "stats.bigip.virtual.${outputVirtualName}.tot-requests\x09[tmsh::get_field_value ${objVirtualMetrics} tot-requests]\x09${timeStamp}"
        if {$version10} {
          if {[tmsh::get_field_value ${objVirtualMetrics} virtual-server.status.availability-state] == "available"} { set toggle "1" } else { set toggle "0" }
          puts "stats.bigip.virtual.${outputVirtualName}.available\x09${toggle}\x09${timeStamp}"
          if {[tmsh::get_field_value ${objVirtualMetrics} virtual-server.status.enabled-state] == "enabled"} { set toggle "1" } else { set toggle "0" }
          puts "stats.bigip.virtual.${outputVirtualName}.enabled\x09${toggle}\x09${timeStamp}"
        } else {
          if {[tmsh::get_field_value ${objVirtualMetrics} status.availability-state] == "available"} { set toggle "1" } else { set toggle "0" }
          puts "stats.bigip.virtual.${outputVirtualName}.available\x09${toggle}\x09${timeStamp}"
          if {[tmsh::get_field_value ${objVirtualMetrics} status.enabled-state] == "available"} { set toggle "1" } else { set toggle "0" }
          puts "stats.bigip.virtual.${outputVirtualName}.enabled\x09${toggle}\x09${timeStamp}"
        }
      }
    }
    foreach {objTcp} [tmsh::get_config /ltm profile tcp] {
      set tcpName [tmsh::get_name ${objTcp}]
      foreach {objTcpMetrics} [tmsh::get_status /ltm profile tcp ${tcpName} raw] {
        set outputTcpName [string map {{.} {_}} ${tcpName}]
        puts "stats.bigip.tcp.${outputTcpName}.abandons\x09[tmsh::get_field_value ${objTcpMetrics} abandons]\x09${timeStamp}"
        puts "stats.bigip.tcp.${outputTcpName}.acceptfails\x09[tmsh::get_field_value ${objTcpMetrics} acceptfails]\x09${timeStamp}"
        puts "stats.bigip.tcp.${outputTcpName}.accepts\x09[tmsh::get_field_value ${objTcpMetrics} accepts]\x09${timeStamp}"
        puts "stats.bigip.tcp.${outputTcpName}.close-wait\x09[tmsh::get_field_value ${objTcpMetrics} close-wait]\x09${timeStamp}"
        puts "stats.bigip.tcp.${outputTcpName}.connects\x09[tmsh::get_field_value ${objTcpMetrics} connects]\x09${timeStamp}"
        puts "stats.bigip.tcp.${outputTcpName}.connfails\x09[tmsh::get_field_value ${objTcpMetrics} connfails]\x09${timeStamp}"
        puts "stats.bigip.tcp.${outputTcpName}.expires\x09[tmsh::get_field_value ${objTcpMetrics} expires]\x09${timeStamp}"
        puts "stats.bigip.tcp.${outputTcpName}.fin-wait\x09[tmsh::get_field_value ${objTcpMetrics} fin-wait]\x09${timeStamp}"
        puts "stats.bigip.tcp.${outputTcpName}.open\x09[tmsh::get_field_value ${objTcpMetrics} open]\x09${timeStamp}"
        puts "stats.bigip.tcp.${outputTcpName}.rxbadcookie\x09[tmsh::get_field_value ${objTcpMetrics} rxbadcookie]\x09${timeStamp}"
        puts "stats.bigip.tcp.${outputTcpName}.rxbadseg\x09[tmsh::get_field_value ${objTcpMetrics} rxbadseg]\x09${timeStamp}"
        puts "stats.bigip.tcp.${outputTcpName}.rxbadsum\x09[tmsh::get_field_value ${objTcpMetrics} rxbadsum]\x09${timeStamp}"
        puts "stats.bigip.tcp.${outputTcpName}.rxcookie\x09[tmsh::get_field_value ${objTcpMetrics} rxcookie]\x09${timeStamp}"
        puts "stats.bigip.tcp.${outputTcpName}.rxooseg\x09[tmsh::get_field_value ${objTcpMetrics} rxooseg]\x09${timeStamp}"
        puts "stats.bigip.tcp.${outputTcpName}.rxrst\x09[tmsh::get_field_value ${objTcpMetrics} rxrst]\x09${timeStamp}"
        puts "stats.bigip.tcp.${outputTcpName}.syncacheover\x09[tmsh::get_field_value ${objTcpMetrics} syncacheover]\x09${timeStamp}"
        puts "stats.bigip.tcp.${outputTcpName}.time-wait\x09[tmsh::get_field_value ${objTcpMetrics} time-wait]\x09${timeStamp}"
        puts "stats.bigip.tcp.${outputTcpName}.txrexmits\x09[tmsh::get_field_value ${objTcpMetrics} txrexmits]\x09${timeStamp}"
      }
    }
    foreach {objHttp} [tmsh::get_config /ltm profile http] {
      set httpName [tmsh::get_name ${objHttp}]
      foreach {objHttpMetrics} [tmsh::get_status /ltm profile http ${httpName} raw] {
        set outputHttpName [string map {{.} {_}} ${httpName}]
        puts "stats.bigip.http.${outputHttpName}.number-reqs\x09[tmsh::get_field_value ${objHttpMetrics} number-reqs]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.get-reqs\x09[tmsh::get_field_value ${objHttpMetrics} get-reqs]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.post-reqs\x09[tmsh::get_field_value ${objHttpMetrics} post-reqs]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.cookie-persist-inserts\x09[tmsh::get_field_value ${objHttpMetrics} cookie-persist-inserts]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.resp-2xx-cnt\x09[tmsh::get_field_value ${objHttpMetrics} resp-2xx-cnt]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.resp-3xx-cnt\x09[tmsh::get_field_value ${objHttpMetrics} resp-3xx-cnt]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.resp-4xx-cnt\x09[tmsh::get_field_value ${objHttpMetrics} resp-4xx-cnt]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.resp-5xx-cnt\x09[tmsh::get_field_value ${objHttpMetrics} resp-5xx-cnt]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.resp-bucket-1k\x09[tmsh::get_field_value ${objHttpMetrics} resp-bucket-1k]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.resp-bucket-2m\x09[tmsh::get_field_value ${objHttpMetrics} resp-bucket-2m]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.resp-bucket-4k\x09[tmsh::get_field_value ${objHttpMetrics} resp-bucket-4k]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.resp-bucket-16k\x09[tmsh::get_field_value ${objHttpMetrics} resp-bucket-16k]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.resp-bucket-32k\x09[tmsh::get_field_value ${objHttpMetrics} resp-bucket-32k]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.resp-bucket-64k\x09[tmsh::get_field_value ${objHttpMetrics} resp-bucket-64k]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.resp-bucket-128k\x09[tmsh::get_field_value ${objHttpMetrics} resp-bucket-128k]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.resp-bucket-512k\x09[tmsh::get_field_value ${objHttpMetrics} resp-bucket-512k]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.resp-bucket-large\x09[tmsh::get_field_value ${objHttpMetrics} resp-bucket-large]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.v9-reqs\x09[tmsh::get_field_value ${objHttpMetrics} v9-reqs]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.v9-resp\x09[tmsh::get_field_value ${objHttpMetrics} v9-resp]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.v10-reqs\x09[tmsh::get_field_value ${objHttpMetrics} v10-reqs]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.v10-resp\x09[tmsh::get_field_value ${objHttpMetrics} v10-resp]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.v11-reqs\x09[tmsh::get_field_value ${objHttpMetrics} v11-reqs]\x09${timeStamp}"
        puts "stats.bigip.http.${outputHttpName}.v11-resp\x09[tmsh::get_field_value ${objHttpMetrics} v11-resp]\x09${timeStamp}"
      }
    }
    foreach {objOneConn} [tmsh::get_config /ltm profile one-connect] {
      set oneConnName [tmsh::get_name ${objOneConn}]
      foreach {objOneConnMetrics} [tmsh::get_status /ltm profile one-connect ${oneConnName} raw] {
        set outputOneConnName [string map {{.} {_}} ${oneConnName}]
        puts "stats.bigip.one-connect.${outputOneConnName}.connects\x09[tmsh::get_field_value ${objOneConnMetrics} connects]\x09${timeStamp}"
        puts "stats.bigip.one-connect.${outputOneConnName}.cur-size\x09[tmsh::get_field_value ${objOneConnMetrics} cur-size]\x09${timeStamp}"
        puts "stats.bigip.one-connect.${outputOneConnName}.max-size\x09[tmsh::get_field_value ${objOneConnMetrics} max-size]\x09${timeStamp}"
        puts "stats.bigip.one-connect.${outputOneConnName}.reuses\x09[tmsh::get_field_value ${objOneConnMetrics} reuses]\x09${timeStamp}"
      }
    }
  }
}
