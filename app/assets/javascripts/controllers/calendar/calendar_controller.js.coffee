$.Controller "CalendarController",
  house_data: prices:[],employtments:[]
  init: ->
    CalendarMonthController.max_date = new Date((new Date).setHours(0,0,0,0) + 365*86400*1000)
    CalendarMonthController.min_date = new Date();
    @months_strip = @element.find('.b_months_strip')
    @months_ctrls = []
    today = new Date
    @get_prices()
    @add_month(2013, today.getMonth())
    @add_month(2013, today.getMonth() + 1)
    @check_height()
    
  get_prices: ->
    self = @
    $.ajax
      url:"/apartments/get_prices"
      data:"id="+$("#apartmnet_content").data("id")
      async:false
      success: (resp)->
       self.set_data(resp)
  set_data: (data) ->
    @parent.house_data = data
  add_month: (year, month) ->
    new_month = $('<div class="b_month"></div>').attachCalendarMonthController({year: year, month: month, calendar: this})
    @months_strip.append(new_month)
    @months_ctrls.push(new_month.controller())

  check_height: ->
    w_c = (ctrl.weeks_count for ctrl in @months_ctrls)
    max_count = _(w_c).max()

    for ctrl in @months_ctrls
      if ctrl.weeks_count < max_count
        _(max_count - ctrl.weeks_count).times ->
          ctrl.element.find('table').append('<tr><td/><td/><td/><td/><td/><td/><td/></tr>')

  ".prev_month -> click": (ev) ->
    ev.preventDefault()
    ctrl = @months_strip.find('.b_month:first-child').controller()

    prev_year = ctrl.year
    prev_month = ctrl.month - 1
    if prev_month < 0
      prev_month = 11
      prev_year -= 1

    @element.find('.b_month:not(:last-child)').each -> $(this).controller().render()
    @element.find('.b_month:last-child')
      .prependTo(@months_strip)
      .controller().render(prev_year, prev_month)
    @check_height()

  ".next_month -> click": (ev) ->
    ev.preventDefault()
    ctrl = @months_strip.find('.b_month:last-child').controller()

    nxt_year = ctrl.year
    nxt_month = ctrl.month + 1
    if nxt_month > 11
      nxt_month = 0
      nxt_year += 1

    @element.find('.b_month:not(:first-child)').each -> $(this).controller().render()
    @element.find('.b_month:first-child')
      .appendTo(@months_strip)
      .controller().render(nxt_year, nxt_month)
    @check_height()

  update_all: ->
    ctrl.update_selection() for ctrl in @months_ctrls

,#subscriptions

  "calendar/day/select": (day) ->
    if $.isArray(day)
      CalendarMonthController.selected_days = day
    else
      CalendarMonthController.selected_days.push(day)
    CalendarMonthController.selected_days.sort (a,b) -> a.getTime() - b.getTime()
    @update_all()
