
Template.partyPage.showCreateDialog = ()->
	Session.get "showCreateDialog"

Template.partyPage.showInviteDialog = () ->
    Session.get("showInviteDialog")


Template.partyPage.events
	"click #addParty":(e,t)->
		e.preventDefault()

		Session.set("createError", null)
		Session.set("showCreateDialog", true)
		
