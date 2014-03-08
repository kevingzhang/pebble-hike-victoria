
Router.configure({
    layoutTemplate: 'basicLayout',
    notFoundTemplate: 'notFound',
    yieldTemplates: {
        'header': { to: 'header' },
        'footer': { to: 'footer' }
    }
})


HomeController = RouteController.extend({
    template: 'partyPage'
    waitOn: () ->
        [
            Meteor.subscribe("directory"),
            Meteor.subscribe("parties")
        ]
    data: () ->
        partyList: () ->
            Parties.find({}, {sort: {hikeTime: -1}})

})


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

        @route( 'checkMap', { path:'/map/:_id'} )

        # the partyDetailPage
        @route(
            'partyDetailPage',
            {
                path :  '/event/:_id',
                template : 'details',
                data: () ->
                    console.log("#{this.params._id}")  # ?????
                    pty = Parties.findOne({})
                    # pty = Parties.findOne(this.params._id)
                    console.log("found party id: #{pty?._id}")
                    return pty
            }
        )


)
