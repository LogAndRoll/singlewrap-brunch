fs = require "fs"
module.exports = class SingleWrap
  brunchPlugin: yes
  type: 'javascript'
  extension: 'js'

  constructor: (@config) ->
    @singleWrapConfig =

      # We add \n to avoid possible conflicts with comments at the end of a line
      wrap: (file, code) ->
        return "(function(){\n#{code}\n})();"

    userConfig = @config.plugins?.singlewrap or {}

    for k of @singleWrapConfig
      if userConfig[k]
        @singleWrapConfig[k] = userConfig[k]

  onCompile: (generatedFiles) ->

    for file in generatedFiles
      path = file.path
      code = fs.readFileSync(path) + ""
      fs.writeFileSync(path, @singleWrapConfig.wrap(path, code))