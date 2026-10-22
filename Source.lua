--local LPH_OBFUSCATED = false 
local IsStudio = false 

if not LPH_OBFUSCATED then
    LPH_NO_VIRTUALIZE = function(...)
        return ...
    end
    
    LPH_JIT_MAX = function(...)
        return ...
    end

    LPH_JIT = function(...)
        return ...
    end

    LPH_CRASH = function(...)
        return ...
    end

    JD_IS_PREMIUM = true 
    JD_EXPIRES_AT = 999999999
end

if IsStudio then
    cloneref = function(f)
        return f 
    end

    gethui = function()
        return script.Parent 
    end
end

local GlowImage2 = "rbxassetid://95194409279070"

LPH_JIT_MAX(function() 
    if getconnections then
        local Remote = cloneref(game:GetService("ReplicatedStorage").Remotes.Overwatch)
        for Index, Value in getconnections(Remote.OnClientEvent) do
            Value:Disable()
        end
    end
end)()

local DataModel = game 
local GarbageCollection = getgc 

local GetService = function(Name)
    return cloneref(DataModel:GetService(Name))
end

local Start = tick();

local ChangeHistoryService = GetService("ChangeHistoryService")
local HttpService = GetService("HttpService")
local Players = GetService("Players")
local TextService = GetService("TextService")
local Workspace = GetService("Workspace")
local ReplicatedStorage = GetService("ReplicatedStorage")
local ReplicatedFirst = GetService("ReplicatedFirst")
local Lighting = GetService("Lighting")
local RunService = GetService("RunService")
local TweenService = GetService("TweenService")
local TeleportService = GetService("TeleportService")
local UserInputService = GetService("UserInputService")
local Stats = GetService("Stats")
local ProximityPromptService = GetService("ProximityPromptService")
local SoundService = GetService("SoundService")

local Client = Players.LocalPlayer 
local Camera = Workspace.CurrentCamera 
local Infinity = math.huge 

if not Client.Character then
    repeat task.wait()

    until Client.Character
end

local ZenithFolder = Instance.new("Folder", Workspace )

local IgnoreList = {
    Client.Character, Camera, Workspace.NoCollision,
    ZenithFolder
}

local Vectors = {
    Vector3.new( 1,  1,  0), Vector3.new( 1, -1,  0),
    Vector3.new(-1,  1,  0), Vector3.new(-1, -1,  0), 
    Vector3.new( 1,  0,  1), Vector3.new( 1,  0, -1),
    Vector3.new(-1,  0,  1), Vector3.new(-1,  0, -1),
    Vector3.new( 0,  1,  1), Vector3.new( 0,  1, -1),
    Vector3.new( 0, -1,  1), Vector3.new( 0, -1, -1),
}


local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Exclude;
RayParams.IgnoreWater = true 
RayParams.FilterDescendantsInstances = IgnoreList

local HitEvent = Instance.new("BindableEvent", ZenithFolder)
local TracerEvent = Instance.new("BindableEvent", ZenithFolder)

local Player = {}

local Visuals = {}

local Hooks = {}

local Connections = {}

local BaseEntity = {}

local MiscEntity = {}

local Math = {}

local Utils = {}

local Game = {}

local Threads = {}

local Garbage = {}

local Assets = {}

Assets.Hitsounds = {
    ["TF2"] = "rbxassetid://8255306220",
    ["Stapler"] = "rbxassetid://108157571955794",
    ["Skeet"] = "rbxassetid://4817809188",
    ["Rust"]      = "rbxassetid://1255040462",
    ["Neverlose"] = "rbxassetid://8726881116",
    ["Bubble"]    = "rbxassetid://198598793",
    ["Ding"]      = "rbxassetid://2868331684"
}

Assets.ItemIcons = {}

local Library = loadstring(DataModel:HttpGet("https://raw.githubusercontent.com/kyoukidevs/zenith.fixed/refs/heads/main/Library.lua"))()
local flags = Library.Flags 

for Index, Value in Library.Folders do
    makefolder(Value)
end
BaseEntity.Functions = {}
BaseEntity.Cache = {}

BaseEntity.LastUpdate = tick();

MiscEntity.Functions = {}
MiscEntity.Cache = {}

-- // Metatables Init 
BaseEntity.Functions.__index = BaseEntity.Functions 
MiscEntity.Functions.__index = MiscEntity.Functions 
Hooks.__index = Hooks 
Connections.__index = Connections 

-- // Font 
setreadonly(Font, false)

