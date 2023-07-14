-- Item adder for Resident Evil 4
-- Author: chenstack
-- Version: 1.4 (Pro)
-- Functions: Add inventory items any time and any where

local version = "1.4"
local cfg_path = "item_adder/config.json"

local default_cfg = {
    graph_closes_with_reframework = true,
    show_item_adder = true,
    weapon_custom_max = false,
    font_size = 30,
    use_english = false,
    craft_bonus_count = 0,
    craft_result_mult = 1,
}


local function table_assign(dst, data)
    dst = dst or {}
    if data == nil then
        return dst
    end
    for key, value in pairs(data) do
        if type(value) == 'table' then
            dst[key] = table_assign(nil, value)
        else
            dst[key] = value
        end
    end
    return dst
end

local cfg = json.load_file(cfg_path) or {}
for key, value in pairs(default_cfg) do
    if cfg[key] == nil then
        if type(value) == 'table' then
            cfg[key] = table_assign(nil, value)
        else
            cfg[key] = value
        end
    end
end

local function dump_cfg()
    json.dump_file(cfg_path, cfg)
end

re.on_config_save(function()
    dump_cfg()
end)

local message_dict_default = {
    window_title = "Item adder by chenstack v" .. tostring(version) .. " (pro version)",
    usage_hint = "Please backup your game save before use",
    pro_hint = "Pro version is loaded.",
    use_english = "Use english",
    reload_message = "Reload items info (when change language)",
    font_size = "Font size (20~60)",
    weapon_warning = "Warning: if same weapon in storage box, will loss new added one when send to storage",
    keyitem_waning = "Warning: Be careful to add this items, may break game flow",
    show_item_adder = "Show item adder",
    remove_key_item = "If you added key item unexpected, check this then click that button to remove",
    weapon_custom_max = "Added weapon custom max",
    not_support_language = "Currently not support render this game language, please set to other",
    useful_functions = "Useful functions",
    craft_bonus_count = "Extra craft bonus count",
    craft_result_mult = "Craft result mult",
}
local message_dict_zh = {
    window_title = "物品添加 by chenstack v" .. tostring(version) .. " (专业版)",
    usage_hint = "使用前请先备份存档",
    pro_hint = "专业版已加载，请支持原创",
    use_english = "Use english",
    reload_message = "刷新数据(切换语言后)",
    font_size = "字体大小 (20~60)",
    weapon_warning = "注意：如果储物箱里已经有相同的武器，新添加的武器放到物品箱后会丢失",
    keyitem_waning = "注意：添加剧情物品，可能会影响游戏流程，谨慎使用",
    Weapon = "武器",
    Grenade = "手雷",
    Accessory = "武器配件",
    HealItem = "治疗物品",
    Ammo = "弹药",
    KeyItem = "关键物品",
    Treasure = "珍宝",
    Unique = "独特物品",
    Money = "金钱",
    Charms = "手提箱挂件",
    show_item_adder = "显示物品添加器窗口",
    remove_key_item = "如果意外地添加了不想要的关键物品又卖不掉，可以勾选这个然后按对应的按钮删除",
    weapon_custom_max = "满改添加的武器",
    useful_functions = "实用功能",
    craft_bonus_count = "额外合成奖励",
    craft_result_mult = "合成数量倍数",
}
local message_dict = message_dict_default

local Category_Weapon = 1
local Category_Grenade = 2
local Category_Accessory = 3
local Category_HealItem = 4
local Category_Ammo = 5
local Category_KeyItem = 6
local Category_Treasure = 7
local Category_Unique = 8
local Category_Money = 9
local Category_Charms = 10

local PTAS_ID = 124000000
local SPINEL_ID = 120800000

local attacheCaseSizeTable = {
    -- [124160000] = 0x0,
    [124161600] = 0x1,
    [124163200] = 0x2,
    [124164800] = 0x3,
    [124166400] = 0x4,
}

