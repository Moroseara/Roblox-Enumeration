local Encode = require(script.Parent:WaitForChild("Base64"))

local HASH_CHARS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+/"
local ID_CHARS   = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

local id_registry   = {} 
local hash_registry = {}  


local function get_unique_id(length: number): string
	length = (typeof(length) == "number" and length > 0) and length or 8

	local function generate(): string
		local parts = {}
		for i = 1, length do
			parts[i] = string.sub(ID_CHARS, math.random(1, #ID_CHARS), 1)
		end
		return table.concat(parts)
	end

	local code = generate()
	while id_registry[code] do
		code = generate()
	end

	id_registry[code] = true
	return code
end

local function string_to_hash(input: string,unique_name: boolean?,level: number?): string
	if typeof(input) ~= "string" then input = tostring(input) end
	level = (typeof(level) == "number" and level >= 1) and level or 1

	local hash = 5381
	for i = 1, #input do
		hash = ((hash * 33) + string.byte(input, i)) % 2147483647
	end

	local result_chars = {}
	local h = hash
	while h > 0 do
		local index = (h % #HASH_CHARS) + 1
		table.insert(result_chars, HASH_CHARS:sub(index, index))
		h = math.floor(h / #HASH_CHARS)
	end

	local location, line = debug.info(level + 1, "sl")

	--local registry_key = unique_name and location or input
	--hash_registry[registry_key] = (hash_registry[registry_key] or 0) + 1
	--local count = hash_registry[registry_key]

	if script:GetAttribute("debug") == true then
		print(("[Hash] input=%s | location=%s | line=%d"):format(
			input, tostring(location), line or -1
			))
	end

	local raw = unique_name
		and (hash .. input .. tostring(line))
		or  (hash .. input)

	return Encode.encode(raw)
end

return {
	get_unique_id  = get_unique_id,
	string_to_hash = string_to_hash,
}