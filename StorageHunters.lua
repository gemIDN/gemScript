-- [[ STORAGE HUNTER: EXECUTOR EDITION - REPEAT TELEPORT UNLOAD ]] --
-- Title: Storage Hunter - Made by Gem

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Tempat penyimpanan GUI paling aman (PlayerGui agar pasti muncul di HP)
local TargetParent = LocalPlayer:WaitForChild("PlayerGui", 5)

if TargetParent:FindFirstChild("SH_RepeatUnloadUI") then
    TargetParent.SH_RepeatUnloadUI:Destroy()
end

-- Ambil Path Event & Module Game Anda
local BidRem = ReplicatedStorage:WaitForChild("Events", 1):WaitForChild("Auction", 1):WaitForChild("Bid", 1)
local UnloadModule = ReplicatedStorage:WaitForChild("Modules", 1):WaitForChild("Screens", 1):WaitForChild("UnloadVehicle", 1)

-- 1. SCREEN GUI UTAMA
local SG = Instance.new("ScreenGui", TargetParent)
SG.Name = "SH_RepeatUnloadUI"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 2. PANEL UTAMA (MAIN FRAME)
local MF = Instance.new("Frame", SG)
MF.Name = "MainFrame"
MF.Size = UDim2.new(0, 240, 0, 140)
MF.Position = UDim2.new(0.5, -120, 0.4, -70)
MF.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MF.BorderSizePixel = 0
MF.ZIndex = 5

local Title = Instance.new("TextButton", MF)
Title.Name = "TitleHeader"
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "   Storage Hunter - Made by Gem" -- Kata VIP telah dihapus sepenuhnya
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 11
Title.ZIndex = 6
Title.AutoButtonColor = false
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)
Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 8)

local Cnt = Instance.new("Frame", MF)
Cnt.Size = UDim2.new(1, -20, 1, -45)
Cnt.Position = UDim2.new(0, 10, 0, 40)
Cnt.BackgroundTransparency = 1
Cnt.ZIndex = 6
local Lay = Instance.new("UIListLayout", Cnt)
Lay.Padding = UDim.new(0, 6)
Lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
Lay.VerticalAlignment = Enum.VerticalAlignment.Center

getgenv().ABid, getgenv().AUnloadItem = false, false
local IsTeleporting = false

-- 3. FUNGSI PEMBUATAN TOMBOL FITUR DI PANEL
local function BuatTombol(txt, parent, varName, labelTxt)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(140, 50, 50)
    b.Text = txt .. ": OFF"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 13
    b.ZIndex = 7
    b.Active = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    
    b.Activated:Connect(function()
        getgenv()[varName] = not getgenv()[varName]
        b.Text = labelTxt .. (getgenv()[varName] and ": ON" or ": OFF")
        b.BackgroundColor3 = getgenv()[varName] and Color3.fromRGB(50, 140, 50) or Color3.fromRGB(140, 50, 50)
    end)
end

BuatTombol("Auto Bid", Cnt, "ABid", "Auto Bid")
BuatTombol("Unload Item", Cnt, "AUnloadItem", "Unload Item")

-- 4. TOMBOL BUKA TUTUP (TOGGLE BUTTON BULAT)
local Tog = Instance.new("TextButton", SG)
Tog.Name = "ToggleButton"
Tog.Size = UDim2.new(0, 50, 0, 50)
Tog.Position = UDim2.new(0, 20, 0, 120)
Tog.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
Tog.Text = "SH"
Tog.TextColor3 = Color3.fromRGB(255, 255, 255)
Tog.Font = Enum.Font.SourceSansBold
Tog.TextSize = 16
Tog.ZIndex = 10
Tog.Active = true
Instance.new("UICorner", Tog).CornerRadius = UDim.new(1, 0)
local TS = Instance.new("UIStroke", Tog)
TS.Color = Color3.fromRGB(150, 150, 150)
TS.Thickness = 2

