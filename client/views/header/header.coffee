
Template.header.events({
	'click #headerResize' : () ->
		# As long as the new Meteor UI isn't out the whole template will re-render
		$('.header-wrapper').toggleClass('active')
		$('.glyphicon').toggleClass('glyphicon-chevron-down').toggleClass('glyphicon-chevron-up')

	'click #homeButton' : () ->
		Router.go('home')
	'click #addEvent':(e,t)->
		Session.set "createError", ''
})

