--this is lyy Publicity
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

local maskBaseLocation = CFrame.new(604.114014, 5.09485245, -1018.1275)
local idleLocation = CFrame.new(1653.397216796875, -16.95315170288086, -530.3738403320312)
local grenadeBuyLocation = CFrame.new(659.044739, 5.77163315, -706.697632, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07)
local bombThrowLocation = CFrame.new(1129.0994873046875, 14.843579292297363, -354.19488525390625)
local bombTargetPosition = Vector3.new(1124.0853271484, 5.3128666877747, -357.68710327148)
local afterExplosionWaitLocation = CFrame.new(1112.95142, 16.6149864, -331.99646, 0, 0, -1, 0, 1, 0, 1, 0, 0)

local idleTeleportEnabled = true
local busy = false
local maskBuying = false

local Remotes, Inventory
pcall(function()
    Remotes = require(ReplicatedStorage.devv.client.Helpers.remotes.Signal)
    Inventory = require(ReplicatedStorage.devv).load("v3item").inventory
end)

local FireServer = Remotes and Remotes.FireServer
local InvokeServer = Remotes and Remotes.InvokeServer

-- 物品缓存
local itemMap = {}
local function updateCache()
    local itemPickup = Workspace.Game.Entities:FindFirstChild("ItemPickup")
    if not itemPickup then itemMap = {} return end
    itemMap = {}
    for _, model in pairs(itemPickup:GetChildren()) do
        for _, v in pairs(model:GetChildren()) do
            if v:IsA("MeshPart") or v:IsA("Part") then
                local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                if prompt and prompt.ObjectText then
                    itemMap[prompt.ObjectText] = { part = v, prompt = prompt }
                end
            end
        end
    end
end
updateCache()
local itemPickupFolder = Workspace.Game.Entities:FindFirstChild("ItemPickup")
if itemPickupFolder then
    itemPickupFolder.ChildAdded:Connect(updateCache)
    itemPickupFolder.ChildRemoved:Connect(updateCache)
end

local itemFailCounts = {}

local function Autoitem(itemName)
    local itemData = itemMap[itemName]
    if not itemData then
        itemFailCounts[itemName] = (itemFailCounts[itemName] or 0) + 1
        return false
    end
    local char = LocalPlayer.Character
    if not char then
        itemFailCounts[itemName] = (itemFailCounts[itemName] or 0) + 1
        return false
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then
        itemFailCounts[itemName] = (itemFailCounts[itemName] or 0) + 1
        return false
    end
    root.CFrame = itemData.part.CFrame
    itemData.prompt.RequiresLineOfSight = false
    itemData.prompt.HoldDuration = 0
    fireproximityprompt(itemData.prompt)
    itemFailCounts[itemName] = 0
    return true
end

LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), CurrentCamera.CFrame)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        idleTeleportEnabled = not idleTeleportEnabled
    end
end)

local function buyMaskOnce()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if char:FindFirstChild("Black Bandana") then return end

    local offsetX = math.random(-8, 8)
    local offsetZ = math.random(-8, 8)
    local randomPos = maskBaseLocation.Position + Vector3.new(offsetX, 0, offsetZ)
    root.CFrame = CFrame.new(randomPos)
    task.wait(0.5)

    local Signal = require(ReplicatedStorage.devv).load("Signal")
    local b1 = require(ReplicatedStorage.devv).load("v3item").inventory.items
    Signal.InvokeServer("attemptPurchase", "Black Bandana")
    task.wait(0.3)
    for _, v in pairs(b1) do
        if v.name == "Black Bandana" then
            Signal.FireServer("equip", v.guid)
            Signal.FireServer("wearMask", v.guid)
            break
        end
    end
end

local function ensureMask()
    while true do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Black Bandana") then
            return true
        end
        pcall(buyMaskOnce)
        task.wait(0.5)
    end
end

local function maskRoutine()
    maskBuying = true
    ensureMask()
    task.wait(2)
    maskBuying = false
end

LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart", 10)
    busy = false
    maskBuying = false
    task.spawn(maskRoutine)
end)

local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

