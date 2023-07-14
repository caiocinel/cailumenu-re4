-- ChenStack Trainer for Resident Evil 4
-- Author: chenstack

local version = "1.0.5"
local cfg_path = "chenstack_trainer/config.json"

local default_cfg = {
    use_english = false,
    GameRankEnable = false,
    GameRank = 1,
    ItemPoint = 0,
    EnemyWinceRateEnable = false,
    EnemyWinceRate = 2.0,
    EnemyBreakRateEnable = false,
    EnemyBreakRate = 2.0,
    EnemyDamageRateEnable = false,
    EnemyDamageRate = 2.0,
    EnemyStoppingRateEnable = false,
    EnemyStoppingRate = 2.0,
    KnifeReduceRateEnable = false,
    KnifeReduceRate = 0.0,
    PlayerDamageRateEnable = false,
    PlayerDamageRate = 0.5,
    GunCriticalRateEnable = false,
    GunCriticalRate = 100,
    PlayerRunSpeedRateEnable = false,
    PlayerRunSpeedRate = 2.0,
    PlayerSpeedRateEnable = false,
    PlayerSpeedRate = 2.0,
    PartnerSpeedRateEnable = false,
    PartnerSpeedRate = 2.0,
    EnemySpeedRateEnable = false,
    EnemySpeedRate = 0.5,
    ReloadSpeedRateEnable = false,
    ReloadSpeedRate = 2.0,
    StopClock = false,
    EnemyPause = false,
    NoReload = false,
    InfiniteAmmo = false,
    NoRecoil = false,
    PerfectAccuracy = false,
    ItemCountNotSub = false,
    ItemDurabilityNotSub = false,
    ShootTypeFullAuto = false,
    RapidFire = false,
    SuperRapidFire = false,
    SuperRapidFireSpeed = 0.2,
    SuperRapidFireInterp = 8.0,
    RapidGrenade = false,
    RapidGrenadeSpeed = 0.8,
    RapidGrenadeInterp = 8.0,
    RapidKnife = false,
    RapidKnifeSpeed = 0.2,
    RapidKnifeInterp = 8.0,
    PlayerInvincible = false,
    PartnerInvincible = false,
    IgnoreTrap = false,
    HealthEnable = false,
    DropItemMultEnable = false,
    DropItemMult = 2.0,
    PickItemMultEnable = false,
    PickItemMult = 2.0,
    FullHealthHotKey = {},
    ToggleHugHotKey = {},
    EnemyPauseHotKey = {},
    EnemySpeedRateHotKey = {},
    MoveToAiming = false,
    MoveToAimingInterp = true,
    MoveToAimingHotKey = {},
    MoveToAimingBackHotKey = {},
    MoveTowardsCameraHotKey = {},
    MoveTowardsCameraDistance = 1,
}

local range_define = {
    GameRank = { 0, 11, "%.0f" },
    ItemPoint = { 0, 100000, "%.0f" },
    EnemyWinceRate = { 0.5, 5 },
    EnemyBreakRate = { 0.5, 5 },
    EnemyDamageRate = { 0.5, 5 },
    EnemyStoppingRate = { 0.5, 5 },
    KnifeReduceRate = { 0, 1.5 },
    PlayerDamageRate = { 0, 1.5 },
    PlayerRunSpeedRate = { 1, 10 },
    PlayerSpeedRate = { 1, 10 },
    PartnerSpeedRate = { 0, 10 },
    EnemySpeedRate = { 0, 5 },
    GunCriticalRate = { 0, 100, "%.0f" },
    ReloadSpeedRate = { 1, 5 },
    DropItemMult = { 1, 10, "%.0f" },
    PickItemMult = { 1, 10, "%.0f" },
    SuperRapidFireSpeed = { 0.1, 0.5 },
    SuperRapidFireInterp = { 0, 20 },
    RapidGrenadeSpeed = { 0.5, 0.8 },
    RapidGrenadeInterp = { 0, 20 },
    RapidKnifeSpeed = { 0.1, 0.2, "%.1f" },
    RapidKnifeInterp = { 0, 20 },
}

local value_names = {
    "GameRank",
    "ItemPoint",
    "EnemyWinceRate",
    "EnemyBreakRate",
    "EnemyDamageRate",
    "EnemyStoppingRate",
    "KnifeReduceRate",
    "PlayerDamageRate",
    "PlayerRunSpeedRate",
    -- "PlayerSpeedRate",
    -- "PartnerSpeedRate",
    "EnemySpeedRate",
    "GunCriticalRate",
    "ReloadSpeedRate",
    "DropItemMult",
    "PickItemMult",
}

local message_dict_default = {
    ToggleHug = "Start/End hug Ashley",
    MoveToAimingHint = "Press move key to teleport to aiming pos (current not support rifle, expiry in 10s).\n" ..
        "If falldown out of the map, press the back key to go back the map.\n" ..
        "Press move key while flying with interp can stop.",
}
local message_dict_zh = {
    Enable = "开启",
    FullHealth = "HP恢复",
    StopClock = "暂停计时",
    EnemyPause = "敌人停止",
    NoReload = "无需换弹",
    InfiniteAmmo = "无限子弹",
    NoRecoil = "无后坐力",
    PerfectAccuracy = "完美精准度（准星最小）",
    ItemCountNotSub = "物品数量不减",
    ItemDurabilityNotSub = "物品耐久不减",
    ShootTypeFullAuto = "枪全自动模式",
    RapidFire = "射速提高",
    SuperRapidFire = "超级射速",
    SuperRapidFireSpeed = "射击速度",
    SuperRapidFireInterp = "射速插帧",
    RapidGrenade = "快速扔雷",
    RapidGrenadeSpeed = "扔雷速度",
    RapidGrenadeInterp = "扔雷插帧",
    RapidKnife = "快速挥刀",
    RapidKnifeSpeed = "挥刀速度",
    RapidKnifeInterp = "挥刀插帧",
    PlayerInvincible = "无敌",
    PartnerInvincible = "伙伴无敌",
    IgnoreTrap = "无视夹子",
    ToggleHug = "抱起/放下阿什莉",
    HealthEnable = "修改血条",
    GameRank = "难度等级",
    ItemPoint = "资源分(越低越容易掉落)",
    EnemyWinceRate = "敌人硬直率",
    EnemyBreakRate = "敌人断肢率",
    EnemyDamageRate = "敌人伤害率",
    EnemyStoppingRate = "敌人停止率",
    KnifeReduceRate = "小刀损耗率",
    PlayerDamageRate = "玩家伤害率",
    PlayerRunSpeedRate = "玩家奔跑速度倍率",
    PlayerSpeedRate = "玩家动作速度倍率(包含动作)",
    PartnerSpeedRate = "伙伴速度倍率",
    EnemySpeedRate = "敌人速度倍率",
    GunCriticalRate = "枪械暴击率",
    ReloadSpeedRate = "换弹速度倍率",
    DropItemMult = "掉落堆数倍率",
    PickItemMult = "拾取数量倍率",
    MoveToAiming = "飞雷神",
    MoveToAimingInterp = "飞雷神动画插值",
    MoveToAimingBack = "回到原处",
    MoveTowardsCamera = "往相机朝向传送",
    MoveTowardsCameraDistance = "往相机朝向传送距离",
    MoveToAimingHint = "按飞雷神键瞬移到瞄准位置（暂不支持步枪），瞄准位置有效期10秒，\n如果掉到地图外了，按返回原处键回来，\n" ..
        "如果开启了动画插帧，飞行过程中可以按飞雷神键停下来",
}

local GameRankSystem_typedef = sdk.find_type_definition("chainsaw.GameRankSystem")
local gameRankSystem = sdk.get_managed_singleton("chainsaw.GameRankSystem")
-- local BulletShell_typedef = sdk.find_type_definition("chainsaw.BulletShell")
local WeaponCustomManager_typedef = sdk.find_type_definition("chainsaw.WeaponCustomManager")
local GameClock_typedef = sdk.find_type_definition("share.GameClock")
local gameClock = sdk.get_managed_singleton("share.GameClock")
local EnemyBaseContext_typedef = sdk.find_type_definition("chainsaw.EnemyBaseContext")
local PlayerBaseContext_typedef = sdk.find_type_definition("chainsaw.PlayerBaseContext")
local PartnerBaseContext_typedef = sdk.find_type_definition("chainsaw.PartnerBaseContext")
local Gun_typedef = sdk.find_type_definition("chainsaw.Gun")
local DropItemContext_SaveData_typedef = sdk.find_type_definition("chainsaw.DropItemContext.SaveData")
-- local WeaponItem_typedef = sdk.find_type_definition("chainsaw.WeaponItem")
local CsInventory_typedef = sdk.find_type_definition("chainsaw.gui.inventory.CsInventory")
local Item_typedef = sdk.find_type_definition("chainsaw.Item")
local ItemIDDefine_typedef = sdk.find_type_definition("chainsaw.ItemIDDefine")
local PlayerEquipment_typedef = sdk.find_type_definition("chainsaw.PlayerEquipment")
local MotionController_typedef = sdk.find_type_definition("chainsaw.MotionController")
local characterManager = sdk.get_managed_singleton("chainsaw.CharacterManager")
local isKeyItem = ItemIDDefine_typedef:get_method("isKeyItem")
local GameObject_typedef = sdk.find_type_definition("via.GameObject")
local get_Transform = GameObject_typedef:get_method("get_Transform")
-- local getComponent_method = GameObject_typedef:get_method("getComponent(System.Type)")
-- local Motion_type = sdk.typeof("via.motion.Motion")

