
# ///////////////////////////////////////////////////////////////////////////////
# // Invite dialog

@openInviteDialog = () ->
    Session.set("showInviteDialog", true)


Template.inviteDialog.events({
    'click .invite': (event, template) ->
        Meteor.call('invite', Session.get("selected"), this._id)

    'click .done': (event, template) ->
        Session.set("showInviteDialog", false)
        return false
})


Template.inviteDialog.uninvited = () ->
    event = Events.findOne(Session.get("selected"))
    if (not event)
        return [];  # // event hasn't loaded yet
    return Meteor.users.find({$nor: [{_id: {$in: event.invited}},
                                   {_id: event.owner}]})


Template.inviteDialog.displayName = () ->
    return displayName(this)


