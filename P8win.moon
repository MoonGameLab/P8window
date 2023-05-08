love = love
graphics = love.graphics

moduleConf = {
  debug: true
  moduleName: "P8win"
}

local dump

if moduleConf.debug then
  m = assert require("moon")
  dump = m.p

class Singleton
  __inherited: (By) =>
    By.getInstance = (...) ->
      if I = By.Instance then return I
      with I = By ...
        By.Instance = I

class P8Win extends Singleton

  --- class var: Windows size (conf.moon/lua)
  @winSize = {
    width: graphics.getWidth! 
    height: graphics.getHeight! 
  }

  --- debug function
  @pDebug: (...) =>
    if moduleConf.debug
      t = {...}
      if #t == 1 and type(t[1]) == 'string'
        print moduleConf.moduleName .. ': ' .. t[1] 
      else
        print moduleConf.moduleName
        dump {...}

  new: =>
    @@pDebug "Initializing."







P8Win!