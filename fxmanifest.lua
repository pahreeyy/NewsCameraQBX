fx_version 'cerulean'
game 'gta5'

author 'pahreey'
description 'Pro News Camera with Satellite Signal System'
version '1.1.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_script 'client.lua'
server_script 'server.lua'

dependencies {
    'qbx_core',
    'ox_lib',
    'ox_target',
    'ox_inventory'
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js',
    'ui/news_lower_third_base.png',
    'ui/corner_logo.png'
}