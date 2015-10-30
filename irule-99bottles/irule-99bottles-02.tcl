# 99 Bottles of Beer on the Wall :: Simple text version
# Sean Jain Ellis <sellis@bandarji.com> @bandarji
#
# Make this iRule "irule.99bottles"
# Create virtual service
# Visit http://x.x.x.x:x/ with favorite browser
#
# Virtual service creation:
# tmsh create / ltm virtual vip.99bottles.10000 { \
#   destination x.x.x.x:10000 ip-protocol tcp \
#   mask 255.255.255.255 rules { irule.99bottles } \
#   profiles add { tcp {} http {} } }
#
# Test with cURL:
# $ curl -x '' -s0 http://x.x.x.x:10000/
#
when HTTP_REQUEST {
  set lyrics ""
  for { set bottleCount 99 } { $bottleCount >= 0 } { incr bottleCount -1 } {
    if { $bottleCount == 1 } {
      set bottleString "bottle"
      set variationLine "One bottle remains, so this is last call, "
    } else {
      if { $bottleCount == 0 } {
        set bottleString "bottles"
        set variationLine "Go to the store to purchase some more, "
      } else {
        set bottleString "bottles"
        if { [expr { int ( 99 * rand() ) } ] % 4 == 0 } {
          set variationLine "If one of those bottles should happen to fall, "
        } else {
          set variationLine "Take one down, pass it around, "
        }
      }
    }
    append lyrics "$bottleCount $bottleString of beer on the wall, $bottleCount $bottleString of beer\n"
    append lyrics "$variationLine"
    append lyrics "$bottleCount $bottleString of beer on the wall\n\n"
  }
  HTTP::respond 200 content "$lyrics" noserver Content-Type text/plain pragma no-cache
}
#
