$.Controller "CalendarMonthController",

  selected_days: []
  max_date: false
  min_date: false
  prev: ''
  type: 'avia'
  
  init: ->
    today = new Date
    @month = @options.month || today.getMonth()
    @year = @options.yeay || today.getFullYear()
    @render()

  to_normal: (day) ->
    if day - 1 >= 0 then day - 1 else 6

  render: (year, month) ->
    @year = year if year?
    @month = month if month?

    cur_day = first_day = new Date(@year, @month)
    last_day = new Date(@year, @month + 1, 0)

    weeks = []
    days = [0,0,0,0,0,0,0]
    while cur_day <= last_day
      days[@to_normal(cur_day.getDay())] = {date: cur_day}

      cur_day = new Date(new Date(cur_day.getTime()).setDate(cur_day.getDate() + 1)) # next day
      
      if @to_normal(cur_day.getDay()) == 0 or cur_day > last_day
        weeks.push { days: days }
        days = [0,0,0,0,0,0,0]

    @weeks_count = weeks.length

    max_date = @parent.max_date
    min_date = @parent.min_date
    @element.empty().append ich.calendar_month
      month: $.datepicker.formatDate('MM', new Date(@year, @month))
      year: @year
      day_names: I18n.days_min
      weeks: weeks
      day: -> this.getDate()
      href: -> sprintf("%02s_%02s_%4s", this.getDate(), this.getMonth()+1, this.getFullYear())
      css_class: ->
        if this < (new Date).setHours(0,0,0,0) or (min_date and this < min_date) or (max_date and this > max_date)
          "disabled"
        else ""

    @update_selection()
        
  update_selection: ->
    @element.find('td').removeClass()
    @parent.selected_days.sort (a,b) -> a.getTime() - b.getTime()
    if @parent.type == 'hotels' || @parent.type == 'apartments'
      @parent.selected_days = [@parent.selected_days[0],_(@parent.selected_days).last()]
    for day in @parent.selected_days
      
      @element
        .find('a[href=#'+$.datepicker.formatDate('dd_mm_yy', day)+']')
        .parent().addClass('active').addClass('selected')

    if @parent.selected_days.length > 1
      for lnk in @element.find('td a')
        day = $.datepicker.parseDate('dd_mm_yy', $(lnk).attr('href').slice(1))
        if @parent.selected_days[0] < day < _(@parent.selected_days).last()
          $(lnk).parent().removeClass().addClass('in_range')

    @element.find('.active:eq(1)').addClass('back') if @options.calendar.secod_is_back

  "td a -> click": (ev) ->
    ev.preventDefault()
    return if @parent.type is 'cars'
    td = $(ev.target).parent()
    @parent.prev = $('.t_month .active')
    return if $(ev.target).hasClass('disabled')
    
    return if td.hasClass('active')
    @options.calendar.update_all()
    td.addClass('active')
    if @element.find('.active').length == 2 and @options.calendar.secod_is_back
      td.addClass('back')
    $.publish("calendar/day/checked", [td, this])

  "td a -> mouseup": (ev) ->
    @parent.drag_element = false

  "td a -> draginit": (ev) ->
    el = $(ev.target)
    return false unless el.parent().hasClass('selected')
    @parent.drag_element = el

  "td a -> dragend": (ev) ->
    @parent.drag_element = false

  "td a -> mouseenter": (ev) ->
    return if @parent.type is 'cars'
    if @parent.drag_element
      return false if $(ev.target).hasClass('disabled')
      day = $.datepicker.parseDate('dd_mm_yy', @parent.drag_element.attr('href').slice(1))
      new_day = $.datepicker.parseDate('dd_mm_yy', $(ev.target).attr('href').slice(1))
      orig_d = _(@parent.selected_days).find (d) -> d.getTime() == day.getTime()
      
      return false unless orig_d
      orig_idx = _(@parent.selected_days).indexOf(orig_d)
      if prev = @parent.selected_days[orig_idx - 1]
        return false if new_day <= prev
      if next = @parent.selected_days[orig_idx + 1]
        return false if new_day >= next
      @parent.selected_days[orig_idx] = new_day
      @parent.drag_element = $(ev.target)
      @options.calendar.update_all()
      $.publish("calendar/day/changed", [orig_idx])
