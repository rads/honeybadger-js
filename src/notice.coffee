class Honeybadger.Notice
  constructor: (@options = {}) ->
    @error = @options.error
    @trace = if @error then @_parseBacktrace(printStackTrace({e: @error})) else null
    @class = @error?.name
    @message = @error?.message
    @url = document.URL
    @project_root = Honeybadger.configuration.project_root
    @environment = Honeybadger.configuration.environment
    @component = Honeybadger.configuration.component
    @action = Honeybadger.configuration.action

    @context = {}
    for k,v of Honeybadger.context
      @context[k] = v
    if @options.context
      for k,v of @options.context
        @context[k] = v

    console.log @toJSON()

  toJSON: ->
    JSON.stringify
      notifier:
        name: 'honeybadger.js'
        url: 'https://github.com/honeybadger-io/honeybadger-js'
        version: Honeybadger.version
      error:
        class: @class
        message: @message
        backtrace: @trace
      request:
        url: @url
        component: @component
        action: @action
        context: @context
      server:
        project_root: @project_root
        environment_name: @environment

  _parseBacktrace: (lines) ->
    lines.map (line) ->
      [method, file, number] = line.match(/^(.+)\s\((.+):(\d+):(\d+)\)$/)[1..3]
      {
        file: file.replace(Honeybadger.configuration.project_root, '[PROJECT_ROOT]'),
        number: number,
        method: method
      }
