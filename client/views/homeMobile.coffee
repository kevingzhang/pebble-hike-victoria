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
	showLocationOnMapActive:(hikeEvent)->
		if Session.equals 'map', true
			if hikeEvent.location?
				active = if hikeEvent._id is Session.get 'curEventId' then true else false
				latLng = new google.maps.LatLng(hikeEvent.location.lat, hikeEvent.location.lng)
					
				if hikeEvent.gMarker?
					gmaps.updateMarker(hikeEvent.gMarker, latLng, hikeEvent.title, active)
				else
					newCreatedMarker = gmaps.addMarker latLng, hikeEvent.title, active
					hikeEvent.gMarker = newCreatedMarker
		return if active then 'active' else ''
	hikeTimeString: (hikeEvent) ->
		moment(hikeEvent.hikeTime).format('MM-DD h:mm a')

	activeEvent: (hikeEvent)->
		if hikeEvent._id is Session.get 'curEventId' then 'active' else ''
Template.homeMobile.events

	'click .testevent':(e,t)->
		e.preventDefault()
		curEventId = e.currentTarget.getAttribute 'data-eventId'
		if curEventId?
			Session.set 'curEventId', curEventId
	'click .openDetail':(e,t)->
		eventId = e.target.getAttribute 'data-eventId'
		Router.go "/meventedit/#{eventId}"