local key_bind = (function ()
    local keyboard_singleton = sdk.get_native_singleton("via.hid.Keyboard")
    local keyboard_typedef = sdk.find_type_definition("via.hid.Keyboard")
    local keyboardkey_typedef = sdk.find_type_definition("via.hid.KeyboardKey")
    local gamePad_singleton = sdk.get_native_singleton("via.hid.GamePad")
    local gamePad_typedef = sdk.find_type_definition("via.hid.GamePad")
    local mouse_singleton = sdk.get_native_singleton("via.hid.Mouse")
    local mouse_typedef = sdk.find_type_definition("via.hid.Mouse")

    local TRIGGER_TYPE_KEYBOARD = 1
    local TRIGGER_TYPE_CONTROLLER = 2
    local TRIGGER_TYPE_MOUSE = 3

    local cfg = {
        long_press_seconds = 0.2,
        -- next time can trigger delta seconds
        long_press_suppress = 0.5,
    }

    local function get_key_code(keyname)
        local field = keyboardkey_typedef:get_field(keyname)
        return field and field:get_data(nil)
    end

    -- return keyname, keycode
    local function try_get_keycode(keyname, default_name)
        keyname = string.gsub(keyname, "%s+", "")
        keyname = string.gsub(keyname, "^%l", string.upper)
        local keycode = get_key_code(keyname)
        if keycode then
            return keyname, keycode
        end
        return default_name, get_key_code(default_name)
    end

    -- inputs
    local trigger_type_choices = { "Keyboard", "Controller", "Mouse" }
    local trigger_type_choices_zh = { "键盘", "手柄", "鼠标" }

    local keyboard_time = {}
    local keyboard_long_press_next = 0
    local function is_keyboard_long_press(kb, code)
        local now = os.clock()
        if kb:isDown(code) then
            if keyboard_time[code] == nil then
                keyboard_time[code] = now
            elseif now > keyboard_long_press_next and now - keyboard_time[code] >= cfg.long_press_seconds then
                keyboard_time[code] = nil
                keyboard_long_press_next = now + cfg.long_press_suppress
                return true
            end
        else
            keyboard_time[code] = nil
        end
        return false
    end

    local pad_time = {}
    local pad_long_press_next = 0
    local pad_isDown = sdk.find_type_definition("via.hid.GamePadDevice"):get_method("isDown(via.hid.GamePadButton)")
    local function is_pad_long_press(pad, code)
        local now = os.clock()
        if pad_isDown:call(pad, code) then
            if pad_time[code] == nil then
                pad_time[code] = now
            elseif now > pad_long_press_next and now - pad_time[code] >= cfg.long_press_seconds then
                pad_time[code] = nil
                pad_long_press_next = now + cfg.long_press_suppress
                return true
            end
        else
            pad_time[code] = nil
        end
        return false
    end

    local mouse_time = {}
    local mouse_long_press_next = 0
    local mouse_choices = { "Left", "Right", "Center", "EX0", "EX1" }
    local mouse_choices_zh = { "左", "右", "中", "后退", "前进" }
    local mouse_values = { 1, 2, 4, 32, 64 }
    local function is_mouse_long_press(mouse, code)
        local now = os.clock()
        if mouse:isDown(code) then
            if mouse_time[code] == nil then
                mouse_time[code] = now
            elseif now > mouse_long_press_next and now - mouse_time[code] >= cfg.long_press_seconds then
                mouse_time[code] = nil
                mouse_long_press_next = now + cfg.long_press_suppress
                return true
            end
        else
            mouse_time[code] = nil
        end
        return false
    end

    local key_code_to_name = {
        [0x00] = "None",
        [0x01] = "LButton",
        [0x02] = "RButton",
        [0x03] = "Cancel",
        [0x04] = "MButton",
        [0x05] = "XButton1",
        [0x06] = "XButton2",
        [0x08] = "Back",
        [0x09] = "Tab",
        [0x0C] = "Clear",
        [0x0D] = "Enter",
        [0x10] = "Shift",
        [0x11] = "Control",
        [0x12] = "Menu",
        [0x13] = "Pause",
        [0x14] = "Capital",
        [0x15] = "Kana",
        [0x17] = "Junja",
        [0x18] = "Final",
        [0x19] = "Hanja",
        [0x1B] = "Escape",
        [0x1C] = "Convert",
        [0x1D] = "NonConvert",
        [0x1E] = "Accept",
        [0x1F] = "ModeChange",
        [0x20] = "Space",
        [0x21] = "Prior",
        [0x22] = "Next",
        [0x23] = "End",
        [0x24] = "Home",
        [0x25] = "Left",
        [0x26] = "Up",
        [0x27] = "Right",
        [0x28] = "Down",
        [0x29] = "Select",
        [0x2A] = "Print",
        [0x2B] = "Execute",
        [0x2C] = "SnapShot",
        [0x2D] = "Insert",
        [0x2E] = "Delete",
        [0x2F] = "Help",
        [0x30] = "Alpha0",
        [0x31] = "Alpha1",
        [0x32] = "Alpha2",
        [0x33] = "Alpha3",
        [0x34] = "Alpha4",
        [0x35] = "Alpha5",
        [0x36] = "Alpha6",
        [0x37] = "Alpha7",
        [0x38] = "Alpha8",
        [0x39] = "Alpha9",
        [0x41] = "A",
        [0x42] = "B",
        [0x43] = "C",
        [0x44] = "D",
        [0x45] = "E",
        [0x46] = "F",
        [0x47] = "G",
        [0x48] = "H",
        [0x49] = "I",
        [0x4A] = "J",
        [0x4B] = "K",
        [0x4C] = "L",
        [0x4D] = "M",
        [0x4E] = "N",
        [0x4F] = "O",
        [0x50] = "P",
        [0x51] = "Q",
        [0x52] = "R",
        [0x53] = "S",
        [0x54] = "T",
        [0x55] = "U",
        [0x56] = "V",
        [0x57] = "W",
        [0x58] = "X",
        [0x59] = "Y",
        [0x5A] = "Z",
        [0x5B] = "LWin",
        [0x5C] = "RWin",
        [0x5D] = "Apps",
        [0x5F] = "Sleep",
        [0x60] = "NumPad0",
        [0x61] = "NumPad1",
        [0x62] = "NumPad2",
        [0x63] = "NumPad3",
        [0x64] = "NumPad4",
        [0x65] = "NumPad5",
        [0x66] = "NumPad6",
        [0x67] = "NumPad7",
        [0x68] = "NumPad8",
        [0x69] = "NumPad9",
        [0x6A] = "Multiply",
        [0x6B] = "Add",
        [0x6C] = "Separator",
        [0x6D] = "Subtract",
        [0x6E] = "Decimal",
        [0x6F] = "Divide",
        [0x70] = "F1",
        [0x71] = "F2",
        [0x72] = "F3",
        [0x73] = "F4",
        [0x74] = "F5",
        [0x75] = "F6",
        [0x76] = "F7",
        [0x77] = "F8",
        [0x78] = "F9",
        [0x79] = "F10",
        [0x7A] = "F11",
        [0x7B] = "F12",
        [0x7C] = "F13",
        [0x7D] = "F14",
        [0x7E] = "F15",
        [0x7F] = "F16",
        [0x80] = "F17",
        [0x81] = "F18",
        [0x82] = "F19",
        [0x83] = "F20",
        [0x84] = "F21",
        [0x85] = "F22",
        [0x86] = "F23",
        [0x87] = "F24",
        [0x90] = "NumLock",
        [0x91] = "Scroll",
        [0x92] = "NumPadEnter",
        [0xA0] = "LShift",
        [0xA1] = "RShift",
        [0xA2] = "LControl",
        [0xA3] = "RControl",
        [0xA4] = "LMenu",
        [0xA5] = "RMenu",
        [0xBA] = ";",  -- OEM_1
        [0xBB] = "+",  -- OEM_Plus
        [0xBC] = ",",  -- OEM_Comma
        [0xBD] = "-",  -- OEM_Minus
        [0xBE] = ".",  -- OEM_Period
        [0xBF] = "/",  -- Slash
        [0xC0] = "`",  -- OEM_3
        [0xDB] = "[",  -- OEM_4
        [0xDC] = "\\", -- OEM_5 BackSlash
        [0xDD] = "]",  -- OEM_6
        [0xDE] = "'",  -- OEM_7
        -- [0xDF] = "OEM_8",
        -- [0xE2] = "OEM_102",
        -- [0xFE] = "DefinedEnter",
        -- [0xFF] = "DefinedCancel",
    }

    local key_name_to_code = {}
    for key, value in pairs(key_code_to_name) do
        key_name_to_code[value] = key
    end

    local reframework_key = {
        [0xBA] = true,  -- OEM_1 -> 0xBB
        [0xBB] = true,  -- OEM_Plus -> 0xDE
        [0xDE] = true,  -- OEM_7 -> 0xBA
        [0xC0] = true,  -- OEM_3 ` 不支持
        [0xDC] = true,  -- OEM_5 BackSlash 不支持
    }

    local pad_code_to_name = {
        [0x00000000] = "Not set",
        [0x00000001] = "LUp",
        [0x00000002] = "LDown",
        [0x00000004] = "LLeft",
        [0x00000008] = "LRight",
        [0x00000010] = "RUp",
        [0x00000020] = "RDown",
        [0x00000040] = "RLeft",
        [0x00000080] = "RRight",
        [0x00000100] = "LTrigTop",
        [0x00000200] = "LTrigBottom",
        [0x00000400] = "RTrigTop",
        [0x00000800] = "RTrigBottom",
        [0x00001000] = "LStickPush",
        [0x00002000] = "RStickPush",
        [0x00004000] = "CLeft",
        [0x00008000] = "CRight",
        [0x00010000] = "CCenter",
        [0x00020000] = "Decide",
        [0x00020020] = "RDown",
        [0x00040000] = "Cancel",
        [0x00040080] = "RRight",
        [0x00080000] = "PlatformHome",
        [0x00100000] = "EmuLup",
        [0x00200000] = "EmuLright",
        [0x00400000] = "EmuLdown",
        [0x00800000] = "EmuLleft",
        [0x01000000] = "EmuRup",
        [0x02000000] = "EmuRright",
        [0x04000000] = "EmuRdown",
        [0x08000000] = "EmuRleft",
        [0x10000000] = "LSide",
        [0x20000000] = "RSide",
        [0x40000000] = "RSL",
        [0x80000000] = "RSR",
    }


    local kb = sdk.call_native_func(keyboard_singleton, keyboard_typedef, "get_Device")
    local pad = sdk.call_native_func(gamePad_singleton, gamePad_typedef, "getMergedDevice", 0)
    local mouse = sdk.call_native_func(mouse_singleton, mouse_typedef, "get_Device")

    local function default_data()
        return { trigger_type = TRIGGER_TYPE_KEYBOARD }
    end

    local function is_valid(trigger_data)
        if not trigger_data or not trigger_data.trigger_type then
            return false
        end
        if trigger_data.trigger_type == TRIGGER_TYPE_KEYBOARD then
            return trigger_data.keycode ~= nil and trigger_data.keycode > 0
        elseif trigger_data.trigger_type == TRIGGER_TYPE_CONTROLLER then
            return trigger_data.pad ~= nil and trigger_data.pad > 0
        elseif trigger_data.trigger_type == TRIGGER_TYPE_MOUSE then
            return mouse_values[trigger_data.mouse] ~= nil
        end
        return false
    end

    -- 尝试设置按键
    local last_key_time = 0
    local function test_set_key(trigger_data)
        if not trigger_data then
            return false
        end
        if trigger_data.wait_set_key then
            local keycode = reframework:get_first_key_down()
            if keycode then
                if keycode == key_name_to_code.Escape then
                    keycode = nil
                end
                trigger_data.keycode = keycode
                trigger_data.wait_set_key = false
                last_key_time = os.clock()
            end
        elseif trigger_data.wait_set_pad then
            local pad_code = pad:get_ButtonRepeat()
            if pad_code ~= 0 then
                trigger_data.pad = pad_code
                trigger_data.wait_set_pad = false
                last_key_time = os.clock()
            end
        end
    end

    local _was_key_down = false
    local function reframework_is_key_down_once(code)
        local down = reframework:is_key_down(code)
        if not _was_key_down and down then
            _was_key_down = true
            return true
        end
        if not down then
            _was_key_down = false
        end
        return false
    end

    -- 检测是否按下
    local function is_trigger(trigger_data)
        if not is_valid(trigger_data) then
            return false
        end
        if os.clock() - last_key_time < 1 then
            return
        end
        if trigger_data.trigger_type == TRIGGER_TYPE_KEYBOARD then
            if trigger_data.keycode then
                local code = trigger_data.keycode
                if reframework_key[trigger_data.keycode] then
                    return reframework_is_key_down_once(code)
                elseif trigger_data.long_press then
                    return is_keyboard_long_press(kb, code)
                else
                    return kb:isRelease(code)
                end
            end
        elseif trigger_data.trigger_type == TRIGGER_TYPE_CONTROLLER then
            if trigger_data.pad then
                if trigger_data.long_press then
                    return is_pad_long_press(pad, trigger_data.pad)
                else
                    return (pad:get_ButtonUp() & trigger_data.pad) ~= 0
                end
            end
        elseif trigger_data.trigger_type == TRIGGER_TYPE_MOUSE then
            local mouse_code = mouse_values[trigger_data.mouse]
            if mouse_code then
                if trigger_data.long_press then
                    return is_mouse_long_press(mouse, mouse_code)
                else
                    return (mouse:get_ButtonUp() & mouse_code) ~= 0
                end
            end
        end
        return false
    end

    local message_dict_default = {
        trigger_with = "Trigger type",
        checked_set_key = "Checked to set a key, current: ",
        checked_set_controller_key = "Checked to set a controller key, current: ",
        choice_mouse_key = "Choice mouse key",
        need_long_press = "Need long press",
        unkown = "Unkown",
        unset = "Unset",
    }

    local message_dict_zh = {
        trigger_with = "触发方式",
        checked_set_key = "选中这里然后设置按键，当前: ",
        checked_set_controller_key = "选中这里设置手柄按键，当前: ",
        choice_mouse_key = "选择鼠标按键",
        need_long_press = "需要长按",
        unkown = "未知",
        unset = "未设置",
    }

    local function render_key_config(trigger_data, is_zh, label)
        local changed
        if label then
            if not imgui.tree_node(label) then return end
        end
        local message_dict = is_zh and message_dict_zh or message_dict_default
        changed, trigger_data.trigger_type = imgui.combo(
            message_dict.trigger_with,
            trigger_data.trigger_type, is_zh and trigger_type_choices_zh or trigger_type_choices)
        if trigger_data.trigger_type == TRIGGER_TYPE_KEYBOARD then
            changed, trigger_data.wait_set_key = imgui.checkbox(
                message_dict.checked_set_key ..
                    (trigger_data.keycode and (key_code_to_name[trigger_data.keycode] or tostring(trigger_data.keycode)) or message_dict.unset),
                trigger_data.wait_set_key)
        elseif trigger_data.trigger_type == TRIGGER_TYPE_CONTROLLER then
            changed, trigger_data.wait_set_pad = imgui.checkbox(
                message_dict.checked_set_controller_key
                    .. (pad_code_to_name[trigger_data.pad] or message_dict.unkown),
                trigger_data.wait_set_pad)
        elseif trigger_data.trigger_type == TRIGGER_TYPE_MOUSE then
            changed, trigger_data.mouse = imgui.combo(
                message_dict.choice_mouse_key,
                trigger_data.mouse,
                is_zh and mouse_choices_zh or mouse_choices)
        end
        changed, trigger_data.long_press = imgui.checkbox(
            message_dict.need_long_press,
            trigger_data.long_press)
        if label then
            imgui.tree_pop()
        end
    end

    -- local function render_key_bind_cfg()
    --     local changed, value
    --     changed, value = imgui.slider_float("Long press seconds", cfg.long_press_seconds, 0.2, 1, "%.1f")
    --     if changed then
    --         cfg.long_press_seconds = value
    --     end
    --     changed, value = imgui.slider_float("Long press suppress", cfg.long_press_suppress, 0, 1, "%.1f")
    --     tooltip("Long press repeat trigger suppress seconds")
    --     if changed then
    --         cfg.long_press_suppress = value
    --     end
    -- end

    return {
        TRIGGER_TYPE_KEYBOARD = TRIGGER_TYPE_KEYBOARD,
        TRIGGER_TYPE_CONTROLLER = TRIGGER_TYPE_CONTROLLER,
        TRIGGER_TYPE_MOUSE = TRIGGER_TYPE_MOUSE,
        kb,
        pad,
        mouse,
        default_data = default_data,
        get_key_code = get_key_code,
        try_get_keycode = try_get_keycode,
        test_set_key = test_set_key,
        is_valid = is_valid,
        is_trigger = is_trigger,
        render_key_config = render_key_config,
    }

end)()
local multi_language = (function ()

    -- imgui glyph ranges
    local GlyphRangesChineseFull = {
        0x0020, 0x00FF, -- Basic Latin + Latin Supplement
        0x2000, 0x206F, -- General Punctuation
        0x3000, 0x30FF, -- CJK Symbols and Punctuations, Hiragana, Katakana
        0x31F0, 0x31FF, -- Katakana Phonetic Extensions
        0xFF00, 0xFFEF, -- Half-width characters
        0xFFFD, 0xFFFD, -- Invalid
        0x4e00, 0x9FAF, -- CJK Ideograms
        0,
    }
    local GlyphRangesKorean = {
        0x0020, 0x00FF, -- Basic Latin + Latin Supplement
        0x3131, 0x3163, -- Korean alphabets
        0xAC00, 0xD7A3, -- Korean characters
        0xFFFD, 0xFFFD, -- Invalid
        0,
    }
    local GlyphRangesFrench = {
        0x0020, 0x017D,
        0,
    }
    local GlyphRangesRussian = {
        0x0020, 0x00FF,
        0x0400, 0x052f,
        0,
    }

    local optionManager = sdk.get_managed_singleton("chainsaw.OptionManager")
    local messageManager = sdk.get_managed_singleton("chainsaw.MessageManager")
    local MessageManager_typedef = sdk.find_type_definition("chainsaw.MessageManager")
    -- getMessage(System.Guid message_id, via.Language language_id, bool emptyable)
    local getMessage_method = MessageManager_typedef:get_method("getMessage(System.Guid, via.Language, System.Boolean)")

    local export = {
        Language_English = 0x1,
        Language_SimplelifiedChinese = 0xD,
        Language_TransitionalChinese = 0xC,
        Language_Japanese = 0x0,
        Language_French = 0x2,
        Language_Russian = 0x6,
        Language_Korean = 0xB,
        Language_Arabic = 0x15,
        language = nil,
        font = nil,
    }

    local last_clock = 0

    function export.handle_language(cfg, on_change, force_reload)
        local now = os.clock()
        if now - last_clock < 0.2 then
            return
        end
        last_clock = now
        local new_language
        if cfg.use_english then
            new_language = export.Language_English
            export.font = nil
        else
            new_language = optionManager:getTextLanguage()
        end
        local language = export.language
        if new_language == language and not force_reload then
            return
        end
        language = new_language
        export.language = language
        local is_zh = false
        if language == export.Language_SimplelifiedChinese or
            language == export.Language_TransitionalChinese then
            is_zh = true
        end
        local font
        if not cfg.builtin_font then
            if language == export.Language_SimplelifiedChinese or
                language == export.Language_TransitionalChinese or
                language == export.Language_Japanese then
                font = imgui.load_font("STXIHEI.TTF", cfg.font_size, GlyphRangesChineseFull)
            elseif language == export.Language_French then
                font = imgui.load_font("STXIHEI.TTF", cfg.font_size, GlyphRangesFrench)
            elseif language == export.Language_Russian then
                font = imgui.load_font("STXIHEI.TTF", cfg.font_size, GlyphRangesRussian)
            elseif language == export.Language_Korean then
                font = imgui.load_font("malgunsl.ttf", cfg.font_size, GlyphRangesKorean)
            end
        end
        export.font = font
        if on_change then
            on_change(is_zh)
        end
    end

    function export.getMessage(msdId)
        return getMessage_method:call(messageManager, msdId, export.language, true)
    end

    return export

end)()
local Mod = (function ()
    local Mod = {}

    local common_cfg = {
        use_english = false,
        builtin_font = false,
        font_size = 30,
    }

    local common_message_dict_default = {
        reset_config = "Reset to default",
        save_config = "Save config",
        use_english = "Use English",
        builtin_font = "Use builtin font",
        reload_message = "Reload info (when language changed)",
        font_size = "Font size (20~60)",
        hot_key = " Hotkey",
    }

    local common_message_dict_zh = {
        font_size = "字体大小 (20~60)",
        reset_config = "重置配置",
        save_config = "保存配置",
        builtin_font = "使用内建字体",
        reload_message = "刷新数据(切换语言后)",
        hot_key = "快捷键",
    }

    local meta_return_key = { __index = function(mytable, key) return key end }

    function Mod:new(title, cfg_path, default_cfg, message_dict_default, message_dict_zh)
        local obj = {
            title = title,
            cfg_path = cfg_path,
            default_cfg = default_cfg,
            message_dict_default = message_dict_default,
            message_dict_zh = message_dict_zh,
            message_dict = message_dict_default,
            is_zh = false,  -- 当前语言是中文
            enable_font_size = true,
            render_window = false,
            zh_title = false,  -- 标题使用中文字体
            pushed_font = false,
            handle_language_callback = nil,
        }
        setmetatable(obj, self)
        self.__index = self

        Mod.table_assign_default(message_dict_default, common_message_dict_default)
        if message_dict_zh then
            setmetatable(message_dict_zh, message_dict_default)
            Mod.table_assign_default(message_dict_zh, common_message_dict_zh)
        end
        message_dict_default.__index = message_dict_default
        setmetatable(message_dict_default, meta_return_key)

        local cfg = json.load_file(cfg_path)
        if type(cfg) ~= 'table' then
            cfg = {}
        end
        Mod.table_assign_default(cfg, common_cfg)
        Mod.table_assign_default(cfg, default_cfg)
        obj.cfg = cfg

        re.on_config_save(function()
            obj:dump_cfg()
        end)

        return obj
    end

    function Mod.table_assign_default(dst, data)
        for key, value in pairs(data) do
            if dst[key] == nil then
                if type(value) == 'table' then
                    dst[key] = Mod.table_assign(nil, value)
                else
                    dst[key] = value
                end
            end
        end
        return dst
    end

    function Mod.table_assign(dst, data)
        dst = dst or {}
        if data == nil then
            return dst
        end
        for key, value in pairs(data) do
            if type(value) == 'table' then
                dst[key] = Mod.table_assign(nil, value)
            else
                dst[key] = value
            end
        end
        return dst
    end

    function Mod.empty_or(text, default)
        if text == nil or text == "" then
            return default
        end
        return text
    end

    function Mod:dump_cfg()
        json.dump_file(self.cfg_path, self.cfg)
    end

    function Mod:init_gui_ids()
        self.gui_ids = setmetatable({__cur = 0}, {
            __index = function (data, name)
                local index = data.__cur + 1
                data[name] = index
                data.__cur = index
                return index
            end
        })
    end

    function Mod:init_multi_language(multi_language)
        self.multi_language = multi_language
    end

    function Mod:init_key_bind(key_bind)
        self.key_bind = key_bind
    end

    function Mod:on_language_changed(is_zh)
        self.is_zh = is_zh
        self.message_dict = is_zh and self.message_dict_zh or self.message_dict_default
    end

    function Mod:handle_language(force_reload)
        if self.multi_language then
            self.multi_language.handle_language(self.cfg, function (is_zh)
                self:on_language_changed(is_zh)
                if self.handle_language_callback then
                    self.handle_language_callback(is_zh)
                end
            end, force_reload)
        end
    end

    function Mod:text(name)
        return self.message_dict[name]
    end

    function Mod.tooltip_text(text)
        if imgui.is_item_hovered() then
            imgui.set_tooltip(text)
        end
    end

    function Mod:tooltip(name)
        if imgui.is_item_hovered() then
            imgui.set_tooltip(self.message_dict[name])
        end
    end

    function Mod:render_checkbox(name)
        local changed, value = imgui.checkbox(self.message_dict[name], self.cfg[name])
        if changed then
            self.cfg[name] = value
        end
        return changed, value
    end

    function Mod:render_slider_float(name, min, max, flag)
        local changed, value = imgui.slider_float(self.message_dict[name], self.cfg[name], min, max, flag)
        if changed then
            self.cfg[name] = value
        end
        return changed, value
    end

    function Mod:render_slider_float_data(name, data)
        local item = data[name]
        self:render_slider_float(name, item[1], item[2], item[3] or "%.1f")
    end

    function Mod:render_slider_int(name, min, max)
        local changed, value = imgui.slider_int(self.message_dict[name], self.cfg[name], min, max)
        if changed then
            self.cfg[name] = value
        end
        return changed, value
    end

    function Mod:render_color_edit(name)
        local changed, value = imgui.color_edit(self.message_dict[name], self.cfg[name])
        if changed then
            self.cfg[name] = value
        end
    end

    function Mod:render_key_config(name, suffix)
        if not self.key_bind then
            return
        end
        local trigger_key = name .. (suffix or "HotKey")
        if not self.cfg[trigger_key] then
            self.cfg[trigger_key] = self.key_bind.default_data()
        end
        if self.message_dict[trigger_key] == trigger_key then
            self.message_dict[trigger_key] = self:text(name) .. self:text("hot_key")
        end
        self.key_bind.render_key_config(self.cfg[trigger_key], self.is_zh, self.message_dict[trigger_key])
    end

    -- set and check key trigger
    function Mod:handle_key(trigger_data)
        if not self.key_bind or not trigger_data then
            return
        end
        self.key_bind.test_set_key(trigger_data)
        return self.key_bind.is_trigger(trigger_data)
    end

    -- hotkey toggle checkbox
    function Mod:handle_key_toggle(name)
        if not self.key_bind then
            return
        end
        local trigger_key = name .. "HotKey"
        self.key_bind.test_set_key(self.cfg[trigger_key])
        if self.key_bind.is_trigger(self.cfg[trigger_key]) then
            self.cfg[name] = not self.cfg[name]
        end
    end

    function Mod:push_font()
        if self.multi_language then
            if not self.multi_language.language then
                self:handle_language()
            end
            local cur_font = self.multi_language.font
            if cur_font then
                imgui.push_font(cur_font)
                self.pushed_font = true
                return true
            end
        end
        return false
    end

    function Mod:begin_render_config(shown_flag)
        imgui.set_next_item_open(true, 1 << 1)
        local title = self.title or self.message_dict.window_title
        if self.zh_title then
            self:push_font()
        end

        if self.render_window then
            if not imgui.begin_window(title, shown_flag ~= false, 1 << 10) then
                if self.pushed_font then
                    imgui.pop_font()
                end
                return false
            end
        else
            if not imgui.tree_node(title) then
                if self.pushed_font then
                    imgui.pop_font()
                end
                return false
            end
        end
        if not self.zh_title then
            self:push_font()
        end
        local changed, value
        local use_english_changed, builtin_font_changed
        use_english_changed, value = self:render_checkbox("use_english")
        imgui.same_line()
        builtin_font_changed, value = self:render_checkbox("builtin_font")
        if use_english_changed or builtin_font_changed then
            self:handle_language(true)
        end
        if self.is_zh then
            imgui.text("RE4修改和mod交流群: 663068787")
        end
        if imgui.button(self.message_dict.reload_message) then
            self:handle_language(true)
        end
        if self.enable_font_size and not self.cfg.builtin_font then
            imgui.same_line()
            imgui.set_next_item_width(200)
            changed, value = imgui.input_text(self.message_dict.font_size, self.cfg.font_size)
            if changed then
                value = tonumber(value)
                if value and value >= 20 and value <= 60 then
                    self.cfg.font_size = value
                    self:handle_language(true)
                end
            end
        end
        if imgui.button(self.message_dict.reset_config) then
            Mod.table_assign(self.cfg, self.default_cfg)
        end
        imgui.same_line()
        if imgui.button(self.message_dict.save_config) then
            self:dump_cfg()
        end

        return true
    end

    function Mod:end_render_config()
        if self.pushed_font then
            imgui.pop_font()
            self.pushed_font = false
        end
        if self.render_window then
            imgui.end_window()
        else
            imgui.tree_pop()
        end
    end

    function Mod:should_update(addr, interval)
        if not self.update_time_map then
            self.update_time_map = {}
        end
        local now = os.clock()
        local time = self.update_time_map[addr]
        local result = not time or now - time > (interval or 1.0)
        if result then
            self.update_time_map[addr] = now
        end
        return result
    end

    return Mod

end)()
local mod = Mod:new("Chenstack Trainer v" .. version, cfg_path, default_cfg, message_dict_default, message_dict_zh)
mod:init_multi_language(multi_language)
mod:init_key_bind(key_bind)
mod:init_gui_ids()

local cfg = mod.cfg
local move_to_lib = (function ()
    local WeaponHoldStanceAdjusterUnit_typedef = sdk.find_type_definition("chainsaw.WeaponHoldStanceAdjusterUnit")
    local characterManager = sdk.get_managed_singleton("chainsaw.CharacterManager")

    local export = {
        enable = false,
    }
    local aiming_pos
    local last_pos

    local now = os.clock()
    local last_aim_clock = now
    sdk.hook(
        -- updateCastRayTip
        WeaponHoldStanceAdjusterUnit_typedef:get_method("castRayTip"),
        function (args)
            if export.enable and now - last_aim_clock > 0.2 then
                local instance = sdk.to_managed_object(args[2])
                aiming_pos = instance._AimingPosition or instance._CastRays._End
                last_aim_clock = now
                -- log.debug(string.format("Pos X:%f,Y:%f,Z:%f", aiming_pos.x, aiming_pos.y, aiming_pos.z))
            end
        end
    )

    local update_fn

    local Transform_typedef = sdk.find_type_definition("via.Transform")
    local GameObject_typedef = sdk.find_type_definition("via.GameObject")
    local CharacterController_typedef = sdk.find_type_definition("via.physics.CharacterController")
    local CharacterController_type = sdk.typeof("via.physics.CharacterController")
    local get_Transform = GameObject_typedef:get_method("get_Transform")
    local get_Position = Transform_typedef:get_method("get_Position")
    local set_Position = Transform_typedef:get_method("set_Position")
    local warp = CharacterController_typedef:get_method("warp")

    local function getCharacterController(body)
        return body and body:call("getComponent(System.Type)", CharacterController_type)
    end

    local function move_to(body, pos, interp_count, move_up)
        local characterController = getCharacterController(body)
        local transform = get_Transform:call(body)
        if move_up then
            pos.y = pos.y + 1
        end
        last_pos = get_Position:call(transform)
        if move_up then
            last_pos.y = last_pos.y + 1
        end

        if interp_count and interp_count > 0 then
            set_Position:call(transform, last_pos)
            warp:call(characterController)
            local try_count = 0
            local step = {
                x = (pos.x - last_pos.x) / interp_count,
                y = (pos.y - last_pos.y) / interp_count,
                z = (pos.z - last_pos.z) / interp_count,
            }
            update_fn = function()
                local cur_pos = get_Position:call(transform)
                if try_count < interp_count and (pos - cur_pos):length() > 0.5 then
                    cur_pos.x = last_pos.x + step.x * try_count
                    cur_pos.y = last_pos.y + step.y * try_count
                    cur_pos.z = last_pos.z + step.z * try_count
                    set_Position:call(transform, cur_pos)
                    warp:call(characterController)
                    try_count = try_count + 1
                else
                    update_fn = nil
                end
            end
        else
            set_Position:call(transform, pos)
            warp:call(characterController)
        end
    end

    local function move_back(body)
        if not last_pos then
            return false
        end
        local transform = get_Transform:call(body)
        local characterController = getCharacterController(body)
        local pos = last_pos
        set_Position:call(transform, pos)
        warp:call(characterController)
        last_pos = nil
        return true
    end

    local function get_player()
        return characterManager:call("getPlayerContextRef")
    end

    local function get_player_body()
        local player = get_player()
        local body = player and player:get_BodyGameObject()
        return body
    end

    function export.move_to_aiming(interp, back)
        local body = get_player_body()
        if body == nil then
            return
        end

        if back then
            move_back(body)
        elseif aiming_pos then
            local pos = aiming_pos
            aiming_pos = nil
            move_to(body, pos, interp and 30 or 0, true)
        elseif update_fn then
            update_fn = nil
        end
    end

    function export.move_to_camera(distance, interp, back)
        local body = get_player_body()
        if body == nil then
            return
        end
        if back then
            move_back(body)
        else
            local camera = sdk.get_primary_camera()
            local transform = get_Transform:call(body)
            local cur_pos = transform:get_Position()
            local pos = camera:get_LookAtPosition()
            pos = cur_pos + (pos - cur_pos) * (distance or 1)
            move_to(body, pos, interp and 20 or 0)
        end
    end

    re.on_frame(function()
        if export.enable then
            if update_fn then
                update_fn()
            end
            now = os.clock()
            if aiming_pos and now - last_aim_clock > 10 then
                aiming_pos = nil
            end
        end
    end)

    export.getCharacterController = getCharacterController
    export.warp = warp
    return export

end)()
move_to_lib.enable = cfg.MoveToAiming

local late_init = {}
local late_init_alias = {
    EnemyPause = "EnemySpeedRateEnable",
    RapidGrenade = "SuperRapidFire",
    RapidKnife = "SuperRapidFire",
}

local function do_late_init(key)
    key = late_init_alias[key] or key
    local fn = late_init[key]
    if fn then
        fn()
        late_init[key] = nil
    end
end

function late_init.GameRankEnable()
    sdk.hook(
        GameRankSystem_typedef:get_method("getLimtCalcRank"),
        nil,
        function (x)
            if cfg.GameRankEnable then
                x = sdk.to_ptr(cfg.GameRank)
            end
            return x
        end
    )
end

function late_init.EnemyWinceRateEnable()
    sdk.hook(
        GameRankSystem_typedef:get_method("getRankEnemyWinceRate"),
        nil,
        function (x)
            if cfg.EnemyWinceRateEnable then
                x = sdk.float_to_ptr(cfg.EnemyWinceRate)
            end
            return x
        end
    )
end

function late_init.EnemyBreakRateEnable()
    sdk.hook(
        GameRankSystem_typedef:get_method("getRankEnemyBreakRate"),
        nil,
        function (x)
            if cfg.EnemyBreakRateEnable then
                x = sdk.float_to_ptr(cfg.EnemyBreakRate)
            end
            return x
        end
    )
end

function late_init.EnemyDamageRateEnable()
    sdk.hook(
        GameRankSystem_typedef:get_method("getRankEnemyDamageRate"),
        nil,
        function (x)
            if cfg.EnemyDamageRateEnable then
                x = sdk.float_to_ptr(cfg.EnemyDamageRate)
            end
            return x
        end
    )
end

function late_init.EnemyStoppingRateEnable()
    sdk.hook(
        GameRankSystem_typedef:get_method("getRankEnemyStoppingRate"),
        nil,
        function (x)
            if cfg.EnemyStoppingRateEnable then
                x = sdk.float_to_ptr(cfg.EnemyStoppingRate)
            end
            return x
        end
    )
end

function late_init.PlayerDamageRateEnable()
    sdk.hook(
        GameRankSystem_typedef:get_method("getRankPlayerDamageRate"),
        nil,
        function (x)
            if cfg.PlayerDamageRateEnable then
                x = sdk.float_to_ptr(cfg.PlayerDamageRate)
            end
            return x
        end
    )
end

function late_init.KnifeReduceRateEnable()
    sdk.hook(
        GameRankSystem_typedef:get_method("getKnifeReduceRate"),
        nil,
        function (x)
            if cfg.KnifeReduceRateEnable then
                x = sdk.float_to_ptr(cfg.KnifeReduceRate)
            end
            return x
        end
    )
end

function late_init.ItemPointEnable()
    sdk.hook(
        GameRankSystem_typedef:get_method("get_ItemPoint"),
        nil,
        function (x)
            if cfg.ItemPointEnable then
                x = sdk.float_to_ptr(cfg.ItemPoint)
            end
            return x
        end
    )
end

function late_init.GunCriticalRateEnable()
    sdk.hook(
        WeaponCustomManager_typedef:get_method("getCriticalRate_Normal"),
        nil,
        function (x)
            if cfg.GunCriticalRateEnable then
                x = sdk.float_to_ptr(cfg.GunCriticalRate)
            end
            return x
        end
    )
    sdk.hook(
        WeaponCustomManager_typedef:get_method("getCriticalRate_Fit"),
        nil,
        function (x)
            if cfg.GunCriticalRateEnable then
                x = sdk.float_to_ptr(cfg.GunCriticalRate)
            end
            return x
        end
    )
end

function late_init.ReloadSpeedRateEnable()
    sdk.hook(
        Gun_typedef:get_method("get_ReloadSpeedRate"),
        nil,
        function (x)
            if cfg.ReloadSpeedRateEnable then
                x = sdk.float_to_ptr(cfg.ReloadSpeedRate)
            end
            return x
        end
    )
end

function late_init.DropItemMultEnable()
    sdk.hook(
        sdk.find_type_definition("chainsaw.DropItemManager"):get_method(
            "requestGenerateRandomDrop(chainsaw.RandomDrop.Option, chainsaw.CharacterContext, via.GameObject, chainsaw.DropItemManager.GenerateItemOption)"),
        function (args)
            if cfg.DropItemMultEnable and cfg.DropItemMult > 1.0 then
                local option = sdk.to_managed_object(args[3])
                if option then
                    option.Num = math.ceil(option.Num * cfg.DropItemMult)
                end
            end
        end
    )
end

function late_init.PickItemMultEnable()
    local pickupItem_called = false
    local last_count
    sdk.hook(
        sdk.find_type_definition("chainsaw.DropItemContext.SaveData"):get_method("generateItemData"),
        nil,
        function (x)
            if pickupItem_called and cfg.PickItemMultEnable and cfg.PickItemMult > 1.0 then
                local result = sdk.to_managed_object(x)
                if result and not result:get_IsStackMax() then
                    last_count = result._CurrentItemCount
                    result._CurrentItemCount = math.ceil(result._CurrentItemCount * cfg.PickItemMult)
                end
            end
            return x
        end
    )
    sdk.hook(
        sdk.find_type_definition("chainsaw.DropItemContext"):get_method("subCount"),
        function (args)
            if last_count then
                args[3] = sdk.to_ptr(-last_count & 0xFFFFFFFF)
                last_count = nil
            end
        end
    )
    sdk.hook(
        sdk.find_type_definition("chainsaw.InventoryControllersInfo"):get_method(
            "pickupItem(chainsaw.ContextID, chainsaw.DropItemContext, chainsaw.ItemID, System.Action, System.Action`1<chainsaw.ItemWindowGuiOpenResult>)"),
        function (args)
            pickupItem_called = true
        end,
        function (retval)
            pickupItem_called = false
            return retval
        end
    )