local items_data = {
    {
        name = "Weapon",
        warning = "weapon_warning",
        items = {
            { id = 274835456 },  -- SG-09 R
            { id = 274837056 },  -- 惩罚者
            { id = 274838656 },  -- Red9
            { id = 274840256 },  -- 黑尾
            { id = 274841856 },  -- 玛蒂尔达
            -- { id = 274843456 },  -- 矿车手枪
            { id = 274995456 },  -- W-870
            { id = 274997056 },  -- 镇暴枪
            { id = 274998656 },  -- 打击者
            { id = 275155456 },  -- TMP
            { id = 275158656 },  -- LE 5
            { id = 275475456 },  -- SR M1903
            { id = 275477056 },  -- 刺鳐战术步枪
            { id = 275478656 },  -- CQBR突击步枪
            { id = 275635456 },  -- 折翼蝴蝶
            { id = 275637056 },  -- Killer7
            { id = 275795456 },  -- 弓弩枪
            { id = 276275456 },  -- 火箭发射器
            { id = 276435456 },  -- 格斗匕首
            { id = 276437056 },  -- 战斗匕首
            { id = 276438656 },  -- 菜刀
            { id = 276440256 },  -- 靴刀
            { id = 276445056 },  -- 原始之刃(奖励)
            { id = 275157056 },  -- 芝加哥清道夫(奖励)
            { id = 275638656 },  -- 手炮(奖励)
            { id = 276278656 },  -- 无限火箭发射器(奖励)
            { id = 276277056 },  -- 火箭发射器（特殊）
            { id = 278035456 },  -- Sentinel Nine (DLC)
            { id = 278037056 },  -- 碎颅者 (DLC)
            { id = 278521856 },  -- 克劳瑟的弓 (佣兵模式)
        }
    },
    {
        name = "Grenade",
        items = {
            { id = 277075456 },  -- 破片手榴弹
            { id = 277077056 },  -- 高爆手榴弹
            { id = 277078656 },  -- 闪光手榴弹
            { id = 277080256 },  -- 白壳鸡蛋
            { id = 277081856 },  -- 红壳鸡蛋
            { id = 277083456 },  -- 金壳鸡蛋
        }
    },
    {
        name = "Accessory",
        items = {
            { id = 116008000 },  -- 激光瞄准器
            { id = 116000000 },  -- 瞄准镜
            { id = 116003200 },  -- 高倍瞄准镜
            { id = 116004800 },  -- 生物传感镜
            { id = 116001600 },  -- 枪托（Red9）
            { id = 116006400 },  -- 枪托（TMP）
            { id = 116009600 },  -- 枪托（玛蒂尔达）
        }
    },
    {
        name = "HealItem",
        items = {
            { id = 114400000 },  -- 绿色草药
            { id = 114401600 },  -- 红色草药
            { id = 114403200 },  -- 黄色草药
            { id = 114404800 },  -- 混合草药（绿+绿）
            { id = 114406400 },  -- 混合草药（绿+绿+绿）
            { id = 114408000 },  -- 混合草药（绿+红）
            { id = 114409600 },  -- 混合草药（绿+黄）
            { id = 114411200 },  -- 混合草药（红+黄）
            { id = 114412800 },  -- 混合草药（绿+红+黄）
            { id = 114414400 },  -- 混合草药（绿+绿+黄）
            { id = 114416000 },  -- 急救喷雾
            { id = 114417600 },  -- 黑鲈鱼
            { id = 114419200 },  -- 大鲈鱼
            { id = 114420800 },  -- 黑鲈鱼（大）
            { id = 114422400 },  -- 蝰蛇
            { id = 114424000 },  -- 独角仙
        }
    },
    {
        name = "Ammo",
        items = {
            { id = 112800000 },  -- 手枪弹药
            { id = 112801600 },  -- 马格南弹药
            { id = 112803200 },  -- 霰弹枪弹药
            { id = 112804800 },  -- 步枪弹药
            { id = 112806400 },  -- 冲锋枪弹药
            { id = 112808000 },  -- 弩箭
            { id = 117603200 },  -- 弩箭雷
            { id = 117600000 },  -- 火药
            { id = 117601600 },  -- 物资（大）
            { id = 117606400 },  -- 物资（小）
            { id = 112320000 },  -- 爆炸箭 (佣兵模式)
        }
    },
    {
        name = "KeyItem",
        warning = "keyitem_waning",
        items = {
            { id = 119244800, add_count = 5 },   -- 小钥匙
            { id = 119286400, add_count = 10 },  -- 银质代币
            { id = 119288000, add_count = 10 },  -- 金质代币
            { id = 119281600 },  -- 猎人小屋的钥匙
            { id = 119204800 },  -- 徽记钥匙
            { id = 119256000 },  -- 老旧的神龛钥匙
            { id = 119203200 },  -- 六边形浮雕
            { id = 119235200 },  -- 木质齿轮
            { id = 119217600 },  -- 水晶球
            { id = 119248000 },  -- 六边形拼图A
            { id = 119249600 },  -- 六边形拼图B
            { id = 119251200 },  -- 六边形拼图C
            { id = 119273600 },  -- 小艇燃料
            { id = 119230400 },  -- 亵渎者头雕
            { id = 119232000 },  -- 叛教者头雕
            { id = 119257600 },  -- 教堂徽记
            { id = 119284800 },  -- 蓝色转盘
            { id = 119289600 },  -- 木板
            { id = 119246400 },  -- 关隘大门摇柄
            { id = 119254400 },  -- 地牢钥匙
            { id = 119209600 },  -- 绯红提灯
            { id = 119260800 },  -- 金剑
            { id = 119262400 },  -- 铁剑
            { id = 119278400 },  -- 血剑
            { id = 119280000 },  -- 锈剑
            { id = 119265600 },  -- 版画石板A
            { id = 119267200 },  -- 版画石板B
            { id = 119268800 },  -- 版画石板C
            { id = 119270400 },  -- 版画石板D
            { id = 119276800 },  -- 立方雕
            { id = 119206400 },  -- 光晕转轮
            { id = 119222400 },  -- 狮头雕像
            { id = 119224000 },  -- 羊头雕像
            { id = 119225600 },  -- 蛇头雕像
            { id = 119275200 },  -- 钥匙串
            { id = 119220800 },  -- 萨拉扎家族徽记
            { id = 119283200 },  -- 独角兽之角
            { id = 119236800 },  -- 开矿炸药
            { id = 119238400 },  -- 路易斯的钥匙
            { id = 119211200 },  -- 1级钥匙卡
            { id = 119212800 },  -- 2级钥匙卡
            { id = 119214400 },  -- 3级钥匙卡
            { id = 119219200 },  -- 扳手
            { id = 119259200 },  -- 摩托艇钥匙
        }
    },
    {
        name = "Treasure",
        items = {
            { id = 120830400, add_count = 5 },  -- 红宝石
            { id = 120833600, add_count = 5 },  -- 蓝宝石
            { id = 120835200, add_count = 5 },  -- 黄钻石
            { id = 120832000, add_count = 5 },  -- 祖母绿
            { id = 120838400, add_count = 5 },  -- 亚历山大石
            { id = 120857600, add_count = 5 },  -- 红色线柱石
            { id = 120867200, add_count = 1 },  -- 高级改造券
            { id = 120801600 },  -- 珍珠吊坠
            { id = 120803200 },  -- 脏臭的珍珠吊坠
            { id = 120809600 },  -- 黄铜怀表
            { id = 120812800 },  -- 萤石发饰
            { id = 120814400 },  -- 老式烟斗
            { id = 120816000 },  -- 珍珠手镯
            { id = 120817600 },  -- 红宝石戒指
            { id = 120819200 },  -- 金手镯
            { id = 120820800 },  -- 光明吊坠
            { id = 120822400 },  -- 珍珠红宝石镜
            { id = 120824000 },  -- 金沙漏
            { id = 120825600 },  -- 优雅的香水瓶
            { id = 120827200 },  -- 华美的棋盘
            { id = 120828800 },  -- 皇家权杖
            { id = 120840000 },  -- 金条
            { id = 120841600 },  -- 金条（大）
            { id = 120843200 },  -- 金砖
            { id = 120844800 },  -- 堕落神像
            { id = 120846400 },  -- 老式指南针
            { id = 120848000 },  -- 正义女神像
            { id = 120849600 },  -- 水晶矿石
            { id = 120851200 },  -- 华丽的甲虫
            { id = 120852800 },  -- 门德斯的义眼
            { id = 120854400 },  -- 金丝单眼镜
            { id = 120856000 },  -- 胭脂口红
            { id = 120860800 },  -- 老式相机
            { id = 120864000 },  -- 紫馨石
            { id = 120865600 },  -- 刮花的祖母绿
            { id = 122400000 },  -- 奢华的面具
            { id = 122401600 },  -- 酒壶
            { id = 122403200 },  -- 妖光蝶提灯
            { id = 122404800 },  -- 高贵的王冠
            { id = 122406400 },  -- 金山猫像
            { id = 122408000 },  -- 豪华的时钟
            { id = 122409600 },  -- 华贵的手镯
            { id = 122411200 },  -- 救赎圣杯
            { id = 122412800 },  -- 华贵的项链
            { id = 122416000 },  -- 精致的手镯
        }
    },
    {
        name = "Unique",
        items = {
            { id = 124001600 },  -- 护甲背心
            { id = 124003200 },  -- 村庄藏宝图
            { id = 124004800 },  -- 城堡藏宝图
            { id = 124006400 },  -- 孤岛藏宝图
            -- { id = 124160000 },  -- 手提箱扩容（7x10）
            { id = 124161600 },  -- 手提箱扩容（7x12）
            { id = 124163200 },  -- 手提箱扩容（8x12）
            { id = 124164800 },  -- 手提箱扩容（8x13）
            { id = 124166400 },  -- 手提箱扩容（9x13）
            { id = 124176000 },  -- 银色手提箱
            { id = 124177600 },  -- 黑色手提箱
            { id = 124179200 },  -- 皮革手提箱
            { id = 124192000 },  -- 金色手提箱 (预购)
            { id = 124193600 },  -- 经典手提箱 (豪华版预购)
            -- WIP
            -- { id = 124321600 },  -- 配方：手枪弹药
            -- { id = 124323200 },  -- 配方：霰弹枪弹药
            -- { id = 124324800 },  -- 配方：冲锋枪弹药
            -- { id = 124326400 },  -- 配方：步枪弹药
            { id = 124328000 },  -- 配方：马格南弹药
            -- { id = 124329600 },  -- 配方：弩箭
            -- { id = 124331200 },  -- 配方：弩箭
            -- { id = 124334400 },  -- 配方：弩箭雷
            -- { id = 124336000 },  -- 配方：高爆手榴弹
            -- { id = 124337600 },  -- 配方：闪光手榴弹
            -- { id = 124353600 },  -- 配方：混合草药（绿+绿）
            -- { id = 124355200 },  -- 配方：混合草药（绿+红）
            -- { id = 124356800 },  -- 配方：混合草药（绿+黄）
            -- { id = 124358400 },  -- 配方：混合草药（红+黄）
            -- { id = 124360000 },  -- 配方：混合草药（绿+绿+绿）
            -- { id = 124361600 },  -- 配方：混合草药（绿+绿+黄）
            -- { id = 124363200 },  -- 配方：混合草药（绿+绿+黄）
            -- { id = 124364800 },  -- 配方：混合草药（绿+红+黄）
            -- { id = 124366400 },  -- 配方：混合草药（绿+红+黄）
            -- { id = 124368000 },  -- 配方：混合草药（绿+红+黄）
        }
    },
    {
        name = "Money",
        items = {
            { id = 124000000, add_count = 100000 },  -- 比塞塔币
            { id = 120800000, add_count = 10 },  -- 尖晶石
        }
    },
    {
        name = "Charms",
        items = {
            { id = 127360000 },  -- 绿色草药 (豪华版预购)
            { id = 127361600 },  -- 手枪弹药 (预购)
            { id = 127200000 },  -- 荷塞先生
            { id = 127201600 },  -- 迭戈先生
            { id = 127203200 },  -- 埃斯特万先生
            { id = 127204800 },  -- 曼努埃尔先生
            { id = 127206400 },  -- 伊莎贝尔女士
            { id = 127208000 },  -- 玛丽亚女士
            { id = 127209600 },  -- 萨尔瓦多医生
            { id = 127211200 },  -- 贝拉姐妹
            { id = 127212800 },  -- 佩德罗先生
            { id = 127214400 },  -- 邪教徒（巨镰）
            { id = 127216000 },  -- 邪教徒（盾牌）
            { id = 127217600 },  -- 邪教徒（十字弩）
            { id = 127219200 },  -- 邪教徒（引导者）
            { id = 127220800 },  -- 士兵（炸药）
            { id = 127222400 },  -- 士兵（电棍）
            { id = 127224000 },  -- 士兵（铁锤）
            { id = 127225600 },  -- J.J.
            { id = 127227200 },  -- 里昂（手枪）
            { id = 127228800 },  -- 里昂（霰弹枪）
            { id = 127230400 },  -- 里昂（火箭发射器）
            { id = 127232000 },  -- 商人
            { id = 127233600 },  -- 阿什莉 · 格拉汉姆
            { id = 127235200 },  -- 路易斯 · 塞拉
            { id = 127236800 },  -- 艾达 · 王
            { id = 127238400 },  -- 鸡
            { id = 127240000 },  -- 黑鲈鱼
            { id = 127241600 },  -- 独角仙
            { id = 127243200 },  -- 光明教徽
            { id = 127244800 },  -- 打击者
            { id = 127246400 },  -- 可爱熊
        }
    },
}


