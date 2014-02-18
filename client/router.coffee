
Router.map ()->
	@route 'home',
		path:'/'
		template:'page'
		waitOn:()->
			[
				Meteor.subscribe("directory"),
				Meteor.subscribe("parties")
			]
		data:()->
			partyList:()->
				Parties.find()
	@route 'checkMap',
		path:'/map/:_id'
