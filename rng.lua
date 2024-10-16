local start = tick()
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

_G.EnableFriendRequest = true;
_G.WaitToSendFriend = 300;

_G.Enable = true;

--_G.Objects_Target = {Pet = {"Shadow Griffin"}, Misc = {}};
_G.Value = 4000000;
_G.Username = "khoimi113";
_G.Message = "khoi";
_G.WaitToSendIfEnough = 300;
_G.WaitToSend = 0.5;

_G.ClaimMail = false;

_G.max = nil;

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game.ReplicatedStorage
local Players = game:GetService('Players')
local Client = Players.LocalPlayer
local Network_Repli = ReplicatedStorage:WaitForChild("Network")

local v5 = require(ReplicatedStorage.Library.Items.Types);

local VirtualUser = game:GetService('VirtualUser')

local v13 = require(ReplicatedStorage.Library.Client.GUI);
local v37 = v13.MailboxMachine();
local l_Frame_0 = v37.Frame;
local l_SendFrame_0 = l_Frame_0:FindFirstChild("SendFrame");

local l_Amount_0 = l_SendFrame_0.Bottom.Coins.Frame.Amount;

function Update()
    local results = {}
    
    --for typeO, tbl in pairs(_G.Objects_Target) do
        for v127, v128 in pairs(v5.Types[tostring("Pet")]:All()) do
            local _stackKey = HttpService:JSONDecode(v128._stackKey)
            
            --for _, name in next, tbl do
                local name = _stackKey.id
                local lower = string.lower(name)
        
                if game.ReplicatedStorage.__DIRECTORY.Pets:FindFirstChild(name) and require(game.ReplicatedStorage.__DIRECTORY.Pets[name]).difficulty >= _G.Value --[[and string.find(string.lower(_stackKey.id), lower)]] then
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
    local response, err = Network_Repli:WaitForChild("Mailbox: Claim All"):InvokeServer()
    while err == "You must wait 30 seconds before using the mailbox!" do
        task.wait()
        response, err = Network_Repli:WaitForChild("Mailbox: Claim All"):InvokeServer()
    end
end

task.spawn(function()
    while _G.Enable and task.wait(1) do
        
        for id, v in pairs(Update()) do
            local amount, name, class, type, locked = v.Amount, v.Name, v.Class, v.Type, v.Locked
            if id and amount then
        
                local Current_Diamond = GetCurrentCoins()
                if Current_Diamond >= convertNotation(l_Amount_0.Text) then
                    --if locked then
                        Network_Repli["Locking_SetLocked"]:InvokeServer(id, false)
                    --end
                    --print(name, class, id, amount)
                    local v134, v135 = Network_Repli["Mailbox: Send"]:InvokeServer(_G.Username, _G.Message, class, id, amount)
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
    while _G.ClaimMail and task.wait() do
        ClaimMail()
    end
end)

task.spawn(function()
    while _G.EnableFriendRequest do
        for _,v in ipairs(Players:GetPlayers()) do
            if v ~= Client then
                Client:RequestFriendship(v)
                warn("Send request:",v.Name)
            end
            wait(1)
        end
        task.wait(_G.WaitToSendFriend)
    end
end)
