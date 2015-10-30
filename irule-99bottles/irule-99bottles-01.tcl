# 99 Bottles of Beer on the Wall :: Simple version
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
when HTTP_REQUEST {
  set lyrics "<html><head><title>99 Bottles of Beer on the Wall</title></head><body>\n"
  for { set bottleCount 99 } { $bottleCount > 0 } { incr bottleCount -1 } {
    if { $bottleCount == 1 } {
      set bottleString "bottle"
      set variationLine "One bottle remains, so this is last call<br>\n"
    } else {
      set bottleString "bottles"
      if { [expr { int ( 99 * rand() ) } ] % 4 == 0 } {
        set variationLine "If one of those bottles should happen to fall<br>\n"
      } else {
        set variationLine "Take one down, pass it around<br>\n"
      }
    }
    append lyrics "<p>$bottleCount $bottleString of beer on the wall<br>\n"
    append lyrics "$bottleCount $bottleString of beer<br>\n"
    append lyrics "$variationLine"
    append lyrics "$bottleCount $bottleString of beer on the wall</p>\n"
  }
  append lyrics "</body></html>"
  HTTP::respond 200 content "$lyrics" noserver Content-Type text/html pragma no-cache
}
#
