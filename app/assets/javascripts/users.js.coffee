# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  url = $('.stats').data 'url'
  if url
    window.skillgraph = $('.skillgraph')
    window.winloss_chart = $('.winloss')
    window.positions_chart = $('.positions')

    $.get url, (data) ->
      render_trueskill data if window.skillgraph.length
      render_winloss data if window.winloss_chart.length
      render_positions data if window.positions_chart.length

render_positions = (data) ->
  window.positions_chart.highcharts
    title:
      text: "Position Breakdown"
    series: [
      type: 'pie',
      data: [{
        name: 'Offense',
        sliced: true
        y: data.players.filter((p) -> p.position == "offense").length
      }, {
        name: 'Defense'
        y: data.players.filter((p) -> p.position == "defense").length
      }]
    ]

render_winloss = (data) ->
  window.winloss_chart.highcharts
    title:
      text: "Win Loss Chart"
    series: [
      type: 'pie',
      data: [{
        name: 'Wins',
        y: data.win_count
        sliced: true
        selected: true
      }, {
        name: 'Losses',
        y: data.loss_count
      }]
    ]

render_trueskill = (data) ->
  data = [data] unless $.isArray data
  window.skillgraph.highcharts "StockChart",
    navigator:
      enabled: false
    rangeSelector:
      enabled: false
    scrollbar:
      enabled: false
    legend:
      enabled: true
    chart:
      type: 'line'
      pinchType: null
    title:
      text: 'Ratings Over Time'
    xAxis:
      type: 'datetime'
      title:
        text: 'Date'
    yAxis:
      title:
        text: 'TrueSkill'
    series: (user_data user for user in data)

user_data = (user) ->
  name: user.name
  data: for player in user.players
    [Date.parse(player.created_at), player.rank]
