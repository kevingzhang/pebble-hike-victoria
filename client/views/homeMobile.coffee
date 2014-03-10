Deps.autorun ()->
	loc = Session.get('mylocation')
	unless loc?
		return
	if loc.error?
		return
	else
		if gmaps?
			newLatlon = new google.maps.LatLng(loc.coords.latitude, loc.coords.longitude)
			if gmaps.curUserLocation?
				gmaps.updateMarker(gmaps.curUserLocation, newLatlon)
			else
				gMarker = new google.maps.Marker
					position: newLatlon
					map: gmaps.map
					title: "Myself"
					icon:'http://maps.google.com/mapfiles/arrow.png'
				infowindow = new google.maps.InfoWindow("Your current location")
				infowindow.open gmaps.map, gMarker
				gmaps.curUserLocation = gmaps.addMarker newLatlon, 'myself'

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



getLocation : ()->
		loc = Session.get 'location'
		if loc?
			if loc.error?
				return loc.error
			else
				return JSON.stringify loc
		else
			
	mapUrl:()->
		loc = Session.get 'location'
		unless loc?
			return
		

		locParm = loc.coords.latitude + "," + loc.coords.longitude
		return "http://maps.googleapis.com/maps/api/staticmap?center=#{loc.coords.latitude},#{loc.coords.longitude}&zoom=14&size=400x300&sensor=false"
