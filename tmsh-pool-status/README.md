# tmsh-pool-status
F5 BIG-IP Traffic Manager shell script to report pool status (JSON output)

Sample Output
=============

    [codetest@bandarji ~]$ ssh -l root dfw-p-c3.company.tld 'tmsh run /cli script poolStatus.tcl dfw-p-c3 pool.dxn-cache.8080'
    {
      "slb": "dfw-p-c3",
      "pool": "pool.dxn-cache.8080",
      "configuration": {
        "monitor": "tcp_half_open",
        "load-balancing-mode": "least-connections-member",
        "min-active-members": 1,
        "slow-ramp-time": 90,
        "members": [
          { "member": "172.20.245.24:webcache", "connection-limit": 0, "priority-group": 50 },
          { "member": "172.20.245.25:webcache", "connection-limit": 0, "priority-group": 50 },
          { "member": "172.50.245.32:webcache", "connection-limit": 0, "priority-group": 30 },
          { "member": "172.50.245.35:webcache", "connection-limit": 0, "priority-group": 30 },
          {}
        ]
      },
      "status": {
        "serverside.bits-in": 8308561702080, "serverside.bits-out": 55665550671952,
        "serverside.cur-conns": 21, "serverside.max-conns": 412,
        "serverside.pkts-in": 6630648856, "serverside.pkts-out": 7027373927,
        "serverside.tot-conns": 1442629350,
        "status.availability-state": "available",
        "status.enabled-state": "enabled",
        "status.status-reason": "The pool is available",
        "members": [
          {
            "addr": "172.20.245.24", "port": 8080,
            "status.enabled-state": "enabled",
            "status.availability-state": "available",
            "status.status-reason": "Pool member is available",
            "serverside.bits-in": 4154260964072, "serverside.bits-out": 27813157235640,
            "serverside.cur-conns": 10, "serverside.max-conns": 313,
            "serverside.pkts-in": 3315758878, "serverside.pkts-out": 3514869794,
            "serverside.tot-conns": 721258231, "tot-requests": 721258040
          },
          {
            "addr": "172.20.245.25", "port": 8080,
            "status.enabled-state": "enabled",
            "status.availability-state": "available",
            "status.status-reason": "Pool member is available",
            "serverside.bits-in": 4154300738008, "serverside.bits-out": 27852393436312,
            "serverside.cur-conns": 11, "serverside.max-conns": 199,
            "serverside.pkts-in": 3314889978, "serverside.pkts-out": 3512504133,
            "serverside.tot-conns": 721371119, "tot-requests": 721371119
          },
          {
            "addr": "172.50.245.32", "port": 8080,
            "status.enabled-state": "enabled",
            "status.availability-state": "available",
            "status.status-reason": "Pool member is available",
            "serverside.bits-in": 2910356142976, "serverside.bits-out": 30098348736512,
            "serverside.cur-conns": 0, "serverside.max-conns": 142,
            "serverside.pkts-in": 2508065242, "serverside.pkts-out": 3375715365,
            "serverside.tot-conns": 479911983, "tot-requests": 479911976
          },
          {
            "addr": "172.50.245.33", "port": 8080,
            "status.enabled-state": "enabled",
            "status.availability-state": "available",
            "status.status-reason": "Pool member is available",
            "serverside.bits-in": 2991278452600, "serverside.bits-out": 30135374088424,
            "serverside.cur-conns": 0, "serverside.max-conns": 143,
            "serverside.pkts-in": 2700296846, "serverside.pkts-out": 3454410321,
            "serverside.tot-conns": 479912097, "tot-requests": 479912081
          },
          {}
        ]
      }
    }

Notes
=====

TMOS v10 and v11 have different fields available, so both versions are included.
