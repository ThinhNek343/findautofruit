wait(1) 
getgenv().Hide_UI = false

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local replicated = RS
local TeamReady = false
local Sec = 1

local World2 = game.PlaceId == 4442272183
local World3 = game.PlaceId == 7449423635

local utils = {}
function utils.create(class, prop)
    local o = Instance.new(class)
    for k,v in pairs(prop) do o[k] = v end
    return o
end

--// v4 — Add Centered "Join Discord" Button

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local function create(class, props)
	local inst = Instance.new(class)
	for i, v in pairs(props) do
		inst[i] = v
	end
	return inst
end

-- Xóa UI cũ nếu có
for _, v in pairs(CoreGui:GetChildren()) do
	if v:IsA("ScreenGui") and v.Name == "no1hub_ui_v4" then
		v:Destroy()
	end
end

-- Tạo ScreenGui chính
local ScreenGui = create("ScreenGui", {
	Name = "no1hub_ui_v4",
	Parent = CoreGui,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Global
})

-- Logo góc trái
local Logo = create("ImageLabel", {
	Parent = ScreenGui,
	Position = UDim2.new(0.105, 720, 0.35, 0),
	Size = UDim2.new(0, 100, 0, 100),
	BackgroundTransparency = 1,
	Image = "rbxassetid://85995292005925"
})
create("UICorner", { Parent = Logo, CornerRadius = UDim.new(1, 0) })
create("UIStroke", {
	Parent = Logo,
	Color = Color3.fromRGB(200, 255, 255),
	Thickness = 1,
	Transparency = 0.4
})

-- Tiêu đề  ở giữa trên
local Title = create("TextLabel", {
	Parent = ScreenGui,
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0.04, 0),
	Size = UDim2.new(0, 600, 0, 80),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack,
	Text = "TDT Find Fruit",
	TextColor3 = Color3.fromRGB(157, 255, 118),
	TextStrokeTransparency = 0.5,
	TextStrokeColor3 = Color3.fromRGB(0, 95, 29),
	TextScaled = true
})
create("UIStroke", {
	Parent = Title,
	Color = Color3.fromRGB(100, 200, 255),
	Thickness = 1.5,
	Transparency = 0.4
})

--// 🟦 Nút Join Discord ở giữa màn hình
local DiscordButton = create("TextButton", {
	Parent = ScreenGui,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0, 250, 0, 70),
	Text = "Join Discord",
	Font = Enum.Font.GothamBold,
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextScaled = true,
	BackgroundColor3 = Color3.fromRGB(255, 255, 255)
})
create("UICorner", { Parent = DiscordButton, CornerRadius = UDim.new(0, 15) })

-- Gradient cho nút
create("UIGradient", {
	Parent = DiscordButton,
	Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 70)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 120))
	},
	Rotation = 90
})

-- Viền sáng
local ButtonStroke = create("UIStroke", {
	Parent = DiscordButton,
	Color = Color3.fromRGB(180, 220, 255),
	Thickness = 2,
	Transparency = 0.3
})

-- Hiệu ứng hover (sáng + phóng to)
DiscordButton.MouseEnter:Connect(function()
	TweenService:Create(DiscordButton, TweenInfo.new(0.2), {
		Size = UDim2.new(0, 270, 0, 76),
		BackgroundColor3 = Color3.fromRGB(90, 150, 255)
	}):Play()
end)
DiscordButton.MouseLeave:Connect(function()
	TweenService:Create(DiscordButton, TweenInfo.new(0.2), {
		Size = UDim2.new(0, 250, 0, 70),
		BackgroundColor3 = Color3.fromRGB(50, 90, 255)
	}):Play()
end)

-- Khi click -> copy link Discord
local copiedLabel = create("TextLabel", {
	Parent = ScreenGui,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.6, 0),
	Size = UDim2.new(0, 200, 0, 40),
	Text = "Copied invite link!",
	TextColor3 = Color3.fromRGB(129, 141, 248),
	Font = Enum.Font.FredokaOne,
	TextScaled = true,
	BackgroundTransparency = 1,
	Visible = false
})

