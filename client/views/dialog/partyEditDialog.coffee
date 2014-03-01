Template.partyEditDialog.events
    'click .save': (event, template) ->
        editingParty = template.data
        hikeTimeString = template.find(".dlgTime").value
        hikeTime = moment hikeTimeString, 'YYYY-MM-DD h:mm a'
        unless hikeTime.isValid()
            Session.set "partyEditError", "Hike time should be in format of MM-DD-YYYY"
            return

        title = template.find(".dlgTitle").value
        description = template.find(".description").value
        publicAccess = true  # not template.find(".private").checked
        maplink = template.find(".maplink").value

        if (title.length > 100)
            Session.set "createError","Title too long"

        if (description.length > 1000)
            Session.set "partyEditError","Description too long"

        unless Meteor.userId()
            Session.set "partyEditError", "You must be logged in"

        if (title.length and description.length)
            id = Parties.update( editingParty._id,
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

            Session.set "showPartyEditDialog", false
        else
            Session.set "partyEditError","It needs a title and a description, or why bother?"

    'click .cancel': ()->
        Session.set "showPartyEditDialog", false


Template.partyEditDialog.rendered = () ->
    $('#datetimepicker').datetimepicker({
        language: 'pt-BR',
        format: 'yyyy-MM-dd hh:mm PP',
        pick12HourFormat: true
    })


Template.partyEditDialog.error = ()->
    Session.get "partyEditError"


Template.partyEditDialog.helpers({
    hikeTimeString: () ->
        editingParty = this
        moment(editingParty.hikeTime).format('YYYY-MM-DD h:mm a')

})


Template.partyEditDialog.hikeTimeString = () ->
        console.log('Template.partyEditDialog.helpers.hikeTimeString():'+this)
        moment().format('YYYY-MM-DD h:mm a')

