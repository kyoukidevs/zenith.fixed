-- // My first ui library, shitty ass code...

LPH_NO_VIRTUALIZE = function(...)
	return ...
end

local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
--#pragma region Library

--#region Variables
local IsStudio = false
local Directory = "zenithv2"
local DataModel = game 

if IsStudio then
	gethui = function()
		return script.Parent 
	end
	cloneref = function(reference)
		return reference 
	end
end

local GetService = function(Name)
	return cloneref(DataModel:GetService(Name)) 	
end

local Services = {}

for _, Name in {"Players","TweenService","CoreGui","Workspace","ReplicatedStorage","ReplicatedFirst","RunService","UserInputService","HttpService","TextService"} do
	Services[Name] = GetService(Name)
end

local Client = Services.Players.LocalPlayer
local Mouse = Client:GetMouse()
local Camera = Services.Workspace.CurrentCamera

local Library = {
	TweenTime = 0.2, -- // Mid
	MenuKey = Enum.KeyCode.Insert,

	Folders = {
		Configs = Directory.."/configs",
		Assets = Directory.."/assets"
	},
	Open = false,

	Holder = nil,
	Notifications = {
		Instance = nil
	},
	OpenedFrames = {},
	Garbage = nil,

	Window = nil,
	TargetInfo = nil,
	KeybindList = nil,
	ESPPreview = nil,
	PlayerList = nil ,
	Sections = {},

	Flags = {},
	SetFlags = {},

	Theme = nil,
	Connections = {}
}

Library.Theme = {
	Accent = Color3.fromRGB(205, 143, 255),
	Background = Color3.fromRGB(0,0,12), -- // 18 18 18 ,
	Section = Color3.fromRGB(10,10,18),
	Background2 = Color3.fromRGB(18,18,18), -- // lIGHT 
	Outline2 = Color3.fromRGB(55,55,55), -- // lIGHT 
	Outline = Color3.fromRGB(30,30,30),
	Unselected = Color3.fromRGB(150,150,150),
	Elements = Color3.fromRGB(12,12,18),
	Selected = Color3.new(1,1,1),
	Selected2 = Color3.fromRGB(35,35,35)
}

local Keys = {
	[Enum.KeyCode.Unknown] = "?",

	[Enum.UserInputType.MouseButton1] = "MB1",
	[Enum.UserInputType.MouseButton2] = "MB2",
	[Enum.UserInputType.MouseButton3] = "MB3",

	[Enum.KeyCode.Ampersand] = "&",
	[Enum.KeyCode.Asterisk] = "*",
	[Enum.KeyCode.At] = "@",
	[Enum.KeyCode.BackSlash] = "\\",
	[Enum.KeyCode.Backquote] = "`",
	[Enum.KeyCode.Backspace] = "<-",
	[Enum.KeyCode.Caret] = "^",
	[Enum.KeyCode.Colon] = ":",
	[Enum.KeyCode.Comma] = ",",
	[Enum.KeyCode.Dollar] = "$",
	[Enum.KeyCode.End] = "END",
	[Enum.KeyCode.Equals] = "=",
	[Enum.KeyCode.Escape] = "ESC",
	[Enum.KeyCode.Euro] = "Euro",
	[Enum.KeyCode.GreaterThan] = ">",
	[Enum.KeyCode.Hash] = "#",
	[Enum.KeyCode.Help] = "?",
	[Enum.KeyCode.Home] = "HM",
	[Enum.KeyCode.Insert] = "INS",
	[Enum.KeyCode.LeftAlt] = "LALT",
	[Enum.KeyCode.LeftBracket] = "[",
	[Enum.KeyCode.LeftControl] = "LCTRL",
	[Enum.KeyCode.LeftCurly] = "{",
	[Enum.KeyCode.LeftMeta] = "LMETA",
	[Enum.KeyCode.LeftParenthesis] = "(",
	[Enum.KeyCode.LeftShift] = "LSHIFT",
	[Enum.KeyCode.LeftSuper] = "LWIN",
	[Enum.KeyCode.LessThan] = "<",
	[Enum.KeyCode.Minus] = "-",
	[Enum.KeyCode.MouseLeftButton] = "XBUTTON1",
	[Enum.KeyCode.MouseRightButton] = "XBUTTON2",
	[Enum.KeyCode.MouseMiddleButton] = "MMB",
	[Enum.KeyCode.NumLock] = "NL",
	[Enum.KeyCode.PageDown] = "PD",
	[Enum.KeyCode.PageUp] = "PU",
	[Enum.KeyCode.Percent] = "%",
	[Enum.KeyCode.Period] = ".",
	[Enum.KeyCode.Pipe] = "'",
	[Enum.KeyCode.Plus] = "+",
	[Enum.KeyCode.Power] = "PW",
	[Enum.KeyCode.Question] = "?",
	[Enum.KeyCode.Quote] = "'",
	[Enum.KeyCode.QuotedDouble] = '"',
	[Enum.KeyCode.RightAlt] = "RALT",
	[Enum.KeyCode.RightBracket] = "]",
	[Enum.KeyCode.RightControl] = "RCTRL",
	[Enum.KeyCode.RightCurly] = "}",
	[Enum.KeyCode.RightMeta] = "RMETA",
	[Enum.KeyCode.RightParenthesis] = ")",
	[Enum.KeyCode.RightShift] = "RSHIFT",
	[Enum.KeyCode.RightSuper] = "RWIN",
	[Enum.KeyCode.Semicolon] = ";",
	[Enum.KeyCode.Slash] = "/",

	-- // Numbers
	[Enum.KeyCode.One] = "1",
	[Enum.KeyCode.Two] = "2",
	[Enum.KeyCode.Three] = "3",
	[Enum.KeyCode.Four] = "4",
	[Enum.KeyCode.Five] = "5",
	[Enum.KeyCode.Six] = "6",
	[Enum.KeyCode.Seven] = "7",
	[Enum.KeyCode.Eight] = "8",
	[Enum.KeyCode.Nine] = "9",
	[Enum.KeyCode.Zero] = "0"
}

--[[if IsStudio then
	Utility = require(Services.ReplicatedStorage.Utils)(true)
else
	Utility = loadstring(DataModel:HttpGet("https://raw.githubusercontent.com/kyoukidevs/zenith/refs/heads/main/Libraries/Utils.lua"))(false)
end]]
local Utility = (function()
    local Utils = {}

    function Utils:SafeCall(Callback)
        local Suc, Err = pcall(Callback)
        if not Suc and Err then 
            warn(Err)
        end
    end

    function Utils:CommaValue(Number)
        return tonumber(string.format("%.0f", Number))
    end

    function Utils:Round(Number, Decimals)
        local Mult = 10 ^ (Decimals or 0)
        return math.round(Number * Mult) / Mult
    end

    return Utils 
end)()

local TweenData = TweenInfo.new(Library.TweenTime, Enum.EasingStyle.Quad)
--#endregion Variables 

--#region Library Functions

Library.Connections.__index = Library.Connections 

Library.Instance = function(self, Class, Properties)
	local Instance = Instance.new(Class)

	for Name, Value in Properties do
		Instance[Name] = Value 
	end

	return Instance 
end

Library.Connect = function(self, Name, Signal, Callback)
	local Connection = Signal:Connect(Callback)

	self.Connections[Name] = setmetatable({
		Signal = Signal,
		Callback = Callback,
		Connection = Connection
	}, Library.Connections)

	return self.Connections[Name]
end

Library.Connections.Disconnect = function(self)
	if Library.Connections[self] then
		self.Connection:Disconnect()
		Library.Connections[self] = nil 
	end
end

Library.Connections.Unload = function(self)
	for Index, Value in self.Connections do
		if type(Value) ~= "function" and Value.Connection then
			Value.Connection:Disconnect()
		end
	end

	table.clear(self.Connections)
end

Library.Tween = function(self, ...)
	local ts = Services.TweenService 

	local tween = ts:Create(...)

	tween:Play()

	return tween 
end

Library.GetValue = function(Flag)
	if not Flag.Class then
		return 
	end	

	local Class = Flag.Class 
	local Value = Flag.Value 

	if Class == "Toggle" or Class == "Slider" or Class == "TextBox" or Class == "Dropdown" then
		return Value 
	end

	if Class == "Colorpicker" then
		return {
			Color = Value[1],
			Transparency = Value[2]
		}
	end

	if Class == "Keybind" then
		return {
			Mode = Flag.Mode,
			Key = Flag.Key,
			Value = Flag.Value 
		}
	end
end

Library.UpdatePosition = function(self)
	local flags = self.Flags 
	--local hud = self.TargetInfo 
	local belt = self.TargetBelt 
	local keylist = self.KeybindList 
	local inventory = self.InventoryViewer 

	flags["Hotbar_Pos"] = Vector2.new(belt.Elements.Holder.Position.X.Offset, belt.Elements.Holder.Position.Y.Offset)
	flags["Key_Pos"] =Vector2.new(keylist.Elements.Holder.Position.X.Offset, keylist.Elements.Holder.Position.Y.Offset)
	flags["Inventory_Pos"] = Vector2.new(inventory.Elements.Holder.Position.X.Offset, inventory.Elements.Holder.Position.Y.Offset)
end

Library.SetPosition = function(self)
	local flags = self.Flags

	local hotbar_pos = flags["Hotbar_Pos"]
	local key_pos = flags["Key_Pos"]
	local inv_pos = flags["Inventory_Pos"] 

	local hotbar = self.TargetBelt.Elements.Holder 
	local key = self.KeybindList.Elements.Holder 
	local inv = self.InventoryViewer.Elements.Holder 

	hotbar.Position = UDim2.new(hotbar.Position.X.Scale, hotbar_pos.X, hotbar.Position.Y.Scale, hotbar_pos.Y)
	key.Position =UDim2.new(key.Position.X.Scale, key_pos.X, key.Position.Y.Scale, key_pos.Y)
	inv.Position = UDim2.new(inv.Position.X.Scale, inv_pos.X, inv.Position.Y.Scale, inv_pos.Y)
end

Library.GetConfig = function(self)
	local flags = self.Flags 
	
	self:UpdatePosition()

	local Table = {}

	for Name, Data in flags do
		if type(Data) == "table" and Data.Key then
			Table[Name] = {Key = Data.Key,Mode = Data.Mode}
		elseif typeof(Data) == "Color3" then
			Table[Name] = "#"..Data:ToHex()
		elseif typeof(Data) == "Vector2" then
			Table[Name] = {X = Data.X, Y = Data.Y}
		else
			Table[Name] = Data
		end
	end

	return Services.HttpService:JSONEncode(Table)