DiscordButton.MouseButton1Click:Connect(function()
	local invite = "https://discord.gg/tdtfreenokey"
	if setclipboard then
		setclipboard(invite)
	end
	copiedLabel.Visible = true
	copiedLabel.TextTransparency = 1
	TweenService:Create(copiedLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
	wait(1.5)
	TweenService:Create(copiedLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
	wait(0.4)
	copiedLabel.Visible = false
end)

getgenv().StatusLabel = Title

function updateStatus(txt, color)
	if getgenv().StatusLabel then
		getgenv().StatusLabel.Text = txt
		getgenv().StatusLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	end
end

task.spawn(function()
    task.wait(2)
    local team = getgenv().Config["Team"]

    if (team == "Marines" or team == "Pirates") then
        pcall(function()
            RS.Remotes.CommF_:InvokeServer("SetTeam", team)
        end)
    end

    repeat task.wait(1) until plr.Team ~= nil and plr.Team.Name == team

    plr.CharacterAdded:Wait()
    task.wait(1)

    TeamReady = true
end)

task.wait(5) 
if getgenv().Config["Fps Boost"] then
    local Player = game.Players.LocalPlayer
    if Player.Character and Player.Character:FindFirstChild("Pants") then
        Player.Character.Pants:Destroy()
    end
    if Player.Character and Player.Character:FindFirstChild("Animate") then
        Player.Character.Animate.Disabled = true
    end
    task.wait(0.2)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/JewhisKids/NewFreeScript/main/Misc/SuperFpsBoost.lua"))()
    setfpscap(60)
    task.wait(1)
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") then
            v.Enabled = false
        end
    end
end

local LocalPlayer = Players.LocalPlayer

local function waitForChar()
    local c = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return c, c:WaitForChild("HumanoidRootPart", 9e9)
end

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local char, hrp = waitForChar()
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end

            local equipped = char:FindFirstChildOfClass("Tool")
            local foundTool

            for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    for _, name in ipairs(getgenv().Config["Weapon"]) do
                        if string.lower(tool.ToolTip) == string.lower(name) then
                            foundTool = tool
                            break
                        end
                    end
                end
            end

            if foundTool and (not equipped or equipped.ToolTip ~= foundTool.ToolTip) then
                humanoid:EquipTool(foundTool)
            end

            if not char:FindFirstChild("HasBuso") then
                pcall(function()
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                end)
            end
        end)
    end
end)

local function hrp()
    return plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
end

local function Alive()
    return plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0
end

