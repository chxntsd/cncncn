-- WindUI 加载模块
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Frostx/WindUI/main/source.lua"))()

-- 创建主窗口
local Window = WindUI:CreateWindow({
    Title = "Ohio 本地美化面板",
    Icon = "rbxassetid://13364795407",
    Theme = "Dark"
})

-- 创建标签页
local TabItem = Window:CreateTab("道具美化")
local TabSkin = Window:CreateTab("枪械皮肤")
local TabAdmin = Window:CreateTab("修改功能")

-- ===================== 道具美化标签页 =====================
-- 自动购买气球 Toggle
TabItem:CreateToggle({
    Name = "自动购买气球",
    Value = false,
    Callback = function(state)
        if not state then return end
        
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        
        if character:FindFirstChild("Balloon") then return end
        
        local Signal = load("Signal")
        Signal.InvokeServer("attemptPurchase", "Balloon")
        
        task.wait(0.5)
        
        local v3item = load("v3item")
        local inventory = v3item.inventory
        local balloonItem = inventory.getFromName("Balloon")
        
        if balloonItem then
            xeniox.Helpers:CallFuncSec(function()
                balloonItem:SetEquipped(true)
            end)
        end
    end
})

-- 美化美金气球
TabItem:CreateButton({
    Name = "美化美金(需普通气球)",
    Callback = function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "name") == "Balloon" and rawget(v, "holdableType") == "Balloon" then
                v.name, v.cost, v.unpurchasable, v.multiplier, v.movespeedAdd, v.cannotDiscard = "Dollar Balloon", 200, true, 0.8, 8, true
                if v.TPSOffsets then v.TPSOffsets.hold = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.pi, 0) end
                if v.viewportOffsets and v.viewportOffsets.hotbar then v.viewportOffsets.hotbar.dist = 4 end
                v.canDrop, v.dropCooldown, v.craft = nil
                break
            end
        end

        for _, item in pairs(require(game.ReplicatedStorage.devv.client.Objects.v3item.modules.inventory).items) do
            if item.name == "Dollar Balloon" then
                for _, btn in pairs({item.button, item.backpackButton}) do
                    if btn and btn.resetModelSkin then btn:resetModelSkin() end
                end
            end
        end
    end
})

-- 美化黑玫瑰气球
TabItem:CreateButton({
    Name = "美化黑玫瑰(需普通气球)",
    Callback = function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "name") == "Balloon" and rawget(v, "holdableType") == "Balloon" then
                v.name, v.cost, v.unpurchasable, v.multiplier, v.movespeedAdd, v.cannotDiscard = "Black Rose", 200, true, 0.75, 12, true
                if v.TPSOffsets then v.TPSOffsets.hold = CFrame.new(0, 0.5, 0) end
                if v.viewportOffsets and v.viewportOffsets.hotbar then v.viewportOffsets.hotbar.dist = 3 end
                v.canDrop, v.dropCooldown, v.craft = nil
                break
            end
        end

        for _, item in pairs(require(game.ReplicatedStorage.devv.client.Objects.v3item.modules.inventory).items) do
            if item.name == "Black Rose" then
                for _, btn in pairs({item.button, item.backpackButton}) do
                    if btn and btn.resetModelSkin then btn:resetModelSkin() end
                end
            end
        end
    end
})

