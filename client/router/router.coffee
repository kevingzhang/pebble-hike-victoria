
Router.configure({
	notFoundTemplate: 'notFound'
})


# This is the homeDesktop, the home page Route Controller.
HomeController = RouteController.extend({
	template: 'homeDesktop'
	layoutTemplate: 'basicLayout'
	waitOn: () ->
		[
			Meteor.subscribe("directory"),
			Meteor.subscribe("events")
		]
	data: () ->
		eventList: () ->
			Events.find({}, {sort: {hikeTime: -1}})

	yieldTemplates: {
			'header': { to: 'header' },
			'footer': { to: 'footer' }
		}
})





# The map for Router -----------------
Router.map ()->
	@route 'home',
		path :  '/'
		controller: HomeController
		waitOn:()->
			Meteor.subscribe 'users'
		before:()->
			if Meteor.Device.isTablet() or Meteor.Device.isPhone()
				Router.go 'homeMobile'
	
	@route 'checkMap',
		path:'/map/:_id'

	@route 'eventDetailPage',
		path : '/event/:_id'
		template : 'eventDetailPage'
		layoutTemplate: 'basicLayout'
		waitOn : () ->
			Meteor.subscribe 'events'
		data: () ->
			currentEvent = Events.findOne(@params._id)
			unless currentEvent?
				Router.go 'home'
			return currentEvent
		yieldTemplates: {
				'header': { to: 'header' },
				'footer': { to: 'footer' }
			}

	@route 'newevent',
		path: '/newevent'
		template:'newEvent'
		layoutTemplate: 'mobileLayout'
		before:()->
			Session.set 'map',false

	@route 'eventeditmobile',
		template:'eventEditMobile'
		path: '/meventedit/:_id'
		layoutTemplate: 'mobileLayout'
		before:()->
			Session.set 'map',false
		waitOn:()->
			Meteor.subscribe 'singleEvent', @params._id
		data:()->
			curEvent = Events.findOne @params._id
			
			if curEvent.owner isnt Meteor.userId()
				Router.go 'home'
			return curEvent

	@route 'eventdetailmobile',
		template:'eventDetailMobile'
		path: '/meventdetail/:_id'
		layoutTemplate: 'mobileLayout'
		before:()->
			Session.set 'map',false
			if navigator.geolocation
				Session.set 'mylocation', {error:'Locating... please wait'}
				navigator.geolocation.getCurrentPosition (position)->
					Session.set 'mylocation', position
					,
					(error)->
						switch error.code
							when error.PERMISSION_DENIED then Session.set 'location', {error:"User denied the request for Geolocation."}
							when error.POSITION_UNAVAILABLE then Session.set 'location', {error:"Location information is unavailable."}
							when error.TIMEOUT then Session.set 'location', {error:"The request to get user location timed out."}
							when error.UNKNOWN_ERROR then Session.set 'location', {error:"An unknown error occurred."}
							else Session.set 'mylocation', {error:"Out of range error"}

			else
				Session.set 'mylocation', {error: 'Not supported browser'}
		waitOn:()->
			Meteor.subscribe 'singleEvent', @params._id
		data:()->
			curEvent = Events.findOne @params._id
			return curEvent
	@route 'homeMobile',
		template:'homeMobile'
		path:'/m'
		layoutTemplate: 'mobileLayout'
		waitOn:()->
			console.log 'waiton'
			h1 = Meteor.subscribe 'users'
			h2 = Meteor.subscribe 'recentLocationLog'
			h3 = Meteor.subscribe 'events'
			return [h1,h2,h3]
		before:()->
			Session.set 'map', null
			loc = Session.get 'mylocation'
			unless loc?
				if navigator.geolocation
					Session.set 'mylocation', {error:'Locating... please wait'}
					navigator.geolocation.getCurrentPosition (position)->
						Session.set 'mylocation', position
						,
						(error)->
							switch error.code
								when error.PERMISSION_DENIED then Session.set 'location', {error:"User denied the request for Geolocation."}
								when error.POSITION_UNAVAILABLE then Session.set 'location', {error:"Location information is unavailable."}
								when error.TIMEOUT then Session.set 'location', {error:"The request to get user location timed out."}
								when error.UNKNOWN_ERROR then Session.set 'location', {error:"An unknown error occurred."}
								else Session.set 'mylocation', {error:"Out of range error"}

				else
					Session.set 'mylocation', {error: 'Not supported browser'}

		data:()->

			return{
				hikeEvents:Events.find(),
				AllLocationLog:LocationLog.find()}

