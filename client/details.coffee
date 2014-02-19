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
		partyId = t.data._id
		Parties.update partyId, {$push:{comments:{posterId:Meteor.userId(), comment:comment, postTime:new Date()}}}
		return false

	'click .invite': ()->
		openInviteDialog();
		return false;

	'click .remove': ()->
		Parties.remove(this._id);
		return false;

