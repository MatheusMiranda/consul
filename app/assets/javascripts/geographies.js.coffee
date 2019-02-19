App.Geographies =

  doStuff: ->
    $.ajax location.protocol + "//" + location.host + '/preview_polygon',
      type: 'POST'
      dataType: 'json'
      data: { geojson: $("#geography_geojson").val() }
      success: (data) ->
        console.log("\n\nDEU BOMMMMMMM\n\n")

  redlightGeojsonField: ->
    $('#geography_geojson').on "mousedown", (event) ->

  initialize: ->
    $('.headings-selector option').on "mousedown", (event) ->
      event.preventDefault()
      clicked_option = event.target
      was_selected = $(clicked_option).prop('selected')

      if was_selected == true
        $(clicked_option).prop('selected', false)
      else if was_selected == false
        $(clicked_option).prop('selected', true)

    timer = null
    $('#geography_geojson').on "keydown", (event) ->
      clearTimeout(timer);
      timer = setTimeout(App.Geographies.doStuff, 1000)

