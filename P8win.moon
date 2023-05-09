love = love
graphics = love.graphics
window = love.window
mouse = love.mouse
print = print

---generale conf for P8win module.
-- @table moduleConf
-- @field debug debugMode
-- @field moduleName moduleName
moduleConf = {
  debug: true
  moduleName: "P8win"
}

local dump

if moduleConf.debug then
  m = assert require("moon")
  dump = m.p

--- @local
class Singleton
  __inherited: (By) =>
    By.getInstance = (...) ->
      if I = By.Instance then return I
      with I = By ...
        By.Instance = I

--- pixel focused screen scaling.
-- @classmod P8Win
class P8Win extends Singleton

  --- window size defined in conf.lua/moon
  -- @table moduleCwinSizeonf
  -- @field width
  -- @field height
  @winSize = {
    width: graphics.getWidth! 
    height: graphics.getHeight! 
  }

  --- TODO: better cursors loading
  --- @local
  @cursorsPaths = {
    {"P8window/assets/cursors/trig1.png", 0, 0}
  }

  --- module configuration
  -- @table conf
  -- @field allowResize
  -- @field globalScaling
  -- @field pixelPerfectFullscreen
  -- @field cursor
  -- @field showSysCursor
  @conf = {
    allowResize: false
    globalScaling: true
    pixelPerfectFullscreen: false
    cursor: 0 --- 0 OS cursor
    showSysCursor: false -- to use the costom cursor
  }

  --- sets the default filter and line style globaly. (Pixel centred)
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

  --- gets the desk dimensions
  getMonitorSize: =>
    w, h = window.getDesktopDimensions 1
    @monitor = {
      w: w,
      h: h,
    }
  
  --- gets the max scale for the window
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

  --- calculates the fullscreen offset for the canvas in full screen mode
  -- @tparam number height
  -- @tparam number width
  calcFullScreenOffset: (height = @@winSize.height, width = @@winSize.width) =>
    math = math
    fullScale = @maxScale

    if @pixelPerfectFullscreen
      fullScale = math.floor @maxScale

    gameWidth = @@winSize.width * fullScale
    blankWidth = width - gameWidth

    gameHeight = @@winSize.height * fullScale
    blankHeight = height - gameHeight

    @offset.x = math.floor blankWidth/2 
    @offset.y = math.floor blankHeight/2

    if window.getFullscreen! == false
      @offset = {x: 0, y: 0}

  --- sets the scale
  -- @tparam number scale
  setGameScale: (scale) =>
    @scale = scale
    window.setMode @@winSize.width * @scale, @@winSize.height * @scale,  {fullscreen: false, resizable: @@conf.allowResize, highdpi: false}

  --- sets cursor visibility
  -- @tparam bool visible
  setCursorVisibility: (visible) =>
    mouse.setVisible visible

  --- creates images for the custom cursors
  createCustomMouse: =>
    for k, v in pairs @@cursorsPaths
      @cursors[k] = graphics.newImage v[1]

  --- updates the custom mouse
  updateCustomMouse: =>
    math = math
    @mouse.x = math.floor (mouse.getX! - @offset.x) / @scale
    @mouse.y = math.floor (mouse.getY! - @offset.y) / @scale
    
  --- init the instance
  -- @tparam number scale
  new: (scale) =>
    @@pDebug "Initializing."
    @monitor = {}
    @maxScale = 0
    @scale = 0
    @maxWinScale = 0
    @offset = {
      x: 0
      y: 0
    }
    @mouse = {
      x: 0
      y: 0
    }
    @cursors = {}
    @currentCursor = 1

    @@setGlobalFilterlLineStyle!
    @createCustomMouse!
    @mainCanvas = graphics.newCanvas @@winSize.width, @@winSize.height
    @shaderCanvas = graphics.newCanvas @@winSize.width, @@winSize.height
    @shaderPool = {}
    @getMonitorSize!
    @getMaxScale!
    @calcFullScreenOffset!
    dScale = scale or @maxWinScale
    @setGameScale dScale
    @setCursorVisibility @@conf.showSysCursor


  update: (dt) =>
    @updateCustomMouse!
    @calcFullScreenOffset!

  start: =>
    graphics.setCanvas {@mainCanvas, stencil: true}
    graphics.clear 0, 0, 0, 1
    graphics.setColor 1, 1, 1, 1

  stop: (hx = 0, hy = 0, hr = 0, hsx = 0, hsy = 0) =>
    for shader=1, #@shaderPool
      graphics.setCanvas {@shaderCanvas, stencil: true}
      graphics.setShader @shaderPool[shader]
      graphics.draw @mainCanvas
      graphics.setShader!
      graphics.setCanvas {@mainCanvas, stencil: true}
      graphics.draw @shaderCanvas

    -- TODO draw after shader
    if @currentCursor > 0 and @currentCursor <= #@cursors
      graphics.draw @cursors[@currentCursor], @mouse.x - @@cursorsPaths[@currentCursor][2], @mouse.y - @@cursorsPaths[@currentCursor][3]
      
    graphics.setCanvas!
    graphics.draw @mainCanvas, hx + @offset.x, hy + @offset.y, hr, hsx + @scale, hsy + @scale



P8Win!