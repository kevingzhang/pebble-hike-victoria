
Template.eventItemRow.events({
    "click .row": (e, t) ->
        # t.isSelected = not t.isSelected
        e.preventDefault()
        clickedEventId = e.currentTarget.getAttribute 'data-eventId'
        currentSelectedEventId = Session.get('selected')
        if clickedEventId? and not currentSelectedEventId?
            Session.set 'selected', clickedEventId
        else if clickedEventId? and currentSelectedEventId? and currentSelectedEventId isnt clickedEventId
            Session.set 'selected', clickedEventId
        else
            Session.set 'selected', ''
        
        return true

    # processing the goto detail page. The .row has captured the click
    'click .detailBtn' : (e, t) ->
        e.preventDefault()

        clickedEventId = e.currentTarget.getAttribute 'data-eventId'
        if clickedEventId? 
            theEvent = Events.findOne(clickedEventId)
            Router.go 'eventDetailPage', theEvent

    # the edit button is clicked ---
    "click .editBtn" : (event, template) ->
        clickedEventId = event.currentTarget.getAttribute 'data-eventId'
        if clickedEventId?
            console.log("editing event id: #{clickedEventId}")
            Session.set 'editingEventId', clickedEventId
            Session.set 'showEventEditDialog', true
        
        return false
})


Template.eventItemRow.helpers({

    upcoming:()->
        moment().isBefore(moment(@hikeTime))

    initiator: ()->
        owner = Meteor.users.findOne @owner
		
        unless owner?
            return "-"
        if owner._id is Meteor.userId()
            "me"
        else
            displayName owner

    timeFormatted: ()->
        moment(@hikeTime).format("ddd, MMM DD, YYYY h:mm a")

    rsvpsCount: ()->
        @rsvps.length

    isEditable: () ->
        owner = Meteor.users.findOne @owner
        unless owner?
            return false
        if owner._id is Meteor.userId()
            return true
        else
            return false

})