RunService.Stepped:Connect(function()
    if Alive() then
        for _,v in pairs(plr.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

local function HopServer()
    local Data = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    for _,v in pairs(HttpService:JSONDecode(Data).data) do
        if v.playing < v.maxPlayers then
            TS:TeleportToPlaceInstance(game.PlaceId, v.id)
        end
    end
end

local function FactoryIsActive()
    return World2 and workspace:FindFirstChild("Factory") and workspace.Factory:FindFirstChild("Core")
end

local function PirateRaidIsActive()
    return World3 and (workspace:FindFirstChild("Raid") or workspace:FindFirstChild("PirateRaid"))
end

local function GetFruit()
    for _,v in pairs(workspace:GetChildren()) do
        if string.find(v.Name,"Fruit") and v:FindFirstChild("Handle") then
            return v.Handle
        end
    end
end

local function TweenFruit(cf)
    local h = hrp()
    if not h then return end
    for _,v in pairs(plr.Character:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide = false end
    end
    local bv = Instance.new("BodyVelocity",h)
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    local s = getgenv().Config["Tween Speed"]

    while task.wait() do
        if not Alive() or not getgenv().Config["Start Auto Fruit"] then break end
        if (h.Position - cf.Position).Magnitude <= 3 then break end
        bv.Velocity = (cf.Position - h.Position).Unit * s
    end

    h.CFrame = cf
    bv:Destroy()
end

UpdStFruit = function()
    for _,x in next, plr.Backpack:GetChildren() do
        local StoreFruit = x:FindFirstChild("EatRemote",true)
        if StoreFruit then
            RS.Remotes.CommF_:InvokeServer("StoreFruit",StoreFruit.Parent:GetAttribute("OriginalName"),plr.Backpack:FindFirstChild(x.Name))
        end
    end
end

collectFruits = function(Succes)
    if Succes then
        for _,v in pairs(workspace:GetChildren()) do
            if string.find(v.Name,"Fruit") then v.Handle.CFrame = hrp().CFrame end
        end
    end
end

spawn(function()
    while wait(Sec) do
        if getgenv().Config["Store Fruit"] then
            pcall(function() UpdStFruit() end)
        end
    end
end)

spawn(function()
  while wait(Sec) do
    if _G.AutoRaidCastle then
      pcall(function()
      local Root = hrp()
      local CFrameCastleRaid = CFrame.new(-5496.17432,313.768921,-2841.53027,0.924894512,0,0.380223751,0,1,0, -0.380223751,0,0.924894512)
        if (CFrame.new(-5539.3115,313.8005,-2972.3723).Position - Root.Position).Magnitude <= 500 then
          for _,v in pairs(workspace.Enemies:GetChildren()) do
            if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - Root.Position).Magnitude <= 2000 then
              repeat wait() Attack.Kill(v,_G.AutoRaidCastle) until not _G.AutoRaidCastle or v.Humanoid.Health <= 0
            end
          end
        else
          _tp(CFrameCastleRaid)
        end
      end)
    end
  end
end)

spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.AutoFactory then
        local v = GetConnectionEnemies("Core")
        if v then
          repeat wait()
            EquipWeapon(_G.SelectWeapon)
            _tp(CFrame.new(448.46756,199.356781,-441.389252))
          until v.Humanoid.Health <= 0 or not _G.AutoFactory
        else
          _tp(CFrame.new(448.46756,199.356781,-441.389252))
        end
      end
    end)
  end
end)

spawn(function()
    while task.wait(1) do
        if getgenv().Config["Auto Factory"] and FactoryIsActive() then
            updateStatus("Factory Event",Color3.fromRGB(255,230,0))
            repeat task.wait(0.5) until not FactoryIsActive()
        elseif getgenv().Config["Auto Pirate Raid"] and PirateRaidIsActive() then
            updateStatus("Pirate Raid",Color3.fromRGB(255,0,0))
            repeat task.wait(0.5) until not PirateRaidIsActive()
        else
            local fruit = GetFruit()
            if fruit then
                updateStatus("Found Fruit",Color3.fromRGB(0,255,0))
                TweenFruit(fruit.CFrame)
                collectFruits(true)
                UpdStFruit()
            else              
              task.wait(1.5)
              updateStatus("No Fruit | Hopping",Color3.fromRGB(255,150,0))
              HopServer()
            end
        end
    end
end)

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local function GetChar()
    return LP.Character or LP.CharacterAdded:Wait()
end

local function GetRoot()
    local char = GetChar()
    return char:FindFirstChild("HumanoidRootPart")
end

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local function GetChar()
    return LP.Character or LP.CharacterAdded:Wait()
end

local function GetRoot()
    local char = GetChar()
    return char:FindFirstChild("HumanoidRootPart")
end

local Modules = RS:WaitForChild("Modules")
local CombatUtil = require(Modules:WaitForChild("CombatUtil"))
local RE_Attack = Modules.Net:WaitForChild("RE/RegisterAttack")

local HIT_FUNCTION
local RunHitDetection = CombatUtil.RunHitDetection
pcall(function()
    local env = getsenv(Modules.CombatUtil)
    if env and env._G and env._G.SendHitsToServer then
        HIT_FUNCTION = env._G.SendHitsToServer
    end
end)

