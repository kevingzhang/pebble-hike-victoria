
Router.configure({

	
	notFoundTemplate: 'notFound',
	

})


# This is the eventPage, the home page Route Controller.
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
    
    @route 'checkMap', 
        path:'/map/:_id'

    @route 'eventDetailPage',
        path : '/event/:_id'
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

