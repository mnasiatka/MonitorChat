local addon_name, addon_data = ...
local maxWidth = 150
local height = 150
local ChatMonitorFrame
local KEYWORDS = {}

function OnLoad()
    local frame, events = CreateFrame("Frame"), {};
    -- On addon loaded
    function events:ADDON_LOADED(name)
        if name == addon_name then
            ChatMonitorFrame = CreateFrame("Frame", "FiveSecondFrame")
            ChatMonitorFrame:SetToplevel(true)
            ChatMonitorFrame:EnableMouse(true)
            ChatMonitorFrame:SetMovable(true)
            ChatMonitorFrame:SetClampedToScreen(true)
            ChatMonitorFrame:SetWidth(maxWidth)
            ChatMonitorFrame:SetHeight(height)

            ChatMonitorFrame:RegisterForDrag('LeftButton')
        end
    end
    -- Guild message
    function events:CHAT_MSG_GUILD(...)
        local msg, author = ...
        messageHandler(msg, author)
    end
    -- Community channel message
    function events:CHAT_MSG_COMMUNITIES_CHANNEL(...)
        local msg, author = ...
        messageHandler(msg, author)
     end
    -- Channel message
    function events:CHAT_MSG_CHANNEL(...)
        local msg, author = ...
        messageHandler(msg, author)
    end
    frame:SetScript("OnEvent", function(self, event, ...)
        events[event](self, ...); -- call one of the functions above
    end);
    for k, v in pairs(events) do
        frame:RegisterEvent(k); -- Register all events for which handlers have been defined
    end
end

function messageHandler(msg, author)
    local shouldNotify = false
    for i, kword in ipairs(KEYWORDS) do
        if string.find(msg, kword) then
            shouldNotify = true
            break;
        end
    end

    if (shouldNotify) then
        notifyKeywordFound(msg, author)
    end
end

function notifyKeywordFound(msg, author)
    PlaySound("ReadyCheck", "master");
    message(author..": "..msg)
    
end

function _printList(list)
    for key, value in pairs(list) do
        print(key, value)
    end
end

SLASH_CHATMONITOR1 = "/cm";
SlashCmdList["CHATMONITOR"] = function(msg)
    -- stub
end