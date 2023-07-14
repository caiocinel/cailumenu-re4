local characterNames = {"Leon","Ashley","Luis"};
local characterObjName = {"ch0a0z0_body","ch0a1z0_body","ch0a2z0_body"};
local selectedCharacter = "ch0a0z0_body";
local disabledCollision = false;
local selectedCharacterIndex = 1;
local zStrength = 1.0;
local waiting_for_input_map = {}
local key_bindings = {}
local prev_key_states = {}

local configs = {
	zStrength = zStrength,
	selectedCharacterIndex = selectedCharacterIndex,
	disabledCollision = disabledCollision,
	selectedCharacter = selectedCharacter,
	key_bindings = key_bindings,
	prev_key_states = prev_key_states,
	waiting_for_input_map = waiting_for_input_map
}



local sceneManager = sdk.get_native_singleton("via.SceneManager")
if not sceneManager then 
	return end
	
local sceneManagerTypeDef = sdk.find_type_definition("via.SceneManager")


local function loadConfig()
	local configData = json.load_file('Cailu/WTW.json')

	if(configData == nil) then
		return
	end

	configs = configData
	if(configs.zStrength ~= nil) then
		zStrength = configs.zStrength
	end
	if(configs.selectedCharacterIndex ~= nil) then
		selectedCharacterIndex = configs.selectedCharacterIndex
	end
	if(configs.disabledCollision ~= nil) then
		disabledCollision = configs.disabledCollision
	end
	if(configs.selectedCharacter ~= nil) then
		selectedCharacter = configs.selectedCharacter
	end
	if(configs.key_bindings ~= nil) then
		key_bindings = configs.key_bindings
	end
	if(configs.prev_key_states ~= nil) then
		prev_key_states = configs.prev_key_states
	end
	if(configs.waiting_for_input_map ~= nil) then
		waiting_for_input_map = configs.waiting_for_input_map
	end
end

loadConfig()

local function isKeyDown(i)	
	if(i == null) then
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

local function applyNoCollisions()
	if(not disabledCollision) then
		return
	end

	local CharacterController = getCharacterController()
	local GroundAdsorber = getGroundAdsorber()

	if (CharacterController == nil) or (GroundAdsorber == nil) then
		return
	end

	CharacterController:call("set_Enabled(System.Boolean)", false);
	CharacterController:call("set_OverwritePosition(System.Boolean)", true)
	GroundAdsorber:call("set_Ground(System.Boolean)", true)	
end

local function fixPosition()
	local CharacterController = getCharacterController()

	if CharacterController == nil then
		return
	end

	CharacterController:call("warp")
end

local function applyCustomX(action, setX)
	local PlayerTransform = getPlayerTransform()

	if PlayerTransform == nil then
		return
	end

	local pos = PlayerTransform:call("get_Position");
	local rot = PlayerTransform:call("get_Rotation");
	
    local xMove = 0
    local zMove = 0

	if (action == 'left') then
		pos.x = pos.x - zStrength * math.cos(rot.w * math.pi)
		pos.z = pos.z + zStrength * math.sin(rot.y * math.pi)
	end
	
	if (action == 'right') then
		pos.x = pos.x + zStrength * math.cos(rot.w * math.pi)
		pos.z = pos.z - zStrength * math.sin(rot.y * math.pi)
	end
	

    pos.x = pos.x + xMove
    pos.z = pos.z + zMove

	if(setX ~= nil) then
		pos.x = setX
	end

	PlayerTransform:call("set_Position",pos)
end

local function applyCustomY(action, setY)
	local PlayerTransform = getPlayerTransform()

	if PlayerTransform == nil then
		return
	end

	local pos = PlayerTransform:call("get_Position");

	if(action == 'up') then
		pos.y = pos.y + zStrength
	end

	if(action == 'down') then
		pos.y = pos.y - zStrength
	end

	if(setY ~= nil) then
		pos.y = setY
	end

	PlayerTransform:call("set_Position",pos)
end

