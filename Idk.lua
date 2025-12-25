local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Auto Farm | for free UGC",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by Acelestuz",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Automation", 4483362458)

local Settings = {
    LongDrive = false,
    LavaJump = false,
    AutoCombat = false -- Toggle for both Boss and Zombies
}

-- Target coordinates for combat rooms
local CombatPos = Vector3.new(7, 7, -41)

local function ultraFire(prompt)
    if not prompt then return end
    prompt.MaxActivationDistance = 100
    prompt.RequiresLineOfSight = false
    fireproximityprompt(prompt)
end

-- --- UI CONTROLS ---

Tab:CreateToggle({
   Name = "Auto Long Drive",
   CurrentValue = false,
   Callback = function(Value) Settings.LongDrive = Value end,
})

Tab:CreateToggle({
   Name = "Auto Lava Jump",
   CurrentValue = false,
   Callback = function(Value) Settings.LavaJump = Value end,
})

Tab:CreateToggle({
   Name = "Auto Combat (Boss/Zombies)",
   CurrentValue = false,
   Callback = function(Value) Settings.AutoCombat = Value end,
})

Tab:CreateButton({
   Name = "Goto Elevator",
   Callback = function()
      local elevatorPart = game:GetService("ReplicatedStorage"):FindFirstChild("ConfirmedRooms") 
          and game:GetService("ReplicatedStorage").ConfirmedRooms:FindFirstChild("FinalRoom")
          and game:GetService("ReplicatedStorage").ConfirmedRooms.FinalRoom:FindFirstChild("Part")

      if elevatorPart then
         local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
         hrp.CFrame = elevatorPart.CFrame * CFrame.new(0, 3, 0)
      else
         Rayfield:Notify({Title = "Error", Content = "Elevator part not found", Duration = 3})
      end
   end,
})

-- --- MASTER LOGIC ---

workspace.ChildAdded:Connect(function(child)
    local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")

    -- 1. LONG DRIVE
    if child.Name == "LongDrive" and Settings.LongDrive then
        local mainPart = child:WaitForChild("Part", 5)
        if mainPart then hrp.CFrame = mainPart.CFrame * CFrame.new(0, 3, 0) end

        repeat
            local interactable = child:FindFirstChild("InteractablePart")
            if interactable then
                hrp.CFrame = interactable.CFrame * CFrame.new(0, 2, 0)
                ultraFire(interactable:FindFirstChildOfClass("ProximityPrompt"))
            end
            task.wait(0.3)
        until not child.Parent or not Settings.LongDrive
    end

    -- 2. LAVA JUMP
    if child.Name == "LavaJumpRoom" and Settings.LavaJump then
        repeat
            local interactable = child:FindFirstChild("InteractablePart")
            if interactable then
                hrp.CFrame = interactable.CFrame * CFrame.new(0, 2, 0)
                ultraFire(interactable:FindFirstChildOfClass("ProximityPrompt"))
            end
            task.wait(0.3)
        until not child.Parent or not Settings.LavaJump
    end

    -- 3. BOSS FIGHT & ZOMBIE SURVIVAL
    if (child.Name == "ReanimatedBossFight" or child.Name == "ZombieSurviveRoom") and Settings.AutoCombat then
        Rayfield:Notify({Title = "Combat Started", Content = "Teleporting to Safe/Kill Position", Duration = 3})
        
        repeat
            -- Force player to the specific coordinates requested
            hrp.CFrame = CFrame.new(CombatPos)
            task.wait(0.1) -- Fast loop to prevent being knocked back or moved
        until not child.Parent or not Settings.AutoCombat
    end
end)
