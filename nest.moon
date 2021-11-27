-- nest.moon
-- SFZILabs 2021

import insert, remove from table

selfy = (fn) -> (...) => @, fn @, ...

transform = (callback) ->
	switch type callback
		when 'function' then callback
		when 'table'
			assert (type callback.emit) == 'function',
				'callback table must have an \'emit\' method!'
			(...) -> callback\emit ...
		else error 'invalid callback type: ' .. type callback

class Nest
	new: =>
		@Events = {}
		@Destroyed = false

	_insert: (callback, t) =>
		return if @Destroyed
		t.fn = transform callback
		insert @Events, t

	on: selfy (name, callback) =>
		@_insert callback, :name

	once: selfy (name, callback) =>
		@_insert callback, :name, drop: true

	onAny: selfy (callback) =>
		@_insert callback, {}

	emit: selfy (name, ...) =>
		drop, events = {}, @Events
		for i, event in pairs events
			insert drop, i if event.drop
			if event.name
				event.fn ... if event.name == name
			else event.fn name, ...

		if #drop > 0
			for i, idx in pairs drop
				remove events, idx - (i - 1)

	-- Broom support
	Destroy: =>
		@Events = {}
		@Destroyed = true
		@emit = ->
