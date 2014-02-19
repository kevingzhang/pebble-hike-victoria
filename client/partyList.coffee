Template.partyList.helpers
	isSelected: ()->
		selectedPartyId = Session.get 'selected'
		if selectedPartyId is @._id
			"selectedParty"
		else
			""
	rsvpsCount: ()->
		@rsvps.length
	initiator:()->
		owner = Meteor.users.findOne @owner
		unless owner?
			return "-"
		if owner._id is Meteor.userId()
			"me"
		else
			displayName owner 

	timeFormatted: ()->
		moment(@hikeTime).format("MM/DD/YYYY")
	upcoming:()->
		moment().isBefore(moment(@hikeTime))

Template.partyList.events
	"click .partyItem":(e,t)->
		e.preventDefault()
		partyId = e.currentTarget.getAttribute 'data-partyId'
		if partyId?
			Session.set 'selected', partyId
	"click #addParty":(e,t)->
		e.preventDefault()

		Session.set("createError", null);
		Session.set("showCreateDialog", true);
		