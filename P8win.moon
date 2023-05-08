love = love
graphics = love.graphics
window = love.window
print = print

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

  --- class configuration
  @conf = {
    allowResize: false
    globalScaling: true
    pixelPerfectFullscreen: false
    cursor: 0 --- 0 OS cursor
    showSysCursor: true
  }

  --- Sets the default filter and line style globaly. (Pixel centred)
  @setGlobalFilterlLineStyle: =>
    if @@conf.globalScaling
      @@pDebug "Setting DefaultFilter && LineStyle"
      graphics.setDefaultFilter "nearest", "nearest", 1 -- https://love2d.org/wiki/love.graphics.setDefaultFilter
      graphics.setLineStyle "rough" -- https://love2d.org/wiki/love.graphics.setLineStyle

  --- debug function
  @pDebug: (...) =>
    if moduleConf.debug
      t = {...}
      if #t == 1 and type(t[1]) == 'string'
        print moduleConf.moduleName .. ': ' .. t[1] 
      else
        print moduleConf.moduleName
        dump {...}

  getMonitorSize: =>
    w, h = window.getDesktopDimensions 1
    @monitor = {
      w: w,
      h: h,
    }
  
  getMaxScale: =>
    fWidth = @monitor.w / @@winSize.width
    fheight = @monitor.h / @@winSize.height
    math = math
    if fheight < fWidth
      @maxScale = @monitor.h / @@winSize.height
      @maxWinScale = math.floor (@monitor.h - 125) / @@winSize.height
    else
      @maxScale = @monitor.w / @@winSize.width
      @maxWinScale = math.floor (@monitor.w - 125) / @@winSize.width

    @@pDebug "scale", @maxScale, @maxWinScale

    
  new: =>
    @@pDebug "Initializing."
    
    @monitor = {}
    @maxScale = 0
    @maxWinScale = 0

    @@setGlobalFilterlLineStyle!
    @mainCanvas = graphics.newCanvas @@winSize.width, @@winSize.height
    @shaderCanvas = graphics.newCanvas @@winSize.width, @@winSize.height
    @getMonitorSize!
    @getMaxScale!



P8Win!