-- 美化Kunai
TabItem:CreateButton({
    Name = "美化Kunai(需普通气球)",
    Callback = function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "name") == "Balloon" and rawget(v, "holdableType") == "Balloon" then
                v.name = "Kunai"
                v.permanent = true
                v.canDrop = true
                v.dropCooldown = 120
                v.holdableType = "Balloon"
                v.movespeedAdd = 12
                if v.TPSOffsets then
                    v.TPSOffsets.hold = CFrame.new(0, -0.3, 0)
                else
                    v.TPSOffsets = {hold = CFrame.new(0, -0.3, 0)}
                end
                if v.viewportOffsets then
                    if v.viewportOffsets.hotbar then
                        v.viewportOffsets.hotbar.dist = 3
                        v.viewportOffsets.hotbar.offset = CFrame.new(0, 0, 0)
                        v.viewportOffsets.hotbar.rotoffset = CFrame.Angles(0, 1.5707963, 0)
                    else
                        v.viewportOffsets.hotbar = {dist = 3, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 1.5707963, 0)}
                    end
                    if v.viewportOffsets.ammoHUD then
                        v.viewportOffsets.ammoHUD.dist = 2
                        v.viewportOffsets.ammoHUD.offset = CFrame.new(-0.1, -0.2, 0)
                        v.viewportOffsets.ammoHUD.rotoffset = CFrame.Angles(0, -1.3744468, 0)
                    else
                        v.viewportOffsets.ammoHUD = {dist = 2, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.3744468, 0)}
                    end
                    if v.viewportOffsets.slotButton then
                        v.viewportOffsets.slotButton.dist = 1
                        v.viewportOffsets.slotButton.offset = CFrame.new(-0.1, -0.2, 0)
                        v.viewportOffsets.slotButton.rotoffset = CFrame.Angles(0, -1.5707963, 0)
                    else
                        v.viewportOffsets.slotButton = {dist = 1, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.5707963, 0)}
                    end
                else
                    v.viewportOffsets = {
                        hotbar = {dist = 3, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 1.5707963, 0)},
                        ammoHUD = {dist = 2, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.3744468, 0)},
                        slotButton = {dist = 1, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.5707963, 0)}
                    }
                end
                break
            end
        end
        for _, item in pairs(require(game.ReplicatedStorage.devv.client.Objects.v3item.modules.inventory).items) do
            if item.name == "Kunai" then
                for _, btn in pairs({item.button, item.backpackButton}) do
                    if btn and btn.resetModelSkin then btn:resetModelSkin() end
                end
            end
        end
    end
})

-- 美化Spirit Kunai
TabItem:CreateButton({
    Name = "美化Spirit Kunai(需普通Kunai)",
    Callback = function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "name") == "Kunai" and rawget(v, "holdableType") == "Kunai" then
                v.name = "Spirit Kunai"
                v.permanent = true
                v.canDrop = true
                v.dropCooldown = 120
                v.holdableType = "Kunai"
                v.movespeedAdd = 12
                if v.TPSOffsets then
                    v.TPSOffsets.hold = CFrame.new(0, -0.3, 0)
                else
                    v.TPSOffsets = {hold = CFrame.new(0, -0.3, 0)}
                end
                if v.viewportOffsets then
                    if v.viewportOffsets.hotbar then
                        v.viewportOffsets.hotbar.dist = 3
                        v.viewportOffsets.hotbar.offset = CFrame.new(0, 0, 0)
                        v.viewportOffsets.hotbar.rotoffset = CFrame.Angles(0, 1.5707963, 0)
                    else
                        v.viewportOffsets.hotbar = {dist = 3, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 1.5707963, 0)}
                    end
                    if v.viewportOffsets.ammoHUD then
                        v.viewportOffsets.ammoHUD.dist = 2
                        v.viewportOffsets.ammoHUD.offset = CFrame.new(-0.1, -0.2, 0)
                        v.viewportOffsets.ammoHUD.rotoffset = CFrame.Angles(0, -1.3744468, 0)
                    else
                        v.viewportOffsets.ammoHUD = {dist = 2, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.3744468, 0)}
                    end
                    if v.viewportOffsets.slotButton then
                        v.viewportOffsets.slotButton.dist = 1
                        v.viewportOffsets.slotButton.offset = CFrame.new(-0.1, -0.2, 0)
                        v.viewportOffsets.slotButton.rotoffset = CFrame.Angles(0, -1.5707963, 0)
                    else
                        v.viewportOffsets.slotButton = {dist = 1, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.5707963, 0)}
                    end
                else
                    v.viewportOffsets = {
                        hotbar = {dist = 3, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 1.5707963, 0)},
                        ammoHUD = {dist = 2, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.3744468, 0)},
                        slotButton = {dist = 1, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.5707963, 0)}
                    }
                end
                break
            end
        end
        for _, item in pairs(require(game.ReplicatedStorage.devv.client.Objects.v3item.modules.inventory).items) do
            if item.name == "Spirit Kunai" then
                for _, btn in pairs({item.button, item.backpackButton}) do
                    if btn and btn.resetModelSkin then btn:resetModelSkin() end
                end
            end
        end
    end
})

-- ===================== 枪械皮肤标签页 =====================
TabSkin:CreateToggle({
    Name = "背包枪械美化虚空",
    Value = false,
    Callback = function(start)
        skinvoid = start
        if skinvoid then
            local it = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory
            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
            for i, item in next, b1 do
                if item.type == "Gun" then
                    table.insert(require(game:GetService("ReplicatedStorage").devv.shared.Indicies.skins.bin.Special.Void).compatabilities, item.name)
                    it.skinUpdate(item.name, "Void")
                end
            end
        end
    end
})