end

-- local TRUE_PTR = sdk.to_ptr(true)
-- sdk.hook(
--     Gun_typedef:get_method("get_EnableLaserSight"),
--     nil,
--     function (x)
--         return TRUE_PTR
--     end
-- )

-- local TRUE_PTR = sdk.to_ptr(true)
-- sdk.hook(
--     sdk.find_type_definition("chainsaw.PlayerEquipment"):get_method("get_IsEnableLaserSight"),
--     nil,
--     function (x)
--         return TRUE_PTR
--     end
-- )

-- sdk.hook(
--     BulletShell_typedef:get_method("checkAttackHitEvent"),
--     function (args)
--         local instance = sdk.to_managed_object(args[2])
--         local damageInfo = sdk.to_managed_object(args[3])
--         -- log.debug(string.format("BulletShell: %X", instance:get_address()))
--         log.debug("checkAttackHitEvent instance:get_IsCritical " .. tostring(instance:get_IsCritical()))
--         log.debug("checkAttackHitEvent damageInfo:get_Damage " .. tostring(damageInfo:get_Damage()))
--     end
-- )

-- sdk.hook(
--     -- get_IsDamaging
--     PlayerBaseContext_typedef:get_method("clearState"),
--     function (args)
--         if cfg.PlayerSpeedRateEnable then
--             local instance = sdk.to_managed_object(args[2])
--             local body = instance:get_BodyGameObject()
--             if body then
--                 body:set_TimeScale(cfg.PlayerSpeedRate)
--             end
--         end
--     end
-- )