task.spawn(function()
    while true do
        local _, hrp = pcall(function() return LocalPlayer.Character.HumanoidRootPart end)
        if hrp then
            local cb = Workspace:FindFirstChild("Game") and Workspace.Game.Entities:FindFirstChild("CashBundle")
            if cb then
                for _, cash in pairs(cb:GetChildren()) do
                    local part = cash:FindFirstChildOfClass("Part")
                    if part then
                        local distance = (hrp.Position - part.Position).Magnitude
                        if distance <= 90 then
                            local cd = cash:FindFirstChildOfClass("ClickDetector")
                            if cd then
                                fireclickdetector(cd)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

local function collectNearbyCash()
    local root = getRoot()
    if not root then return end
    local cb = Workspace:FindFirstChild("Game") and Workspace.Game.Entities:FindFirstChild("CashBundle")
    if not cb then return end
    for _, cash in pairs(cb:GetChildren()) do
        local part = cash:FindFirstChildOfClass("Part")
        if part then
            local distance = (root.Position - part.Position).Magnitude
            if distance <= 90 then
                local cd = cash:FindFirstChildOfClass("ClickDetector")
                if cd then
                    fireclickdetector(cd)
                end
            end
        end
    end
end

-- 自动捡气球
task.spawn(function()
    while true do
        if not busy then
            for _, name in ipairs({"Bunny Balloon", "Ghost Balloon", "Clover Balloon", "Bat Balloon", "Gold Clover Balloon", "Golden Rose", "Black Rose", "Heart Balloon"}) do
                Autoitem(name)
            end
        end
        task.wait(0.1)
    end
end)

-- 自动捡印钞机
task.spawn(function()
    while (itemFailCounts["Money Printer"] or 0) < 12 do
        if not busy then
            Autoitem("Money Printer")
        end
        task.wait(0.1)
    end
end)

-- 自动售卖
task.spawn(function()
    local Signal = require(ReplicatedStorage.devv).load("Signal")
    local itemModule = require(ReplicatedStorage.devv).load("v3item")
    while true do
        for _, v in pairs(itemModule.inventory.items) do
            pcall(function()
                Signal.FireServer("equip", v.guid)
                Signal.FireServer("sellItem", v.guid)
            end)
        end
        task.wait(1)
    end
end)

local function runATMPhase()
    local atms = workspace:FindFirstChild("ATMs")
    if not atms then return end
    local root = getRoot()
    if not root then return end

    busy = true
    local originalCFrame = root.CFrame
    local currentTarget = nil
    local stop = false
    local lockConn = nil
    local canSearch = true

    local function clearLock()
        if lockConn then
            lockConn:Disconnect()
            lockConn = nil
        end
    end

    local moveThread = task.spawn(function()
        while not stop do
            if canSearch then
                local nearestATM, nearestDist = nil, math.huge
                for _, atm in ipairs(atms:GetChildren()) do
                    if atm:IsA("Model") and (atm:GetAttribute("health") or 0) ~= 0 then
                        local main = atm:FindFirstChild("Main")
                        if main and main:IsA("BasePart") then
                            local dist = (root.Position - main.Position).Magnitude
                            if dist < nearestDist then
                                nearestDist = dist
                                nearestATM = atm
                            end
                        end
                    end
                end
                if not nearestATM then
                    stop = true
                    clearLock()
                    break
                end
                currentTarget = nearestATM
                local main = nearestATM:FindFirstChild("Main")
                local lockCF = CFrame.new(main.Position - Vector3.new(0, 4, 0)) * CFrame.Angles(math.rad(90), 0, 0)
                root.CFrame = lockCF
                clearLock()
                lockConn = RunService.Heartbeat:Connect(function()
                    if root and root.Parent then
                        root.CFrame = lockCF
                        root.Velocity = Vector3.zero
                        root.RotVelocity = Vector3.zero
                    end
                end)
                canSearch = false
                task.spawn(function()
                    task.wait(0.4)
                    if currentTarget and currentTarget.Parent then
                        currentTarget:SetAttribute("health", 0)
                        collectNearbyCash()
                    end
                    task.wait(1)
                    currentTarget = nil
                    canSearch = true
                end)
            end
            task.wait(0.1)
        end
        clearLock()
    end)

    repeat
        task.wait(0.1)
    until stop

    if root then
        root.CFrame = originalCFrame
    end
    busy = false
end

local function ensureItem(itemName, buyLocation)
    if not InvokeServer or not FireServer then return end
    local items = require(ReplicatedStorage.devv).load("v3item").inventory.items
    for _, v in pairs(items) do
        if v.name == itemName then return v.guid end
    end
    local root = getRoot()
    if root then
        root.CFrame = buyLocation
        task.wait(0.5)
        InvokeServer("attemptPurchase", itemName)
        task.wait(0.5)
    end
    items = require(ReplicatedStorage.devv).load("v3item").inventory.items
    for _, v in pairs(items) do
        if v.name == itemName then return v.guid end
    end
    return nil
end

local function tryBankHeist()
    if not FireServer or not InvokeServer then return false end

    busy = true

    local bank = Workspace:FindFirstChild("BankRobbery")
    if not bank then busy = false return false end
    local cashFolder = bank:FindFirstChild("BankCash") and bank.BankCash:FindFirstChild("Cash")
    if not cashFolder or #cashFolder:GetChildren() == 0 then
        busy = false
        return false
    end

    local fragGuid = ensureItem("Frag", grenadeBuyLocation)
    if not fragGuid then busy = false return false end

    local root = getRoot()
    if not root then busy = false return false end

    root.CFrame = bombThrowLocation
    task.wait(0.3)

    FireServer("equip", fragGuid)
    task.wait(0.1)
    local direction = (bombTargetPosition - root.Position).Unit
    FireServer("throwItem", fragGuid, direction, bombTargetPosition)
    FireServer("removeItem", fragGuid)
    task.wait(1.5)

    bank = Workspace:FindFirstChild("BankRobbery")
    if not bank then busy = false return false end
    cashFolder = bank:FindFirstChild("BankCash") and bank.BankCash:FindFirstChild("Cash")
    local pallet = bank:FindFirstChild("BankCash") and bank.BankCash:FindFirstChild("Pallet")
    local promptPart = bank:FindFirstChild("BankCash") and bank.BankCash:FindFirstChild("Main")
    local prompt = promptPart and promptPart:FindFirstChild("Attachment") and promptPart.Attachment:FindFirstChild("ProximityPrompt")
    if not (cashFolder and pallet and prompt) then busy = false return false end

    root.CFrame = afterExplosionWaitLocation

    local lockPos = (afterExplosionWaitLocation * CFrame.new(0, 0, -4)).Position
    local lockCF = CFrame.new(lockPos) * CFrame.Angles(math.rad(90), 0, 0)
    local endTime = tick() + 4
    while tick() < endTime do
        root = getRoot()
        if root then
            root.CFrame = lockCF
            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
        end
        task.wait(0.2)
    end

    local collectCF = CFrame.new((pallet.CFrame * CFrame.new(0, -2, 0)).Position) * CFrame.Angles(math.rad(90), 0, 0)
    root = getRoot()
    if root then
        root.CFrame = collectCF
    end

    local cashConnection
    cashConnection = RunService.Heartbeat:Connect(function()
        if not cashFolder or not cashFolder.Parent or #cashFolder:GetChildren() == 0 then
            if cashConnection then cashConnection:Disconnect() end
            return
        end
        collectNearbyCash()
        pcall(function() fireproximityprompt(prompt) end)
    end)

    while bank and cashFolder and prompt.Enabled and #cashFolder:GetChildren() > 0 do
        root = getRoot()
        if not root then break end
        root.CFrame = collectCF
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        task.wait(0.2)
    end

    if cashConnection then cashConnection:Disconnect() end

    root = getRoot()
    if root then
        root.CFrame = idleLocation
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
    end
    busy = false
    return true
end

task.spawn(function()
    while true do
        task.wait(0.1)
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Seated then
                humanoid.Sit = false
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end
end)

task.spawn(function()
    RunService.Heartbeat:Connect(function()
        if idleTeleportEnabled and not busy and not maskBuying then
            local root = getRoot()
            if root then
                root.CFrame = idleLocation
                root.Velocity = Vector3.zero
                root.RotVelocity = Vector3.zero
            end
        end
    end)
end)

repeat task.wait(0.5) until getRoot()

maskRoutine()

while true do
    pcall(runATMPhase)
    pcall(tryBankHeist)
    task.wait(0.5)
end