local AWF = require("AWF Core")

local selectedCharacter = "ch0a0z0_body"; -- WIP Auto Detect player
local waiting_for_input_map = {}
local key_bindings = {}
local prev_key_states = {}
local CountPTAS = 0;
local godMode = false;
local armorDurability = false;
local knifeDurability = false;
local unlimitedHealth = false;
local reloadSpeed = 1.0;
local entitySpeed = 1.0;
local noRecoil = false;
local CountSpinels = 0;
local unlimitedAmmo = false;
local damageMultiplier = 1.0;
local unlimitedItems = false;
local knifeSpeed = 1.0;

local configs = {
	selectedCharacter = selectedCharacter,
	key_bindings = key_bindings,
	prev_key_states = prev_key_states,
	waiting_for_input_map = waiting_for_input_map,
	godMode = godMode,
	armorDurability = armorDurability,
	knifeDurability = knifeDurability,
	unlimitedHealth = unlimitedHealth,
	reloadSpeed = reloadSpeed,
	entitySpeed = entitySpeed,
	noRecoil = noRecoil,
	CountPTAS = CountPTAS,
	CountSpinels = CountSpinels,
	unlimitedAmmo = unlimitedAmmo,
	damageMultiplier = damageMultiplier,
	unlimitedItems = unlimitedItems,
	knifeSpeed = knifeSpeed
}

local sceneManager = sdk.get_native_singleton("via.SceneManager")
if not sceneManager then
	return
end

local sceneManagerTypeDef = sdk.find_type_definition("via.SceneManager")


local function isKeyDown(i)
	if (i == null) then
		return false
	end
	local down = reframework:is_key_down(i)
	local prev = prev_key_states[i]
	prev_key_states[i] = down

	return down and not prev
end

local function getCharacterController()
	local scene = sdk.call_native_func(sceneManager, sceneManagerTypeDef, "get_CurrentScene")
	if not scene then
		return nil
	end

	local PlayerObj = scene:call("findGameObject(System.String)", selectedCharacter)
	if PlayerObj == nil then
		return nil
	end

	return PlayerObj:call("getComponent(System.Type)", sdk.typeof("via.physics.CharacterController"))
end

local function getPlayerTransform()
	local scene = sdk.call_native_func(sceneManager, sceneManagerTypeDef, "get_CurrentScene")
	if not scene then
		return nil
	end

	local PlayerObj = scene:call("findGameObject(System.String)", selectedCharacter)
	if PlayerObj == nil then
		return nil
	end

	return PlayerObj:call("getComponent(System.Type)", sdk.typeof("via.Transform"))
end

local function getPlayerEquipment()
	local scene = sdk.call_native_func(sceneManager, sceneManagerTypeDef, "get_CurrentScene")
	if not scene then
		return nil
	end

	return scene:call("findComponents(System.Type)", sdk.typeof("chainsaw.PlayerEquipment"))[0]
end

local function getGroundAdsorber()
	local scene = sdk.call_native_func(sceneManager, sceneManagerTypeDef, "get_CurrentScene")
	if not scene then
		return nil
	end

	local PlayerObj = scene:call("findGameObject(System.String)", selectedCharacter)
	if PlayerObj == nil then
		return nil
	end

	return PlayerObj:call("getComponent(System.Type)", sdk.typeof("chainsaw.GroundAdsorber"))
end

local function getInventoryManager()
	return sdk.get_managed_singleton('chainsaw.InventoryManager')
end

local function getCharacterManager()
	return sdk.get_managed_singleton('chainsaw.CharacterManager')
end

local function getPlayerManager()
	local CharacterManager = getCharacterManager()
	return CharacterManager:call('get_PlayerManager()')
end

local function getCharacterHitController()
	local scene = sdk.call_native_func(sceneManager, sceneManagerTypeDef, "get_CurrentScene")
	if not scene then
		return nil
	end

	local PlayerObj = scene:call("findGameObject(System.String)", selectedCharacter)
	if PlayerObj == nil then
		return nil
	end

	return PlayerObj:call("findComponents(System.Type)", sdk.typeof("chainsaw.HitController"))[0]
