-- ⚡ Case Opener v4.0 - Full Version
-- 💡 Created by: Mahdiyar100

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- ===== Config =====
local teleportPosition = Vector3.new(159.718033, 569.948914, -845.139343)
local tpEnabled = false
local caseLoopEnabled = false
local sellEnabled = false
local selectedCase = "Recoil Case"
local delaySpeed = 0.001 -- Delay between each case open

local cases = {
    "Free Case","Recoil Case","Fracture Case","Clutch Case","VIP Case",
    "Fever Case","Prisma 2 Case","Revolver Case","Chroma Case","Weapon Case 3",
    "Huntsman Weapon Case","Operation Breakout Case","2013 Winter Case",
    "2014 Summer Case","Operation Hydra Case","Operation Bravo Case",
    "2013 Case","Weapon Case","St. Marc Collection","2015 Cobblestone Collection"
}

-- ===== UI Setup =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 320, 0, 520)
Frame.Position = UDim2.new(0.5, -160, 0.5, -260)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.ClipsDescendants = true

local TopBar = Instance.new("Frame")
TopBar.Parent = Frame
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Case Opener v4.0"
Title.TextColor3 = Color3.fromRGB(180, 180, 220)
Title.Font = Enum.Font.Gotham
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Center

-- ===== Minimize/Maximize Button =====
local minMaxBtn = Instance.new("TextButton")
minMaxBtn.Parent = TopBar
minMaxBtn.Size = UDim2.new(0, 30, 0, 30)
minMaxBtn.Position = UDim2.new(1, -35, 0, 0)
minMaxBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
minMaxBtn.Text = "-"
minMaxBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
minMaxBtn.Font = Enum.Font.Gotham
minMaxBtn.TextSize = 18
minMaxBtn.BorderSizePixel = 0

-- ===== Layout =====
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Frame
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ===== Utility Functions =====
local function animateButton(button, hoverColor, defaultColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = defaultColor}):Play()
    end)
end

local function createButton(parent, text)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(210, 210, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    animateButton(btn, Color3.fromRGB(60, 60, 90), btn.BackgroundColor3)
    return btn
end

local tpToggle = createButton(Frame, "Auto TP: Off")
local caseToggle = createButton(Frame, "Auto Case: Off")
local sellToggle = createButton(Frame, "Auto Sell: Off")

-- Selected Case Label
local selectedLabel = Instance.new("TextLabel")
selectedLabel.Parent = Frame
selectedLabel.Size = UDim2.new(0.9, 0, 0, 30)
selectedLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
selectedLabel.BorderSizePixel = 0
selectedLabel.Text = "Selected Case: " .. selectedCase
selectedLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
selectedLabel.Font = Enum.Font.Gotham
selectedLabel.TextSize = 13
selectedLabel.TextWrapped = true

-- Scrollable Case Selection
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Parent = Frame
scrollingFrame.Size = UDim2.new(0.9, 0, 0, 150)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #cases*30)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)

local uiListLayoutCases = Instance.new("UIListLayout")
uiListLayoutCases.Parent = scrollingFrame
uiListLayoutCases.Padding = UDim.new(0, 2)
uiListLayoutCases.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayoutCases.SortOrder = Enum.SortOrder.LayoutOrder

for _, caseName in ipairs(cases) do
    local button = Instance.new("TextButton")
    button.Parent = scrollingFrame
    button.Size = UDim2.new(0.95, 0, 0, 25)
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    button.BorderSizePixel = 0
    button.Text = caseName
    button.TextColor3 = Color3.fromRGB(200, 200, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 12
    animateButton(button, Color3.fromRGB(55, 55, 75), button.BackgroundColor3)
    button.MouseButton1Click:Connect(function()
        selectedCase = caseName
        selectedLabel.Text = "Selected Case: " .. selectedCase
    end)
end

-- ===== Delay Input =====
local delayLabel = Instance.new("TextLabel")
delayLabel.Parent = Frame
delayLabel.Size = UDim2.new(0.9, 0, 0, 30)
delayLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
delayLabel.BorderSizePixel = 0
delayLabel.Text = "Delay (s): " .. delaySpeed
delayLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 13

local delayInput = Instance.new("TextBox")
delayInput.Parent = Frame
delayInput.Size = UDim2.new(0.9, 0, 0, 30)
delayInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
delayInput.BorderSizePixel = 0
delayInput.Text = tostring(delaySpeed)
delayInput.TextColor3 = Color3.fromRGB(210, 210, 255)
delayInput.Font = Enum.Font.Gotham
delayInput.TextSize = 14
delayInput.PlaceholderText = "Enter delay (e.g., 0.001)"
delayInput.FocusLost:Connect(function(enter)
    if enter then
        local val = tonumber(delayInput.Text)
        if val and val >= 0 then
            delaySpeed = val
            delayLabel.Text = "Delay (s): " .. delaySpeed
        else
            delayInput.Text = tostring(delaySpeed)
        end
    end
end)

-- ===== Creator Label =====
local creatorLabel = Instance.new("TextLabel")
creatorLabel.Parent = Frame
creatorLabel.Size = UDim2.new(0.9, 0, 0, 25)
creatorLabel.BackgroundTransparency = 1
creatorLabel.Text = "💡 Script by Mahdiyar100"
creatorLabel.TextColor3 = Color3.fromRGB(120, 200, 255)
creatorLabel.Font = Enum.Font.Gotham
creatorLabel.TextSize = 12
creatorLabel.TextXAlignment = Enum.TextXAlignment.Center

-- ===== Button Actions =====
tpToggle.MouseButton1Click:Connect(function()
    tpEnabled = not tpEnabled
    tpToggle.Text = "Auto TP: " .. (tpEnabled and "On" or "Off")
end)
caseToggle.MouseButton1Click:Connect(function()
    caseLoopEnabled = not caseLoopEnabled
    caseToggle.Text = "Auto Case: " .. (caseLoopEnabled and "On" or "Off")
end)
sellToggle.MouseButton1Click:Connect(function()
    sellEnabled = not sellEnabled
    sellToggle.Text = "Auto Sell: " .. (sellEnabled and "On" or "Off")
end)

-- ===== Minimize/Maximize Logic =====
local isMinimized = false
local originalSize = Frame.Size
local originalPosition = Frame.Position

minMaxBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(Frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 200, 0, 40)}):Play()
        TweenService:Create(Frame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -100, 0.5, -20)}):Play()
        minMaxBtn.Text = "+"
    else
        TweenService:Create(Frame, TweenInfo.new(0.3), {Size = originalSize}):Play()
        TweenService:Create(Frame, TweenInfo.new(0.3), {Position = originalPosition}):Play()
        minMaxBtn.Text = "-"
    end
end)

-- ===== Loops =====
task.spawn(function()
    while true do
        task.wait(1)
        if tpEnabled then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(delaySpeed)
        if caseLoopEnabled then
            local mainEvent = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("MainEvent")
            if mainEvent then
                mainEvent:FireServer("OpenCase", selectedCase, 1)
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if sellEnabled then
            local inv = player:FindFirstChild("Backpack") or player:FindFirstChild("Inventory")
            if inv then
                for _, item in pairs(inv:GetChildren()) do
                    local sellEvent = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("SellItem")
                    if sellEvent and item then
                        sellEvent:FireServer(item.Name)
                        task.wait(0.1)
                    end
                end
            end
        end
    end
end)

print("Script loaded successfully! - Mahdiyar100")
