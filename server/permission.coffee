Parties.allow
	insert: (userId, party) ->
		return true
	
	update: (userId, party, fields, modifier) ->
		console.log "update is called. fields is #{JSON.stringify fields}, userId is #{userId}, owner is #{party.owner}"
		if userId isnt party.owner
			console.log "fields is #{JSON.stringify fields}"
			allowed = ["comments"]
			if _.difference(fields, allowed).length
				return false# not the owner, not allowed fields
			else
				return true #not owner, but allow field
		else
			allowed = ["title", "description","comments"]
			if _.difference(fields, allowed).length
				return false#; // tried to write to forbidden field
				###
				A good improvement would be to validate the type of the new
				value of the field (and if a string, the length.) In the
				future Meteor will have a schema system to makes that easier.
				###
			else
				return true;
	
	remove: (userId, party)->
		# You can only remove parties that you created and nobody is going to.
		return party.owner is userId and attending(party) is 0