end

local function getInGameShopManager()
	return sdk.get_managed_singleton('chainsaw.InGameShopManager')
end

local function applyGodMode()
	local CharacterHitController = getCharacterHitController()

	if CharacterHitController == nil then
		return
	end

	CharacterHitController:call('set_AttackEnable(System.Boolean)', not godMode)
end

local function applyEntitySpeed()
	local CharacterManager = getCharacterManager()
	if CharacterManager == nil then
		return
	end

	CharacterManager:call('set_TimeScale(System.Single)', entitySpeed)
end

local function setPTAS(value)
	local InventoryManager = getInventoryManager()
	if InventoryManager == nil then
		return
	end

	InventoryManager:call("set_CurrPTAS(System.Int32)", value)
end

local function setSpinels(value)
	local InGameShopManager = getInGameShopManager()

	if InGameShopManager == nil then
		return
	end

	InGameShopManager:call('set_CurrSpinelCount(System.Int32)', value)
end

local function applyArmorDurability()
	if (not armorDurability) then
		return
	end

	local PlayerEquipment = getPlayerEquipment()

	if (PlayerEquipment == nil) then
		return
	end

	PlayerEquipment:call('useArmor(System.Int32)', -1000);
end

local function applyNoRecoil()
	for k, v in pairs(AWF.WeaponData) do
		AWF.WeaponData[k].SMG_Random = 0
		AWF.WeaponData[k].SMG_RandomFit = 0
		AWF.WeaponData[k].Focus_Limit = 0
		AWF.WeaponData[k].ReticleType = 203
		AWF.WeaponData[k].Changed = true
	end
end

local function applyUnlimitedAmmo()
	for k, v in pairs(AWF.WeaponData) do
		AWF.WeaponData[k].BaseAmmoCost = unlimitedAmmo and 0 or 1
		AWF.WeaponData[k].Changed = true
	end
end

local function applyDamageMultiplier()
	for k, v in pairs(AWF.WeaponData) do
		AWF.WeaponData[k].HG_BaseDMG = damageMultiplier
		AWF.WeaponData[k].HG_BaseBRK = damageMultiplier
		AWF.WeaponData[k].Changed = true
	end
end

local function hotkey(name)
	imgui.push_id(name)
	if not waiting_for_input_map[name] then
		if imgui.button("Bind Key") then
			waiting_for_input_map[name] = true
		end

		if key_bindings[name] ~= nil then
			imgui.same_line()
			if imgui.button("X") then
				key_bindings[name] = nil
			end

			imgui.same_line()
			imgui.text_colored("key: " .. tostring(key_bindings[name]), 0xFF00FF00)
		end
	else
		imgui.text_colored("Press a key to bind", 0xFF00FFFF)

		local key = reframework:get_first_key_down()
		if key ~= nil then
			key_bindings[name] = key
			waiting_for_input_map[name] = false
		end
	end
	imgui.pop_id()
end

re.on_config_save(function()
	--WIP
	configs.godMode = godMode
	configs.entitySpeed = entitySpeed
	configs.armorDurability = armorDurability
	configs.damageMultiplier = damageMultiplier
	configs.unlimitedAmmo = unlimitedAmmo
	configs.reloadSpeed = reloadSpeed
	configs.noRecoil = noRecoil
	configs.selectedCharacter = selectedCharacter
	configs.key_bindings = key_bindings
	configs.CountSpinels = CountSpinels
	configs.CountPTAS = CountPTAS
	configs.knifeDurability = knifeDurability
	configs.knifeSpeed = knifeSpeed
	configs.unlimitedHealth = unlimitedHealth
	configs.unlimitedItems = unlimitedItems

	json.dump_file('Cailu/Menu.json', configs)
end)