end

Library.SaveConfig = function(self, Name : string)
	local cfg = Library:GetConfig()

	writefile(Library.Folders.Configs.."/"..Name..".json", cfg)
end

Library.LoadConfig = function(self, Name)
	local Path = Library.Folders.Configs.."/"..Name

	local Encoded = readfile(Path)
	local Table = Services.HttpService:JSONDecode(Encoded)

	for Index, Value in Table do
		if Library.SetFlags[Index] then
			Library.SetFlags[Index](Value)
		end

		if type(Value) == "table" and Value.X then
			Library.Flags[Index] = Vector2.new(Value.X, Value.Y)
		end

		self:SetPosition()
	end
end

Library.RefreshConfigs = function(self, Dropdown)
	local List = {};
	local Final = {};

	for Index, Value in listfiles(Library.Folders.Configs) do
		local FileName = string.match(Value, "([^/\\]+)$");
		Final[Index] = FileName 
	end

	local IsNew = #Final ~= List 

	if not IsNew then
		for Index = 1, #Final do
			if Final[Index] ~= List[Index] then
				IsNew = true break 
			end
		end
	else
		List = Final 
		Dropdown:Refresh(List)
	end
end

Library.Font = Font.fromId(12187365364, Enum.FontWeight.SemiBold) -- // Inter SemiBold 
Library.BoldFont = Font.fromId(12187365364, Enum.FontWeight.Bold) -- // Inter Bold

--#endregion Library Functions

--#region Library Instances

-- // Instances
Library.Holder = Library:Instance("ScreenGui", {
	Parent = cloneref(gethui()),
	IgnoreGuiInset = true,
	Name = "Library.Holder"
})

Library.Garbage = Library:Instance("ScreenGui", {
	Parent = cloneref(gethui()),
	Enabled = false,
	IgnoreGuiInset = true ,
	Name = "Library.Garbage"
})

Library.Notifications.Instance = Library:Instance("ScreenGui", {
	Parent = cloneref(gethui()),
	IgnoreGuiInset= true ,
	Name = "Notifications.Instance"
})

--#endregion Library Instances

-- // I think we can begin to components 

--#region Keybind List

-- // Keybind List
Library.KeybindList = function(self)
	local List = {
		Elements = {}
	}

	Library.KeybindList = List

	local Elements = {} do
		Elements.Holder = Library:Instance("Frame", {
			Parent = Library.Holder,
			Size = UDim2.new(0,250,0,0),
			Position = UDim2.new(0.05,0,0.5,0),
			AnchorPoint = Vector2.new(0,.5),
			BackgroundColor3 = Library.Theme.Background2,
			AutomaticSize = Enum.AutomaticSize.Y 
		})

		Elements.Title = Library:Instance("Frame", {
			Parent = Elements.Holder,
			Size = UDim2.new(1,0,0,30),
			BackgroundTransparency = 1
		})

		Elements.TitleText = Library:Instance("TextLabel", {
			Parent = Elements.Title,
			BackgroundTransparency = 1,
			FontFace = Library.BoldFont,
			TextSize = 14,
			Text = "Keybinds",
			Size = UDim2.new(1,0,1,0),
			TextStrokeTransparency = 0,
			TextColor3 = Library.Theme.Accent
		})

		Elements.Line = Library:Instance("Frame", {
			Parent = Elements.Holder,
			Position = UDim2.new(),
			Size = UDim2.new(1,0,0,1),
			BackgroundColor3 = Library.Theme.Accent,
			BorderSizePixel = 1,
			BorderColor3 = Color3.new()
		})

		Elements.Keybinds = Library:Instance("Frame", {
			Parent = Elements.Holder,
			Position = UDim2.new(0,0,0,30),
			Size = UDim2.new(1,0,0,1),
			BackgroundColor3 = Library.Theme.Outline,
			BorderSizePixel = 0,
			BorderColor3 = Color3.fromRGB(40,40,40)
		})

		Library:Instance("UIPadding", {
			Parent = Elements.Keybinds,
			PaddingLeft = UDim.new(0,4)
		})

		Library:Instance("UIListLayout", {
			Parent = Elements.Keybinds,
			Padding = UDim.new(0,2)
		})
	end

	List.Elements = Elements

	function List:Add(Name, Key)
		Key = string.upper(Key)
		local NewKey = {
			Holder = Library:Instance("Frame", {
				BackgroundTransparency = 1,
				Parent = self.Elements.Keybinds,
				Size = UDim2.new(1,0,0,20)
			})
		}

		NewKey.Name = Library:Instance("TextLabel", {
			Parent = NewKey.Holder,
			Size = UDim2.new(0.7,0,1,0),
			BackgroundTransparency = 1,
			FontFace = Library.Font,
			TextSize = 14,
			Text = Name ,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Color3.new(1,1,1),
			TextStrokeTransparency = 0
		})

		NewKey.Key = Library:Instance("TextLabel", {
			Parent = NewKey.Holder,
			Position = UDim2.new(0.8,0,0,0),
			BackgroundTransparency = 1,
			FontFace = Library.BoldFont,
			TextSize = 14,
			Text = "["..Key.."]",
			TextColor3 = Library.Theme.Unselected,
			TextStrokeTransparency = 0,
			Size = UDim2.new(0.2,0,1,0)
		})

		function NewKey:Set(Bool, Key)
			if Key then
				self.Key.Text = "["..Key.."]"
			end

			if Bool ~= nil then
				self.Key.TextColor3 = Bool and Color3.fromRGB(0, 180, 0) or Library.Theme.Unselected
			end
		end

		return NewKey
	end

	function List:SetVisible(Bool)
		self.Elements.Holder.Visible = Bool 
	end

	return List 
end

--#endregion Keybind List

Library.TargetBelt = function(self)
	local Belt = {
		Icons = {},
	};

	Library.TargetBelt = Belt 

	local Elements = {} do
		Elements.Holder = Library:Instance("Frame", {
			Parent = Library.Holder,
			Size = UDim2.new(0,300,0,320),
			Position = UDim2.new(0.8,0,0.5,0),
			AnchorPoint = Vector2.new(0,.5),
			BackgroundColor3 = Library.Theme.Background2,
		})

		Elements.Title = Library:Instance("Frame", {
			Parent = Elements.Holder,
			Size = UDim2.new(1,0,0,30),
			BackgroundTransparency = 1
		})

		Elements.TitleText = Library:Instance("TextLabel", {
			Parent = Elements.Title,
			BackgroundTransparency = 1,
			FontFace = Library.BoldFont,
			TextSize = 14,
			Text = "Hotbar Viewer",
			Size = UDim2.new(1,0,1,0),
			TextStrokeTransparency = 0,
			TextColor3 = Library.Theme.Accent
		})

		Elements.Line = Library:Instance("Frame", {
			Parent = Elements.Holder,
			Position = UDim2.new(),
			Size = UDim2.new(1,0,0,1),
			BackgroundColor3 = Library.Theme.Accent,
			BorderSizePixel = 1,
			BorderColor3 = Color3.new()
		})

		Elements.Content = Library:Instance("Frame", {
			Parent = Elements.Holder,
			Position = UDim2.new(0,0,0,30),
			Size = UDim2.new(1,0,0,1),
			BackgroundColor3 = Library.Theme.Outline,
			BorderSizePixel = 0,
			BorderColor3 = Color3.fromRGB(40,40,40)
		})

		Library:Instance("UIPadding", {
			Parent = Elements.Content,
			PaddingLeft = UDim.new(0,4)
		})

		Library:Instance("UIListLayout", {
			Parent = Elements.Content,
			Wraps = true,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0,2)
		})
	end

	Belt.Elements = Elements 

	function Belt:Add(Name, Image)
		if self.Icons[Name] then
			return 
		end

		local Item = {}

		self.Icons[Name] = Item 

		Item.Image = Library:Instance("ImageLabel", {
			Parent = self.Elements.Content,
			Image = Image,
			Size = UDim2.new(0,70,0,70),
			BorderSizePixel = 1,
			BorderColor3 = Library.Theme.Outline2,
			BackgroundColor3 = Library.Theme.Background2 
		})

		return Item 
	end

	function Belt:Clear()
		for Index, Value in self.Icons do
			Value.Image:Destroy()
			self.Icons[Index] = nil 
		end
	end

	function Belt:Remove(Name)
		if self.Icons[Name] then
			self.Icons[Name].Image:Destroy()
			self.Icons[Name] = nil 
		end
	end
	
	function Belt:SetVisible(Bool)
		self.Elements.Holder.Visible = Bool	
	end

	return Belt 
end

--#region Inventory Viewer

Library.InventoryViewer = function(self)
	local Viewer = {}

	self.InventoryViewer = Viewer 

	local Elements = {} do
		Elements.Holder = Library:Instance("Frame",{
			Parent = Library.Holder,
			BackgroundColor3 = Color3.new(),
			Size = UDim2.new(0,250,0,600),
			Position = UDim2.new(0,20,0,20),
			BorderSizePixel= 1,
			BorderColor3 = self.Theme.Accent 
		})

		Elements.Text=  Library:Instance("TextLabel",{
			Parent = Elements.Holder,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(),
			TextColor3 = Color3.new(1,1,1),
			BackgroundTransparency = 1,
			FontFace = Library.Font,
			TextSize = 12,
			TextXAlignment= Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		})

		Library:Instance("UIPadding",{
			Parent = Elements.Text,
			PaddingTop = UDim.new(0,10),
			PaddingLeft = UDim.new(0,10)
		})
	end

	Viewer.Elements = Elements 

	function Viewer:Set(Text)
		self.Elements.Text.Text = Text 
	end

	function Viewer:SetVisible(Bool)
		self.Elements.Holder.Visible = Bool 
	end

	return Viewer 
end

--#endregion
--#region Target HUD

