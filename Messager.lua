Messager = {}
Messager.__index = Messager

local channels = {
	default = {}
}

function Messager.send(title, body, channel)
	local currentChannel = channels['default']
	if channel ~= nil then
		currentChannel = channels[channel]
	end

	if currentChannel == nil or currentChannel[title] == nil then
		return
	end

	observers = currentChannel[title]
	for _,v in ipairs(observers) do
		v(body)
	end
end

function Messager.addListener(title, fn, channel)
	local currentChannel = channels['default']
	if channel ~= nil then
		if channels[channel] == nil then 
			channels[channel] = {}
		end
		currentChannel = channels[channel]
	end

	if currentChannel[title] == nil then
		currentChannel[title] = {}
	end
	observers = currentChannel[title]
	table.insert(observers, fn)
end

return Messager