local function applyCustomZ(action)
	local PlayerTransform = getPlayerTransform()

	if PlayerTransform == nil then
		return
	end

	local pos = PlayerTransform:call("get_Position");
	local rot = PlayerTransform:call("get_Rotation");

	if(action == 'forward') then
        pos.z = pos.z - zStrength * math.cos(rot.w * math.pi)
        pos.x = pos.x - zStrength * math.sin(rot.y * math.pi)
    end

    if(action == 'back') then
        pos.z = pos.z + zStrength * math.cos(rot.w * math.pi)
        pos.x = pos.x + zStrength * math.sin(rot.y * math.pi)
    end

	PlayerTransform:call("set_Position",pos)
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
	configs.disabledCollision = disabledCollision
	configs.zStrength = zStrength
	configs.selectedCharacter = selectedCharacter
	configs.key_bindings = key_bindings
	configs.prev_key_states = prev_key_states
	configs.waiting_for_input_map = waiting_for_input_map
	configs.selectedCharacterIndex = selectedCharacterIndex
	json.dump_file('Cailu/WTW.json', configs)
end)

local function drawMenu()
	if not reframework:is_drawing_ui() then
		return
	end

	local onChange;
	if imgui.begin_window("Cailu's Walk Through Walls") then
		imgui.set_next_item_width(150)
		onChange, selectedCharacterIndex = imgui.combo("Character", selectedCharacterIndex, characterNames)
		if(onChange) then
			selectedCharacter = characterObjName[selectedCharacterIndex]
		end;
		imgui.separator();
		onChange, disabledCollision = imgui.checkbox("Disable Collisions", disabledCollision)	
		if(onChange) then
			fixPosition()
		end
		imgui.same_line()
		hotkey("walkThroughWalls")
		imgui.separator();
		if (imgui.button("Step Up")) then
			applyCustomY('up')
		end
		imgui.same_line();
		hotkey("goUp")
		if (imgui.button("Step Down")) then
			applyCustomY('down')
		end
		imgui.same_line();
		hotkey("goDown")		
		if(imgui.button("Step Left")) then
			applyCustomX('left')
		end
		imgui.same_line();
		hotkey("goLeft")
		if (imgui.button("Step Right")) then
			applyCustomX('right')
		end
		imgui.same_line();
		hotkey("goRight")
		if (imgui.button("Step Forward")) then
			applyCustomZ('forward')
		end
		imgui.same_line();
		hotkey("goForward")
		if (imgui.button("Step Back")) then
			applyCustomZ('back')
		end
		imgui.same_line();
		hotkey("goBack")

		imgui.set_next_item_width(150)
		onChange, zStrength = imgui.slider_float("Step Size", zStrength, 0.0, 10.0)
		imgui.separator();		
		if(imgui.button("Panic Button")) then
			disabledCollision = true;
			applyCustomY('none', 75)
		end
		imgui.same_line()
		imgui.text_colored("If you fall into limbo ;)", 0xFF00FFFF)
	end
	imgui.spacing() --[[ Sometimes the tree node overflow the window, so we add a spacing to prevent it. ]]
end


re.on_frame(function()
	if(key_bindings ~= nil) then
		if(isKeyDown(key_bindings['walkThroughWalls'])) then
			disabledCollision = not disabledCollision;
			fixPosition()
		end;

		if(isKeyDown(key_bindings['goUp'])) then
			applyCustomY('up')
		end;

		if(isKeyDown(key_bindings['goDown'])) then
			applyCustomY('down')
		end;

		if(isKeyDown(key_bindings['goLeft'])) then
			applyCustomX('left')
		end;

		if(isKeyDown(key_bindings['goRight'])) then
			applyCustomX('right')
		end;

		if(isKeyDown(key_bindings['goForward'])) then
			applyCustomZ('forward')
		end;

		if(isKeyDown(key_bindings['goBack'])) then
			applyCustomZ('back')
		end;

	end;

	applyNoCollisions()
	drawMenu()
end)