Font.Register = function(self, Name, Weight, Style, Data)
    if not isfile(Library.Folders.Assets.."/"..Data.Id) then
        writefile(Library.Folders.Assets.."/"..Data.Id, DataModel:HttpGet(Data.Url))
    end

    local data = {
        name = Name,
        faces = {{
            name = "Regular",
            weight = Weight,
            style= Style,
            assetId = getcustomasset(Library.Folders.Assets.."/"..Data.Id)
        }}
    }

    writefile(Library.Folders.Assets.."/"..Name..".font", HttpService:JSONEncode(data))

    return Font.new(getcustomasset(Library.Folders.Assets.."/"..Name..".font"), Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end

setreadonly(Font, true)

BaseEntity.SmallFont = Font:Register("smallest_pixel7", 400, "normal", {Id = "smallest-pixel7.ttf", Url = "https://github.com/britzl/gbrausers/blob/master/assets/font/smallest_pixel-7.ttf?raw=true"})

Assets.Fonts = {}

Assets.Fonts["Inter"] = Library.BoldFont
Assets.Fonts["Minecraft"] = Font:Register("minecraft", 400, "normal", {Id = "minecraft.ttf", Url = "https://github.com/kyoukidevs/zenith/blob/main/Minecraft.ttf?raw=true"})
Assets.Fonts["Proggy"] = Font:Register("proggy_clean", 400, "normal", {Id = "proggy-clean.ttf", Url = "https://github.com/bluescan/proggyfonts/raw/refs/heads/master/ProggyOriginal/ProggyClean.ttf"})
Assets.Fonts["Verdana"] = Font:Register("verdana", 700, "normal", {Id = "verdana.ttf", Url = "https://github.com/kyoukidevs/zenith/blob/main/verdana.ttf?raw=true"})

MiscEntity.Font = Assets.Fonts["Inter"]
BaseEntity.Font = Assets.Fonts["Inter"]

--#region Global Functions

Utils.Instance = LPH_NO_VIRTUALIZE(function(self, Class, Properties)
    local New = Instance.new(Class)

    for Name, Value in Properties do
        New[Name] = Value 
    end

    return New 
end)

Connections.Connect = LPH_NO_VIRTUALIZE(function(self, Signal, Callback)
    local RealConn = Signal:Connect(Callback)
    local Connection = setmetatable({
        Connection = RealConn
    }, Connections)
    
    Connections[#Connections+1] = Connection 

    return Connection 
end)

Connections.Disconnect = LPH_NO_VIRTUALIZE(function(self)
    self.Connection:Disconnect()
    self = nil     
end)

Connections.Disable = LPH_NO_VIRTUALIZE(function(self)
    self.Connection:Disable()
    self.Active = false 
end)

Connections.Enable = LPH_NO_VIRTUALIZE(function(self)
    self.Connection:Enable()
    self.Active = true 
end)

if not IsStudio then
    -- // Hooks 

    Hooks.Cache = {};

    Hooks.Create = LPH_NO_VIRTUALIZE(function(self, Function, NewFunction)
        local Hook = setmetatable({
            Hooked = false,
            Original = Function,
            Replaced = NewFunction 
        }, Hooks)

        self.Cache[Function] = Hook 

        return Hook 
    end)

    Hooks.Hook = LPH_NO_VIRTUALIZE(function(self)
        if self.Hooked then return end 

        local og = self.Original 
        local old; old = hookfunction(og, function(...)
            return self.Replaced(old, ...)
        end)

        self.Hooked = true 
        self.Old = old 

        return old 
    end)

    Hooks.Unhook = LPH_NO_VIRTUALIZE(function(self)
        if not self.Hooked then return end 

        hookfunction(self.Original, self.Old) 
        self.Hooked = false 
    end)
end

-- // Math
Math.__index = Math 

Math.Lerp = function(self, a, b, t)
    return a + (b - a) * t 
end

Math.FloorVector = function(self, Vector)
    if typeof(Vector) == "Vector2" then
        return Vector2.new(math.floor(Vector.X), math.floor(Vector.Y))
    else
        return Vector3.new(math.floor(Vector.X), math.floor(Vector.Y), math.floor(Vector.Z))
    end
end

Math.GetDistance = function(self, Position1, Position2)
    return (Position1 - Position2).Magnitude 
end

Math.To2D = function(self, Vector)
    return Vector.X, Vector.Y
end

-- // Threads

Threads.New = function(self, Cooldown, Function)
    while true do
        task.wait(Cooldown)

        pcall(Function)
    end
end

--#endregion

--#region Utils

-- // Utils 

Utils.__index = Utils 

Utils.Tween = LPH_NO_VIRTUALIZE(function(self, ...)
    local Tween = TweenService:Create(...)
    
    Tween:Play()

    return Tween 
end)

Utils.GetItemIcon = LPH_NO_VIRTUALIZE(function(self, Name)
    local Temp = Game.Items:FindFirstChild(Name)

    if Temp then
        local Image = Temp.ItemProperties.ItemIcon.Image 

        return Image 
    end
end)


Utils.Pitch = LPH_NO_VIRTUALIZE(function(self, Pitch)
    if not Client.Character then
        return 
    end

    if not Pitch then
        Pitch = 0.7
    end

    if Pitch < 0 then
        Pitch = math.abs(Pitch)
    elseif Pitch == 0 then
        Pitch = 0
    else
        Pitch = -Pitch 
    end

    Pitch *= 80 

    local Waist = Client.Character.UpperTorso:FindFirstChild("Waist")
    local Neck = Client.Character.Head:FindFirstChild("Neck")

    if Waist and Neck then
        Waist.C1 = CFrame.Angles(math.rad(Pitch), 0, 0) + Vector3.new(0, -0.5, 0)
        Waist.C1 = CFrame.Angles(math.rad(Pitch), 0, 0) + Vector3.new(0, -0.5, 0)
    end
end)

Utils.IsVisible = LPH_NO_VIRTUALIZE(function(self, Destination, Origin)
    if not Origin then Origin = Camera.CFrame.p end 

    if typeof(Destination) ~= "Instance" then
        return false 
    end

    local Raycast = Workspace:Raycast(Origin, (Destination.Position - Origin).Unit * 10000, RayParams)

    return Raycast and Raycast.Instance and Raycast.Instance:IsDescendantOf(Destination.Parent)
end)

Utils.IsPositionVisible = LPH_NO_VIRTUALIZE(function(self, Destination, Origin)
    if not Origin then Origin = Camera.CFrame.p end 

    if typeof(Destination) ~= "Vector3" then
        Destination = Destination.CFrame.p 
    end

    local Direction = (Destination - Origin)

    local Raycast = Workspace:Raycast(Origin, Direction.Unit * Direction.Magnitude, RayParams)

    return not Raycast 
end)

Utils.GetManipulatedPosition = LPH_NO_VIRTUALIZE(function(self, Destination, Origin)
    if not Origin then
        Origin = Camera.CFrame.p 
    end

    local Distance = 5 -- // Studs

    for _, Vector in Vectors do
        local NewOrigin = Origin + Vector * Distance  
        if self:IsPositionVisible(NewOrigin, Origin) and self:IsVisible(Destination, NewOrigin) then
            return NewOrigin
        end
    end

    return nil
end)

Garbage.OriginalC0 = {};

Utils.UpdateViewmodel = LPH_NO_VIRTUALIZE(function(self, Viewmodel)
    if not Viewmodel then
        Viewmodel = Player.Viewmodel.Instance
    end

    if flags["Custom Viewmodel"] then do
        
        local Item = Viewmodel:FindFirstChild("Item");

        if Item then
            for _, Value in Item:GetDescendants() do
                if Value:IsA("BasePart") and Value:GetAttribute("OriginalTransparency") ~= 1 then
                    Value.Material = flags["Gun Material"];
                    Value.Transparency = flags["VM Transparency"] / 100 
                    Value.Color = flags["Gun Color"]
                end

                local Temp = Value:FindFirstChildOfClass("SurfaceAppearance")
                if Temp then Temp:Destroy() end 
            end
        end end 

        do
            for _, Item in Viewmodel:GetChildren() do
                if Item:IsA("MeshPart") then
                    if string.find(string.lower(Item.Name), "hand") or string.find(string.lower(Item.Name), "arm") then
                        Item.Material = flags["Arms Material"]
                        Item.Transparency = flags["VM Transparency"] / 100 
                        Item.Color = flags["Arms Color"]
                    end 
                end 

                if Item.ClassName == 'Model' and (Item:FindFirstChild("LL") or Item:FindFirstChild("LH")) then
                    for _, Clothing in Item:GetChildren() do
                        local Temp = Clothing:FindFirstChildOfClass("SurfaceAppearance") 

                        if Temp then
                            Temp:Destroy()
                        end

                        Clothing.Material = flags["Arms Material"]
                        Clothing.Transparency = flags["VM Transparency"] / 100 
                        Clothing.Color = flags["Arms Color"]
                    end
                end
            end
        end
    end

    if flags["Viewmodel Position"] then
        local Root = Viewmodel:FindFirstChild("HumanoidRootPart");

        if not Root then
            return 
        end

        local Vector = Vector3.new(flags["Viewmodel X"], flags["Viewmodel Y"], flags["Viewmodel Z"])

        for _, Motor in Root:GetChildren() do
            if Motor.ClassName == 'Motor6D' then
                if not Garbage.OriginalC0[Motor] then
                    Garbage.OriginalC0[Motor] = Motor.C0 
                end
                Motor.C0 = Garbage.OriginalC0[Motor] + Vector 
            end
        end
    end
end)

Utils.PlayHitsound = LPH_NO_VIRTUALIZE(function(self, IsHeadshot)
    local Flag = IsHeadshot and flags["Headshot Sound"] or flags["Bodyshot Sound"]
    
    local Sound = Utils:Instance("Sound", {
        Parent = SoundService,
        Looped = false,
        SoundId = Assets.Hitsounds[Flag],
        Volume = flags["Hitsounds Volume"]
    })

    Sound:Play()
    
    task.delay(2, function()
        Sound:Destroy()
    end)
end)

Utils.WorldToScreen = LPH_NO_VIRTUALIZE(function(self, Position)
    return Camera:WorldToScreenPoint(Position)
end)

Utils.WorldToViewport = LPH_NO_VIRTUALIZE(function(self, Position)
    return Camera:WorldToViewportPoint(Position)
end)

local Center2D = Camera.ViewportSize / 2

Utils.GetDistanceFromCenter = LPH_NO_VIRTUALIZE(function(self, Destination)
    if typeof(Destination) ~= "Vector3" then
        Destination = Destination.CFrame.p 
    end

    local ScreenPos, OnScreen = self:WorldToViewport(Destination)

    if ScreenPos and OnScreen then
        return Math:GetDistance(Vector2.new(Center2D.X, Center2D.Y), Vector2.new(ScreenPos.X, ScreenPos.Y))
    end

    return 9e9 
end)

Utils.CreateContainer = LPH_NO_VIRTUALIZE(function(self, Name)
    return Utils:Instance("ScreenGui", {
        Name = Name,
        Parent = cloneref(gethui()),
        IgnoreGuiInset = true 
    })
end)


--#endregion

--#region Visuals

Visuals.DrawLine = LPH_NO_VIRTUALIZE(function(self)
    local Line = Drawing.new("Line")
    Line.Visible = false 
    Line.Thickness = 1
    Line.Color = Color3.fromRGB(255,255,255)
    Line.ZIndex = 2

    local Outline = Drawing.new("Line")
    Outline.Visible = false 
    Outline.Color = Color3.fromRGB(0,0,0)
    Outline.Thickness = 3
    Outline.ZIndex = 1

    return Line, Outline 
end)

-- // Visuals 
Visuals.ESPSpace = Utils:CreateContainer("ESPSpace") -- // ESP Rendering
Visuals.FOVSpace = Utils:CreateContainer("FOVSpace") -- // Everything On Screen

Visuals.FOVCircle = Utils:Instance("Frame",{
    Parent = Visuals.FOVSpace,
    BackgroundTransparency = 1,
    ZIndex = 9e9,
    BackgroundColor3 = Color3.new(1,1,1),
    Size = UDim2.new(0,200,0,200),
    Visible = false,
    AnchorPoint = Vector2.new(0.5,0.5),
    Position = UDim2.new(0,Center2D.X, 0, Center2D.Y)
})

Utils:Instance("UICorner", {
    Parent = Visuals.FOVCircle,
    CornerRadius = UDim.new(1,0)
})

Visuals.FOVStroke = Utils:Instance("UIStroke", {
    Parent = Visuals.FOVCircle,
    Thickness = 3,
    Color = Color3.new(1,1,1)
}) 

Visuals.FOVGradient = Utils:Instance("UIGradient", {
    Parent = Visuals.FOVStroke,
    Enabled = true 
})

Visuals.Snapline, Visuals.SnaplineOutline = Visuals:DrawLine()

Visuals.Snapline.From = Vector2.new(Center2D.X, Center2D.Y)
Visuals.SnaplineOutline.From = Visuals.Snapline.From

Visuals.CrosshairContainer = Utils:Instance("Frame", {
    Parent = Visuals.FOVSpace,
    Size = UDim2.new(),
    Position = UDim2.new(0, Center2D.X, 0, Center2D.Y),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 2
})

Visuals.CrosshairTop = Utils:Instance("Frame", {
    Parent = Visuals.CrosshairContainer,
    Size = UDim2.new(0,1,0,10), AnchorPoint = Vector2.new(0.5, 1),
    BackgroundColor3 = Color3.new(),
    ZIndex = 3
})

Visuals.CrosshairBottom = Utils:Instance("Frame", {
    Parent = Visuals.CrosshairContainer,
    Size = UDim2.new(0,1,0,10),
    AnchorPoint= Vector2.new(0.5, 0),
    ZIndex = 3,
    BackgroundColor3 = Color3.new()
})

Visuals.CrosshairLeft = Utils:Instance("Frame", {
    Parent = Visuals.CrosshairContainer,
    Size = UDim2.new(0,10,0,1),
    AnchorPoint = Vector2.new(1, 0.5),
    BackgroundColor3 = Color3.new(),
    ZIndex = 3
})

Visuals.CrosshairRight = Utils:Instance("Frame", {
    Parent = Visuals.CrosshairContainer,
    Size = UDim2.new(0,10,0,1),
    AnchorPoint = Vector2.new(0, 0.5),
    BackgroundColor3 = Color3.new(),
    ZIndex = 3
})

Visuals.UpdateInventory = LPH_NO_VIRTUALIZE(function(self, Inventory)
    local Bounds = 0
    local Text = "[Inventory]: \n"
    local EmptySpace = "      "
    
    Bounds += 14 

    for Index, Clothing in Inventory:GetChildren() do
        local Temp = Clothing:FindFirstChild("Inventory")

        if Temp then 
            Text = Text..EmptySpace.."["..Clothing.Name.."]: \n"
            Bounds += 14
            
            for Index, Value in Temp:GetChildren() do
                local Amount = Value:GetAttribute("Amount")
                Text = Text..EmptySpace..EmptySpace..Value.Name

                if Amount then
                    Text = Text.. " x"..Amount .."\n"
                else
                    Text = Text.."\n"
                end
            end
        end
    end

    Library.InventoryViewer:Set(Text)
end)

--[[

Visuals.ProjectSkeletonLine = LPH_NO_VIRTUALIZE(function(self, BodyPart, Offset)
    Offset = Offset or Vector3.zero 

    local Line, Outline = self:DrawLine();

    local Position = BodyPart.Position + Offset

    local ScreenPos = Utils:WorldToViewport(Position)

    return Math:FloorVector(Vector2.new(ScreenPos.X, ScreenPos.Y))
end)

Visuals.UpdateSkeletonLine = LPH_NO_VIRTUALIZE(function(self, Index, From, To, Color)
    local Line = self.Drawings.Lines[Index];

    if Line then
        Line.Visible = true 
        Line.From = From 
        Line.To = To 
        Line.Color = Color 
    end

    local Outline = self.Drawings.Lines[Index + 8];

    if Outline then
        Outline.Visible = true 
        Outline.From = From 
        Outline.To = To 
    end
end)

Visuals.HideSkeleton = LPH_NO_VIRTUALIZE(function(self)
    for Index, Value in self.Drawings.Lines do
        Value.Visible = false 
    end
end)
]]
--#endregion

--#region BaseEntity

-- // BaseEntity

BaseEntity.Flags = {};

BaseEntity.NewFlag = function(self, Data)
    local Flag = {
        Flag = Data.Flag,
        CustomName = Data.CustomName,
        Name = Data.Name ,
        Allow = Data.Allow 
    }

    self.Flags[Flag.Name] = Flag 
end

BaseEntity.ChangeFont = function(self, Name)
    BaseEntity.Font = Assets.Fonts[Name]

    for Index, Value in self.Cache do
        local Drawings = Value.Drawings 

        if Drawings then
            for Index, Value in Drawings do
                if typeof(Value) == "Instance" and Value:IsA("TextLabel") then
                    Value.FontFace = Assets.Fonts[Name]
                end
            end
        end
    end
end

-- // Get BaseEntity Data For Caching

BaseEntity.Functions.GetCharacter = LPH_NO_VIRTUALIZE(function(self)
    if not self.AI then
        return self.Instance.Character 
    else
        return self.Instance 
    end

    return nil 
end)

BaseEntity.Functions.GetRoot = LPH_NO_VIRTUALIZE(function(self)
    local Humanoid = self.Data.Character and self.Data.Character:FindFirstChildOfClass("Humanoid")

    self.Data.Humanoid = Humanoid 

    return Humanoid and Humanoid.RootPart 
end)

BaseEntity.Functions.GetHP = LPH_NO_VIRTUALIZE(function(self)
    if self.Data.Humanoid then
        return self.Data.Humanoid.Health, self.Data.Humanoid.MaxHealth 
    end
end)

BaseEntity.Functions.GetItem = LPH_NO_VIRTUALIZE(function(self)
    if self.Data.Character then
        if not self.AI and self.Folder then

            local Status = self.Folder:FindFirstChild("Status")

            if not Status then
                return nil 
            end

            local Vars = Status.GameplayVariables

            if Vars.EquippedTool and Vars.EquippedTool.Value then
                return Vars.EquippedTool.Value.Name 
            end
        elseif self.AI then 
            local Inventory = self.Instance:FindFirstChild("Inventory")

            if Inventory then
                local Tool = Inventory:FindFirstChildOfClass("StringValue")  

                return Tool and Tool.Value 
            end
        end
    end

    return nil 
end)

--[[BaseEntity.Functions.UpdateStats = LPH_NO_VIRTUALIZE(function(self)
    if not self.AI and self.Folder then
        local KD, Hours = 0, 0

        local Status = self.Folder:FindFirstChild("Status")

        if not Status then return end 

        local Journey = Status:FindFirstChild("Journey")

        if not Journey then return end 

        local Statistics = Journey.Statistics

        local Kills = Stats:GetAttribute("Kills")
        local Deaths = Stats:GetAttribute("Deaths")
        local Seconds = Stats:GetAttribute("TimePlayed")
        
        KD = math.floor(Kills / Deaths) / 10 
        Hours = math.floor(Seconds / 3600) / 10

        self.Data.KD = KD 
        self.Data.Hours = Hours 
    end
end)]]

-- // Calculate Box Size + Get Some Visibility Information 
BaseEntity.Functions.CalculateBox = LPH_NO_VIRTUALIZE(function(self)
    local Data = {};

    local Character = self.Data.Character;
    local Root = self.Data.Root; 

    if not Root then
        return {
            OnScreen = false,
            ScreenPos = nil 
        }
    end

    local ScreenPos, OnScreen = Utils:WorldToViewport(Root.Position)

    if not OnScreen then
        return {
            OnScreen = false 
        }
    end

    local Size, Position, Center

    if flags["Sizing Type"] == "Static" then 
        local Width = flags["Box Width"]
        local Height = flags["Box Height"]

        local ScaleFactor = 1 / (ScreenPos.Z * math.tan(math.rad(Camera.FieldOfView / 2)) * 2) * 1000
        Width *= ScaleFactor
        Height *= ScaleFactor

        local MinWidth, MaxHeight = 0,6

        --[[if flags["Box Style"] == "Corner" then
            MinWidth = 4
        end]]

        Size = Math:FloorVector(Vector2.new(math.max(Width, MinWidth), math.max(MaxHeight, Height)))
        Position = Math:FloorVector(Vector2.new(ScreenPos.X - Width / 2, (ScreenPos.Y - Height / 2) + 3))
        Center = Vector2.new((Size.X + Position.X) / 2, (Size.Y + Position.Y) / 2)
    else
        local CFPosition, CFSize = Character:GetBoundingBox()

        if not (CFPosition and CFSize) then
            return {
                OnScreen = false
            }
        end

        local Center = CFPosition.p
        local HalfSize = CFSize / 2 

        local TopLeft = Utils:WorldToViewport(Center - CFSize / 2)
        local BotRight = Utils:WorldToViewport(Center + CFSize / 2)

        local Width = math.abs(BotRight.X - TopLeft.X)
        local Height = math.abs(BotRight.Y - TopLeft.Y)

        local MinWidth, MaxHeight = 0, 6

        if flags["Box Style"] == "Corner" then
            MinWidth = 4    
        end

        Size = Math:FloorVector(Vector2.new(math.max(Width, MinWidth), math.max(Height, MaxHeight)))
        Position = Math:FloorVector(Vector2.new(ScreenPos.X - Width / 2, (ScreenPos.Y - Height / 2) + 3))
        Center = Vector2.new((Size.X + Position.X) / 2, (Size.Y + Position.Y) / 2)
    end

    --[[if flags["Head Dot"] then 
        local HeadSize, HeadPosition
        local Head = Character.Head 
        local CFPosition, CFSize = Head.CFrame, Head.Size
        local Center = Head.Position

        local HeadScreenPos = Utils:WorldToViewport(Center)

        local TopLeft = Utils:WorldToViewport(Center - CFSize / 2)
        local BotRight = Utils:WorldToViewport(Center + CFSize / 2)

        local HeadWidth = math.abs(BotRight.X - TopLeft.X )
        local HeadHeight = math.abs(BotRight.Y - TopLeft.Y)

        local HeadMinWidth = 1

        HeadSize = Math:FloorVector(Vector2.new(math.max(HeadWidth, HeadMinWidth), HeadHeight))
        HeadPosition = Math:FloorVector(Vector2.new(HeadScreenPos.X, HeadScreenPos.Y))
        
        Data.HeadSize = HeadSize 
        Data.HeadPos = HeadPosition 
    end]]

    Data.Visible = Utils:IsVisible(Character.Head)
    Data.Size = Size 
    Data.Position = Position 
    Data.Center = Center 
    Data.OnScreen = OnScreen
    Data.ScreenPos = ScreenPos

    return Data 
end)

BaseEntity.FlagProperties = {
    BackgroundTransparency = 1,
    FontFace = BaseEntity.SmallFont,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextSize = 9,
    TextColor3 = Color3.new(1,1,1),
    ClipsDescendants = false,
    Size = UDim2.new(1, 0, 0, 7)
}

BaseEntity.Functions.Update = LPH_NO_VIRTUALIZE(function(self)
    self.Data.Character = self:GetCharacter()
    self.Data.Root = self:GetRoot()
    self.Data.Item = self:GetItem()

    local Data = self:CalculateBox()

    local Drawings = self.Drawings 

    local Hide = function()
        Drawings.Core.Visible = false 
    end

    if not (self.Data.Root and self.Data.Character and Data) then
        Hide()
        return 
    end

    self.Data.Distance = Math:GetDistance(Camera.CFrame.p, self.Data.Root.Position)

    self.Status.OnScreen = Data.OnScreen
    self.Status.Visible = Data.Visible 
    self.Data.ScreenPos = Data.ScreenPos 

    local HP, MaxHP = self:GetHP()
    self.Data.Health = HP 

    self.Status.Alive = self.Data.Health > 0.1

    local Color = flags["Dynamic Colors"] and (self.Status.Visible and flags["Visible Color"] or flags["Accent Color"])

    if Color and BaseEntity.Target and BaseEntity.Target == self.Instance then
        Color = flags["Target Color"]
    end

    local Transparency = self.Status.Alive and 0 or 1 
    local BottomBounds = 6

    if (self.AI and flags["AI ESP"]) or (not self.AI and flags["Player ESP"]) and self.Status.Alive then
        if self.Status.OnScreen then

            if flags["Chams"] then
                Drawings.Chams.Enabled = true 
                Drawings.Chams.Adornee = self.Data.Character
                Drawings.Chams.DepthMode = flags["Chams Only Visible"] and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop

                Drawings.Chams.FillColor = flags["Chams Color"]
                Drawings.Chams.OutlineColor = flags["Chams Color"]

                local Breath = math.atan(math.sin(tick() * 2)) * 2 / math.pi 
                Drawings.Chams.FillTransparency = flags["Chams Transparency"] * Breath / 100
                Drawings.Chams.OutlineTransparency = flags["Chams Transparency"] * Breath / 100 
            end

            -- // Setup Size & Position 
            Drawings.Core.Position = UDim2.new(0, Data.Position.X, 0, Data.Position.Y)
            Drawings.Core.Size = UDim2.new(0, Data.Size.X, 0, Data.Size.Y)
            Drawings.Core.Visible = true 

            -- // Boxes
            Drawings.Box.Visible = flags["Box"]-- and flags["Box Style"] == "Full"
            Drawings.OutlineStroke.Enabled = Drawings.Box.Visible
            Drawings.BoxStroke.Color = Color and Drawings.BoxStroke.Color:Lerp(Color, 0.1) or flags["Box Color"]
            Drawings.BoxStroke.Transparency = Transparency
            Drawings.OutlineStroke.Transparency = Transparency

            Drawings.Glow.Visible = flags["Box"] and flags["Box Glow"]

            -- // Nametag Text
            if flags["Nametag"] then
                Drawings.Nametag.Visible = true 
                Drawings.Nametag.Text = self.Instance.Name 
                Drawings.Nametag.TextColor3 = Color and Drawings.Nametag.TextColor3:Lerp(Color, 0.1) or flags["Nametag Color"]
                Drawings.Nametag.TextTransparency = Transparency 
            else
                Drawings.Nametag.Visible = false 
            end

            -- // Held Item Text
            if flags["Item"] and self.Data.Item then
                Drawings.Item.Visible = true 
                Drawings.Item.Text = self.Data.Item 
                Drawings.Item.TextColor3 = Color and Drawings.Item.TextColor3:Lerp(Color, 0.1) or flags["Item Color"]
                Drawings.Item.TextTransparency = Transparency
                Drawings.Item.Position = UDim2.new(0,0,1,BottomBounds)
                BottomBounds += 11
            else
                Drawings.Item.Visible = false 
            end

            -- // Distance Text
            if flags["Distance"] then
                Drawings.Distance.Visible = true 
                Drawings.Distance.Text = math.floor(self.Data.Distance / 3).."m"
                Drawings.Distance.TextColor3 = Color and Drawings.Distance.TextColor3:Lerp(Color, 0.1) or flags["Distance Color"]
                Drawings.Distance.TextTransparency = Transparency
                Drawings.Distance.Position = UDim2.new(0.25,0,1,BottomBounds)
                BottomBounds += 11
            else
                Drawings.Distance.Visible = false 
            end

            --[[if flags["Item Image"] and self.Data.Item then
                Drawings.ItemImage.Visible = true 
                Drawings.ItemImage.Image = Assets.ItemIcons[self.Data.Item]
                Drawings.ItemImage.Position = Drawings.ItemImage.Position:Lerp(UDim2.new(0,0,1,BottomBounds), 0.1)
                BottomBounds += 52
            else
                Drawings.ItemImage.Visible = false 
            end]]

            -- // Health bar
            if flags["HP Bar"] then
                local Percent = HP/MaxHP
                local Color = flags["Low HP Color"]:Lerp(flags["High HP Color"], Percent)

                Drawings.Healthbar.Visible = true 
                Drawings.Healthbar.BackgroundTransparency = Transparency 
                Drawings.HealthbarFill.BackgroundTransparency =Transparency
                Drawings.HealthbarFill.Size = Drawings.HealthbarFill.Size:Lerp(UDim2.new(1,0,Percent, 0), 0.1)
                Drawings.HealthbarFill.BackgroundColor3 = Color 
            else
                Drawings.Healthbar.Visible = false 
            end

            --[[if flags["Head Dot"] and Data.HeadSize then
                Drawings.Dot.Visible = true 
                Drawings.Dot.Size = UDim2.new(0, Data.HeadSize.X, 0, Data.HeadSize.Y)
                Drawings.Dot.BackgroundColor3 = flags["Head Dot Color"]
                Drawings.Dot.Position = UDim2.new(0, Data.HeadPos.X, 0, Data.HeadPos.Y)
            else
                Drawings.Dot.Visible = false 
            end]]

            -- // Flags
            for Name, Data in BaseEntity.Flags do
                if flags["Custom Flags"] and table.find(flags["Custom Flags"], Data.Flag) then
                    local Drawing = Drawings.Flags[Name]
                    local RealName = Data.Name

                    if Data.CustomName then
                        RealName = Data.CustomName(self)  
                    end

                    if not Drawing then
                        Drawing = Utils:Instance("TextLabel",BaseEntity.FlagProperties)

                        Drawing.Parent = Drawings.FlagContainer

                        Drawings.Flags[Name] = Drawing 
                    end

                    local CanShow = Data.Allow(self)

                    Drawing.Visible = CanShow 
                    Drawing.Text = RealName
                    Drawing.TextColor3 = flags[Data.Flag.." Flag Color"]
                else
                    Drawings.Flags[Name].Visible = false
                end
            end
        else
            -- // OOF Arrows Space
            Hide()
        end
    else
        Hide()
    end
end)

-- // Cache BaseEntity's Metatable
BaseEntity.Create = LPH_NO_VIRTUALIZE(function(self, Object : Instance)
    local Drawings = {};

    local TextStroke = function(Text, Thickness)
        local stroke = Utils:Instance("UIStroke", {
            Parent = Text,
            Thickness = Thickness,
            Color = Color3.new()
        })

        return stroke 
    end

    Drawings.Core = Utils:Instance("Frame", {
        Parent = Visuals.ESPSpace,
        Name = Object.Name.."'s Drawings",
        BackgroundTransparency = 1,
        Visible = false -- // Master toggle for all ESP drawings
    })

    Drawings.Box = Utils:Instance("Frame", {
        Parent = Drawings.Core,
        Size = UDim2.new(1,2,1,2),
        Position = UDim2.new(0,-1,0,-1),
        BackgroundTransparency = 1,
        Visible = false 
    })

    Drawings.Glow = Utils:Instance("ImageLabel", {
        Parent = Drawings.Box,
        Size = UDim2.new(1,0,1,0),
        Image = GlowImage2,
        BackgroundTransparency = 1,
        ImageColor3 = Color3.new(1,1,1),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Stretch
    })

    Drawings.BoxStroke = Utils:Instance("UIStroke", {
        Parent = Drawings.Box,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Thickness = 1,
        Enabled = true,
        ZIndex = 2,
        Color = Color3.new(1,1,1)
    })

    -- // Box outline, without outlines any object seems ugly
    Drawings.OutlineStroke = Utils:Instance("UIStroke", {
        Parent = Drawings.Core,
        ZIndex = 1,
        Thickness = 3, -- // Box Thickness + Box Thickness * 2, To Outline It For -X & +X
        Color = Color3.new(), -- // Black Outline Color 
        LineJoinMode = Enum.LineJoinMode.Miter
    })

    -- // Text

    -- // Nametag
    Drawings.Nametag = Utils:Instance("TextLabel", {
        Parent = Drawings.Core,
        FontFace = BaseEntity.Font,
        TextSize = 12,
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1,1,1),
        Size = UDim2.new(1,0,0,12),
        Position = UDim2.new(0,0,0,-16),
        Visible = false 
    })

    -- // Distance
    Drawings.Distance = Utils:Instance("TextLabel", {
        Parent = Drawings.Core,
        FontFace = BaseEntity.Font,
        TextSize = 12, 
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1,1,1),
        Size = UDim2.new(0.8,0,0,12),
        Position = UDim2.new(0.1,0,1,2),
        Visible = false 
    })

    -- // Item
    Drawings.Item = Utils:Instance("TextLabel", {
        Parent = Drawings.Core,
        FontFace = BaseEntity.Font,
        TextSize = 12,
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1,1,1),
        Size = UDim2.new(1,0,0,12),
        Position = UDim2.new(0,0,1,12),
        Visible = false 
    })

    -- // Outlines
    Drawings.NametagStroke = TextStroke(Drawings.Nametag, 1)
    Drawings.DistanceStroke = TextStroke(Drawings.Distance, 1)
    Drawings.ItemStroke = TextStroke(Drawings.Item, 1)

    Drawings.ItemImage = Utils:Instance("ImageLabel", {
        Parent = Drawings.Core,
        BackgroundTransparency = 1,
        ImageColor3 = Color3.new(1,1,1),
        Size = UDim2.new(0,40,0,60),
        Position = UDim2.new(0,0,1,24),
        Visible = false 
    })
    -- // Bars

    -- // Health
    Drawings.Healthbar = Utils:Instance("Frame", {
        Parent = Drawings.Core,
        Size = UDim2.new(0, 2, 1, 4),
        Position = UDim2.new(0, -6, 0, -2),
        BackgroundTransparency = 0,
        BackgroundColor3 = Color3.new(),
        BorderSizePixel = 0,
        Rotation = 180,
        Visible = false 
    })

    Drawings.HealthbarFill = Utils:Instance("Frame", {
        Parent = Drawings.Healthbar,
        Size = UDim2.new(1,0,0,0),
        BackgroundColor3 = Color3.new(0,1,0),
        BorderSizePixel = 1,
        BorderColor3 = Color3.new(),
    })

    Drawings.Chams = Utils:Instance("Highlight", {
        Parent = Drawings.Core,
        FillTransparency = 1,
        OutlineTransparency = 0,
        OutlineColor = Color3.fromRGB(),
        DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    })

    -- // Flags
    Drawings.FlagContainer = Utils:Instance("Frame", {
        Parent = Drawings.Core,
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        Size = UDim2.new(0,150,1,12),
        Position = UDim2.new(1,3,0,-6),
        Visible = true 
    })

    Utils:Instance("UIListLayout", {
        Parent = Drawings.FlagContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0,1)
    })

    Utils:Instance("UIPadding", {
        Parent = Drawings.FlagContainer,
        PaddingTop = UDim.new(0,2),
        PaddingLeft = UDim.new(0,2)
    })

    Drawings.Flags = {}

    for Name, _ in BaseEntity.Flags do
        Drawings.Flags[Name] = Utils:Instance("TextLabel", self.FlagProperties)

        Drawings.Flags[Name].Parent = Drawings.FlagContainer

        Utils:Instance("UIStroke", {
            Parent = Drawings.Flags[Name],
            Thickness = 1,
            Color = Color3.new()
        })
    end

    local MT = setmetatable({
        Instance = Object,
        AI = not Object:IsA("Player"),
        Drawings = Drawings,
        Data = {},
        Status = {},
        Adornments = {},
        Folder = ReplicatedStorage.Players:FindFirstChild(Object.Name),
        LastChamsUpdate = tick(),
        LastUpdate = tick()
    }, self.Functions)

    self.Cache[Object] = MT 

    return MT 
