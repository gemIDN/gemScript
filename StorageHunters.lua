-- [[ Storage Hunter - Made by Gem ]] --
local Players, Rep = game:GetService("Players"), game:GetService("ReplicatedStorage")
local UIS, VIM = game:GetService("UserInputService"), game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer

local Target = gethui and gethui() or game:GetService("CoreGui"):FindFirstChild("RobloxGui") or game:GetService("CoreGui")
if Target:FindFirstChild("SH_AutoUnloadUI") then Target.SH_AutoUnloadUI:Destroy() end

local BidRem = Rep:WaitForChild("Events", 1):WaitForChild("Auction", 1):WaitForChild("Bid", 1)
local SG = Instance.new("ScreenGui", Target) SG.Name = "SH_AutoUnloadUI" SG.ResetOnSpawn = false

-- UKURAN PANEL DIKEMBALIKAN KE SEMULA (Lebih Ringkas & Bersih)
local MF = Instance.new("Frame", SG) MF.Size = UDim2.new(0, 240, 0, 160) MF.Position = UDim2.new(0.5, -120, 0.4, -80) MF.BackgroundColor3 = Color3.fromRGB(30, 30, 30) MF.Active = true
local Title = Instance.new("TextButton", MF) Title.Size = UDim2.new(1, 0, 0, 35) Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45) Title.Text = "   Storage Hunter - Made by GemIDN" Title.TextColor3 = Color3.fromRGB(255, 255, 255) Title.TextXAlignment = Enum.TextXAlignment.Left Title.Font = Enum.Font.SourceSansBold Title.TextSize = 11 Title.AutoButtonColor = false
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8) Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 8)

local Cnt = Instance.new("Frame", MF) Cnt.Size = UDim2.new(1, -20, 1, -45) Cnt.Position = UDim2.new(0, 10, 0, 40) Cnt.BackgroundTransparency = 1
local Lay = Instance.new("UIListLayout", Cnt) Lay.Padding = UDim.new(0, 4) Lay.HorizontalAlignment = Enum.HorizontalAlignment.Center Lay.VerticalAlignment = Enum.VerticalAlignment.Center

-- LABEL TEKS INSTRUKSI UNLOAD (BAHASA INGGRIS)
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 20)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "(to use unload item you must sit in the car)"
InfoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoLabel.Font = Enum.Font.SourceSansItalic
InfoLabel.TextSize = 11
InfoLabel.TextWrapped = true

getgenv().ABid, getgenv().AUnloadItem = false, false local IsTP = false

local function BuatTombol(txt, parent, var)
    local b = Instance.new("TextButton", parent) b.Size = UDim2.new(1, 0, 0, 32) b.BackgroundColor3 = Color3.fromRGB(140, 50, 50) b.Text = txt .. ": OFF" b.TextColor3 = Color3.fromRGB(255, 255, 255) b.Font = Enum.Font.SourceSansBold b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.Activated:Connect(function()
        getgenv()[var] = not getgenv()[var]
        b.Text = txt .. (getgenv()[var] and ": ON" or ": OFF")
        b.BackgroundColor3 = getgenv()[var] and Color3.fromRGB(50, 140, 50) or Color3.fromRGB(140, 50, 50)
    end)
    return b
end
local B1 = BuatTombol("Auto Bid", Cnt, "ABid") 
local B2 = BuatTombol("Unload Item", Cnt, "AUnloadItem")
InfoLabel.Parent = Cnt

local Tog = Instance.new("TextButton", SG) Tog.Size = UDim2.new(0, 50, 0, 50) Tog.Position = UDim2.new(0, 20, 0, 120) Tog.BackgroundColor3 = Color3.fromRGB(55, 55, 55) Tog.Text = "SH" Tog.TextColor3 = Color3.fromRGB(255, 255, 255) Tog.Font = Enum.Font.SourceSansBold Tog.TextSize = 16 Tog.ZIndex = 10 Tog.Active = true
Instance.new("UICorner", Tog).CornerRadius = UDim.new(1, 0) local TS = Instance.new("UIStroke", Tog) TS.Color = Color3.fromRGB(150, 150, 150) TS.Thickness = 2

local function Drag(clickObj, moveObj, isTog)
    local drag, dStart, sPos, moved = false, nil, nil, false
    clickObj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true moved = false dStart = i.Position sPos = moveObj.Position i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end) end end)
    UIS.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local del = i.Position - dStart if del.Magnitude > 5 then moved = true end moveObj.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + del.X, sPos.Y.Scale, sPos.Y.Offset + del.Y) end end)
    if isTog then clickObj.InputEnded:Connect(function(i) if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) and not moved then MF.Visible = not MF.Visible end drag = false end) end
end
Drag(Title, MF, false) Drag(Tog, Tog, true)

task.spawn(function()
    while task.wait(0.1) and SG.Parent do
        local Chr = LP.Character local Root = Chr and Chr:FindFirstChild("HumanoidRootPart")
        if not Chr or not Root then continue end

        if getgenv().ABid and BidRem then
            local id, amt local AH = LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("LocalAuctionHandler")
            if AH and AH:IsA("ModuleScript") then
                local s, m = pcall(require, AH) if s and type(m) == "table" then id = m.CurrentAuctionID or m.AuctionID or m.StorageID amt = m.CurrentBid or m.NextBid or m.Amount end
            end
            if id and amt then BidRem:FireServer(id, amt) else BidRem:FireServer() end
        end

        if getgenv().AUnloadItem and not IsTP then
            local TargetZone = workspace:FindFirstChild("UnpackZone")
            if TargetZone then
                local TargetPos = TargetZone:IsA("BasePart") and TargetZone.CFrame or TargetZone:GetPivot()
                if TargetPos then
                    IsTP = true local OriginalCFrame = Root.CFrame
                    Root.CFrame = TargetPos * CFrame.new(0, 3, 0) task.wait(0.6) 

                    pcall(function()
                        local UnloadBtn = LP.PlayerGui.UIControllerGui.UnloadVehiclePanel.Footer.Buttons.UnloadSelectedBtn
                        if UnloadBtn and UnloadBtn.AbsolutePosition then
                            local X = UnloadBtn.AbsolutePosition.X + (UnloadBtn.AbsoluteSize.X / 2)
                            local Y = UnloadBtn.AbsolutePosition.Y + (UnloadBtn.AbsoluteSize.Y / 2) + 55
                            VIM:SendMouseButtonEvent(X, Y, 0, true, game, 1) task.wait(0.05) VIM:SendMouseButtonEvent(X, Y, 0, false, game, 1)
                        end
                    end)
                    task.wait(1.5) 

                    Root.CFrame = OriginalCFrame
                    task.wait(2.5) IsTP = false
                end
            end
        end
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Storage Hunter", Text = "Script successfully loaded!", Duration = 3})