TabSkin:CreateToggle({
    Name = "背包枪械美化战术",
    Value = false,
    Callback = function(start)
        skinvoid = start
        if skinvoid then
            local it = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory
            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
            for i, item in next, b1 do
                if item.type == "Gun" then
                    table.insert(require(game:GetService("ReplicatedStorage").devv.shared.Indicies.skins.bin.Special.Void).compatabilities, item.name)
                    it.skinUpdate(item.name, "Tactical")
                end
            end
        end
    end
})

TabSkin:CreateToggle({
    Name = "背包枪械美化赛博",
    Value = false,
    Callback = function(start)
        skinvoid = start
        if skinvoid then
            local it = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory
            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
            for i, item in next, b1 do
                if item.type == "Gun" then
                    table.insert(require(game:GetService("ReplicatedStorage").devv.shared.Indicies.skins.bin.Special.Void).compatabilities, item.name)
                    it.skinUpdate(item.name, "Cyberpunk")
                end
            end
        end
    end
})

TabSkin:CreateToggle({
    Name = "背包枪械美化黑曜石",
    Value = false,
    Callback = function(start)
        skinvoid = start
        if skinvoid then
            local it = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory
            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
            for i, item in next, b1 do
                if item.type == "Gun" then
                    table.insert(require(game:GetService("ReplicatedStorage").devv.shared.Indicies.skins.bin.Special.Void).compatabilities, item.name)
                    it.skinUpdate(item.name, "Obsidian")
                end
            end
        end
    end
})

-- 皮肤下拉菜单
local skinsec = "Void"
TabSkin:CreateDropdown({
    Name = "选择美化皮肤",
    Options = {
        "烟火", "虚空", "纯金", "暗物质", "反物质", "神秘", "虚空神秘", "战术", "纯金战术",
        "白未来", "黑未来", "圣诞未来", "礼物包装", "猩红", "收割者", "虚空收割者", "圣诞玩具",
        "荒地", "隐形", "像素", "钻石像素", "黄金零下", "绿水晶", "生物", "樱花", "精英",
        "黑樱花", "彩虹激光", "蓝水晶", "紫水晶", "红水晶", "零下", "虚空射线", "冰冻钻石",
        "虚空梦魇", "金雪", "爱国者", "MM2", "声望", "酷化", "蒸汽", "海盗", "玫瑰", "黑玫瑰",
        "激光", "烟花", "诅咒背瓜", "大炮", "财富", "黄金大炮", "四叶草", "自由", "黑曜石", "赛博朋克"
    },
    Default = "虚空",
    Callback = function(Value)
        if Value == "烟火" then
            skinsec = "Sparkler"
        elseif Value == "虚空" then
            skinsec = "Void"
        elseif Value == "纯金" then
            skinsec = "Solid Gold"
        elseif Value == "暗物质" then
            skinsec = "Dark Matter"
        elseif Value == "反物质" then
            skinsec = "Anti Matter"
        elseif Value == "神秘" then
            skinsec = "Hystic"
        elseif Value == "虚空神秘" then
            skinsec = "Void Mystic"
        elseif Value == "战术" then
            skinsec = "Tactical"
        elseif Value == "纯金战术" then
            skinsec = "Solid Gold Tactical"
        elseif Value == "白未来" then
            skinsec = "Future White"
        elseif Value == "黑未来" then
            skinsec = "Future Black"
        elseif Value == "圣诞未来" then
            skinsec = "Christmas Future"
        elseif Value == "礼物包装" then
            skinsec = "Gift Wrapped"
        elseif Value == "猩红" then
            skinsec = "Crimson Blood"
        elseif Value == "收割者" then
            skinsec = "Reaper"
        elseif Value == "虚空收割者" then
            skinsec = "Void Reaper"
        elseif Value == "圣诞玩具" then
            skinsec = "Christmas Toy"
        elseif Value == "荒地" then
            skinsec = "Wasteland"
        elseif Value == "隐形" then
            skinsec = "Invisible"
        elseif Value == "像素" then
            skinsec = "Pixel"
        elseif Value == "钻石像素" then
            skinsec = "Diamond Pixel"
        elseif Value == "黄金零下" then
            skinsec = "Frozen-Gold"
        elseif Value == "绿水晶" then
            skinsec = "Atomic Nature"
        elseif Value == "生物" then
            skinsec = "Biohazard"
        elseif Value == "樱花" then
            skinsec = "Sakura"
        elseif Value == "精英" then
            skinsec = "Elite"
        elseif Value == "黑樱花" then
            skinsec = "Death Blossom-Gold"
        elseif Value == "彩虹激光" then
            skinsec = "Rainbowlaser"
        elseif Value == "蓝水晶" then
            skinsec = "Atomic Water"
        elseif Value == "紫水晶" then
            skinsec = "Atomic Amethyst"
        elseif Value == "红水晶" then
            skinsec = "Atomic Flame"
        elseif Value == "零下" then
            skinsec = "Sub-Zero"
        elseif Value == "虚空射线" then
            skinsec = "Void-Ray"
        elseif Value == "冰冻钻石" then
            skinsec = "Frozen Diamond"
        elseif Value == "虚空梦魇" then
            skinsec = "Void Nightmare"
        elseif Value == "金雪" then
            skinsec = "Golden Snow"
        elseif Value == "爱国者" then
            skinsec = "Patriot"
        elseif Value == "MM2" then
            skinsec = "MM2 Barrett"
        elseif Value == "声望" then
            skinsec = "Prestige Barnett"
        elseif Value == "酷化" then
            skinsec = "Skin Walter"
        elseif Value == "蒸汽" then
            skinsec = "Steampunk"
        elseif Value == "海盗" then
            skinsec = "Pirate"
        elseif Value == "玫瑰" then
            skinsec = "Rose"
        elseif Value == "黑玫瑰" then
            skinsec = "Black Rose"
        elseif Value == "激光" then
            skinsec = "Hyperlaser"
        elseif Value == "烟花" then
            skinsec = "Firework"
        elseif Value == "诅咒背瓜" then
            skinsec = "Cursed Pumpkin"
        elseif Value == "大炮" then
            skinsec = "Cannon"
        elseif Value == "财富" then
            skinsec = "Firework"
        elseif Value == "黄金大炮" then
            skinsec = "Gold Cannon"
        elseif Value == "四叶草" then
            skinsec = "Lucky Clover"
        elseif Value == "自由" then
            skinsec = "Freedom"
        elseif Value == "黑曜石" then
            skinsec = "Obsidian"
        elseif Value == "赛博朋克" then
            skinsec = "Cyberpunk"
        end
    end
})

