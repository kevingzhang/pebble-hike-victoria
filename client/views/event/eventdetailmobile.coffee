
Template.eventDetailMobile.helpers
	ownerof:(hikeEvent)->
		hikeEvent.owner is Meteor.userId()
	joinedin:(hikeEvent)->
		_.contains hikeEvent.rsvps, Meteor.userId()
	hikeTimeString: (hikeEvent) ->
		moment(hikeEvent.hikeTime).format('MM-DD hh-mm')

Template.eventDetailMobile.events
	

	'click .cancel': ()->
		Router.go 'homeMobile'
	'click .join-in':(e,t)->
		eventId = e.target.getAttribute 'data-eventId'
		Events.update eventId, $push:{rsvp:Meteor.userId()}
		alert 'You have joined this hike'
	'click .join-out':(e,t)->
		unless confirm 'Are you sure you are not going?'
			return
		eventId = e.target.getAttribute 'data-eventId'
		Events.update eventId, $pull:{rsvp:Meteor.userId()}

Template.eventDetailMobile.rendered = ()->
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

Template.eventDetailMobile.error = ()->
	Session.get "createError"
