
# // If no party selected, or if the selected party was deleted, select one.
# // Meteor.startup(function () {
# //   Deps.autorun(function () {
# //     var selected = Session.get("selected");
# //     if (! selected || ! Parties.findOne(selected)) {
# //       var party = Parties.findOne();
# //       if (party)
# //         Session.set("selected", party._id);
# //       else
# //         Session.set("selected", null);
# //     }
# //   });
# // });


# ///////////////////////////////////////////////////////////////////////////////
# // Party attendance widget

Template.attendance.rsvpName = () ->
    user = Meteor.users.findOne(this.user)
    displayName(user)


Template.attendance.outstandingInvitations = () ->
    party = Parties.findOne(this._id)

    Meteor.users.find({
        $and: [
            {_id: {$in: party.invited}},  # // they're invited
            {_id: {$nin: _.pluck(party.rsvps, 'user')}}  # // but haven't RSVP'd
        ]
    })
    

Template.attendance.invitationName = () ->
    displayName(this)


Template.attendance.rsvpIs = (what) ->
    this.rsvp == what


Template.attendance.nobody = () ->
    not this.public and (this.rsvps.length + this.invited.length == 0)


Template.attendance.canInvite = () ->
    not this.public and this.owner == Meteor.userId()


# ///////////////////////////////////////////////////////////////////////////////
# // Map display

# // Use jquery to get the position clicked relative to the map element.
coordsRelativeToElement = (element, event) ->
    offset = $(element).offset()
    x = event.pageX - offset.left
    y = event.pageY - offset.top
    return { x: x, y: y }



