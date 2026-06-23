local UniqueID = require("./UniqueID")
function CreateEnum <T> (data: T) : T
	local next = {}
	for name, _ in pairs(data) do
		if typeof(name) ~= "string" then
			error("Enum name must be a string")
		end
		
		next[name] = UniqueID.string_to_hash(name, false, 2)
		
		
	end
	
	return setmetatable({}, {
		__index = next,
		__newindex = function(_, key)
			error(`Unable to assign property {key}. Property is read only`, 2)
		end,
		__tostring = function()
			return "Enum"
		end,
		__metatable = "This metatable is locked"
	})
end


return CreateEnum