Library.TargetHUD = function(self)
	local HUD = { }

	Library.TargetInfo = HUD 

	local Elements = {} do
		Elements.Holder = Library:Instance("Frame", {
			Parent = Library.Holder,
			Size = UDim2.new(0,400,0,150),
			BackgroundColor3 = Library.Theme.Background,
			Position = UDim2.new(0.5, 0, 0.6, 0),
			BorderSizePixel = 1,
			BorderColor3 = Library.Theme.Accent
		})

		Library:Instance("UIPadding", {
			Parent = Elements.Holder,
			PaddingLeft = UDim.new(0,5)
		})

		Elements.Title = Library:Instance("TextLabel", {
			Parent = Elements.Holder,
			TextStrokeTransparency = 0,
			FontFace = Library.BoldFont,
			TextColor3 = Color3.new(1,1,1),
			TextSize = 14,
			BackgroundTransparency = 1,
			Text = "Target",
			Position=  UDim2.new(),
			Size = UDim2.new(0, 60, 0, 20)
		})

		Elements.Image = Library:Instance("ImageLabel", {
			Parent = Elements.Holder,
			Position = UDim2.new(0, 0, 0.15, 0),
			Size = UDim2.new(0,100,0,100),
			BackgroundTransparency = 1,
		})

		Elements.Visiblity = Library:Instance("TextLabel", {
			Parent = Elements.Holder,
			Position= UDim2.new(0, 0, 0.82, 0),
			Size = UDim2.new(0,100,0,20),
			TextColor3 = Color3.new(1,1,1),
			BackgroundTransparency = 1,
			FontFace = Library.BoldFont,
			TextSize = 14,
			TextStrokeTransparency = 0
		})

		Elements.Nametag = Library:Instance("TextLabel", {
			Parent = Elements.Holder,
			FontFace = Library.BoldFont,
			Size = UDim2.new(0,100,0,30),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 =Color3.new(1,1,1),
			Position = UDim2.new(0.275, 0,0.1,0),
			TextStrokeTransparency = 0,
			TextSize = 17
		})

		Elements.Item = Library:Instance("TextLabel", {
			Parent = Elements.Holder,
			FontFace = Library.BoldFont,
			Size = UDim2.new(0,100,0,20),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.28,0,0.3,0),
			TextColor3 = Color3.new(1,1,1),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextStrokeTransparency = 0,
			TextSize = 14 
		})

		Elements.Flags = Library:Instance("TextLabel", {
			Parent = Elements.Holder,
			FontFace = Library.BoldFont,
			Size = UDim2.new(0,100,0,20),
			BackgroundTransparency = 1,
			TextXAlignment= Enum.TextXAlignment.Left,
			Position = UDim2.new(0.28,0,0.45,0),
			TextColor3 = Color3.new(1,1,1),
			TextStrokeTransparency = 0,
			Text = " 666 K/D, 10000 Hours",
			TextSize = 14 
		})
		--
		Elements.Bar = Library:Instance("Frame", {
			Parent = Elements.Holder,
			Size = UDim2.new(0.7,0,0,30),
			Position = UDim2.new(0.28,0,0.65,0),
			BackgroundColor3 = Color3.new()
		})

		Library:Instance("UICorner", {
			Parent = Elements.Bar,
			CornerRadius = UDim.new(0,8)
		})

		Elements.BarFill = Library:Instance("Frame", {
			Parent = Elements.Bar,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(),
			BackgroundColor3 = Color3.fromRGB(0,170,0)
		})

		Library:Instance("UICorner", {
			Parent = Elements.BarFill,
			CornerRadius = UDim.new(0,8)
		})

		Elements.Health = Library:Instance("TextLabel", {
			Parent = Elements.Bar,
			BackgroundTransparency = 1,
			FontFace= Library.BoldFont,
			TextColor3 = Color3.new(1,1,1),
			Size = UDim2.new(0, 100,1, 0),
			Position =UDim2.new(0.3,0,0,0),
			TextStrokeTransparency = 0,
			TextSize = 17,
			TextXAlignment = Enum.TextXAlignment.Center
		})
	end

	HUD.Elements = Elements

	function HUD:Update(Data)
		Data = Data or {}

		if Data.HealthData then
			local Percent = Data.HealthData.HP / Data.HealthData.MaxHP 
			Elements.BarFill:TweenSize(UDim2.new(Percent,0,1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15)
			Elements.Health.Text = Data.HealthData.HP.."/"..Data.HealthData.MaxHP
		end

		if Data.Item then
			Elements.Item.Text = "Equipped Item: "..Data.Item 
		end

		if Data.Name and Data.Distance then
			Elements.Nametag.Text = Data.Name .." ("..Data.Distance.."m)"
		end

		if Data.KD and Data.Hours then
			Elements.Flags.Text = Data.KD.." K/D, "..Data.Hours.." Hours"
		end

		Elements.Visiblity.Text = Data.Visible and "VISIBLE" or "NOT VISIBLE"
	end

	function HUD:SetVisible(Bool)
		Elements.Holder.Visible = Bool 
	end

	return HUD 
end

--#endregion Target HUD

--#region Important Things

Library.CreateColorpicker = function(self, Data) --
	Data = Data or {}

	local ColorPicker = {
		Name = Data.Name or Data.name or "Colorpicker",
		Flag = Data.Flag or Data.flag or "Unknown",
		Callback = Data.Callback or Data.callback or function()
			
			end,
		Default = Data.Default or Data.default or Color3.new(1,1,1),
		Window = Data.Window,
		Section = Data.Section,
		Value = Color3.new(1,1,1),
		Hue = 0,
		Saturation = 0,
		Val = 0,
		Transparency = 0,
		IsOpen = false 
	}

	local Elements = {} do
		Elements.Button = Library:Instance("TextButton", {
			Parent = Data.Parent,
			Size = UDim2.new(0,20,1,0),
			BackgroundColor3 = ColorPicker.Value,
			Text = ""
		})

		Library:Instance("UIStroke", {
			Parent = Elements.Button,
			Color = Library.Theme.Outline2,
			ApplyStrokeMode= Enum.ApplyStrokeMode.Border 
		})

		Library:Instance("UICorner", {
			Parent = Elements.Button,
			CornerRadius = UDim.new(0,5) -- // Idk, Toggle Corner Radius + 1
		})

		-- // Hardest Shit
		Elements.Window = Library:Instance('Frame', {
			Parent = Library.Garbage,
			Position = UDim2.new(),
			BackgroundColor3 = Library.Theme.Elements,
			Size = UDim2.new(0,165,0,160)

		})

		Elements.Name = Library:Instance("TextLabel", {
			Parent = Elements.Window,
			Position = UDim2.new(),
			Text = ColorPicker.Name,
			TextColor3 = Color3.new(1,1,1),
			FontFace = Library.Font,
			Size = UDim2.new(0.5,0,0,15),
			BackgroundTransparency = 1,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		})

		Elements.Hue = Library:Instance("TextButton", {
			Parent = Elements.Window,
			Size = UDim2.new(0,20,0.9,0),
			Position = UDim2.new(0.8,5,0.05,0),
			BackgroundColor3 = Color3.new(1,1,1),
			Text = "",
			AutoButtonColor = false 
		})

		Elements.HueCursor = Library:Instance("Frame", {
			Parent = Elements.Hue,
			Size = UDim2.new(1,0,0,2),
			Position = UDim2.new(0,0,0.5,0),
			BackgroundColor3 = Color3.new(1,1,1)
		})

		Elements.Pallete = Library:Instance("TextButton", {
			Parent=  Elements.Window,
			Size = UDim2.new(1,-40,1,-35),
			Position = UDim2.new(0,7,0,25),
			BackgroundColor3 = Color3.fromRGB(255,255,255),
			AutoButtonColor = false , 
			Text = ""
		})

		Elements.Saturation = Library:Instance("ImageLabel", {
			Parent = Elements.Pallete,
			Image = "rbxassetid://130624743341203",
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			ZIndex = 2
		})

		Elements.Value = Library:Instance("ImageLabel", {
			Parent = Elements.Pallete,
			Image = "rbxassetid://96192970265863",
			BackgroundTransparency = 1,
			Size = UDim2.new(1,2,1,2),
			ZIndex = 2
		})

		Elements.PalleteCursor = Library:Instance("Frame", {
			Parent= Elements.Pallete,
			BackgroundColor3 = Color3.new(),
			Size = UDim2.new(0,4,0,4),
			Position = UDim2.new(0.5,0,0.5,0), -- // -4 bro,
			ZIndex = 3
		})

		Library:Instance("UICorner", {
			Parent = Elements.PalleteCursor,
			CornerRadius = UDim.new(1,0)
		})

		Library:Instance("UICorner", {
			Parent = Elements.HueCursor,
			CornerRadius = UDim.new(1,0)
		})

		Library:Instance("UIStroke", {
			Parent = Elements.HueCursor,
			Color = Color3.new(),
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		})

		Library:Instance("UICorner", {
			Parent = Elements.Saturation,
			CornerRadius = UDim.new(0,8)
		})

		Library:Instance("UICorner", {
			Parent = Elements.Hue, 
			CornerRadius = UDim.new(0,8)
		})

		Library:Instance("UICorner", {
			Parent = Elements.Pallete,
			CornerRadius= UDim.new(0,8)
		})

		Library:Instance("UIPadding", {
			Parent = Elements.Name,
			PaddingLeft = UDim.new(0,10),
			PaddingTop = UDim.new(0,10)
		})

		Library:Instance("UICorner", {
			Parent = Elements.Window,
			CornerRadius = UDim.new(0,8)
		})

		Library:Instance("UIStroke", {
			Parent = Elements.Window,
			Color = Library.Theme.Outline,
			Thickness = 1
		})

		Library:Instance("UIGradient", {
			Parent = Elements.Hue,
			Rotation= 270,
			Color= ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), 
				ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)), 
				ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)), 
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)), 
				ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)), 
				ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)), 
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
			})
		})
	end

	ColorPicker.Elements = Elements 

	function ColorPicker:GetColor()
		return self.Value.Color 
	end

	local Conn 
	local Debounce = false 

	function ColorPicker:SetOpen(Bool)
		if Debounce then
			return 
		end

		Debounce = true

		self.IsOpen = Bool 
		Bool = self.IsOpen


		if Bool then
			self.Elements.Window.Visible = true 
			self.Elements.Window.Parent = Library.Holder

			Conn = Services.RunService.RenderStepped:Connect(function(deltaTime)
				self.Elements.Window.Position = UDim2.new(0, self.Elements.Button.AbsolutePosition.X + 20, 0, self.Elements.Button.AbsolutePosition.Y + 10)
			end)

			Library.OpenedFrames[self.Flag] = self
		elseif Conn then
			Library.OpenedFrames[self.Flag] = nil 
			Conn:Disconnect()
			Conn=  nil 
		end

		Debounce = false

		if not Bool then 
			self.Elements.Window.Parent = Library.Garbage
		end
	end

	local DraggingPallete = false 
	local DraggingHue = false 

	function ColorPicker:Update()
		ColorPicker.Window.CanDrag = not (DraggingPallete and DraggingHue)

		local h,s,v = self.Hue, self.Saturation, self.Val 

		self.Value = Color3.fromHSV(h,s,v)

		Library.Flags[self.Flag] = self.Value 
		
		Utility:SafeCall(self.Callback)

		Library:Tween(self.Elements.Button, TweenData, {
			BackgroundColor3 = self.Value
		})

		Library:Tween(self.Elements.Pallete, TweenData, {
			BackgroundColor3 = Color3.fromHSV(h,1,1)
		})
	end

	function ColorPicker:DragPallete(Input)
		if not Input or not DraggingPallete then
			return 
		end

		local ValueX= math.clamp(1 - (Input.Position.X - self.Elements.Pallete.AbsolutePosition.X) / self.Elements.Pallete.AbsoluteSize.X, 0, 1)
		local ValueY = math.clamp(1 - (Input.Position.Y - self.Elements.Pallete.AbsolutePosition.Y) / self.Elements.Pallete.AbsoluteSize.Y, 0, 1)

		self.Saturation = ValueX 
		self.Val = ValueY 

		local SlideX = math.clamp((Input.Position.X - self.Elements.Pallete.AbsolutePosition.X) / self.Elements.Pallete.AbsoluteSize.X, 0, 0.98)
		local SlideY = math.clamp((Input.Position.Y - self.Elements.Pallete.AbsolutePosition.Y) / self.Elements.Pallete.AbsoluteSize.Y, 0, 0.98)

		Library:Tween(self.Elements.PalleteCursor, TweenData, {
			Position = UDim2.new(SlideX, 0, SlideY, 0)
		})
		self:Update()
	end

	function ColorPicker:DragHue(Input)
		if not Input or not DraggingHue then
			return 
		end

		local Value = math.clamp(1 - (Input.Position.Y - self.Elements.Hue.AbsolutePosition.Y) / self.Elements.Hue.AbsoluteSize.Y, 0, 1)

		self.Hue = Value

		local SlideY = math.clamp((Input.Position.Y - self.Elements.Hue.AbsolutePosition.Y) / self.Elements.Hue.AbsoluteSize.Y, 0, 0.99)

		Library:Tween(self.Elements.HueCursor, TweenData, {
			Position = UDim2.new(0,0,SlideY,0)
		})
		self:Update()
	end

	function ColorPicker:Set(Color)
		if type(Color) == "table" then
			Color = Color3.fromRGB(Color[1], Color[2], Color[3])
		elseif type(Color) == "string" then
			Color = Color3.fromHex(Color)
		end

		self.Hue, self.Saturation, self.Val = Color:ToHSV()
		self.Value = Color 

		local ValueX = math.clamp(1 - self.Saturation, 0, 0.98)
		local ValueY = math.clamp(1 - self.Val, 0, 0.98)

		local HuePos = math.clamp(self.Hue, 0, 0.99) -- // HueSos

		Library:Tween(self.Elements.PalleteCursor, TweenData, {
			Position = UDim2.new(ValueX, 0, ValueY, 0)
		})

		Library:Tween(self.Elements.HueCursor, TweenData, {
			Position = UDim2.new(0,0,HuePos,0)
		})

		self:Update()
	end

	Library:Connect(ColorPicker.Name.." Opening", ColorPicker.Elements.Button.MouseButton1Down, function()
		ColorPicker:SetOpen(not ColorPicker.IsOpen)
	end)

	Services.UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			DraggingPallete = false 
			DraggingHue = false 
		end
	end)

	Services.UserInputService.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			if DraggingPallete then
				ColorPicker:DragPallete(Input)
			elseif DraggingHue then
				ColorPicker:DragHue(Input)
			end
		end
	end)

	Library:Connect(ColorPicker.Name.." Pallete Dragging", ColorPicker.Elements.Pallete.InputBegan, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			ColorPicker.Window.InDragging = true 
			DraggingPallete = true 

			ColorPicker:DragPallete(Input)
		end
	end)

	Library:Connect(ColorPicker.Name.." Hue Dragging", ColorPicker.Elements.Hue.InputBegan, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			ColorPicker.Window.InDragging = true 
			DraggingHue = true 

			ColorPicker:DragHue(Input)
		end
	end)

	ColorPicker:Set(ColorPicker.Default)

	Library.SetFlags[ColorPicker.Flag] = function(Color)
		ColorPicker:Set(Color)
	end

	return ColorPicker 
