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

local StatusLabel

if not getgenv().Hide_UI then
    pcall(function()
        for _, v in pairs(CoreGui:GetChildren()) do
            if v:IsA("ScreenGui") and v.Name == "abcyohkh#%$>][][][]" then v:Destroy() end
        end
    end)

    local ScreenGui = utils.create("ScreenGui",{Name="abcyohkh#%$>][][][]",Parent=CoreGui,IgnoreGuiInset=true})
    local Frame = utils.create("Frame",{Parent=ScreenGui,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0)})
    local Banner = utils.create("Frame",{Parent=Frame,Position=UDim2.new(0.05,0,0.12,0),Size=UDim2.new(0,280,0,55),BackgroundColor3=Color3.fromRGB(0,0,0),BorderColor3=Color3.fromRGB(255,255,255),BorderSizePixel=2})
    local Logo = utils.create("ImageLabel",{Parent=Banner,Position=UDim2.new(0.04,0,0.5,0),AnchorPoint=Vector2.new(0,0.5),Size=UDim2.new(0,40,0,40),BackgroundTransparency=1,Image="rbxassetid://111223180842676"})
    StatusLabel = utils.create("TextLabel",{Parent=Banner,Position=UDim2.new(0.26,0,0.5,0),AnchorPoint=Vector2.new(0,0.5),Size=UDim2.new(0.7,0,0.7,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="No.1Hub",TextColor3=Color3.fromRGB(255,255,255),TextScaled=true})
    local Timer = utils.create("TextLabel",{Parent=Frame,Position=UDim2.new(0.055,0,0.195,0),Size=UDim2.new(0,280,0,25),BackgroundTransparency=1,Font=Enum.Font.FredokaOne,TextColor3=Color3.fromRGB(180,180,180),TextScaled=true})
    local t = tick()
    RunService.Heartbeat:Connect(function()
        local e = tick() - t
        Timer.Text = string.format("%d Hours %d Minutes %d Seconds",math.floor(e / 3600),math.floor((e % 3600) / 60),math.floor(e % 60))
    end)
end

local function updateStatus(m,c)
    if StatusLabel then
        StatusLabel.Text = m
        StatusLabel.TextColor3 = c or Color3.fromRGB(255,255,255)
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
