class window.DockerTab
  constructor: (options, @id) ->
    @settings = $.extend({}, $.fn.dock.tabDefaults, options)

  title: ->
    @settings.title

  action: ->
    @settings.action

  url: ->
    @settings.url

  fieldNames: ->
    @settings.fieldNames

  format: ->
    @settings.format

  init: ->
    if @action() == 'get'
      @getContent()
      @initSearch()

  getContent: ->
    self = @
    settings = {
      type: @action()
      url: @url()
      dataType: @settings.dataType,
      crossOrigin: true,
      contentType: 'multipart/form-data'
      success: (result) ->
        $.each result, (i, res) ->
          dataAppend = self.format()
          $.each self.fieldNames(), (i, name) ->
            dataAppend = dataAppend.replace("%#{i}", res[name]);
          self.contents().append(dataAppend)
      error: (jqXHR, textStatus, errorThrown) ->
        alert(errorThrown + " : " + textStatus)
    }

    if @settings.authorizationEnabled
      $.extend(settings, {
        beforeSend: (xhr) ->
          if self.settings.authorization.type == 'Basic'
            xhr.setRequestHeader("Authorization", "Basic " + btoa(self.settings.authorization.username + ":" + self.settings.authorization.password))
          else if self.settings.authorization.type == 'Token'
            xhr.setRequestHeader("Authorization", "Token token=#{self.settings.authorization.token}")
            xhr.setRequestHeader("Access-Control-Allow-Origin", "true")
        }
      )

    $.ajax @url(), settings

  initSearch: ->
    if @settings.searchEnabled
      @searchInput().on 'keyup', ->
        query = $(@).val()
        $(@).parents('article').children(':not(input)').show()
        $(@).parents('article').children(':not(input)').not(":contains('#{query}')").hide()

  contents: ->
    $("#ac-#{@id} ~ article")

  searchInput: ->
    $("#ac-search-#{@id}")

  addSearch: ->
    if @settings.searchEnabled
      "<input type=\"text\" name=\"search\" id=\"ac-search-#{@id}\" placeholder=\"Search\" style=\"width: 100%;\">"
    else
      ''

  getHtml: ->
    "<div>
      <input id=\"ac-#{@id}\" name=\"accordion-#{@id}\" type=\"checkbox\" />
      <label for=\"ac-#{@id}\">#{@title()}</label>
      <article class=\"ac-small\">
        #{@addSearch()}
      </article>
    </div>"

  contentHtml: ->
    if @action() == 'get'
      @getHtml()
    # else if tab.action == 'post'

class window.Docker
  constructor: (@container, options) ->
    @settings = $.extend({}, $.fn.dock.defaults, options)
    @tabs = []
    self = @
    $.each @settings.tabs, (i, options) ->
      self.tabs.push(new DockerTab(options, i))

    $(@container).prepend(@dockHtml())
    @slideInit()
    @initTabs()

  dockHtml: ->
    "<div class=\"slideout-menu\">
      <div class=\"slideout-menu-inner\">
        <span class=\"slideout-menu-toggle\"></span>
      </div>
      <h3>#{@settings.title}</h3>
      <section class=\"ac-container\">
        #{@tabHtml()}
      </section>
    </div>"

  tabHtml: ->
    tabHtml = ''
    self = this
    $.each @tabs, (i, tab) ->
      tabHtml += "#{tab.contentHtml()}"
    tabHtml

  initTabs: ->
    $.each @tabs, (i, tab) ->
      tab.init()

  slideMenu: ->
    $('.slideout-menu')

  slideInit: ->
    self = this
    $('.slideout-menu-toggle').on 'click', (event) ->
      event.preventDefault()
      self.slideMenu().toggleClass('open')

jQuery ->
  $.fn.extend
    dock: (options) ->
      @.each ->
        new Docker(@, options)
  $.fn.dock.defaults =
    title: 'Dock &amp; Load Sidebar',
    tabs: [],
    dataType: 'json'
  $.fn.dock.tabDefaults =
    searchEnabled: true,
    authorizationEnabled: false,
    authorization: {}
