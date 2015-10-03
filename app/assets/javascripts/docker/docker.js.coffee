class window.DockerTabData
  constructor: (@id, @data) ->

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

  init: (linkTab) ->
    if @action() == 'get'
      @data = []
      @linkTab = linkTab
      @getContent()
      @initSearch()
      # @initLink()

  getContent: ->
    self = @
    settings = {
      type: @action()
      url: @url()
      dataType: @settings.dataType,
      success: (result) ->
        self.resultObjects = result
        $.each result, (result_index, res) ->
          self.data.push(new DockerTabData(result_index, res))
          dataAppend = self.format()
          $.each self.fieldNames(), (field_index, name) ->
            dataAppend = dataAppend.replace("%#{field_index}", res[name]);
          if self.settings.linkTo.length > 0
            self.contents().append("<a class=\"ac-a-#{self.id}\" data-data-id=\"#{result_index}\">#{dataAppend}</a>")
          else
            self.contents().append(dataAppend)
        self.initLink()
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

  initLink: ->
    self = @
    $(".ac-a-#{@id}").on 'click', ->
      $("#ac-#{self.linkTab.id}").prop('checked', true)
      $("#ac-#{self.id}").prop('checked', false)
      tabDetails = self.data[$(@).data('dataId')].data
      $.each self.linkTab.fieldNames(), (i, name) ->
        $("#ac-#{self.linkTab.id}-field-#{name}").html(tabDetails[name])

  contents: ->
    $("#ac-#{@id} ~ article")

  searchInput: ->
    $("#ac-search-#{@id}")

  addSearch: ->
    if @settings.searchEnabled
      "<input type=\"text\" name=\"search\" id=\"ac-search-#{@id}\" placeholder=\"Search\" style=\"width: 100%;\">"
    else
      ''

  fieldHtml: ->
    self = @
    fieldHtml = ''
    $.each @fieldNames(), (i, name) ->
      fieldHtml += "<h4 style=\"text-transform: capitalize;\">#{name}</h4><p id=\"ac-#{self.id}-field-#{name}\"></p>"
    fieldHtml

  detailHtml: ->
    "<div>
      <input id=\"ac-#{@id}\" name=\"accordion-#{@id}\" type=\"checkbox\" />
      <label for=\"ac-#{@id}\">#{@title()}</label>
      <article class=\"ac-small\">
        #{@fieldHtml()}
      </article>
    </div>"

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
    else if @action() == 'detail'
      @detailHtml()
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
    self = @
    $.each @tabs, (i, tab) ->
      tabHtml += "#{tab.contentHtml()}"
    tabHtml

  initTabs: ->
    self = @
    $.each @tabs, (i, tab) ->
      if tab.settings.linkTo.length > 0
        matches = $.grep self.tabs, (e) ->
          e.title() == tab.settings.linkTo
        if matches.length == 0
          tab.init()
        else if matches.length > 0
          tab.init(matches[0])
      else
        tab.init()

  slideMenu: ->
    $('.slideout-menu')

  slideInit: ->
    self = @
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
    title: '',
    action: '',
    url: '',
    fieldNames: [],
    format: '',
    linkTo: '',
    searchEnabled: false,
    authorizationEnabled: false,
    authorization: {}
