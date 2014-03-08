Template.eventEditDialog.events
    'click .save': (event, template) ->
        editingEvent = template.data
        hikeTimeString = template.find(".dlgTime").value
        hikeTime = moment hikeTimeString, 'YYYY-MM-DD h:mm a'
        unless hikeTime.isValid()
            Session.set "eventEditError", "Hike time should be in format of MM-DD-YYYY"
            return

        title = template.find(".dlgTitle").value
        description = template.find(".description").value
        publicAccess = true  # not template.find(".private").checked
        maplink = template.find(".maplink").value

        if (title.length > 100)
            Session.set "createError","Title too long"

        if (description.length > 1000)
            Session.set "eventEditError","Description too long"

        unless Meteor.userId()
            Session.set "eventEditError", "You must be logged in"

        if (title.length and description.length)
            id = Events.update( editingEvent._id,
                { $set:
                    title: title
                    description: description
                    # public: publicAccess
                    maplink: maplink
                    hikeTime:hikeTime.toDate()
                }
            )

            Session.set "selected", id
            if (not publicAccess and Meteor.users.find().count() > 1)
                openInviteDialog()

            Session.set "showEventEditDialog", false
        else
            Session.set "eventEditError","It needs a title and a description, or why bother?"

    'click .cancel': ()->
        Session.set "showEventEditDialog", false


Template.eventEditDialog.rendered = () ->
    $('#datetimepicker').datetimepicker({
        language: 'pt-BR',
        format: 'yyyy-MM-dd hh:mm PP',
        pick12HourFormat: true
    })


Template.eventEditDialog.error = ()->
    Session.get "eventEditError"


Template.eventEditDialog.helpers({
    hikeTimeString: () ->
        editingEvent = this
        moment(editingEvent.hikeTime).format('YYYY-MM-DD h:mm a')

})


Template.eventEditDialog.hikeTimeString = () ->
        console.log('Template.eventEditDialog.helpers.hikeTimeString():'+this)
        moment().format('YYYY-MM-DD h:mm a')

