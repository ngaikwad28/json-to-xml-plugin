local cjson = require "cjson"
local xml2lua = require "xml2lua"
local xml_handler = require "xmlhandler.tree"

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

  -- Initialize buffer in the request context if not already present
  if not ngx.ctx.buffer then
    ngx.ctx.buffer = ""
  end

  -- Append the current chunk to the buffer
  if chunk then
    ngx.ctx.buffer = ngx.ctx.buffer .. chunk
    ngx.arg[1] = nil  -- Clear chunk to prevent outputting raw data prematurely
  end

  -- If it's the end of the body, process the complete response
  if eof then
    -- Decode the buffered JSON response
    local success, decoded_json = pcall(cjson.decode, ngx.ctx.buffer)
    if success then
      -- Convert JSON to XML
      local handler_instance = xml_handler:new()
      local parser = xml2lua.parser(handler_instance)

      -- Serialize JSON to XML
      local success, xml_data = pcall(function()
        return xml2lua.toXml(decoded_json)
      end)

      if success then
        ngx.arg[1] = xml_data -- Send the converted XML data
      else
        ngx.log(ngx.ERR, "Error converting JSON to XML: ", xml_data)
        ngx.arg[1] = ngx.ctx.buffer -- Fallback to original JSON if conversion fails
      end
    else
      ngx.log(ngx.ERR, "Failed to decode JSON response: ", ngx.ctx.buffer)
      ngx.arg[1] = ngx.ctx.buffer -- Return original response if JSON decoding fails
    end
  end
end

-- Define the plugin priority (mandatory)
JsonToXmlPlugin.PRIORITY = 10

-- Define the plugin version (mandatory)
JsonToXmlPlugin.VERSION = "1.0.0"

return JsonToXmlPlugin