-- sdk.hook(
--     -- get_IsDamaging
--     PartnerBaseContext_typedef:get_method("clearPartnerState"),
--     function (args)
--         if cfg.PartnerSpeedRateEnable then
--             local instance = sdk.to_managed_object(args[2])
--             local body = instance:get_BodyGameObject()
--             if body then
--                 body:set_TimeScale(cfg.PartnerSpeedRate)
--             end
--         end
--     end
-- )

local function on_enemy_speed(args)
    if cfg.EnemyPause or cfg.EnemySpeedRateEnable then
        local instance = sdk.to_managed_object(args[2])
        local body = instance:get_BodyGameObject()
        if body then
            body:set_TimeScale(cfg.EnemyPause and 0.0 or cfg.EnemySpeedRate)
        end
    end
end

function late_init.EnemySpeedRateEnable()
    sdk.hook(
        EnemyBaseContext_typedef:get_method("canValidPositionSave"),
        on_enemy_speed
    )

    sdk.hook(
        sdk.find_type_definition("chainsaw.Ch1d3z0Context"):get_method("updateNearestPositionInfo"),
        on_enemy_speed
    )

    sdk.hook(
        sdk.find_type_definition("chainsaw.Ch1f6z0Context"):get_method("get_IsCombatReady"),
        on_enemy_speed
    )