end

Library.CreateKeybind = function(self, Data)
	local Keybind = {
		Value = false,
		Picking = false,
		IsOpen = false,   

		Mode = Data.Mode or "Toggle",
		Flag = Data.Flag,
		Key = tostring(Data.Key),
		Name = Data.Name,
		Callback = Data.Callback or Data.callback or function ()
			
		end,
		Section = Data.Section,
		Window = Data.Window,
		Default = Data.Default 
	}

	local Convert = function(Key : string)
		if Keys[Key] then
			return string.lower(Keys[Key])
		end

		local Text = string.gsub(Key, "Enum.KeyCode.", "")
		Text = string.gsub(Text, "Enum.UserInputType.", "")

		return string.lower(Text)
	end

	local ListItem = Library.KeybindList:Add(Keybind.Name, Convert(Keybind.Key))

	local Elements = {} do
		Elements.Button = Library:Instance("TextButton", {
			Parent = Data.Parent,
			Size = UDim2.new(0.9,0,1,0),
			BackgroundColor3 = self.Theme.Elements,
			AutoButtonColor = false,
			Text = Convert(Keybind.Key),
			TextSize = 14,
			TextColor3 = Color3.new(1,1,1),
			FontFace = self.Font 
		})

		Library:Instance("UIStroke", {
			Parent = Elements.Button,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = self.Theme.Outline,
			Thickness = 1
		})

		Library:Instance("UICorner", {
			Parent = Elements.Button,
			CornerRadius = UDim.new(0,8)
		})

		Elements.Window = Library:Instance("Frame", {
			Parent = Library.Garbage,
			BackgroundColor3 = Library.Theme.Elements,
			Size = UDim2.new(0,150,0,70),
			ZIndex = 55
		})

		Library:Instance("UIStroke", {
			Parent = Elements.Window,
			Color = self.Theme.Outline,
			Thickness = 1
		})

		Library:Instance("UICorner", {
			Parent = Elements.Window,
			CornerRadius = UDim.new(0,8)
		})

		Library:Instance("UIPadding", {
			Parent = Elements.Window,
			PaddingBottom = UDim.new(0.05,0),
			PaddingTop = UDim.new(0.05,0)
		})

		Library:Instance("UIListLayout", {
			Parent = Elements.Window,
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		Elements.Toggle = Library:Instance("TextButton",{
			Parent = Elements.Window,
			BackgroundTransparency = 1,
			TextColor3 = Keybind.Mode == "Toggle" and Library.Theme.Selected or Library.Theme.Unselected,
			FontFace = Library.Font,
			TextSize = 14,
			Size = UDim2.new(1,0,0.3,0),
			Text = 'Toggle',
			ZIndex = 56,
			AutoButtonColor = false
		})

		Elements.Hold = Library:Instance("TextButton",{
			Parent = Elements.Window,
			BackgroundTransparency = 1,
			TextColor3 = Keybind.Mode == "Hold" and Library.Theme.Selected or Library.Theme.Unselected,
			FontFace = Library.Font,
			TextSize = 14,
			Size = UDim2.new(1,0,0.3,0),
			ZIndex = 56,
			Text ='Hold',
			AutoButtonColor = false
		})

		Elements.Always = Library:Instance("TextButton",{
			Parent = Elements.Window,
			BackgroundTransparency = 1,
			TextColor3 = Keybind.Mode == "Always" and Library.Theme.Selected or Library.Theme.Unselected,
			FontFace = Library.Font,
			TextSize = 14,
			Size = UDim2.new(1,0,0.3,0),
			ZIndex = 56,
			Text = "Always",
			AutoButtonColor = false
		})
	end

	Keybind.Elements = Elements 

	local KeybindConnection
	local KeybindConnection2

	local Debounce = false 
	local Renderstepped

	function Keybind:SetOpen(Bool : boolean) 
		if Debounce then
			return 
		end

		Debounce = true 

		self.IsOpen = Bool 

		if Bool then
			self.Elements.Window.Parent = Library.Holder 
			Renderstepped = Services.RunService.RenderStepped:Connect(function(Delta)
				self.Elements.Window.Position = UDim2.new(0, self.Elements.Button.AbsolutePosition.X + 70, 0, self.Elements.Button.AbsolutePosition.Y + 50)
			end) 
			Library.OpenedFrames[self.Flag] = self
		elseif Renderstepped then
			Library.OpenedFrames[self.Flag] = nil 
			Renderstepped:Disconnect()
			Renderstepped = nil 
		end

		Debounce = false 

		if not Bool then
			self.Elements.Window.Parent = Library.Garbage
		end
	end

	function Keybind:Set(Key : string)
		Key = tostring(Key)
		self.Key = Key

		ListItem:Set(nil, Convert(self.Key))
		self.Elements.Button.Text = Convert(self.Key)

		Library.Flags[self.Flag] = {
			Mode = self.Mode,
			Key = self.Key ,
			Active = self.Value 
		}
	end

	function Keybind:SetMode(Mode : string)
		self.Mode = Mode 

		self.Elements.Toggle.TextColor3 = Library.Theme.Unselected
		self.Elements.Hold.TextColor3 = Library.Theme.Unselected
		self.Elements.Always.TextColor3 = Library.Theme.Unselected

		self.Elements[Mode].TextColor3 = Library.Theme.Selected


		if self.Mode == "Always" then
			Keybind:Press()
		end

		Library.Flags[self.Flag] = {
			Mode = self.Mode,
			Key = self.Key,
			Active = self.Value 
		}
	end

	function Keybind:Press(Bool : boolean)
		if self.Mode == "Toggle" then
			self.Value = not self.Value 
		elseif self.Mode == "Hold" then
			self.Value = Bool 
		else
			self.Value = true 
		end
		
		Library.Flags[self.Flag] = {
			Mode = self.Mode,
			Key = self.Key,
			Active = self.Value
		}

		Utility:SafeCall(self.Callback)
		ListItem:Set(self.Value, Convert(self.Key))
	end

	KeybindConnection = Services.UserInputService.InputBegan:Connect(function(Input : table)
		if Keybind.IsOpen and Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Keybind:SetOpen(false)
		end

		if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key then
			if Keybind.Mode == "Toggle" or Keybind.Mode == "Always" then
				Keybind:Press()
			else
				Keybind:Press(true)
			end
		end
	end)

	KeybindConnection2 = Services.UserInputService.InputEnded:Connect(function(Input : table)
		if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key then
			if Keybind.Mode == "Hold" then
				Keybind:Press(false)
			end
		end
	end)

	local InputBegan 

	Keybind.Elements.Button.MouseButton2Down:Connect(function()
		Keybind:SetOpen(not Keybind.IsOpen)	
	end)

	Keybind.Elements.Toggle.MouseButton1Down:Connect(function()
		if Keybind.Mode ~= "Toggle" then
			Keybind:SetMode("Toggle")
		end
	end)

	Keybind.Elements.Hold.MouseButton1Down:Connect(function()
		if Keybind.Mode ~= "Hold" then
			Keybind:SetMode("Hold")
		end
	end)

	Keybind.Elements.Always.MouseButton1Down:Connect(function()
		if Keybind.Mode ~= "Always" then
			Keybind:SetMode("Always")
		end
	end)

	Library:Connect(Keybind.Flag.." Picking", Keybind.Elements.Button.MouseButton1Down, function()
		Keybind.Picking = not Keybind.Picking 

		if Keybind.Picking then
			Keybind.Elements.Button.Text = "..."

			task.wait(0.05)
			InputBegan = Services.UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseMovement then return end 

				if Input.UserInputType == Enum.UserInputType.Keyboard then
					Keybind:Set(Input.KeyCode)
				else
					Keybind:Set(Input.UserInputType)
				end

				Keybind.Picking = false 
				InputBegan:Disconnect()
				InputBegan = nil 
			end)
		elseif InputBegan then
			InputBegan:Disconnect()
			InputBegan = nil 

			Keybind.Elements.Button.Text = Convert(Keybind.Key)
		end
	end)

	Library.SetFlags[Keybind.Flag] = function(Table)
		if Table.Key then
			Keybind:Set(Table.Key)
		end

		if Table.Mode then
			Keybind:SetMode(Table.Mode)
		end
	end

	Keybind:SetMode(Keybind.Mode); Keybind:Set(Keybind.Key) -- // Default
end

--#endregion Important Things 

--#pragma region Create

Library.Create = function(self, Properties)

	Properties = Properties or {}

	local Holder = {
		Window = {
			Elements = {},
			Tabs = {},
			Size = Properties.Size or UDim2.new(0,200,0,500),
			IsOpen = false,
			Name = Properties.Name or Properties.name or "Window",
			Icon = "rbxassetid://16220661409",
			Version = Properties.Version or Properties.version or "Developer",
			GameName = Properties.GameName or Properties.gamename or "Baseplate",
			CanDrag = false
		},
		KeybindList = Library:KeybindList(),
		--InventoryViewer = Library:InventoryViewer(),
		--TargetBelt = Library:TargetBelt(),
		Elements = {}
	}

	--#pragma region Holder
--[[
	function Holder:Button(Data)
		Data = Data or { }

		local Button = {
			Default = Data.Default or Data.default or false,
			Callback = Data.Callback or Data.callback or function ()
				
			end,
			Image = Data.Image or Data.image ,
			Value = false
		}

		if not string.find(Button.Image, "rbxasset") then
			Button.Image = "rbxassetid://"..Button.Image 
		end

		if not Button.Image then Button.Image = "rbxasset://Images/Default.png"
		end

		if not self.Elements.Panel then return end  

		local Elements = {} do
			Elements.Button = Library:Instance("ImageButton", {
				Parent = self.Elements.Panel,
				BackgroundTransparency = 0,
				BackgroundColor3 = Library.Theme.Background2,
				Position = UDim2.new(0,0,0,0),
				ImageColor3 = Library.Theme.Unselected,
				AutoButtonColor = false,
				Size = UDim2.new(0,35,1,0),
				Image = Button.Image
			}) 

			Library:Instance("UICorner", {
				Parent = Elements.Button,
				CornerRadius = UDim.new(0,8)
			})

			Library:Instance("UIStroke", {
				Parent = Elements.Button,
				Color = Library.Theme.Outline2
			})
		end

		Button.Elements = Elements

		function Button:Set(Bool : boolean)
			self.Value = Bool 
			
			Button.Callback(Bool)

			self.Elements.Button.ImageColor3 = Bool and Library.Theme.Accent or Library.Theme.Unselected
		end


		Button.Elements.Button.MouseButton1Down:Connect(function()
			Button:Set(not Button.Value)
		end)

		Button:Set(Button.Default)

		return Button  
	end
]]
	function Holder:SetOpen(Bool)
		self.IsOpen = Bool 
		self.Elements.Background.Visible =  self.IsOpen

		if not Bool then
			for Ind3x, Value in Library.OpenedFrames do
				Value:SetOpen(false)
			end
		end
	end

	--[[Library:Connect("Holder Opening", Services.UserInputService.InputBegan, function(Input)
		if tostring(Input.UserInputType) == Library.MenuKey or tostring(Input.KeyCode) == Library.MenuKey then
			Holder:SetOpen(not Holder.IsOpen)
		end
	end)]]


	local Elements = { } do
		-- // Main 
		Elements.Background = Library:Instance("Frame", {
			Parent = Library.Holder,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(),
			BackgroundColor3 = Color3.new(),
			BackgroundTransparency = 0.5 
		})

		--[[Elements.Panel = Library:Instance("Frame", {
			Parent = Elements.Background,
			Size = UDim2.new(0,250,0,45),
			Position = UDim2.new(0.5,0,0.1,0),
			BackgroundColor3 = Library.Theme.Background
		})

		-- // Misc 
		Library:Instance("UICorner", {
			Parent = Elements.Panel,
			CornerRadius = UDim.new(0,8)
		})

		Library:Instance("UIListLayout", {
			Parent = Elements.Panel,
			Padding = UDim.new(0,6),
			FillDirection = Enum.FillDirection.Horizontal
		})

		Library:Instance("UIPadding", {
			Parent = Elements.Panel,
			PaddingBottom = UDim.new(0,6),
			PaddingTop = UDim.new(0,6),
			PaddingLeft = UDim.new(0.25,0),
			PaddingRight = UDim.new(0.25,0)
		})

		Library:Instance("UIStroke", {
			Parent = Elements.Panel,
			Color = Library.Theme.Outline2 ,
			Thickness = 1 
		})]]
	end

	Holder.Elements = Elements

	--#endregion Holder

	--#pragma region Window

	Elements = {} do

		-- // Main
		Elements.Main = Library:Instance("Frame", {
			Parent = Holder.Elements.Background,
			BackgroundColor3 = self.Theme.Background,
			Size = UDim2.new(0,520,0,700),
			Visible = true,
			Position = UDim2.new(0.45,0,0.2,0)
		})

		Elements.NameSpace = Library:Instance("Frame", {
			Parent = Elements.Main,
			Size = UDim2.new(1,0,0.05,0),
			BackgroundTransparency = 1,
			Position = UDim2.new()
		})

		Elements.TabSpace = Library:Instance("Frame", {
			Parent = Elements.Main,
			Position = UDim2.new(0,0,0.05,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0.03,0)
		})

		Elements.Image = Library:Instance("ImageLabel",{
			Parent = Elements.NameSpace,
			Image = Holder.Window.Icon,
			Position = UDim2.new(),
			Size = UDim2.new(0.05,0,1,0),
			BackgroundTransparency = 1
		})

		Elements.Name = Library:Instance("TextLabel", {
			Parent = Elements.NameSpace,
			BackgroundTransparency = 1,
			Text = Holder.Window.Name .. " | " .. Holder.Window.GameName .. " [Version: "..Holder.Window.Version.."]",
			FontFace = Library.Font,
			TextSize = 14,
			Size = UDim2.new(0.5,0,1,0),
			Position =UDim2.new(0.06,0,0,0),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Color3.new(1,1,1)
		})	
--[[
		Elements.Bar = Library:Instance("Frame", {
			Parent = Elements.Main,
			Size = UDim2.new(1,0,0,1),
			Position = UDim2.new(0,0,0.04,0),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(35,35,35)
		})
]]
		Elements.Content = Library:Instance("Frame", {
			Parent = Elements.Main,
			Position = UDim2.new(0,0,0.08,0),
			Size = UDim2.new(1,0,0.92,0),
			BackgroundTransparency = 1
		})

		-- // Misc
		Library:Instance("UIListLayout", {
			Parent = Elements.TabSpace,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding =UDim.new()
		})

		Library:Instance("UICorner", {
			Parent = Elements.Main,
			CornerRadius = UDim.new(0,8)
		})

		Library:Instance("UIPadding", {
			Parent = Elements.Main,
			PaddingLeft = UDim.new(0,10),
			PaddingRight = UDim.new(0,10),
			PaddingBottom = UDim.new(0,10)
		})

		Library:Instance("UIPadding",{
			Parent = Elements.NameSpace,
			PaddingTop = UDim.new(0,5),
			PaddingLeft = UDim.new(0,5),
			PaddingRight = UDim.new(0,5),
			PaddingBottom = UDim.new(0,8)
		})

	end

	local Window = Holder.Window 

	Window.Elements = Elements 

	do -- // Dragging
		local Dragging = false 
		local StartPos = nil 
		local InputPos = nil 
		local UIS = Services.UserInputService

		local Update = function(Input)
			local Delta = Input.Position - InputPos

			Window.Elements.Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
		end

		UIS.InputEnded:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Dragging = false 
			end
		end)

		UIS.InputChanged:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement and Dragging and Window.CanDrag then
				Update(Input)
			end
		end)

		Window.Elements.Main.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and Window.CanDrag then
				InputPos = Input.Position
				Dragging = true 
				StartPos = Window.Elements.Main.Position
			end
		end)
	end 

	--[[function Window:SetOpen(Bool)
		self.IsOpen = Bool 
		self.Elements.Main.Visible = Bool 	
	end]]

	function Window:Tab(Data)
		Data = Data or {}

		local Tab = {
			Name = Data.Name or Data.name or "Tab",
			Sections = {},
			Columns = {},
			Window = self,
			IsOpen = false 
		}

		local Elements = {} do
			-- // Main
			Elements.Line = Library:Instance("Frame", {
				Parent = Tab.Window.Elements.TabSpace,
				Size = UDim2.new(0,70,0,1),
				Position = UDim2.new(),
				BorderSizePixel = 0,
				BackgroundColor3 = Library.Theme.Outline
			})

			Elements.Button = Library:Instance("TextButton", {
				Parent = Elements.Line,
				Size = UDim2.new(1,0,1,0),
				Text = Tab.Name,
				BackgroundTransparency = 1,
				TextColor3 = Library.Theme.Unselected,
				FontFace = Library.Font, -- // Bold Font 
				TextSize = 14,
				TextStrokeTransparency = 0,
				TextXAlignment = Enum.TextXAlignment.Center 
			})

			Elements.Content = Library:Instance("ScrollingFrame", {
				Parent = Library.Garbage,
				BackgroundTransparency = 1,
				Size = UDim2.new(1,0,1,0),
				ScrollBarThickness = 0 
			})

			-- // Misc 
			Library:Instance("UIPadding", {
				Parent = Elements.Line,
				PaddingBottom = UDim.new(0,25)
			})
		end

		Tab.Elements = Elements

		function Tab:SetOpen(Bool)
			Tab.IsOpen = Bool 
			Bool = Tab.IsOpen

			if Bool then
				self.Elements.Content.Parent = self.Window.Elements.Content 
			else
				self.Elements.Content.Parent = Library.Garbage
			end

			if Bool then

				Library:Tween(self.Elements.Line, TweenData, {
					BackgroundColor3 = Library.Theme.Accent 
				})

				Library:Tween(self.Elements.Button, TweenData, {
					TextColor3 = Library.Theme.Accent 
				})
			else

				Library:Tween(self.Elements.Line, TweenData, {
					BackgroundColor3 = Library.Theme.Outline 
				})

				Library:Tween(self.Elements.Button, TweenData, {
					TextColor3 = Library.Theme.Unselected
				})
			end
		end

		-- // #subregion Section, #region Tab 
		function Tab:Section(Data)
			local Section = {
				Name = Data.Name or Data.name or "Section",
				Tab= self,
				Multi = Data.Multi or Data.multi or false,
				Window = self.Window,
				Side = Data.Side or 1
			}

			local Elements = {} do
				-- // Main
				Elements.Main = Library:Instance("Frame", {
					Parent = Section.Tab.Columns[Section.Side],
					Size = UDim2.new(1,0,0,0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Library.Theme.Section
				})

				Elements.Name = Library:Instance("TextLabel", {
					Parent = Elements.Main,
					FontFace = Library.Font, -- // Bold Font
					TextSize = 14,
					BackgroundTransparency = 1,
					Text = Section.Name, 
					TextColor3 = Color3.new(1,1,1),
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0,0,0,20),
					Position = UDim2.new(),
					TextStrokeTransparency = 0.5
				})

				Elements.Content = Library:Instance("Frame", {
					Parent = Elements.Main,
					Position = UDim2.new(0,0,0,28),
					Size = UDim2.new(1,0,0,0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1 
				})

				-- // Misc
				Library:Instance("UICorner", {
					Parent = Elements.Main,
					CornerRadius = UDim.new(0,8)
				})

				Library:Instance("UIStroke", {
					Parent = Elements.Main,
					Thickness = 0.5,
					Color = Library.Theme.Outline
				})

				Library:Instance("UIPadding", {
					Parent = Elements.Main,
					PaddingTop = UDim.new(0,5),
					PaddingBottom= UDim.new(0,10),
					PaddingRight = UDim.new(0,10),
					PaddingLeft = UDim.new(0,10)
				})

				Library:Instance("UIListLayout", {
					Parent = Elements.Content,
					Padding = UDim.new(0,8),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				})
			end

			Section.Elements = Elements

			--#subregion Toggle, #region Section

			function Section:Toggle(Data)
				local Toggle = {
					Name = Data.Name or Data.name or "Toggle",
					Value = false,
					Section = self,
					Default = Data.Default or Data.default or false ,
					Window = self.Window,
					Elements = {},
					Callback = Data.Callback or Data.callback or function ()

					end,
					Flag = Data.Flag or Data.flag or "Unknown"
				}

				local Elements = { } do
					Elements.Button = Library:Instance("TextButton", {
						Parent = Toggle.Section.Elements.Content,
						Size = UDim2.new(0.6,0,0,20),
						BackgroundTransparency = 1,
						Text = ""
					})

					Elements.Indicator = Library:Instance("TextLabel", {
						Parent = Elements.Button,
						Size = UDim2.new(0.15,0,1,0),
						BackgroundColor3 = Library.Theme.Accent,
						Text = ""
					})

					Elements.Name = Library:Instance("TextLabel", {
						Parent = Elements.Button,
						FontFace = Library.Font,
						TextSize = 14,
						Size = UDim2.new(0.85,0,1,0),
						TextColor3 =Library.Theme.Unselected,
						BackgroundTransparency = 1,
						TextStrokeTransparency = 0,
						Text = Toggle.Name,
						TextXAlignment = Enum.TextXAlignment.Left,
						Position = UDim2.new(0.2,0,0,0) 
					})

					Elements.MiscSpace = Library:Instance("Frame", {
						Parent = Elements.Button,
						Size = UDim2.new(0.7,0,1,0),
						Position = UDim2.new(1,0,0,0),
						BackgroundTransparency = 1
					})

					Library:Instance("UIListLayout", {
						Parent = Elements.MiscSpace,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0,5)
					})

					Library:Instance("UICorner", {
						Parent = Elements.Indicator,
						CornerRadius = UDim.new(0,4)
					})

					Library:Instance("UIStroke", {
						Parent = Elements.Indicator,
						Color = Color3.fromRGB(35,35,35),
						Thickness = 1,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border 
					})
				end

				Toggle.Elements = Elements

				function Toggle:Set(Value)
					self.Value = Value 
					Value = self.Value 

					if Value then

						Library:Tween(self.Elements.Indicator, TweenData, {
							BackgroundTransparency = 0 
						})

						Library:Tween(self.Elements.Name, TweenData, {
							TextColor3 = Library.Theme.Selected
						})

					else

						Library:Tween(self.Elements.Indicator, TweenData, {
							BackgroundTransparency = 1
						})

						Library:Tween(self.Elements.Name, TweenData, {
							TextColor3 = Library.Theme.Unselected
						})

					end

					Library.Flags[self.Flag] = Value 

					Utility:SafeCall(self.Callback)
				end

				function Toggle:Colorpicker(Data)
					Data = Data or {}

					Data.Window = self.Window 
					Data.Section = self.Section 
					Data.Parent = self.Elements.MiscSpace

					Library:CreateColorpicker(Data)
				end

				function Toggle:Keybind(Data)
					Data = Data or {};

					Data.Default = Data.Default or Enum.KeyCode.Unknown
					Data.Section = self.Section 
					Data.Parent = self.Elements.MiscSpace 
					Data.Window = self.Window 

					Library:CreateKeybind(Data)
				end

				Library.SetFlags[Toggle.Flag] = function(Value)
					Toggle:Set(Value)	
				end

				Library:Connect(Toggle.Name.." Toggle Setting", Toggle.Elements.Button.MouseButton1Down, function()
					Toggle:Set(not Toggle.Value)
				end)

				Toggle:Set(Toggle.Default)

				return Toggle 
			end

			--#endsubregion Toggle, #region Section

			--#subregion Slider, #region Section 

			function Section:Slider(Data)
				Data = Data or {}

				local Slider = {
					Name = Data.Name or Data.name or "Slider",
					Min = Data.Min or Data.min or 0,
					Max = Data.Max or Data.max or 100,
					Default = Data.Default or Data.default or 100,
					Callback = Data.Callback or Data.callback or function()
						
						end,
					Decimals = Data.Decimals or Data.decimals or 1,
					Flag = Data.Flag or Data.flag or "Unknown",

					Value = 100,
					Window = self.Window,
					Section = self 
				}

				local Elements = {} do
					Elements.Holder = Library:Instance("Frame", {
						Parent = Slider.Section.Elements.Content,
						BackgroundTransparency = 1,
						Size = UDim2.new(1,0,0,30)
					})

					Elements.Name = Library:Instance("TextLabel", {
						Parent = Elements.Holder,
						Position = UDim2.new(),
						Size = UDim2.new(0.5,0,0,10),
						BackgroundTransparency = 1,
						TextColor3 = Library.Theme.Unselected,
						TextSize = 14,
						FontFace = Library.Font,
						Text = Slider.Name,
						TextXAlignment = Enum.TextXAlignment.Left
					})

					Elements.Value = Library:Instance("TextLabel", {
						Parent = Elements.Holder,
						Position = UDim2.new(0.5,0,0,0),
						Size = UDim2.new(0.5,0,0,10),
						BackgroundTransparency = 1,
						TextColor3 = Color3.new(1,1,1),
						TextSize = 14,
						FontFace = Library.Font,
						Text = Slider.Value,
						TextXAlignment = Enum.TextXAlignment.Right
					})

					Elements.Bar = Library:Instance("Frame", {
						Parent = Elements.Holder,
						Position = UDim2.new(0,0,0.7,0),
						Size = UDim2.new(1,0,0.15,0),
						BackgroundColor3 = Library.Theme.Elements
					})

					Elements.BarFill = Library:Instance("Frame", {
						Parent = Elements.Bar,
						Size = UDim2.new(0,0,1,0),
						Position= UDim2.new(),
						BackgroundColor3 = Library.Theme.Accent,
					})

					Elements.Circle = Library:Instance("Frame", {
						Parent = Elements.BarFill,
						Size = UDim2.new(0,10,2,0),
						Position = UDim2.new(1,-10,-0.5,0),
						BackgroundColor3 =Color3.new(1,1,1)
					})

					Library:Instance("UICorner", {
						Parent = Elements.Bar,
						CornerRadius = UDim.new(0,8)
					})

					Library:Instance("UICorner", {
						Parent = Elements.BarFill,
						CornerRadius = UDim.new(0,8)
					})

					Library:Instance("UICorner", {
						Parent = Elements.Circle,
						CornerRadius = UDim.new(0,8)
					})

					Library:Instance("UIStroke", {
						Parent = Elements.Bar,
						Color = Library.Theme.Outline,
						Thickness = 1 
					})
				end

				Slider.Elements = Elements 

				function Slider:Set(Value)
					Value = Utility:Round(math.clamp(Value, self.Min, self.Max),  self.Decimals)

					self.Value = Value 
					Value = self.Value 

					local Scale = (Value - self.Min) / (self.Max - self.Min )

					Library:Tween(self.Elements.BarFill, TweenData, {
						Size = UDim2.new(Scale, 0, 1, 0)
					})

					self.Elements.Value.Text = Utility:CommaValue(Value, self.Decimals)

					Library.Flags[Slider.Flag] = Value 
					
					Utility:SafeCall(self.Callback)
				end 

				do
					local Dragging = false 

					local Update= function(Input)
						Window.CanDrag = not Dragging 

						local Scale = (Input.Position.X - Slider.Elements.Bar.AbsolutePosition.X) / Slider.Elements.Bar.AbsoluteSize.X 

						local Percent = math.clamp(Scale, 0, 1)

						local Val = (Slider.Max - Slider.Min) * Percent + Slider.Min 

						Slider:Set(Val) 
					end

					local UIS = Services["UserInputService"]

					UIS.InputEnded:Connect(function(Input)
						if Input.UserInputType == Enum.UserInputType.MouseButton1 then
							Window.CanDrag = true 
							Dragging = false 
						end
					end)

					UIS.InputChanged:Connect(function(Input)
						if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
							Update(Input)
						end
					end)

					Library:Connect("Slider "..Slider.Name, Slider.Elements.Holder.InputBegan, function(Input)
						if Input.UserInputType == Enum.UserInputType.MouseButton1 then
							Dragging = true 
							Update(Input)
						end
					end)
				end

				Library.SetFlags[Slider.Flag]= function(Value)
					Slider:Set(Value)
				end

				Slider:Set(Slider.Default)

				return Slider 
			end

			--#endsubregion Slider, #region Section

			--#subregion Dropdown, #region Section

			function Section:Dropdown(Data)
				Data = Data or { }

				local Dropdown = {
					Name = Data.Name or Data.name or "Dropdown",
					Flag = Data.Flag or Data.flag or "Unknown",
					Multi = Data.Multi or Data.multi or false,
					Callback = Data.Callback or Data.callback or function()
						
						end,
					Options = Data.Items or Data.items or {},
					Default = Data.Default or Data.default or (not Data.Multi and "" or {}),

					Items = {},
					Section = self,
					IsOpen =   false,
					Window = self.Window,
					Value = not Data.Multi and "" or {}
				}

				local Elements = {} do
					Elements.Holder = Library:Instance("Frame", {
						Parent = Dropdown.Section.Elements.Content,
						BackgroundTransparency = 1,
						Size = UDim2.new(1,0,0,55)
					})

					Elements.Name = Library:Instance("TextLabel", {
						Parent = Elements.Holder,
						Text = Dropdown.Name,
						FontFace = Library.Font,
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = Library.Theme.Unselected,
						BackgroundTransparency = 1,
						Size = UDim2.new(0.5,0,0,10),
						Position = UDim2.new()
					})

					Elements.Button = Library:Instance("TextButton", {
						Parent = Elements.Holder,
						AutoButtonColor = false,
						Text = "",
						FontFace = Library.Font,
						TextSize = 13,
						TextColor3 = Color3.new(0.9,0.9,0.9),
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundColor3 = Library.Theme.Elements,
						Position = UDim2.new(0,0,0,20),
						Size = UDim2.new(1,0,0,35)
					})

					Elements.Items = Library:Instance("Frame", {
						Parent = Library.Garbage,
						Size = UDim2.new(1,0,0,0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = Library.Theme.Elements,
						BorderSizePixel = 1,
						ZIndex = 55,
						BorderColor3 = Library.Theme.Outline
					})

					Library:Instance("UIListLayout", {
						Parent = Elements.Items,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0,3)
					})

					Library:Instance("UIPadding", {
						Parent = Elements.Items,
						PaddingTop = UDim.new(0,5),
						PaddingBottom = UDim.new(0,5),
						PaddingLeft = UDim.new(0,5),
						PaddingRight = UDim.new(0,5)
					})

					Library:Instance("UICorner", {
						Parent = Elements.Button,
						CornerRadius = UDim.new(0,8)
					})

					Library:Instance("UIStroke", {
						Parent = Elements.Button,
						Color = Library.Theme.Outline,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Thickness = 1
					})

					Library:Instance("UIPadding", {
						Parent = Elements.Button,
						PaddingLeft = UDim.new(0,13)
					})
				end

				Dropdown.Elements = Elements

				function Dropdown:Add(Name)
					local Item = {
						Name = Name,
						Value= false,
						Connections = {}
					}

					local Elements = {} do
						Elements.Button = Library:Instance("TextButton", {
							Parent = self.Elements.Items,
							BackgroundColor3 = Library.Theme.Elements,
							Size = UDim2.new(1,0,0,30),
							AutoButtonColor = false,
							Text = Item.Name,
							Name = Item.Name,
							ZIndex = 56,
							FontFace = Library.Font,
							TextColor3 = Library.Theme.Unselected,
							TextSize = 14,
							BorderSizePixel = 0
						})

						Library:Instance("UICorner", {
							Parent = Elements.Button,
							CornerRadius = UDim.new(0,8)
						})

						--[[Item.Connections[1] = Library:Connect(Name.." Item Mouse Enter", Elements.Button.MouseEnter, function()
							if not Item.Value then
								Library:Tween(Elements.Button, TweenData, {
									BackgroundColor3 = Library.Theme.Selected2
								})
							end
						end)

						Item.Connections[2] = Library:Connect(Name.." Item Mouse Leave", Elements.Button.MouseLeave, function()
							if not Item.Value then
								Library:Tween(Elements.Button, TweenData, {
									BackgroundColor3 = Color3.fromRGB(18,18,18)
								})
							end
						end)]]

						Item.Connections[3] = Library:Connect(Name.." Item Handler", Elements.Button.MouseButton1Down, function()

							if Dropdown.Multi then

								Item.Value = not Item.Value 
								
								local List = {}

								for Name, Item in Dropdown.Items do
									if Item.Value then
										table.insert(List, Name)
									end
								end

								Dropdown:Set(List)
							else
								Dropdown:Set(Item.Name)
							end
						end)
					end

					Item.Elements= Elements

					Dropdown.Items[Name] = Item 

					return Item 
				end

				function Dropdown:Remove(Name)
					if Dropdown.Items[Name] then
						local Item = Dropdown.Items[Name]

						for Index, Value in Item.Elements do
							Value:Destroy()
						end

						for Index, Value in Item.Connections do
							Value:Disconnect()
						end

						Item = nil 
					end
				end

				function Dropdown:Refresh(List)
					for Index, Value in Dropdown.Items do
						Dropdown:Remove(Value.Name)
					end

					for Index, Value in List do
						Dropdown:Add(Value)
					end
				end

				local Conn 

				function Dropdown:SetOpen(Bool)
					Dropdown.IsOpen = Bool 

					self.Elements.Items.Parent = Bool and self.Elements.Holder or Library.Garbage

					if Bool then
						Conn = Services.RunService.RenderStepped:Connect(function(Delta)
							local Pos = self.Elements.Button.Position 
							self.Elements.Items.Position = UDim2.new(Pos.X.Scale, Pos.X.Offset, Pos.Y.Scale, Pos.Y.Offset + 35)
						end)

						Library.OpenedFrames[self.Flag] = self 
					else
						Library.OpenedFrames[self.Flag] = nil 
						Conn:Disconnect()
						Conn = nil 
					end
				end
				
				function Dropdown:Set(Value)
					self.Value = Value 

					if self.Multi then
						if typeof(Value) ~= "table" then
							return 
						end

						Library.Flags[self.Flag] = Value 

						local Names = {}

						for Key, Item in self.Items do
							local Selected = table.find(Value, Item.Name) ~= nil 

							Library:Tween(Item.Elements.Button, TweenData, {
								TextColor3 = Selected and Library.Theme.Selected or Library.Theme.Unselected,
								BackgroundColor3 = Selected and Color3.fromRGB(24,24,30) or Library.Theme.Elements
							})

							Item.Value = Selected 

							if Selected then
								table.insert(Names, Item.Name)
							end
						end

						self.Elements.Button.Text = #Names > 0 and table.concat(Names, ", ") or ""
					else
						Library.Flags[self.Flag] = Value;

						for Key, Item in self.Items do
							local Selected = Item.Name == Value 

							Item.Value = Selected 

							Library:Tween(Item.Elements.Button, TweenData, {
								TextColor3 = Selected and Library.Theme.Selected or Library.Theme.Unselected,
								BackgroundColor3 = Selected and Color3.fromRGB(24,24,30) or Library.Theme.Elements
							})
						end

						self.Elements.Button.Text = tostring(Value)
					end
					
					Utility:SafeCall(self.Callback)
				end


				for Index, Value in Dropdown.Options do
					Dropdown:Add(Value)
				end

				Dropdown:Set(Dropdown.Default)

				Library:Connect(Dropdown.Name.." Dropdown Opening", Dropdown.Elements.Button.MouseButton1Down, function()
					local Tween = Library:Tween(Elements.Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
						BackgroundColor3 = Color3.fromRGB(30,30,30)
					})
					Tween.Completed:Wait()
					Library:Tween(Elements.Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
						BackgroundColor3 = Library.Theme.Elements
					})
					Dropdown:SetOpen(not Dropdown.IsOpen)
				end)

				--[[Dropdown.Elements.Button.MouseEnter:Connect(function()
					Library:Tween(Dropdown.Elements.Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
						BackgroundColor3 = Color3.fromRGB(40,40,40)
					})
				end)

				Dropdown.Elements.Button.MouseLeave:Connect(function()
					Library:Tween(Dropdown.Elements.Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
						BackgroundColor3 = Library.Theme.Elements
					})
				end)]]

				Library.SetFlags[Dropdown.Flag] = function(Value)
					Dropdown:Set(Value)
				end

				return Dropdown

			end
			--#endregion Dropdown

			--#region Button

			local CreateButton = function(Data)
				local Button = {
					Name = Data.Name or Data.name or "Button",
					Callback = Data.Callback or Data.callback or function ()

					end
				}

				local Elements = {}; do
					Elements.Button = Library:Instance("TextButton",{
						Parent = Data.Parent,
						BackgroundColor3 = Library.Theme.Elements,
						Size = UDim2.new(1,0,1,0),
						TextColor3 = Color3.new(1,1,1),
						FontFace = Library.Font,
						TextSize = 13,
						Text = Button.Name,
						AutoButtonColor = false,
						TextXAlignment = Enum.TextXAlignment.Center
					}); 

					Library:Instance("UICorner",{
						Parent = Elements.Button,
						CornerRadius = UDim.new(0,8)
					})

					Library:Instance("UIStroke",{
						Parent = Elements.Button																																																																																																																																																																																																																																																																					,
						Color = Library.Theme.Outline 																																																																																																																																																																 		,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					})

					--[[Library:Instance("UIPadding",{
						Parent = Elements.Button,
						PaddingLeft = UDim.new(0,13)
					})]]
				end;

				Button.Elements = Elements 
				--// Click!
				Library:Connect(Button.Name.." Triggering", Button.Elements.Button.MouseButton1Down, function(...)

					local Tween = Library:Tween(Elements.Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
						BackgroundColor3 = Color3.fromRGB(30,30,30)
					})

					Tween.Completed:Wait()

					Library:Tween(Elements.Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
						BackgroundColor3 = Library.Theme.Elements
					})

					Utility:SafeCall(Button.Callback) --// Safe!!!
				end)

				return Button 
			end

			function Section:Button(Data)
				Data = Data or {};

				local Holder = Library:Instance("Frame",{
					Parent = self.Elements.Content,
					Size = UDim2.new(1,0,0,25),
					BackgroundTransparency = 1
				})

				Data.Parent = Holder

				local Button=  CreateButton(Data)

				function Button:AddButton(Data)
					Data = Data or {};

					Data.Parent = Holder 

					Button.Elements.Button.Size = UDim2.new(0.48,0,1,0)

					local Button0 = CreateButton(Data)

					Button0.Elements.Button.Size = UDim2.new(0.52,0,1,0)
					Button0.Elements.Button.Position = UDim2.new(0.5,0,0,0)
				end

				return Button 
			end

			--#endsubregion Button, #region Section

			--#region Label 

			function Section:Label(Text)

				local Label = {
					Text = Text or 'Label',
					Window = self.Window
				}


				local Elements = {}; do

					Elements.Text = Library:Instance("TextLabel",{
						Parent = self.Elements.Content,
						TextColor3 = Color3.new(1,1,1),
						BackgroundTransparency = 1,
						Size = UDim2.new(0.5,0,0,20),
						FontFace = Library.Font,
						TextXAlignment = Enum.TextXAlignment.Left, -- // idk why,
						TextSize = 14,
						Text = Text 
					});

					Elements.MiscSpace = Library:Instance("Frame", {
						Parent = Elements.Text,
						Size = UDim2.new(1,0,1,0),
						Position = UDim2.new(1,0,0,0),
						BackgroundTransparency = 1
					});

					Library:Instance("UIListLayout", {
						Parent = Elements.MiscSpace,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0,5)
					});	
				end	

				Label.Elements = Elements

				function Label:Colorpicker(Data)
					Data = Data or {}

					Data.Window = self.Window 
					Data.Section = self.Section 
					Data.Parent = self.Elements.MiscSpace

					Library:CreateColorpicker(Data)
				end

				function Label:Keybind(Data)
					Data = Data or {};

					Data.Default = Data.Default or Enum.KeyCode.Unknown
					Data.Section = self.Section 
					Data.Parent = self.Elements.MiscSpace 
					Data.Window = self.Window 

					Library:CreateKeybind(Data)
				end

				return Label
			end

			--#endregion Label 


			function Section:TextBox(Data)
				Data = Data or { };

				local TextBox = {
					Default = Data.Default or Data.default or "",
					Flag = Data.Flag or Data.flag or "Unknown",
					Text = Data.Text or Data.text or "TextBox",
					Name = Data.Name or Data.name or "TextBox",
					Value = "",
					Section = self
				}

				local Elements = {} do
					Elements.Holder = Library:Instance("Frame", {
						Parent = TextBox.Section.Elements.Content,
						BackgroundTransparency = 1,
						Size = UDim2.new(1,0,0,55)
					})

					Elements.Name = Library:Instance("TextLabel", {
						Parent = Elements.Holder,
						Text = TextBox.Name,
						FontFace = Library.Font,
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = Library.Theme.Unselected,
						BackgroundTransparency = 1,
						Size = UDim2.new(0.5,0,0,10),
						Position = UDim2.new()
					})

					Elements.Textbox = Library:Instance("TextBox", {
						Parent = Elements.Holder,
						Text = "",
						PlaceholderText = TextBox.Text,
						FontFace = Library.Font,
						TextSize = 13,
						TextColor3 = Color3.new(0.9,0.9,0.9),
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundColor3 = Library.Theme.Elements,
						Position = UDim2.new(0,0,0,20),
						Size = UDim2.new(1,0,0,35)
					})

					Library:Instance("UICorner", {
						Parent = Elements.Textbox,
						CornerRadius = UDim.new(0,8)
					})

					Library:Instance("UIStroke", {
						Parent = Elements.Textbox,
						Color = Library.Theme.Outline,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Thickness = 1
					})

					Library:Instance("UIPadding", {
						Parent = Elements.Textbox,
						PaddingLeft = UDim.new(0,13)
					})
				end

				TextBox.Elements = Elements 

				function TextBox:Set(Value : string)
					if typeof(Value) ~= "string" then
						Value = tostring(Value)
					end

					self.Value = Value 
					Library.Flags[TextBox.Flag] = Value 
					self.Elements.Textbox.Text = Value 
				end

				TextBox.Elements.Textbox:GetPropertyChangedSignal("Text"):Connect(function()
					TextBox:Set(TextBox.Elements.Textbox.Text)
				end)

				TextBox:Set(TextBox.Default)

				Library.SetFlags[TextBox.Flag] = function(Value)
					TextBox:Set(Value)
				end

				return TextBox
			end

			--#endregion Section

			return Section 
		end

		Library:Connect(Tab.Name.." Tab Turning", Tab.Elements.Button.MouseButton1Down, function()
			for Index, Value in Tab.Window.Tabs do
				Value:SetOpen(Value == Tab)
			end
		end)

		for Index = 1, 2 do
			local Offset = Index == 1 and 0 or 0.52
			local Size = Index == 1 and 0.5 or 0.48 

			Tab.Columns[Index] = Library:Instance("Frame", {
				Parent = Tab.Elements.Content,
				Size = UDim2.new(Size,0,1,0), 
				Position = UDim2.new(Offset,0,0,0), 
				BackgroundTransparency = 1 
			})

			Library:Instance("UIListLayout", {
				Parent = Tab.Columns[Index],
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0,10)
			})

			if Index == 1 then
				Library:Instance("UIPadding", {
					Parent = Tab.Columns[Index],
					PaddingTop = UDim.new(0,10),
					PaddingBottom = UDim.new(0,10),
					PaddingLeft = UDim.new(0,1)
				})
			else
				Library:Instance("UIPadding", {
					Parent = Tab.Columns[Index],
					PaddingTop = UDim.new(0,10),
					PaddingBottom = UDim.new(0,10),
					PaddingLeft = UDim.new(0,1),
					PaddingRight = UDim.new(0,2)
				})
			end
		end

		table.insert(Tab.Window.Tabs, Tab)

		return Tab 

		--#endregion Tab
	end

	--#endregion Window 

	return {Window = Window, Holder = Holder}