local function Testes()
	local scene = sdk.call_native_func(sceneManager, sceneManagerTypeDef, "get_CurrentScene")
	if not scene then
		return nil
	end

	local PlayerObj = scene:call("findGameObject(System.String)", selectedCharacter)
	if PlayerObj == nil then
		return nil
	end

	local PlayerEquipment = getPlayerEquipment()
	local CharacterManager = getCharacterManager()
	local HitController = getCharacterHitController()
	local InventoryManager = getInventoryManager()
	local WeaponItem = PlayerEquipment:call("getEquipWeaponItem()")
	local CsInventoryController = PlayerEquipment:call("get_InventoryController()");
	local CharacterManager = getCharacterManager()
	local PlayerManager = getPlayerManager()
	local GroundAdsorber = getGroundAdsorber()
	local PlayerBodyUpdater = getPlayerEquipment():call('get_PlayerBody')
	local PlayerBodyHitDriver = PlayerBodyUpdater:call('get_HitDriver');
	local InGameShopManager = getInGameShopManager()


	--[[
	chainsaw.PlayerEquipment
	chainsaw.CsInventoryController
	chainsaw.MapManager
	chainsaw.InGameShopManager
	chainsaw.HitManager

	chainsaw.CharacterBackup
	chainsaw.WeaponBehaviorTreeAction_Rapid
	chainsaw.KnifeGaugeControlGui

	chainsaw.CampaignManager.endCampaign()
]]
end

local function drawMenu()
	if not reframework:is_drawing_ui() then
		return
	end

	local onChange;
	if imgui.begin_window("Cailu's Menu") then
		imgui.set_next_item_width(150)
		onChange, CountPTAS = imgui.drag_int("PTAS", CountPTAS, 0, 9999999)
		if (onChange) then
			setPTAS(CountPTAS)
		end
		;
		onChange, godMode = imgui.checkbox("God Mode", godMode)
		if (onChange) then
			applyGodMode()
		end
		onChange, armorDurability = imgui.checkbox("Infinite Armor Durability", armorDurability)
		onChange, knifeDurability = imgui.checkbox("Infinite Knife Durability", knifeDurability)
		onChange, unlimitedHealth = imgui.checkbox("Unlimited Health", unlimitedHealth)
		imgui.set_next_item_width(150)
		onChange, reloadSpeed = imgui.slider_float("Reload Speed", reloadSpeed, 0.01, 10.0)
		imgui.set_next_item_width(150)
		onChange, entitySpeed = imgui.slider_float("Entity Speed", entitySpeed, 0.01, 20.0)
		onChange, noRecoil = imgui.checkbox("No Recoil", noRecoil)
		if (onChange) then
			applyNoRecoil()
		end
		imgui.set_next_item_width(150)
		onChange, CountSpinels = imgui.drag_int("Spinels", CountSpinels, 0, 9999)
		if (onChange) then
			setSpinels(CountSpinels)
		end
		;
		onChange, unlimitedAmmo = imgui.checkbox("Unlimited Ammo", unlimitedAmmo)
		if (onChange) then
			applyUnlimitedAmmo()
		end
		imgui.set_next_item_width(150)
		onChange, damageMultiplier = imgui.slider_float("Damage Multiplier", damageMultiplier, 0.01, 100.0)
		if (onChange) then
			applyDamageMultiplier()
		end
		onChange, unlimitedItems = imgui.checkbox("Unlimited Items", unlimitedItems)
		imgui.set_next_item_width(150)
		onChange, knifeSpeed = imgui.slider_float("Knife Speed", knifeSpeed, 0.01, 10.0)
	end

	-- imgui.set_next_item_width(1000)
	-- if(imgui.button("Teste")) then
	-- 	Testes()
	-- end
	imgui.spacing() --[[ Sometimes the tree node overflow the window, so we add a spacing to prevent it. ]]
end

