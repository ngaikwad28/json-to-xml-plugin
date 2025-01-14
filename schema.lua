local typedefs = require "kong.db.schema.typedefs"

return {
  name = "json-to-xml-plugin",
  fields = {
    { consumer = typedefs.no_consumer },
    { protocols = typedefs.protocols_http },  -- Supports HTTP/HTTPS only
    { config = {
        type = "record",
        fields = {},
      },
    },
  },
}
