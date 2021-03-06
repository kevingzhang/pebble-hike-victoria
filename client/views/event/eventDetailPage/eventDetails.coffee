Template.eventDetails.events
	'click .rsvp_yes': ()->
		Meteor.call "rsvp", Session.get("selected"), "yes"
		return false

	'click .rsvp_maybe': ()->
		Meteor.call "rsvp", Session.get("selected"), "maybe"
		return false

	'click .rsvp_no': ()->
		Meteor.call "rsvp", Session.get("selected"), "no"
		return false

	'click #postCommentBtn':(e,t)->
		postEle = t.find '#postCommentInput'
		unless postEle?
			return
		comment = postEle.value
		if comment.length is 0
			return
		eventId = @_id
		timeNow = new Date()
		Events.update eventId, {$push:{comments:{posterId:Meteor.userId(), comment:comment, postTime:timeNow}}}
		return false

	'click .invite': ()->
		openInviteDialog()
		return false

	'click .remove': ()->
		Events.remove(this._id)
		return false


Template.eventDetails.helpers
	posterName: () ->
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
		moment(@postTime).format('MM/DD/YYYY H:mm')

# ///////////////////////////////////////////////////////////////////////////////
# // event details sidebar

Template.eventDetails.selectedEvent = () ->
	return Events.findOne(Session.get("selected"))


Template.eventDetails.anyEvents = () ->
	return Events.find().count() > 0


Template.eventDetails.creatorName = () ->
	owner = Meteor.users.findOne @owner

	unless owner?
		"-"
	if owner._id is Meteor.userId()
		"me"
	else
		displayName owner


Template.eventDetails.canRemove = () ->
  return this.owner == Meteor.userId() and attending(this) == 0


Template.eventDetails.maybeChosen = (what) ->
	myRsvp = _.find(this.rsvps, (r) ->
		return r.user == Meteor.userId()
	) or {}

	return if what == myRsvp.rsvp then "chosen btn-inverse" else ""

