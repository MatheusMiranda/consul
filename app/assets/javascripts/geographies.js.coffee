App.Geographies =

  sendGeojsonData: ->
    geojsonFieldValue = $("#geography_geojson").val()
    colorFieldValue = $("#geography_color").val()

    if geojsonFieldValue != ""
      $.ajax location.protocol + "//" + location.host + '/admin/geographies/preview_polygon',
        dataType: 'script'
        type: 'POST'
        data: { geojson: geojsonFieldValue, color: colorFieldValue }
    else if geojsonFieldValue == ""
      App.Geographies.hideGeoJsonErrorAlert()
      App.Geographies.hidePreviewMap()
;w;w
  showGeoJsonErrorAlert: ->
    $('#geojson-error-message').removeClass("hide-geojson-error-message")
    $('#geography_geojson').addClass("geography-geojson-field-red-border")
		$('#preview-polygon-map').removeClass("preview-map")
		App.Geographies.hidePreviewMap()

  hideGeoJsonErrorAlert: ->
    $('#geojson-error-message').addClass("hide-geojson-error-message")
    $("#geography_geojson").removeClass("geography-geojson-field-red-border")

  hidePreviewMap: ->
    $('#new_map_location').remove()

  initialize: ->
    timer = null
    $('#geography_geojson').on "keydown", (event) ->
      clearTimeout(timer);
      timer = setTimeout(App.Geographies.sendGeojsonData, 1000)

    $('#geography_color').on 'change', ->
       App.Geographies.sendGeojsonData()

    $('#geojson-error-message').addClass("hide-geojson-error-message")

    App.Geographies.sendGeojsonData()

  initializePreviewMap: ->
    $('#preview-polygon-map').addClass("preview-map")

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

    addPreviewPolygon previewPolygonData

