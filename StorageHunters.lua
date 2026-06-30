-- [[ Storage Hunter - Made by GemIDN ]] --
local P = game:GetService("Players")
local R = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local TWS = game:GetService("TweenService")
local LP = P.LocalPlayer

local Tgt = gethui and gethui() or game:GetService("CoreGui"):FindFirstChild("RobloxGui") or game:GetService("CoreGui")
if Tgt:FindFirstChild("Rayfield_CustomSH") then Tgt.Rayfield_CustomSH:Destroy() end


local BidRem, PickupStartRem, CarryablesFolder
pcall(function()
    BidRem = R:WaitForChild("Events"):WaitForChild("Auction"):WaitForChild("Bid")
end)
pcall(function()
    PickupStartRem = R:WaitForChild("Events", 2):WaitForChild("Auction", 2):WaitForChild("AuctionPickupStart", 2)
end)
pcall(function()
    CarryablesFolder = workspace:WaitForChild("_Carryables", 2)
end)

local SG = Instance.new("ScreenGui", Tgt) 
SG.Name = "Rayfield_CustomSH" 
SG.ResetOnSpawn = false 

local W = Instance.new("Frame", SG) 
W.Name = "RayfieldWindow" 
W.Size = UDim2.new(0, 340, 0, 265) 
W.Position = UDim2.new(0.5, -170, 0.4, -132) 
W.BackgroundColor3 = Color3.fromRGB(21, 23, 30) 
W.BorderSizePixel = 0 
W.Active = true 
W.ZIndex = 5 
Instance.new("UICorner", W).CornerRadius = UDim.new(0, 8)

local TB = Instance.new("TextButton", W) 
TB.Size = UDim2.new(1, 0, 0, 35) 
TB.BackgroundColor3 = Color3.fromRGB(25, 28, 38) 
TB.Text = "   Storage Hunter  |  Made by Gem" 
TB.TextColor3 = Color3.fromRGB(240, 243, 255) 
TB.TextXAlignment = Enum.TextXAlignment.Left 
TB.Font = Enum.Font.SourceSansBold 
TB.TextSize = 12 
TB.ZIndex = 6 
TB.AutoButtonColor = false 
Instance.new("UICorner", TB).CornerRadius = UDim.new(0, 8)

local SB = Instance.new("Frame", W) 
SB.Size = UDim2.new(0, 95, 1, -35) 
SB.Position = UDim2.new(0, 0, 0, 35) 
SB.BackgroundColor3 = Color3.fromRGB(17, 19, 26) 
SB.BorderSizePixel = 0 
SB.ZIndex = 6 
local SL = Instance.new("UIListLayout", SB) 
SL.Padding = UDim.new(0, 4) 
SL.HorizontalAlignment = Enum.HorizontalAlignment.Center 
local TC = Instance.new("Frame", W) 
TC.Size = UDim2.new(1, -105, 1, -45) 
TC.Position = UDim2.new(0, 100, 0, 40) 
TC.BackgroundTransparency = 1 
TC.ZIndex = 6

local TM = Instance.new("Frame", TC) 
TM.Size = UDim2.new(1, 0, 1, 0) 
TM.BackgroundTransparency = 1 
TM.Visible = true 
TM.ZIndex = 7 
local ML = Instance.new("UIListLayout", TM) 
ML.Padding = UDim.new(0, 5) 

local TCd = Instance.new("Frame", TC) 
TCd.Size = UDim2.new(1, 0, 1, 0) 
TCd.BackgroundTransparency = 1 
TCd.Visible = false 
TCd.ZIndex = 7 
local CL = Instance.new("UIListLayout", TCd) 
CL.Padding = UDim.new(0, 5)

