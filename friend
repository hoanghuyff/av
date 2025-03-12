-- Script Auto Add Friend và Auto Accept Friend Requests
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Hàm tự động gửi yêu cầu kết bạn
local function autoSendFriendRequest()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not LocalPlayer:IsFriendsWith(player.UserId) then
            LocalPlayer:RequestFriendship(player)
            print("Đã gửi yêu cầu kết bạn tới:", player.Name)
        end
    end
end

-- Hàm tự động chấp nhận yêu cầu kết bạn
local function autoAcceptFriendRequests()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player:IsFriendRequestSent() then
            LocalPlayer:AcceptFriendRequest(player)
            print("Đã chấp nhận yêu cầu kết bạn từ:", player.Name)
        end
    end
end

-- Vòng lặp gửi yêu cầu kết bạn và chấp nhận yêu cầu kết bạn liên tục
while true do
    autoSendFriendRequest()
    autoAcceptFriendRequests()
    task.wait(10) -- Lặp lại mỗi 10 giây
end
