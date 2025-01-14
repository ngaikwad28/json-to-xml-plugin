local PLUGIN_NAME = "json-to-xml"
local helpers = require "spec.helpers"

for _, strategy in helpers.each_strategy() do
  describe(PLUGIN_NAME .. ": (response) [#" .. strategy .. "]", function()
    local client

    lazy_setup(function()
      local bp = helpers.get_db_utils(strategy, {
        "plugins",
      }, { PLUGIN_NAME })

      bp.plugins:insert({
        name = PLUGIN_NAME,
        config = {},
      })

      assert(helpers.start_kong({
        database = strategy,
        plugins = "bundled," .. PLUGIN_NAME,
      }))
    end)

    lazy_teardown(function()
      helpers.stop_kong()
    end)

    before_each(function()
      client = helpers.proxy_client()
    end)

    after_each(function()
      if client then
        client:close()
      end
    end)

    it("converts JSON responses to XML", function()
      local res = assert(client:send {
        method = "GET",
        path = "/",
        headers = {
          ["Accept"] = "application/xml",
        },
      })

      assert.response(res).has.status(200)
      local body = assert.response(res).has.body()
      assert.matches("^<%?xml", body)  -- XML responses should start with an XML declaration
    end)
  end)
end
