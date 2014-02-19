Template.details.events
	'click .rsvp_yes': ()->
		Meteor.call "rsvp", Session.get("selected"), "yes"
		return false;

	'click .rsvp_maybe': ()->
		Meteor.call "rsvp", Session.get("selected"), "maybe"
		return false;

	'click .rsvp_no': ()->
		Meteor.call "rsvp", Session.get("selected"), "no"
		return false;
	'click #postCommentBtn':(e,t)->
		postEle = t.find '#postCommentInput'
		unless postEle?
			return
		comment = postEle.value
		if comment.length is 0
			return
		partyId = @_id
		timeNow = new Date()
		Parties.update partyId, {$push:{comments:{posterId:Meteor.userId(), comment:comment, postTime:timeNow}}}
		return false

	'click .invite': ()->
		openInviteDialog();
		return false;

	'click .remove': ()->
		Parties.remove(this._id);
		return false;


Template.details.helpers
	posterName: ()->
		poster = Meteor.users.findOne @posterId
		unless poster?
			return "-"
		if poster._id is Meteor.userId()
			"me"
		else
			displayName poster
	posterContent:()->
		@comment
	postTimeFormatted:()->
		moment(@postTime).format('MM/DD/YYYY H:m')