local FastAttack = {}

function FastAttack:IsAlive(mob)
    return mob
        and mob:FindFirstChild("Humanoid")
        and mob.Humanoid.Health > 0
        and mob:FindFirstChild("HumanoidRootPart")
end

function FastAttack:GetTargets(radius)
    local res = {}
    local root = GetRoot()
    if not root then return res end

    local pos = root.Position
    for _, mob in ipairs(workspace.Enemies:GetChildren()) do
        if self:IsAlive(mob) then
            if (mob.HumanoidRootPart.Position - pos).Magnitude <= (radius or 60) then
                table.insert(res, mob)
            end
        end
    end
    return res
end

function FastAttack:GetHitbox(mob)
    local list = {
        "RightLowerArm","RightUpperArm","LeftLowerArm","LeftUpperArm",
        "RightHand","LeftHand","HumanoidRootPart","Head"
    }
    return mob:FindFirstChild(list[math.random(1,#list)]) or mob.HumanoidRootPart
end

function FastAttack:Attack()
    local char = GetChar()
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end

    if tool.ToolTip == "Blox Fruit" then
        local remote = tool:FindFirstChild("LeftClickRemote")
        if remote then
            remote:FireServer(Vector3.new(0,-500,0),1,true)
            remote:FireServer(false)
        end
        return
    end

    local targets = self:GetTargets(65)
    if #targets == 0 then return end

    local args = {[1]=nil,[2]={}}
    for _, mob in ipairs(targets) do
        local hit = self:GetHitbox(mob)
        if not args[1] then args[1] = hit end
        table.insert(args[2], {mob, hit})
    end

    RE_Attack:FireServer(0)
    if HIT_FUNCTION then
        HIT_FUNCTION(unpack(args))
    end
end

_G.FastAttackToggle = true
RunService.Heartbeat:Connect(function()
    if _G.FastAttackToggle then
        pcall(function()
            FastAttack:Attack()
        end)
    end
end)
-- 🌐 Modern Countdown Teleport UI (Roblox Studio)
-- ✅ Dùng cho game của bạn (không phải game người khác)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local PLACE_ID = game.PlaceId
local countdownTime = 10 -- số giây đếm ngược

-- (Tuỳ chọn) Làm mờ nền nhẹ trong lúc hiển thị countdown
local blur = Instance.new("BlurEffect")
blur.Name = "CountdownBlur"
blur.Size = 0
blur.Parent = Lighting

-- ===== TẠO UI =====
local gui = Instance.new("ScreenGui")
gui.Name = "CountdownGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- Đổ bóng (drop shadow) phía sau thẻ
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Size = UDim2.new(0, 420, 0, 110)
shadow.Position = UDim2.new(0.5, 0, 0.78, 6) -- giữa màn hình và thấp hơn 1 chút
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.Parent = gui
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 16)

-- Thẻ chính (glassmorphism nhẹ)
local card = Instance.new("Frame")
card.Name = "Card"
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Size = UDim2.new(0, 420, 0, 110)
card.Position = UDim2.new(0.5, 0, 0.78, 0) -- 👈 ở giữa, “dưới dưới tí”
card.BackgroundColor3 = Color3.fromRGB(18, 22, 28)
card.BackgroundTransparency = 0.15
card.BorderSizePixel = 0
card.ZIndex = 2
card.Parent = gui

local corner = Instance.new("UICorner", card)
corner.CornerRadius = UDim.new(0, 16)

local stroke = Instance.new("UIStroke", card)
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Transparency = 0.5
stroke.Thickness = 1.4

local grad = Instance.new("UIGradient", card)
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 160, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 50, 70))
})
grad.Rotation = 12
grad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.15),
    NumberSequenceKeypoint.new(1, 0.15)
})

