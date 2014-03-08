
Template.partyPage.showCreateDialog = ()->
    Session.get "showCreateDialog"
    

Template.partyPage.showPartyEditDialog = ()->
    console.log('checking showPartyEditDialog:' + Session.get "showPartyEditDialog")
    Session.get "showPartyEditDialog"



Template.partyPage.selectedParty = () ->
    Parties.findOne(Session.get("editingPartyId"))


Template.partyPage.showInviteDialog = () ->
    Session.get("showInviteDialog")


Template.partyPage.events
    "click #addParty":(e,t)->
        e.preventDefault()

        Session.set("createError", null)
        Session.set("showCreateDialog", true)
		
    "click #partyEditButton":(event,template)->
        event.preventDefault()

        Session.set("partyEditError", null)
        Session.set("showPartyEditDialog", true)
		
