package = "kong-plugin-json-to-xml"
version = "0.1.0-1"
rockspec_format = "1.0"
description = {
  summary = "A Kong plugin to convert JSON responses to XML format",
  homepage = "https://your-plugin-homepage.com",
  license = "MIT",
}

dependencies = {
  "lua >= 5.1",
  "kong >= 3.0",
  "xml2lua >= 1.5",
  "lua-cjson >= 2.1.0",
}
source = {
  url = "/home/kong/Desktop/kong-plugin-master",
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins.json-to-xml.handler"] = "handler.lua",
    ["kong.plugins.json-to-xml.schema"] = "schema.lua",
  },
}