end

function late_init.EnemyPause()
    -- for alias
end

-- local paused_enemys = {}

-- function late_init.EnemyPause()
--     sdk.hook(
--         EnemyBaseContext_typedef:get_method("get_IsLively"),
--         function(args)
--             local addr = sdk.to_int64(args[2])
--             if cfg.EnemyPause or paused_enemys[addr] then
--                 if mod:should_update(addr) then
--                     local instance = sdk.to_managed_object(args[2])
--                     local body = instance:get_BodyGameObject()
--                     if body then
--                         local motion = getComponent_method:call(body, Motion_type)
--                         motion:call("set_Enabled", not cfg.EnemyPause)
--                     end
--                     paused_enemys[addr] = cfg.EnemyPause
--                 end
--             end
--         end
--     )
-- end

function late_init.StopClock()
    sdk.hook(
        GameClock_typedef:get_method("update"),
        function (args)
            if cfg.StopClock then
                return sdk.PreHookResult.SKIP_ORIGINAL
            end
        end
    )
end

local TRUE_PTR = sdk.to_ptr(true)
function late_init.InfiniteAmmo()
    sdk.hook(
        CsInventory_typedef:get_method("use(chainsaw.EquipType)"),
        function (args)
            if cfg.InfiniteAmmo then
                return sdk.PreHookResult.SKIP_ORIGINAL
            end
        end
    )
    sdk.hook(
        ItemIDDefine_typedef:get_method("isInfiniteAmmo"),
        nil,
        function (x)
            if cfg.InfiniteAmmo then
                return TRUE_PTR
            end
            return x
        end
    )
