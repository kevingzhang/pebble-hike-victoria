
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
    party = Parties.findOne(Session.get("selected"))
    if (not party)
        return [];  # // party hasn't loaded yet
    return Meteor.users.find({$nor: [{_id: {$in: party.invited}},
                                   {_id: party.owner}]})


Template.inviteDialog.displayName = () ->
    return displayName(this)