end)

BaseEntity.Remove = LPH_NO_VIRTUALIZE(function(self, Object)
    local MT = BaseEntity.Cache[Object]
    if MT and MT.Drawings then
        for Index, Value in MT.Drawings do
            if typeof(Value) == "Instance" then
                Value:Destroy()
            else
                Value = nil 
            end
        end

        MT = nil 
    end
end)

--#endregion

--#region MiscEntity

-- // Misc BaseEntity

MiscEntity.ChangeFont = function(self, Name)
    MiscEntity.Font = Assets.Fonts[Name]

    for Index, Value in self.Cache do
        local Text = Value.Text 

        if Text then Text.FontFace = Assets.Fonts[Name] end 
    end
end

MiscEntity.Create = LPH_NO_VIRTUALIZE(function(self, Data)
    local Text = Utils:Instance("TextLabel", {
        Parent = Visuals.ESPSpace,
        Visible = false,
        BackgroundTransparency = 1,
        FontFace = MiscEntity.Font,
        TextSize = 12,
        Size = UDim2.new(0,20,0,13),
        TextColor3 = Color3.new(1,1,1),
        Text = ""
    })

    Utils:Instance("UIStroke", {
        Parent = Text
    })

    self.Cache[Data.Object] = {
        Flag = Data.Flag,
        Name = Data.Name,
        Parent = Data.Parent,
        Color =Data.Color,
        GetName = Data.GetName,
        GetPosition = Data.GetPosition,
        Text = Text,
        LastUpdate = tick(),
        Allow = Data.Allow
    }
end)

