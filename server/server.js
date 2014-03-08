// All Tomorrow's events -- server

Meteor.publish("directory", function () {
    return Meteor.users.find({}, {fields: {emails: 1,username:1, profile: 1}});
});

Meteor.publish("events", function () {
    return Events.find(
        {$or: [{"public": true}, {invited: this.userId}, {owner: this.userId}]},
        {sort:{hikeTime:-1}}
    );
});
