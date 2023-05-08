love = love
graphics = love.graphics



class p8Win

  --- class var : Windows size (conf.moon/lua)
  @winSize = {
    width: graphics.getWidth! 
    height: graphics.getHeight! 
  }

  new: =>