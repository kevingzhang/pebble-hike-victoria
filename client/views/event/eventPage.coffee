
Template.eventPage.selectedEvent = () ->
    Events.findOne(Session.get("editingEventId"))


Template.eventPage.events
    "click #addEvent":(e,t)->
        e.preventDefault()

        Session.set("createError", null)
        Session.set("showCreateDialog", true)

    "click #eventEditButton":(e, t)->
        e.preventDefault()

        Session.set("eventEditError", null)
        Session.set("showEventEditDialog", true)
        
