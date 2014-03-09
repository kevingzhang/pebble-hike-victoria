
Router.configure({
	
	notFoundTemplate: 'notFound',
	yieldTemplates: {
		'header': { to: 'header' },
		'footer': { to: 'footer' }
	}
})


HomeController = RouteController.extend({
	template: 'eventPage'
	layoutTemplate: 'basicLayout'
	waitOn: () ->
		[
			Meteor.subscribe("directory"),
			Meteor.subscribe("events")
		]
	data: () ->
		eventList: () ->
			Events.find({}, {sort: {hikeTime: -1}})

})


Router.map ()->
	@route 'home',
		path :  '/'
		controller: HomeController
	
	@route 'checkMap', 
		path:'/map/:_id'
		layoutTemplate: 'basicLayout'

	@route 'eventDetailPage',
		path : '/event/:_id'
		layoutTemplate: 'basicLayout'
		template : 'eventDetailPage'
		waitOn : () ->
			Meteor.subscribe 'events'
		data: () ->
			console.log "#{this.params._id}"  # ?????
			pty = Events.findOne(this.params._id)

			console.log "found event id: #{pty?._id}" 
			return pty
	@route 'newevent',
		path: '/newevent'
		template:'newEvent'
		layoutTemplate: 'mobileLayout'