MiscEntity.NewClass = LPH_NO_VIRTUALIZE(function(self, Data)
    local Allow = Data.Allow or function (Object)
        return true 
    end

    for Index, Value in Data.Parent:GetChildren() do
        task.spawn(function()
            task.wait(0.21)
            if ((Value.Name == Data.Name or Value:IsA(Data.Class)) or type(Data.Name) == "table" and table.find(Data.Name, Value.Name)) and Allow(Value) then
                self:Create({
                    Object = Value,
                    Flag = Data.Flag.." ESP",
                    Name = Data.Name,
                    Parent = Data.Parent,
                    Color = Data.Flag.." Color",
                    GetName = Data.GetName or function (Object)
                        return Object.Name 
                    end,
                    GetPosition = Data.GetPosition or function (Object)
                        return Object.CFrame.p 
                    end,
                    Allow = Allow
                })
            end
        end)
    end

    Data.Parent.ChildAdded:Connect(function(Value)
        task.spawn(function()
            task.wait(0.25)
            if ((Value.Name == Data.Name or Value:IsA(Data.Class)) or type(Data.Name) == "table" and table.find(Data.Name, Value.Name)) and Allow(Value) then
                self:Create({
                    Object = Value,
                    Flag = Data.Flag.." ESP",
                    Name = Data.Name,
                    Parent = Data.Parent,
                    Color = Data.Flag.." Color",
                    GetName = Data.GetName or function (Object)
                        return Object.Name 
                    end,
                    GetPosition = Data.GetPosition or function (Object)
                        return Object.CFrame.p 
                    end,
                    Allow = Allow
                })
            end
        end)
    end)

    Data.Parent.ChildRemoved:Connect(function(Child)
        if self.Cache[Child] then
            self.Cache[Child].Text:Destroy();
            self.Cache[Child] = nil 
        end
    end)
end)

--#endregion

--#region UI Creating

local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere", Lighting)

