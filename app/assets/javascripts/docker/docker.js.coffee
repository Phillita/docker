class window.Docker
  constructor: (container) ->
    @container = container
    $(@container).prepend(this.dockHtml())
    this.slideInit()

  dockHtml: ->
    '<div class="slideout-menu">
      <h3>Menu <a href="#" class="slideout-menu-toggle">×</a></h3>
      <ul>
        <li><a href="#">Home <i class="fa fa-angle-right"></i></a></li>
        <li><a href="#">Tour Information <i class="fa fa-angle-right"></i></a></li>
        <li><a href="#">Tour Pricing <i class="fa fa-angle-right"></i></a></li>
        <li><a href="#">Photo Gallery <i class="fa fa-angle-right"></i></a></li>
        <li><a href="#">News & Events <i class="fa fa-angle-right"></i></a></li>
      </ul>
    </div>
    <button class="slideout-menu-toggle"></button>'

  slideMenu: ->
    $('.slideout-menu')

  isOpen: ->
    this.slideMenu().hasClass('open')

  slideOpen: ->
    this.slideMenu().addClass("open")
    this.slideMenu().animate
      left: "0px"

  slideClose: ->
    this.slideMenu().removeClass("open")
    this.slideMenu().animate({ left: -this.slideMenu().width() }, 250)

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
  $.fn.extend {
    dock: () ->
      this.each ->
        new Docker(this)
  }