local optionManager = sdk.get_managed_singleton("chainsaw.OptionManager")
local messageManager = sdk.get_managed_singleton("chainsaw.MessageManager")
local MessageManager_typedef = sdk.find_type_definition("chainsaw.MessageManager")
-- getMessage(System.Guid message_id, via.Language language_id, bool emptyable)
local getMessage_method = MessageManager_typedef:get_method("getMessage(System.Guid, via.Language, System.Boolean)")
local itemManager = sdk.get_managed_singleton("chainsaw.ItemManager")
local itemMessageManager = itemManager:get_ItemMessageManager()
-- local InGameShopGuiUtil_typedef = sdk.find_type_definition("chainsaw.gui.shop.InGameShopGuiUtil")
-- local constructPurchaseItem = InGameShopGuiUtil_typedef:get_method("constructPurchaseItem")
local characterManager = sdk.get_managed_singleton("chainsaw.CharacterManager")
local ChainsawGuiUtil_typedef = sdk.find_type_definition("chainsaw.ChainsawGuiUtil")
local generateItem = ChainsawGuiUtil_typedef:get_method("generateItem")
-- local getInventoryControllers = ChainsawGuiUtil_typedef:get_method("getInventoryControllers(chainsaw.ContextID)")
local MsgID_typedef = sdk.find_type_definition("via.gui.MsgID")
local inventoryManager = sdk.get_managed_singleton("chainsaw.InventoryManager")
local inGameShopManager = sdk.get_managed_singleton("chainsaw.InGameShopManager")

