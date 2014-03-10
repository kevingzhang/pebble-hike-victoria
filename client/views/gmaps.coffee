
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

	addMarker: (gLatLng, title,active)->
		gMarker = new google.maps.Marker
			position: gLatLng
			map: this.map
			title: title
			animation: if active then google.maps.Animation.BOUNCE else null
			icon:'http://maps.google.com/mapfiles/ms/icons/blue-dot.png'
		@latLngs.push(gLatLng)
		@markers.push(gMarker)
		@markerData.push(gMarker)
		return gMarker
	updateMarker: (gMarker, gLatLng, title, active)->
		unless gMarker.getPosition().equals gLatLng
			gMarker.setPosition gLatLng 
		unless gMarker.getTitle() is title
			gMarker.setTitle title
		setToAnimation = if active then google.maps.Animation.BOUNCE else null
		unless gMarker.getAnimation() is setToAnimation
			gMarker.setAnimation setToAnimation

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
			# backgroundColor:'green'
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