local function TBtn(txt, tab) 
    local b = Instance.new("TextButton", SB) 
    b.Size = UDim2.new(0.9, 0, 0, 28) 
    b.BackgroundColor3 = tab.Visible and Color3.fromRGB(35, 40, 55) or Color3.fromRGB(25, 28, 38) 
    b.Text = txt 
    b.TextColor3 = Color3.fromRGB(220, 220, 220) 
    b.Font = Enum.Font.SourceSansBold 
    b.TextSize = 10 
    b.ZIndex = 7 
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5) 
    b.Activated:Connect(function() 
        TM.Visible = false 
        TCd.Visible = false 
        for _, v in pairs(SB:GetChildren()) do 
            if v:IsA("TextButton") then 
                v.BackgroundColor3 = Color3.fromRGB(25, 28, 38) 
            end 
        end 
        tab.Visible = true 
        b.BackgroundColor3 = Color3.fromRGB(35, 40, 55) 
    end) 
end

TBtn("Main Features", TM) 
TBtn("Credits Menu", TCd) 

getgenv().ABid = false
getgenv().AUnload = false
getgenv().APickup = false
getgenv().QuickSell = false 
local IsTP = false
local SavedPosition = nil 

local function Tgl(txt, p, vN) 
    local f = Instance.new("Frame", p) 
    f.Size = UDim2.new(1, 0, 0, 32) 
    f.BackgroundColor3 = Color3.fromRGB(28, 31, 43) 
    f.BorderSizePixel = 0 
    f.ZIndex = 8 
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6) 
    
    local l = Instance.new("TextLabel", f) 
    l.Size = UDim2.new(0.65, 0, 1, 0) 
    l.Position = UDim2.new(0, 6, 0, 0) 
    l.BackgroundTransparency = 1 
    l.Text = txt 
    l.TextColor3 = Color3.fromRGB(220, 225, 240) 
    l.Font = Enum.Font.SourceSansBold 
    l.TextSize = 11 
    l.TextXAlignment = Enum.TextXAlignment.Left 
    l.ZIndex = 9 
    
    local sw = Instance.new("TextButton", f) 
    sw.Size = UDim2.new(0, 35, 0, 18) 
    sw.Position = UDim2.new(1, -42, 0.5, -9) 
    sw.BackgroundColor3 = Color3.fromRGB(140, 50, 50) 
    sw.Text = "" 
    sw.ZIndex = 9 
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0) 
    
    local c = Instance.new("Frame", sw) 
    c.Size = UDim2.new(0, 14, 0, 14) 
    c.Position = UDim2.new(0, 2, 0.5, -7) 
    c.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
    c.ZIndex = 10 
    Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0) 
    
    sw.Activated:Connect(function() 
        getgenv()[vN] = not getgenv()[vN] 
        local act = getgenv()[vN] 
        TWS:Create(sw, TweenInfo.new(0.15), {BackgroundColor3 = act and Color3.fromRGB(50, 140, 50) or Color3.fromRGB(140, 50, 50)}):Play() 
        TWS:Create(c, TweenInfo.new(0.15), {Position = act and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play() 
        
        if vN == "QuickSell" then
            local Chr = LP.Character
            local Root = Chr and Chr:FindFirstChild("HumanoidRootPart")
            if act then
                if Root then SavedPosition = Root.CFrame end 
            else
                if Root and SavedPosition then
                    IsTP = true
                    Root.CFrame = SavedPosition 
                    task.wait(0.2)
                    SavedPosition = nil
                    IsTP = false
                end
            end
        end
    end) 
end

Tgl("Auto Bid", TM, "ABid") 
Tgl("Unload Item (maybe it doesn't work on PC)", TM, "AUnload") 
Tgl("Auto Pickup Items", TM, "APickup")
Tgl("Quick Sell (talk to npc)", TM, "QuickSell") 

local PF = Instance.new("Frame", TM) 
PF.Size = UDim2.new(1, 0, 0, 34) 
PF.BackgroundColor3 = Color3.fromRGB(24, 26, 36) 
Instance.new("UICorner", PF).CornerRadius = UDim.new(0, 6) 

local PT = Instance.new("TextLabel", PF) 
PT.Size = UDim2.new(1, -10, 1, -10) 
PT.Position = UDim2.new(0, 5, 0, 5) 
PT.BackgroundTransparency = 1 
PT.Text = "(Aktif: Diam di Rick & Jual | Nonaktif: Otomatis pulang ke tempat asal)" 
PT.TextColor3 = Color3.fromRGB(150, 155, 175) 
PT.Font = Enum.Font.SourceSansItalic 
PT.TextSize = 9 
PT.TextWrapped = true

local function LblC(t, p) 
    local l = Instance.new("TextLabel", p) 
    l.Size = UDim2.new(1, 0, 0, 20) 
    l.BackgroundTransparency = 1 
    l.Text = t 
    l.TextColor3 = Color3.fromRGB(180, 185, 200) 
    l.Font = Enum.Font.SourceSans 
    l.TextSize = 10 
    l.TextXAlignment = Enum.TextXAlignment.Left 
end
LblC("• Script Creator: GemIDN", TCd) 
LblC("• Game: Storage Hunter", TCd) 
LblC("• Theme: Simple_ui", TCd)

local Tog = Instance.new("TextButton", SG) 
Tog.Size = UDim2.new(0, 45, 0, 45) 
Tog.Position = UDim2.new(0, 20, 0, 120) 
Tog.BackgroundColor3 = Color3.fromRGB(25, 28, 38) 
Tog.Text = "SH" 
Tog.TextColor3 = Color3.fromRGB(240, 240, 240) 
Tog.Font = Enum.Font.SourceSansBold 
Tog.TextSize = 15 
Tog.ZIndex = 10 
Tog.Active = true 
Instance.new("UICorner", Tog).CornerRadius = UDim.new(1, 0) 
local TS = Instance.new("UIStroke", Tog) 
TS.Color = Color3.fromRGB(60, 65, 85) 
TS.Thickness = 1.5

local function Drag(c, m, t) 
    local d, dS, sP, mv = false, nil, nil, false 
    c.InputBegan:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            d = true 
            mv = false 
            dS = i.Position 
            sP = m.Position 
            i.Changed:Connect(function() 
                if i.UserInputState == Enum.UserInputState.End then 
                    d = false 
                end 
            end) 
        end 
    end) 
    UIS.InputChanged:Connect(function(i) 
        if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then 
            local del = i.Position - dS 
            if del.Magnitude > 5 then 
                mv = true 
            end 
            m.Position = UDim2.new(sP.X.Scale, sP.X.Offset + del.X, sP.Y.Scale, sP.Y.Offset + del.Y) 
        end 
    end) 
    if t then 
        c.InputEnded:Connect(function(i) 
            if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) and not mv then 
                W.Visible = not W.Visible 
            end 
            d = false 
        end) 
    end 