-- Icon refresh
local icon = Instance.new("ImageLabel")
icon.Name = "Icon"
icon.BackgroundTransparency = 1
icon.ZIndex = 3
icon.Image = "rbxassetid://6031280882" -- refresh icon
icon.ImageColor3 = Color3.fromRGB(0, 200, 255)
icon.Size = UDim2.new(0, 52, 0, 52)
icon.Position = UDim2.new(0, 18, 0.5, -26)
icon.Parent = card

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.ZIndex = 3
title.Size = UDim2.new(1, -100, 0, 48)
title.Position = UDim2.new(0, 90, 0, 8)
title.Font = Enum.Font.GothamBold
title.Text = "Đổi server"
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = card

-- Dòng phụ hiển thị đếm ngược (RichText để tô màu số giây)
local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.BackgroundTransparency = 1
subtitle.ZIndex = 3
subtitle.Size = UDim2.new(1, -100, 0, 40)
subtitle.Position = UDim2.new(0, 90, 0, 60)
subtitle.Font = Enum.Font.Gotham
subtitle.TextScaled = true
subtitle.TextColor3 = Color3.fromRGB(230, 235, 240)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.RichText = true
subtitle.Text = ""
subtitle.Parent = card

-- Thanh tiến trình
local barBG = Instance.new("Frame")
barBG.Name = "BarBG"
barBG.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
barBG.BackgroundTransparency = 0.85
barBG.BorderSizePixel = 0
barBG.ZIndex = 2
barBG.Size = UDim2.new(1, -28, 0, 6)
barBG.Position = UDim2.new(0, 14, 1, -18)
barBG.Parent = card
Instance.new("UICorner", barBG).CornerRadius = UDim.new(0, 6)

local barFill = Instance.new("Frame")
barFill.Name = "BarFill"
barFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
barFill.BorderSizePixel = 0
barFill.ZIndex = 3
barFill.Size = UDim2.new(0, 0, 1, 0) -- bắt đầu từ 0%
barFill.Parent = barBG
Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 6)

local barGrad = Instance.new("UIGradient", barFill)
barGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 140, 255))
})

-- ===== ANIMATION VÀ ĐẾM NGƯỢC =====
local function showCard()
    card.Position = UDim2.new(0.5, 0, 0.84, 0) -- trượt lên
    shadow.Position = UDim2.new(0.5, 0, 0.84, 6)
    TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.78, 0)
    }):Play()
    TweenService:Create(shadow, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.78, 6)
    }):Play()
    TweenService:Create(blur, TweenInfo.new(0.25), {Size = 8}):Play()
end

local function hideCard()
    TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, 0, 0.84, 0)
    }):Play()
    TweenService:Create(shadow, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, 0, 0.84, 6)
    }):Play()
    TweenService:Create(blur, TweenInfo.new(0.2), {Size = 0}):Play()
end

local function spinIcon()
    -- Icon xoay nhẹ trong quá trình đếm
    local rot = TweenService:Create(icon, TweenInfo.new(0.9, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, math.huge), {Rotation = icon.Rotation + 360})
    rot:Play()
end

local function countdownAndTeleport()
    showCard()
    spinIcon()

    for i = countdownTime, 1, -1 do
        -- Cập nhật text với RichText (tô màu số giây)
        subtitle.Text = string.format("<b>Sau:</b> <font color=\"rgb(0,200,255)\">%d</font> giây", i)

        -- Cập nhật progress bar (tiến dần 0% -> 100%)
        local progress = (countdownTime - (i - 1)) / countdownTime
        TweenService:Create(barFill, TweenInfo.new(0.85, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(progress, 0, 1, 0)
        }):Play()

        task.wait(1)
    end

    subtitle.Text = "Đang đổi server..."
    task.wait(0.3)
    hideCard()
    task.wait(0.1)
    TeleportService:Teleport(PLACE_ID, player)
end

-- Gọi ngay khi người chơi vào game
task.spawn(countdownAndTeleport)