TabSkin:CreateToggle({
    Name = "全部枪械美化",
    Value = false,
    Callback = function(start)
        autoskin = start
        if autoskin then
            local it = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory
            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
            for i, item in next, b1 do
                if item.type == "Gun" then
                    it.skinUpdate(item.name, skinsec)
                end
            end
        end
    end
})

-- ===================== 物品生成模块 =====================
local items = {
    "Golden Rose", "Black Rose", "Dollar Balloon", "Bat Balloon", "Bunny Balloon", "Clover Balloon",
    "Ghost Balloon", "Gold Clover Balloon", "Heart Balloon", "Skull Balloon", "Snowflake Balloon",
    "Admin AK-47", "Admin Nuke Launcher", "Admin RPG", "Void Gem", "Pulse Rifle", "Unusual Money Printer",
    "Money Printer", "Trident", "NextBot Grenade", "El Fuego", "Kunai", "Spirit Kunai"
}
local itemDisplayNames = {
    ["Golden Rose"] = "金玫瑰", ["Black Rose"] = "黑玫瑰", ["Dollar Balloon"] = "美元气球",
    ["Bat Balloon"] = "蝙蝠气球", ["Bunny Balloon"] = "兔子气球", ["Clover Balloon"] = "三叶草气球",
    ["Ghost Balloon"] = "幽灵气球", ["Gold Clover Balloon"] = "金三叶草气球", ["Heart Balloon"] = "爱心气球",
    ["Skull Balloon"] = "骷髅气球", ["Snowflake Balloon"] = "雪花气球", ["Admin AK-47"] = "管理员黄金AK-47",
    ["Admin Nuke Launcher"] = "管理员核弹发射器", ["Admin RPG"] = "管理员RPG", ["Void Gem"] = "虚空宝石",
    ["Pulse Rifle"] = "脉冲步枪", ["Unusual Money Printer"] = "异常印钞机", ["Money Printer"] = "印钞机",
    ["Trident"] = "三叉戟", ["NextBot Grenade"] = "NextBot手榴弹", ["El Fuego"] = "烈焰喷射器",
    ["Kunai"] = "苦无", ["Spirit Kunai"] = "灵魂苦无"
}
local itemData = {}

itemData["Bat Balloon"] = {name = "Bat Balloon", cost = 0, unpurchasable = true, multiplier = 0.625, holdableType = "Balloon", canDrop = true, dropCooldown = 120, permanent = true,
