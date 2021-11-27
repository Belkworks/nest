local insert, remove
do
  local _obj_0 = table
  insert, remove = _obj_0.insert, _obj_0.remove
end
local selfy
selfy = function(fn)
  return function(self, ...)
    return self, fn(self, ...)
  end
end
local transform
transform = function(callback)
  local _exp_0 = type(callback)
  if 'function' == _exp_0 then
    return callback
  elseif 'table' == _exp_0 then
    assert((type(callback.emit)) == 'function', 'callback table must have an \'emit\' method!')
    return function(...)
      return callback:emit(...)
    end
  else
    return error('invalid callback type: ' .. type(callback))
  end
end
local Nest
do
  local _class_0
  local _base_0 = {
    _insert = function(self, callback, t)
      if self.Destroyed then
        return 
      end
      t.fn = transform(callback)
      return insert(self.Events, t)
    end,
    on = selfy(function(self, name, callback)
      return self:_insert(callback, {
        name = name
      })
    end),
    once = selfy(function(self, name, callback)
      return self:_insert(callback, {
        name = name,
        drop = true
      })
    end),
    onAny = selfy(function(self, callback)
      return self:_insert(callback, { })
    end),
    emit = selfy(function(self, name, ...)
      local drop, events = { }, self.Events
      for i, event in pairs(events) do
        if event.drop then
          insert(drop, i)
        end
        if event.name then
          if event.name == name then
            event.fn(...)
          end
        else
          event.fn(name, ...)
        end
      end
      if #drop > 0 then
        for i, idx in pairs(drop) do
          remove(events, idx - (i - 1))
        end
      end
    end),
    Destroy = function(self)
      self.Events = { }
      self.Destroyed = true
      self.emit = function() end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.Events = { }
      self.Destroyed = false
    end,
    __base = _base_0,
    __name = "Nest"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Nest = _class_0
  return _class_0
end
