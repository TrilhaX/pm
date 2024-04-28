warn('[TEMPEST HUB] Loading Ui')
wait(1)
local repo = 'https://raw.githubusercontent.com/TrapstarKSSKSKSKKS/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({

    Title = 'Tempest Hub | Project Mugetsu',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

Library:Notify('Loading Project Mugetsu Script', 5)


local function GetCFrame(obj)
    local cframe = CFrame.new()
    local objType = typeof(obj)
    
    if objType == "Vector3" then
        cframe = CFrame.new(obj)
    elseif objType == "table" then
        cframe = CFrame.new(unpack(obj))
    elseif objType == "string" then
        local parts = {}
        for val in obj:gmatch("[^,]+") do
            table.insert(parts, tonumber(val))
        end
        if #parts >= 3 then
            cframe = CFrame.new(unpack(parts))
        end
    elseif objType == "Instance" then
        if obj:IsA("Model") then
            local rootPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
            if rootPart then
                cframe = rootPart.CFrame
            end
        elseif obj:IsA("Part") then
            cframe = obj.CFrame
        end
    end
    
    return cframe
end

local selectedClan = ""

function RollDeClan()
    while getgenv().RollDeClan == true do
        local Player_Datas = game:GetService("ReplicatedStorage").Player_Datas
        local player = game.Players.LocalPlayer
        local children = Player_Datas:GetChildren()
        for _, child in ipairs(children) do
            local clan = child.Slot_1.Clan.Value
            if selectedClan == clan then
                print("Pegou UHUUUUL")
            else 
                local args = {
                    [1] = 1
                }
            
                game:GetService("ReplicatedStorage"):WaitForChild("Spin"):InvokeServer(unpack(args))
                wait(delay)
            end     
        end
        wait(2)
    end
end

local codes = {
    "ChangesAgainSorryForShutdown",
    "USECODESINMAINMENU",
    "CrispyReasonForBugs",
    "150kLikes",
    "QuincyFixes",
    "AgainSorryForShutdown",
    "UPDATE2MoreRerolls",
    "UPDATE2MoreRerolls2",
    "FirstBalanceChange",
    "BlackButlerPublicSchoolArc",
    "TestOrbCode",
}

local Tabs = {
    Main = Window:AddTab('Main'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Player')

local MyButton = LeftGroupBox:AddButton({
    Text = 'Reedem Codes',
    Func = function()
        local args = {
            [1] = codes
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Code"):InvokeServer(unpack(args))        
    end,
    DoubleClick = false,
})

LeftGroupBox:AddDropdown('Map', {
    Values = {"Asano", "Arisawa", "Joaquin", "Haida", "Hanakari", "Honsho", "Ide", "Iijima", "Kanoniji", "Kojima", "Kunieda", "Natsui", "Shigeo", "Dokugamine", "Sado", "Inoue", "Ginjo", "Kutsuzawa", "Tsukishima", "Shishigawara", "Yukio", "Kotetsu", "Mugurama", "Yadomaru", "Iba", "Kira", "Hirako", "Ushoda", "Sarugaki", "Amagi", "Valkyrie", "Jagerjaquez", "Hitsugaya", "Hisagi", "Ichimaru", "Shihoin", "Unohana","Sasuke", "Naruto", "Itachi", "Urahara", "Kurosaki", "Itadori", "Brook", "Ginjo", "Ichibei", "Gojo","Tsukishima"},
    Default = "None",
    Multi = false,
    Text = 'Choose Map',
    Callback = function(value)
        selectedClan = value
    end
})

LeftGroupBox:AddToggle('AutoRoll', {
    Text = 'Auto Roll',
    Default = false,
    Callback = function(Value)
        getgenv().RollDeClan = Value
        if Value then
            RollDeClan()
        end
    end
})

LeftGroupBox:AddSlider('delay', {
    Text = 'spam of auto roll',
    Default = 1,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        delay = Value
    end
})


local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local WatermarkConnection

-- Create a function to update FPS and ping information
local function UpdateWatermark()
    FrameCounter = FrameCounter + 1

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end

    Library:SetWatermark(('Tempest Hub | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end

-- Connect the function to the RenderStepped event
WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(UpdateWatermark)

-- Create tabs for UI settings
local TabsUI = {
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- Unload function
local function Unload()
    WatermarkConnection:Disconnect()
    print('Unloaded!')
    Library.Unloaded = true
end

-- UI Settings
local MenuGroup = TabsUI['UI Settings']:AddLeftGroupbox('Menu')

-- Add an unload button
MenuGroup:AddButton('Unload', Unload)

-- Add a label and key picker for the menu keybind
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

-- Define the ToggleKeybind variable
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder('Tempest Hub')
SaveManager:SetFolder('Tempest Hub/_p_m_')

SaveManager:BuildConfigSection(TabsUI['UI Settings'])

ThemeManager:ApplyToTab(TabsUI['UI Settings'])

SaveManager:LoadAutoloadConfig()

local GameConfigName = '_p_m_'
local player = game.Players.LocalPlayer
SaveManager:Load(player.Name .. GameConfigName)
spawn(function()
    while task.wait(1) do
        if Library.Unloaded then
            break
        end
        SaveManager:Save(player.Name .. GameConfigName)
    end
end)

-- Disable player idling
for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end
warn('[TEMPEST HUB] Loaded')
