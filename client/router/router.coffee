
Router.configure({
    layoutTemplate: 'basicLayout',
    notFoundTemplate: 'notFound',
    yieldTemplates: {
        'header': { to: 'header' },
        'footer': { to: 'footer' }
    }
})


# This is the eventPage, the home page Route Controller.
HomeController = RouteController.extend({
    template: 'eventPage'
    waitOn: () ->
        [
            Meteor.subscribe("directory"),
            Meteor.subscribe("events")
        ]
    data: () ->
        eventList: () ->
            Events.find({}, {sort: {hikeTime: -1}})

})

# The map for Router -----------------
Router.map(
    () ->
        # the home page, default landing page
        @route(
            'home',
            {
                path :  '/',
                controller: HomeController
            }
        )

        # the eventDetailPage
        @route(
            'eventDetailPage',
            {
                path :  '/event/:_id',
                template : 'eventDetailPage',
                waitOn : () ->
                    [ Meteor.subscribe('events') ]
                data: () ->
                    console.log("#{this.params._id}")  # ?????
                    pty = Events.findOne(this.params._id)

                    # pty = Events.findOne(this.params._id)
                    console.log("found event id: #{pty?._id}")
                    return pty
            }
        )


)