end

--#endregion Create

--[[#region Notifications

Library.Notify = function(self, Text, Duration)
	Duration = Duration or 3 
	
	local Elements = {};

	local Holder = Library:Instance("TextLabel",{
		Size = UDim2.new(1,0,1,0),
		Parent = self.Notifications.Instance,
		TextSize = 14,
		FontFace = self.Font,
		TextWrapped = true,
		Visible = false ,
		Text = Text 
	})

	task.wait(0/0)

	
end

Library.HitLog = function(self, Text, Duration)
	
end

--#endregion ]]

--#pragma region Miscelaneous
Library.CreateSettings = function(self, Holder)
	local Tab = Holder.Window:Tab({Name = "Settings"})

	local sec = Tab:Section({Name = "Menu"})
	sec:Toggle({Name = 'Keybind List', Flag = 'Keybind List', Callback = function()
		Library.KeybindList:SetVisible(Library.Flags["Keybind List"])
	end})
	sec:Label("Menu Keybind"):Keybind({Name = "Menu", Flag = 'Menu Key', Key = Enum.KeyCode.Insert, Ignore = true, Mode = "Toggle", Callback = function()
		Holder.Holder:SetOpen(Library.Flags["Menu Key"].Active)
	end})
	sec = Tab:Section({Name = "Config", Side = 2})
	sec:TextBox({Name = "Config Name", Flag = "Config Name"})
	local cd = sec:Dropdown({Name = "Configs List", Flag = "Config", Options = {}, Multi = false})
	sec:Button({Name = "Create Config", Callback = function()
		Library:SaveConfig(Library.Flags["Config Name"])
		Library:RefreshConfigs(cd)
	end}):AddButton({Name = "Save Config", Callback = function()
		Library:SaveConfig(Library.Flags["Config"])
		Library:RefreshConfigs(cd)	
	end})
	sec:Button({Name = "Load Config", Callback = function()
		Library:LoadConfig(Library.Flags["Config"])
		Library:RefreshConfigs(cd)
	end}):AddButton({Name = "Delete Config", Callback = function()
		if isfile(Library.Folders.Configs.."/"..Library.Flags["Config"]..".json") then
			delfile(Library.Folders.Configs.."/"..Library.Flags["Config"]..".json")
		end
		Library:RefreshConfigs(cd)
	end})

	Library:RefreshConfigs(cd)

	return Tab 
end

--[[

local Menu = Library:Create()
local Window = Menu.Window 

local Tab = Window:Tab({Name = "Test"})
local Settings = Library:CreateSettings(Menu)

Tab:Section({Name = "Section 2", Side = 1}):Slider({Name = "Slider 1", Min = 1, Max = 100, Decimals = 0.5, Default = 10, Suffix = "%"})
]]
return Library
