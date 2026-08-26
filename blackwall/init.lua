--Author: yakuzadeso

--------------------------------------------------------------------------------
--Settings

MultiTargetRange = 75.00
ShowOnScreenEffects = true
useAnimations = true
drainMemorySingle = false
memoryToDrainSingle = 1
drainMemoryMulti = false
memoryToDrainMulti = 1
drainHealthSingle = false
healthToDrainSingle = 1.0
drainHealthMulti = false
healthToDrainMulti = 1.0
uploadTimeSingle = 0.001
uploadTimeMulti = 0.001
blackwallCooldown = 0.0001
uiTextColor = { 1.0, 1.0, 1.0 }
uiThemeColor = { 0.26, 0.59, 0.98 }
uiWindowBgColor = { 0.06, 0.06, 0.06 }
uiTitleBarColor = { 0.16, 0.29, 0.48 }
vehicleBlackwallEnabled = false
chainSpreadMode = 0
chainSpreadResource = 0
chainSpreadAmount = 1
chainSpreadRange = 20.0

------------------------------------------------------------------------------

Cron = require("Cron.lua")
local Ref = require("Ref")
local myCapturedNpcs = {}
local isPreGameState = true

did = 0
forcedCarryingWounded = false
vfxTriggered = false
drainedHealthMulti = false


function SaveSettings()
    local settings = {
        ShowOnScreenEffects = ShowOnScreenEffects,
        MultiTargetRange = MultiTargetRange,
        useAnimations = useAnimations,
        drainMemorySingle = drainMemorySingle,
        memoryToDrainSingle = memoryToDrainSingle,
        drainMemoryMulti = drainMemoryMulti,
        memoryToDrainMulti = memoryToDrainMulti,
        drainHealthSingle = drainHealthSingle,
        healthToDrainSingle = healthToDrainSingle,
        drainHealthMulti = drainHealthMulti,
        healthToDrainMulti = healthToDrainMulti,
        uploadTimeSingle = uploadTimeSingle,
        uploadTimeMulti = uploadTimeMulti,
        blackwallCooldown = blackwallCooldown,
        uiTextColor = uiTextColor,
        uiThemeColor = uiThemeColor,
        uiWindowBgColor = uiWindowBgColor,
        uiTitleBarColor = uiTitleBarColor,
        vehicleBlackwallEnabled = vehicleBlackwallEnabled,
        chainSpreadMode = chainSpreadMode,
        chainSpreadResource = chainSpreadResource,
        chainSpreadAmount = chainSpreadAmount,
        chainSpreadRange = chainSpreadRange,
    }
    local jsonString = json.encode(settings)

    local file = io.open("settings.json", "w")

    if file then
        file:write(jsonString)
        file:close()
    end
end

function LoadSettings()
    local file = io.open("settings.json", "r")

    if file then
        local jsonString = file:read("*a")
        file:close()

        local settings = json.decode(jsonString)
        if settings then
            ShowOnScreenEffects = settings.ShowOnScreenEffects
            MultiTargetRange = settings.MultiTargetRange
            useAnimations = settings.useAnimations
            drainMemorySingle = settings.drainMemorySingle
            memoryToDrainSingle = settings.memoryToDrainSingle
            drainMemoryMulti = settings.drainMemoryMulti
            memoryToDrainMulti = settings.memoryToDrainMulti
            drainHealthSingle = settings.drainHealthSingle
            healthToDrainSingle = settings.healthToDrainSingle
            drainHealthMulti = settings.drainHealthMulti
            healthToDrainMulti = settings.healthToDrainMulti
            uploadTimeSingle = settings.uploadTimeSingle
            uploadTimeMulti = settings.uploadTimeMulti
            blackwallCooldown = settings.blackwallCooldown
            uiTextColor = settings.uiTextColor
            uiThemeColor = settings.uiThemeColor
            uiWindowBgColor = settings.uiWindowBgColor
            uiTitleBarColor = settings.uiTitleBarColor
            vehicleBlackwallEnabled = settings.vehicleBlackwallEnabled
            chainSpreadMode = settings.chainSpreadMode
            chainSpreadResource = settings.chainSpreadResource
            chainSpreadAmount = settings.chainSpreadAmount
            chainSpreadRange = settings.chainSpreadRange

            -- Guard against corrupted/non-numeric values (e.g. an old error
            -- string accidentally saved into settings.json). Without this,
            -- a bad value here would crash every ImGui.DragInt call below.
            if type(memoryToDrainSingle) ~= 'number' then
                memoryToDrainSingle = 1
            end
            if type(memoryToDrainMulti) ~= 'number' then
                memoryToDrainMulti = 1
            end
            if type(MultiTargetRange) ~= 'number' then
                MultiTargetRange = 75
            end
            if type(healthToDrainSingle) ~= 'number' then
                healthToDrainSingle = 1.0
            end
            if type(healthToDrainMulti) ~= 'number' then
                healthToDrainMulti = 1.0
            end
            if type(drainHealthSingle) ~= 'boolean' then
                drainHealthSingle = false
            end
            if type(drainHealthMulti) ~= 'boolean' then
                drainHealthMulti = false
            end
            if type(uploadTimeSingle) ~= 'number' then
                uploadTimeSingle = 0.001
            end
            if type(uploadTimeMulti) ~= 'number' then
                uploadTimeMulti = 0.001
            end
            if type(blackwallCooldown) ~= 'number' then
                blackwallCooldown = 0.0001
            end
            if type(uiTextColor) ~= 'table' or type(uiTextColor[1]) ~= 'number' or type(uiTextColor[2]) ~= 'number' or type(uiTextColor[3]) ~= 'number' then
                uiTextColor = { 1.0, 1.0, 1.0 }
            end
            if type(uiThemeColor) ~= 'table' or type(uiThemeColor[1]) ~= 'number' or type(uiThemeColor[2]) ~= 'number' or type(uiThemeColor[3]) ~= 'number' then
                uiThemeColor = { 0.26, 0.59, 0.98 }
            end
            if type(vehicleBlackwallEnabled) ~= 'boolean' then
                vehicleBlackwallEnabled = false
            end
            if type(uiWindowBgColor) ~= 'table' or type(uiWindowBgColor[1]) ~= 'number' or type(uiWindowBgColor[2]) ~= 'number' or type(uiWindowBgColor[3]) ~= 'number' then
                uiWindowBgColor = { 0.06, 0.06, 0.06 }
            end
            if type(uiTitleBarColor) ~= 'table' or type(uiTitleBarColor[1]) ~= 'number' or type(uiTitleBarColor[2]) ~= 'number' or type(uiTitleBarColor[3]) ~= 'number' then
                uiTitleBarColor = { 0.16, 0.29, 0.48 }
            end
            if type(chainSpreadMode) ~= 'number' then
                chainSpreadMode = 0
            end
            if type(chainSpreadResource) ~= 'number' then
                chainSpreadResource = 0
            end
            if type(chainSpreadAmount) ~= 'number' then
                chainSpreadAmount = 1
            end
            if type(chainSpreadRange) ~= 'number' then
                chainSpreadRange = 20.0
            end
        end
    end