-- // UI Creating
LPH_JIT_MAX(function()
    local Ver = not LPH_OBFUSCATED and "Developer" or "Public"

    local Menu = Library:Create({Name = "Zenith", GameName = "Project Delta", Version = Ver})
    local Window = Menu.Window 

    local Tabs = {
        Combat = Window:Tab({Name = "Combat"}),
        Weapon = Window:Tab({Name = "Weapon"}),
        ESP = Window:Tab({Name = "ESP"}),
		World = Window:Tab({Name = "World"}),
        Visuals = Window:Tab({Name = "Visuals"}),
        Misc = Window:Tab({Name = "Misc"}),
        Settings = Library:CreateSettings(Menu)
    }

    local VMCallback = LPH_NO_VIRTUALIZE(function()
        Utils:UpdateViewmodel()
    end)

    local sec = Tabs.Combat:Section({Name = "Aimbot", Side = 1})
    sec:Toggle({Name = "Enabled", Flag = "Aimbot"})
    :Keybind({Name = "Aimbot", Flag = "Aimbot Key", Mode = "Toggle"})
    sec:Dropdown({Name = "Mode", Flag = "Aimbot Mode", Items = {"Memory","Silent"}, Default = "Silent"})
    sec:Toggle({Name = "Manipulation", Flag = "Manipulation"})
    sec:Toggle({Name = "Wallbang", Flag = "Wallbang"})
    sec:Toggle({Name = "Hitscan", Flag = "Wallbang Hitscan"})
    sec:Toggle({Name = "Dead Check", Flag = "Dead Check"})
    sec:Toggle({Name = "Visible Check", Flag = 'Hitscan'})
    sec:Toggle({Name = "Instant Hit", Flag = "Instant Bullet"})
    sec:Dropdown({Name = "Hitpart", Flag = "Target Part", Items = {"Head","HumanoidRootPart","Random"}, Default = "Head"})
    --sec:Slider({Name = "Distance", Flag = "Aimbot Distance", Min = 10, Max = 1000, Default = 1000, Suffix = "m"})
    local sec = Tabs.Combat:Section({Name = "Autoshoot", Side = 1})
    sec:Toggle({Name = "Autoshoot", Flag = "Autoshoot"})
    :Keybind({Name = "Autoshoot", Flag = "Autoshoot Key"})
    local sec = Tabs.Combat:Section({Name = "Visualization", Side = 2})
    --[[sec:Toggle({Name = "Target HUD", Flag = "Target HUD", Callback = function()
        if not flags["Target HUD"] then 
            Library.TargetInfo:SetVisible(false)
        end
    end})]]
    --[[sec:Toggle({Name = "Hotbar Viewer", Flag = "Hotbar Viewer", Callback = function()
        if not flags["Hotbar Viewer"] then 
            Library.TargetBelt:SetVisible(false)
        end
    end})
    sec:Toggle({Name = "Inventory Viewer", Flag = "Inventory Viewer", Callback = function()
        if not flags["Inventory Viewer"] then
            Library.InventoryViewer:SetVisible(false)
        end
    end})]]
    local t = sec:Toggle({Name = "Visualize FOV Circle", Flag = "Draw FOV"})
    t:Colorpicker({Flag = "FOV Main Color", Default = Color3.fromRGB(136, 154, 255)})
    t:Colorpicker({Flag = "FOV Second Color", Default = Color3.fromRGB(136, 154, 255)})
    sec:Slider({Name = "FOV Radius", Flag = "FOV Radius", Min = 10, Max = 1000, Decimals = 1, Default = 200, Suffix = "px"})
    sec:Toggle({Name = "Rotate FOV Gradient", Flag = "Rotate FOV"})
    sec:Toggle({Name = "Rainbow FOV", Flag = "Rainbow FOV"})
    sec:Toggle({Name = "Snapline", Flag = "Snapline"})
    :Colorpicker({Flag = "Snapline Color", Default = Color3.new(1,1,1)})
    sec:Toggle({Name = "Crosshair", Flag = "Crosshair"})
    :Colorpicker({Flag = "Crosshair Color", Default = Color3.new(1,1,1)})
    sec:Toggle({Name = "Rotate Crosshair", Flag = "Rotate Crosshair"})
    sec:Slider({Name = "Length", Flag = "Crosshair Length", Min = 1, Max = 10, Decimals = 1, Default = 10, Suffix = "px"})
    sec:Slider({Name = "Width", Flag = "Crosshair Width", Min = 1, Max = 10, Decimals = 1, Default = 3, Suffix = "px"})
    sec:Slider({Name = "Gap", Flag = "Crosshair Gap", Min = 1, Max = 10, Decimals = 1, Default = 10, Suffix = "px"})
    sec = Tabs.Combat:Section({Name = "Hit Detection", Side = 2})
    sec:Toggle({Name = "Custom Hitsounds", Flag = "Hitsounds"})
    sec:Dropdown({Name = "Headshot Sound", Flag = "Headshot Sound", Items = {"Rust","Skeet","Neverlose","Ding","Stapler","Bubble","TF2"}, Default = "Rust"})
    sec:Dropdown({Name = "Bodyshot Sound", Flag = "Bodyshot Sound", Items = {"Rust","Skeet","Neverlose","Ding","Stapler","Bubble","TF2"}, Default = "Skeet"})
    sec:Slider({Name = "Volume", Flag = "Hitsounds Volume", Min = 1, Max = 10, Default = 10, Suffix = "dB"})
    local sec = Tabs.Weapon:Section({Name = "Gun", Side = 1})
    sec:Toggle({Name = "Remove Recoil", Flag = "Remove Recoil"})
    sec:Toggle({Name = "Remove Spread", Flag = "Remove Spread"})
    sec:Toggle({Name = "Remove Bobbing", Flag = "Remove Bobbing"})
    sec:Toggle({Name = "Remove Sway", Flag = "Remove Sway"})
    sec:Toggle({Name  = "Remove Drag", Flag = "Remove Drag"})
    sec:Toggle({Name = "Instant Aim", Flag = "Instant Aim"})
    sec:Toggle({Name = "Instant Bolt", Flag = "Instant Bolt"})
    sec:Toggle({Name = "Instant Reload", Flag = 'Instant Reload'})
    --sec:Toggle({Name = "Instant Equip", Flag = "Instant Equip"})
    sec:Toggle({Name = "Unlock Firemodes", Flag = "Unlock Firemodes"})
    sec:Toggle({Name = "Remove Bullet Drop", Flag = "Remove Gravity"})
    sec:Toggle({Name = "Remove Obstructions", Flag = "Remove Obstructions"})
    sec:Toggle({Name = "Multi Bullet", Flag = "Multi Bullet"})
    sec:Slider({Name = "Bullets", Flag = "Bullets Amount", Min = 1, Max = 10, Decimals = 1, Default = 3})
    sec:Toggle({Name = "Rapid Fire", Flag = "Rapid Fire"})
    sec:Slider({Name = "Firerate", Flag = "Firerate", Min = 1, Max = 100, Decimals = 1, Default = 50, Suffix = "x"})
    local sec = Tabs.Weapon:Section({Name = "Melee", Side = 2})
    sec:Toggle({Name = "Remove Cooldown", Flag = "Remove Cooldown Melee"})
    --[[sec:Toggle({Name = "Kill-Aura", Flag ="Kill Aura"})
    :Keybind({Name = "Kill Aura", Flag = "Kill Aura Key"})
    sec:Dropdown({Name = "Part", Flag = "Kill Aura Part", Items = {"Head","HumanoidRootPart"}, Default = "Head"})
    sec:Slider({Name = "Radius", Flag = "Kill Aura Distance", Min = 1, Max = 10, Decimals = 1, Default = 5, Suffix = "m"})]]
    local sec = Tabs.ESP:Section({Name = "Constructor", Side = 1})
    sec:Toggle({Name = "Players", Flag = "Player ESP"})
    sec:Toggle({Name = "NPCs", Flag = "AI ESP"})
    sec:Toggle({Name = "Box", Flag= "Box"})
    :Colorpicker({Flag = "Box Color", Default = Color3.new(1,1,1)})
    sec:Toggle({Name = "Box Glow", Flag = "Box Glow"})
    --[[sec:Toggle({Name = "Head Dot", Flag = "Head Dot"})
    :Colorpicker({Name = "Head Dot", Flag = "Head Dot Color"})]]
    --sec:Dropdown({Name = "Style", Flag = "Box Style", Items = {"Full","Corner"},Default = "Full"})
    sec:Toggle({Name = "Nametag", Flag = "Nametag"})
    :Colorpicker({Name = "Nametag Text", Flag= "Nametag Color"})
    sec:Toggle({Name = "Distance", Flag = "Distance"})
    :Colorpicker({Name = "Distance Text", Flag = "Distance Color"})
    sec:Toggle({Name = "Item Text", Flag = "Item"})
    :Colorpicker({Flag = "Item Color"})
    sec:Toggle({Name = "Item Image (BETA)", Flag = "Item Image"})
    local t = sec:Toggle({Name = "Health Bar", Flag = "HP Bar"})
    t:Colorpicker({Name = "Low HP", Flag = "Low HP Color", Default = Color3.new(1,0,0)})
    t:Colorpicker({Name = "High HP", Flag = "High HP Color", Default = Color3.new(0,1,0)})
    --[[sec:Toggle({Name = "Health Text", Flag = "Health Text"})
    :Colorpicker({Name = "Health Text", Flag = "Health Color"})]]
    local t = sec:Toggle({Name = "Chams", Flag = "Chams"})
    t:Colorpicker({Flag = "Chams Color", Default = Color3.new(0.596078, 0.623529, 1)})
    sec:Toggle({Name = "Chams Visible Only", Flag = "Chams Visible Only"})
    sec:Slider({Name = "Chams Transparency", Flag = "Chams Transparency", Min = 0, Max = 100, Default = 100})
    sec:Dropdown({Name = "Display Flags", Flag = "Custom Flags", Items = {"Visible", "Target", "Manipulated"}, Multi = true})
    sec:Label("Visible Flag Color"):Colorpicker({Name = "Visible Flag", Flag = "Visible Flag Color"})
    sec:Label("Target Flag Color"):Colorpicker({Name = "Target Flag", Flag = "Target Flag Color", Default = Color3.new(0.6, 0, 1)})
    sec:Label("Manipulated Flag Color"):Colorpicker({Name = "Manipulated Flag", Flag = "Manipulated Flag Color", Default = Color3.new(1,0,0)})

    local sec = Tabs.ESP:Section({Name = "Misc", Side = 2})
    sec:Toggle({Name = "Dynamic Colors", Flag= "Dynamic Colors"})
    sec:Label("Accent Color"):Colorpicker({Name = "Accent", Flag = "Accent Color"})
    sec:Label("Visible Color"):Colorpicker({Name = "Visible", Flag = "Visible Color", Default = Color3.new(0,1,0)})
    sec:Label("Target Color"):Colorpicker({Name = "Target", Flag = "Target Color", Default = Color3.new(1,0,0)})

    local fonts = {}

    for index,value in Assets.Fonts do
        table.insert(fonts, index)
    end

    --[[sec:Dropdown({Name = "ESP Font", Flag = "ESP Font", Items = fonts, Default = "Inter", Callback = LPH_NO_VIRTUALIZE(function()
        BaseEntity:ChangeFont(flags["ESP Font"])
    end)})
    sec:Dropdown({Name = "Entity Font", Flag = "Entity Font", Items = fonts, Default = "Inter", Callback = LPH_NO_VIRTUALIZE(function()
        MiscEntity:ChangeFont(flags["ESP Font"])
    end)})]]
    sec:Dropdown({Name = "Box Sizing Type", Flag = "Sizing Type", Items = {"Dynamic", "Static"}, Default = "Static"})
    sec:Slider({Name = "Static Box Width", Flag = "Box Width", Min = 1, Max = 10, Default = 4, Decimals = 0.5})
    sec:Slider({Name = "Static Box Height", Flag = "Box Height", Min = 1, Max = 10, Default = 6, Decimals = 0.5})

    local sec = Tabs.ESP:Section({Name = "Misc Entity", Side = 1})
    sec:Toggle({Name = "Extractions", Flag = "Extracts ESP"}):Colorpicker({Name = "Extractions", Flag= "Extracts Color"})
    sec:Toggle({Name = "Corpses", Flag = "Corpses ESP"}):Colorpicker({Name = "Corpses", Flag=  "Corpses Color"})
    sec:Slider({Name = "Render Distance", Flag = "Entity Render Distance", Min = 100, Max = 1000, Default = 250})
    
    --[[local sec = Tabs.ESP:Section({Name = "Options", Side = 2})
    sec:Slider({Name = "Render Distance", Flag = "ESP Distance", Min = 10, Max= 1000, Suffix = "m", Default = 1000})]]
    local sec = Tabs.World:Section({Name = "Lighting", Side = 1})
    local t = sec:Toggle({Name = "Custom Ambient", Flag = "Ambient", Callback = LPH_NO_VIRTUALIZE(function()
        if flags["Ambient"] then
            if not Garbage.OldAmbient then
                Garbage.OldAmbient = Lighting.Ambient 
                Garbage.OldAmbient2 = Lighting.OutdoorAmbient
            end

            Lighting.Ambient = flags["Ambient1"]
            Lighting.OutdoorAmbient = flags["Ambient2"]
        elseif Garbage.OldAmbient then
            Lighting.Ambient = Garbage.OldAmbient
            Lighting.OutdoorAmbient = Garbage.OldAmbient2

            Garbage.OldAmbient = nil 
        end
    end)})
    t:Colorpicker({Flag = "Ambient1", Callback = LPH_NO_VIRTUALIZE(function()
        if flags["Ambient"] then
            Lighting.Ambient = flags["Ambient1"]
        end
    end)})
    t:Colorpicker({Flag = "Ambient2", Callback = LPH_NO_VIRTUALIZE(function()
        if flags['Ambient'] then 
            Lighting.OutdoorAmbient = flags["Ambient2"]
        end
    end)})
    sec:Toggle({Name = "Clock Time", Flag = "Clock Time", Callback = LPH_NO_VIRTUALIZE(function()
        if flags["Clock Time"] then
            if not Garbage.OldTime then
                Garbage.OldTime = Lighting.ClockTime 
            end

            Lighting.ClockTime = flags["Time"]
        elseif Garbage.OldTime then 
            Lighting.ClockTime = Garbage.OldTime 
            Garbage.OldTime = nil
        end
    end)})
    sec:Slider({Name = "Time", Flag = "Time", Suffix = "h", Min = 0, Max = 24, Default = 12, Callback = LPH_NO_VIRTUALIZE(function()
        if flags["Clock Time"] then
            Lighting.ClockTime = flags["Time"]
        end
    end)})
    --[[local skyboxes = {}
    sec:Dropdown({Name = "Skybox", Flag = "Skybox", Items = skyboxes, Default = "Blue Nebula"})
    sec:Button({Name = "Change Skybox", Callback = function()
        Visuals:SwitchSkybox(flags["Skybox"])
    end})
    sec:Button({Name = "Return Skybox", Callback = function()
        Visuals:SwitchSkybox("Original")
    end})]]
    sec:Slider({Name = "Exposure Compensation", Flag = "Exposure", Min = Lighting.ExposureCompensation, Max = 5, Default = Lighting.ExposureCompensation, Decimals = 0.1,Callback = LPH_NO_VIRTUALIZE(function()
        Lighting.ExposureCompensation = flags["Exposure"]
    end)})
    sec:Dropdown({Name = "Lighting Style", Flag = "Lighting Style", Items = {"Realistic","Soft"}, Default = "Realistic", Callback = LPH_NO_VIRTUALIZE(function()
        Lighting.LightingStyle = flags['Lighting Style']
    end)})

    local sec = Tabs.World:Section({Name = "Atmosphere", Side = 1})
    sec:Label("Color")
    :Colorpicker({Flag = "Atmosphere Color", Default = atmosphere.Color, Callback = LPH_NO_VIRTUALIZE(function()
        atmosphere.Color = flags["Atmosphere Color"]
    end)})
    sec:Label("Decay")
    :Colorpicker({Flag = "Atmosphere Decay", Default = atmosphere.Decay,Callback = LPH_NO_VIRTUALIZE(function()
        atmosphere.Decay = flags["Atmosphere Decay"]
    end)})
    sec:Slider({Name = "Glare", Flag = "Atmosphere Glare", Min = 0, Max = 10, Decimals = 1, Default = atmosphere.Glare, Callback = LPH_NO_VIRTUALIZE(function()
        atmosphere.Glare = flags["Atmosphere Glare"]
    end)})
    sec:Slider({Name = "Haze", Flag = "Atmosphere Haze", Min =0, Max = 10, Decimals = 1, Default = atmosphere.Haze, Callback = LPH_NO_VIRTUALIZE(function()
        atmosphere.Haze = flags["Atmosphere Haze"]
    end)})
    sec:Slider({Name = "Density", Flag = 'Atmosphere Density', Min =0, Max = 1, Decimals = 0.1, Default = atmosphere.Density, Callback = LPH_NO_VIRTUALIZE(function()
        atmosphere.Density = flags["Atmosphere Density"]
    end)})

    sec = Tabs.World:Section({Name = "Terrain", Side = 2})
    sec:Toggle({Name= 'Remove Grass', Flag = "Remove Grass", Callback = function()
        sethiddenproperty(Workspace:FindFirstChildOfClass("Terrain"), "Decoration", not flags["Remove Grass"])
    end})
    sec:Toggle({Name = "Remove Shadows", Flag = "Remove Shadows", Callback = function()
        Lighting.GlobalShadows = flags["Remove Shadows"]
    end})
    sec:Toggle({Name = "Remove Foliage", Flag = "Remove Foliage", Callback = LPH_NO_VIRTUALIZE(function()
        if Workspace:FindFirstChild("SpawnerZones") then
            for Index, Value in Workspace.SpawnerZones.Foliage:GetDescendants() do
                if Value:IsA("MeshPart") and Value.Color ~= Color3.fromRGB(100,88,75) then
                    Value.Transparency = flags["Remove Foliage"] and 1 or 0
                end
            end
        end
    end)})
    sec = Tabs.Visuals:Section({Name = "Viewmodel", Side = 1})
    sec:Toggle({Name = "Custom Viewmodel", Flag = "Custom Viewmodel", Callback = VMCallback})
    sec:Dropdown({Name = "Arms Material", Flag = "Arms Material", Items = {"ForceField", "SmoothPlastic", "Neon"}, Default = "ForceField", Callback = VMCallback})
    sec:Dropdown({Name = "Gun Material", Flag = "Gun Material", Items = {"ForceField", "SmoothPlastic", "Neon"}, Default = "ForceField", Callback = VMCallback})
    sec:Label("Arms Color")
    :Colorpicker({Flag = "Arms Color", Callback = VMCallback})
    sec:Label("Gun Color")
    :Colorpicker({Flag = "Gun Color", Callback = VMCallback})
    sec:Slider({Name = "Viewmodel Transparency", Flag = "VM Transparency", Min = 0, Max = 100, Default = 0, Decimals = 1})
    sec:Toggle({Name = "Viewmodel Position", Flag = "Viewmodel Position", Callback = VMCallback})
    sec:Slider({Name = "X Offset", Flag = "Viewmodel X", Min = -10, Max = 10, Default = 0, Decimals = 1, Callback = VMCallback})
    sec:Slider({Name = "Y Offset", Flag = "Viewmodel Y", Min = -10, Max = 10, Default = 0, Decimals = 1, Callback = VMCallback})
    sec:Slider({Name = "Z Offset", Flag = "Viewmodel Z", Min = -10, Max = 10, Default = 0, Decimals = 1, Callback = VMCallback})
    sec  =             Tabs.Visuals:Section({Name = "Hit Detection", Side = 2})
    sec:Toggle({Name = "Hitmarkers", Flag = "Hitmarkers"})
    :Colorpicker({Flag = 'Hitmarkers Color'})
    sec:Slider({Name = "Lifetime", Flag = "Hitmarkers Lifetime", Min = 1, Max = 10, Default = 5, Suffix = "s"})
    sec = Tabs.Visuals:Section({Name = "Character", Side = 2})
    sec:Toggle({Name = "Third Person", Flag = "Third Person"})
    :Keybind({Name = "Third Person", Flag= "Third Person Key",})
    sec:Slider({Name = "Distance", Flag = "Third Person Distance", Min = 1, Max =5, Default = 3})
    sec = Tabs.Visuals:Section({Name = "Bullet", Side = 2})
    sec:Toggle({Name = "Bullet Tracers", Flag = "Bullet Tracers"}):Colorpicker({Flag = "Bullet Tracers Color"})
    sec:Slider({Name = "Travel Time", Flag = "Bullet Tracers Travel Time", Min = 0, Max = 10, Default = 5, Decimals = 1})
    
    sec:Slider({Name = "Lifetime", Flag = "Bullet Tracers Lifetime", Min = 1, Max = 10, Default = 3})
    sec = Tabs.Misc:Section({Name= "Camera", Side = 1})
    sec:Toggle({Name = "Custom Camera FOV", Flag = "Custom Camera FOV"})
    sec:Slider({Name = "Camera FOV", Flag = "Camera FOV", Min = 60, Max = 120, Default = 90})
    sec:Toggle({Name = "Zoom", Flag = "Zoom"})
    :Keybind({Name = "Zoom", Flag = "Zoom Key"})
    sec:Slider({Name = "Zoom FOV", Flag = "Zoom FOV", Min = 10, Max = 40, Default = 20})
    sec = Tabs.Misc:Section({Name = "Movement", Side = 2})
    sec:Toggle({Name = "No Jump Cooldown", Flag = "Bunny Hop"})
    sec:Toggle({Name = "No Drowning", Flag = "Vodolaz"})
    sec:Toggle({Name = "No Fall Damage", Flag = "No Fall Damage"})
    local Humanoid = Client.Character and Client.Character:FindFirstChildOfClass("Humanoid")
    sec:Toggle({Name = "Omni Sprint", Flag = "Speedhack", Callback = LPH_NO_VIRTUALIZE(function()
        if Humanoid and flags["Speedhack"] then
            Humanoid.WalkSpeed = flags["Speedhack Speed"]
        end
    end)})
    sec:Slider({Name = "Speed", Flag = "Speedhack Speed", Min = 16, Max = 22, Default = 20, Callback = LPH_NO_VIRTUALIZE(function()
        if Humanoid and flags["Speedhack"] then
            Humanoid.WalkSpeed = flags["Speedhack Speed"]
        end
    end)})
    sec:Toggle({Name = "Jumphack", Flag = "Jumphack", Callback = LPH_NO_VIRTUALIZE(function()
        if Humanoid and flags["Jumphack"] then
            Humanoid.JumpHeight = flags["Jump Height"]
        end
    end)})
    sec:Slider({Name = "Jump Height", Flag = "Jump Height", Min = 1, Max = 5, Default = 5, Callback = LPH_NO_VIRTUALIZE(function()
        if Humanoid and flags["Jumphack"] then
            Humanoid.JumpHeight = flags["Jump Height"]
        end
    end)})
    sec:Toggle({Name = "Freecam", Flag = "Freecam"}):Keybind({Name = "Freecam", Flag = "Freecam Key", Mode = "Toggle"})
    sec:Slider({Name = "Freecam Speed", Flag = "Freecam Speed", Min = 10, Max = 100, Default = 30})
    sec:Toggle({Name = "Spiderman", Flag = "Spiderman"}):Keybind({Name = "Spiderman", Flag = "Spiderman Key", Mode = "Toggle"})
    sec = Tabs.Misc:Section({Name = "Desync", Side = 2})
    sec:Toggle({Name = "Underground AA", Flag = "Underground AA"}):Keybind({Name = "Underground AA", Flag = "Underground AA Key", Mode = "Toggle"})
    sec:Toggle({Name = "Visualize Desync", Flag = "Visualize Desync"})
    sec = Tabs.Misc:Section({Name = "Anti Aim", Side = 1})
    sec:Toggle({Name = "Enabled", Flag = "Anti Aim"})
    sec:Dropdown({Name = "Yaw Base", Flag = "Yaw Base", Items = {"None", "Back", "Spin", "HvH"}})
    sec:Dropdown({Name = "Pitch Base", Flag = "Pitch Base", Items = {"None", "Up", "Down", "HvH"}})
end)()