local function loadConfig()
	local configData = json.load_file('Cailu/Menu.json')

	if (configData == nil) then
		return
	end

	configs = configData
	if (configs.key_bindings ~= nil) then
		key_bindings = configs.key_bindings
	end
	if (configs.prev_key_states ~= nil) then
		prev_key_states = configs.prev_key_states
	end
	if (configs.waiting_for_input_map ~= nil) then
		waiting_for_input_map = configs.waiting_for_input_map
	end

	if (configs.godMode ~= nil) then
		godMode = configs.godMode
	end

	if (configs.armorDurability ~= nil) then
		armorDurability = configs.armorDurability
	end

	if (configs.knifeDurability ~= nil) then
		knifeDurability = configs.knifeDurability
	end

	if (configs.unlimitedHealth ~= nil) then
		unlimitedHealth = configs.unlimitedHealth
	end

	if (configs.reloadSpeed ~= nil) then
		reloadSpeed = configs.reloadSpeed
	end

	if (configs.entitySpeed ~= nil) then
		entitySpeed = configs.entitySpeed
	end

	if (configs.noRecoil ~= nil) then
		noRecoil = configs.noRecoil
	end

	if (configs.unlimitedAmmo ~= nil) then
		unlimitedAmmo = configs.unlimitedAmmo
	end

	if (configs.damageMultiplier ~= nil) then
		damageMultiplier = configs.damageMultiplier
	end

	if (configs.unlimitedItems ~= nil) then
		unlimitedItems = configs.unlimitedItems
	end

	if (configs.knifeSpeed ~= nil) then
		knifeSpeed = configs.knifeSpeed
	end

	if (configs.CountPTAS ~= nil) then
		CountPTAS = configs.CountPTAS
	end

	if (configs.CountSpinels ~= nil) then
		CountSpinels = configs.CountSpinels
	end

	if (noRecoil) then
		applyNoRecoil()
	end

	if (CountPTAS > 0) then
		setPTAS(CountPTAS)
	end

	if (godMode) then
		applyGodMode()
	end

	if (CountSpinels > 0) then
		setSpinels(CountSpinels)
	end

	if (damageMultiplier > 1.0) then
		applyDamageMultiplier()
	end

	if (unlimitedAmmo) then
		applyUnlimitedAmmo()
	end
end

loadConfig()

re.on_frame(function()
	applyGodMode()
	applyArmorDurability()
	applyEntitySpeed()
	drawMenu()
end)

sdk.hook(sdk.find_type_definition("chainsaw.Melee"):get_method("getReducePoint"), nil, function(value)
	if (not knifeDurability) then
		return value
	end
end)

sdk.hook(sdk.find_type_definition("chainsaw.PlayerBodyHitDriver"):get_method("onCalculateDamage"), nil,
	function(damage, calculate)
		if (not unlimitedHealth) then
			return damage, calculate
		end
	end)

sdk.hook(sdk.find_type_definition("chainsaw.CsInventoryController"):get_method("useWeapon"), function(args)
	if (unlimitedItems) then
		return sdk.PreHookResult.SKIP_ORIGINAL
	end

	return sdk.PreHookResult.CALL_ORIGINAL
end, nil)

sdk.hook(
	sdk.find_type_definition("chainsaw.gui.inventory.CsInventory"):get_method(
		"operation(chainsaw.gui.inventory.ReduceItemCountOperation)"), function(args)
		if (unlimitedItems) then
			return sdk.PreHookResult.SKIP_ORIGINAL
		end

		return sdk.PreHookResult.CALL_ORIGINAL
	end, nil)

sdk.hook(sdk.find_type_definition("chainsaw.Gun"):get_method("get_ReloadSpeedRate"), nil, function(value)
	return sdk.float_to_ptr(reloadSpeed)
end)

sdk.hook(sdk.find_type_definition("chainsaw.Melee"):get_method("get_CombatSpeed"), nil, function(value)
	return sdk.float_to_ptr(knifeSpeed)
end)

sdk.hook(sdk.find_type_definition("chainsaw.CameraRecoilParam"):get_method("init"), function(args)
	if (noRecoil) then
		return sdk.PreHookResult.SKIP_ORIGINAL
	end

	return sdk.PreHookResult.CALL_ORIGINAL
end, nil)
