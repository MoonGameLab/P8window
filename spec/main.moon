export Log = assert require "lib.log.log"
p8 = assert require "lib.P8win"


with love
  .load = ->
    export screen = p8 1, { {"assets/cursors/trig1.png", 0, 0} }
  .update = (dt) ->
    screen\update dt  
  
  .draw = ->
    screen\start!
    screen\stop!