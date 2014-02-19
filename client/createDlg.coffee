Template.createDialog.events
	'click .save': (event, template) ->
		hikeTimeString = template.find(".dlgTime").value
		hikeTime = moment hikeTimeString, 'MM-DD-YYYY'
		unless hikeTime.isValid()
			Session.set "createError", "Hike time should be in format of MM-DD-YYYY"
			return


		title = template.find(".dlgTitle").value
		description = template.find(".description").value
		publicAccess = ! template.find(".private").checked
		maplink = template.find(".maplink").value

		if (title.length > 100)
			Session.set "createError","Title too long"
		if (description.length > 1000)
			Session.set "createError","Description too long"
		unless Meteor.userId()
			Session.set "createError", "You must be logged in"

		if (title.length && description.length) 
			id = Parties.insert
				owner: Meteor.userId()
				title: title
				description: description
				public: publicAccess
				maplink: maplink
				hikeTime:hikeTime.toDate()
				inviated:[]
				rsvps:[]
			

			Session.set "selected", id
			if (! publicAccess && Meteor.users.find().count() > 1)
				openInviteDialog()
			Session.set "showCreateDialog", false
		else
			Session.set "createError","It needs a title and a description, or why bother?"


	'click .cancel': ()->
		Session.set "showCreateDialog", false



Template.createDialog.error = ()->
	Session.get "createError"