-- 5. SYSTEM DRAG MOBILE & PC
local function Drag(clickObj, moveObj, isTog)
    local drag, dStart, sPos, moved = false, nil, nil, false
    clickObj.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true moved = false dStart = i.Position sPos = moveObj.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local del = i.Position - dStart
            if del.Magnitude > 5 then moved = true end
            moveObj.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + del.X, sPos.Y.Scale, sPos.Y.Offset + del.Y)
        end
    end)
    if isTog then
        clickObj.InputEnded:Connect(function(i)
            if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) and not moved then
                MF.Visible = not MF.Visible
            end
            drag = false
        end)
    end
end
Drag(Title, MF, false)
Drag(Tog, Tog, true)

-- 6. RUNNER CORE LOOP BACKGROUND (INTERVAL 0.1 DETIK)
task.spawn(function()
    while task.wait(0.1) and SG.Parent do
        local Chr = LocalPlayer.Character
        local Root = Chr and Chr:FindFirstChild("HumanoidRootPart")
        if not Chr or not Root then continue end

        -- [[ 1. LOGIKA AUTO BID ]]
        if getgenv().ABid and BidRem then
            local id, amt
            local AH = LocalPlayer:FindFirstChild("PlayerScripts") and LocalPlayer.PlayerScripts:FindFirstChild("LocalAuctionHandler")
            if AH and AH:IsA("ModuleScript") then
                local s, m = pcall(require, AH)
                if s and type(m) == "table" then
                    id = m.CurrentAuctionID or m.AuctionID or m.StorageID
                    amt = m.CurrentBid or m.NextBid or m.Amount
                end
            end
            if id and amt then BidRem:FireServer(id, amt) else BidRem:FireServer() end
        end

        -- [[ 2. LOGIKA UNLOAD ITEM: REPEAT & DELAY ]]
        if getgenv().AUnloadItem and not IsTeleporting then
            local TargetZone = workspace:FindFirstChild("UnpackZone")
            
            if TargetZone then
                local TargetPos = nil
                if TargetZone:IsA("BasePart") then TargetPos = TargetZone.CFrame
                elseif TargetZone:IsA("Model") then TargetPos = TargetZone:GetPivot() end
                
                if TargetPos then
                    IsTeleporting = true
                    
                    -- A. Potret posisi awal Anda sebelum berteleportasi
                    local OriginalCFrame = Root.CFrame
                    
                    -- B. Teleportasikan karakter tepat di area UnpackZone (+3 Studs ke atas agar aman)
                    Root.CFrame = TargetPos * CFrame.new(0, 3, 0)
                    
                    -- Memberikan waktu 2.5 Detik di tempat agar bisa klik manual tombol unload bawaan game
                    task.wait(2.5) 
                    
                    -- Eksekusi otomatis script module (sebagai backup otomatis jika tombol manual tidak tertekan)
                    local success, module = pcall(require, UnloadModule)
                    if success and type(module) == "table" then
                        if module.Unload then pcall(function() module.Unload() end)
                        elseif module.UnloadVehicle then pcall(function() module.UnloadVehicle() end)
                        elseif module.Execute then pcall(function() module.Execute() end)
                        else
                            for _, func in pairs(module) do
                                if type(func) == "function" then pcall(func) end
                            end
                        end
                    end
                    
                    task.wait(0.2) -- Jeda mikro untuk sinkronisasi server
                    
                    -- C. TELEPORT BALIK secara instan ke posisi awal Anda semula
                    Root.CFrame = OriginalCFrame
                    
                    -- D. JEDA REPEAT/LOOP: Tunggu 2 detik sebelum script diperbolehkan melakukan TP ulang
                    task.wait(2)
                    
                    IsTeleporting = false -- Membuka kunci status agar loop bisa melakukan "Repeat TP"
                end
            end
        end
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Storage Hunter", -- Kata VIP telah dihapus dari notifikasi
    Text = "Script by Gem successfully loaded!",
    Duration = 3
})
