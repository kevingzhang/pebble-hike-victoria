Template.homeMobile.rendered = ()->
	unless Session.get 'map'
		gmaps.initialize()
		# if @data? and @data.location?
		# 	latlng = new google.maps.LatLng(@data.location.lat, @data.location.lng)
		# 	gmaps.curMarker = new google.maps.Marker
		# 		position: latlng
		# 		map: gmaps.map
		# 		animation: google.maps.Animation.DROP

		
		#google.maps.event.addListener gmaps.map,'click', gmaps.clickAddMarkerWithInfo


Template.homeMobile.helpers
	showLocationOnMap:(hikeEvent)->
		if Session.equals 'map', true
			if hikeEvent.location?
				latLng = new google.maps.LatLng(hikeEvent.location.lat, hikeEvent.location.lng)
				newCreatedMarker = gmaps.addMarker latLng, hikeEvent.title