			
Template.newEvent.events
	'click .save': (event, template) ->
		hikeTimeString = template.find(".dlgTime").value
		hikeTime = moment hikeTimeString, 'YYYY-MM-DD h:mm a'
		unless hikeTime.isValid()
			Session.set "createError", "Hike time should be in format of MM-DD-YYYY"
			return

		title = template.find(".dlgTitle").value
		description = template.find(".description-mobile").value
		publicAccess = true  # not template.find(".private").checked

		if (title.length > 100)
			Session.set "createError","Title too long"
			return
		if (description.length > 1000)
			Session.set "createError","Description too long"
			return
		unless Meteor.userId()
			Session.set "createError", "You must be logged in"
			return
		unless gmaps.curMarker?
			unless confirm "You have not set the meetup location. Confirm to continue without the map location"
				return
		if (title.length and description.length)
			id = Events.insert
				owner: Meteor.userId()
				title: title
				description: description
				public: publicAccess
				
				hikeTime:hikeTime.toDate()
				inviated:[]
				rsvps:[]
				location: {lat:gmaps.curMarker.getPosition().lat(), lng:gmaps.curMarker.getPosition().lng()}
		else
			Session.set "createError","It needs a title and a description, or why bother?"

	'click .cancel': ()->
		Session.set "showCreateDialog", false


Template.newEvent.rendered = ()->
	$('#datetimepicker').datetimepicker 
		language: 'pt-BR'
		format: 'yyyy-MM-dd hh:mm PP'
		pick12HourFormat: true
	# unless Session.equals 'mapInited',true
	# 	if google?
	# 		mapProp = 
	# 			center:new google.maps.LatLng(51.508742,-0.120850)
	# 			zoom:5
	# 			mapTypeId:google.maps.MapTypeId.ROADMAP

	# 		map = new google.maps.Map document.getElementById("googleMap") , mapProp
	# 		Session.set 'mapInited', true


	# 		google.maps.event.addDomListener(window, 'load', initialize);

Template.newEvent.error = ()->
	Session.get "createError"

Template.eventEditMobile.events
	'click .update': (event, template) ->
		hikeTimeString = template.find(".dlgTime").value
		hikeTime = moment hikeTimeString, 'YYYY-MM-DD h:mm a'
		
		title = template.find(".dlgTitle").value
		description = template.find(".description-mobile").value
		publicAccess = true  # not template.find(".private").checked

		if (title.length > 100)
			Session.set "createError","Title too long"
			return
		if (description.length > 1000)
			Session.set "createError","Description too long"
			return
		unless Meteor.userId()
			Session.set "createError", "You must be logged in"
			return
		unless gmaps.curMarker?
			unless confirm "You have not set the meetup location. Confirm to continue without the map location"
				return
		if (title.length and description.length)
			modifier = {
				$set:{
					title: title
					description: description
					hikeTime:hikeTime.toDate()
					location: {lat:gmaps.curMarker.getPosition().lat(), lng:gmaps.curMarker.getPosition().lng()}
				}
			}
			console.log "#{JSON.stringify modifier}"
			Events.update template.data._id, modifier
				
		else
			Session.set "createError","It needs a title and a description, or why bother?"

	'click .cancel': ()->
		

Template.eventEditMobile.rendered = ()->
	$('#datetimepicker').datetimepicker 
		language: 'pt-BR'
		format: 'yyyy-MM-dd hh:mm PP'
		pick12HourFormat: true
	# unless Session.equals 'mapInited',true
	# 	if google?
	# 		mapProp = 
	# 			center:new google.maps.LatLng(51.508742,-0.120850)
	# 			zoom:5
	# 			mapTypeId:google.maps.MapTypeId.ROADMAP

	# 		map = new google.maps.Map document.getElementById("googleMap") , mapProp
	# 		Session.set 'mapInited', true


	# 		google.maps.event.addDomListener(window, 'load', initialize);

Template.eventEditMobile.error = ()->
	Session.get "createError"



Template.map.rendered = ()->
	unless Session.get 'map'
		gmaps.initialize()
		if @data? and @data.location?
			latlng = new google.maps.LatLng(@data.location.lat, @data.location.lng)
			gmaps.curMarker = new google.maps.Marker
				position: latlng
				map: gmaps.map
				animation: google.maps.Animation.DROP


		google.maps.event.addListener gmaps.map,'click', gmaps.clickAddMarkerWithInfo

Template.map.destroyed = ()->
	Session.set 'map',false
Template.map.events

@gmaps = 
	# map object
	map: null
	#// google markers objects
	markers: []
	#// google lat lng objects
	latLngs: []
	#// our formatted marker data objects
	markerData: []
	#// add a marker given our formatted marker data object
	curMarker: null

	addMarker: (gLatLng, title)->
		gMarker = new google.maps.Marker
			position: gLatLng
			map: this.map
			title: title
			#// animation: google.maps.Animation.DROP,
			icon:'http://maps.google.com/mapfiles/ms/icons/blue-dot.png'
		@latLngs.push(gLatLng)
		@markers.push(gMarker)
		@markerData.push(gMarker)
		return gMarker
	#// calculate and move the bound box based on our marker
	calcBounds: ()->
		bounds = new google.maps.LatLngBounds()
		bounds.extend latLng for latLng in @latLngs
		this.map.fitBounds(bounds)
	#// check if a marker already exists
	markerExists: (key, val)->
		_.each this.markers, (storedMarker)->
			if (storedMarker[key] is val)
				return true
		return false;
	#// intialize the map
	initialize: () ->
		console.log("[+] Intializing Google Maps...");
		mapOptions = 
			backgroundColor:'green'
			zoom: 12
			center: new google.maps.LatLng(48.46, -123.49)
			mapTypeId: google.maps.MapTypeId.ROADMAP
			scrollwheel:false
			panControl:false,
			zoomControl:true,
			mapTypeControl:true,
			scaleControl:true,
			streetViewControl:true,
			overviewMapControl:true,
			rotateControl:true
		@map = new google.maps.Map document.getElementById('map-canvas'),mapOptions
			# (e)->
			# 	@map.clickAddMarkerWithInfo e
		#// global flag saying we intialized already
		Session.set('map', true);


	clickAddMarkerWithInfo:(event)->
		
		if gmaps.curMarker?
			gmaps.curMarker.setPosition event.latLng
			
		else
			
			marker = new google.maps.Marker
				position: event.latLng
				map: this
				animation: google.maps.Animation.DROP
				
			# infowindow = new google.maps.InfoWindow 
			# 	content:"{#{event.latLng.lat()} - #{event.latLng.lng()}"
			# infowindow.open this, marker
			gmaps.curMarker = marker




