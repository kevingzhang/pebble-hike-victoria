


  // Each event is represented by a document in the events collection:
  //   owner: user id
  //   x, y: Number (screen coordinates in the interval [0, 1])
  //   title, description: String
  //   public: Boolean
  //   invited: Array of user id's that are invited (only if !public)
  //   rsvps: Array of objects like {user: userId, rsvp: "yes"} (or "no"/"maybe")


this.Events = new Meteor.Collection("events");

this.LocationLog = new Meteor.Collection("locations");

attending = function (event) {
  return (_.groupBy(event.rsvps, 'rsvp').yes || []).length;
};

var NonEmptyString = Match.Where(function (x) {
  check(x, String);
  return x.length !== 0;
});

var Coordinate = Match.Where(function (x) {
  check(x, Number);
  return x >= 0 && x <= 1;
});

createEvent = function (options) {
  var id = Random.id();
  Meteor.call('createEvent', _.extend({ _id: id }, options));
  return id;
};

Meteor.methods({
  // options should include: title, description, x, y, public
  createEvent: function (options) {
    check(options, {
      title: NonEmptyString,
      description: NonEmptyString,
      x: Coordinate,
      y: Coordinate,
      public: Match.Optional(Boolean),
      _id: Match.Optional(NonEmptyString)
    });

    if (options.title.length > 100)
      throw new Meteor.Error(413, "Title too long");
    if (options.description.length > 1000)
      throw new Meteor.Error(413, "Description too long");
    if (! this.userId)
      throw new Meteor.Error(403, "You must be logged in");

    var id = options._id || Random.id();
    Events.insert({
      _id: id,
      owner: this.userId,
      x: options.x,
      y: options.y,
      title: options.title,
      description: options.description,
      public: !! options.public,
      invited: [],
      rsvps: []
    });
    return id;
  },

  invite: function (eventId, userId) {
    check(eventId, String);
    check(userId, String);
    var event = Events.findOne(eventId);
    if (! event || event.owner !== this.userId)
      throw new Meteor.Error(404, "No such event");
    if (event.public)
      throw new Meteor.Error(400,
                             "That event is public. No need to invite people.");
    if (userId !== event.owner && ! _.contains(event.invited, userId)) {
      Events.update(eventId, { $addToSet: { invited: userId } });

      var from = contactEmail(Meteor.users.findOne(this.userId));
      var to = contactEmail(Meteor.users.findOne(userId));
      if (Meteor.isServer && to) {
        // This code only runs on the server. If you didn't want clients
        // to be able to see it, you could move it to a separate file.
        Email.send({
          from: "noreply@example.com",
          to: to,
          replyTo: from || undefined,
          subject: "event: " + event.title,
          text:
"Hey, I just invited you to '" + event.title + "' on All Tomorrow's events." +
"\n\nCome check it out: " + Meteor.absoluteUrl() + "\n"
        });
      }
    }
  },

  rsvp: function (eventId, rsvp) {
    check(eventId, String);
    check(rsvp, String);
    if (! this.userId)
      throw new Meteor.Error(403, "You must be logged in to RSVP");
    if (! _.contains(['yes', 'no', 'maybe'], rsvp))
      throw new Meteor.Error(400, "Invalid RSVP");
    var event = Events.findOne(eventId);
    if (! event)
      throw new Meteor.Error(404, "No such event");
    if (! event.public && event.owner !== this.userId &&
        !_.contains(event.invited, this.userId))
      // private, but let's not tell this to the user
      throw new Meteor.Error(403, "No such event");

    var rsvpIndex = _.indexOf(_.pluck(event.rsvps, 'user'), this.userId);
    if (rsvpIndex !== -1) {
      // update existing rsvp entry

      if (Meteor.isServer) {
        // update the appropriate rsvp entry with $
        Events.update(
          {_id: eventId, "rsvps.user": this.userId},
          {$set: {"rsvps.$.rsvp": rsvp}});
      } else {
        // minimongo doesn't yet support $ in modifier. as a temporary
        // workaround, make a modifier that uses an index. this is
        // safe on the client since there's only one thread.
        var modifier = {$set: {}};
        modifier.$set["rsvps." + rsvpIndex + ".rsvp"] = rsvp;
        Events.update(eventId, modifier);
      }

      // Possible improvement: send email to the other people that are
      // coming to the event.
    } else {
      // add new rsvp entry
      Events.update(eventId,
                     {$push: {rsvps: {user: this.userId, rsvp: rsvp}}});
    }
  }
});

///////////////////////////////////////////////////////////////////////////////
// Users

displayName = function (user) {
  if user?
    if (user.profile && user.profile.name)
        return user.profile.name;
    else if (user.username)
        return user.username;
    else 
        return user.emails[0].address;
  else
    ""
};

var contactEmail = function (user) {
  if (user.emails && user.emails.length)
    return user.emails[0].address;
  if (user.services && user.services.facebook && user.services.facebook.email)
    return user.services.facebook.email;
  return null;
};
