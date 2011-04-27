-- WoWDings
-- Version 1.1
-- By Lenwë from EU-Sargeras

WoWDings_OldSendChatMessage = SendChatMessage


function WoWDings_SendChatMessage(msg, system, language, target)
	local range, codes, code, symbol, ranges

	if string.find(msg, "^RU") then
		msg = string.gsub(msg, "^RU%s*", '')
		if system ~= 'SAY' and system ~= 'YELL' then
			msg = WoWDings_Russianize(msg)
		end
	end

	msg = string.gsub(msg, "%(WD%)", WOWDINGS_AD)

	if system ~= 'SAY' then
		for _, ranges in pairs(WOWDINGS) do
			for _, range in pairs(ranges) do
				for symbol, codes in pairs(range) do
					for _, code in pairs(codes) do
						msg = string.gsub(msg, code, symbol)
					end
				end
			end
		end
	end

	WoWDings_OldSendChatMessage(msg, system, language, target)
end

SendChatMessage = WoWDings_SendChatMessage


function WoWDings_Russianize(msg)
	local find, replace, x

	for find, replace in pairs(WOWDINGS_RUSSIAN) do
		x = math.random(table.getn(replace))
		if (math.random(6) >= 2) then
			msg = string.gsub(msg, find, replace[x])
		end
	end

	return msg
end

SlashCmdList["WOWDINGS"] = function(s)
	local rangeName, range, ranges, codes, code, symbol, str, strCodes, i

	for rangeName, ranges in pairs(WOWDINGS) do
		rangeName = "|cFFFFFF00"..rangeName.."|r"
		DEFAULT_CHAT_FRAME:AddMessage("========== "..rangeName.." ==========")
		str = ""
		for i = 1, table.getn(ranges), 1 do
			range = ranges[i]
			for symbol, codes in pairs(range) do
				if (symbol == "|")  then symbol = "Unescaped ||" end
				if (symbol == "\r") then symbol = "End of line"    end
				symbol = "|cFFFFFF00"..symbol.."|r"
				str = str..symbol..":"
				for _, code in pairs(codes) do
					code = string.gsub(code, "%%", "")
					code = "|cFF00FF00"..code.."|r"
					str = str..code.." "
				end
				str = str.." "
			end
		end
		DEFAULT_CHAT_FRAME:AddMessage(str)
	end
end

SLASH_WOWDINGS1 = "/wowdings"
SLASH_WOWDINGS2 = "/wd"