end

function late_init.NoRecoil()
    sdk.hook(
        PlayerEquipment_typedef:get_method("execFire"),
        function (args)
            if cfg.NoRecoil then
                return sdk.PreHookResult.SKIP_ORIGINAL
            end
        end
    )
end

function late_init.ItemCountNotSub()
    sdk.hook(
        Item_typedef:get_method("reduceCount"),
        function (args)
            if cfg.ItemCountNotSub then
                local instance = sdk.to_managed_object(args[2])
                local count = sdk.to_int64(args[3])
                if isKeyItem:call(nil, instance._ItemId) and instance:get_StackMax() == 1 then
                    return
                end
                if count < instance._CurrentItemCount then
                    return sdk.PreHookResult.SKIP_ORIGINAL
                end
            end
        end
    )
end

function late_init.ItemDurabilityNotSub()
    sdk.hook(
        Item_typedef:get_method("reduceDurability"),
        function (args)
            if cfg.ItemDurabilityNotSub then
                local instance = sdk.to_managed_object(args[2])
                local count = sdk.to_int64(args[3])
                if count < instance._CurrentDurability then
                    return sdk.PreHookResult.SKIP_ORIGINAL
                end
            end
        end
    )
end

function late_init.ShootTypeFullAuto()
    sdk.hook(
        PlayerEquipment_typedef:get_method("hasFullAutoGun"),
        nil,
        function (x)
            if cfg.ShootTypeFullAuto then
                return TRUE_PTR
            end
            return x
        end
    )
