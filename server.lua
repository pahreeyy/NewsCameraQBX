local QBX = exports.qbx_core

-- Mendaftarkan item News Camera agar bisa digunakan
QBX.CreateUseableItem("newscamera", function(source)
    TriggerClientEvent("newscamera:client:use", source)
end)

-- Mendaftarkan item News Transmitter agar bisa digunakan
QBX.CreateUseableItem("newstransmitter", function(source)
    TriggerClientEvent("newscamera:client:setupTransmitter", source)
end)

-- Event untuk hapus item saat transmitter dipasang
RegisterNetEvent('qbx_newscamera:server:removeItem', function()
    local src = source
    -- Pastikan nama item 'newstransmitter' sesuai dengan di database ox_inventory
    exports.ox_inventory:RemoveItem(src, 'newstransmitter', 1)
end)

-- Event untuk kasih item balik saat transmitter diambil
RegisterNetEvent('qbx_newscamera:server:addItem', function()
    local src = source
    exports.ox_inventory:AddItem(src, 'newstransmitter', 1)
end)