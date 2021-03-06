
# // If no event selected, or if the selected event was deleted, select one.
# // Meteor.startup(function () {
# //   Deps.autorun(function () {
# //     var selected = Session.get("selected");
# //     if (! selected || ! events.findOne(selected)) {
# //       var event = events.findOne();
# //       if (event)
# //         Session.set("selected", event._id);
# //       else
# //         Session.set("selected", null);
# //     }
# //   });
# // });


# ///////////////////////////////////////////////////////////////////////////////
# // event attendance widget

Template.attendance.rsvpName = () ->
    user = Meteor.users.findOne(this.user)
    displayName(user)


Template.attendance.outstandingInvitations = () ->
    event = Events.findOne(this._id)

    Meteor.users.find({
        $and: [
            {_id: {$in: event.invited}},  # // they're invited
            {_id: {$nin: _.pluck(event.rsvps, 'user')}}  # // but haven't RSVP'd
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


