
Template.header.events({
	'click .resize.button' : () ->
		# As long as the new Meteor UI isn't out the whole template will re-render
		$('.header-wrapper').toggleClass('active')
		$('.angle.icon').toggleClass('down').toggleClass('up')

	'click #homeButton' : () ->
		Router.go('home')
})

