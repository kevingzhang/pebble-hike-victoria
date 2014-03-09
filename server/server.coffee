
Meteor.publish "directory", ()->
	return Meteor.users.find({}, {fields: {emails: 1,username:1, profile: 1}})


Meteor.publish "events", (eid)->
	if eid?
		return Events.find _id:eid
	else
		return Events.find(
			{$or: [{"public": true}, {invited: this.userId}, {owner: this.userId}]},
			{sort:{hikeTime:-1}})
		

