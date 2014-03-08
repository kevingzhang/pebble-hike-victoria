
Template.partyItem.events({
    "click .row": (e, t) ->
        # t.isSelected = not t.isSelected
        e.preventDefault()
        clickedPartyId = e.currentTarget.getAttribute 'data-partyId'
        currentSelectedPartyId = Session.get('selected')
        if clickedPartyId? and not currentSelectedPartyId?
            Session.set 'selected', clickedPartyId
        else if clickedPartyId? and currentSelectedPartyId? and currentSelectedPartyId isnt clickedPartyId
            Session.set 'selected', clickedPartyId
        else
            Session.set 'selected', ''
        
        return false

    "click .button" : (event, template) ->
        clickedPartyId = event.currentTarget.getAttribute 'data-partyId'
        if clickedPartyId?
            console.log("editing party id: #{clickedPartyId}")
            Session.set 'editingPartyId', clickedPartyId
            Session.set 'showPartyEditDialog', true
        
        return false
})


Template.partyItem.helpers({
    isSelected: () ->
        selectedPartyId = Session.get 'selected'
        if selectedPartyId is @._id
            return true  # "selectedParty"
        else
            return false  # ""

    upcoming:()->
        moment().isBefore(moment(@hikeTime))

    initiator:()->
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
