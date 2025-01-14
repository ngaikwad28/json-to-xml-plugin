# json-to-xml-plugin


# json-to-xml-plugin for Kong

## Overview

The `json-to-xml-plugin` for Kong Gateway provides conversion  functionalities for responses coming from backend.

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/json-to-xml-plugin.git
   cd json-to-xml-plugin
=========================================================================================
### 2. Install Dependencies
Install required libraries (xml2lua and lua-cjson):

   ```bash
      sudo luarocks install xml2lua
      sudo luarocks install lua-cjson


=========================================================================================
### 3. Install and Enable the Plugin

1. **Install the Plugin**

   If you have LuaRocks installed, navigate to the plugin directory and run:

   ```bash
   sudo luarocks make kong-plugin-json-to-xml-1.0-1.rockspec

# Enable the Plugin

 ```bash
curl -X POST http://localhost:8001/services/{service_id}/plugins \
     --data "name=json-to-xml-plugin"








