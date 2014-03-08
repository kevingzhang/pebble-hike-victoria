Template.header.helpers({
})

Template.header.events({
    'click .resize.button' : () ->
        # As long as the new Meteor UI isn't out the whole template will re-render
        $('.header-wrapper').toggleClass('active')
        $('.angle.icon').toggleClass('down').toggleClass('up')

    # this is the post new event
    "click #addEvent": (e,t) ->
        e.preventDefault()

        Session.set("createError", null)
        Session.set("showCreateDialog", true)

})

