local cjson = require "cjson"
local xml2lua = require "xml2lua"
local handler = require "xmlhandler.tree"

local ngx = ngx
local kong = kong

local JsonToXmlPlugin = {}

-- Constructor
function JsonToXmlPlugin:new()
  local obj = {}
  setmetatable(obj, self)
  self.__index = self
  return obj
end

-- Header filter phase
function JsonToXmlPlugin:header_filter()
  -- Change the Content-Type header to "application/xml"
  ngx.header["Content-Type"] = "application/xml"
  -- Remove Content-Length header to support body modification
  ngx.header["Content-Length"] = nil
end

-- Body filter phase
function JsonToXmlPlugin:body_filter()
  local chunk = ngx.arg[1]
  local eof = ngx.arg[2]

  if not ngx.ctx.buffer then
    ngx.ctx.buffer = ""
  end

  if chunk then
    ngx.ctx.buffer = ngx.ctx.buffer .. chunk
    ngx.arg[1] = nil  -- Clear chunk to prevent outputting raw data
  end

  if eof then
    local success, decoded_json = pcall(cjson.decode, ngx.ctx.buffer)
    if success then
      -- Convert JSON to XML
      local handler_instance = handler:new()
      local parser = xml2lua.parser(handler_instance)
      xml2lua.toXml(handler_instance, decoded_json)
      local xml_response = handler_instance.root

      ngx.arg[1] = xml_response
    else
      ngx.log(ngx.ERR, "Failed to decode JSON response")
      ngx.arg[1] = ngx.ctx.buffer  -- Return original response if conversion fails
    end
  end
end

-- Define the plugin priority (mandatory)
JsonToXmlPlugin.PRIORITY = 10

-- Define the plugin version (mandatory)
JsonToXmlPlugin.VERSION = "1.0.0"

return JsonToXmlPlugin