end

function late_init.PerfectAccuracy()
    sdk.hook(
        Gun_typedef:get_method("updateReticleFitPoin"),
        function (args)
            local gun = sdk.to_managed_object(args[2])
            if cfg.PerfectAccuracy then
                gun._CurrentReticleFitPoint = 100.0
                return sdk.PreHookResult.SKIP_ORIGINAL
            end
        end
    )
end

function late_init.RapidFire()
    local FLOAT_1_PTR = sdk.float_to_ptr(1.0)
    sdk.hook(
        Gun_typedef:get_method("get_RapidSpeed"),
        -- function (args)
        --     local gun = sdk.to_managed_object(args[2])
        --     gun.WeaponStructureParam._RapidBaseFrame = 3
        --     log.debug("get_RapidBaseFrame " .. gun:get_RapidBaseFrame())
        -- end,
        nil,
        function (x)
            -- log.debug("get_RapidSpeed " .. tostring(sdk.to_float(x)))
            if cfg.RapidFire then
                x = FLOAT_1_PTR
            -- elseif cfg.SuperRapidFire and sdk.to_float(x) > 2 then
            --     x = sdk.to_ptr(1.5)
            end
            return x
        end
    )

    sdk.hook(
        Gun_typedef:get_method("get_PumpActionRapidSpeed"),
        nil,
        function (x)
            if cfg.RapidFire or cfg.SuperRapidFire then
                return sdk.float_to_ptr(10.0)
            end
            return x
        end
    )
end


function late_init.SuperRapidFire()
    local last_layer
    local last_throw_layer
    local last_knife_layer
    sdk.hook(
        -- getInterpolationData(via.motion.TreeLayer layer, System.UInt32 bankID, System.UInt32 motionID)
        MotionController_typedef:get_method("getInterpolationData(via.motion.TreeLayer, System.UInt32, System.UInt32)"),
        function (args)
            last_layer = nil
            last_throw_layer = nil
            last_knife_layer = nil
            local bankID = sdk.to_int64(args[4]) & 0xFFFFFFFF
            local motionID = sdk.to_int64(args[5]) & 0xFFFFFFFF
            if bankID == 2 and motionID == 500 then
                last_layer = sdk.to_managed_object(args[3])
                -- log.debug(string.format("bankID: %d, motionID: %d, EndFrame: %.0f",
                --     bankID, motionID, last_layer:get_EndFrame()))
            end
            -- 扔雷？
            -- if bankID == 2000 and motionID == 1400 then
            --     last_throw_layer = sdk.to_managed_object(args[3])
            -- end
            -- 有个终止帧640的 0和-1 那个改了奇效
            -- 2, 600 突刺
            -- 2, 630 右挥刀
            if bankID == 2 and (motionID == 600 or motionID == 630) then
                last_knife_layer = sdk.to_managed_object(args[3])
                -- log.debug(string.format("bankID: %d, motionID: %d, EndFrame: %.0f",
                --     bankID, motionID, last_knife_layer:get_EndFrame()))
            end
            -- local layer = sdk.to_managed_object(args[3])
            -- log.debug(string.format("bankID: %d, motionID: %d, EndFrame: %.0f",
            --         bankID, motionID, layer:get_EndFrame()))
        end,
        function (x)
            local reset
            if last_layer then
                local result = sdk.to_managed_object(x)
                if cfg.SuperRapidFire then
                    local end_frame = last_layer:get_EndFrame()
                    local start_frame
                    if end_frame > 1000 then
                        start_frame = 80
                    else
                        start_frame = end_frame * cfg.SuperRapidFireSpeed
                    end
                    result._StartFrame = start_frame
                    result._InterpolationFrame = cfg.SuperRapidFireInterp
                else
                    reset = result
                end
            elseif last_throw_layer then
                local result = sdk.to_managed_object(x)
                if cfg.RapidGrenade then
                    local end_frame = last_throw_layer:get_EndFrame()
                    result._StartFrame = end_frame * cfg.RapidGrenadeSpeed
                    result._InterpolationFrame = cfg.RapidGrenadeInterp
                else
                    reset = result
                end
            elseif last_knife_layer then
                local result = sdk.to_managed_object(x)
                if cfg.RapidKnife then
                    -- local end_frame = last_knife_layer:get_EndFrame()
                    -- if end_frame < 200 then
                    --     result._StartFrame = end_frame * cfg.RapidKnifeSpeed
                    -- end
                    -- result._InterpolationFrame = cfg.RapidKnifeInterp
                    result._StartFrame = cfg.RapidKnifeSpeed <= 0.1 and 15 or 20
                    result._InterpolationFrame = cfg.RapidKnifeInterp
                else
                    reset = result
                end
            end
            if reset then
                reset._StartFrame = 0
                reset._InterpolationFrame = 0
            end
            return x
        end
    )
end

function late_init.RapidGrenade() end
function late_init.RapidKnife() end

local current_player

local GmLegHoldTrap_typedef = sdk.find_type_definition("chainsaw.GmLegHoldTrap")
function late_init.IgnoreTrap()
    sdk.hook(
        GmLegHoldTrap_typedef:get_method("<initInteractTrigger>b__90_1"),
        function (args)
            if cfg.IgnoreTrap then
                local arg = sdk.to_managed_object(args[3])
                if arg:get_Target() == current_player:get_BodyGameObject() then
                    return sdk.PreHookResult.SKIP_ORIGINAL
                end
            end
        end
    )
end

local function start_hug()
    if current_player then
        local player_HeadUpdater = current_player:get_HeadUpdater()
        player_HeadUpdater:startHug()
    end
end

local function end_hug()
    if current_player then
        local player_HeadUpdater = current_player:get_HeadUpdater()
        local is_hug = player_HeadUpdater:get_IsPartnerHug()
        player_HeadUpdater:endHug()
        if is_hug then
            local partner = characterManager:getPartnerContextRef()
            if partner then
                local playerBody = current_player:get_BodyGameObject()
                local partnerBody = partner:get_BodyGameObject()
                if not playerBody or not partnerBody then
                    return
                end
                local playerBody_Transform = get_Transform:call(playerBody)
                local partnerBody_Transform = get_Transform:call(partnerBody)
                local pos = playerBody_Transform:get_Position()
                local forward = playerBody_Transform:get_AxisZ()
                pos = pos + forward * -2
                pos.y = pos.y + 1
                partnerBody_Transform:call("set_Position", pos)
                partnerBody_Transform:call("set_Rotation", playerBody_Transform:get_Rotation())

                local characterController = move_to_lib.getCharacterController(partnerBody)
                if characterController then
                    move_to_lib.warp:call(characterController)
                end
            end
        end
    end
end