end

LoadSettings()

function AddActions()
    for _, character in pairs(TweakDB:GetRecords("gamedataCharacter_Record")) do
        local objectActionsRecord = character:GetID() .. ".objectActions"
        if objectActionsRecord ~= nil then
            newArray = TweakDB:GetFlat(objectActionsRecord)

            local containsBaseBlackWallHack = false
            for _, entry in ipairs(newArray) do
                if entry.value == "QuickHack.BaseBlackWallHack" then
                    containsBaseBlackWallHack = true
                    break
                end
            end

            local containsActualBlackWallHack = false
            for _, entry in ipairs(newArray) do
                if entry.value == "QuickHack.BlackWallHack_modified_Single" or entry.value == "QuickHack.BlackWallHack_modified_Multi" then
                    containsActualBlackWallHack = true
                    break
                end
            end

            if containsBaseBlackWallHack and not containsActualBlackWallHack then
                table.insert(newArray, "QuickHack.BlackWallHack_modified_Single")
                table.insert(newArray, "QuickHack.BlackWallHack_modified_Multi")
                TweakDB:SetFlat(objectActionsRecord, newArray)
            end
        end
    end
end

function processCapturedNpcs()
    for i = #myCapturedNpcs, 1, -1 do
        local npc = myCapturedNpcs[i]
        if not IsDefined(npc) then
            table.remove(myCapturedNpcs, i)
        else
            if StatusEffectSystem.ObjectHasStatusEffect(npc, "BaseStatusEffect.SoMi_Q306_BlackwallHackQuestForceKill") then
                StatusEffectHelper.RemoveStatusEffect(npc, "BaseStatusEffect.SoMi_Q306_BlackwallHackQuestForceKill")
                StatusEffectHelper.RemoveStatusEffect(npc, "BaseStatusEffect.BaseBlackWallHackEffect_Trigger_Single")
                StatusEffectHelper.RemoveStatusEffect(npc, "BaseStatusEffect.BaseBlackWallHackEffect_Trigger_Multi")
            end
        end
    end
end

-- Distance between two entities' world positions, computed by hand from the
-- raw x/y/z fields so we don't depend on an unverified Vector4.Distance API.
function DistanceBetween(posA, posB)
    local dx = posA.x - posB.x
    local dy = posA.y - posB.y
    local dz = posA.z - posB.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

-- Finds every living, non-friendly, non-child, non-godmode NPC within range
-- of originPos, sorted nearest-first. excludeEntity (usually the NPC that
-- just died) is skipped.
function FindNearbyEnemies(originPos, range, excludeEntity)
    local player = Game.GetPlayer()
    local targetingSystem = Game.GetTargetingSystem()
    local searchQuery = TSQ_EnemyNPC()
    searchQuery.maxDistance = range + 200.0 -- generous player-relative net; we filter by real distance below
    searchQuery.searchFilter = TSF_And(TSF_Not("Att_Friendly"), TSF_Any("Sp_Aggressive"), TSF_Any("St_Alive"))
    local success, parts = targetingSystem:GetTargetParts(player, searchQuery)

    local candidates = {}
    if parts ~= nil then
        for _, part in ipairs(parts) do
            local candidate = part:GetComponent():GetEntity()
            if IsDefined(candidate) and candidate ~= excludeEntity and ScriptedPuppet.IsActive(candidate) then
                if not Game.GetGodModeSystem():HasGodMode(candidate:GetEntityID(), gameGodModeType.Invulnerable) then
                    local dist = DistanceBetween(originPos, candidate:GetWorldPosition())
                    if dist <= range then
                        table.insert(candidates, { entity = candidate, distance = dist })
                    end
                end
            end
        end
    end

    table.sort(candidates, function(a, b) return a.distance < b.distance end)
    return candidates
