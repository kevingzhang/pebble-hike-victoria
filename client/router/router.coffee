
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
    ()->
        @route(
            'home',
            {
                path :  '/',
                controller: HomeController
            }
        )

        @route( 'checkMap', { path:'/map/:_id'} )
)