--#endregion

--#region Game Init

-- // Game Init 
do
    local FPS = ReplicatedStorage.Modules.FPS 

    Game.FPS = require(FPS)
    Game.Bullet = require(FPS.Bullet)
    Game.Melee = require(FPS.Melee)
    Game.CameraSystem = require(ReplicatedStorage.Modules.CameraSystem)
    Game.Items = ReplicatedStorage.ItemsList 

    LPH_NO_VIRTUALIZE(function()
        for _, Value in GarbageCollection(true) do
            if type(Value) == "table" then
                if rawget(Value, "RangedWeaponDefault") then
                    Game.ItemFunctions = Value 
                end

                if rawget(Value, "shove") and rawget(Value, "update") then
                    local oldShove = Value.shove 
                    local oldUpdate = Value.update 

                    Value["shove"] = function(...)
                        if flags["Remove Recoil"] then
                            return 
                        end

                        return oldShove(...)
                    end

                    Value.update = function(...)
                        return flags["Remove Bobbing"] and Vector3.zero or oldUpdate(...)
                    end

                    --shoveHook:Hook()
                    --updateHook:Hook()
                end

                if rawget(Value, "create") and debug.getinfo(Value.create).short_src == "ReplicatedStorage.Modules.SpringV2" then
                    local old = Value.create
                    Value.create = function(...)
                        local Functions = old(...);

                        local old1 = Functions.shove 
                        local old2 = Functions.update 

                        Functions.shove = function(...)
                            if flags["Remove Recoil"] then
                                return 
                            end

                            return old1(...)
                        end

                        Functions.update = function(...)
                            return flags["Remove Bobbing"] and Vector3.zero or old2(...)
                        end

                        --shoveHook:Hook()
                        --updateHook:Hook()

                        return Functions
                    end
                end
            end
        end
    end)()

    Game.ProjectileCodes = {}; -- // Fire & Inflict Codes

    local OnCharacterAdded = function(Character)
        if not Character then
            return 
        end

        RayParams.FilterDescendantsInstances = {Camera, Character, IgnoreList}

        local Humanoid = Character:FindFirstChildOfClass("Humanoid");

        Humanoid.StateChanged:Connect(function(Old, New)
            if flags["No Fall Damage"] and (New == Enum.HumanoidStateType.Freefall or New == Enum.HumanoidStateType.FallingDown) then
                Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
            end
        end)

        Humanoid.Changed:Connect(function(Property)
            if Property == "WalkSpeed" and flags["Speedhack"] then
                Humanoid["WalkSpeed"] = flags["Speedhack Speed"]
            end

            if Property == "JumpHeight" and flags["Jumphack"] then
                Humanoid["JumpHeight"] = flags['Jump Height']
            end
        end)
    end

    Connections:Connect(Client.CharacterAdded, OnCharacterAdded)

    -- // Desync Init 
    local Folder = Instance.new("Folder", ZenithFolder)
    Folder.Name = "Desync Clone"

    local CreatePart = LPH_NO_VIRTUALIZE(function(RealPart, Parent)
        local Part = RealPart:Clone()
        Part.Parent = Parent
        
        Part.Material = Enum.Material.Neon
        Part.Color = Color3.fromRGB(255, 182, 239)
        Part.CanCollide = false
        Part.CanTouch = false 
        Part.CanQuery = false 
        Part.Anchored = true 
        Part.Transparency = 1

        local box = Instance.new("SelectionBox", Part)
        box.SurfaceTransparency = 1
        box.Color3 = Color3.new(1,1,1)
        box.Adornee = Part 
        box.LineThickness = 0.001
        
        for _, child in Part:GetChildren() do
            if child:IsA("Motor6D") or child:IsA("WeldConstraint") then
                child:Destroy()
            end
        end

        return Part 
    end)

    local PartsList = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand", 
                   "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", 
                   "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}

    Game.CreateVisualizer = LPH_NO_VIRTUALIZE(function(self)
        local Temp = Folder:FindFirstChild("Visualizer")
        if Temp then return Temp end 

        local Clone = Instance.new("Model", Folder)
        Clone.Name = "Visualizer"

        for _, Name in PartsList do
            local RealPart = Client.Character:FindFirstChild(Name)
            if RealPart then
                CreatePart(RealPart, Clone)
            end
        end

        return Clone 
    end)

    Game.DestroyVisualizer = LPH_NO_VIRTUALIZE(function(self)
        local Temp = Folder:FindFirstChild("Visualizer")

        if Temp then Temp:Destroy() end 
    end)

    -- // Download Icons 
    for Index, Value in Game.Items:GetChildren() do
        local Icon = Value.ItemProperties.ItemIcon.Image

        Assets.ItemIcons[Value.Name] = Icon 
    end
end

--#endregion

--#region Connections

-- // Connections
Connections:Connect(Camera.ChildRemoved, LPH_NO_VIRTUALIZE(function(Child)
    if string.lower(Child.Name) == "viewmodel" then
        table.clear(Garbage.OriginalC0)
    end
end))

Player.Viewmodel = {};

