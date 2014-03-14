
Template.eventDetailMobile.helpers
	ownerof:(hikeEvent)->
		hikeEvent.owner is Meteor.userId()
	joinedin:(hikeEvent)->
		_.contains hikeEvent.rsvps, Meteor.userId()
	hikeTimeString: (hikeEvent) ->
		moment(hikeEvent.hikeTime).format('MM-DD hh-mm')
	getDisplayName: (userId)->
		u  = Meteor.users.findOne (userId)
		if u?
			if u.profile?
				if u.profile.name?
					return u.profile.name
			return u.emails[0].address
		else
			return 'noname'

Template.eventDetailMobile.events
	

	'click .cancel': ()->
		Router.go 'homeMobile'
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


Template.eventDetailMobile.error = ()->
	Session.get "createError"
