Events.allow
    insert: (userId, theEvent) ->
        return true
    
    update: (userId, theEvent, fields, modifier) ->
        console.log "update is called. fields is #{JSON.stringify fields}, userId is #{userId}, owner is #{theEvent.owner}"
        if userId isnt theEvent.owner

            console.log "not owner but fields is #{JSON.stringify fields}"
            allowed = ["comments","rsvps"]
            if _.difference(fields, allowed).length > 0
                console.log "oh?"
                return false# not the owner, not allowed fields
            else
                console.log 'oh2'
                return true #not owner, but allow field
        else
            console.log 'he is the owner'
            allowed = ["title", "rsvps", "description","comments", "location","hikeTime"]
            if _.difference(fields, allowed).length
                console.log "update denied because #{_.difference(fields, allowed).length}"
                return false#; // tried to write to forbidden field
                ###
                A good improvement would be to validate the type of the new
                value of the field (and if a string, the length.) In the
                future Meteor will have a schema system to makes that easier.
                ###
            else
                return true
    
    remove: (userId, theEvent)->
        # You can only remove events that you created and nobody is going to.
        return theEvent.owner is userId and attending(theEvent) is 0

