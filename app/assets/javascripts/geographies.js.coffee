App.Geographies =

  doStuff: ->
    geojsonFieldValue = $("#geography_geojson").val()

    if geojsonFieldValue != ""
      $.ajax location.protocol + "//" + location.host + '/admin/geographies/preview_polygon',
        dataType: 'script'
        type: 'POST'
        data: { geojson: $("#geography_geojson").val() }
    else if geojsonFieldValue == ""
      App.Geographies.hideGeoJsonErrorAlert()

  showGeoJsonErrorAlert: ->
    $('#geojson-error-message').removeClass("hide-geojson-error-message")
    $('#geojson-error-message').addClass("show-geojson-error-message")

    $('#geography_geojson').addClass("geography-geojson-field-red-border")

  hideGeoJsonErrorAlert: ->
    $('#geojson-error-message').removeClass("show-geojson-error-message")
    $('#geojson-error-message').addClass("hide-geojson-error-message")

    $("#geography_geojson").removeClass("geography-geojson-field-red-border")

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

    $('#geojson-error-message').addClass("hide-geojson-error-message")

  initializePreviewMap: ->
    maps = $('*[data-map]')

    if maps.length > 0
      $.each maps, (index, map) ->
        App.Geographies.createPreviewMap map

  createPreviewMap: (element) ->

    addPreviewPolygon = (polygon_data) ->

      polygon  = L.polygon(polygon_data.outline_points,
                           {color: polygon_data.color})
      polygon.options['fillOpacity'] = 0.3
      polygon.addTo(map)
      map.fitBounds(polygon.getBounds());

      return polygon

    mapCenterLatitude        = $(element).data('map-center-latitude')
    mapCenterLongitude       = $(element).data('map-center-longitude')
    mapTilesProvider         = $(element).data('map-tiles-provider')
    mapAttribution           = $(element).data('map-tiles-provider-attribution')
    previewPolygonData       = $(element).data('polygons-geographies-data')
    zoom                     = $(element).data('map-zoom')

    mapCenterLatLng  = new (L.LatLng)(mapCenterLatitude, mapCenterLongitude)
    map              = L.map(element.id).setView(mapCenterLatLng, zoom)
    L.tileLayer(mapTilesProvider, attribution: mapAttribution).addTo map

    addPreviewPolygon previewPolygonData[0]

