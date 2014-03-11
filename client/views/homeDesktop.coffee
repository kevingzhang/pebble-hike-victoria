
Template.homeDesktop.selectedEvent = () ->
    Events.findOne(Session.get("editingEventId"))


Template.homeDesktop.events
    "click #eventEditButton":(e, t)->
        e.preventDefault()

        Session.set("eventEditError", null)
        Session.set("showEventEditDialog", true)
        
