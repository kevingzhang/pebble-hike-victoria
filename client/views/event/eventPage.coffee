
Template.eventPage.showCreateDialog = ()->
    Session.get "showCreateDialog"
    

Template.eventPage.showEventEditDialog = ()->
    console.log('checking showEventEditDialog:' + Session.get "showEventEditDialog")
    Session.get "showEventEditDialog"



Template.eventPage.selectedEvent = () ->
    Events.findOne(Session.get("editingEventId"))


Template.eventPage.showInviteDialog = () ->
    Session.get("showInviteDialog")


Template.eventPage.events
    "click #addEvent":(e,t)->
        e.preventDefault()

        Session.set("createError", null)
        Session.set("showCreateDialog", true)

    "click #eventEditButton":(e, t)->
        e.preventDefault()

        Session.set("eventEditError", null)
        Session.set("showEventEditDialog", true)
        
