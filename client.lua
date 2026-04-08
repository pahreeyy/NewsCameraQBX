-- ==========================================================================================
-- IME NEWS CAMERA
-- Developed by: pahreeyy#2747 (Motion Line Media)
-- Features: Dynamic Signal, Transmitter System, Multi-UI Toggle.
-- ==========================================================================================

local QBX = exports.qbx_core
local usingCamera = false
local cameraProp = nil
local activeTransmitter = nil 
local lastBeepTime = 0

-- Zoom & Rotation Settings
local fov_max, fov_min = 70.0, 5.0
local current_fov, target_fov = 37.5, 37.5
local zoomSpeed, speed_lr, speed_ud = 2.0, 3.0, 3.0

-- ==========================================
-- NEW FEATURE: UI HELPERS
-- ==========================================
local function DrawLetterbox()
    -- Bar Atas
    DrawRect(0.5, 0.05, 1.0, 0.1, 0, 0, 0, 255)
    -- Bar Bawah
    DrawRect(0.5, 0.95, 1.0, 0.1, 0, 0, 0, 255)
end

-- ==========================================
-- HELPER: ANIMASI & SIGNAL
-- ==========================================
local function PlayTransmitterAnim(ped)
    local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(10) end
    TaskPlayAnim(ped, animDict, "machinic_loop_mechandplayer", 8.0, -8.0, -1, 1, 0, false, false, false)
end

local function GetBestSignalSource()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local source, minDist = nil, 999.0

    -- Kita panggil Config langsung di sini agar tidak nil
    for _, model in ipairs(Config.NewsVehicles) do
        local veh = GetClosestVehicle(pos.x, pos.y, pos.z, Config.MaxDistance, model, 70)
        if DoesEntityExist(veh) then
            local dist = #(pos - GetEntityCoords(veh))
            if dist < minDist then minDist = dist; source = veh end
        end
    end

    if activeTransmitter and DoesEntityExist(activeTransmitter) then
        local dist = #(pos - GetEntityCoords(activeTransmitter))
        if dist < minDist then minDist = dist; source = activeTransmitter end
    end
    return source, minDist
end

-- ==========================================
-- FEATURE: TRANSMITTER
-- ==========================================
local function PickUpTransmitter()
    local ped = PlayerPedId()
    if activeTransmitter and DoesEntityExist(activeTransmitter) then
        PlayTransmitterAnim(ped)
        exports.qbx_core:Notify("Mengambil Transmitter...", "primary")
        Wait(3000)
        TriggerServerEvent('qbx_newscamera:server:addItem') 
        exports.ox_target:removeLocalEntity(activeTransmitter, 'pickup_transmitter')
        DeleteObject(activeTransmitter)
        activeTransmitter = nil
        ClearPedTasks(ped)
    end
end

RegisterNetEvent('newscamera:client:setupTransmitter', function()
    local playerData = QBX.GetPlayerData()
    if playerData.job.name ~= Config.JobName then
        exports.qbx_core:Notify("Hanya " .. Config.JobName .. " yang bisa menggunakan ini!", "error")
        return
    end

    if activeTransmitter and DoesEntityExist(activeTransmitter) then 
        exports.qbx_core:Notify("Transmitter sudah terpasang!", "error")
        return 
    end

    local ped = PlayerPedId()
    local model = `ch_prop_ch_mobile_jammer_01x` 
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    
    PlayTransmitterAnim(ped)
    exports.qbx_core:Notify("Sinkronisasi Satelit...", "primary")
    Wait(4000)
    
    TriggerServerEvent('qbx_newscamera:server:removeItem') 
    local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.7, 0.0)
    activeTransmitter = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)
    PlaceObjectOnGroundProperly(activeTransmitter)
    
    exports.ox_target:addLocalEntity(activeTransmitter, {
        {
            name = 'pickup_transmitter',
            icon = 'fa-solid fa-hand-holding',
            label = 'Ambil Transmitter',
            onSelect = function() PickUpTransmitter() end,
            canInteract = function()
                return QBX.GetPlayerData().job.name == Config.JobName
            end
        }
    })
    ClearPedTasks(ped)
end)

-- ==========================================
-- UI & CAMERA LOGIC
-- ==========================================
local function SetupScaleform(header, title, summary)
    local handle = RequestScaleformMovie("BREAKING_NEWS")
    while not HasScaleformMovieLoaded(handle) do Wait(0) end
    
    PushScaleformMovieFunction(handle, "SET_TEXT")
    PushScaleformMovieFunctionParameterString(header) 
    PushScaleformMovieFunctionParameterString(title)
    PopScaleformMovieFunctionVoid()
    
    return handle
end

