Deps.autorun ()->
	loc = Session.get('mylocation')
	unless loc?
		return
	if loc.error?
		return
	else
		u = Meteor.user()
		if u?
			if u.profile?
				if u.profile.name?
					userName = u.profile.name
				else
					userName = u.emails[0].address
			else
				userName = u.emails[0].address
		else
			userName = 'not log in'
	
		LocationLog.insert {
			location:loc
			userId:Meteor.userId()
			userName: userName
			}, (e,r)->
				if e?
					console.log e

		if gmaps? and google?
			newLatlon = new google.maps.LatLng(loc.coords.latitude, loc.coords.longitude)
			if gmaps.curUserLocation?
				gmaps.updateMarker(gmaps.curUserLocation, newLatlon)
			else
				gMarker = new google.maps.Marker
					position: newLatlon
					map: gmaps.map
					title: "Myself"
					icon:'http://maps.google.com/mapfiles/ms/icons/red-dot.png'
					animation: google.maps.Animation.BOUNCE 
				gmaps.curUserLocation = gMarker

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
					if active
						hikeEvent.infowindow.open gmaps.map, hikeEvent.gMarker
						gmaps.map.panTo hikeEvent.gMarker.getPosition()
					else
						hikeEvent.infowindow.close()
					
				else
					newCreatedMarker = gmaps.addMarker latLng, hikeEvent.title, active
					newCreatedMarker.hikeEventId = hikeEvent._id
					hikeEvent.gMarker = newCreatedMarker
					google.maps.event.addListener newCreatedMarker,'click',()->
						Session.set 'curEventId', @hikeEventId
						
					infoTitle = "<a href='/meventdetail/#{hikeEvent._id}'>#{hikeEvent.title}/#{moment(hikeEvent.hikeTime).format('MM-DD')}</a>"
					infowindow = new google.maps.InfoWindow content:infoTitle
					hikeEvent.infowindow = infowindow

		return if active then 'active' else ''
	hikeTimeString: (hikeEvent) ->
		moment(hikeEvent.hikeTime).format('MM-DD')

	activeEvent: (hikeEvent)->
		if hikeEvent._id is Session.get 'curEventId' then 'active' else ''

	ownerof:(hikeEvent)->
		hikeEvent.owner is Meteor.userId()

	joinedin:(hikeEvent)->
		_.contains hikeEvent.rsvps, Meteor.userId()


Template.homeMobile.events

	'click .testevent':(e,t)->
		e.preventDefault()
		curEventId = e.currentTarget.getAttribute 'data-eventId'
		if curEventId?
			Session.set 'curEventId', curEventId
	'click .updateevent':(e,t)->
		eventId = e.target.getAttribute 'data-eventId'
		Router.go "/meventedit/#{eventId}"
	'click .openDetail':(e,t)->
		eventId = e.target.getAttribute 'data-eventId'
		Router.go "/meventdetail/#{eventId}"
	'click .remove-event':(e,t)->
		eventId = e.target.getAttribute 'data-eventId'
		Events.remove eventId
	'click .join-in':(e,t)->
		unless Meteor.userId()?
			alert ("please login first")
			return Route.go 'homeMobile'
		eventId = e.target.getAttribute 'data-eventId'
		Events.update eventId, $push:{rsvps:Meteor.userId()}
		alert 'You have joined this hike'
	'click .join-out':(e,t)->
		unless Meteor.userId()?
			alert ("please login first")
			return Route.go 'homeMobile'
		unless confirm 'Are you sure you are not going?'
			return
		eventId = e.target.getAttribute 'data-eventId'
		Events.update eventId, $pull:{rsvps:Meteor.userId()}
	'click .add-event-btn':(e,t)->
		e.preventDefault()
		unless Meteor.userId()?
			alert ("please login first")
			return Route.go 'homeMobile'
		Router.go 'newevent'

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