local weaponCustomManager = sdk.get_managed_singleton("chainsaw.WeaponCustomManager")
local weaponCustomManager_typedefine = sdk.find_type_definition("chainsaw.WeaponCustomManager")
local getMaxCustomLevel_Common = weaponCustomManager_typedefine:get_method("getMaxCustomLevel(chainsaw.WeaponID, chainsaw.CommonCustomCategory)")
local getMaxCustomLevel_Individual = weaponCustomManager_typedefine:get_method("getMaxCustomLevel(chainsaw.WeaponID, chainsaw.IndividualCustomCategory)")
local getMaxCustomLevel_Limit = weaponCustomManager_typedefine:get_method("getMaxCustomLevel(chainsaw.WeaponID, chainsaw.LimitBreakCustomCategory)")

local Language_English = 0x1
local Language_SimplelifiedChinese = 0xD
local Language_TransitionalChinese = 0xC
local Language_Japanese = 0x0
local Language_French = 0x2
local Language_Russian = 0x6
local Language_Korean = 0xB
local Language_Arabic = 0x15
local language

local function empty_or(text, default)
    if text == nil or text == "" then
        return default
    end
    return text
end

local function getMessage(msdId)
    return getMessage_method:call(messageManager, msdId, language, true)
end

local function get_ref_string(text)
    local ref_id = MsgID_typedef:get_field(string.sub(text, 6, #text - 1)):get_data(nil)
    if ref_id ~= nil then
        local result = getMessage(ref_id)
        if result and result ~= "" then
            result = string.gsub(result, "%%", "")
            result = string.gsub(result, "％", "")
            result = string.gsub(result, "{0}", "")
        end
        return result
    end
    return text
end

-- get item name and desc
local function read_item_msg()
    for index, category in ipairs(items_data) do
        for _, item in ipairs(category.items) do
            local msdId = itemMessageManager:getItemNameMsgId(item.id)
            local captionMsgId = itemMessageManager:getItemCaptionMsgId(item.id)
            -- local perksMessage = itemMessageManager:getItemPerksMessage(item.id)
            item.name = empty_or(getMessage(msdId), item.name)
            item.desc = empty_or(getMessage(captionMsgId), item.desc)
            if item.desc ~= nil and item.desc:find("^<REF ") then
                item.desc = get_ref_string(item.desc)
            end
            -- item.perks = getMessage(perksMessage)
        end
    end
end


local current_tab = 1
local remove_key_item = false

local function get_enum_table(typename)
    local type = sdk.find_type_definition(typename)
    if not type then return {} end

    local fields = type:get_fields()
    local enum = {}

    for i, field in ipairs(fields) do
        if field:is_static() then
            enum[field:get_name()] = field:get_data(nil)
        end
    end

    return enum
end

local commonCustomCategory = get_enum_table("chainsaw.CommonCustomCategory")
local individualCustomCategory = get_enum_table("chainsaw.IndividualCustomCategory")
local limitBreakCustomCategory = get_enum_table("chainsaw.LimitBreakCustomCategory")

local function weapon_custom_max(weapon)
    local weaponId = weapon:get_WeaponId()
    local customLevel = weapon:get_CustomLevelInWeapon()
    if customLevel == nil then
        return
    end

    -- void setCommomCustomLevel(chainsaw.CommonCustomCategory commonCategory, int commonLevel, chainsaw.CustomLevelInWeapon customLevelInWeapon, chainsaw.WeaponID weaponID)
    for key, value in pairs(commonCustomCategory) do
        if value ~= 0xFFFFFFFF then
            local max_level = getMaxCustomLevel_Common:call(weaponCustomManager, weaponId, value)
            if max_level ~= -1 then
                weaponCustomManager:setCommomCustomLevel(value, max_level, customLevel, weaponId)
            end
        end
    end
    -- void setIndividualCustomLevel(chainsaw.IndividualCustomCategory individualCategory, int individualLevel, chainsaw.CustomLevelInWeapon customLevelInWeapon, chainsaw.WeaponID weaponID) = 141C92180
    for key, value in pairs(individualCustomCategory) do
        if value ~= 0xFFFFFFFF then
            local max_level = getMaxCustomLevel_Individual:call(weaponCustomManager, weaponId, value)
            if max_level ~= -1 then
                weaponCustomManager:setIndividualCustomLevel(value, max_level, customLevel, weaponId)
            end
        end
    end
    -- void setLimitBreakCustomLevel(chainsaw.LimitBreakCustomCategory limitBreakCategory, int limitBreakLevel, chainsaw.CustomLevelInWeapon customLevelInWeapon) = 141C934A0
    for key, value in pairs(limitBreakCustomCategory) do
        if value ~= 0xFFFFFFFF then
            local max_level = getMaxCustomLevel_Limit:call(weaponCustomManager, weaponId, value)
            if max_level ~= -1 then
                weaponCustomManager:setLimitBreakCustomLevel(value, max_level, customLevel)
            end
        end
    end

    weapon:setAmmoCount(weapon:get_CurrentAmmoMax())
    weapon:setDurability(weapon:get_CurrentDurabilityMax())
end

local function do_add_item(item_data)
    local player = characterManager:getPlayerContextRef()
    if player == nil then
        return
    end
    -- add ptas and spinel
    if item_data.id == PTAS_ID then
        inventoryManager:addPTAS(item_data.add_count, false)
        return
    elseif item_data.id == SPINEL_ID then
        inGameShopManager:addSpinelCount(item_data.add_count)
        return
    end
    -- local context_id = player:get_SpawnerID()
    -- local controllersInfo = getInventoryControllers:call(nil, context_id)
    local player_UeadUpdater = player:get_HeadUpdater()
    local controller

    local is_csInventory = false
    local is_unique = false
    if current_tab == Category_KeyItem then
        controller = player_UeadUpdater:get_KeyItemInventoryController()
    elseif current_tab == Category_Treasure then
        controller = player_UeadUpdater:get_TreasureInventoryController()
    elseif current_tab == Category_Unique or current_tab == Category_Charms then
        controller = player_UeadUpdater:get_UniqueInventoryController()
        is_unique = true
    else
        controller = player_UeadUpdater:get_InventoryController()
        is_csInventory = true
    end
    if controller ~= nil then
        if current_tab == Category_KeyItem and remove_key_item then
            controller:reduceItem(item_data.id, 1)
            remove_key_item = false
            return
        end
        -- constructPurchaseItem has treasure issue
        -- local item = constructPurchaseItem:call(nil, item_data.id, item_data.add_count or 1)
        -- chainsaw.Item generateItem(chainsaw.ItemID itemId, int itemCount, int durability, chainsaw.ItemID ammoId, int ammoCount, bool changeId)
        local item = generateItem:call(nil, item_data.id, item_data.add_count or 1, -1, -1, 100, 0)
        if item == nil then
            return
        end
        if current_tab == Category_Weapon and cfg.weapon_custom_max then
            weapon_custom_max(item)
        end
        if not item_data.add_count and current_tab ~= Category_Treasure and not is_unique then
            local add_count = item:get_RemainingStackableCount()
            if add_count > 90 then
                add_count = 9
            end
            if add_count > 0 then
                item:addCount(add_count)
            end
        end

        local success
        if current_tab == Category_Treasure or is_unique then
            success = controller:call("add", item)
        else
            success = controller:call("pickupItem(chainsaw.Item)", item)
        end
        -- attacheCaseSize
        if success and is_unique then
            local attacheCaseSize = attacheCaseSizeTable[item_data.id]
            if attacheCaseSize then
                local csInventoryController = player_UeadUpdater:get_InventoryController()
                if csInventoryController:get_CurrInventorySize() < attacheCaseSize then
                    csInventoryController:changeSize(attacheCaseSize, false)
                end
            end
        end
        if not success and is_csInventory then
            controller:pickupInstance(item)
        end
    end
end

local CsInventoryController_typedefine = sdk.find_type_definition("chainsaw.CsInventoryController")
sdk.hook(
    CsInventoryController_typedefine:get_method("getCraftBonusCount"),
    nil,
    function(x)
        if cfg.craft_bonus_count > 0 then
            x = sdk.to_ptr(sdk.to_int64(x) + cfg.craft_bonus_count)
        end
        return x
    end
)

local ItemCraftRecipe_typedefine = sdk.find_type_definition("chainsaw.ItemCraftRecipe")
sdk.hook(
    ItemCraftRecipe_typedefine:get_method("getCraftResult"),
    nil,
    function(x)
        if cfg.craft_result_mult > 1 then
            local result = sdk.to_managed_object(x)
            result._GeneratedNumMax = result._GeneratedNumMax * cfg.craft_result_mult
            result._GeneratedNumMin = result._GeneratedNumMin * cfg.craft_result_mult
        end
        return x
    end
)

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

local font

local function handle_language(force_reload)
    local new_language
    if cfg.use_english then
        new_language = Language_English
        font = nil
    else
        new_language = optionManager:getTextLanguage()
    end
    if new_language == language and not force_reload then
        return
    end
    language = new_language
    read_item_msg()
    if language == Language_SimplelifiedChinese or
        language == Language_TransitionalChinese then
        message_dict = message_dict_zh
    else
        message_dict = message_dict_default
    end
    if language == Language_SimplelifiedChinese or
        language == Language_TransitionalChinese or
        language == Language_Japanese then
        font = imgui.load_font("STXIHEI.TTF", cfg.font_size, GlyphRangesChineseFull)
    elseif language == Language_French then
        font = imgui.load_font("STXIHEI.TTF", cfg.font_size, GlyphRangesFrench)
    elseif language == Language_Russian then
        font = imgui.load_font("STXIHEI.TTF", cfg.font_size, GlyphRangesRussian)
    elseif language == Language_Korean then
        font = imgui.load_font("malgunsl.ttf", cfg.font_size, GlyphRangesKorean)
    end
end

local function tooltip(text)
    if imgui.is_item_hovered() then
        imgui.set_tooltip(text)
    end
end

local ImGuiCol_Text = 0
local ImGuiCol_Button = 21
local ImGuiStyleVar_WindowRounding = 2

local function render_checkbox(name)
    local changed, value = imgui.checkbox(message_dict[name], cfg[name])
    if changed then
        cfg[name] = value
    end
    return changed, value
end

local COLOR_WARNING = 0xFF00FFFF
local COLOR_ACTIVE = 0xFFF4853D

local function draw_functions()
    imgui.set_next_item_open(true, 1 << 1)
    if imgui.tree_node(message_dict.useful_functions) then
        local changed, value = imgui.slider_int(message_dict.craft_bonus_count, cfg.craft_bonus_count, 0, 30)
        if changed then
            cfg.craft_bonus_count = value
        end
        changed, value = imgui.slider_int(message_dict.craft_result_mult, cfg.craft_result_mult, 1, 10)
        if changed then
            cfg.craft_result_mult = value
        end
    end
end

local function draw_item_adder()
    if not cfg.show_item_adder then
        return
    end
    local current_font = font
    if current_font then
        imgui.push_font(current_font)
    end
    cfg.show_item_adder = imgui.begin_window(message_dict.window_title, cfg.show_item_adder, 1 << 10)
    if not cfg.show_item_adder then
        if current_font then
            imgui.pop_font()
        end
        return
    end

    imgui.text_colored(message_dict.usage_hint, COLOR_WARNING)

    imgui.text(message_dict.pro_hint)

    if language == Language_Arabic then
        imgui.text_colored(message_dict.not_support_language, COLOR_WARNING)
    end

    imgui.spacing()
    local changed, _ = render_checkbox("use_english")
    if changed then
        handle_language()
    end
    if imgui.button(message_dict.reload_message) then
        handle_language(true)
    end
    imgui.same_line()
    imgui.set_next_item_width(100)
    local change, value = imgui.input_text(message_dict.font_size, cfg.font_size)
    if change then
        value = tonumber(value)
        if value and value >= 20 and value <= 60 then
            cfg.font_size = value
            handle_language(true)
        end
    end

    imgui.spacing()
    -- category
    for index, category in ipairs(items_data) do
        if index == current_tab then
            imgui.push_style_color(ImGuiCol_Button, COLOR_ACTIVE)
        end
        local clicked = imgui.button(message_dict[category.name] or category.name)
        if index == current_tab then
            imgui.pop_style_color()
        end
        if clicked then
            current_tab = index
        end
        imgui.same_line()
    end
    imgui.new_line()

    if items_data[current_tab].warning ~= nil then
        imgui.text_colored(message_dict[items_data[current_tab].warning], COLOR_WARNING)
    end

    if current_tab == Category_Weapon then
        render_checkbox("weapon_custom_max")
    elseif current_tab == Category_KeyItem then
        local changed
        changed, remove_key_item = imgui.checkbox(message_dict.remove_key_item, remove_key_item)
    end

    -- buttons
    imgui.spacing()
    local last_new_line = false
    local index = 1
    for _, item in ipairs(items_data[current_tab].items) do
        if item.name then
            if imgui.button(item.name) then
                do_add_item(item)
            end
            if item.desc then
                tooltip(item.desc)
            end
            last_new_line = true
            if index % 4 ~= 0 then
                last_new_line = false
                imgui.same_line()
            end
            index = index + 1
        end
    end

    if not last_new_line then
        imgui.new_line()
    end
    draw_functions()

    if current_font then
        imgui.pop_font()
    end

    imgui.end_window()
end

local window_size = {
    x = math.max(imgui.get_display_size().x / 4, 960),
    y = math.max(imgui.get_display_size().y / 2, 480)
}

local display_size = imgui.get_display_size()
local window_size_vec = {window_size.x, window_size.y}
local window_pos_vec = {display_size.x / 2 - (window_size.x / 2), display_size.y / 2 - (window_size.y / 2)}

re.on_frame(function()
    if cfg.graph_closes_with_reframework then
        if not reframework:is_drawing_ui() then return end
    end

    if not language then
        handle_language()
    end

    imgui.push_style_var(ImGuiStyleVar_WindowRounding, 10.0)

    imgui.set_next_window_size(window_size_vec, 1 << 1) -- ImGuiCond_Once
    imgui.set_next_window_pos(window_pos_vec, 1 << 1)
    draw_item_adder()

    imgui.pop_style_var()
end)


local checkboxs = {
    "show_item_adder",
}

re.on_draw_ui(function()
    imgui.set_next_item_open(true, 1 << 1)

    if imgui.tree_node("Item adder") then
        local current_font = font
        if current_font then
            imgui.push_font(current_font)
        end
        for _, name in ipairs(checkboxs) do
            render_checkbox(name)
        end
        if current_font then
            imgui.pop_font()
        end
        imgui.tree_pop()
    end
end)