local function toggle_hug()
    if current_player then
        local player_HeadUpdater = current_player:get_HeadUpdater()
        local is_hug = player_HeadUpdater:get_IsPartnerHug()
        if not is_hug then
            start_hug()
        else
            end_hug()
        end
    end
end

local function full_health()
    if current_player then
        local hit_point = current_player:get_HitPoint()
        hit_point:set_CurrentHitPoint(hit_point:get_DefaultHitPoint())
    end
end

for key, fn in pairs(late_init) do
    if cfg[key] then
        do_late_init(key)
    end
end

local last_time = 0
local rank_data = {}
local last_player_run_speed_rate
local last_player
local current_health
local max_health

re.on_frame(function ()
    local now = os.clock()
    if now - last_time > 1 then
        last_time = now
        rank_data.GameRank = gameRankSystem:get_GameRank()
        rank_data.EnemyWinceRate = gameRankSystem:getRankEnemyWinceRate()
        rank_data.EnemyBreakRate = gameRankSystem:getRankEnemyBreakRate()
        rank_data.EnemyDamageRate = gameRankSystem:getRankEnemyDamageRate()
        rank_data.EnemyStoppingRate = gameRankSystem:getRankEnemyStoppingRate()
        rank_data.KnifeReduceRate = gameRankSystem:getKnifeReduceRate()
        rank_data.ItemPoint = gameRankSystem:get_ItemPoint()

        local player = characterManager:getPlayerContextRef()
        current_player = player
        if player then
            if cfg.PlayerRunSpeedRateEnable and (last_player ~= player or last_player_run_speed_rate ~= cfg.PlayerRunSpeedRate) then
                local data = player:get_HeadUpdater():get_ParamUserData()
                data._RunSpeedRate = cfg.PlayerRunSpeedRate
                -- data._WalkSpeedRate = cfg.PlayerRunSpeedRate
                -- data._NarrowRunSpeedRate = cfg.PlayerRunSpeedRate
                -- data._NarrowRunSpeedRate = cfg.PlayerRunSpeedRate
                -- data._HoldWalkSpeedRate = cfg.PlayerRunSpeedRate
                data._BattleRunSpeedRate = cfg.PlayerRunSpeedRate
                -- data._BattleWalkSpeedRate = cfg.PlayerRunSpeedRate
                last_player = player
                last_player_run_speed_rate = cfg.PlayerRunSpeedRate
            elseif not cfg.PlayerRunSpeedRateEnable and last_player_run_speed_rate and last_player_run_speed_rate > 1.0 then
                last_player = player
                last_player_run_speed_rate = 1.0
                local data = player:get_HeadUpdater():get_ParamUserData()
                data._RunSpeedRate = last_player_run_speed_rate
                data._BattleRunSpeedRate = last_player_run_speed_rate
            end
            local hit_point = player:get_HitPoint()
            hit_point:set_Invincible(cfg.PlayerInvincible)
            if cfg.HealthEnable then
                current_health = hit_point:get_CurrentHitPoint()
                max_health = hit_point:get_DefaultHitPoint()
            end
        end
        if cfg.PartnerInvincible then
            local partner = characterManager:getPartnerContextRef()
            if partner then
                partner:get_HitPoint():set_Invincible(cfg.PartnerInvincible)
            end
        end
    end
end)

local function toggle_checkbox(name)
    cfg[name] = not cfg[name]
    if cfg[name] then
        do_late_init(name)
    end
end

re.on_application_entry("UpdateHID", function()
    if mod:handle_key(cfg.FullHealthHotKey) then
        full_health()
    end
    if mod:handle_key(cfg.ToggleHugHotKey) then
        toggle_hug()
    end
    if mod:handle_key(cfg.EnemyPauseHotKey) then
        toggle_checkbox("EnemyPause")
    end
    if mod:handle_key(cfg.EnemySpeedRateHotKey) then
        toggle_checkbox("EnemySpeedRateEnable")
    end
    if cfg.MoveToAiming then
        if mod:handle_key(cfg.MoveToAimingHotKey) then
            move_to_lib.move_to_aiming(cfg.MoveToAimingInterp)
        end
        if mod:handle_key(cfg.MoveToAimingBackHotKey) then
            move_to_lib.move_to_aiming(cfg.MoveToAimingInterp, true)
        end
        if mod:handle_key(cfg.MoveTowardsCameraHotKey) then
            move_to_lib.move_to_camera(cfg.MoveTowardsCameraDistance, cfg.MoveToAimingInterp)
        end
    end
end)

local function render_checkbox(name)
    local changed, value = mod:render_checkbox(name)
    if changed and value then
        do_late_init(name)
    end
end

local function render_slider_float(name)
    local changed, value
    local range = range_define[name]
    local enable_key = name .. "Enable"
    imgui.push_id(mod.gui_ids[name])
    changed, value = imgui.checkbox(nil, cfg[enable_key])
    imgui.pop_id()
    if changed then
        cfg[enable_key] = value
    end
    if changed and value then
        do_late_init(enable_key)
    end
    imgui.same_line()
    imgui.set_next_item_width(300)
    local label = mod:text(name)
    if rank_data[name] then
        label = string.format("%s: %.1f", mod:text(name), rank_data[name])
    end
    changed, value = imgui.slider_float(label, cfg[name], range[1], range[2], range[3] or "%.1f")
    if changed then
        cfg[name] = value
    end
end

re.on_draw_ui(function()
    local changed, value
    if mod:begin_render_config() then
        if imgui.button(mod:text("ToggleHug")) then
            toggle_hug()
        end
        mod:render_key_config("ToggleHug")
        if imgui.button(mod:text("FullHealth")) then
            full_health()
        end
        mod:render_key_config("FullHealth")
        render_checkbox("StopClock")
        render_checkbox("PlayerInvincible")
        imgui.same_line()
        render_checkbox("PartnerInvincible")
        render_checkbox("EnemyPause")
        mod:render_key_config("EnemyPause")
        -- render_checkbox("NoReload")
        render_checkbox("InfiniteAmmo")
        render_checkbox("NoRecoil")
        render_checkbox("PerfectAccuracy")
        render_checkbox("ItemCountNotSub")
        render_checkbox("ItemDurabilityNotSub")
        render_checkbox("ShootTypeFullAuto")
        render_checkbox("IgnoreTrap")
        render_checkbox("RapidFire")
        render_checkbox("SuperRapidFire")
        if cfg.SuperRapidFire then
            imgui.same_line()
            imgui.set_next_item_width(100)
            mod:render_slider_float_data("SuperRapidFireSpeed", range_define)
            imgui.same_line()
            imgui.set_next_item_width(100)
            mod:render_slider_float_data("SuperRapidFireInterp", range_define)
        end
        -- render_checkbox("RapidGrenade")
        -- if cfg.RapidGrenade then
        --     imgui.same_line()
        --     imgui.set_next_item_width(100)
        --     mod:render_slider_float_data("RapidGrenadeSpeed", range_define)
        --     imgui.same_line()
        --     imgui.set_next_item_width(100)
        --     mod:render_slider_float_data("RapidGrenadeInterp", range_define)
        -- end
        render_checkbox("RapidKnife")
        if cfg.RapidKnife then
            imgui.same_line()
            imgui.set_next_item_width(100)
            mod:render_slider_float_data("RapidKnifeSpeed", range_define)
            imgui.same_line()
            imgui.set_next_item_width(100)
            mod:render_slider_float_data("RapidKnifeInterp", range_define)
        end
        render_checkbox("HealthEnable")
        if cfg.HealthEnable and current_health then
            imgui.same_line()
            imgui.push_id(mod.gui_ids.current_health)
            imgui.set_next_item_width(100)
            changed, value = imgui.slider_int(nil, current_health, 1260, 2500)
            imgui.pop_id()
            if changed and current_player then
                current_health = value
                current_player:get_HitPoint():set_CurrentHitPoint(value)
            end
            imgui.same_line()
            imgui.text("/")
            imgui.same_line()
            imgui.push_id(mod.gui_ids.max_health)
            imgui.set_next_item_width(100)
            changed, value = imgui.slider_int(nil, max_health, 1260, 2500)
            imgui.pop_id()
            if changed and current_player then
                max_health = value
                current_player:get_HitPoint():set_DefaultHitPoint(value)
            end
        end

        for _, name in ipairs(value_names) do
            render_slider_float(name)
        end
        mod:render_key_config("EnemySpeedRate")
        render_checkbox("MoveToAiming")
        mod:tooltip("MoveToAimingHint")
        move_to_lib.enable = cfg.MoveToAiming
        if cfg.MoveToAiming then
            render_checkbox("MoveToAimingInterp")
            mod:render_key_config("MoveToAiming")
            mod:render_key_config("MoveToAimingBack")
            mod:render_key_config("MoveTowardsCamera")
            mod:render_slider_float("MoveTowardsCameraDistance", 1, 5, "%.1f")
        end
        mod:end_render_config()
    end
end)
