
# Nest
*An event emitter.*

**Importing with [Neon](https://github.com/Belkworks/NEON)**:
```lua
Nest = NEON:github('belkworks', 'nest')
```

## API

To create a **Nest** instance, call `Nest`.  
**Nest**: `Nest() -> Nest`  
```lua
nest = Nest()
```

### Emitting events

To emit an event, call `Nest:emit`  
**emit**: `Nest:emit(name, ...) -> Nest`
```lua
nest:emit('message', 'test', 123)
```

### Listening for events

To listen to a named event, call `Nest:on`  
**on**: `Nest:on(name, callback) -> nil`
```lua
nest:on('message', function(...)
	-- Do something 
end)
```

To listen to a named event only once, call `Nest:once`  
**once**: `Nest:once(name, callback) -> nil`
```lua
nest:once('message', function(...)
	-- Do something just once
end)
```

To listen to any event, call `Nest:onAny`  
**onAny**: `Nest:onAny(callback) -> Nest`  
The first parameter to the callback is the event name.
```lua
nest:onAny(function(name, ...)
	-- Do something for every event
end)
```

### Cleaning up

To destroy a **Nest**, call `Nest:Destroy`  
**Destroy**: `Nest:Destroy() -> nil`  
Further calls to `Nest:emit` will be ignored.
```lua
nest:Destroy()
```
This makes **Nest** compatible with [Broom](https://github.com/Belkworks/broom).
```lua
broom.nest = nest
-- or --
broom:give(nest)
```

### Callback information
- Callbacks can be functions or other **Nest** instances
- You can have multiple callbacks on the same event name
- Callbacks are executed synchronously in the order they are attached
- Errors are not handled, and will stop the `emit` call
- Callback return values are ignored
- Most methods return the nest, allowing chaining:
```lua
nest = Nest()
	:on('message', print)
	:on('error', error)
```