end

-- True if the player currently has enough of the chosen resource to pay for
-- one more spread step, without the Health option being able to kill the player.
function CanAffordChainSpread()
    local player = Game.GetPlayer()
    if chainSpreadResource == 1 then
        local health = Game.GetStatPoolsSystem():GetStatPoolValue(player:GetEntityID(), "Health", false)
        return health > chainSpreadAmount
    else
        local ram = Game.GetStatPoolsSystem():GetStatPoolValue(player:GetEntityID(), "Memory", false)
        return ram >= chainSpreadAmount
    end
end

function PayChainSpreadCost()
    local player = Game.GetPlayer()
    if chainSpreadResource == 1 then
        Game.GetStatPoolsSystem():RequestChangingStatPoolValue(player:GetEntityID(), "Health", -chainSpreadAmount,
            player, true, false)
    else
        Game.GetStatPoolsSystem():RequestChangingStatPoolValue(player:GetEntityID(), "Memory", -chainSpreadAmount,
            player, true, false)
    end
end

-- Watches a freshly-hacked target and, once it actually dies, hands off to
-- SpreadBlackwallChain. Polling (rather than an OnDeath-style event we
-- haven't verified exists) keeps this independent of the exact internal
-- timing of the SoMi_Q306_BlackwallHackQuestForceKill kill.
function StartChainDeathWatch(target)
    if chainSpreadMode == 0 then return end
    if not IsDefined(target) then return end

    local elapsed = 0
    local watcher
    watcher = Cron.Every(0.25, { tick = 1 }, function(watcher)
        elapsed = elapsed + 0.25
        if not IsDefined(target) or not ScriptedPuppet.IsActive(target) then
            Cron.Halt(watcher)
            SpreadBlackwallChain(target)
        elseif elapsed >= 15.0 then
            -- Safety valve: stop watching after 15s so a target that never
            -- dies (e.g. immune to the hack) doesn't leave a Cron running forever.
            Cron.Halt(watcher)
        end
    end)
end

-- Called once a hacked target dies. Mode 1 hops to the single nearest enemy
-- and keeps the chain going from there. Mode 2 bursts out to every enemy in
-- range at once and does not keep chaining beyond that.
function SpreadBlackwallChain(deadTarget)
    if chainSpreadMode == 0 then return end
    if not IsDefined(deadTarget) then return end

    local deadPos = deadTarget:GetWorldPosition()
    local candidates = FindNearbyEnemies(deadPos, chainSpreadRange, deadTarget)
    if #candidates == 0 then return end

    if chainSpreadMode == 1 then
        if not CanAffordChainSpread() then return end
        local nextTarget = candidates[1].entity
        PayChainSpreadCost()
        StatusEffectHelper.ApplyStatusEffect(nextTarget, "BaseStatusEffect.SoMi_Q306_BlackwallHackUpload")
        StartChainDeathWatch(nextTarget)
    elseif chainSpreadMode == 2 then
        for _, candidate in ipairs(candidates) do
            if not CanAffordChainSpread() then break end
            PayChainSpreadCost()
            StatusEffectHelper.ApplyStatusEffect(candidate.entity, "BaseStatusEffect.SoMi_Q306_BlackwallHackUpload")
        end
    end
end

function DoAnims()
    local player = Game.GetPlayer()
    if StatusEffectSystem.ObjectHasStatusEffect(player, "GameplayRestriction.BodyCarryingWoundedSoldier") then
        isCarryingWounded = true
    end
    if not isCarryingWounded then
        Game.SetAnimWrapperWeight(Game.GetPlayer(), 'carry_woundedSoldier', 1.0)
        forcedCarryingWounded = true
    end
    handAnim = player:GetBlackboard():GetInt(GetAllBlackboardDefs().BlackwallDeathAnim.handGestureAnimNumber)
    if handAnim < 0 or handAnim == 5 then
        handAnim = 0
    end
    adHocAnimEvent = AdHocAnimationEvent.new()
    adHocAnimEvent.animationIndex = handAnim
    adHocAnimEvent.useBothHands = true
    adHocAnimEvent.unequipWeapon = true
    player:QueueEvent(adHocAnimEvent)
    player:GetBlackboard():SetInt(GetAllBlackboardDefs().BlackwallDeathAnim.handGestureAnimNumber, handAnim + 1)
    Cron.After(1, { tick = 1 }, function()
        if forcedCarryingWounded then
            Game.SetAnimWrapperWeight(Game.GetPlayer(), 'carry_woundedSoldier', 0.0)
            forcedCarryingWounded = false
        end
    end)
end

registerForEvent("onInit", function()
    if drainMemorySingle then
        TweakDB:SetFlat("QuickHack.BlackWallHack_modified_Single.costs",
            { "QuickHack.BaseBlackWallHack_inline7_modified_Single" })
        TweakDB:SetFlat("QuickHack.BaseBlackWallHack_inline8_modified_Single.value", memoryToDrainSingle)
    else
        TweakDB:SetFlat("QuickHack.BlackWallHack_modified_Single.costs", {})
    end

    if drainMemoryMulti then
        TweakDB:SetFlat("QuickHack.BlackWallHack_modified_Multi.costs",
            { "QuickHack.BaseBlackWallHack_inline7_modified_Multi" })
        TweakDB:SetFlat("QuickHack.BaseBlackWallHack_inline8_modified_Multi.value", memoryToDrainMulti)
    else
        TweakDB:SetFlat("QuickHack.BlackWallHack_modified_Multi.costs", {})
    end

    TweakDB:SetFlat("QuickHack.BaseBlackWallHack_inline11_modified_Single.value", uploadTimeSingle)
    TweakDB:SetFlat("QuickHack.BaseBlackWallHack_inline11_modified_Multi.value", uploadTimeMulti)
    TweakDB:SetFlat("BaseStatusEffect.BlackwallCooldown_inline1.value", blackwallCooldown)

    AddActions()

    isPreGameState = Game.GetSystemRequestsHandler():IsPreGame()

    ObserveAfter('PlayerPuppet', 'OnGameAttached', function(this)
        if not this:IsA('PlayerPuppet') then return end
        if this:IsReplacer() then return end
        isPreGameState = Game.GetSystemRequestsHandler():IsPreGame()
        myCapturedNpcs = {} -- clear the table on a new game load
        collectgarbage()    -- and take the opportunity for a cleanup
    end)

    ObserveAfter('NPCPuppet', 'OnGameAttached', function(this)
        if isPreGameState then return end
        if not this:IsA('NPCPuppet') then return end
        if this:IsDrone() then return end
        table.insert(myCapturedNpcs, Ref.Weak(this))
    end)

    Observe("NPCPuppet", "OnQuickHackEffectApplied", function(puppet, event)
        local recordID = TDBID.ToStringDEBUG(event.staticData:GetRecordID())
        if recordID == "BaseStatusEffect.BaseBlackWallHackEffect_Trigger_Single" then
            local player = Game.GetPlayer()
            local target = puppet

            if GameObject.GetActiveWeapon(player) ~= nil then
                wasUnarmed = false
            else
                wasUnarmed = true
            end

            if useAnimations then
                DoAnims()
            end

            Cron.After(1, { tick = 1 }, function()
                if ShowOnScreenEffects then
                    GameObjectEffectHelper.StartEffectEvent(player, "blackwall_use_force")
                end
                if drainHealthSingle then
                    Game.GetStatPoolsSystem():RequestChangingStatPoolValue(player:GetEntityID(), "Health",
                        -healthToDrainSingle, player, true, false)
                end
                StatusEffectHelper.ApplyStatusEffect(target, "BaseStatusEffect.SoMi_Q306_BlackwallHackUpload")
                StartChainDeathWatch(target)
            end)

            Cron.After(2, { tick = 1 }, function()
                if not wasUnarmed then
                    equipmentManipulationRequest = EquipmentSystemWeaponManipulationRequest.new()
                    eqSystem = Game.GetScriptableSystemsContainer():Get('EquipmentSystem')
                    equipmentManipulationRequest.requestType = EquipmentManipulationAction.RequestLastUsedWeapon
                    equipmentManipulationRequest.owner = player
                    eqSystem:QueueRequest(equipmentManipulationRequest)
                end
            end)

            Cron.After(5, { tick = 1 }, function()
                processCapturedNpcs()
            end)
        else
            if recordID == "BaseStatusEffect.BaseBlackWallHackEffect_Trigger_Multi" then
                local player = Game.GetPlayer()

                if GameObject.GetActiveWeapon(player) ~= nil then
                    wasUnarmed = false
                else
                    wasUnarmed = true
                end

                targetingSystem = Game.GetTargetingSystem()
                parts = {}
                searchQuery = TSQ_EnemyNPC()
                searchQuery.maxDistance = MultiTargetRange
                searchQuery.searchFilter = TSF_And(TSF_Not("Att_Friendly"), TSF_Any("Sp_Aggressive"), TSF_Any("St_Alive"))
                success, parts = targetingSystem:GetTargetParts(player, searchQuery)

                if parts ~= nil then
                    for _, enemies in ipairs(parts) do
                        local targets = enemies:GetComponent():GetEntity()
                        if Game.GetGodModeSystem():HasGodMode(targets:GetEntityID(), gameGodModeType.Invulnerable) then
                            -- targets:Kill(player, false, false)
                            -- do nothing
                        else
                            if did == 0 then
                                if useAnimations then
                                    DoAnims()
                                end
                            end
                            Cron.After(1, { tick = 1 }, function()
                                StatusEffectHelper.ApplyStatusEffect(targets,
                                    "BaseStatusEffect.SoMi_Q306_BlackwallHackUpload", 0.0)
                                if ShowOnScreenEffects and not vfxTriggered then
                                    GameObjectEffectHelper.StartEffectEvent(player, "blackwall_use_force")
                                end
                                if drainHealthMulti and not drainedHealthMulti then
                                    Game.GetStatPoolsSystem():RequestChangingStatPoolValue(player:GetEntityID(),
                                        "Health", -healthToDrainMulti, player, true, false)
                                end
                                vfxTriggered = true
                                drainedHealthMulti = true
                            end)
                            did = did + 1
                        end
                    end

                    vfxTriggered = false
                    drainedHealthMulti = false
                    did = 0

                    Cron.After(2, { tick = 1 }, function()
                        if not wasUnarmed then
                            equipmentManipulationRequest = EquipmentSystemWeaponManipulationRequest.new()
                            eqSystem = Game.GetScriptableSystemsContainer():Get('EquipmentSystem')
                            equipmentManipulationRequest.requestType = EquipmentManipulationAction.RequestLastUsedWeapon
                            equipmentManipulationRequest.owner = player
                            eqSystem:QueueRequest(equipmentManipulationRequest)
                        end
                    end)

                    Cron.After(5, { tick = 1 }, function()
                        processCapturedNpcs()
                    end)
                end
            end
        end
    end)
end)

registerForEvent("onUpdate", function(dt)
    Cron.Update(dt)
end)

registerInput('BlackwallSoundBugFix', 'BlackwallSoundBugFix', function(isKeyDown)
    if not isKeyDown then
        return
    end
    processCapturedNpcs()
end)

-- Applies the Blackwall upload effect directly to a crosshair-targeted vehicle.
-- Ported from the old "Custom Blackwall Quickhacks" mod, which used this exact
-- pattern (StatusEffectHelper.ApplyStatusEffect on a GameObject.IsVehicle target)
-- since vehicles are not reachable through the NPCPuppet QuickHack menu that the
-- rest of this mod relies on.
registerInput('VehicleBlackwall', 'Arac/Cihaz Blackwall', function(isKeyDown)
    if not isKeyDown then
        return
    end
    if not vehicleBlackwallEnabled then
        return
    end

    local player = Game.GetPlayer()
    local searchQuery = Game["TSQ_ALL;"]()
    local target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)
    if target == nil then
        target = Game.GetTargetingSystem():GetObjectClosestToCrosshair(player, searchQuery)
    end
    if target == nil then
        return
    end
    if not GameObject.IsVehicle(target) then
        return
    end
    if Game.GetGodModeSystem():HasGodMode(target:GetEntityID(), gameGodModeType.Invulnerable) then
        return
    end

    if useAnimations then
        DoAnims()
    end

    if ShowOnScreenEffects then
        GameObjectEffectHelper.StartEffectEvent(player, "blackwall_use_force")
    end

    StatusEffectHelper.ApplyStatusEffect(target, "BaseStatusEffect.SoMi_Q306_BlackwallHackUpload")
end)