function StartNewsCamera(header, title, summary)
    CreateThread(function()
        local ped = PlayerPedId()
        local uiMode = 1 -- 1: News, 2: Letterbox, 3: Clear
        
        local model = `prop_v_cam_01`
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(100) end
        cameraProp = CreateObject(model, 0.0, 0.0, 0.0, true, true, false)
        
        AttachEntityToEntity(cameraProp, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        
        RequestAnimDict("missfinale_c2mcs_1")
        while not HasAnimDictLoaded("missfinale_c2mcs_1") do Wait(100) end
        TaskPlayAnim(ped, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 8.0, -8.0, -1, 49, 0, false, false, false)

        local cam = CreateCam('DEFAULT_SCRIPTED_FLY_CAMERA', true)
        AttachCamToEntity(cam, ped, 0.0, 0.0, 1.0, true)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(ped), 2)
        RenderScriptCams(true, false, 0, true, false)

        local ui = SetupScaleform(header, title, summary)
        usingCamera = true

        while usingCamera do
            Wait(0)
            local source, dist = GetBestSignalSource()

            if IsControlJustPressed(0, 47) then
                uiMode = uiMode + 1
                if uiMode > 3 then uiMode = 1 end
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
            end

            if not source or dist > Config.MaxDistance then
                exports.qbx_core:Notify("Sinyal Hilang!", "error")
                usingCamera = false
            else
                local intensity = (dist - Config.WarningDistance) / (Config.MaxDistance - Config.WarningDistance)
                if intensity < 0 then intensity = 0 end
                local signalPercent = math.floor((1.0 - intensity) * 100)
                
                local r, g, b, a = 255, 255, 255, 180
                if signalPercent < 60 then
                    if GetGameTimer() - lastBeepTime > 1500 then
                        PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                        lastBeepTime = GetGameTimer()
                    end
                    if GetGameTimer() - lastBeepTime < 500 then r, g, b, a = 255, 0, 0, 255 end
                end

                if uiMode ~= 3 then
                    SetTextFont(0)
                    SetTextScale(0.35, 0.35)
                    SetTextColour(r, g, b, a)
                    SetTextEntry("STRING")
                    AddTextComponentString("SIGNAL: " .. signalPercent .. "%")
                    DrawText(0.05, uiMode == 2 and 0.11 or 0.05)
                end
            end

            if uiMode == 1 then
                DrawScaleformMovieFullscreen(ui, 255, 255, 255, 255, 0)
            elseif uiMode == 2 then
                DrawLetterbox()
            end
            
            DisableControlAction(0, 24, true) 
            DisableControlAction(0, 25, true) 
            DisableControlAction(0, 140, true) 
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 22, true) 

            local camRot = GetCamRot(cam, 2)
            local mouseX = GetDisabledControlNormal(0, 1)
            local mouseY = GetDisabledControlNormal(0, 2)
            
            if mouseX ~= 0.0 or mouseY ~= 0.0 then
                local newZ = camRot.z + mouseX * -speed_lr
                local newX = math.max(math.min(25.0, camRot.x + mouseY * -speed_ud), -89.5)
                SetCamRot(cam, newX, 0.0, newZ, 2)
                SetEntityHeading(ped, newZ)
            end

            if IsControlJustPressed(0, 241) then target_fov = math.max(target_fov - zoomSpeed, fov_min) end
            if IsControlJustPressed(0, 242) then target_fov = math.min(target_fov + zoomSpeed, fov_max) end
            current_fov = current_fov + (target_fov - current_fov) * 0.05
            SetCamFov(cam, current_fov)

            if IsControlJustPressed(0, 177) then usingCamera = false end
            HideHudAndRadarThisFrame()
        end

        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(cam, false)
        DeleteObject(cameraProp)
        ClearPedTasks(ped)
        SetScaleformMovieAsNoLongerNeeded(ui)
    end)
end

-- TRIGGER CAMERA
RegisterNetEvent('newscamera:client:use', function()
    -- PENGAMAN: Jika Config belum ter-load, paksa ambil ulang
    if not Config then 
        print("^1[ERROR] Config tidak ditemukan! Pastikan shared_script 'config.lua' ada di manifest.^7")
        return 
    end

    local playerData = QBX.GetPlayerData()
    if playerData.job.name == Config.JobName then
        if not usingCamera then
            local source = GetBestSignalSource()
            if source then
                local input = lib.inputDialog('News Camera Config', {
                    {type = 'input', label = 'Box Tengah (Merah)', default = 'LOS SANTOS', required = true},
                    {type = 'input', label = 'Box Bawah (Hitam)', default = 'LIVE REPORT', required = true},
                })
                if input then StartNewsCamera(input[1], input[2], input[3]) end
            else
                exports.qbx_core:Notify("Butuh Link Satelit!", "error")
            end
        else
            usingCamera = false
        end
    else
        exports.qbx_core:Notify("Hanya " .. Config.JobName .. "!", "error")
    end
end)