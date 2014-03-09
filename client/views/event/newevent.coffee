			
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
		maplink = template.find(".maplink").value

		if (title.length > 100)
			Session.set "createError","Title too long"

		if (description.length > 1000)
			Session.set "createError","Description too long"

		unless Meteor.userId()
			Session.set "createError", "You must be logged in"

		if (title.length and description.length)
			id = Events.insert
				owner: Meteor.userId()
				title: title
				description: description
				public: publicAccess
				maplink: maplink
				hikeTime:hikeTime.toDate()
				inviated:[]
				rsvps:[]

			Session.set "selected", id
			if (not publicAccess and Meteor.users.find().count() > 1)
				openInviteDialog()
			Session.set "showCreateDialog", false
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

Template.map.rendered = ()->
	unless Session.get 'map'
		gmaps.initialize()

Template.data.helpers
	markers:()->
		markers = Session.get 'markers'
		unless markers?
			return
		console.log 'reload markers'
		for marker in markers
			unless gmaps.markerExists 'id', marker.id
				console.log "addMarker #{JSON.stringify marker}"
				gmaps.addMarker marker

Template.map.destroyed = ()->
	Session.set 'map',false

Template.map.events
	'click #test':()->
		markers = [
			{id:1
			lat: 48.46
			lng:-123.49
			title:'people1'},
			{id:2
			lat:48.50
			lng:-123.50
			title:'people2'}
		]
		Session.set 'markers', markers


gmaps = 
	    # map object
	map: null
	 
	    #// google markers objects
	markers: []
	 
	    #// google lat lng objects
	latLngs: []
	 
	    #// our formatted marker data objects
	markerData: []
	 
	#// add a marker given our formatted marker data object
	addMarker: (marker)->
		console.log "inside addMarker #{JSON.stringify marker}"
		gLatLng = new google.maps.LatLng(marker.lat, marker.lng)
		gMarker = new google.maps.Marker
			position: gLatLng
			map: this.map
			title: marker.title
			#// animation: google.maps.Animation.DROP,
			icon:'http://maps.google.com/mapfiles/ms/icons/blue-dot.png'
        
		@latLngs.push(gLatLng)
		@markers.push(gMarker)
		@markerData.push(marker)
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
			zoom: 12
			center: new google.maps.LatLng(48.46, -123.49)
			mapTypeId: google.maps.MapTypeId.HYBRID
        
 
		this.map = new google.maps.Map document.getElementById('map-canvas'),mapOptions
        
 
        #// global flag saying we intialized already
		Session.set('map', true);
    