registerForEvent("onOverlayOpen", function()
    isOverlayOpen = true
end)

registerForEvent("onOverlayClose", function()
    isOverlayOpen = false
end)

registerForEvent("onDraw", function()
    if isOverlayOpen then
        ImGui.SetNextWindowPos(100, 100, ImGuiCond.FirstUseEver)
        ImGui.SetNextWindowSize(550, 550, ImGuiCond.FirstUseEver)

        ImGui.PushStyleColor(ImGuiCol.WindowBg, uiWindowBgColor[1], uiWindowBgColor[2], uiWindowBgColor[3], 0.94)
        ImGui.PushStyleColor(ImGuiCol.TitleBg, uiTitleBarColor[1], uiTitleBarColor[2], uiTitleBarColor[3], 1.0)
        ImGui.PushStyleColor(ImGuiCol.TitleBgActive, uiTitleBarColor[1], uiTitleBarColor[2], uiTitleBarColor[3], 1.0)
        ImGui.PushStyleColor(ImGuiCol.TitleBgCollapsed, uiTitleBarColor[1], uiTitleBarColor[2], uiTitleBarColor[3], 0.75)

        ImGui.Begin("Actual Blackwall Quickhacks")

        ImGui.PushStyleColor(ImGuiCol.Text, uiTextColor[1], uiTextColor[2], uiTextColor[3], 1.0)
        ImGui.PushStyleColor(ImGuiCol.FrameBg, uiThemeColor[1], uiThemeColor[2], uiThemeColor[3], 0.54)
        ImGui.PushStyleColor(ImGuiCol.FrameBgHovered, uiThemeColor[1], uiThemeColor[2], uiThemeColor[3], 0.74)
        ImGui.PushStyleColor(ImGuiCol.FrameBgActive, uiThemeColor[1], uiThemeColor[2], uiThemeColor[3], 1.0)
        ImGui.PushStyleColor(ImGuiCol.SliderGrab, uiThemeColor[1], uiThemeColor[2], uiThemeColor[3], 1.0)
        ImGui.PushStyleColor(ImGuiCol.SliderGrabActive, uiThemeColor[1], uiThemeColor[2], uiThemeColor[3], 1.0)
        ImGui.PushStyleColor(ImGuiCol.CheckMark, uiThemeColor[1], uiThemeColor[2], uiThemeColor[3], 1.0)
        ImGui.PushStyleColor(ImGuiCol.Button, uiThemeColor[1], uiThemeColor[2], uiThemeColor[3], 0.6)
        ImGui.PushStyleColor(ImGuiCol.ButtonHovered, uiThemeColor[1], uiThemeColor[2], uiThemeColor[3], 0.8)
        ImGui.PushStyleColor(ImGuiCol.ButtonActive, uiThemeColor[1], uiThemeColor[2], uiThemeColor[3], 1.0)

        width = ImGui.GetWindowContentRegionWidth()
        Text_x1, Text_y1 = ImGui.CalcTextSize("                   ")
        SingleTargetCooldown_x, SingleTargetCooldown_y = ImGui.CalcTextSize("Yeniden Kullanim Süresi (Cooldown)")

        ImGui.Text("Ayarlar")
        ImGui.Spacing()
        ImGui.Separator()
        ImGui.Spacing()

        uiTextColor, toggled = ImGui.ColorEdit3("Yazi Rengi", uiTextColor)
        if toggled then
            SaveSettings()
        end

        uiThemeColor, toggled = ImGui.ColorEdit3("Arayuz Rengi (Mavi Ton)", uiThemeColor)
        if toggled then
            SaveSettings()
        end

        uiWindowBgColor, toggled = ImGui.ColorEdit3("Arka Plan Rengi", uiWindowBgColor)
        if toggled then
            SaveSettings()
        end

        uiTitleBarColor, toggled = ImGui.ColorEdit3("Baslik Cubugu Rengi", uiTitleBarColor)
        if toggled then
            SaveSettings()
        end

        uiWindowBgColor, toggled = ImGui.ColorEdit3("Arka Plan Rengi", uiWindowBgColor)
        if toggled then
            SaveSettings()
        end

        uiTitleBarColor, toggled = ImGui.ColorEdit3("Baslik Cubugu Rengi", uiTitleBarColor)
        if toggled then
            SaveSettings()
        end

        ImGui.Spacing()
        ImGui.Separator()
        ImGui.Spacing()

        ShowOnScreenEffects, toggled = ImGui.Checkbox("Ekran Efektlerini Göster", ShowOnScreenEffects)
        if toggled then
            SaveSettings()
        end

        useAnimations, toggled = ImGui.Checkbox("Animasyonlari Kullan", useAnimations)
        if toggled then
            SaveSettings()
        end

        if ImGui.IsItemHovered()
        then
            ImGui.BeginTooltip()
            ImGui.SetTooltip("El animasyonlarinin kullanilip kullanilmayacagi.")
            ImGui.EndTooltip()
        end

        drainMemorySingle, toggled = ImGui.Checkbox("RAM Tüket (Tekli Hedef)", drainMemorySingle)
        if toggled then
            SaveSettings()
        end

        if ImGui.IsItemHovered()
        then
            ImGui.BeginTooltip()
            ImGui.SetTooltip("Yetenek kullanildiginda RAM'inizin tüketilip tüketilmeyecegi.")
            ImGui.EndTooltip()
        end

        drainMemoryMulti, toggled = ImGui.Checkbox("RAM Tüket (Çoklu Hedef)", drainMemoryMulti)
        if toggled then
            SaveSettings()
        end

        if ImGui.IsItemHovered()
        then
            ImGui.BeginTooltip()
            ImGui.SetTooltip("Yetenek kullanildiginda RAM'inizin tüketilip tüketilmeyecegi.")
            ImGui.EndTooltip()
        end

        drainHealthSingle, toggled = ImGui.Checkbox("Can Tüket (Tekli Hedef)", drainHealthSingle)
        if toggled then
            SaveSettings()
        end

        if ImGui.IsItemHovered()
        then
            ImGui.BeginTooltip()
            ImGui.SetTooltip("Yetenek kullanildiginda caninizin tüketilip tüketilmeyecegi.")
            ImGui.EndTooltip()
        end

        drainHealthMulti, toggled = ImGui.Checkbox("Can Tüket (Çoklu Hedef)", drainHealthMulti)
        if toggled then
            SaveSettings()
        end

        if ImGui.IsItemHovered()
        then
            ImGui.BeginTooltip()
            ImGui.SetTooltip("Yetenek kullanildiginda caninizin tüketilip tüketilmeyecegi.")
            ImGui.EndTooltip()
        end

        vehicleBlackwallEnabled, toggled = ImGui.Checkbox("Arac/Cihaz Hedeflemeyi Etkinlestir", vehicleBlackwallEnabled)
        if toggled then
            SaveSettings()
        end

        if ImGui.IsItemHovered()
        then
            ImGui.BeginTooltip()
            ImGui.SetTooltip("Nisan aldiginiz arac/cihazi Blackwall ile hackleyip patlatmanizi saglar. Etkinlestirdikten sonra CET'in Bindings sekmesinden 'Arac/Cihaz Blackwall' islemine bir tus atamaniz gerekir.")
            ImGui.EndTooltip()
        end

        ImGui.Spacing()
        ImGui.Separator()
        ImGui.Spacing()

        ImGui.Text("Zincirleme Yayilma (Tekli Hedef)")

        chainSpreadMode, toggled = ImGui.Combo("Yayilma Modu", chainSpreadMode,
            { "Kapali", "Teker Teker", "Çevreye Yayilma" }, 3)
        if toggled then
            SaveSettings()
        end
        if ImGui.IsItemHovered()
        then
            ImGui.BeginTooltip()
            ImGui.SetTooltip("Kapali: hack sadece ilk hedefi etkiler. Teker Teker: hedef olünce en yakin bir dusmana atlar ve zincir oyle devam eder. Çevreye Yayilma: hedef ölünce menzil icindeki TÜM dusmanlara ayni anda yayilir (tek seferlik).")
            ImGui.EndTooltip()
        end

        chainSpreadResource, toggled = ImGui.Combo("Yayilma Maliyeti Kaynagi", chainSpreadResource, { "RAM", "Can" }, 2)
        if toggled then
            SaveSettings()
        end

        ImGui.PushItemWidth(width - SingleTargetCooldown_x - Text_x1)
        chainSpreadAmount, toggled = ImGui.DragFloat("Yayilma Basina Maliyet", chainSpreadAmount, 0.5, 0.1, 100.0,
            "%.2f", 1)
        if toggled then
            chainSpreadAmount = chainSpreadAmount
            SaveSettings()
        end
        if ImGui.IsItemHovered()
        then
            ImGui.BeginTooltip()
            ImGui.SetTooltip("Zincirdeki her yeni yayilma adimi icin harcanacak RAM ya da Can miktari.")
            ImGui.EndTooltip()
        end
        ImGui.PopItemWidth()

        ImGui.PushItemWidth(width - SingleTargetCooldown_x - Text_x1)
        chainSpreadRange, toggled = ImGui.DragFloat("Yayilma Menzili", chainSpreadRange, 0.5, 1.0, 100.0, "%.1f", 1)
        if toggled then
            chainSpreadRange = chainSpreadRange
            SaveSettings()
        end
        if ImGui.IsItemHovered()
        then
            ImGui.BeginTooltip()
            ImGui.SetTooltip("Ölen hedefin etrafinda yeni hedef aranacak yaricap (metre).")
            ImGui.EndTooltip()
        end
        ImGui.PopItemWidth()

        ImGui.Spacing()
        ImGui.Separator()
        ImGui.Spacing()

        ImGui.PushItemWidth(width - SingleTargetCooldown_x - Text_x1)
        MultiTargetRange, toggled = ImGui.DragInt("Çoklu Hedef Menzili", MultiTargetRange, 1, 1, 500)
        if toggled then
            MultiTargetRange = MultiTargetRange
            SaveSettings()
        end
        if ImGui.IsItemHovered()
        then
            ImGui.BeginTooltip()
            ImGui.SetTooltip("Min: 1, Maks: 500, Sürükleyin veya yazmak için çift tiklayin.")
            ImGui.EndTooltip()
        end
        ImGui.PopItemWidth()

        ImGui.PushItemWidth(width - SingleTargetCooldown_x - Text_x1)
        uploadTimeSingle, toggled = ImGui.DragFloat("Yükleme Süresi (Tekli Hedef)", uploadTimeSingle, 0.05, 0.001, 10.0,
            "%.3f", 1)
        if toggled then
            uploadTimeSingle = uploadTimeSingle
            TweakDB:SetFlat("QuickHack.BaseBlackWallHack_inline11_modified_Single.value", uploadTimeSingle)
            SaveSettings()
        end
        if ImGui.IsItemHovered()
        then
            ImGui.BeginTooltip()
            ImGui.SetTooltip("Hackin tetiklenmeden önce hedefin basindaki yükleme çubugunun dolma süresi (saniye). Min: 0.001, Maks: 10, Sürükleyin veya yazmak için çift tiklayin.")
            ImGui.EndTooltip()
        end
        ImGui.PopItemWidth()

        ImGui.PushItemWidth(width - SingleTargetCooldown_x - Text_x1)
        uploadTimeMulti, toggled = ImGui.DragFloat("Yükleme Süresi (Çoklu Hedef)", uploadTimeMulti, 0.05, 0.001, 10.0,
            "%.3f", 1)
        if toggled then
            uploadTimeMulti = uploadTimeMulti
            TweakDB:SetFlat("QuickHack.BaseBlackWallHack_inline11_modified_Multi.value", uploadTimeMulti)
            SaveSettings()
        end
        if ImGui.IsItemHovered()
        then
            ImGui.BeginTooltip()
            ImGui.SetTooltip("Hackin tetiklenmeden önce hedeflerin basindaki yükleme çubugunun dolma süresi (saniye). Min: 0.001, Maks: 10, Sürükleyin veya yazmak için çift tiklayin.")
            ImGui.EndTooltip()
        end
        ImGui.PopItemWidth()

        ImGui.PushItemWidth(width - SingleTargetCooldown_x - Text_x1)
        blackwallCooldown, toggled = ImGui.DragFloat("Yeniden Kullanim Süresi (Cooldown)", blackwallCooldown, 0.5, 0.0001, 120.0,
            "%.4f", 1)
        if toggled then
            blackwallCooldown = blackwallCooldown
            TweakDB:SetFlat("BaseStatusEffect.BlackwallCooldown_inline1.value", blackwallCooldown)
            SaveSettings()
        end
        if ImGui.IsItemHovered()
        then
            ImGui.BeginTooltip()
            ImGui.SetTooltip("Blackwall'i kullandiktan sonra tekrar kullanabilmek için beklemeniz gereken süre ('YENIDEN DERLENIYOR...' çubugu), saniye cinsinden. Min: 0.0001, Maks: 120, Sürükleyin veya yazmak için çift tiklayin.")
            ImGui.EndTooltip()
        end
        ImGui.PopItemWidth()

        if drainMemorySingle then
            TweakDB:SetFlat("QuickHack.BlackWallHack_modified_Single.costs",
                { "QuickHack.BaseBlackWallHack_inline7_modified_Single" })
            TweakDB:SetFlat("QuickHack.BaseBlackWallHack_inline8_modified_Single.value", memoryToDrainSingle)

            maxMemory = Game.GetStatPoolsSystem():GetStatPoolMaxPointValue(Game.GetPlayer():GetEntityID(), "Memory")
            if maxMemory == nil or maxMemory == 0 then
                maxMemory = 2
            end
            -- GetStatPoolMaxPointValue returns a float; DragInt needs an
            -- integer or sol2 can't match the overload and throws.
            maxMemory = math.floor(maxMemory)
            memoryToDrainSingle = math.floor(memoryToDrainSingle)
            ImGui.PushItemWidth(width - SingleTargetCooldown_x - Text_x1)
            memoryToDrainSingle, toggled = ImGui.DragInt("Tüketilecek RAM (Tekli Hedef)", memoryToDrainSingle, 1, 1,
                maxMemory)
            if toggled then
                memoryToDrainSingle = memoryToDrainSingle
                TweakDB:SetFlat("QuickHack.BaseBlackWallHack_inline8_modified_Single.value", memoryToDrainSingle)
                SaveSettings()
            end
            if ImGui.IsItemHovered()
            then
                ImGui.BeginTooltip()
                ImGui.SetTooltip("Min: 1, Maks: " .. maxMemory .. ", Sürükleyin veya yazmak için çift tiklayin.")
                ImGui.EndTooltip()
            end
            ImGui.PopItemWidth()
        else
            TweakDB:SetFlat("QuickHack.BlackWallHack_modified_Single.costs", {})
        end

        if drainMemoryMulti then
            TweakDB:SetFlat("QuickHack.BlackWallHack_modified_Multi.costs",
                { "QuickHack.BaseBlackWallHack_inline7_modified_Multi" })
            TweakDB:SetFlat("QuickHack.BaseBlackWallHack_inline8_modified_Multi.value", memoryToDrainMulti)

            maxMemory = Game.GetStatPoolsSystem():GetStatPoolMaxPointValue(Game.GetPlayer():GetEntityID(), "Memory")
            if maxMemory == nil or maxMemory == 0 then
                maxMemory = 2
            end
            -- Same float/int fix as the single-target slider above.
            maxMemory = math.floor(maxMemory)
            memoryToDrainMulti = math.floor(memoryToDrainMulti)
            ImGui.PushItemWidth(width - SingleTargetCooldown_x - Text_x1)
            memoryToDrainMulti, toggled = ImGui.DragInt("Tüketilecek RAM (Çoklu Hedef)", memoryToDrainMulti, 1, 1,
                maxMemory)
            if toggled then
                memoryToDrainMulti = memoryToDrainMulti
                TweakDB:SetFlat("QuickHack.BaseBlackWallHack_inline8_modified_Multi.value", memoryToDrainMulti)
                SaveSettings()
            end
            if ImGui.IsItemHovered()
            then
                ImGui.BeginTooltip()
                ImGui.SetTooltip("Min: 1, Maks: " .. maxMemory .. ", Sürükleyin veya yazmak için çift tiklayin.")
                ImGui.EndTooltip()
            end
            ImGui.PopItemWidth()
        else
            TweakDB:SetFlat("QuickHack.BlackWallHack_modified_Multi.costs", {})
        end

        if drainHealthSingle then
            maxHealth = Game.GetStatPoolsSystem():GetStatPoolMaxPointValue(Game.GetPlayer():GetEntityID(), "Health")
            if maxHealth == nil or maxHealth <= 1 then
                maxHealth = 2
            end
            ImGui.PushItemWidth(width - SingleTargetCooldown_x - Text_x1)
            healthToDrainSingle, toggled = ImGui.DragFloat("Tüketilecek Can (Tekli Hedef)", healthToDrainSingle, 1,
                1, maxHealth - 1, "%.3f", 16)
            if toggled then
                healthToDrainSingle = healthToDrainSingle
                SaveSettings()
            end
            if ImGui.IsItemHovered()
            then
                ImGui.BeginTooltip()
                ImGui.SetTooltip("Min: 1, Maks: " .. (maxHealth - 1) .. ", Sürükleyin veya yazmak için çift tiklayin.")
                ImGui.EndTooltip()
            end
            ImGui.PopItemWidth()
        end

        if drainHealthMulti then
            maxHealth = Game.GetStatPoolsSystem():GetStatPoolMaxPointValue(Game.GetPlayer():GetEntityID(), "Health")
            if maxHealth == nil or maxHealth <= 1 then
                maxHealth = 2
            end
            ImGui.PushItemWidth(width - SingleTargetCooldown_x - Text_x1)
            healthToDrainMulti, toggled = ImGui.DragFloat("Tüketilecek Can (Çoklu Hedef)", healthToDrainMulti, 1,
                1, maxHealth - 1, "%.3f", 16)
            if toggled then
                healthToDrainMulti = healthToDrainMulti
                SaveSettings()
            end
            if ImGui.IsItemHovered()
            then
                ImGui.BeginTooltip()
                ImGui.SetTooltip("Min: 1, Maks: " .. (maxHealth - 1) .. ", Sürükleyin veya yazmak için çift tiklayin.")
                ImGui.EndTooltip()
            end
            ImGui.PopItemWidth()
        end

        ImGui.PopStyleColor(10)

        ImGui.End()

        ImGui.PopStyleColor(4)
    end
end)
