			
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
			Router.go 'homeMobile'
		else
			Session.set "createError","It needs a title and a description, or why bother?"

	'click .cancel': ()->
		Router.go 'homeMobile'


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

Template.eventEditMobile.helpers
	ownerof:(hikeEvent)->
		hikeEvent.owner is Meteor.userId()

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
			Router.go 'home'
		else
			Session.set "createError","It needs a title and a description, or why bother?"

	'click .cancel': ()->
		Router.go 'homeMobile'

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

