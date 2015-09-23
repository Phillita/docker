class window.DockerTab
  constructor: (@settings, @id) ->

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
    @collapseInit()
    if @action() == 'get'
      @getContent()
      @initSearch()

  getContent: ->
    self = @
    $.get @url(), (result) ->
      $.each result, (i, res) ->
        dataAppend = self.format()
        $.each self.fieldNames(), (i, name) ->
          dataAppend = dataAppend.replace("%#{i}", res[name]);
        self.contents().append(dataAppend)

  initSearch: ->
    @searchInput().on 'keyup', ->
      query = $(@).val()
      $(@).siblings('div').children().show()
      $(@).siblings('div').children().not(":contains('#{query}')").hide()

  collapseInit: ->
    self = @
    @headerDiv().on 'click', ->
      if $(@).hasClass('collapse-close')
        $(@).removeClass('collapse-close')
        $(@).addClass('collapse-open')
        self.contentDiv().fadeIn()
      else
        $(@).removeClass('collapse-open')
        $(@).addClass('collapse-close')
        self.contentDiv().fadeOut()

  headerDiv: ->
    $("#dock-tab-content-title-#{@id}")

  contents: ->
    $("#dock-tab-content-#{@id} > .content > div")

  contentDiv: ->
    $("#dock-tab-content-#{@id} > .content")

  searchInput: ->
    $("#dock-tab-content-#{@id} > .content > input")

  headerHtml: ->
    "<div id=\"dock-tab-content-title-#{@id}\" class=\"page_collapsible collapse-close\" data-tab=\"#{@id}\">#{@title()}<span></span></div>"

  getHtml: ->
    "<div id=\"dock-tab-content-#{@id}\" class=\"container dock-tab-get-contents\">
      <div class=\"content\" style=\"display: none;\">
        <input type=\"text\" name=\"search\" class=\"dock-tab-content-search\" placeholder=\"Search\" style=\"width: 100%;\">
        <div data-tab=\"#{@id}\">
        </div>
      </div>
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
        <span></span>
      </div>
      <h3>#{@settings.title} <a href=\"#\" class=\"slideout-menu-toggle\">×</a></h3>
      #{@tabHtml()}
    </div>
    <button class=\"slideout-menu-toggle\">Dock And Load</button>"

  tabHtml: ->
    tabHtml = ''
    self = this
    $.each @tabs, (i, tab) ->
      tabHtml += "#{tab.headerHtml()}#{tab.contentHtml()}"
    tabHtml

  initTabs: ->
    $.each @tabs, (i, tab) ->
      tab.init()

  slideMenu: ->
    $('.slideout-menu')

  isOpen: ->
    @slideMenu().hasClass('open')

  slideOpen: ->
    @slideMenu().addClass("open")
    @slideMenu().animate
      left: "0px"

  slideClose: ->
    @slideMenu().removeClass("open")
    @slideMenu().animate({ left: -@slideMenu().width() }, 250)

  slideInit: ->
    self = this
    $('.slideout-menu-toggle').on 'click', (event) ->
      event.preventDefault()

      if !self.isOpen()
        self.slideOpen()
      else
        self.slideClose()

jQuery ->
  $.fn.extend
    dock: (options) ->
      this.each ->
        new Docker(this, options)
  $.fn.dock.defaults =
    title: 'Dock &amp; Load Sidebar',
    tabs: []