end
Drag(TB, W, false) 
Drag(Tog, Tog, true)

-- BACKGROUND PROCESS ENGINE
task.spawn(function() 
    while task.wait(0.3) and SG.Parent do 
        local Chr = LP.Character 
        local Root = Chr and Chr:FindFirstChild("HumanoidRootPart") 
        if not Chr or not Root then continue end

        -- [[ 1. EXECUTE AUTO BID (FIXED) ]]
        if getgenv().ABid and BidRem then
            pcall(function()
                -- Scan langsung ke UI Screen/Billboard lelang untuk mendapatkan data ID & Jumlah Bid terbaru
                for _, gui in pairs(LP.PlayerGui:GetDescendants()) do
                    if gui:IsA("TextButton") and gui.Visible then
                        local btnName = string.lower(gui.Name)
                        local btnText = string.lower(gui.Text)
                        
                        if string.find(btnName, "bid") or string.find(btnText, "bid") then
                            -- Menembakkan bid langsung ke path Remote Event utama
                            BidRem:FireServer()
                            gui:Activate() -- Fallback alternatif klik tombol visual
                        end
                    end
                end
            end)
        end

        -- [[ 2. OPTIMIZED AUTO UNLOAD ]]
        if getgenv().AUnload and not IsTP then
            local UnloadBtn
            pcall(function()
                UnloadBtn = LP.PlayerGui.UIControllerGui.UnloadVehiclePanel.Footer.Buttons.UnloadSelectedBtn
            end)
            
            if UnloadBtn and UnloadBtn.Visible and UnloadBtn.AbsolutePosition then
                local Zone = workspace:FindFirstChild("UnpackZone")
                if Zone then
                    local Pos = Zone:IsA("BasePart") and Zone.CFrame or Zone:GetPivot()
                    if Pos then
                        IsTP = true
                        local CurrentLocation = Root.CFrame 
                        
                        Root.CFrame = Pos * CFrame.new(0, 3.5, 0) 
                        task.wait(0.5)
                        
                        pcall(function()
                            local X = UnloadBtn.AbsolutePosition.X + (UnloadBtn.AbsoluteSize.X / 2)
                            local Y = UnloadBtn.AbsolutePosition.Y + (UnloadBtn.AbsoluteSize.Y / 2) + 55
                            VIM:SendMouseButtonEvent(X, Y, 0, true, game, 1) 
                            task.wait(0.05) 
                            VIM:SendMouseButtonEvent(X, Y, 0, false, game, 1)
                        end)
                        
                        task.wait(1.2) 
                        Root.CFrame = CurrentLocation 
                        task.wait(0.4) 
                        IsTP = false
                    end
                end
            end
        end

        -- [[ 3. EXECUTE TELEPORT AUTO PICKUP ]]
        if getgenv().APickup and PickupStartRem and CarryablesFolder and not IsTP then
            local items = CarryablesFolder:GetChildren()
            if #items > 0 then
                IsTP = true
                local OriginalPosition = Root.CFrame 
                for _, item in pairs(items) do
                    if not getgenv().APickup then break end
                    local TargetCFrame = item:IsA("BasePart") and item.CFrame or item:IsA("Model") and item:GetPivot()
                    if TargetCFrame then
                        Root.CFrame = TargetCFrame * CFrame.new(0, 2.5, 0)
                        task.wait(0.2) 
                        pcall(function()
                            PickupStartRem:FireServer(item)
                        end)
                        for _, prompt in pairs(item:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") then
                                if fireproximityprompt then fireproximityprompt(prompt) end
                            end
                        end
                        task.wait(0.1)
                    end
                end
                Root.CFrame = OriginalPosition
                task.wait(0.5) 
                IsTP = false
            end
        end

        -- [[ 4. SYSTEM TOGGLE QUICK SELL ]]
        if getgenv().QuickSell and not IsTP then
            pcall(function()
                local NPCFolder = workspace:FindFirstChild("Mall - Shop NPCs")
                local Rick = NPCFolder and NPCFolder:FindFirstChild("Rick Harrison")
                local RickPart = Rick and (Rick:FindFirstChild("HumanoidRootPart") or Rick:FindFirstChildOfClass("BasePart") or Rick:GetPivot())
                
                if Rick and RickPart then
                    local TargetCFrame = typeof(RickPart) == "CFrame" and RickPart or RickPart.CFrame
                    local FinalPos = TargetCFrame * CFrame.new(0, 0, -3) * CFrame.Angles(0, math.pi, 0)
                    
                    if (Root.Position - FinalPos.Position).Magnitude > 2 then
                        Root.CFrame = FinalPos
                        task.wait(0.1)
                    end
                    
                    for _, obj in pairs(Rick:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            if fireproximityprompt then fireproximityprompt(obj) end
                        elseif obj:IsA("Dialog") then
                            for _, choice in pairs(obj:GetChildren()) do
                                if choice:IsA("DialogChoice") and string.find(string.lower(choice.UserDialogue), "sell") then
                                    LP:SelectChoice(choice)
                                end
                            end
                        end
                    end

                    for _, gui in pairs(LP.PlayerGui:GetDescendants()) do
                        if gui:IsA("TextButton") and gui.Visible then
                            local text = string.lower(gui.Text)
                            local name = string.lower(gui.Name)
                            
                            if string.find(text, "sell something") or string.find(text, "sell all") or string.find(name, "sell") or string.find(text, "jual") then
                                gui:Activate()
                            end
                        end
                    end
                end
            end)
        end
    end 
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Storage Hunter", 
    Text = "Script successfully loaded!", 
    Duration = 3
})
