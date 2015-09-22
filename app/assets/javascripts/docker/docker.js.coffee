class window.Docker
  constructor: (@container, options) ->
    @settings = $.extend({}, $.fn.dock.defaults, options)
    $(@container).prepend(@dockHtml())
    @slideInit()
    @tabCollapseInit()
    @tabGetInit()

  dockHtml: ->
    "<div class=\"slideout-menu\">
      <h3>#{@settings.title} <a href=\"#\" class=\"slideout-menu-toggle\">×</a></h3>
      #{@tabHtml()}
    </div>
    <button class=\"slideout-menu-toggle\">Dock And Load</button>"

  tabHtml: ->
    tabHtml = ''
    self = this
    $.each @settings.tabs, (i, tab) ->
      tabHtml += "
      <div id=\"dock-tab-content-title-#{tab.title}\" class=\"page_collapsible collapse-close\" data-tab=\"#{tab.title}\">#{tab.title}<span></span></div>
      #{self.tabHtmlContent(tab)}
      "
    tabHtml

  tabHtmlContent: (tab) ->
    if tab.action == 'get'
      "
      <div id=\"dock-tab-content-#{tab.title}\" class=\"container dock-tab-get-contents\">
        <div class=\"content\" style=\"display: none;\">
          <div data-url=\"#{tab.url}\" data-field-names=\"#{tab.fieldNames.join('|')}\" data-format=\"#{tab.format}\">
          </div>
        </div>
      </div>
      "
    # else if tab.action == 'post'

  tabCollapseInit: ->
    @slideMenu().on 'click', "[id^=dock-tab-content-title]", ->
      if $(@).hasClass('collapse-close')
        $(@).removeClass('collapse-close')
        $(@).addClass('collapse-open')
        $("#dock-tab-content-#{$(@).data('tab')} > .content").fadeIn()
      else
        $(@).removeClass('collapse-open')
        $(@).addClass('collapse-close')
        $("#dock-tab-content-#{$(@).data('tab')} > .content").fadeOut()

  tabGetInit: ->
    $.each @slideMenu().find('.dock-tab-get-contents > .content > div'), ->
      self = this
      fieldNames = $(@).data('fieldNames').split('|')
      format = $(@).data('format')
      $.get $(@).data('url'), (result) ->
        $.each result, (i, res) ->
          dataAppend = format
          $.each fieldNames, (i, name) ->
            dataAppend = dataAppend.replace("%#{i}", res[name]);
          $(self).append(dataAppend)

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




# $(function() {
#   $('#nav').stop().animate({'marginRight':'-100px'},1000);

# function toggleDivs() {
#     var $inner = $("#nav");
#     if ($inner.position().right == "-100px") {
#         $inner.animate({right: 0});
#     $(".nav-btn").html('<img src="images/slide-out.png" alt="open" />')
#     }
#     else {
#         $inner.animate({right: "100px"});
#     $(".nav-btn").html('<img src="images/slide-out.png" alt="close" />')
#     }
# }
# $(".nav-btn").bind("click", function(){
#     toggleDivs();
# });

# });

# class window.MultiSelectCondition extends Condition
#   constructor: (@container) ->
#     super
#     self = this
#     self.isConditionMet(self.getValue(self.container))
#     if self.viewType() == 'check'
#       $(this.container).find("input[type=checkbox]").each ->
#         $(this).on 'change', (e) ->
#           self.isConditionMet(self.getValue(self.container))

#   getValue: (target_container) ->
#     values = []
#     $(target_container).find("input:checked").each (e) ->
#       values.push($(this).parentsUntil('div', 'label').text().trim())
#     values

jQuery ->
  $.fn.extend
    dock: (options) ->
      this.each ->
        new Docker(this, options)
  $.fn.dock.defaults =
    title: 'Dock &amp; Load Sidebar',
    tabs: []