Connections:Connect(Camera.ChildAdded, LPH_NO_VIRTUALIZE(function(Child)
    task.spawn(function()
        if string.lower(Child.Name) ~= "viewmodel" then
            return     
        end

        Player.Viewmodel.Instance = Child 

        local Item = Child:FindFirstChild("Item")
        local Muzzle = nil 
        
        do
            if not Muzzle then
                Muzzle = Item:FindFirstChild("Barrel")

                if not Muzzle then
                    local Atts = Item:FindFirstChild("Attachments")
                    if Atts then
                        Muzzle = Atts:GetChildren()[1].Barrel 
                    end
                end

                if not Muzzle or not Muzzle:IsA("BasePart") then
                    local Atts = Item:FindFirstChild("Attachments")

                    if Atts then
                        Muzzle = Atts.Front.Barrel 
                    end
                end
            end
        end

        Player.Viewmodel.Muzzle = Muzzle 
    end)

    Utils:UpdateViewmodel()
end))
-- // Loops
Connections:Connect(RunService.RenderStepped, LPH_NO_VIRTUALIZE(function(Delta)
    Camera = Workspace.CurrentCamera
    local Target, TargetPart, TargetMT, LastDistance = nil, nil, nil, Visuals.FOVCircle.AbsoluteSize.X / 2
    local Manipulated, ManipulatedPosition, ManipulatedPart = false, nil, nil 

    for Object, Entity in BaseEntity.Cache do
        if tick() - Entity.LastUpdate > 0.0175 then
            Entity.LastUpdate = tick()
            Entity:Update() -- // ESP 
            --Entity:UpdateStats()
        end

        if flags['Dead Check'] and not Entity.Status.Alive then
            continue 
        end

        if not Entity.Folder then
            
            Entity.Folder = ReplicatedStorage.Players:FindFirstChild(Object.Name)
        end

        if not (Entity.Data.Root and Entity.Data.Character) then
            continue 
        end

        local Root = Entity.Data.Root 
        local Character = Entity.Data.Character 

        local DistanceFromCenter = Utils:GetDistanceFromCenter(Root)

        if not (DistanceFromCenter < LastDistance and Entity.Status.OnScreen) then
            continue 
        end

        local Part = Character:FindFirstChild(flags["Target Part"])

        TargetPart = Part 

        if flags["Target Part"] == "Random" then
            local Parts = {
                "Head", "HumanoidRootPart"
            };

            TargetPart = Character:FindFirstChild(Parts[math.random(1, #Parts)])
        end

        local ClientRoot = Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")

        if flags["Manipulation"] and ClientRoot and TargetPart and not Entity.Status.Visible then
            local Position = Utils:GetManipulatedPosition(TargetPart, ClientRoot.Position)

            if Position then
                Manipulated = true 
                ManipulatedPart = TargetPart 
                ManipulatedPosition = Position 
            end
        end

        if flags["Hitscan"] and TargetPart then
            TargetPart = (Manipulated or Utils:IsVisible(TargetPart)) and TargetPart or nil
        end

        if TargetPart then
            TargetMT = Entity 
            Target = Object 
            LastDistance = DistanceFromCenter
        end
    end

    BaseEntity.Manipulated = Manipulated
    BaseEntity.ManipulatedPart = ManipulatedPart
    BaseEntity.ManipulatedPosition = ManipulatedPosition

    BaseEntity.TargetPart = TargetPart 
    BaseEntity.Target = Target 
    BaseEntity.TargetInfo = TargetMT

    if BaseEntity.TargetPart and flags["Aimbot"] and flags["Aimbot Key"].Active then
        Camera.CFrame = CFrame.new(Camera.CFrame.p ,BaseEntity.TargetPart.Position)
    end

    local rainbowColors = {}
    local angle = Visuals.FOVGradient.Rotation 
    local s = 0.5 
    local v = 0.9

    for i = 0,7 do
        local baseh = i / 7
        local o = angle / 360 
        local hue = (baseh + o) % 1 
        table.insert(rainbowColors, ColorSequenceKeypoint.new(i / 7, Color3.fromHSV(hue,s,v)))
    end

    Visuals.FOVCircle.Size = UDim2.fromOffset(flags["FOV Radius"], flags["FOV Radius"])
    Visuals.FOVCircle.Visible = flags["Draw FOV"]
    Visuals.FOVGradient.Color = not flags["Rainbow FOV"] and ColorSequence.new({
        ColorSequenceKeypoint.new(0, flags["FOV Main Color"]),
        ColorSequenceKeypoint.new(1, flags["FOV Second Color"])
    }) or ColorSequence.new(rainbowColors)
    Visuals.FOVGradient.Rotation = flags["Rotate FOV"] and math.sin(tick()) * 360 or 0 

    if flags["Snapline"] and BaseEntity.TargetPart then
        --local From = (Player.Viewmodel.Muzzle and Player.Viewmodel.Muzzle.Position) or Camera.ViewportSize / 2
        Visuals.SnaplineOutline.Visible = true
        
        --From = Utils:WorldToViewport(From)
        local ScreenPos = Utils:WorldToViewport(BaseEntity.TargetPart.Position)
        --Visuals.SnaplineOutline.From = Vector2.new(From.X, From.Y)
        Visuals.SnaplineOutline.To = Vector2.new(ScreenPos.X, ScreenPos.Y)

        Visuals.Snapline.Visible = true 
        Visuals.Snapline.To = Visuals.SnaplineOutline.To 
        --Visuals.Snapline.From = Vector2.new(From.X, From.Y)
        Visuals.Snapline.Color = flags["Snapline Color"]
    else
        Visuals.SnaplineOutline.Visible = false 
        Visuals.Snapline.Visible = false 
    end

    local Width,Length,Gap = flags["Crosshair Width"], flags["Crosshair Length"], flags["Crosshair Gap"]
    Visuals.CrosshairBottom.Size = UDim2.new(0,Width,0,Length)
    Visuals.CrosshairTop.Size = UDim2.new(0,Width,0,Length)
    Visuals.CrosshairLeft.Size = UDim2.new(0,Length, 0, Width)
    Visuals.CrosshairRight.Size = UDim2.new(0,Length,0,Width)

    Visuals.CrosshairBottom.Position = UDim2.new(0.5, 0, 0.5, Gap)
    Visuals.CrosshairTop.Position = UDim2.new(0.5,0,0.5, -Gap)
    Visuals.CrosshairLeft.Position = UDim2.new(0.5,-Gap,0.5,0)
    Visuals.CrosshairRight.Position = UDim2.new(0.5,Gap,0.5,0)

    for Index, Component in Visuals.CrosshairContainer:GetChildren() do
        Component.BackgroundColor3 = flags["Crosshair Color"]
    end

    Visuals.CrosshairContainer.Visible = flags["Crosshair"]

    Visuals.CrosshairContainer.Rotation = flags["Rotate Crosshair"] and (tick() * 120 % 360) or 0 

    do
        local Info = BaseEntity.TargetInfo 

        --[[if Info and not Info.AI then 
--
            if flags["Target HUD"] then
                Library.TargetInfo:SetVisible(true)

                Library.TargetInfo:Update({
                    Name = BaseEntity.Target.Name,
                    HealthData = {HP = BaseEntity.TargetInfo.Data.Health, MaxHP = 100},
                    Item = BaseEntity.TargetInfo.Data.Item or "None",
                    Distance = math.floor(BaseEntity.TargetInfo.Data.Distance / 3),
                    Visible = BaseEntity.TargetInfo.Status.Visible,
                    KD = BaseEntity.TargetInfo.Data.KD,
                    Hours = BaseEntity.TargetInfo.Data.Hours
                })
            else
                Library.TargetInfo:SetVisible(false)
            end

            if tick() - BaseEntity.LastUpdate > 0.35 and Info.Folder then
                BaseEntity.LastUpdate = tick();
                if flags["Hotbar Viewer"] then  
                    Library.TargetBelt:SetVisible(true)
                    local Hotbar = Library.TargetBelt
                    local Inventory = Info.Folder:FindFirstChild("Inventory")
                    local Passed = {}

                    if Inventory then
                        for _, Value in Inventory:GetChildren() do 
                            local Name = Value.Name
                            Passed[Name] = true 
                            Hotbar:Add(Name, Assets.ItemIcons[Name])
                        end

                        for Name in Hotbar.Icons do
                            if not Passed[Name] then Hotbar:Remove(Name) end
                        end
                    end
                end

                if flags["Inventory Viewer"] and Info.Folder then
                    Library.InventoryViewer:SetVisible(true)
                    local inv = Info.Folder:FindFirstChild("Inventory")
                    if inv then 
                        Visuals:UpdateInventory(inv)
                    end
                end
            end
        else
            Library.InventoryViewer:SetVisible(false)
            Library.TargetBelt:Clear()
            Library.TargetBelt:SetVisible(false)
            Library.TargetInfo:SetVisible(false)
        end]]
    end

    -- // Misc Entity 
    for Object, Data in MiscEntity.Cache do
        task.spawn(function()
            if tick() - Data.LastUpdate > 0.025 then
                Data.LastUpdate = tick();

                local Passed = Data.Allow(Object)

                if Object and flags[Data.Flag] and Passed then
                    local Name = Data.GetName(Object)
                    local Position = Data.GetPosition(Object)

                    if Position then
                        local Distance = Math:GetDistance(Camera.CFrame.p, Position)
                        Distance = math.floor(Distance)

                        if Distance / 3 <= flags["Entity Render Distance"] then
                            local ScreenPos, OnScreen = Utils:WorldToViewport(Position)

                            Data.Text.Visible = OnScreen

                            if Data.Text.Visible then
                                Data.Text.Text = Name 
                                Data.Text.TextColor3 = flags[Data.Color]
                                Data.Text.Position = UDim2.fromOffset(ScreenPos.X, ScreenPos.Y)
                            end
                        else
                            Data.Text.Visible = false
                        end
                    else
                        Data.Text.Visible = false 
                    end
                else
                    Data.Text.Visible = false 
                end
            end
        end)
    end

    Player.EquippedItem = ReplicatedStorage.Players[Client.Name].Status.GameplayVariables.EquippedTool.Value

    local Character = Client.Character 
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if flags["Custom Camera FOV"] or flags["Zoom"] then
        if flags["Zoom"] and flags["Zoom Key"].Active then
            Camera.FieldOfView = Math:Lerp(Camera.FieldOfView, flags["Zoom FOV"], 0.1)
            return 
        end

        if flags["Custom Camera FOV"] then
            Camera.FieldOfView = flags["Camera FOV"]
        else
            Camera.FieldOfView = 70
        end
    else
        Camera.FieldOfView = 70 
    end

    --[[if flags["Speedhack"] and Humanoid then
        Humanoid.WalkSpeed = flags["Speedhack Speed"]
    end

    if flags["Jumphack"] and Humanoid then
        Humanoid.JumpHeight = flags["Jump Height"]
    end]]

    if flags["Freecam"] and flags["Freecam Key"].Active and Humanoid then
        task.spawn(function()
            
            local LookDirection = Camera.CFrame.LookVector 
            local OriginalLookDirection = LookDirection
            local Root = Humanoid.RootPart 

            if not Player.FreecamStart then
                Player.FreecamStart = Root.CFrame 
            end

            sethiddenproperty(Root, "NetworkIsSleeping", true) 
            
            local OriginalCFrame = Root.CFrame 
            local Forward = UserInputService:IsKeyDown(Enum.KeyCode.W)
            local Backward = UserInputService:IsKeyDown(Enum.KeyCode.S)

            Root.Anchored= true 
            Root.Velocity = Vector3.zero 

            local Multiplier = Delta * flags["Freecam Speed"] * 3

            local Vector = (Humanoid.MoveDirection +
            (Forward and OriginalLookDirection or Vector3.zero)+
            (Backward and -OriginalLookDirection or Vector3.zero)
            ) * Multiplier 

            OriginalCFrame += Vector 

            Root.CFrame = CFrame.new(OriginalCFrame.p, OriginalCFrame.p + LookDirection)
            Humanoid.AutoRotate = false 
        end)
    elseif Player.FreecamStart and Character then 
        Humanoid.AutoRotate = true 
        sethiddenproperty(Humanoid.RootPart, "NetworkIsSleeping", false)

        for Index, Value in Character:GetChildren() do
            if Value:IsA('BasePart') then
                sethiddenproperty(Value, "NetworkIsSleeping", false)
            end
        end

        Humanoid.RootPart.CFrame = Player.FreecamStart
        Humanoid.RootPart.Anchored = false 

        Player.FreecamStart = nil 
    end

    -- // Anti Aim 
    if Humanoid and Character then 

        if flags["Anti Aim"] then 
            local Root = Humanoid.RootPart 
            
            Humanoid.AutoRotate = false 

            local ZeroAngle = -math.atan2(Camera.CFrame.LookVector.Z, Camera.CFrame.LookVector.X)
            local Angle = 0

            if flags["Yaw Base"] == "None" then
                Angle = ZeroAngle 
            elseif flags["Yaw Base"] == "Back" then
                Angle = ZeroAngle + math.rad(180)
            elseif flags["Yaw Base"] == "Spin" then
                Angle = ZeroAngle + tick() * 10 % 360 
            else
                Angle = ZeroAngle + math.rad(math.random(-180, 120))
            end
            Root.CFrame = CFrame.new(Root.CFrame.p) * CFrame.Angles(0, Angle, 0)

            -- // Pitch 
            local Pitch = 0 

            if flags["Pitch Base"] == "Down" then
                Pitch = -0.7
            elseif flags['Pitch Base'] == "Up" then
                Pitch = 0.7
            elseif flags["Pitch Base"] == "None" then
                Pitch = 0 
            else
                Pitch = math.random(-7, 7) / 10 
            end

            Utils:Pitch(Pitch)
            ReplicatedStorage.Remotes.UpdateTilt:FireServer(Pitch)
        else
            Humanoid.AutoRotate = true 
            Utils:Pitch(0)
        end
    end
    
end))

do
    local Desync = {}

    Connections:Connect(RunService.Heartbeat, LPH_NO_VIRTUALIZE(function(Delta)
        if Client.Character and Client.Character:FindFirstChild("HumanoidRootPart") then
            local Character = Client.Character
            local Root = Character["HumanoidRootPart"]

            Desync.Real = Root.CFrame 

            local Offset = Desync.Real

            if flags["Manipulation"] and BaseEntity.Manipulated and Player.Shooting then
                Offset = CFrame.new(BaseEntity.ManipulatedPosition)
            elseif flags["Underground AA"] and flags["Underground AA Key"].Active then
                Offset *= CFrame.new(0,-2,0) * CFrame.Angles(math.pi,0,0)
            end

            Root.CFrame = Offset 
            
            if flags["Visualize Desync"] then
                local Vis = Game:CreateVisualizer()
                
                for name, part in Vis:GetChildren() do
                    part.CFrame = Client.Character[part.Name].CFrame
                end
            else
                Game:DestroyVisualizer()
            end

            Desync.Fake = Root.CFrame 

            if flags["Spiderman"] and flags["Spiderman Key"].Active then
                local Foot = Character:FindFirstChild("RightFoot")
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                local Raycast = Workspace:Raycast(Foot.Position, Root.CFrame.LookVector* 2, RayParams)

                if Raycast and Raycast.Instance then
                    local HumanoidState = Humanoid:GetState()

                    if not Player.FlyhackViolationStart then
                        Player.FlyhackViolationStart = tick()
                    end

                    if tick() - Player.FlyhackViolationStart >= 3 then
                        Player.FlyhackViolationStart = nil 
                        task.wait(3)
                    end

                    Root.Velocity = Vector3.new(Root.Velocity.X, 30, Root.Velocity.Z)

                    if HumanoidState ~= Enum.HumanoidStateType.Climbing then
                        Humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
                    end
                end
            end
        end
    end))

    RunService:BindToRenderStep("Desync", Enum.RenderPriority.First.Value, LPH_NO_VIRTUALIZE(function()
        if Client.Character and Client.Character:FindFirstChild("HumanoidRootPart") then
            Client.Character["HumanoidRootPart"].CFrame = Desync.Real
        end
    end))
end

if Workspace:FindFirstChild("SpawnerZones")then
    Connections:Connect(Workspace.SpawnerZones.DescendantAdded, LPH_NO_VIRTUALIZE(function(Descendant)
        task.wait(0.1)
        if Descendant:IsA("MeshPart") and Descendant.Color ~= Color3.fromRGB(100,88,75) and flags["Remove Foliage"] then
            Descendant.Transparency = 1
        end
    end))
end

-- // Lighting Stuff
Connections:Connect(Lighting.Changed, LPH_NO_VIRTUALIZE(function(Property)
    if (Property == "Ambient" or Property == "OutdoorAmbient") and flags["Ambient"] then
        Lighting["Ambient"] = flags["Ambient1"]
        Lighting["OutdoorAmbient"] = flags["Ambient2"] 
    end

    if Property == "ClockTime" and flags["Clock Time"] then
        Lighting["ClockTime"] = flags["Time"]
    end

    if Property == "ExposureCompensation" then
        Lighting["ExposureCompensation"] = flags['Exposure']
    end
end))


--#endregion 

--#region Bindable Events

-- // Hit Event
HitEvent.Event:Connect(LPH_NO_VIRTUALIZE(function(HitInstance)
    if flags["Hitsounds"] then
        local IsHeadshot = string.find(string.lower(HitInstance.Name), "head") or string.find(string.lower(HitInstance.Name), "face")

        Utils:PlayHitsound(IsHeadshot)
    end

    if flags["Hitmarkers"] then
        local Hitmarker = Utils:Instance("ImageLabel", {
            Parent = Visuals.FOVContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(0,25,0,25),
            Visible = false,
            Rotation = 0,
            Image = "rbxassetid://117704376238153",
            AnchorPoint = Vector2.new(0.5,0.5),
            ImageColor3 = flags["Hitmarkers Color"],
            ImageTransparency = 1
        })

        local HitPos, OnScreen = Utils:WorldToViewport(HitInstance.Position)

        if OnScreen then
            Hitmarker.Visible = true 
            Hitmarker.Position = UDim2.fromOffset(HitPos.X, HitPos.Y)
        end

        Utils:Tween(Hitmarker, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            ImageTransparency = 0
        })

        task.delay(flags["Hitmarkers Lifetime"], function()
            local Tween = Utils:Tween(Hitmarker, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                ImageTransparency = 1
            })

            Tween.Completed:Wait()

            Hitmarker:Destroy()
        end)
    end
end))

TracerEvent.Event:Connect(LPH_NO_VIRTUALIZE(function(Origin, Position)
    local Parent = Instance.new("Model", ZenithFolder)
    Parent.Name = "Bullet Tracer"

    local CreateAnchoredPart = function(Position)
        local Part = Instance.new("Part", Parent)
        Part.Name = "AnchoredPart"
        Part.Size = Vector3.new(0.1,0,0)
        Part.Anchored = true 
        Part.Position = Position 
        Part.CanCollide = false 
        Part.CanQuery = false 
        Part.CanTouch = false 
        Part.Transparency = 1

        return Part
    end

    local StartPart = CreateAnchoredPart(Origin)
    local EndPart = CreateAnchoredPart(Origin)

    local Attachment0 = Instance.new("Attachment", StartPart)
    local Attachment1 = Instance.new("Attachment", EndPart)

    local Beam = Instance.new("Beam", Parent)
    Beam.Name = "Tracer"
    Beam.Attachment0 = Attachment0
    Beam.Attachment1 = Attachment1
    Beam.FaceCamera = true 
    Beam.Color = ColorSequence.new(flags["Bullet Tracers Color"])
    Beam.Width0 = 0.5
    Beam.Width1 = 0.5
    Beam.LightEmission = 1
    Beam.LightInfluence = 0
    Beam.Brightness = 1
    Beam.TextureLength = 4
    Beam.TextureSpeed = 10 
    Beam.Texture = "rbxassetid://12781800668"

    Utils:Tween(EndPart, TweenInfo.new(flags["Bullet Tracers Travel Time"], Enum.EasingStyle.Cubic), {
        Position = Position 
    })

    task.delay(flags["Bullet Tracers Lifetime"], function()
        local Tween = Utils:Tween(Beam, TweenInfo.new(0.5, Enum.EasingStyle.Circular), {
            Width0 = 0,
            Width1 = 0,
            TextureSpeed = 0,
            Brightness = 0
        })

        Tween.Completed:Wait()

        Parent:Destroy()
    end)
end))

--#endregion

--#region Hooks

do
    -- // Hooks

    local OldNamecall; OldNamecall = hookmetamethod(game, "__namecall", LPH_NO_VIRTUALIZE(function(self, ...)
        local Args = {...};
        local Method = getnamecallmethod();
        local Traceback = debug.traceback();
        
        if not checkcaller() then
            if Method == "GetAttribute" then
                local Attribute = Args[1];

                if Attribute == "AccuracyDeviation" and flags["Remove Spread"] then
                    return 0.01 
                end

                if Attribute == "ProjectileDrop" and flags["Remove Gravity"] then
                    return 0.01 
                end

                if Attribute == "UpAngle" and flags["Resolve Pitch"] and self.Name ~= Client.Name then
                    return 0 
                end

                if Attribute == "Drag" and flags["Remove Drag"] then
                    return 0
                end

                if Attribute == "JumpCooldown" and flags["Bunny Hop"] then
                    return 0 
                end
            end

            if Method == "Play" then
                if self.ClassName == "AnimationTrack" and (string.find(string.lower(self.Name), "reload") or string.find(string.lower(self.Name), "bolt")) and flags["Instant Reload"] then
                    Args[1] = Args[1] or 0.01 
                    Args[2] = 0.01 
                    Args[3] = 25 
                end
            end

            if Method == "Raycast" then
                if Traceback and string.find(Traceback, ".Bullet") and string.find(Traceback, "onStep") and BaseEntity.TargetPart then

                    if BaseEntity.Manipulated then
                        Args[1] = BaseEntity.ManipulatedPosition
                        Args[2] = (BaseEntity.TargetPart.Position - Args[1]).Unit
                    end

                    if flags["Instant Bullet"] then
                        Args[2] = (BaseEntity.TargetPart.Position - Args[1]).Unit * 9e9
                    end

                    -- // Dont forget to update detection

                    if flags["Freeze Bullets"] then
                        Args[2] = Args[2] * 0
                    end
                    

                    --[[task.spawn(function()
                        if flags["Wallbang"] then

                            if flags["Wallbang Hitscan"] then 
                                print("Hitscanning")
                                local Hitscan = Utils:Hitscan(BaseEntity.TargetPart)

                                if Hitscan then 
                                    print("HItscan Penetrating")
                                    return {
                                        Instance = BaseEntity.TargetPart,
                                        Position = Hitscan,
                                        Normal = Vector3.new(1,0,0),
                                        Material = BaseEntity.TargetPart.Material
                                    }
                                end
                            else
                                print("Penetrating")
                                return {
                                    Instance = BaseEntity.TargetPart,
                                    Position = BaseEntity.TargetPart.Position,
                                    Normal = Vector3.new(1,0,0),
                                    Material = BaseEntity.TargetPart.Material
                                }
                            end
                        end
                    --end)]]
                end
            end

            if Method == "FireServer" then
                if self.Name == "Drowning" and flags["Vodolaz"] then
                    return 
                end

                if self.Name == "ProjectileInflict" then
                    if Traceback and Traceback:find("CharacterController") then
                        return coroutine.yield()
                    end

                    local HitInstance = Args[1]

                    if flags["Instant Bullet"] and Game.ProjectileCodes[Args[3]] then
                        local Info = Game.ProjectileCodes[Args[3]]
                        local Tick = Info.Tick 
                        local Drag = Info.Drag 
                        local MuzzleVelocity = Info.MuzzleVelocity 

                        local Distance = Math:GetDistance(HitInstance.CFrame.p, Camera.CFrame.p)
                        local TimeToHit = Distance / MuzzleVelocity

                        local HitPosition = HitInstance.Position + HitInstance.Velocity * TimeToHit
                        
                        local Delta = (HitPosition - HitInstance.CFrame.p ).Magnitude

                        local BulletSpeed = MuzzleVelocity - Drag * MuzzleVelocity ^ 2 * TimeToHit ^ 2
                        TimeToHit += Delta / BulletSpeed

                        Args[4] = Tick + TimeToHit
                    end

                    task.spawn(function()
                        HitEvent:Fire(HitInstance)
                    end)
                end
            end

            if Method == "InvokeServer" then
                if self.Name == "FireProjectile" then
                    if BaseEntity.Manipulated then
                        Args[1] = (BaseEntity.TargetPart.Position - BaseEntity.ManipulatedPosition).Unit
                    end

                    if flags["Instant Bullet"] then 
                        task.spawn(function()
                            local Ammo = Player.LoadedAmmo;

                            if Ammo then
                                Game.ProjectileCodes[Args[2]] = {
                                    Tick = Args[3],
                                    MuzzleVelocity = Ammo:GetAttribute("MuzzleVelocity"),
                                    Drag = Ammo:GetAttribute("Drag")
                                }
                            end
                        end)
                    end
                end
            end
        end

        return OldNamecall(self, table.unpack(Args))
    end))

    local OldNewIndex; OldNewIndex = hookmetamethod(game, "__newindex", LPH_NO_VIRTUALIZE(function(self, Key, Value)
        if not checkcaller() and self == Camera and Key == "CFrame" and flags["Third Person"] and flags["Third Person Key"].Active then
            Value += Camera.CFrame.LookVector * -flags["Third Person Distance"]
        end

        return OldNewIndex(self, Key, Value)
    end))

    local BulletFunction = Game.Bullet.CreateBullet 

    Hooks:Create(BulletFunction, LPH_JIT_MAX(function(Old, ...)
        local Args = {...};
        
        local AimpartKey

        for Key, Value in Args do
            if typeof(Value) == "Instance" and string.lower(Value.Name) == "aimpart" then
                AimpartKey = Key
            end

            if type(Value) == "string" then
                local Temp = ReplicatedStorage.AmmoTypes:FindFirstChild(Value)

                if Temp then
                    Player.LoadedAmmo = Temp 
                end
            end
        end

        if not AimpartKey then
            return 
        end

        if flags["Aimbot"] and flags["Aimbot Mode"] == "Silent" and BaseEntity.TargetPart then
            local Origin = Camera.CFrame.Position
            local Destination = BaseEntity.TargetPart.Position
            
            if flags["Third Person"] and flags['Third Person Key'].Active then
                Origin = Client.Character.Head 
            end

            if BaseEntity.Manipulated then
                Origin = BaseEntity.ManipulatedPosition
                
                Args[AimpartKey] = {
                    ClassName = "Part",
                    Position = Origin,
                    CFrame = CFrame.new(Origin, Destination)
                }
            else
                Args[AimpartKey] = {
                    ClassName = "Part",
                    CFrame = CFrame.new(Origin, Destination)
                }
            end
        end

        if flags["Bullet Tracers"] and Player.Viewmodel.Muzzle then
            task.spawn(function()
                local Origin = BaseEntity.ManipulatedPosition or Player.Viewmodel.Muzzle.Position
                local Destination = BaseEntity.TargetPart and BaseEntity.TargetPart.Position or Args[AimpartKey].CFrame.LookVector * 5000 

                TracerEvent:Fire(Origin, Destination)
            end)
        end

        task.spawn(function()
            Player.Shooting = true 
            task.wait(0.5)
            Player.Shooting = false 
        end)

        if flags["Multi Bullet"] then
            for Bullet = 1, flags["Bullets Amount"] do
                Old(table.unpack(Args))
            end
        end

        return Old(table.unpack(Args))
    end))

    local ClientUpdate = Game.FPS.updateClient 

    Hooks:Create(ClientUpdate, LPH_JIT_MAX(function(Old, ...)
        local Args = {...};
        
        local HeldItem = Args[1];
    
        if flags["Instant Aim"] then
            HeldItem.AimInSpeed = 0.01
            HeldItem.AimOutSpeed = 0.01
        end

        if flags["Remove Sway"] then
            HeldItem.swayMult = 0
        end

        --[[if flags["Force Firemodes"] then
            HeldItem.FireModes = {"Auto", "Semi"}
        end]]

        if flags["Remove Obstructions"] then
            HeldItem.TouchWallPosY = 0
            HeldItem.TouchWallPosZ = 0
            HeldItem.TouchWallRotX = 0
            HeldItem.TouchWallRotY = 0 
        end

        if flags["Rapid Fire"] then
            HeldItem.FireRate /= flags["Firerate"]
        end

        if flags["Autoshoot"] and flags["Autoshoot Key"].Active and BaseEntity.TargetPart and HeldItem.useModuleName == "RangedWeaponDefault" then
            Game.ItemFunctions.RangedWeaponDefault(HeldItem)
        end

        return Old(table.unpack(Args))
    end))

    local ZoomFunction = Game.CameraSystem.SetZoomTarget 

    Hooks:Create(ZoomFunction, LPH_JIT_MAX(function(Old, ...)
        local Args = {...};

        Args[4] = 0 

        return Old(table.unpack(Args))
    end))

    local MeleeFunction = Game.ItemFunctions.MeleeWeaponDefault

    Hooks:Create(MeleeFunction, LPH_JIT_MAX(function(Old, ...)
        local Args = {...};

        if flags["Remove Cooldown Melee"] then
            Args[1].useDebounce = false 
        end

        return Old(table.unpack(Args))
    end))
end

local InitHooks = function()
    for Index, Value in Hooks.Cache do
        Value:Hook()
    end
end

task.wait(0.1)

InitHooks()

--#endregion

--#region BaseEntity Creating

-- // BaseEntity Creating
BaseEntity:NewFlag({
    Name = "Target",
    Flag = "Target",
    Allow = function(self)
        if BaseEntity.Target and BaseEntity.Target == self.Instance then
            return true 
        end

        return false 
    end
})

BaseEntity:NewFlag({
    Name = "Manipulated",
    Flag = "Manipulated",
    CustomName = function(self)
        if not BaseEntity.Manipulated then
            return ""
        end

        return "MANIPULATED: "..tostring(BaseEntity.ManipulatedPart)
    end,
    Allow = function(self)
        return BaseEntity.Manipulated and BaseEntity.Target == self.Instance
    end
})

BaseEntity:NewFlag({
    Name = "Visible", 
    Flag = "Visible",
    Allow = function(self)
        return self.Status.Visible 
    end
})

for Index, Value in Players:GetPlayers() do
    if Value ~= Client and Value:IsA("Player") then
        BaseEntity:Create(Value)
    end
end

Connections:Connect(Players.PlayerAdded, function(Player)
    BaseEntity:Create(Player)
end)

Connections:Connect(Players.PlayerRemoving, function(Player)
    BaseEntity:Remove(Player)
end)

-- // AI 
for Index, Value in Workspace.AiZones:GetDescendants() do
    if Value:FindFirstChildOfClass("Humanoid") then
        BaseEntity:Create(Value)
    end
end

Connections:Connect(Workspace.AiZones.DescendantAdded, LPH_NO_VIRTUALIZE(function(Descendant)
    if Descendant:FindFirstChildOfClass("Humanoid") then
        BaseEntity:Create(Descendant)
    end
end))

Connections:Connect(Workspace.AiZones.DescendantRemoving, function(Descendant)
    BaseEntity:Remove(Descendant)
end)

--#endregion

--#region MiscEntity Classes
MiscEntity:NewClass({
    Class = "Model",
    Parent = Workspace.DroppedItems,
    Flag = "Corpses",
    GetName = LPH_NO_VIRTUALIZE(function(Object)
        local Name = "Corpse"

        if Object.PrimaryPart then
            local Root = Object.PrimaryPart
            local Distance = (Root.CFrame.p - Camera.CFrame.p).Magnitude / 3

            Name = Object.Name.."'s ".."Corpse".." | "..math.floor(Distance / 3).."m"
        end

        return Name 
    end),
    GetPosition = function(Object)
        if Object.PrimaryPart then
            return Object.PrimaryPart.CFrame.p 
        end
    end,
    Allow = LPH_NO_VIRTUALIZE(function(Object)
        return (Object:FindFirstChild("Clothing") and Object.PrimaryPart)
    end)
})

MiscEntity:NewClass({
    Class = "Part",
    Parent = Workspace.NoCollision.ExitLocations,
    Flag = "Extracts",
    GetName = LPH_NO_VIRTUALIZE(function(Object)
        local Name = "Extract";
        local Distance = (Object.CFrame.p - Camera.CFrame.p).Magnitude 

        Name = Name.." | "..math.floor(Distance / 3).."m"

        return Name 
    end),
    GetPosition = function(Object)
        return Object.CFrame.p 
    end
})
