Template.createDialog.events
	'click #XXXsaveButton': (e, t) ->
		e.preventDefault()
		# clean up the error message
		Session.set "createError", null

		hikeTimeString = t.find(".dlgTime").value
		hikeTime = moment hikeTimeString, 'YYYY-MM-DD h:mm a'
		unless hikeTime.isValid()
			Session.set "createError", "Hike time should be in format of MM-DD-YYYY"
			e.stopPropagation()
			return

		title = t.find(".dlgTitle").value
		description = t.find(".description").value
		publicAccess = true  # not template.find(".private").checked
		maplink = t.find(".maplink").value

		if (title.length > 100)
			Session.set "createError","Title too long"

		if (description.length > 1000)
			Session.set "createError","Description too long"

		unless Meteor.userId()
			Session.set "createError", "You must be logged in"

		if (not Session.get('createError')) and (title.length and description.length)
			id = Events.insert
				owner: Meteor.userId()
				title: title
				description: description
				public: publicAccess
				maplink: maplink
				hikeTime:hikeTime.toDate()
				inviated:[]
				rsvps:[]

			Session.set "selected", id
			if (not publicAccess and Meteor.users.find().count() > 1)
				openInviteDialog()
		else
			Session.set "createError","It needs a title and a description, or why bother?"
		if Session.get('createError')
			$("#createDialog").modal()
		else
			$("#createDialog").modal('hide')


	'click .cancel': ()->
		Session.set "showCreateDialog", false


Template.createDialog.rendered = () ->
	$('#datetimepicker').datetimepicker({
		language: 'pt-BR',
		format: 'yyyy-MM-dd hh:mm PP',
		pick12HourFormat: true
	})


Template.createDialog.error = ()->
	Session.get "createError"

