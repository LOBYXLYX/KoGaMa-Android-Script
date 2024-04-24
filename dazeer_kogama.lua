-- LOBYX | Patito
Dmenu = 0


-- Dazeer Config
--local pl = require 'pl.import_into'()

-- others :
weapon_data_revert = ''
shotgun_damage_value = '200' -- float | If there are no results in Shotgun delete radius
impulse_gun_value = '3000' -- float
radius_weapon = '8.2;7' -- XZ/Y | float
radius_weapon_sleep = '7200' -- float
high_jump_value = '4' -- float
spawnweapon_sleep = '10000'
saved_player_coordinates = '???'
cube_radius_selection = 'REMOVING'
weapondamage_values = 'DAMAGE: ' -- revert
dialog_interval_coords = '300'
previous_profile_id = ''
token_profile_replace = '???'
original_profile_token = ''

radius_belowplayer = {bool = false}
radiussimple_disable_duration = {bool = false}
radiussimple_antilag = {bool = false}

-- menu's return :
is_main_menu_returned = true
is_accessorysetting_returned = false
is_giantavatar_returned = false
is_setcubesize_returned = false
is_sensivity_returned = false
--is_setteam_returned = false
is_infhealth_actived = false
is_maintainjump_actived = false
is_simpleradius_actived = false

-- ON/OF Hacks : (1=true, 2=false)
noclip_hack_actived = 2
rapidfire_weapons_actived = 2
cubegun_rapidremove_actived = 2
hitdamage_actived = 2
flyhack_actived = 2
swordrapifire_actived = 2
cubegunrapidfire_actived = 2
gamewalls_actived = 2

----------------------------------------

-- Accessories Size :
_accessory_size = '1' -- float
_offsetX = 'unknown value' -- float
_offsetY = 'unknown value' -- float
_offsetZ = '0' -- float

-- Giant Avatar :
player_effect_id = 'No Actived'
_giant_avatar_multiplier = '1' -- float
_giant_avatar_value = '1' -- float
maxAvatarSize = 9999999999

-- Weapon Sensivity :
_sensivityXZ_value = '0.20800000429' -- float
_sensivityY_value = '0.16699999571' -- float

-- Cube Gun Shape :
_cube_size = '1' -- float | X/Y/Z
_cube_offsetXZ = '1' -- float
_cube_rotation = '0'
_cube_shape_ID = '0'

-- Bazooka & Impulse gun :
_bazooka_range = 'increased_value'
_bazooka_bullet_speed = '30'
_bazooka_radius = '10'
_impulsegun_range = 'increased_value'
_impulsegun_radius = '1.2'
------------------------

function success(message, result_name, results, freeze_value, show_message)
	if show_message ~= true then
		gg.toast('SUCCESSFUL: '..message)
	end
	
    if results == nil then
    	return
   end
    
    local save_results = {}
    if freeze_value == nil then 
		freeze_value = false
	end
    
    for i, result in ipairs(results) do
        table.insert(save_results, {address=result.address, value=result.value, flags=result.flags, name=result_name, freeze=freeze_values})
    end
    gg.addListItems(save_results)
end

function notFoundError(result_name, change_value, type, _return, _get, radius_sleep, noimpulse, _duration, action_result, crumbly_radius, anti_lag_radius)
	local ggTYPE
	
   if type == 'float' then
   	ggTYPE = gg.TYPE_FLOAT
   elseif type == 'dword' then
   	ggTYPE = gg.TYPE_DWORD
   elseif type == 'word' then
   	ggTYPE = gg.TYPE_WORD
   else
   	print('Invalid search type')
   	return
   end

    local saved_results = gg.getListItems()
    local modifer_results = {}

    if #saved_results > 0 then
        for i, result in ipairs(saved_results) do
            if result.name == result_name then
                table.insert(modifer_results, {address=result.address, value=result.value, flags=ggTYPE})
            end
        end
    end
    
    if #modifer_results > 0 then
    	gg.clearResults()
    	gg.loadResults(modifer_results)
    	local results2 = gg.getResults('9999')
    	if _get == true then
    		return results2
    	end
    
    	if result_name == 'Avatar Radius' then
    		if noimpulse == true then
    			if checkSavedResults('Player moves') == false then
					PlayerMovesValue('...', '...', false, true)
				end
    		end
    
    		AvatarRadius(radius_sleep, _duration, crumbly_radius, noimpulse) -- maxRadius
    
    	elseif result_name == 'Avatar Radius second' or result_name == 'Avatar Radius third' then
    		--if noimpulse == true then
    		--	local issaved = isSavedResult('No second impulse', '3.4E38;1',  'float')
    		--	if issaved == false then
    		--		NoImpulsePlayerSecond()
    		--	end
    		--end
			if anti_lag_radius == true then
				if checkSavedResults('Anti Lag') then
					isSavedResult('Anti Lag', '9999', 'float')
				else
					AntiLagRadius()
					gg.sleep('500')
					isSavedResult('Anti Lag', '9999', 'float')
				end
				
				gg.clearResults()
				gg.loadResults(modifer_results)
				gg.getResults('100')
			end
    		
    		gg.editAll(change_value, ggTYPE)
    		if crumbly_radius == true then
    			PlayerEffect('24')
    			gg.clearResults()
    			gg.loadResults(modifer_results)
    			gg.getResults('999')
   		 end
   
    		if radius_sleep == nil then
				return
    		end
    
    		gg.sleep(radius_sleep)
    		if crumbly_radius == true then
    			if is_infhealth_actived == false then
					PlayerEffect('17')
				else
					PlayerEffect('24')
				end
   		 end
   
    		gg.editAll('0.45;0.95', ggTYPE)
    		if anti_lag_radius == true then
    			AntiLagRadius('desactive')
    		end
    		--isSavedResult('No second impulse', '1',  'float')
    
    	elseif result_name == 'Spawn weapon fr' then
    		gg.editAll(change_value, ggTYPE)
    		success('Spawned weapon, touch another weapon to activate (you have 10 seconds!)')
    		gg.sleep(spawnweapon_sleep)
    		gg.setValues(results2)
    	else
    		gg.editAll(change_value, ggTYPE)
    		if action_result == 'desactive' then
    			-- check if is freezed value
    			for i, mresult in ipairs(modifer_results) do
    				if mresult.freeze ~= nil then
    					mresult.freeze = nil
    				end
   			 end
    			gg.removeListItems(modifer_results)
    		end
    	end
    
    	gg.clearResults()
    	modifer_results = {}
    	success('Desactived or changed '..result_name)
    	return true
    end
    
    if _return == true then
    	return false
    end
    
    gg.toast('FAILED: No found results. Try again')
    gg.sleep(3000)
    Dazeer()
end

function isSavedResult(result_name, change_value, type, radius_sleep, action, crumbly_radius, anti_lag)
	local succs = notFoundError(result_name, change_value, type, true, false, radius_sleep, nil, nil, action, crumbly_radius, anti_lag)
	if succs ~= false then
		return true
	else
		return false
	end
end


function ReturnMain()
	return Dazeer()
	--local options = gg.choice({
	--	':: Back to menu ::',
	--	'> Exit'
	--},nil,nil)
	--if options == nil then else end
	--if options == 1 then Dazeer() end
	--if options == 2 then os.exit() end
end

function InfiniteHealthOptions()
	local function isSavedResultsWithValue(value_equal) -- search. values between
		local results = getSavedResults('INF Health', 'dword')
		
		gg.clearResults()
		gg.loadResults(results)
		gg.refineNumber(value_equal, gg.TYPE_DWORD)
		
		if gg.getResultsCount() >= 1 then
			return true
		end
		return false
	end
	
	local function SearchPlayerControllers()
		gg.clearResults()
		gg.setRanges(gg.REGION_ANONYMOUS)

		gg.searchNumber('100;100F;1;257,000~265,000', gg.TYPE_DWORD)
		gg.refineNumber('1', gg.TYPE_DWORD)
	
		if gg.getResultsCount() <= 0 then
			notFoundError()
		end

		local results = gg.getResults('300')
		success('...', 'Health no controllers', results, nil, true)
	end
		
	local options = gg.choice({
		'Desactive INF. Health',
		'Reactivate Player Controls',
		'Change INF. Health for Avatar Radius',
		'Change to Normal the INF. Health'
	},'idk',nil)
	
	if options == nil then return end
	if options == 1 then 
		isSavedResult('INF Health', '1', 'dword', nil, 'desactive') 
		is_infhealth_actived = false
	end
	if options == 2 then
		if checkSavedResults('Health no controllers') then
			-- Avoid getting a crash...
			local infh_results = getSavedResults('Health no controllers', 'dword')
			gg.clearResults()
			gg.loadResults(infh_results)
		
			gg.refineNumber('0', gg.TYPE_DWORD) -- only get results with value 0
			infh_results = gg.getResults('100')
			gg.editAll('1', gg.TYPE_DWORD)
		end
	end
	if options == 3 then
		if isSavedResultsWithValue('5~9') then
			if checkSavedResults('Health no controllers') == false then
				SearchPlayerControllers()
			end
			isSavedResult('INF Health', '0', 'dword')
		end
	end
	if options == 4 then
		if isSavedResultsWithValue('0~5') then
			isSavedResult('INF Health', '9', 'dword')
			InfiniteHealthOptions()
		end
	end
end

function InfiniteHealthType()
	local options = gg.choice({
		'INF. Health Normal',
		'INF. Health for Avatar Radius (activate after starting the game)'
	},'idk',"Select a INF. Health Type\n\nNote: If the hack doesn't work try restarting the game\nRecommended use INF. Health Normal")
	if options == nil then return end
	if options == 1 then InfiniteHealth_Normal() end
	if options == 2 then InfiniteHealthNoControls() end
end

function CubeRadiusTypeOptions()
	local options = gg.choice({
		'Adding Cubes',
		'Removing Cubes'
	},nil,'Select a Radius Cube Type')
	if options == nil then return end
	if options == 1 then
		cube_radius_selection = 'ADDING'
		Dazeer()
	end
	if options == 2 then
		cube_radius_selection = 'REMOVING'
		Dazeer()
	end
end

function ColorRandom(results_changed)
	-- 1: Red (scarletRed01)
    -- 2: Dark Red (scarletRed02)
    -- 3: Sand (chocolate00)
    -- 4: Light Purple Fabric (plum00)
    -- 5: Bright Blue (skyBlue00)
    -- 6: Blue (skyBlue01)
    -- 7: Dark Blue (skyBlue02)
    -- 8: Caramel (chocolate01)
    -- 9: Purple Fabric (plum01)
    -- 10: Bright Green (chameleon00)
    -- 11: Green (chameleon01)
    -- 12: Dark Green (chameleon02)
    -- 13: Ceramic (chocolate02)
    -- 14: Dark Purple Fabric (plum02)
    -- 15: Yellow (orange00)
    -- 16: Bright Orange (orange01)
    -- 17: Orange (orange02)
    -- 18: Butter (butter00)
    -- 19: Sandstone (butter01)
    -- 20: Light Concrete (aluminium00)
    -- 21: Concrete (aluminium01)
    -- 22: Dark Concrete (aluminium02)
    -- 23: Black Concrete (aluminium03)
    -- 24: Khaki (butter02)
    -- 25: Ice (funcIce00)
    -- 26: Lava (funcLava00)
    -- 27: Bouncy (funcBouncy00)
    -- 28: Poison (funcLava01)
    -- 29: Parkour (funcParkour00)
    -- 30: Bricks (brickwall00)
    -- 31: Bright Wood (wood01)
    -- 32: Cobblestone (pavement00)
    -- 33: Cement (concrete00)
    -- 34: Camouflage (cloth01)
    -- 35: Green Pavement (pavement02)
    -- 36: Ancient Cobblestone (pavement03)
    -- 37: Red Bricks (brickwall01)
    -- 38: Yellow Bricks (brickwall02)
    -- 39: Zigzag (aluminium04)
    -- 40: Metal Pattern (metal00)
    -- 41: Metal (metal01)
    -- 42: Mushroom (funcBouncy01)
    -- 43: Black Ice (funcIce01)
    -- 44: Pink Fabric (pink00)
    -- 45: Red Grid (grid00)
    -- 46: Green Grid (grid01)
    -- 47: Circuit (circuit00)
    -- 48: Grey Bricks (brickwall03)
    -- 49: Spotty (pattern01)
    -- 50: Metal Scraps (metal02)
    -- 51: Slime (funcSlime00)
    -- 52: Wrapping Paper (pattern02)
    -- 53: Dark Wood (wood02)
    -- 54: Super Bouncy (funcBouncy02)
    -- 55: Cloud (cloud00)
    -- 56: Soft Destructible (destructable02)
    -- 57: Medium Destructible (destructable01)
    -- 58: Hard Destructible (destructable00)
    -- 59: Cracked Ice (destruction03)
    -- 60: Striped Cement (StripedCement)
    -- 61: Machinery (Machinery)
    -- 62: Embossed Metal (EmbossedMetal)
    -- 63: Scrolling (Scrolling)
    -- 64: Kill (Kill)
    -- 65: Heal (Heal)
    -- 66: Slow (Slow)
    -- 67: Speed (Speed)
    -- 68: Crumble (Crumble)
    -- 69: END
    local is_showed_button = false
    --local color_idle_count = 0 -- avoid a ban due to multiple memory changes
    
    if is_showed_button == false then
		gg.showUiButton()
		is_showed_button = true
	end
    
	for i = 0, 69 do
		if gg.isClickedUiButton() then
        	gg.toast('Desactiving')
        	is_showed_button = false
        	break
        end
        
        --elseif color_idle_count == 10000 then
        --	is_showed_button = false
        --	break
        --end
        
		local ID = tostring(i)
		gg.editAll(ID, gg.TYPE_DWORD)
		--color_idle_count = color_idle_count + 1
		gg.sleep('100')
	end
	
	if is_showed_button == false then
		gg.hideUiButton()
    	gg.setVisible(false)
		return Dazeer()
	end
	--elseif color_idle_count == 10000 then
	--	return
	--end
	ColorRandom(results_changed)
end

function ShowMaterialCubeList()
	gg.alert('CUBE COLORS LIST:\n\n1: Red\n2: Dark Red\n3: Sand\n4: Light Purple Fabric\n5: Bright Blue\n6: Blue\n7: Dark Blue\n8: Caramel\n9: Purple Fabric\n10: Bright Green\n11: Green\n12: Dark Green\n13: Ceramic\n14: Dark Purple Fabric\n15: Yellow\n16: Bright Orange\n17: Orange\n18: Butter\n19: Sandstone\n20: Light Concrete\n21: Concrete\n22: Dark Concrete\n23: Black Concrete\n24: Khaki\n25: Ice\n26: Lava\n27: Bouncy\n28: Poison\n29: Parkour\n30: Bricks\n31: Bright Wood\n32: Cobblestone\n33: Cement\n34: Camouflage\n35: Green Pavement\n36: Ancient Cobblestone\n37: Red Bricks\n38: Yellow Bricks\n39: Zigzag\n40: Metal Pattern\n41: Metal\n42: Mushroom\n43: Black Ice\n44: Pink Fabric\n45: Red Grid\n46: Green Grid\n47: Circuit\n48: Grey Bricks\n49: Spotty\n50: Metal Scraps\n51: Slime\n52: Wrapping Paper\n53: Dark Wood\n54: Super Bouncy\n55: Cloud\n56: Soft Destructible\n57: Medium Destructible\n58: Hard Destructible\n59: Cracked Ice\n60: Striped Cement\n61: Machinery\n62: Embossed Metal\n63: Scrolling\n64: Kill\n65: Heal\n66: Slow\n67: Speed\n68: Crumble')
end

function ColorRandomFav(selected_colors)
	local is_showed_button = false
	if is_showed_button == false then
		gg.showUiButton()
		is_showed_button = true
	end
	
	for num, fav_ID in pairs(selected_colors) do
		if gg.isClickedUiButton() then
        	gg.toast('Desactiving')
        	is_showed_button = false
        	break
        end	
        
		gg.editAll(fav_ID, gg.TYPE_DWORD)
		gg.sleep('50')
		--print('changed '..fav_ID)
	end
	
	if is_showed_button == false then
		gg.hideUiButton()
    	gg.setVisible(false)
		return Dazeer()
	end
	
	ColorRandomFav(selected_colors)
end

function AvatarRadius(maxRadius, radius_duration, crumbly_radius, noimpulse)
	local results = gg.getResults('999')
	local function CrumblyBlocksAndLoadResult(results)
		PlayerEffect('24')
		gg.clearResults()
		gg.loadResults(results)
		return gg.getResults('10')
	end
	
	for i = 4, maxRadius do
		local XZsize = tostring(i)
		local Ysize = tostring(i - 3)
		
		if noimpulse == true then
			PlayerMovesValue('0', '...', false)
		end
		
		if crumbly_radius == true then
			CrumblyBlocksAndLoadResult(results)
		end
		
		gg.editAll(XZsize..';'..Ysize, gg.TYPE_FLOAT)
		gg.sleep(radius_duration)
		gg.editAll('0.45;0.95', gg.TYPE_FLOAT)
		gg.sleep(radius_duration)
		
		if noimpulse == true then
			PlayerMovesValue('1', '...', false)
		end
		
		if crumbly_radius == true then
			if is_infhealth_actived == true then
				PlayerEffect('25')
			else
				PlayerEffect('17')
			end
		end
	end
	gg.editAll('0.45;0.95', gg.TYPE_FLOAT)
end

function EditAndFreezeValues(result_name, type, value, desactive_freeze)
	local results = getSavedResults(result_name, type)
	if results == false then
		return false
	end
	
	for i, result in ipairs(results) do
		result.freeze = nil
		result.name = result_name
	end
	
	if desactive_freeze == true then
		gg.addListItems(results)
		return
	end
	
	gg.sleep('300')
	for i, result in ipairs(results) do
		result.freeze = true
		result.value = value
		result.name = result_name -- After this it will change to Var {address}
	end
	
	gg.addListItems(results)
	return true
end

function getSavedResults(result_name, type, getter_type)
	--local succs = notFoundError(result_name, change_value, type, true, true)
	--return succs
	
	local saved_results = gg.getListItems()
	local results = {}
	local ggTYPE
	
	if type == 'float' then
		ggTYPE = gg.TYPE_FLOAT
	elseif type == 'dword' then
		ggTYPE = gg.TYPE_DWORD
	else
		print('Invalid search type')
		return
	end
	
	for i, result in ipairs(saved_results) do
		if result.name == result_name and result.flags == ggTYPE then
			table.insert(results, {address=result.address, value=result.value, flags=ggTYPE})
		end
	end
	if #results <= 0 then
		return false
	end
	
	if getter_type == 2 then
		gg.clearResults()
		gg.loadResults(results)
		return gg.getResults('9999')
	end
	
	return results
end

function removeSavedResults(result_name, values, type, without_value)    
    local saved_results = gg.getListItems()
    local remove_results = {}
    local ggTYPE

	if type == 'float' then
		ggTYPE = gg.TYPE_FLOAT
	elseif type == 'dword' then
		ggTYPE = gg.TYPE_DWORD
	else
		print('Invalid search type')
		return
	end

    if #saved_results > 0 then
        for i, result in ipairs(saved_results) do
            if without_value ~= nil and without_value ~= false then
				if result.name == result_name and result.value ~= values then
                	table.insert(remove_results, {address=result.address, value=result.value, flags=ggTYPE})
            	end
            elseif without_value == true then
            	if result.name == result_name then
            		table.insert(remove_results, {address=result.address, value=result.value, flags=ggTYPE})
            	end
            end
        end
    end
    
    if #remove_results > 0 then
        gg.removeListItems(remove_results)
    end
end

function SearchCoordinates(results, results_count)
	local new_results = {}
	local coords_results_memory = {
		value43_to_float = 6.025583396596713E-44,
		value1_to_float = 1.401298464324817E-45,
		valueshit_to_float = 2.802596928649634E-45,
		zero_float = 0.0,
		minus_zero_float = -0.0,
		other_values = 0.75,
		other_values2 = 1.0,
		other_values3 = 0.7499998807907104,
		other_values4 = 0.15600000321865082
	}
	results_count = results_count or '9999'
	
	local function isValueInList(value)
        for _, list_value in pairs(coords_results_memory) do
        	print(value, list_value)
            if value == list_value then
                return true
            end
        end
        return false
    end
    
    for i, result in ipairs(results) do
    	if not isValueInList(result.value) then
    		table.insert(new_results, {address = result.address, value = result.value, flags = gg.TYPE_FLOAT})
		end
	end
	
	gg.clearResults()
	gg.loadResults(new_results)
	return gg.getResults(results_count)
end

function SearchWeaponFire(results)
    local weapons = {
        bazooka = 30,
        revolver = 500,
        centergun = 240,
        shotgun = 350,
        -- railgun = 60, my error
        shuriken_and_dual = 100,
        cubegun = 50,
        -- Range wepaons
        bazooka_and_centergun_range = 150,
        cubegun_range = 200,
        
    }
    local new_results = {}

    for i, result in ipairs(results) do
        for weapon, value in pairs(weapons) do
            if result.flags == gg.TYPE_FLOAT then
                if result.value == value then
                    table.insert(new_results, {address=result.address, value=result.value, flags=gg.TYPE_FLOAT})
                end
            end
        end
    end
    return new_results
end

function SearchWeaponAMMO(results, scan_ammo_type, get_float_results)
    local new_results = {}
    local ggTYPE = gg.TYPE_DWORD
    local weapons_memory_list = {
        weapons_base_ammo = 444444,
        cube_gun_dword = 65536,
        weapons_dword = 230887,
        one_float_dword = 1065353216,
        one_dword = 1,
        zero_dword = 0,
        other_minus_one = -1,
        other_weapon_dword = 4097,
        idk_this_shit = -2053
        -- float ammo
    }
    
    if get_float_results == true then
    	ggTYPE = gg.TYPE_FLOAT
    end

    local function isValueInList(value)
        for _, list_value in pairs(weapons_memory_list) do
            if value == list_value then
                return true
            end
        end
        return false
    end

    if scan_ammo_type == 'cube gun' then
		for i, result in ipairs(results) do
     	   if not isValueInList(result.value) and 
   	        (result.value < 2 or result.value > 29) and 
  	         (result.value < 31 or result.value > 68) then
     	       table.insert(new_results, {address = result.address, value = result.value, flags = gg.TYPE_DWORD})
	        end
 	   end
	else
		for i, result in ipairs(results) do
			if not isValueInList(result.value) then
				table.insert(new_results, {address = result.address, value = result.value, flags = ggTYPE})
			end
		end
	end

    gg.clearResults()
    gg.loadResults(new_results)
    return gg.getResults('9999')
end

-- last_cubegun_ammo = {}
-- changed_cubegun_ammo = {}

function isIncreasedCube(blocks_crumble, with_anti_lag, noimpulse)
	local is_showed_button = false
	local lastAmmo = {}
	
	-- show SX Button
	if is_showed_button == false then
		gg.showUiButton()
		is_showed_button = true
	end

    local results = gg.getResults('9999')
    for _, result in ipairs(results) do
        lastAmmo[result.address] = result.value
    end

    while true do
        local currentAmmo = {}
        results = gg.getResults('9999')
        for _, result in ipairs(results) do
            currentAmmo[result.address] = result.value
        end
        
        -- Compare current values with previous ones
        for address, value in pairs(currentAmmo) do
            if value > (lastAmmo[address] or 0) then
            	local idk = gg.getResults('100')
            	-- ANTI LAG :
            	if with_anti_lag == true then
            		isSavedResult('Anti Lag', '9999', 'float')
            	end
            	------------------
            	-- NO IMPULSE :
            	if noimpulse == true then
					PlayerMovesValue('0', '...', false)
				end
            	------------------
            
                isSavedResult('Avatar Radius second', radius_weapon, 'float', nil)
                if blocks_crumble == true then
            		PlayerEffect('24')
            	end
            	
            	gg.sleep(radius_weapon_sleep)
            	isSavedResult('Avatar Radius second', '0.45;0.95', 'float', nil)
            	if blocks_crumble == true then
            		if is_infhealth_actived == true then
						PlayerEffect('25')
					else
						PlayerEffect('17')
					end
            	end
            	
            	-- desactive ANTI LAG :
            	if with_anti_lag == true then
					AntiLagRadius('desactive')
				end
				---------------
				-- desactive NO IMPULSE :
				if noimpulse == true then
					PlayerMovesValue('1', '...', false)
				end
				------------------
                gg.loadResults(idk)
            end
        end
        
        lastAmmo = currentAmmo
        if gg.isClickedUiButton() then
        	gg.toast('Desactiving')
        	is_showed_button = false
        	break
        end
        
        gg.sleep(50)
    end
    
    if is_showed_button == false then
    	gg.hideUiButton()
    	gg.setVisible(false)
		Dazeer()
	end
end

function isDecreasedAmmoRadius(blocks_crumble, with_anti_lag, noimpulse)
	local is_showed_button = false
	local lastAmmo = {}
	
	-- show SX Button
	if is_showed_button == false then
		gg.showUiButton()
		is_showed_button = true
	end

    local results = gg.getResults('9999')
    for _, result in ipairs(results) do
        lastAmmo[result.address] = result.value
    end

    while true do
        local currentAmmo = {}
        results = gg.getResults('9999')
        for _, result in ipairs(results) do
            currentAmmo[result.address] = result.value
        end
        
        -- Compare current values with previous ones
        for address, value in pairs(currentAmmo) do
            if value < (lastAmmo[address] or 0) then
            	local idk = gg.getResults('100')
            	-- ANTI LAG :
            	if with_anti_lag == true then
            		isSavedResult('Anti Lag', '9999', 'float')
            	end
            	------------------
            	-- NO IMPULSE :
            	if noimpulse == true then
					PlayerMovesValue('0', '...', true)
				end
            	------------------	
            
            	isSavedResult('Avatar Radius second', radius_weapon, 'float', nil)
                if blocks_crumble == true then
            		PlayerEffect('24')
            	end
            	
            	gg.sleep(radius_weapon_sleep)
            	isSavedResult('Avatar Radius second', '0.45;0.95', 'float', nil)
            	if blocks_crumble == true then
            		if is_infhealth_actived == true then
						PlayerEffect('25')
					else
						PlayerEffect('17')
					end
            	end
            
            	-- desactive ANTI LAG :
            	if with_anti_lag == true then
					AntiLagRadius('desactive')
				end
				--------------
				-- desactive NO IMPULSE :
				if noimpulse == true then
					PlayerMovesValue('1', '...', true)
				end
				------------------
                gg.loadResults(idk)
            end
        end
        
        lastAmmo = currentAmmo
        if gg.isClickedUiButton() then
        	gg.toast('Desactiving')
        	is_showed_button = false
        	break
        end
        
        gg.sleep(50)
    end
    
    if is_showed_button == false then
    	gg.hideUiButton()
    	gg.setVisible(false)
		Dazeer()
	end
end

function checkSavedResults(result_name)
	local saved_results = gg.getListItems()
    local check = {}

    if #saved_results > 0 then
        for i, result in ipairs(saved_results) do
            if result.name == result_name then
                table.insert(check, {address=result.address, value=result.value, flags=result.flags})
            end
        end
    end
    
    if #check <= 0 then
    	return false
    else
    	return true
   end
end

function getSavedResultValue(result_name, type)
	local results = getSavedResults(result_name, type)
	if results ~= false then
		return results[1].value
	end
	return false
end

function refineBucle(amount, value, type)
	local ggTYPE
	
	if type == 'float' then
		ggTYPE = gg.TYPE_FLOAT
	elseif type == 'dword' then
		ggTYPE = gg.TYPE_DWORD
	else
		print('Invalid search type')
		return
	end
   
	for i = 0, amount do
		gg.refineNumber(value, ggTYPE)
		gg.sleep('190')
	end
end

function AdjustRadiusWeapon()
	local playerRadius = gg.prompt(
		{'X/Z Size', 'Y Size'}
	)
	
	
	--if XZsize or Ysize == nil then
		--return
	--end
	
	radius_weapon = playerRadius[1]..';'..playerRadius[2]
	print(radius_weapon)
	Dazeer()
end

function AdjustJumpHeight()
	high_jump_value = gg.prompt({'Height amount'})[1]
	local saved = isSavedResult('High Jump', 'float', high_jump_value)
	if saved ~= true then
		Dazeer()
	end
end
	
function AccessorySize()
	_accessory_size = gg.prompt({'Size'})[1]
	isSavedResult('Accessory Size', _accessory_size, 'float')
	AccessorySetOption()
end

function AccessoryOffsetX()
	_offsetX = gg.prompt({'Offset X'})[1]
	isSavedResult('Accessy Offset X', _offsetX, 'float')
	AccessorySetOption()
end

function AccessoryOffsetY()
	_offsetY = gg.prompt({'Offset Y'})[1]
	isSavedResult('Accessy Offset Y', _offsetY, 'float')
	AccessorySetOption()
end
	
function AccessoryOffsetZ()
	_offsetZ = gg.prompt({'Offset Z'})[1]
	isSavedResult('Accessy Offset Z', _offsetZ, 'float')
	AccessorySetOption()
end

function SetAvatarModifier()
	if player_effect_id == 'No Actived' then
		gg.toast('Active All Blocks Destructibles or Self Heal, first')
		return
	end
	
	gg.alert('AvatarModifierPackageType: \n\n0:  None\n1:  Fire\n2:  Mutant\n3:  Sticky\n4:  Poison\n5:  WallJump\n6:  InstantDeath\n7:  NoFriction\n8:  FlamerBurn\n9:  Underwater\n10:  Frozen\n11:  NinjaRun\n12:  Shrunken\n13:  WindFriction\n14:  DisableVehiclePickup\n15:  Enlarged\n16:  Shielded\n17:  SpawnProtection\n18:  RayHeal\n19:  TimeAttackFlagDebriefSlow\n20:  Lethal\n21:  HealingMat\n22:  SlowMat\n23:  SpeedMat\n24:  CrumbleMat\n25:  RayHealEnemy')
	player_effect_id = gg.prompt({'Modifier ID'})[1]
	if tonumber(player_effect_id) > 25 then
		player_effect_id = '25'
	end
	PlayerEffect(player_effect_id)
end

function SetGiantMultiplier()
	_giant_avatar_multiplier = gg.prompt({'Amount'})[1]
	_giant_avatar_multiplier = math.floor(_giant_avatar_multiplier * 6)
	
	if tonumber(_giant_avatar_multiplier) > maxAvatarSize then
		_giant_avatar_multiplier = tostring(maxAvatarSize)
	elseif tonumber(_giant_avatar_multiplier) <= 0 then
		_giant_avatar_multiplier = '6'
	end
	
	-- calculate hitbox and speed
	speed_subtracted = math.floor(_giant_avatar_multiplier / 2)
	hitbox_subtracted = tonumber(math.floor(_giant_avatar_multiplier / 2)) - 5.5
	if tonumber(speed_subtracted) < 6 then
		speed_subtracted = '8'
	end
	
	if hitbox_subtracted < 0.4 then
		hitbox_subtracted = '1'
	end
	
	EditAndFreezeValues('Giant avatar', 'float', _giant_avatar_multiplier)
	isSavedResult('Speed', speed_subtracted, 'float')
	isSavedResult('Avatar hitbox', tostring(hitbox_subtracted), 'float')
	
	PlayerOption()
end

function SetGiantNormalValue()
	_giant_avatar_value = gg.prompt({'Amount'})[1]
	if tonumber(_giant_avatar_value) > maxAvatarSize then
		_giant_avatar_value = tostring(maxAvatarSize)
	elseif tonumber(_giant_avatar_value) <= 0.01 then
		_giant_avatar_value = '0.01'
	end
	
	speed_subtracted = math.floor(_giant_avatar_value / 2)
	hitbox_subtracted = tonumber(math.floor(_giant_avatar_value / 2)) - 25.5
	if tonumber(speed_subtracted) < 6 then
		speed_subtracted = '8'
	end
	
	if hitbox_subtracted < 0.4 then
		hitbox_subtracted = '1'
	end
	print(speed_subtracted)
	print(hitbox_subtracted)
	EditAndFreezeValues('Giant avatar', 'float', _giant_avatar_value)
	isSavedResult('Speed', speed_subtracted, 'float')
	isSavedResult('Avatar hitbox', tostring(hitbox_subtracted), 'float')
	PlayerOption()
end

function SetSensivityXZ()
	_sensivityXZ_value = gg.prompt({'Sens X/Z value'})[1]
	isSavedResult('Sensivity XZ', _sensivityXZ_value, 'float')
	SensivityOption()
end

function SetSensivityY()
	_sensivityY_value = gg.prompt({'Sens Y value'})[1]
	isSavedResult('Sensivity Y', _sensivityY_value, 'float')
	SensivityOption()
end

function CubeSizeValueNormal()
	_cube_size = gg.prompt({'Size value'})[1]
	isSavedResult('Cube size', _cube_size, 'float')
	CubeGunShapeEditOption()
end
	
function CubeSizeXZ()
	_cube_offsetXZ = gg.prompt({'Size value X/Z'})[1]..';'.._cube_size
	isSavedResult('Cube size', _cube_offsetXZ, 'float')
	CubeGunShapeEditOption()
end
	
function CubeRotation()
	_cube_rotation = gg.prompt({'Rotation (max: 0.5, minimum: -0.5)'})[1]
	if tonumber(_cube_rotation) > 0.5 then
		_cube_rotation = '1'
	elseif tonumber(_cube_rotation) < -0.5 then
		_cube_rotation = '-1'
	end
	
	isSavedResult('Cube rotation', _cube_rotation, 'float')
	CubeGunShapeEditOption()
end

function BazookaRangeValue()
	_bazooka_range = gg.prompt({'Bazooka range value'})[1]
	isSavedResult('Bazooka Range', _bazooka_range, 'float')
	BazookaDamageRadiusOption()
end

function BazookaBulletSpeedValue()
	_bazooka_bullet_speed = gg.prompt({'Bazooka bullet speed value'})[1]
	if tonumber(_bazooka_bullet_speed) <= 20 then
		_bazooka_bullet_speed = '30'
	end
	
	isSavedResult('Bazooka Bullet Speed', _bazooka_bullet_speed, 'float')
	BazookaDamageRadiusOption()
end

function BazookaRadiusValue()
	_bazooka_radius = gg.prompt({'Bazooka radius value'})[1]
	isSavedResult('Bazooka Radius', _bazooka_radius, 'float')
	BazookaDamageRadiusOption()
end

function ImpulseGunRangeValue()
	_impulsegun_range = gg.prompt({'Impulse Gun range value'})[1]
	isSavedResult('Impulse Gun Range', _impulsegun_range, 'float')
	ImpulseGunRangeRadiusOption()
end

function ImpulseGunRadiusValue()
	_impulsegun_radius = gg.prompt({'Impulse Gun radius value'})[1]
	isSavedResult('Impulse Gun Radius', _impulsegun_range, 'float')
	ImpulseGunRangeRadiusOption()
end

function AdjustRadiusWeaponSleep()
	radius_weapon_sleep = gg.prompt({'Sleep amount (seconds) [3; 24]'}, {3}, {'number'})[1]..'000'
	Dazeer()
end

function AdjustWeaponSpawnSleep()
	spawnweapon_sleep = gg.prompt({'Sleep amount (seconds) [6; 120]'}, {8}, {'number'})[1]..'000'
	OtherWeaponSpawnOption()
end

function AdjustDialogViewerMicroSeconds()
	dialog_interval_coords = gg.prompt({'Set Dialog Interval in micro seconds (1000 = 1 second)'}, {500}, {'number'})[1]
	PlayerCoordsViewerOption()
end

function ProfileTokenChange()
	token_profile_replace = gg.prompt({'Token To Replace'}, {''}, {'text'})[1]
	isSavedResult('Profile token', token_profile_replace, 'word')
	ProfileTokenOption()
end

function ViewOriginalProfileToken()
	gg.prompt({'Your token'}, {original_profile_token}, {'text'})
	ProfileTokenOption()
end

function CustomResolutionValue()
	local values = gg.prompt({'Width', 'Height'}, {1366, 768}, {'number', 'number'})
	isSavedResult('Resul changer', values[1]..';'..values[2], 'float')
end

function CustomResolutionFloatSimple()
	local results = getSavedResults('Resul changer', 'float')
	local second_value = results[2].value
	local minimum_value = 2.0
	
	local value = gg.prompt({'Set Resulution Size (normal = 2.0)'}, {2.0}, {'number'})[1]
	-- multplier value
	if tonumber(value) < 0.1 then
		value = 0.2
	elseif tonumber(value) > 15 then
		value = 15
	end
	
	value = math.floor(second_value * tonumber(value) / 2)
	isSavedResult('Resul changer', value, 'float')
end
	
function TextToCopyPrompt(text)
	gg.prompt({'Text to copy'}, {text}, {'text'})
	PlayerCoordsViewerOption()
end

function SearchWeaponDamage(results)
    local new_results = {}
    local weapons_damage = {
        bazooka = 1000,
        centergun = 240,
        shotgun = 200,
        revolver = 150,
        shuriken_and_dual = 175
    }

    local function isValueInList(value)
        for _, list_value in pairs(weapons_damage) do
            if value == list_value then
                return true
            end
        end
        return false
    end
    

    for i, result in ipairs(results) do
        if not isValueInList(result.value) then
            table.insert(new_results, {address = result.address, value = result.value, flags = gg.TYPE_FLOAT})
        end
    end

    for _, result in ipairs(new_results) do
		if isValueInList(result.value) then
            weapondamage_values = weapondamage_values .. weapon .. ';'
        end
    end

    weapondamage_values = weapondamage_values:sub(1, -2)
    print('name '..weapondamage_values)

    if #new_results > 0 then
        gg.addListItems({address=new_results[1].address, value=new_results[1].value, name=weapondamage_values, flags=gg.TYPE_FLOAT})
        table.remove(new_results, 1)
    end

    gg.clearResults()
    gg.loadResults(new_results)
    return gg.getResults('9999')
end

function RandomShapeCube()
	local cube_shapes = {
		default = '1',
		small_cube = '0.25',
		texture_bug = '1;-1;1',
		texture_bug2 = '-1;1;-1',
		cube_plane = '1;0.25;1',
		cube_plane2 = '0.25;1;1',
		cube_plane3 = '1;0.1;0.1',
		small_cube2 = '0.25;0.25;0.5',
		cube_medium_small = '0.5'
	}
	local cube_size = getSavedResults('Cube size', 'float')
	local is_showed_button = false
	
	if is_showed_button == false then
		gg.showUiButton()
		is_showed_button = true
	end
	
	gg.clearResults()
	gg.loadResults(cube_size)
	gg.getResults('999')
	
	local function ShapeChanger()
		for shape_name, cube_form in pairs(cube_shapes) do
			if gg.isClickedUiButton() then
        		gg.toast('Desactiving')
        		is_showed_button = false
        		return
        	end
			gg.editAll(cube_form, gg.TYPE_FLOAT)
			gg.sleep('400')
		end
	end
	
	while true do
		ShapeChanger()
		
		if is_showed_button == false then
    		gg.hideUiButton()
    		gg.setVisible(false)
			Dazeer()
			break
		end
	end
end

function ChangeCubeShape()
	_cube_shape_ID = gg.prompt({'Shape ID (0 to 9)'})[1]
	if tonumber(_cube_shape_ID) > 9 then
		_cube_shape_ID = '9'
	elseif tonumber(_cube_shape_ID) <= -1 then
		_cube_shape_ID = '0'
	end
	
	local cube_shapes = {
		default = '1',
		small_cube = '0.25',
		texture_bug = '1;-1;1',
		texture_bug2 = '-1;1;-1',
		cube_plane = '1;0.25;1',
		cube_plane2 = '0.25;1;1',
		cube_plane3 = '1;0.1;0.1',
		small_cube2 = '0.25;0.25;0.5',
		cube_medium_small = '0.5'
	}
	
	local value_ID = cube_shapes[tonumber(_cube_shape_ID)]
	isSavedResult('Cube size', value_ID, 'float')
	CubeGunShapeEditOption()
end

function InfiniteHealthExecuteOption()
	if checkSavedResults('INF Health') then
		InfiniteHealthOptions()
	else
		InfiniteHealthType()
	end
end

function HealthPlayerSetID(interaction_id, message) -- I think there is no point in doing this.
	----- LIST FROM 0 TO 20 :
	-- 0: INF. Health + No controls
	-- 1: Normal
	-- 3: Freeze Animation + INF. Health
	-- 5: INF. Health + Invisibility 
	-- 9: INF. Health
	-- 17: INF. Health
	
	if checkSavedResults('INF Health') == false then
		gg.toast('Active "INF. Health" first')
		return
	end
	
	isSavedResult('INF Health', interaction_id, 'dword')
	gg.alert('SUCCESSFUL: Actived '..message..' Respawn again!')
end

function SaveNewPlayerPos()
	local pos = gg.prompt({'X Position', 'Y Position', 'Z Position'})
	saved_player_coordinates = pos[1]..';'..pos[2]..';'..pos[3]
end

function SimpleAvatarRadiusAdjust()
	local sradius = gg.prompt(
		{'Note: To desactivate the radius, select "Avatar Radius (simple)" again\n\nAnti Lag (Fast Remove)', 'No Radius Duration'}, 
		{false, false}, {'checkbox', 'checkbox'}
	)
	return sradius[1], sradius[2]
end

function CubeGunFavSelection()
	local found_text = false
	local exceeded = false
	local color_exceeded
	
	local function splitText(text)
		local text_parts = {}
		local for_comma = '([^,]+)'
		
		for x in string.gmatch(text, for_comma) do
			print(x)
    		table.insert(text_parts, x)
		end
		return text_parts
	end
	
	ShowMaterialCubeList()
	local fav_cube = gg.prompt({'Write with commas the cubes you want to select for rainbow. (0 to 69)\nExample:  60,64,65'})[1]	
	fav_cube = splitText(fav_cube)
	
	if fav_cube[2] == nil then
		gg.alert('You need to select more than 1 colors, you only selected one. "'..fav_cube[1]..'"')
	end
			
	
	-- check if the values ​​exceed the number 69, And verify that it is a number
	for _, fav_ID in pairs(fav_cube) do
		if tonumber(fav_ID) == nil then
			gg.alert('Must be a number. "'..fav_ID..'"')
			found_text = true
			break
		end
		
		if tonumber(fav_ID) > 69 then
			exceeded = true
			color_exceeded = fav_ID
			break
		end
	end
	
	if exceeded == true then
		gg.alert('Invalid color ID: '..color_exceeded)
		return
	elseif found_text == true then
		return
	end
	
	ColorRandomFav(fav_cube)
end
	
function BypassAmmoValueBan(results) -- soon
end

function isFreezedValues(result_name, type)
	local results = getSavedResults(result_name, type)
	local found_not_freezed = false
	
	for i, result in ipairs(results) do
		if result.freeze ~= nil then
			found_not_freezed = true
			break
		end
	end
	return found_not_freezed
end

function OptionHackActivation(hack_name_boolean, result_name, type, value_on, value_off)
	local results = getSavedResults(result_name, type)
	if results[1].value == value_on then
		hack_name_boolean = 1
	elseif results[1].value == value_off then
		hack_name_boolean = 2
	end
		
	local option = gg.choice({'𝘖𝘕','𝘖𝘍𝘍'},hack_name_boolean,'Hack Activation: '..result_name)
	if option == nil then ReturnMain() return end
	if option == 1 then
		hack_name_boolean = 1
		isSavedResult(result_name, value_on, type)
	end
	if option == 2 then
		hack_name_boolean = 2
		isSavedResult(result_name, value_off, type)
	end
end

function SecondOptionHackActivation(hack_name_boolean)
	local option = gg.choice({'𝘖𝘕','𝘖𝘍𝘍'},hack_name_boolean,'Activation')
	if option == nil then ReturnMain() return end
	if option == 1 then
		hack_name_boolean.bool = true
	end
	if option == 2 then
		hack_name_boolean.bool = false
	end
	return hack_name_boolean
end

function ShowCoordinatesInDialog()
	local coords_list = getSavedResults('Player coords', 'float', 2)
	local is_showed_button = false
	
	if is_showed_button == false then
		gg.showUiButton()
		is_showed_button = true
	end
	
	-- create coords variable
	local coordX = coords_list[1].value
	local coordY = coords_list[2].value
	local coordZ = coords_list[3].value
	
	gg.toast('\nCoord - X:  '..coordX..'\nCoord - Y:  '..coordY..'\nCoord - Z: '..coordZ)
	if gg.isClickedUiButton() then
        gg.toast('Returning')
        is_showed_button = false
        gg.hideUiButton()
        PlayerCoordsViewerOption()
        return
    end     
      
	gg.sleep(dialog_interval_coords)
	ShowCoordinatesInDialog()
end

-- Player Health: -0.00000582226;100D;100   type: float
-- Jetpack player mode: 100F;0D;1F;100;0~1   type: dword. refine 0~1


--##################################################################	

--function Dazeer()
--	local options = gg.choice({
--		':: [Player]',
--		':: [Logic - User]',
--		':: [Logic - Game]',
--		':: [Rapid-Fire Weapons]',
--		':: [Weapons - Crash]',
--		':: [CubeGun Options]',
--		':: [Ammunition]',
--		':: [Impulse Options]',
--		':: [Bazooka Options]',
--		':: [Spawn Weapons]',
--		':: [Animation Options]'
--	},'idk','    🌛 Cheats by ......')
--end

function Dazeer()
	is_main_menu_returned = true
	is_accessorysetting_returned = false
	is_giantavatar_returned = false
	is_sensivity_returned = false
	--is_setteam_returned = false
	is_setcubesize_returned = false
	
	local options = gg.choice({
		':: 𝘗𝘓𝘈𝘠𝘌𝘙 ::',
		':: 𝘞𝘌𝘈𝘗𝘖𝘕 ::',
		':: 𝘗𝘠𝘏𝘚  -  𝘓𝘖𝘎𝘐𝘊 ::',
		':: 𝘊𝘈𝘔𝘌𝘙𝘈 ::',
		':: 𝘕𝘗𝘊 (𝘈.𝘐.)  -  𝘝𝘌𝘏𝘐𝘊𝘓𝘌𝘚 ::',
		':: 𝘚𝘏𝘖𝘗 ::',
		':: 𝘖𝘛𝘏𝘌𝘙 ::'
	},'idk', '🚬. 𝓓𝓪𝔃𝓮𝓮𝓻')
	
	if options == nil then return end
	if options == 1 then PlayerOption() end
	if options == 2 then WeaponsOption() end
	if options == 3 then PhysLogicOption() end
	if options == 4 then CameraOption() end
	if options == 5 then NPCAIOption() end
	if options == 6 then ShopOption() end
	if options == 7 then OtherOption() end
end

function PlayerOption()
	local options = gg.multiChoice({
		'𝘈𝘷𝘢𝘵𝘢𝘳 𝘔𝘰𝘥𝘪𝘧𝘪𝘦𝘳',
		'𝘐𝘕𝘍. 𝘏𝘦𝘢𝘭𝘵𝘩',
		'𝘈𝘭𝘭 𝘉𝘭𝘰𝘤𝘬𝘴 𝘋𝘦𝘴𝘵𝘳𝘶𝘤𝘵𝘪𝘣𝘭𝘦',
		'𝘕𝘰 𝘍𝘢𝘭𝘭',
		'𝘈𝘷𝘢𝘵𝘢𝘳 𝘙𝘢𝘥𝘪𝘶𝘴',
		'𝘈𝘷𝘢𝘵𝘢𝘳 𝘙𝘢𝘥𝘪𝘶𝘴  (𝘴𝘪𝘮𝘱𝘭𝘦)',
		'𝘕𝘰𝘤𝘭𝘪𝘱',
		'𝘚𝘱𝘦𝘦𝘥 𝘉𝘰𝘰𝘴𝘵 𝘔𝘶𝘭𝘵𝘪𝘱𝘭𝘪𝘦𝘳' ,
		'𝘚𝘱𝘢𝘸𝘯 𝘗𝘳𝘰𝘵𝘦𝘤𝘵𝘪𝘰𝘯',
		'𝘍𝘳𝘦𝘦𝘻𝘦 𝘗𝘭𝘢𝘺𝘦𝘳𝘴 (𝘞𝘦𝘢𝘱𝘰𝘯)',
		'𝘚𝘦𝘭𝘧 𝘏𝘦𝘢𝘭 + 𝘈𝘭𝘭 𝘉𝘋',
		'[*]  𝘕𝘦𝘷𝘦𝘳 𝘊𝘳𝘶𝘴𝘩𝘦𝘥',
		'𝘎𝘪𝘢𝘯𝘵 𝘈𝘷𝘢𝘵𝘢𝘳 + 𝘔𝘶𝘭𝘵𝘪𝘱𝘭𝘪𝘦𝘳',
		'𝘕𝘰 𝘐𝘮𝘱𝘶𝘭𝘴𝘦',
		'𝘙𝘦𝘷𝘪𝘷𝘦 𝘔𝘰𝘥𝘦',
		'𝘐𝘯𝘷𝘪𝘴𝘪𝘣𝘪𝘭𝘪𝘵𝘺 (𝘷𝘪𝘴𝘪𝘣𝘭𝘦 𝘵𝘰 𝘰𝘵𝘩𝘦𝘳𝘴 𝘱𝘭𝘢𝘺𝘦𝘳𝘴)',
		'𝘈𝘯𝘵𝘪-𝘐𝘮𝘱𝘢𝘤𝘵',
		'[*]  𝘞𝘦𝘢𝘱𝘰𝘯𝘴 𝘞𝘪𝘵𝘩 𝘎𝘳𝘰𝘸𝘵𝘩',
		'𝘚𝘩𝘰𝘸 𝘌𝘯𝘦𝘮𝘺 𝘐𝘤𝘰𝘯 𝘛𝘩𝘳𝘰𝘶𝘨𝘩 𝘞𝘢𝘭𝘭𝘴 (𝘭𝘪𝘬𝘦 𝘌𝘚𝘗)',
		'𝘕𝘰 𝘌𝘲𝘶𝘪𝘱 𝘞𝘦𝘢𝘱𝘰𝘯𝘴',
		'𝘈𝘷𝘢𝘵𝘢𝘳 𝘏𝘪𝘵𝘣𝘰𝘹 - 𝘙𝘢𝘯𝘨𝘦',
		'𝘛𝘦𝘭𝘦𝘱𝘰𝘳𝘵',
		'𝘈𝘷𝘢𝘵𝘢𝘳 𝘈𝘯𝘪𝘮𝘢𝘵𝘪𝘰𝘯𝘴'
	})
	
	if options == nil then ReturnMain() return end
	if options[1] == true then AvatarModifierOption() end
	if options[2] == true then InfiniteHealthExecuteOption() end
	if options[3] == true then PlayerEffect('25') end
	if options[4] == true then NoFall() end
	if options[5] == true then RemoveCubegunsXYZ() end
	if options[6] == true then AvatarRadiusValuesOption() end
	if options[7] == true then NoclipV2() end
	if options[8] == true then SpeedPlayer() end
	if options[9] == true then PlayerEffect('17') end
	if options[10] == true then WeaponsCrashOption() end
	if options[11] == true then PlayerEffect('18') end
	if options[12] == true then NeverCrushed() end
	if options[13] == true then PlayerSizeAdvanced() end
	if options[14] == true then NoImpulsePlayer() end
	if options[15] == true then ReviveMode() end
	if options[16] == true then HealthPlayerSetID('5', 'Invisiblity') end
	if options[17] == true then AntiImpactPlayer() end
	if options[18] == true then WeaponsWithGrowth() end
	if options[19] == true then GameWallsInteraction('9999', 'Show Enemy Icon Through Walls', true) end
	if options[20] == true then NoEquipWeapons() end
	if options[21] == true then AvatarHitboxRange() end
	if options[22] == true then TeleportOption() end
	if options[23] == true then AnimationsOption() end
end

function PhysLogicOption()
	local options = gg.multiChoice({
  	  '𝘈𝘪𝘳𝘴 𝘑𝘶𝘮𝘱𝘴 - 𝘍𝘭𝘺',
  	  '𝘔𝘢𝘪𝘯𝘵𝘢𝘪𝘯 𝘑𝘶𝘮𝘱  (𝘶𝘴𝘦 𝘸𝘪𝘵𝘩 𝘈𝘪𝘳 𝘑𝘶𝘮𝘱𝘴 - 𝘍𝘭𝘺)',
  	  '𝘏𝘪𝘨𝘩 𝘑𝘶𝘮𝘱',
 	   '𝘍𝘭𝘺 𝘉𝘭𝘰𝘤𝘬 - 𝘎𝘳𝘢𝘷𝘪𝘵𝘺',
 	   '𝘈𝘶𝘵𝘰 𝘑𝘶𝘮𝘱',
 	   '𝘔𝘰𝘰𝘯 𝘑𝘶𝘮𝘱',
   	 '𝘞𝘰𝘳𝘭𝘥 𝘛𝘳𝘢𝘮𝘱𝘰𝘭𝘪𝘯𝘦',
   	 '𝘗𝘭𝘢𝘺𝘦𝘳 𝘊𝘰𝘰𝘳𝘥𝘴  (𝘦𝘹𝘱𝘦𝘳𝘪𝘮𝘦𝘯𝘵𝘢𝘭)'
	})
	if options == nil then ReturnMain() return end
	if options[1] == true then FlyJump() end
	if options[2] == true then PlayerMovesValue('1;0;1', 'Maintain Jump', true, nil, true) end
	if options[3] == true then HighJump() end
	if options[4] == true then FlyGravity() end
	if options[5] == true then AutoJump() end
	if options[6] == true then MoonJump() end
	if options[7] == true then SuperTrampoline() end
	if options[8] == true then ViewerPlayerCoordinates() end
end
	

function AvatarModifierOption()
	if player_effect_id == 'No Actived' then
		local playerEffects = getSavedResults('Player Effects (change to 0 to desactive it)', 'dword')
		if playerEffects ~= false then
			player_effect_id = playerEffects[1].value
		end
	end
	
	local options = gg.multiChoice({
		'𝘔𝘰𝘥𝘪𝘧𝘪𝘦𝘳 𝘐𝘋;  '..player_effect_id,
		'𝘈𝘶𝘵𝘰 𝘎𝘪𝘢𝘯𝘵 𝘈𝘷𝘢𝘵𝘢𝘳  (𝘎𝘳𝘰𝘸𝘵𝘩 𝘦𝘧𝘧𝘦𝘤𝘵)',
		'𝘈𝘶𝘵𝘰 𝘚𝘮𝘢𝘭𝘭 𝘈𝘷𝘢𝘵𝘢𝘳  (𝘔𝘰𝘶𝘴𝘦 𝘦𝘧𝘧𝘦𝘤𝘵)',
		'𝘚𝘩𝘪𝘦𝘭𝘥𝘦𝘥',
		'𝘐𝘤𝘦 𝘌𝘧𝘧𝘦𝘤𝘵',
		'𝘊𝘳𝘶𝘮𝘣𝘭𝘦𝘔𝘢𝘵'
	})
	if options == nil then ReturnMain() return end
	if options[1] == true then SetAvatarModifier() end
	if options[2] == true then PlayerEffect('15') end
	if options[3] == true then PlayerEffect('12') end
	if options[4] == true then PlayerEffect('16') end
	if options[5] == true then PlayerEffect('10') end
	if options[6] == true then PlayerEffect('24') end
end

function GiantAvatarOption()
	is_main_menu_returned = false
	is_giantavatar_returned = true
	
	local options = gg.multiChoice({
   	 '𝘔𝘶𝘭𝘵𝘪𝘱𝘭𝘪𝘦𝘳  (𝘮𝘪𝘯𝘪𝘮𝘶𝘮 = 1);  '.._giant_avatar_multiplier,
  	  '𝘚𝘪𝘻𝘦 𝘝𝘢𝘭𝘶𝘦  (𝘮𝘪𝘯𝘪𝘮𝘶𝘮 = 0.01);  '.._giant_avatar_value,
	}, nil, 'Press "Cancel" to return menu')
	if options == nil then ReturnMain() return end
	if options[1] == true then SetGiantMultiplier() end
	if options[2] == true then SetGiantNormalValue() end
end

function TeleportOption()
	local function ApplySavedPlayerPos()
		if saved_player_coordinates ~= '???' then
			isSavedResult('Player coords', saved_player_coordinates, 'float')
		else
			gg.toast('No saved player found')
		end
	end
	
	local function FreezeCoords()
		if checkSavedResults('Player coords') == false then
			gg.alert('Activate the teleport first. "Load"')
			TeleportOption()
			return
		else
			-- desactive :
			if isFreezedValues('Player coords', 'float') then
				EditAndFreezeValues('Player coords', 'float', nil, true)
				TeleportOption()
				return
			end
		end
		
		local results = getSavedResults('Player coords', 'float')
		for i, result in ipairs(results) do
			result.freeze = true
			result.name = 'Player coords'
		end
		
		gg.addListItems(results)
	end
	
	local options = gg.multiChoice({
   	 '𝘓𝘰𝘢𝘥',
   	 '𝘚𝘢𝘷𝘦 (𝘴𝘢𝘷𝘦 𝘯𝘦𝘸 𝘱𝘭𝘢𝘺𝘦𝘳 𝘱𝘰𝘴)',
  	  '𝘓𝘰𝘤𝘢𝘵𝘪𝘰𝘯 𝘗𝘳𝘦𝘴𝘦𝘵𝘴',
   	 '𝘈𝘱𝘱𝘭𝘺 𝘛𝘰 𝘚𝘱𝘢𝘸𝘯 𝘗𝘰𝘪𝘯𝘵  (𝘧𝘳𝘰𝘮 𝘴𝘢𝘷𝘦𝘥 𝘱𝘭𝘢𝘺𝘦𝘳 𝘱𝘰𝘴)',
   	 '𝘍𝘳𝘦𝘦𝘻𝘦 𝘊𝘰𝘰𝘳𝘥𝘴'
	})
	if options == nil then ReturnMain() return end
	if options[1] == true then MapTeleport() end
	if options[2] == true then SaveNewPlayerPos() end
	if options[3] == true then LocationPresetsOption() end
	if options[4] == true then ApplySavedPlayerPos() end
	if options[5] == true then FreezeCoords() end
end

function PlayerCoordsViewerOption()
	local coords_list = getSavedResults('Player coords', 'float', 2)
	if coords_list == false then
		gg.alert('Failed to show player coordinates')
		Dazeer()
		return
	end
	
	-- create coords variable
	local coordX = coords_list[1].value
	local coordY = coords_list[2].value
	local coordZ = coords_list[3].value
	
	local options = gg.choice({
		'𝘊𝘰𝘰𝘳𝘥 - 𝘟;  '..coordX,
		'𝘊𝘰𝘰𝘳𝘥 - 𝘠;  '..coordY,
		'𝘊𝘰𝘰𝘳𝘥 - 𝘡;  '..coordZ,
		'𝘜𝘱𝘥𝘢𝘵𝘦 𝘊𝘰𝘰𝘳𝘥𝘴',
		'𝘚𝘩𝘰𝘸 𝘪𝘯 𝘋𝘪𝘢𝘭𝘰𝘨 (𝘳𝘦𝘤𝘰𝘮𝘮𝘦𝘯𝘥𝘦𝘥)',
		'𝘋𝘪𝘢𝘭𝘰𝘨 𝘐𝘯𝘵𝘦𝘳𝘷𝘢𝘭 (𝘮𝘪𝘤𝘳𝘰 𝘴𝘦𝘤𝘰𝘯𝘥𝘴);  '..dialog_interval_coords
	},'idk','Coordinates Viewer')
	if options == 1 then TextToCopyPrompt(coordX) end
	if options == 2 then TextToCopyPrompt(coordY) end
	if options == 3 then TextToCopyPrompt(coordZ) end
	if options == 4 then PlayerCoordsViewerOption() end
	if options == 5 then
		gg.alert('To return to the menu press the "Sx" button')
		ShowCoordinatesInDialog()
	end
	if options == 6 then AdjustDialogViewerMicroSeconds() end
end
		
function AvatarRadiusValuesOption() -- simple
	local options_num = {}
	local radius_edit = {}
	local minimum_duration = '2800'
	
	-- check if the avatar radius is Actived
	if checkSavedResults('Avatar Radius second') then
		if is_simpleradius_actived == true then
			isSavedResult('Avatar Radius second', '0.45;0.95', 'float')
			is_simpleradius_actived = false
			gg.toast('Changed Avatar Radius')
			return
		end
	end
	
	for i = 5, 70, 5 do
		local radius_string = 'radius = '..tostring(i)..' : '..tostring(i / 2)
		local radius_edd = tostring(i)..';'..tostring(i / 2)
		
		table.insert(options_num, radius_string)
		table.insert(radius_edit, {radius=radius_edd})
	end

	
	-- others
	table.insert(options_num, 'Anti Radius Lag')
	table.insert(options_num, 'Disable Radius Duration')
	-- set avatar radius Pos Y | Type (17)
	table.insert(options_num, 'Remove blocks below the player')
	-- add Avatar Radius Auto : (18)
	table.insert(options_num, '[*]  Avatar Radius Auto')
	--print(radius_belowplayer, radiussimple_antilag, radiussimple_disable_duration)
	
	local options = gg.multiChoice(options_num,nil,'radius = XZ/Y  Size')
	--print(options)
	
	if options == nil then ReturnMain() return end
	for value, option in pairs(radius_edit) do
		for rnum, radius in pairs(options) do
			if rnum == value and options[rnum] == true then
				local max_radius_duration = tonumber(math.floor(minimum_duration * value * 2))
				if value > 5 then
					minimum_duration = tonumber(minimum_duration)
					minimum_duration = tostring(minimum_duration + 1500)
					
					max_radius_duration = math.floor(max_radius_duration * 2)
				end
				
				max_radius_duration = string.gsub(tostring(max_radius_duration), '%.0', '')
				print(max_radius_duration)
				RemoveCubegunsSimple(radius_edit[rnum]['radius'], max_radius_duration)
				
			elseif options[15] == true then
				SecondOptionHackActivation(radiussimple_disable_duration)
				return PlayerOption()				
			elseif options[16] == true then
				SecondOptionHackActivation(radiussimple_antilag)
				return PlayerOption()
			elseif options[17] == true then
				SecondOptionHackActivation(radius_belowplayer)
				return PlayerOption()
			elseif options[18] == true then AutoRemoveCubes() end
		end
	end
end

function AccessorySetOption()
	is_main_menu_returned = false
	is_accessorysetting_returned = true
	
	local options = gg.multiChoice({
    	'𝘚𝘪𝘻𝘦:  '.._accessory_size,
    	'𝘖𝘧𝘧𝘴𝘦𝘵 𝘟:  '.._offsetX,
   	 '𝘖𝘧𝘧𝘴𝘦𝘵 𝘠:  '.._offsetY,
  	  '𝘖𝘧𝘧𝘴𝘦𝘵 𝘡:  '.._offsetZ
	}, nil, 'Press "Cancel" to return menu')
	if options == nil then ReturnMain() return end
	if options[1] == true then AccessorySize() end
	if options[2] == true then AccessoryOffsetX() end
	if options[3] == true then AccessoryOffsetY() end
	if options[4] == true then AccessoryOffsetZ() end
end

function SetTeamOption()
	--is_main_menu_returned = false
	--is_setteam_returned = true
	
	local options = gg.multiChoice({
 	   '𝘉𝘭𝘶𝘦 𝘛𝘦𝘢𝘮  (𝘐𝘋: 0)',
    	'𝘠𝘦𝘭𝘭𝘰𝘸 𝘛𝘦𝘢𝘮  (𝘐𝘋: 3)',
  	  '𝘎𝘳𝘦𝘦𝘯 𝘛𝘦𝘢𝘮  (𝘐𝘋: 2)',
 	   '𝘞𝘩𝘪𝘵𝘦 𝘛𝘦𝘢𝘮  (𝘐𝘋: 5)'
	}, nil, 'Press "Cancel" to return menu')
	if options == nil then ReturnMain() return end
	if options[1] == true then isSavedResult('Player team', '0', 'dword') end
	if options[2] == true then isSavedResult('Player team', '3', 'dword') end
	if options[3] == true then isSavedResult('Player team', '2', 'dword') end
	if options[4] == true then isSavedResult('Player team', '5', 'dword') end
end

function LocationPresetsOption()
	-- instant teleport location :
	local playerstron19_flag = '-834.9609985;6.004750252;-1138.013428'
	local onlyup02_flag = '-266.8571;2011;-1493.8990'
	--------------
	
	local options = gg.choice({
		'>WAR 4<  (GameID: 2593313)',
		'cube gun 1011  (GameID: 2263148)',
		'cube gun :D :D3  (GameID: 879737)',
		'2 Player Tron 1.9  (GameID: 1243225) - Flag',
		'4 Players Parkour  (GameID: 1888173)',
		'Only Up [0.2]  (GameID: 10801809) - Flag',
		'WORLD RACING  (GameID: 191472)'
	},'idk','Game Locations')
	if options == nil then ReturnMain() return end
	if options == 1 then War4LocationsOption() end
	if options == 2 then cube1011LocationsOption() end
	if options == 3 then cubeDD3LocationsOption() end
	if options == 4 then CustomTeleport(playerstron19_flag, 'Flag') end
	if options == 5 then Players4ParkourLocationsOption() end
	if options == 6 then CustomTeleport(onlyup02_flag, 'Flag') end
	if options == 7 then WorldRacingLocationsOption() end
end

function War4LocationsOption()
	local secret_room1 = '-197.627594;650.5;44.04277802'
	local secret_room2 = '119.9238739;983;-212.5054779'
	local password_room = '168.953125;984;-174.0741272'
	
	local options = gg.multiChoice({
		'Secret Room 1',
		'Secret Room 2',
		'Password - 5835  use the Bazooka to Confirm'
	},nil,'>WAR 4< - Locations')
	if options == nil then LocationPresetsOption() return end
	if options[1] == true then CustomTeleport(secret_room1, 'Secret Room 1') end
	if options[2] == true then CustomTeleport(secret_room2, 'Secret Room 2') end
	if options[3] == true then CustomTeleport(password_room, 'Password - 5835  use the Bazooka to Confirm') end
end
	
function cube1011LocationsOption()
	local roof1 = '-29.93484306;47;-46.15624619'
	local roof2 = '-29.93484306;59;-46.15624619'
	local secret_room_roof = '-156.1627502;67;-140.1403046'
	local secret_room_checkpoint = '-172.0625;44.00099945;-152.4375'
	local secret_room_impulsegun = '-156.162674;48;-140.1444397'
	
	local options = gg.multiChoice({
		'Roof 1',
		'Roof 2',
		'Secret Room - Roof',
		'Secret Room - Checkpoint',
		'Secret Room - Impulse Gun'
	},nil,'cube gun 1011 - Locations')
	if options == nil then LocationPresetsOption() return end
	if options[1] == true then CustomTeleport(roof1, 'Roof 1') end
	if options[2] == true then CustomTeleport(roof2, 'Roof 2') end
	if options[3] == true then CustomTeleport(secret_room_roof, 'Secret Room - Roof') end
	if options[4] == true then CustomTeleport(secret_room_checkpoint, 'Secret Room - Checkpoint') end
	if options[5] == true then CustomTeleport(secret_room_impulsegun, 'Secret Room - Impulse Gun') end
end

function cubeDD3LocationsOption()
	local roof1 = '-30.1156559;18.5;-77.79825592'
	local roof2 = '-30.1156559;26.5;-77.79825592'
	local secret_room_roof = '7.81248951;30.5;-147.625'
	local secret_room_check = '7.8125;16.00099945;-147.625'
	local secret_parkour_beg = '6.339283466;485;437.1636047'
	local secret_parkour_check = '-1017.5;5.875999928;-54.9375'
	
	local options = gg.multiChoice({
		'Roof 1',
		'Roof 2',
		'Secret Room - Roof',
		'Secret Room - Checkpoint',
		'Secret Parkour - Beginning',
		'Secret Parkour - Checkpoint'
	},nil,'cube gun :D :D3 - Locations')
	if options == nil then LocationPresetsOption() return end
	if options[1] == true then CustomTeleport(roof1, 'Roof 1') end
	if options[2] == true then CustomTeleport(roof2, 'Roof 2') end
	if options[3] == true then CustomTeleport(secret_room_roof, 'Secret Room - Roof') end
	if options[4] == true then CustomTeleport(secret_room_check, 'Secret Room - Checkpoint') end
	if options[5] == true then CustomTeleport(secret_parkour_beg, 'Secret Parkour - Beginning') end
	if options[6] == true then CustomTeleport(secret_parkour_check, 'Secret Parkour - Checkpoint') end
end

function Players4ParkourLocationsOption()
	local flag1 = '39.87408066;930.038269;-3610.364746'
	local flag2 = '7.375603199;600;-100.4519196'
	
	local options = gg.multiChoice({
		'Flag',
		'Flag 2'
	},nil,'4 Players Parkour - Locations')
	if options == nil then LocationPresetsOption() return end
	if options[1] == true then CustomTeleport(flag1, 'Flag 1') end
	if options[2] == true then CustomTeleport(flag2, 'Flag 2') end
end

function WorldRacingLocationsOption()
	local flags = '1033.36218261;154;-4082.16601562'
	local Eiffel_tower_roof = '284;250;547.92022705'
	local room_cars = '1177.44458007;230;1855.53918457'
	
	local options = gg.multiChoice({
		'Flag',
		'Eiffel Tower - Roof',
		'Secret Room - Cars'
	},nil,'WORLD RACING - Locations')
	if options == nil then LocationPresetsOption() return end
	if options[1] == true then CustomTeleport(flags, 'Flag') end
	if options[2] == true then CustomTeleport(Eiffel_tower_roof, 'Eiffel Tower - Roof') end
	if options[3] == true then CustomTeleport(room_cars, 'Secret Room - Cars') end
end

function CameraOption()
	local options = gg.multiChoice({
  	  '𝘊𝘢𝘮𝘦𝘳𝘢 𝘍𝘖𝘝',
  	  '𝘍𝘳𝘦𝘦𝘻𝘦 𝘊𝘢𝘮𝘦𝘳𝘢 + 𝘗𝘭𝘢𝘺𝘦𝘳',
   	 '𝘡𝘰𝘰𝘮  (𝘶𝘴𝘦 𝘙𝘢𝘪𝘭 𝘎𝘶𝘯)',
  	  '𝘞𝘦𝘢𝘱𝘰𝘯 𝘊𝘢𝘮𝘦𝘳𝘢 𝘏𝘦𝘪𝘨𝘩𝘵',
  	  '𝘕𝘰 𝘊𝘢𝘮𝘦𝘳𝘢 𝘊𝘰𝘭𝘭𝘪𝘴𝘪𝘰𝘯',
  	  '𝘞𝘦𝘢𝘱𝘰𝘯 𝘚𝘦𝘯𝘴𝘪𝘷𝘪𝘵𝘺'
	})
	if options == nil then ReturnMain() return end
	if options[1] == true then Camera() end
	if options[2] == true then FreezeCamera() end
	if options[3] == true then ZoomCamera() end
	if options[4] == true then WPCameraHeight() end
	if options[5] == true then NoCameraCollision() end
	if options[6] == true then PlayerSensivity() end
end

function SensivityOption()
	is_main_menu_returned = false
	is_sensivity_returned = true
	
	local options = gg.multiChoice({
  	  '𝘚𝘦𝘯𝘴𝘪𝘷𝘪𝘵𝘺 Y;  '.._sensivityXZ_value,
  	  '𝘚𝘦𝘯𝘴𝘪𝘷𝘪𝘵𝘺 X/Z;  '.._sensivityY_value
	}, nil, 'Press "Cancel" to return menu')
	if options == nil then ReturnMain() return end
	if options[1] == true then SetSensivityXZ() end
	if options[2] == true then SetSensivityY() end
end

function BazookaDamageRadiusOption()
	local options = gg.multiChoice({
  	  '𝘙𝘢𝘥𝘪𝘶𝘴 (𝘯𝘰𝘳𝘮𝘢𝘭 = 10);  '.._bazooka_radius,
 	   '𝘙𝘢𝘯𝘨𝘦 (𝘯𝘰𝘳𝘮𝘢𝘭 = 150);  '.._bazooka_range,
 	   '𝘉𝘶𝘭𝘭𝘦𝘵 𝘚𝘱𝘦𝘦𝘥 (𝘯𝘰𝘳𝘮𝘢𝘭 = 30);  '.._bazooka_bullet_speed,
 	   '𝘋𝘦𝘴𝘢𝘤𝘵𝘪𝘷𝘦 𝘉𝘢𝘻𝘰??𝘬𝘢 - 𝘋𝘢𝘮𝘢𝘨𝘦'
	}, nil, 'Bazooka - Settings Damage')
	if options == nil then ReturnMain() return end
	if options[1] == true then BazookaRadiusValue() end
	if options[2] == true then BazookaRangeValue() end
	if options[3] == true then BazookaBulletSpeedValue() end
	if options[4] == true then
		isSavedResult('Bazooka Range', '150', 'float', nil, 'desactive')
		isSavedResult('Bazooka Bullet Speed', '30', 'float', nil, 'desactive')
		isSavedResult('Bazooka Radius', '10', 'float', nil, 'desactive')
		isSavedResult('Bazooka Damage Value', '1000', 'float', nil, 'desactive')
	end
end

function ImpulseGunRangeRadiusOption()
	local options = gg.multiChoice({
   	 '𝘙𝘢𝘯𝘨𝘦 (𝘯𝘰𝘳𝘮𝘢𝘭 = 25);  '.._impulsegun_range,
  	  '𝘙𝘢𝘥𝘪𝘶𝘴 (𝘯𝘰𝘳𝘮𝘢𝘭 = 1.2);  '.._impulsegun_radius,
  	  '𝘕𝘰 𝘐𝘮𝘱𝘶𝘭𝘴𝘦 𝘠𝘰𝘶𝘳𝘴𝘦𝘭𝘧',
  	  '𝘋𝘦𝘴𝘢𝘤𝘵𝘪𝘷𝘦 𝘐𝘮𝘱𝘶𝘭𝘴𝘦 𝘎𝘶𝘯 - 𝘙𝘢𝘯𝘨𝘦'
	}, nil, 'Impulse - Settings')
	if options == nil then ReturnMain() return end
	if options[1] == true then ImpulseGunRangeValue() end
	if options[2] == true then ImpulseGunRadiusValue() end
	if options[3] == true then isSavedResult('Impulse Gun Self Impulse', '0', 'float') end
	if options[4] == true then
		isSavedResult('Impulse Gun Range', '25', 'float', nil, 'desactive')
		isSavedResult('Impulse Gun Radius', '1.2', 'float', nil, 'desactive')
		isSavedResult('Impulse Gun Self Impulse', '1600', 'float', nil, 'desactive')
	end
end


function WeaponsOption()
    local options = gg.multiChoice({
    	'𝘐𝘕𝘍. 𝘈𝘮𝘮𝘰  (𝘈𝘓𝘓 𝘞𝘦𝘢𝘱𝘰𝘯𝘴)',
    	'𝘞𝘦𝘢𝘱𝘰𝘯 𝘚𝘱𝘢𝘸𝘯  (𝘴𝘪𝘮𝘱𝘭𝘦)',
   	 '𝘉𝘶𝘭𝘭𝘦𝘵  (𝘚𝘱𝘦𝘦𝘥,𝘙𝘢𝘯𝘨𝘦)',
  	  '𝘙𝘢𝘱𝘪𝘥 𝘍𝘪𝘳𝘦  (𝘰𝘵𝘩𝘦𝘳 𝘸𝘦𝘢𝘱𝘰𝘯𝘴)',
  	  '[*]  𝘏𝘪𝘵 𝘋𝘢𝘮𝘢𝘨𝘦',
   	 '𝘈𝘶𝘵𝘰 𝘍𝘪𝘳𝘦 - 𝘚𝘩𝘰𝘵𝘨𝘶𝘯',
   	 '𝘈𝘶𝘵𝘰 𝘍𝘪𝘳𝘦 - 𝘚𝘪𝘹-𝘚𝘩𝘰𝘰𝘵𝘦𝘳',
   	 '𝘈𝘶𝘵𝘰 𝘍𝘪𝘳𝘦 - 𝘋𝘰𝘶𝘣𝘭𝘦 𝘚𝘪𝘹-𝘚𝘩𝘰𝘰𝘵𝘦𝘳',
        '𝘈𝘶𝘵𝘰 𝘍𝘪𝘳𝘦 - 𝘉𝘢𝘻𝘰𝘰𝘬𝘢',
  	  '𝘉𝘢𝘻𝘰𝘰𝘬𝘢 - 𝘋𝘢𝘮𝘢𝘨𝘦',
   	 '𝘙𝘢𝘱𝘪𝘥 𝘍𝘪𝘳𝘦 - 𝘊𝘶𝘣𝘦 𝘎𝘶𝘯',
    	'𝘙𝘢𝘱𝘪𝘥 𝘙𝘦𝘮𝘰𝘷𝘦 - 𝘊𝘶𝘣𝘦 𝘎𝘶𝘯',
   	 '𝘙𝘢𝘱𝘪𝘥 𝘍𝘪𝘳𝘦 - 𝘙𝘢𝘪𝘭 𝘎𝘶𝘯',
   	 '𝘙𝘢𝘱𝘪𝘥 𝘍𝘪𝘳𝘦 - 𝘚𝘸𝘰𝘳𝘥',
  	  '𝘏𝘦𝘢𝘭 𝘙𝘢𝘺 - 𝘙𝘢𝘯𝘨𝘦',
   	 '𝘐𝘮𝘱𝘶𝘭𝘴𝘦 𝘎𝘶𝘯 - 𝘙𝘢𝘯𝘨𝘦',
   	 '𝘐𝘮𝘱𝘶𝘭𝘴𝘦 𝘎𝘶𝘯 - 𝘙𝘦𝘷𝘦𝘳𝘴𝘦 𝘐𝘮𝘱𝘶𝘭𝘴𝘦',
    	'𝘊𝘶𝘣𝘦 𝘎𝘶𝘯 - 𝘔𝘢𝘵𝘦𝘳𝘪𝘢𝘭 𝘊𝘩𝘢𝘯𝘨𝘦𝘳',
    	'𝘊𝘶𝘣𝘦 𝘎𝘶𝘯 - 𝘙𝘢𝘪𝘯𝘣𝘰𝘸 + 𝘍𝘢𝘷',
   	 '𝘊𝘶𝘣𝘦 𝘎𝘶𝘯 - 𝘙𝘢𝘥𝘪𝘶𝘴',
   	 '𝘊𝘶𝘣𝘦 𝘎𝘶𝘯 - 𝘚𝘩𝘢𝘱𝘦 𝘌𝘥𝘪𝘵  (𝘝𝘪𝘴𝘶𝘢𝘭)',
   	 '𝘚𝘩𝘰𝘵𝘨𝘶𝘯 - 𝘙𝘢𝘥𝘪𝘶𝘴'
	})
    if options == nil then ReturnMain() return end
    if options[1] == true then AmmunitionOption() end
    if options[2] == true then OtherWeaponSpawnOption() end
    if options[3] == true then SpeedWeapon() end
    if options[4] == true then RapidFireWeapons() end
    if options[5] == true then WeaponHitDamage() end
    if options[6] == true then AutoFireShotgun() end
    if options[7] == true then AutoFireSixShooter() end
    if options[8] == true then AutoFireDoubleSixShooter() end
    if options[9] == true then AutoFireBazooka() end
    if options[10] == true then BazookaDamageSettings() end
    if options[11] == true then CubeGunRapidFire() end
    if options[12] == true then CubegunDeleteSpeed() end
    if options[13] == true then RailGunRapidFire() end
    if options[14] == true then SwordRapidFire() end
    if options[15] == true then HealRayRange() end
    if options[16] == true then ImpulseRangeSettings() end
    if options[17] == true then ImpulseReverse() end
    if options[18] == true then CubegunChangeColor() end
    if options[19] == true then CubegunRandom() end
    if options[20] == true then MiniCubeGunRadius() end
    if options[21] == true then CubeGunShapeEdit() end
    if options[22] == true then MiniShotgunRadius() end
end


function DoubleSixShooterOption()
	local function ActiveAutoFire()
		local results = getSavedResults('Autofire doubleshooter', 'dword')
		for i, result in ipairs(results) do
			result.value = '1'
			result.freeze = true
			result.name = 'Autofire doubleshooter'
		end
		gg.addListItems(results)
	end
	
	local options = gg.multiChoice({
		'𝘈𝘶𝘵𝘰 𝘚𝘩𝘰𝘵 - 𝘚𝘪𝘹-𝘚𝘩𝘰𝘰𝘵𝘦𝘳',
		'𝘕𝘰 𝘙𝘦𝘤𝘰𝘪𝘭 - 𝘋𝘰𝘶𝘣𝘭𝘦 𝘚𝘪𝘹-𝘚𝘩𝘰𝘰𝘵𝘦𝘳',
		'𝘋𝘦𝘴𝘢𝘤𝘵𝘪𝘷𝘦 𝘈𝘶𝘵𝘰 𝘍𝘪𝘳𝘦 - 𝘋𝘰𝘶𝘣𝘭𝘦 𝘚𝘪𝘹-𝘚𝘩𝘰𝘰𝘵𝘦𝘳'
	})
	if options == nil then return end
	if options[1] == true then ActiveAutoFire() end
	if options[2] == true then isSavedResult('recoil doubleshooter', '0', 'float') end
	if options[3] == true then
		isSavedResult('recoil doubleshooter', '150', 'float', nil, 'desactive')
		isSavedResult('Auto fire doubleshooter', '0', 'dword', nil, 'desactive')
	end
end

function SixShooterOption()
	local function ActiveAutoFire()
		local results = getSavedResults('Autofire sixshooter', 'dword')
		for i, result in ipairs(results) do
			result.value = '1'
			result.freeze = true
			result.name = 'Autofire sixshooter'
		end
		gg.addListItems(results)
	end
	
	local options = gg.multiChoice({
		'𝘈𝘶𝘵𝘰 𝘚𝘩𝘰𝘵 - 𝘚𝘪𝘹-𝘚𝘩𝘰𝘰𝘵𝘦𝘳',
		'𝘕𝘰 𝘙??𝘤𝘰𝘪𝘭 - 𝘚𝘪𝘹-𝘚𝘩𝘰𝘰𝘵𝘦𝘳',
		'𝘋𝘦𝘴𝘢𝘤𝘵𝘪𝘷𝘦 𝘈𝘶𝘵𝘰 𝘍𝘪𝘳𝘦 - 𝘚𝘪𝘹-𝘚𝘩𝘰𝘰𝘵𝘦𝘳'
	})
	if options == nil then return end
	if options[1] == true then ActiveAutoFire() end
	if options[2] == true then isSavedResult('recoil sixshooter', '0', 'float') end
	if options[3] == true then
		isSavedResult('recoil sixshooter', '150', 'float', nil, 'desactive')
		isSavedResult('Auto fire sixshooter', '0', 'dword', nil, 'desactive')
	end
end

function CubeGunRainbowAndFavOption()
	local cube_results = getSavedResults('Cubegun random', 'dword')
	local function LoadResult(results)
		gg.clearResults()
		gg.loadResults(results)
		gg.getResults('9999')
	end
	
	local options = gg.multiChoice({
		'𝘔𝘢𝘵𝘦𝘳𝘪𝘢𝘭 𝘙𝘢𝘪𝘯𝘣𝘰𝘸',
		'𝘔𝘢𝘵𝘦𝘳𝘪𝘢𝘭 𝘍𝘢𝘷 (𝘴𝘦𝘭𝘦𝘤𝘵 𝘤𝘶𝘣𝘦𝘴 𝘢𝘴 𝘳𝘢𝘪𝘯𝘣𝘰𝘸)',
		'𝘋𝘦𝘴𝘢𝘤𝘵𝘪𝘷𝘦 𝘈𝘯𝘥 𝘙𝘦𝘢𝘤𝘵𝘪𝘷𝘢𝘵𝘦',
		'_𝘤𝘰𝘭𝘰𝘳𝘴_𝘭𝘪𝘴𝘵_'
	},nil,'Select an option')
	if options == nil then return end
	if options[1] == true then
		LoadResult(cube_results)
		ColorRandom(cube_results)
	end
	if options[2] == true then
		LoadResult(cube_results)
		CubeGunFavSelection()
	end
	if options[3] == true then
		isSavedResult('Cubegun random', '0', 'dword', nil, 'desactive')
		CubegunRandom()
	end
	if options[4] == true then
		ShowMaterialCubeList()
		CubeGunRainbowAndFavOption()
	end
end

function CubeGunShapeEditOption()
	is_main_menu_returned = false
	is_setcubesize_returned = true
	
	local options = gg.multiChoice({
		'𝘚𝘩𝘢𝘱𝘦 𝘐𝘋;  '.._cube_shape_ID,
   	 '𝘊𝘶𝘣𝘦 𝘚𝘪𝘻𝘦 (𝘯𝘰𝘳𝘮𝘢𝘭 = 1);  '.._cube_size,
 	   '𝘊𝘶𝘣𝘦 𝘖𝘧𝘧𝘴𝘦𝘵 𝘟/𝘡;  '.._cube_offsetXZ,
 	   '[*]  𝘊𝘶𝘣𝘦 𝘙𝘰𝘵𝘢𝘵𝘪𝘰𝘯 (??𝘰𝘳𝘮𝘢𝘭 = 0);  '.._cube_rotation,
 	   '𝘊𝘶𝘣𝘦 𝘐𝘯𝘷𝘪𝘴𝘪𝘣𝘪𝘭𝘪𝘵𝘺',
 	   '𝘊𝘶𝘣𝘦 𝘙𝘢𝘯𝘥𝘰𝘮 𝘚𝘩𝘢𝘱𝘦'
	}, nil, 'Press "Cancel" to return menu')
	if options == nil then ReturnMain() return end
	if options[1] == true then ChangeCubeShape() end
	if options[2] == true then CubeSizeValueNormal() end
	if options[3] == true then CubeSizeXZ() end
	if options[4] == true then CubeRotation() end
	if options[5] == true then isSavedResult('Cube down', '1', 'float') end
	if options[6] == true then RandomShapeCube() end
end

function ProfileTokenOption()
	local options = gg.multiChoice({
		'your original token:  [View_in_bytes]',
		'token_replace:  '..token_profile_replace,
		'Desactive Profile Token'
	},nil,'Profile Token Viewer\nNote: Activate this before the "Joined" comes out of the red cube')
	if options == nil then ReturnMain() return end
	if options[1] == true then ViewOriginalProfileToken() end
	if options[2] == true then ProfileTokenChange() end
	if options[3] == true then isSavedResult('Profile token', '0', 'dword', nil, 'desactive') end
end

function GameResolutionSettingOption()
	local function Change(resolution_value)
		isSavedResult('Resul changer', resolution_value, 'float')
	end
	
	local options = gg.multiChoice({
		'720×480 (SD)',
		'960×540 (qHD)',
		'1024×576',
		'1152×648',
		'1280×720 (HD)',
		'1366×768 (WXGA)',
		'1920×1080 (FHD)',
		'2560×1440 (QHD)',
		'3840×2160 (4K UHD)',
		'Custom Resolution',
		'Custom Resolution  (simple)'
	})
	if options == nil then ReturnMain() return end
	if options[1] == true then Change('720;480') end
	if options[2] == true then Change('960;540') end
	if options[3] == true then Change('1024;576') end
	if options[4] == true then Change('1152;648') end
	if options[5] == true then Change('1280;720') end
	if options[6] == true then Change('1366;768') end
	if options[7] == true then Change('1920;1080') end
	if options[8] == true then Change('2560;1440') end
	if options[9] == true then Change('3840;2160') end
	if options[10] == true then CustomResolutionValue() end
	if options[11] == true then CustomResolutionFloatSimple() end
end
	

function WeaponsCrashOption()
	local options = gg.multiChoice({
   	 '[*]  𝘐𝘮𝘱𝘶𝘭𝘴𝘦 𝘎𝘶𝘯 - 𝘐𝘮𝘱𝘶𝘭𝘴𝘦 𝘒𝘪𝘤𝘬',
 	   '𝘊𝘦𝘯𝘵𝘦𝘳 𝘎𝘶𝘯 - 𝘐𝘮𝘱𝘶𝘭𝘴𝘦 𝘒𝘪𝘤𝘬',
	    '𝘚𝘩𝘰𝘵𝘨𝘶𝘯 - 𝘐𝘮𝘱𝘶𝘭𝘴𝘦 𝘒𝘪𝘤𝘬',
  	  '𝘚𝘪𝘹𝘚𝘩𝘰𝘰𝘵𝘦𝘳 - 𝘐𝘮𝘱𝘶𝘭𝘴𝘦 𝘒𝘪𝘤𝘬',
  	  '𝘉𝘢𝘻𝘰𝘰𝘬𝘢 - 𝘐𝘮𝘱𝘶𝘭𝘴𝘦 𝘒𝘪𝘤𝘬'
	})
	if options == nil then ReturnMain() return end
	if options[1] == true then ImpulseCrash() end
	if options[2] == true then CentergunCrash() end
	if options[3] == true then ShotgunCrash() end
	if options[4] == true then RevolverCrash() end
	if options[5] == true then BazookaCrash() end
end

function OtherWeaponSpawnOption()
	local options = gg.multiChoice({
		'𝘚𝘦𝘭𝘦𝘤𝘵 𝘞𝘦𝘢𝘱𝘰𝘯-𝘖𝘱𝘵𝘪𝘰𝘯',
		'𝘚𝘱𝘢𝘸𝘯𝘞𝘦𝘢𝘱𝘰𝘯 𝘚𝘭𝘦𝘦𝘱;  '..spawnweapon_sleep
	})
	if options == nil then ReturnMain() return end
	if options[1] == true then WeaponSpawnOption() end
	if options[2] == true then AdjustWeaponSpawnSleep() end
end

function WeaponSpawnOption()
    local options = gg.multiChoice({
        '𝘚𝘱𝘢𝘸𝘯 𝘊𝘦𝘯𝘵𝘦𝘳𝘎𝘶𝘯',
        '𝘚𝘱𝘢𝘸𝘯 𝘐𝘮𝘱𝘶𝘭𝘴𝘦𝘎𝘶𝘯',
        '𝘚𝘱𝘢𝘸𝘯 𝘉𝘢𝘻𝘰𝘰𝘬𝘢',
        '𝘚𝘱𝘢𝘸𝘯 𝘏𝘢𝘯𝘥',
        '𝘚𝘱𝘢𝘸𝘯 𝘙𝘢𝘪𝘭𝘎𝘶??',
        '𝘚𝘱𝘢𝘸𝘯 𝘔𝘦??𝘦𝘦𝘞𝘦𝘢𝘱𝘰𝘯',
        '𝘚𝘱𝘢𝘸𝘯 𝘚𝘩𝘰𝘵𝘨𝘶𝘯',
        '𝘚𝘱𝘢??𝘯 𝘍𝘭𝘢𝘮𝘦𝘵𝘩𝘳𝘰𝘸𝘦𝘳',
        '𝘚𝘱𝘢𝘸𝘯 𝘊𝘶𝘣𝘦𝘎𝘶𝘯',
        '𝘚𝘱𝘢𝘸𝘯 𝘚𝘪𝘹𝘚𝘩𝘰𝘰𝘵??𝘳',
        '𝘚𝘱𝘢𝘸𝘯 𝘋𝘰𝘶𝘣𝘭𝘦𝘚𝘪??𝘚𝘩𝘰𝘰𝘵𝘦𝘳',
        '𝘚𝘱𝘢𝘸𝘯 𝘛𝘩𝘳𝘰𝘸𝘪𝘯𝘨𝘚𝘵𝘢𝘳',
        '𝘚𝘱𝘢𝘸𝘯 𝘔𝘶𝘭𝘵𝘪𝘛𝘩𝘳𝘰𝘸𝘪𝘯𝘨𝘚𝘵𝘢𝘳',
        '𝘚𝘱𝘢𝘸𝘯 𝘊??𝘴𝘵𝘶𝘮𝘦',
        '𝘚𝘱𝘢𝘸𝘯 𝘔𝘰𝘶𝘴𝘦𝘎𝘶𝘯',
        '𝘚𝘱𝘢𝘸𝘯 𝘎𝘳𝘰𝘸𝘵𝘩𝘎𝘶𝘯',
        '𝘚𝘱𝘢𝘸𝘯 𝘚𝘭𝘢𝘱𝘎𝘶𝘯',
        '𝘚𝘱𝘢𝘸𝘯 𝘏𝘦𝘢𝘭𝘙𝘢𝘺',
        '[*]  𝘚𝘱𝘢𝘸𝘯 𝘓𝘢𝘴𝘦𝘳𝘗𝘰𝘪𝘯𝘵𝘦𝘳',
        '𝘚𝘱𝘢𝘸𝘯 𝘏𝘦𝘢𝘭𝘵𝘩',
        '𝘚𝘱𝘢𝘸𝘯 𝘔𝘶𝘵𝘢𝘯𝘵',
        '𝘚𝘱𝘢𝘸𝘯 𝘕𝘪𝘯𝘫𝘢𝘙𝘶𝘯',
        '[*]  𝘚𝘱𝘢𝘸𝘯 ??𝘰𝘥𝘻𝘪𝘭????𝘓𝘢𝘴𝘦𝘳',
        '[*]  𝘚𝘱𝘢𝘸𝘯 𝘊𝘰𝘭𝘭𝘦𝘤𝘵𝘛𝘩𝘦𝘐𝘵𝘦𝘮𝘊𝘰𝘭𝘭𝘦𝘤𝘵𝘢𝘣𝘭𝘦',
        '[*]  𝘚𝘱𝘢𝘸𝘯 𝘔𝘰𝘶𝘴𝘦𝘗𝘢𝘤𝘬',
        '[*]  𝘚𝘱𝘢𝘸𝘯 𝘎𝘳𝘰𝘸𝘵𝘩𝘗𝘢𝘤𝘬'
    })

    if options == nil then ReturnMain() return end
    if options[1] == true then SpawnWeaponID('1') end
	if options[2] == true then SpawnWeaponID('2') end
	if options[3] == true then SpawnWeaponID('4') end
	if options[4] == true then SpawnWeaponID('5') end
	if options[5] == true then SpawnWeaponID('6') end
	if options[6] == true then SpawnWeaponID('8') end
	if options[7] == true then SpawnWeaponID('9') end
	if options[8] == true then SpawnWeaponID('10') end
	if options[9] == true then SpawnWeaponID('11') end
	if options[10] == true then SpawnWeaponID('12') end
	if options[11] == true then SpawnWeaponID('13') end
	if options[12] == true then SpawnWeaponID('45') end
	if options[13] == true then SpawnWeaponID('46') end
	if options[14] == true then SpawnWeaponID('59') end
	if options[15] == true then SpawnWeaponID('60') end
	if options[16] == true then SpawnWeaponID('62') end
	if options[17] == true then SpawnWeaponID('65') end
	if options[18] == true then SpawnWeaponID('70') end
	if options[19] == true then SpawnWeaponID('0') end
	if options[20] == true then SpawnWeaponID('70') end
	if options[21] == true then SpawnWeaponID('0') end
	if options[22] == true then SpawnWeaponID('3') end
	if options[23] == true then SpawnWeaponID('7') end
	if options[24] == true then SpawnWeaponID('14') end
	if options[25] == true then SpawnWeaponID('47') end
	if options[26] == true then SpawnWeaponID('61') end
	if options[27] == true then SpawnWeaponID('63') end
	if options[28] == true then SpawnWeaponID('64') end
end

function AnimationsOption()
	local options = gg.multiChoice({
    	'𝘍𝘳𝘦𝘦𝘻𝘦 𝘈𝘭𝘭 𝘈𝘯𝘪𝘮𝘢𝘵𝘪𝘰𝘯𝘴',
   	 '𝘍𝘳𝘦𝘦𝘻𝘦 𝘋𝘦𝘢𝘵𝘩 𝘈𝘯𝘪𝘮𝘢𝘵𝘪𝘰𝘯',
	    '𝘈𝘯𝘪𝘮𝘢𝘵𝘪𝘰𝘯 1  (jump)',
  	  '𝘈𝘯𝘪𝘮𝘢𝘵𝘪𝘰𝘯 2  (𝘫𝘦𝘵𝘱𝘢𝘤𝘬)',
  	  '𝘈𝘯𝘪𝘮𝘢𝘵𝘪𝘰𝘯 3  (𝘢𝘯𝘪𝘮𝘢𝘵𝘦𝘥 𝘢𝘳𝘮)'
	})
	if options == nil then ReturnMain() return end
	if options[1] == true then PlayerEffect('26') end
	if options[2] == true then DeathAnimation() end
	if options[3] == true then Animation_1() end
	if options[4] == true then JetpackAnimation() end
	if options[5] == true then Animation_3() end
end

function AmmunitionOption()
	local options = gg.multiChoice({
 	   '𝘊𝘶𝘣𝘦 𝘎𝘶𝘯 - 𝘐𝘕𝘍. 𝘈𝘮𝘮𝘰',
   	 '𝘉𝘢𝘻𝘰𝘰𝘬𝘢 - 𝘐𝘕𝘍. 𝘈𝘮𝘮𝘰',
 	   '𝘚𝘩𝘰𝘵𝘨𝘶𝘯 - 𝘐𝘕𝘍. 𝘈𝘮𝘮𝘰',
  	  '𝘊𝘦𝘯𝘵𝘦𝘳 𝘎𝘶𝘯 - 𝘐𝘕𝘍. 𝘈𝘮𝘮𝘰',
  	  '𝘍𝘭𝘢𝘮𝘦𝘵𝘩𝘳𝘰𝘸𝘦𝘳 - 𝘐𝘕𝘍. 𝘈𝘮𝘮𝘰',
  	  '𝘏𝘦𝘢𝘭 𝘙𝘢𝘺 - 𝘐𝘕𝘍. 𝘈𝘮𝘮𝘰',
  	  '𝘙𝘢𝘪𝘭 𝘎𝘶𝘯 - 𝘐𝘕𝘍. 𝘈𝘮𝘮𝘰',
  	  '𝘋𝘰𝘶𝘣𝘭𝘦 𝘚𝘪𝘹-𝘚𝘩𝘰𝘰𝘵𝘦𝘳 - 𝘐𝘕𝘍. 𝘈𝘮𝘮𝘰',
  	  '𝘚𝘪𝘹-𝘚𝘩𝘰𝘰𝘵𝘦𝘳 - 𝘐𝘕𝘍. 𝘈𝘮𝘮𝘰',
  	  '𝘔𝘰𝘶𝘴𝘦𝘎𝘶𝘯 - 𝘐𝘕𝘍. 𝘈𝘮𝘮𝘰',
		'𝘎𝘳𝘰𝘸𝘵𝘩𝘎𝘶𝘯 - 𝘐𝘕𝘍. 𝘈𝘮𝘮𝘰',
		'𝘔𝘶𝘭𝘵𝘪𝘛𝘩𝘳𝘰𝘸𝘪𝘯𝘨𝘚𝘵𝘢𝘳 - 𝘐𝘕𝘍. 𝘈𝘮𝘮𝘰',
		'𝘛𝘩𝘳𝘰𝘸𝘪𝘯𝘨𝘚𝘵𝘢𝘳 - 𝘐𝘕𝘍. 𝘈𝘮𝘮𝘰'
	})
	if options == nil then ReturnMain() return end
	if options[1] == true then CubegunAMMO() end
	if options[2] == true then BazookaAMMO() end
	if options[3] == true then ShotgunAMMO() end
	if options[4] == true then CentergunAMMO() end
	if options[5] == true then FlamethrowerAMMO() end
	if options[6] == true then HealRayAMMO() end
	if options[7] == true then RailGunAMMO() end
	if options[8] == true then DoubleSixShooterAMMO() end
	if options[9] == true then SixShooterAMMO() end
	if options[10] == true then MouseGunAMMO() end
	if options[11] == true then GrowthGunAMMO() end
	if options[12] == true then MultiThrowingStarAMMO() end
	if options[13] == true then ThrowingStarAMMO() end
end

function NPCAIOption()
	local options = gg.multiChoice({
		'𝘕𝘰 𝘖𝘤𝘶𝘭𝘶𝘴 𝘞𝘦𝘢𝘱𝘰𝘯',
		'𝘕𝘰 𝘖𝘤𝘶𝘭𝘶𝘴 𝘚𝘰𝘶𝘯𝘥',
		'𝘕𝘰 𝘖𝘤𝘶𝘭𝘶𝘴 𝘋𝘢𝘮𝘢𝘨𝘦',
		'𝘝𝘦𝘩𝘪𝘤𝘭𝘦 𝘊𝘢𝘮𝘦𝘳𝘢 - 𝘍𝘖𝘝',
		'𝘕𝘰 𝘐𝘤𝘦 𝘛𝘰𝘸𝘦𝘳',
		'𝘕𝘰 𝘍𝘪𝘳𝘦 𝘛𝘰𝘸𝘦𝘳',
		'𝘕𝘰 𝘛𝘰𝘸𝘦𝘳 𝘉𝘦𝘢𝘮',
		'𝘑𝘦𝘵𝘗𝘢𝘤𝘬 - 𝘕𝘰 𝘖𝘷𝘦𝘳𝘩𝘦𝘢𝘵',
		'𝘑𝘦𝘵𝘗𝘢𝘤𝘬 - 𝘚𝘱𝘦𝘦𝘥 𝘔𝘶𝘭𝘵𝘪𝘱𝘭𝘪𝘦𝘳'
	})
	if options == nil then ReturnMain() return end
	if options[1] == true then NoOculusWeapon() end
	if options[2] == true then NoOculusSoundEffect() end
	if options[3] == true then NoOculusDamage() end
	if options[4] == true then VehicleCameraFov() end
	if options[5] == true then NoIceTower() end
	if options[6] == true then NoFireTower() end
	if options[8] == true then InfiniteJetpack() end
	if options[9] == true then SpeedJetPack() end
end

function ShopOption()
	local options = gg.multiChoice({
		'[*]  𝘈𝘤𝘤𝘦𝘴𝘴𝘰𝘳𝘪𝘦𝘴 𝘚𝘪𝘻𝘦 (𝘝𝘪𝘴𝘶𝘢𝘭)',
		'𝘎𝘰𝘭𝘥 𝘔𝘰𝘥𝘪𝘧𝘪𝘦𝘳 (𝘝𝘪𝘴𝘶𝘢𝘭)'
	})
	if options == nil then ReturnMain() return end
	if options[1] == true then AccessorySettings() end
	if options[2] == true then GoldModifier() end
end

function GameGraphicsOption()
	local options = gg.multiChoice({
		'𝘙𝘦𝘮𝘰𝘷𝘦 𝘚𝘩𝘢𝘥𝘦𝘴',
		'𝘎𝘢𝘮𝘦 𝘊𝘩𝘶𝘯𝘬 - 𝘓𝘰𝘸 𝘋𝘪𝘴𝘵𝘢𝘯𝘤𝘦',
		'𝘎𝘢𝘮𝘦 𝘊𝘩𝘶𝘯𝘬 - 𝘏𝘪𝘨𝘩 𝘋𝘪𝘴𝘵𝘢𝘯𝘤𝘦'
	})
	if options == nil then ReturnMain() return end
	if options[1] == true then RemoveShade() end
	if options[2] == true then GameChunkDistance('Low') end
	if options[3] == true then GameChunkDistance('High') end
end

function OtherOption()
	local options = gg.multiChoice({
   	 '𝘚->𝘏𝘪𝘨𝘩_𝘑𝘶𝘮𝘱𝘏𝘦𝘪𝘨𝘩𝘵;  '..high_jump_value,
   	 '𝘚->𝘞𝘦𝘢𝘱𝘰𝘯_𝘙𝘢𝘥𝘪𝘶𝘴𝘚𝘭𝘦𝘦𝘱;  '..radius_weapon_sleep,
   	 '𝘛𝘦𝘢𝘮 𝘚𝘱𝘢𝘸𝘯',
   	 '𝘐𝘕𝘍. 𝘖𝘹𝘺𝘨𝘦𝘯',
   	 '𝘈𝘭𝘸𝘢𝘺𝘴 𝘚𝘸𝘪𝘮𝘮𝘪𝘯𝘨',
   	 '𝘊𝘶𝘣𝘦 𝘙𝘢𝘥𝘪𝘶𝘴 𝘛𝘺𝘱𝘦  (𝘧𝘰𝘳 𝘊𝘶𝘣𝘦 𝘊𝘶𝘯 - 𝘙𝘢??𝘪𝘶𝘴)',
   	 '𝘙𝘦𝘴𝘰𝘭𝘶𝘵𝘪𝘰𝘯 𝘊𝘩𝘢𝘯𝘨𝘦𝘳',
   	 '𝘚𝘮𝘰𝘰𝘵𝘩 𝘊𝘢𝘮',
   	 '𝘗𝘳𝘰𝘧𝘪𝘭𝘦 𝘐𝘋 + 𝘓𝘝𝘓 𝘜𝘱  (𝘝𝘪𝘴𝘶𝘢𝘭)',
    	'[*]  𝘗𝘳𝘰𝘧𝘪𝘭𝘦 𝘛𝘰𝘬𝘦𝘯',
		'𝘎𝘢𝘮𝘦 𝘎𝘳𝘢𝘱𝘩𝘪𝘤𝘴  (𝘈𝘯𝘥𝘳𝘰𝘪𝘥)',
		'𝘔𝘰𝘷𝘦𝘮𝘦𝘯𝘵𝘴 𝘚𝘱𝘦𝘦𝘥'
	})
	if options == nil then ReturnMain() return end
	if options[1] == true then AdjustJumpHeight() end
	if options[2] == true then AdjustRadiusWeaponSleep() end
	if options[3] == true then PlayerTeamSpawn() end
	if options[4] == true then InfiniteOxygen() end
	if options[5] == true then AlwaysSwimming() end
	if options[6] == true then CubeRadiusTypeOptions() end
	if options[7] == true then ResolutionChanger() end
	if options[8] == true then SmoothCamera() end
	if options[9] == true then ProfileID_LevelUp() end
	if options[10] == true then ProfileToken() end
	if options[11] == true then GameGraphicsOption() end
	if options[12] == true then AnimationSpeed() end
end

-- ##########################################################
-- sword weapon values: 0.30000001192F;0;4097
-- oculus other values: 5;1000;0.9;2.5
-- oculus sound:  0.103
-- oculus damage: 0.5;17;4

function ProfileToken()
	-- This hack is probably necessary. After kogama added tourists to the registered servers
	
	if checkSavedResults('Profile token') then
		ProfileTokenOption()
		return
	end
	
	-- pause KoGaMa App
	local tourist_token = '0.tjxgbEYSDy5MWYyj2ducSL0F8aA'
	gg.processPause()
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1,869,881,900;577,660,267;100~32,000W::52', gg.TYPE_DWORD)
	gg.refineNumber('100~32,000', gg.TYPE_WORD)
	
	-- play 
	gg.processResume()
	
	if gg.getResultsCount() <= 0 then
		gg.toast('No found results. The game must be paused before "Joined"')
		return
	end
	
	local results = gg.getResults('200')
	gg.editAll(tourist_token, gg.TYPE_WORD)
	token_profile_replace = tourist_token
	
	for lp, token_result in ipairs(results) do
		token_result.value = token_result.value .. original_profile_token
	end
	
	success('Obtained Account Token', 'Profile token', results)
	ProfileTokenOption()
end

function ProfileID_LevelUp()
	-- search format:  -1;level;profile_id;259,000~262,000;-3780~-3700;1
	local level_value = '45'
	local profile_changer = '40000000'
	
	if checkSavedResults('Level value') or checkSavedResults('Profile value') then
		if previous_profile_id == '' then
			previous_profile_id = '1'
		end
		
		isSavedResult('Level value', '1', 'dword', nil, 'desactive')
		isSavedResult('Profile value', previous_profile_id, 'dword', nil, 'desactive')
		return
	end
	
	local function LoadResult(results, save_name, refined_results)
		success('Activing..', save_name, refined_results)
		gg.sleep('100')
		gg.clearResults()
		gg.loadResults(results)
		gg.getResults('10')
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('-1;1~45;100,000~1,147,000;259,000~262,000;-3780~-3700;1', gg.TYPE_DWORD)
	local primary_results = gg.getResults('100')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	-- level value
	gg.refineNumber('1~45', gg.TYPE_DWORD)
	local results1 = gg.getResults('5')
	gg.editAll(level_value, gg.TYPE_DWORD)
	LoadResult(primary_results, 'Level value', results1)
	
	-- profile id
	gg.refineNumber('100,000~1,147,000', gg.TYPE_DWORD)
	local results2 = gg.getResults('2')
	previous_profile_id = results2[1].value
	gg.editAll(profile_changer, gg.TYPE_DWORD)
	LoadResult(primary_results, 'Profile value', results2)
	
	gg.clearResults()
	gg.toast('Actived Profle ID + Level Up')
end

function NoOculusDamage()
	local saved = isSavedResult('Oculus damage', '0.5;17;4', 'float', nil, 'desactive')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.00999999978;0.5;17;4;17', gg.TYPE_FLOAT)
	gg.refineNumber('0.00999999978;0.5;4', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('1000')
	gg.editAll('100', gg.TYPE_FLOAT)
	success('Actived No Oculus Damage', 'Oculus damage', results)
end

function GameChunkDistance(value_type)
	local value_group_chunk
	if value_type == 'Low' then
		value_group_chunk = '0.5;10;40;70;100;200;320'
	else -- High
		value_group_chunk = '25000'
	end
		
	local saved = isSavedResult('chunk distance', value_group_chunk, 'float')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.33333334327;2.5;25;75~1500::', gg.TYPE_FLOAT)
	gg.refineNumber('2~1500', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('500')
	gg.editAll(value_group_chunk, gg.TYPE_FLOAT)
	success('Actived Chunk Distance '..value_type, 'chunk distance', results)
end

function AntiImpactPlayer()
	local saved = isSavedResult('Anti impact', '55', 'float', nil, 'desactive')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('-1;55;4::15', gg.TYPE_FLOAT)
	gg.refineNumber('55', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('100')
	gg.editAll('10000', gg.TYPE_DWORD)
	success('Actived Anti-Impact', 'Anti impact', results)
end

function NoOculusSoundEffect()
	local saved = isSavedResult('Oculus sound', '0.103', 'float', nil, 'desactive')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('5;0.103', gg.TYPE_FLOAT)
	refineBucle(4, '0.103', 'float')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('1000')
	gg.editAll('0', gg.TYPE_FLOAT)
	success('Actived No Oculus Sound', 'Oculus sound', results)
end

function NoOculusWeapon()
	local saved = isSavedResult('Oculus weapon', '1', 'dword', nil, 'desactive')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('8.5F;2F;1F;1F;1;2:200', gg.TYPE_DWORD)
	gg.refineNumber('1', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('1000')
	gg.editAll('0', gg.TYPE_DWORD)
	success('Actived No Oculus Weapon', 'Oculus weapon', results)
end

function VehicleCameraFov()
	local value = gg.prompt(
 		{'Camera Amount [4; 80]'},
	 	{7}, {'number'}
	)
	
	local saved = isSavedResult('Vehicle fov', value[1], 'float')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('7;40;-1::100', gg.TYPE_FLOAT)
	gg.refineNumber('7', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('500')
	gg.editAll(value[1], gg.TYPE_FLOAT)
	success('Actived Vehicle Camera Fov', 'Vehicle fov', results)
end

function AlwaysSwimming()
	local saved = isSavedResult('always swim', '0.6', 'float', nil, 'desactive')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('10;4;0.6::', gg.TYPE_FLOAT)
	gg.refineNumber('0.6', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('30')
	gg.editAll('0', gg.TYPE_FLOAT)
	success('Actived Always Swimming', 'always swim', results)
end

function ResolutionChanger()
	local pw = checkSavedResults('Resul changer')
	if pw == true then
		GameResolutionSettingOption()
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1D;100;1;1000~3000;96::60', gg.TYPE_FLOAT)
	gg.refineNumber('1000~3000', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('60')
	success('Obtained Resolution Value', 'Resul changer', results)
	GameResolutionSettingOption()
end

function InfiniteOxygen()
	local saved = isSavedResult('INF Oxygen', '20', 'float', nil, 'desactive')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('258,000~265,000D;1;20;20::100', gg.TYPE_FLOAT)
	gg.refineNumber('20', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('100')
	gg.editAll('3.4E38', gg.TYPE_FLOAT)
	success('Actived INF. Oxygen', 'INF Oxygen', results)
end

function AnimationSpeed()
	local speed_value = gg.prompt({'Speed (1 = normal, 0 = super slow)'}, {1}, {'number'})
	if tonumber(speed_value[1]) < 0 then
		speed_value = {'0'}
	end
	
	local saved = isSavedResult('Animation speed', speed_value[1], 'float')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('5;90;45;1::120', gg.TYPE_FLOAT)
	gg.refineNumber('1', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('100')
	gg.editAll(speed_value[1], gg.TYPE_FLOAT)
	success('Actived Animation Speed', 'Animation speed', results)
end
	

function ViewerPlayerCoordinates()
	if checkSavedResults('Player coords') then
		local saved_results = getSavedResults('Player coords', 'float')
		local function getRealCoords(saved_results)
			gg.clearResults()
			gg.loadResults(saved_results)
			local cresults = gg.getResults('3')
			
			gg.removeListItems(saved_results)
			gg.sleep('500')
			success('...', 'Player coords', cresults, nil, true)
		end
		
		
		PlayerCoordsViewerOption()
		return
	end
		
	gg.clearResults()	
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber('0.156;0.75;0.74999988079;0.74999988079;-3000~3000::55', gg.TYPE_FLOAT)
    
    if gg.getResultsCount() <= 0 then
		notFoundError('Player coords', '0', 'float')
		return
	end
	
    local results = gg.getResults('999')
    results =  SearchCoordinates(results, '3') -- get 3 results
    success('...', 'Player coords', results, nil, true)
    PlayerCoordsViewerOption()
end
    

function GameWallsInteraction(value, func_name, show_message)
	if checkSavedResults('Game walls') then
		OptionHackActivation(gamewalls_actived, 'Game walls', 'float', value, '1')
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1;4;8;14:180',gg.TYPE_FLOAT)
	refineBucle(5, '1', 'float')
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Game walls', value, 'float')
		return
	end
	
	local results = gg.getResults('5000')
	gg.editAll(value, gg.TYPE_FLOAT)
	success('Actived '..func_name, 'Game walls', results, nil, show_message)
end

function ThrowingStarAMMO()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('175F;100F;-2,147,000,000~2,141,000,000;60::100', gg.TYPE_DWORD)
	gg.refineNumber('-2147483648~2147483647;60')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('999')
	results = SearchWeaponAMMO(results)
	local found = false -- Avoid being banned
	
	for i, result in ipairs(results) do
    	if result.value == 60 then
        	found = true
        	break
    	end
	end
	
	if found == false then
		gg.toast('FAILED: The value "60" was not found')
		return
	end
	
	for i, v in ipairs(results) do
		v.freeze = true
	end
	gg.addListItems(results)
	values = nil
end

function MultiThrowingStarAMMO()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('175F;100F;-2,147,000,000~2,141,000,000;150::100', gg.TYPE_DWORD)
	gg.refineNumber('-2147483648~2147483647;150')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('999')
	results = SearchWeaponAMMO(results)
	local found = false -- Avoid being banned
	
	for i, result in ipairs(results) do
    	if result.value == 150 then
        	found = true
        	break
    	end
	end
	
	if found == false then
		gg.toast('FAILED: The value "150" was not found')
		return
	end
	
	for i, v in ipairs(results) do
		v.freeze = true
	end
	gg.addListItems(results)
	values = nil
end

function GrowthGunAMMO()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.75810986757F;0.90441179276F;-2,147,000,000~2141,000,000;5;4097::100', gg.TYPE_DWORD)
	gg.refineNumber('-2147483648~2147483647;5')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('999')
	results = SearchWeaponAMMO(results)
	local found = false -- Avoid being banned
	
	for i, result in ipairs(results) do
    	if result.value == 5 then
        	found = true
        	break
    	end
	end
	
	if found == false then
		gg.toast('FAILED: The value "5" was not found')
		return
	end
	
	for i, v in ipairs(results) do
		v.freeze = true
	end
	gg.addListItems(results)
	values = nil
end

function MouseGunAMMO()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.89999997616F;0.30000001192F;-2,147,000,000~2,141,000,000;5;4097::100', gg.TYPE_DWORD)
	gg.refineNumber('-2147483648~2147483647;5')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('999')
	results = SearchWeaponAMMO(results)
	local found = false -- Avoid being banned
	
	for i, result in ipairs(results) do
    	if result.value == 5 then
        	found = true
        	break
    	end
	end
	
	if found == false then
		gg.toast('FAILED: The value "5" was not found')
		return
	end
	
	for i, v in ipairs(results) do
		v.freeze = true
	end
	gg.addListItems(results)
	values = nil
end

function SixShooterAMMO()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('500F;150F;-2,147,000,000~2,145,000,000;24::100', gg.TYPE_DWORD)
	gg.refineNumber('-2147483648~2147483647;24')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('999')
	results = SearchWeaponAMMO(results)
	local found = false -- Avoid being banned
	
	for i, result in ipairs(results) do
    	if result.value == 24 then
        	found = true
        	break
    	end
	end
	
	if found == false then
		gg.toast('FAILED: The value "24" was not found')
		return
	end
	
	for i, v in ipairs(results) do
		v.freeze = true
	end
	gg.addListItems(results)
	values = nil
end

function RemoveShade()
	local saved = isSavedResult('Shade', '1', 'float', nil, 'desactive')
	if saved == true then
		return
	end
		
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.1;10;1::15', gg.TYPE_FLOAT)
	gg.refineNumber('1', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('1000')
	-- Prevent it from returning to normal due to pills (GwrothPill, MousePill) :
	for i, result in ipairs(results) do
		result.value = '0'
		result.freeze = true
		result.name = 'Shade'
	end
	gg.addListItems(results)
end

function SmoothCamera()
	local saved = isSavedResult('Smooth cam', '15', 'float', nil, 'desactive')
	if saved == true then
		return
	end
		
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('5~1000;15;15;1D:200', gg.TYPE_FLOAT)
	refineBucle(10, '15', 'float')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('1000')
	gg.editAll('5', gg.TYPE_FLOAT)
	success('Actived Smooth Camera', 'Smooth cam', results)
end

function DoubleSixShooterAMMO()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('500F;150F;-2,147,000,000~2,145,000,000;48::100', gg.TYPE_DWORD)
	gg.refineNumber('-2147483648~2147483647;48')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('999')
	results = SearchWeaponAMMO(results)
	local found = false -- Avoid being banned
	
	for i, result in ipairs(results) do
    	if result.value == 48 then
        	found = true
        	break
    	end
	end
	
	if found == false then
		gg.toast('FAILED: The value "48" was not found')
		return
	end
	
	for i, v in ipairs(results) do
		v.freeze = true
	end
	gg.addListItems(results)
	values = nil
end

function SwordRapidFire()
	if checkSavedResults('Sword rapidfire') then
		OptionHackActivation(swordrapifire_actived, 'Sword rapidfire', 'dword', '0', '1')
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1F;1F;0.3F;1D::35', gg.TYPE_DWORD)
	gg.refineNumber('1', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('50')
	gg.editAll('0', gg.TYPE_DWORD)
	success('Actived Sword Rapid Fire', 'Sword rapidfire', results)
end

function AutoFireBazooka()
	local saved = isSavedResult('Autofire bazooka', '0', 'dword', nil, 'desactive')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0;444,432;45F::42', gg.TYPE_DWORD)
	gg.refineNumber('0', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('50')
	for i, result in ipairs(results) do
		result.value = '1'
		result.freeze = true
		result.name = 'Autofire bazooka'
	end
	
	gg.addListItems(results)
end

function AutoFireSixShooter()
	local pw = checkSavedResults('Autofire sixshooter')
	if pw == true then
		SixShooterOption()
		return
	end
	
	local function LoadResult(results, save_name, refined_results)
		success('Activing..', save_name, refined_results)
		gg.sleep('100')
		gg.clearResults()
		gg.loadResults(results)
		gg.getResults('10')
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0;444,420;150F::40', gg.TYPE_DWORD)
	local primary_results = gg.getResults('100')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	-- OnFire (auto fire)
	gg.refineNumber('0', gg.TYPE_DWORD)
	local results1 = gg.getResults('10')
	LoadResult(primary_results, 'Autofire sixshooter', results1)

	-- No Recoil
	gg.refineNumber('150', gg.TYPE_FLOAT)
	local results2 = gg.getResults('10')
	LoadResult(primary_results, 'recoil sixshooter', results2)
	
	gg.clearResults()
	SixShooterOption()
end

function AutoFireDoubleSixShooter()
	local pw = checkSavedResults('Autofire doubleshooter')
	if pw == true then
		DoubleSixShooterOption()
		return
	end
	
	local function LoadResult(results, save_name, refined_results)
		success('Activing..', save_name, refined_results)
		gg.sleep('100')
		gg.clearResults()
		gg.loadResults(results)
		gg.getResults('10')
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0;444,460;150F::40', gg.TYPE_DWORD)
	local primary_results = gg.getResults('100')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	-- OnFire (auto fire)
	gg.refineNumber('0', gg.TYPE_DWORD)
	local results1 = gg.getResults('10')
	LoadResult(primary_results, 'Autofire doubleshooter', results1)

	-- No Recoil
	gg.refineNumber('150', gg.TYPE_FLOAT)
	local results2 = gg.getResults('10')
	LoadResult(primary_results, 'recoil doubleshooter', results2)
	
	gg.clearResults()
	SixShooterOption()
end

function AutoFireShotgun()
	local saved = isSavedResult('Autofire shotgun', '0', 'dword', nil, 'desactive')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0;444,420;200F::40', gg.TYPE_DWORD)
	gg.refineNumber('0', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('50')
	for i, result in ipairs(results) do
		result.value = '1'
		result.freeze = true
		result.name = 'Autofire shotgun'
	end
	
	gg.addListItems(results)
end

function MoonJump()
	local saved = isSavedResult('Moon jump', '4.1', 'float', nil, 'desactive')
	if saved == true then
		return
	end
		
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('4.1;70', gg.TYPE_FLOAT)
	gg.refineNumber('4.1', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('10')
	gg.editAll('99999', gg.TYPE_FLOAT)
	success('Actived Moon Jump', 'Moon jump', results)
end

function AutoJump()
	local saved = isSavedResult('Auto jump', '0.2', 'float', nil, 'desactive')
	if saved == true then
		return
	end
		
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.1~0.3;70;92;0.25', gg.TYPE_FLOAT)
	gg.refineNumber('0.1~0.3', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('1000')
	gg.editAll('9999', gg.TYPE_FLOAT)
	success('Actived Auto Jump', 'Auto jump', results)
end

function PlayerMovesValue(values, func_name, show_message, NoEdit, maintain_jump, change_mj_value) -- 8;1;1;1;0.4;0.3::
	-- This is for :  
	-- Maintain Jump
	-- No Impulse (only for avatar radius)
	
	local speed_search = '8'
	if checkSavedResults('Player moves') and maintain_jump == true then
		values = '1'
	end
	
	if NoEdit == nil then
		if is_maintainjump_actived == true then
			values = '1;0;1'
		end
		
		local saved = isSavedResult('Player moves', values, 'float')
		if saved == true then
			return
		end
	end
	
	if checkSavedResults('Speed') then
		speed_search = getSavedResultValue('Speed', 'float')
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber(speed_search..';1;1;1;0.4;0.3::', gg.TYPE_FLOAT)
	gg.refineNumber('1', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('50')
	if NoEdit == nil then
		gg.editAll(values, gg.TYPE_FLOAT)
	end
	
	success('...', 'Player moves', results, nil, true)
	if maintain_jump == true then
		is_maintainjump_actived = true
	end
end

function AntiLagRadius(action_type)
	if action_type == 'desactive' then
		isSavedResult('Anti Lag','1.2', 'float')
		return
	end
		
	gg.clearResults()
	gg.searchNumber('80;1.20000004768', gg.TYPE_FLOAT)
	gg.refineNumber('1.20000004768', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('500')
	success('...', 'Anti Lag', results, nil, true)
end

function SpeedJetPack()
	local speed_value = gg.prompt(
 		{'Speed Amount (1 = normal) [1; 24]'},
	 	{8, -76}, {'number'}
	)
	
	speedjetpack = math.floor(speed_value[1] * 1050)
	local saved = isSavedResult('Jetpack speed', speedjetpack, 'float')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.3~0.5;900~1750;2;300~500::',gg.TYPE_FLOAT)
	gg.refineNumber('900~1750', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Jetpack speed', speedjetpack, 'float')
		return
	end
	
	local results = gg.getResults('100')
	gg.editAll(speedjetpack, gg.TYPE_FLOAT)
	success('Actived JetPack Speed Multiplier', 'Jetpack speed', results)
end

function NoFireTower()
	local saved = isSavedResult('No fireT', '20', 'float', nil, 'desactive')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1.89835476875;20;5:100', gg.TYPE_FLOAT)
	gg.refineNumber('20', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('No fireT', '20', 'float')
		return
	end
	
	local results = gg.getResults('10')
	gg.editAll('0', gg.TYPE_FLOAT)
	success('Actived No Fire Tower', 'No fireT', results)
end

function NoIceTower()
	local saved = isSavedResult('No iceT', '20', 'float', nil, 'desactive')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1.54999995232;20;5:100', gg.TYPE_FLOAT)
	gg.refineNumber('20', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('No iceT', '1', 'float')
		return
	end
	
	local results = gg.getResults('10')
	gg.editAll('0', gg.TYPE_FLOAT)
	success('Actived No Ice Tower', 'No iceT', results)
end

function GoldModifier()
	local modifier = gg.prompt({'What is your current gold', 'Gold Amount'}, {0, 5000}, {'number', 'number'})
	local saved = isSavedResult('Gold amount', modifier[2], 'dword')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('32~55;60;63;'..modifier[1]..':180', gg.TYPE_DWORD)
	gg.refineNumber(modifier[1], gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Gold amount', modifier[2], 'dword')
		return
	end
	
	local results = gg.getResults('1000')
	gg.editAll(modifier[2], gg.TYPE_DWORD)
	success('Gold amount', modifier[2], 'dword')
end

function CubeGunShapeEdit() -- 0.25~0.5;0.25~5;1;1;1;1;1;-1.5;-1.5;-1.5;0D;0D;0D;1;1;1;-99~1000;43D;-0.7~0.8;43D
	local pw = checkSavedResults('Cube size')
	if pw == true then
		CubeGunShapeEditOption()
		return
	end
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.25~0.5;0.25~5;1;1;1;-1.5;-1.5;-1.5;0;0;1;1;1;43D;-0.7~0.8;43D', gg.TYPE_FLOAT)
	gg.refineNumber('-1.5;0;1', gg.TYPE_FLOAT)
	local primary_results = gg.getResults('400')
	
	local function LoadResult(results, save_name, refined_results)
		success('Activing..', save_name, refined_results)
		gg.sleep('100')
		gg.clearResults()
		gg.loadResults(results)
		gg.getResults('10')
	end
	
	-- cube gun size 
	gg.refineNumber('1', gg.TYPE_FLOAT)
	local results1 = gg.getResults('100')
	LoadResult(primary_results, 'Cube size', results1)
	
	-- cube gun rotation
	gg.refineNumber('0', gg.TYPE_FLOAT)
	local results2 = gg.getResults('70')
	LoadResult(primary_results, 'Cube rotation', results2)
	
	-- cube down
	gg.refineNumber('-1.5', gg.TYPE_FLOAT)
	local results3 = gg.getResults('20')
	LoadResult(primary_results, 'Cube down', results3)
	
	gg.sleep('200')
	gg.clearResults()
	CubeGunShapeEditOption()
end

function WeaponHitDamage()
	if checkSavedResults('Hit damage') then
		-- I could have used "gg.setValues()" but it doesn't work because if the script fails and ends, this will not be disabled again.
		local function getOtherResult()
			local results = gg.getListItems()
			local dmvalues = ''
			local total_name = ''
			
			for i, result in ipairs(results) do
				if string.sub(result.name, 1, 8) == 'DAMAGE: ' then
					local start_index = string.find(result.name, 'DAMAGE: ') + string.len('DAMAGE: ')
					dmvalues = string.sub(result.name, start_index)
					total_name = result.name
					break
				end
			end
			return dmvalues, total_name
		end
		
		local damage_values, otherhitdamage = getOtherResult()
		print(otherhitdamage)
		local otherhitresults = getSavedResults(otherhitdamage, 'float')
		local hitdamage = getSavedResults('Hit damage', 'float')
		
		for idk, ok in ipairs(hitdamage) do
			table.insert(otherhitresults, {address=ok.address, value=ok.value, flags=ok.flags})
		end
		
		gg.clearResults()
		gg.loadResults(otherhitresults)
		
		gg.getResults('9999')
		-- finally :
		gg.editAll(damage_values, gg.TYPE_FLOAT)
		gg.toast('Desactived Hit Damage')
		return
	end
				
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1D;444,444D;444,000~444,700D;5~1600;2~150D', gg.TYPE_FLOAT)
	gg.refineNumber('5~1600', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
	end
	
	local results = gg.getResults('9000')
	results = SearchWeaponDamage(results)
	
	gg.editAll('9999999', gg.TYPE_FLOAT)
	success('Actived Weapon Hit Damage', 'Hit damage', results)
end

function Animation_3() -- animated arm
	local saved = isSavedResult('animation 3', '0', 'dword', nil, 'desactive')
	if saved == true then
		return
	end
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('5F;90F;45F;0~1::180', gg.TYPE_DWORD)
	gg.refineNumber('0~1', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('animation 3', '0', 'dword')
	end
	
	local results = gg.getResults('500')
	for i, result in ipairs(results) do
		result.value = '1'
		result.freeze = true
		result.name = 'animation 3'
	end
	gg.addListItems(results)
end

function ImpulseRangeSettings()
	local imp = checkSavedResults('Impulse Gun Range')
	if imp == true then
		ImpulseGunRangeRadiusOption()
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1600;1500;25;1.20000004768', gg.TYPE_FLOAT)
	gg.refineNumber('25;1.20000004768', gg.TYPE_FLOAT)
	local primary_results = gg.getResults('100')
	
	local function LoadResult(results, save_name, refined_results)
		success('Activing..', save_name, refined_results)
		gg.sleep('100')
		gg.clearResults()
		gg.loadResults(results)
		gg.getResults('10')
	end
	
	-- range
	gg.refineNumber('25', gg.TYPE_FLOAT)
	local results1 = gg.getResults('40')
	gg.editAll('9999999', gg.TYPE_FLOAT)
	LoadResult(primary_results, 'Impulse Gun Range', results1)
	
	-- radius
	gg.refineNumber('1.20000004768', gg.TYPE_FLOAT)
	local results2 = gg.getResults('40')
	LoadResult(primary_results, 'Impulse Gun Radius', results2)
	
	-- self impulse
	gg.refineNumber('1600', gg.TYPE_FLOAT)
	local results3 = gg.getResults('40')
	LoadResult(primary_results, 'Impulse Gun Self Impulse', results3)
	
	gg.sleep('200')
	gg.clearResults()
	ImpulseGunRangeRadiusOption()
end

function BazookaDamageSettings()
	local bak = checkSavedResults('Bazooka Bullet Speed')
	if bak == true then
		BazookaDamageRadiusOption()
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('10;1000;30;150', gg.TYPE_FLOAT)
	local primary_results = gg.getResults('100')
	
	local function LoadResult(results, save_name, refined_results)
		success('Activing..', save_name, refined_results)
		gg.sleep('100')
		gg.clearResults()
		gg.loadResults(results)
		gg.getResults('10')
	end
	
	-- radius
	gg.refineNumber('10', gg.TYPE_FLOAT)
	local results1 = gg.getResults('40')
	LoadResult(primary_results, 'Bazooka Radius', results1)
	
	-- speed bullet
	gg.refineNumber('30', gg.TYPE_FLOAT)
	local results2 = gg.getResults('40')
	LoadResult(primary_results, 'Bazooka Bullet Speed', results2)
	
	-- range
	gg.refineNumber('150', gg.TYPE_FLOAT)
	local results3 = gg.getResults('20')
	gg.editAll('999999', gg.TYPE_FLOAT)
	LoadResult(primary_results, 'Bazooka Range', results3)
	
	-- damage
	gg.refineNumber('1000', gg.TYPE_FLOAT)
	local results4 = gg.getResults('20')
	gg.editAll('999999', gg.TYPE_FLOAT)
	LoadResult(primary_results, 'Bazooka Damage Value', results4)
	
	gg.sleep('200')
	gg.clearResults()
	BazookaDamageRadiusOption()
end
	

function CubeGunRapidFire()
	if checkSavedResults('Cube Gun rapidfire') then
		OptionHackActivation(cubegunrapidfire_actived, 'Cube Gun rapidfire', 'dword', '0', '1')
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1F;1F;0.3F;1;0.8F;444,444::90', gg.TYPE_DWORD)
	gg.refineNumber('1', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Cube Gun rapidfire', '1', 'dword')
		return
	end
	
	local results = gg.getResults('20')
	gg.editAll('0', gg.TYPE_DWORD)
	success('Actived Cube Gun Rapid Fire', 'Cube Gun rapidfire', results)
end

function BazookaRapidFire()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1.29999995232F;1;444,444;10F;1000F;30F;4097:160', gg.TYPE_DWORD)
	gg.refineNumber('1', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Bazooka rapidfire', '1', 'dword')
		return
	end
	
	local results = gg.getResults('1')
	gg.editAll('0', gg.TYPE_DWORD)
	success('Actived Bazooka Rapid Fire', 'Bazooka rapidfire', results)
end

function ApplySpawnPoint()
	--if local saved_data = checkTextInSavedResults
end

function RailGunAMMO()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('5F;40F;-2,147,000,000~2,145,000,000;5::100', gg.TYPE_DWORD)
	gg.refineNumber('-2147483648~2147483647;5')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('999')
	results = SearchWeaponAMMO(results)
	local found = false -- Avoid being banned
	
	for i, result in ipairs(results) do
    	if result.value == 5 then
        	found = true
        	break
    	end
	end
	
	if found == false then
		gg.toast('FAILED: The value "5" was not found')
		return
	end
	
	for i, v in ipairs(results) do
		v.freeze = true
	end
	gg.addListItems(results)
	values = nil
end

function CubeGunIlluminated()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('2000~900000;1;0.8~0.9F;0', gg.TYPE_DWORD)
	refineBucle(10, '0', 'dword')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local count = 0
	
	while true do
		local results = gg.getResults('10000')
		
		for i, result in ipairs(results) do
			if result.value == 1 then
				gg.setValues({address=result.address, value='0', flags=gg.TYPE_DWORD})
				if count == 2 then
					break
				end
				count = count + 1
			end
		end
		gg.toast('Delete something to activate it')
		gg.sleep('1500')
	end
	
	success('Actived Cube Gun Illuminated')
end
	

function PlayerTeamSpawn()
	local sens = checkSavedResults('Player team')
	if sens == true then
		SetTeamOption()
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('-1;0~5;258,000~264,000;-3740~-3700::', gg.TYPE_DWORD)
	gg.refineNumber('0~5', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('20')
	success('Obtained concurrent player team', 'Player team', results)
	SetTeamOption()
end
	

function ControllersSize()
	local size = gg.prompt({'Size amount (0.1 = normal)'})
	
	
	local saved = isSavedResult('Controllers size', size[1], 'float')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.1;0.01:400', gg.TYPE_FLOAT)
	refineBucle(15, '0.1;0.01', 'float')
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Controllers size', '0.1;0.01', 'float')
		return
	end
	
	local results = gg.getResults('5500')
	gg.editAll(size[1], gg.TYPE_FLOAT)
	success('Actived Controllers Size', 'Controllers size', results)
end

function PlayerSensivity()
	local sens = checkSavedResults('Sensivity XZ')
	if sens == true then
		SensivityOption()
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1.75;0;0.16699999571;0.20800000429', gg.TYPE_FLOAT)
	gg.refineNumber('0.16699999571;0.20800000429', gg.TYPE_FLOAT)
	local primary_results = gg.getResults('20')
	
	local function LoadResult(results, save_name, refined_results)
		success('Activing..', save_name, refined_results)
		gg.sleep('100')
		gg.clearResults()
		gg.loadResults(results)
		gg.getResults('10')
	end
	
	gg.refineNumber('0.16699999571', gg.TYPE_FLOAT)
	local results1 = gg.getResults('10')
	LoadResult(primary_results, 'Sensivity XZ', results1)
	
	gg.refineNumber('0.20800000429', gg.TYPE_FLOAT)
	local results2 = gg.getResults('200')
	LoadResult(primary_results, 'Sensivity Y', results2)
	
	gg.sleep('200')
	gg.clearResults()
	SensivityOption()
end


function NoEquipWeapons()
	local saved = isSavedResult('No equip', '0.5', 'float', nil, 'desactive')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1;0.00999999978;267D;0.4~0.6;0.3~1', gg.TYPE_FLOAT)
	gg.refineNumber('0.4~0.6', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('No equip', '0.5', 'float')
		return
	end
	
	local results = gg.getResults('500')
	gg.editAll('-9', gg.TYPE_FLOAT)
	success('Actived No Equip Weapons', 'No equip', results)
end

function ReviveMode()
	local function isEqualResultDead(results, equal_address)
		local found_value = false
		while true do
			for _, nwresult in ipairs(results) do
				if nwresult.address == equal_address and nwresult.value == 0 then
					found_value = true
					break
				end
			end
		end
		return found_value
	end
	
	local function LoadResult(results)
		gg.clearResults()
		gg.loadResults(results)
		return gg.getResults('999')
	end
					
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	
	if checkSavedResults('Player coords') == false then
		CustomTeleport('...', 'Activing', true)
		gg.clearResults()
	end
	
	gg.searchNumber('0.58088231087F;1F;2F;2F;1;0::', gg.TYPE_DWORD)
	refineBucle(5, '0', 'dword')
	
	while true do
		local results = gg.getResults('999')
		for i, result in ipairs(results) do
			if result.value == 1 then
				local result_address = result.address
				local dead_coords = getSavedResults('Player coords', 'float', 2)
				local new_results = LoadResult(results)

				
				-- check if the player has already respawned 
				print('laaaa')
				local rDead_player = isEqualResultDead(new_results, result_address)
				if rDead_player == true then
					-- Coordinates where it reappeared
					local spawn_coords = getSavedResults('Player coords', 'float', 2)
					LoadResult(spawn_coords)
					gg.setValues(dead_coords)
				
					gg.sleep('250')
					LoadResult(new_results)
				end
			end
		end
	end
end


function NoImpulsePlayer()
	local saved = isSavedResult('No impulse', '1', 'float')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_C_HEAP | gg.REGION_ANONYMOUS)
	gg.searchNumber('5;90;20;1D;1;1::90', gg.TYPE_FLOAT)
	gg.refineNumber('1', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('No impulse', '1', 'float')
		return
	end
	
	local results = gg.getResults('30')
	gg.editAll('3.4E38;1', gg.TYPE_FLOAT)
	success('Actived No Impulse', 'No impulse', results)
end

function AvatarHitboxRange()
	local size = gg.prompt({'Range amount (0.5 = normal)'})
	
	if tonumber(size[1]) < 0.5 then
		size[1] = '0.5'
	end
	
	local saved = isSavedResult('Avatar hitbox', size[1], 'float')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1;0.00999999978;267D;0.4~0.6;0.3~1', gg.TYPE_FLOAT)
	gg.refineNumber('0.4~0.6', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Avatar hitbox', '0.5', 'float')
		return
	end
	
	local results = gg.getResults('500')
	gg.editAll(size[1], gg.TYPE_FLOAT)
	success('Actived Avatar Hitbox Range', 'Avatar hitbox', results)
end

function InfiniteHealth_Normal()
	--local saved = checkSavedResults('INF Health')
	--if saved == true then
	--	InfiniteHealthOptions()
	--	return
	--end
	
	-- player interaction :
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('10F;4F;1;258,000~266,000::', gg.TYPE_DWORD)
	gg.refineNumber('1', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		gg.toast('No found results. Restart the game to fix it!')
		return
	end
	
	local results = gg.getResults('100')
	gg.editAll('9', gg.TYPE_DWORD)
	success('Actived INF. Health Normal', 'INF Health', results)
end

function InfiniteHealthNoControls() -- inf health shitty
	--local saved = checkSavedResults('INF Health')
	--if saved == true then
	--	InfiniteHealthOptions()
	--	return
	--end
	
	local function LoadResult(results)
		gg.clearResults()
		gg.loadResults(results)
		gg.refineNumber('0', gg.TYPE_DWORD)
		local results2 = gg.getResults('9999')
		gg.editAll('1', gg.TYPE_DWORD)
		return results2
	end
	
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)

	-- player controllers : 
	gg.searchNumber('100;100F;1;257,000~265,000', gg.TYPE_DWORD)
	gg.refineNumber('1', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end

	local results = gg.getResults('300')
	success('Activing...', 'Health no controllers', results)
	gg.clearResults()
	
	-- player interaction :
	-- old search:  4F;1;0.60000002384F;1F;20F;20F
	gg.searchNumber('10F;4F;1;258,000~266,000::', gg.TYPE_DWORD)
	gg.refineNumber('1', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
	end
	
	local results2 = gg.getResults('100')
	gg.editAll('0', gg.TYPE_DWORD)
	gg.alert('Respawn again to activate it')
	gg.sleep('10000')
	
	local results4 = LoadResult(results)
	is_infhealth_actived = true
	success('Actived INF. Health (respawn again)', 'INF Health', results2)
end

function AccessorySettings()
	local asize = checkSavedResults('Accessory Size')
	if asize == true then
		AccessorySetOption()
		return
	end
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1~1.25;-0.3~0.9;0.1~0.8;0;43D', gg.TYPE_FLOAT)
	local primary_results = gg.getResults('1000')
	
	local function LoadResult(results, save_name, refined_results)
		success('Activing..', save_name, refined_results)
		gg.sleep('100')
		gg.clearResults()
		gg.loadResults(results)
		gg.getResults('1000')
	end
	
	gg.refineNumber('1~1.25', gg.TYPE_FLOAT)
	local results1 = gg.getResults('500')
	LoadResult(primary_results, 'Accessory Size', results1)
	
	gg.refineNumber('-0.3~0.9', gg.TYPE_FLOAT)
	local results2 = gg.getResults('200')
	LoadResult(primary_results, 'Accessy Offset X', results2)
	
	gg.refineNumber('-0.1~0.8', gg.TYPE_FLOAT)
	local results3 = gg.getResults('200')
	LoadResult(primary_results, 'Accessy Offset Y', results3)
	
	gg.refineNumber('0', gg.TYPE_FLOAT)
	local results4 = gg.getResults('200')
	LoadResult(primary_results, 'Accessy Offset Z', results4)
	
	gg.sleep('200')
	gg.clearResults()
	AccessorySetOption() -- settings
end

function NoCameraCollision()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.3000000119;-80;80', gg.TYPE_FLOAT)
	gg.refineNumber('0.3000000119', gg.TYPE_FLOAT)
	if gg.getResultsCount() <= 0 then
		notFoundError('No camera collision', '0.3000000119', 'float')
		return
	end
	
	local results = gg.getResults('999')
	gg.editAll('0', gg.TYPE_FLOAT)
	success('Actived No Camera Collision', 'No camera collision', results)
end

function FlamethrowerAMMO()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('20F;15F;0.5F;-2,147,000,000~2,145,000,000;19~20F::100', gg.TYPE_DWORD)
	gg.refineNumber('-2147483648~2147483647;20F')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('999')
	results = SearchWeaponAMMO(results, nil, true)
	local found = false -- Avoid being banned
	
	for i, result in ipairs(results) do
    	if result.flags == gg.TYPE_FLOAT then
    		if result.value == 20 then
    			found = true
    			break
    		end
    	end
	end
	
	if found == false then
		gg.toast('FAILED: The value "100" was not found')
		return
	end
	
	for i, v in ipairs(results) do
		v.freeze = true
	end
	gg.addListItems(results)
	values = nil
end

function HealRayAMMO()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('25F;0.5F;-2,147,000,000~2,145,000,000;29~30F::100', gg.TYPE_DWORD)
	gg.refineNumber('-2147483648~2147483647;30F')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('999')
	results = SearchWeaponAMMO(results, nil, true)
	local found = false -- Avoid being banned
	
	for i, result in ipairs(results) do
    	if result.flags == gg.TYPE_FLOAT then
    		if result.value == 30 then
    			found = true
    			break
    		end
    	end
	end
	
	if found == false then
		gg.toast('FAILED: The value "100" was not found')
		return
	end
	
	for i, v in ipairs(results) do
		v.freeze = true
	end
	gg.addListItems(values)
	values = nil
end

function WeaponsWithGrowth()
	local saved = isSavedResult('Weapons with growth', '1', 'dword', nil, 'desactive')
	if saved == true then
		return
	end
	
	PlayerEffect('15')
	gg.toast('Activing hack, wait...')
	gg.clearResults()

	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('3;1;50~300', gg.TYPE_DWORD)
	refineBucle(15, '1', 'dword')
	
	local results1 = gg.getResults('99999')
	success('Activing...', 'Growth Weapon', results1)
	PlayerEffect('20')
	gg.sleep('500')
	PlayerEffect('0') -- instantDeath
	gg.sleep('6000')
	
	gg.clearResults()
	gg.loadResults(results1)
	gg.refineNumber('0', gg.TYPE_DWORD)
	local results2 = gg.getResults('9999')
	success('Activing...', 'Growth Weapon second', results2)
	PlayerEffect('15')
	gg.sleep('1000')
	
	gg.clearResults()
	gg.loadResults(results2)
	refineBucle(10, '1', 'dword')
	local results3 = gg.getResults('3000')
	gg.editAll('0', gg.TYPE_FLOAT)
	
	PlayerEffect('0')
	removeSavedResults('Growth Weapon', '1', 'dword')
	removeSavedResults('Growth Weapon second', '0', 'dword')
	success('Actived Weapons With Growth', 'Weapons with growth', results3)
end

function MiniShotgunRadius() -- bad
	local playerRadius = gg.prompt(
		{'Note: Press the "SX" Button to desactive, and return main menu.\n\nX/Z Size', 'Y Size', 'Make Crumbly Blocks', 'Anti Lag (Fast Remove)', 'No Impulse (Avoid being pushed)'},
		{[3]=false, [4]=false, [5]=false}, 
		{[3]='checkbox', [4]='checkbox', [5]='checkbox'}
	)
	gg.alert('Try to have 24 ammo to make it work')
	local checksaved = checkSavedResults('Avatar Radius second')
	
	if checksaved == false then
		gg.toast('Use Avatar Radius (auto or manual) first')
		return
	end
	
	if playerRadius[3] == true and checkSavedResults('Player Effects (change to 0 to desactive it)') == false then
		gg.toast('Use All Blocks Destructibles or Self Heal first')
		return
	end
	
	if playerRadius[4] == true then
		if checkSavedResults('Anti Lag') == false then
			AntiLagRadius()
		end
	end
	
	if playerRadius[5] == true then
		PlayerMovesValue('...', '...', false, true)
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber(shotgun_damage_value..'F;50F;350F;23~24:55', gg.TYPE_DWORD)
	gg.refineNumber('24', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		gg.toast('FAILED: No found results')
		--gg.sleep('2000')
		--MiniShotgunRadius()
	end
	
	--rest of the code
	isDecreasedAmmoRadius(playerRadius[3], playerRadius[4], playerRadius[5])
end

function MiniCubeGunRadius() -- bad
	local playerRadius = gg.prompt(
		{'Note: Press the "SX" Button to desactive, and return main menu.\n\nX/Z Size', 'Y Size', 'Make Crumbly Blocks', 'Anti Lag (Fast Remove)', 'No Impulse (Avoid being pushed)'},
		{[1]='10', [2]='5', [3]=false, [4]=false, [5]=false},
		{[3]='checkbox', [4]='checkbox', [5]='checkbox'}
	)
	
	gg.alert('Try to have 28~40 cube gun blocks to make it work')
	radius_weapon = playerRadius[1]..';'..playerRadius[2]
	
	local checksaved = checkSavedResults('Avatar Radius second')
	if checksaved == false then
		gg.toast('Use Avatar Radius (auto or manual) first')
		return
	end
	
	if playerRadius[3] == true and checkSavedResults('Player Effects (change to 0 to desactive it)') == false then
		gg.toast('Use All Blocks Destructibles or Self Heal first')
		return
	end
	
	if playerRadius[4] == true then
		if checkSavedResults('Anti Lag') == false then
			AntiLagRadius()
		end
	end
	
	if playerRadius[5] == true then
		PlayerMovesValue('...', '...', false, true)
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('444444;200F;2~40;65536', gg.TYPE_DWORD)
	gg.refineNumber('28~40', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		gg.toast('FAILED: No found results, trying again...')
		gg.sleep('2000')
		MiniCubeGunRadius()
	end
	--rest of the code
	if cube_radius_selection == 'REMOVING' then
		isIncreasedCube(playerRadius[3], playerRadius[4], playerRadius[5])
	else -- ADDING
		isDecreasedAmmoRadius(playerRadius[3], playerRadius[4], playerRadius[5])
	end
end

function ImpulseNoCollision()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1500;15;20', gg.TYPE_FLOAT)
	gg.refineNumber('15', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Impulse no collision', '15', 'float')
		return
	end
	
	local results = gg.getResults('20')
	gg.editAll('0', gg.TYPE_FLOAT)
	success('Actived Impulse No Camera Collision', 'Impulse no collision', results)
end

function RapidFireWeapons()
	if checkSavedResults('Rapidfire Weapons') then
		OptionHackActivation(rapidfire_weapons_actived, 'Rapidfire Weapons', 'dword', '0', '1')
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1F;1F;1;444,444::80', gg.TYPE_DWORD)
	gg.refineNumber('1', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('100')
	gg.editAll('0', gg.TYPE_DWORD)
	success('Actived Rapid Fire Weapons', 'Rapidfire Weapons', results)
end

function CentergunAMMO()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('150F;500F;-2147483648~2147483647;150::100', gg.TYPE_DWORD)
	gg.refineNumber('-2147483648~2147483647;150')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('999')
	results = SearchWeaponAMMO(results)
	
	local found = false -- Avoid being banned
	
	for i, result in ipairs(results) do
    	if result.value == 150 then
        	found = true
        	break
    	end
	end
	
	if found == false then
		gg.toast('FAILED: The value "150" was not found')
		return
	end
	
	for i, v in ipairs(results) do
		if v.flags == gg.TYPE_DWORD then
			v.freeze = true
		end
	end
	gg.addListItems(results)
	values = nil
end

function ShotgunAMMO()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('50F;350F;-2147483648~2147483647;24::100', gg.TYPE_DWORD)
	gg.refineNumber('-2147483648~2147483647;24')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('999')
	results = SearchWeaponAMMO(results)
	
	local found = false -- Avoid being banned
	
	for i, result in ipairs(results) do
    	if result.value == 24 then
        	found = true
        	break
    	end
	end
	
	if found == false then
		gg.toast('FAILED: The value "24" was not found')
		return
	end
	
	for i, v in ipairs(results) do
		if v.flags == gg.TYPE_DWORD then
			v.freeze = true
		end
	end
	gg.addListItems(results)
end

function InfiniteAmmoWeapons() -- 0.001~2F;1;0;444,444;-2,146,812,124~2,146,812,124;1~150:55
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('444,444;444,000~445,000;2~1000F;-2,147,200,200~2,141,000,900;1~150;1', gg.TYPE_DWORD)
	gg.refineNumber('-2,146,812,124~2,142,812,124;1~150', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('10000')
	results = SearchWeaponAMMO(results)
	
	for i, result in ipairs(results) do
		result.freeze = true
	end
	
	gg.addListItems(results)
	success('Actived INF. Ammo Weapons')
end

function RevolverKill()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('150;100;500;150', gg.TYPE_FLOAT)
	gg.refineNumber('150', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Revolver damage', '150', 'float')
		return
	end
	
	local results = gg.getResults('1')
	gg.editAll('99999', gg.TYPE_FLOAT)
	success('Actived Revolver Damage', 'Revolver damage', results)
end

function SpeedWeapon()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1F;444,444D;443,000~445,590D;1~1600;3~150D;0~1D:140', gg.TYPE_FLOAT)
	gg.refineNumber('2~1600', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results1 = gg.getResults('2000')
	local results = SearchWeaponFire(results1)
	
	gg.clearResults()
	gg.loadResults(results)
	gg.getResults('100')
	
	gg.editAll('999999', gg.TYPE_FLOAT)
	success('Actived Speed Weapon')
end

function Animation_1()
	local saved = isSavedResult('animation 1', '0', 'dword', nil, 'desactive')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.25F;1F;4.09999990463F;0', gg.TYPE_DWORD)
	gg.refineNumber('0', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('animation 1', '0', 'dword')
	end
	
	local results = gg.getResults('40')
	for i, result in ipairs(results) do
    	result.value = '1'
    	result.freeze = true
    	result.name = 'animation 1'
	end
	gg.addListItems(results)
end

function FreezeCamera() -- like Animation 1
	local saved = isSavedResult('Freeze camera', '0', 'dword', nil, 'desactive')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('256;0~1;512;729;0.3F:260', gg.TYPE_DWORD)
	gg.refineNumber('0', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Freeze camera', '0', 'dword')
		return
	end
	
	local results = gg.getResults('200')
	gg.editAll('1', gg.TYPE_DWORD)
	success('Actived Freeze Camera', 'Freeze camera', results)
end

function RevolverCrash()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('150;22~48D;1D::40', gg.TYPE_FLOAT)
	gg.refineNumber('150', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Revolver crash', '150', 'float')
		return
	end
	
	local results = gg.getResults('100')
	gg.editAll('3.4E38', gg.TYPE_FLOAT)
	success('Actived Revolver Crash', 'Revolver crash', results)
end

function NoFall()
	local saved = isSavedResult('No fall', '1', 'float', nil, 'desactive')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.43;20;1', gg.TYPE_FLOAT)
	gg.refineNumber('1', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('No fall', '1', 'float')
		return
	end
	
	local results = gg.getResults('300')
	gg.editAll('0', gg.TYPE_FLOAT)
	success('Actived No Fall', 'No fall', results)
end

function CustomTeleport(coords, func_name, NoEdit)
	if NoEdit == true then
		local saved = isSavedResult('Player coords', coords, 'float')
		if saved == true then
			return
		end
	end
	
	gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber('0.156;1;0.75;0.74999988079;0.74999988079;-3000~3000::55', gg.TYPE_FLOAT)
    
    if gg.getResultsCount() <= 0 then
		--MapTeleport(coords, 'Player map')
		notFoundError()
		return
	end
	
    local results = gg.getResults('300')
    results =  SearchCoordinates(results)
    
    if NoEdit == true then
		gg.editAll(coords, gg.TYPE_FLOAT)
	end
	
    if checkSavedResults('Player coords') == false then
		success('Teleported to '..func_name, 'Player coords', results)
	end
end

function MapTeleport2(xyz, result_name)
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1.00000011921;1.32500004768;0.40000000596;1;1;1;-777~999', gg.TYPE_FLOAT)
	gg.sleep('1000')
	gg.refineNumber('-777~999', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError(result_name, '33', 'float')
	end
	
	local results = gg.getResults('160')
	results =  SearchCoordinates(results)
	
	gg.editAll(xyz, gg.TYPE_FLOAT)
	success('Teleported Player', result_name, results)
end

function MapTeleport()
	local playerPos = gg.prompt(
		{'X Position', 'Y Position', 'Z Position', 'Save player coordinates'},
		{[4]=false}, {[4]='checkbox'}
	)
	local coords = playerPos[1]..';'..playerPos[2]..';'..playerPos[3]
	
	if playerPos[4] == true then
		saved_player_coordinates = coords
	end
	
	local saved = isSavedResult('Player coords', coords, 'float')
	if saved == true then
		return
	end
	
    gg.clearResults()	
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber('0.156;0.75;0.74999988079;0.74999988079;-3000~3000::55', gg.TYPE_FLOAT)
    
    if gg.getResultsCount() <= 0 then
		notFoundError('Player coords', '0', 'float')
		return
	end
	
    local results = gg.getResults('999')
    results =  SearchCoordinates(results)
    
    gg.editAll(coords, gg.TYPE_FLOAT)
    success('Teleported Player', 'Player coords', results)
end

function DeathAnimation()
	local saved = isSavedResult('Death animation', '0', 'dword', nil, 'desactive')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.58088231087F;1F;2F;2F;1;0', gg.TYPE_DWORD)
	gg.refineNumber('0', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Death animation', '0', 'dword')
		return
	end
	
	local results = gg.getResults('460')
	gg.editAll('1', gg.TYPE_DWORD)
	success('Actived Death Animation', 'Death animation', results)
end

function JetpackAnimation()
	local saved = isSavedResult('Jetpack animation', '0', 'dword', nil, 'desactive')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('100F;1F;100;0::57', gg.TYPE_DWORD)
	gg.refineNumber('0', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Jetpack animation', '0', 'dword')
		return
	end
	
	local results = gg.getResults('120')
	gg.editAll('1', gg.TYPE_DWORD)
	success('Actived Animation 1', 'Jetpack animation', results)
end

function InfiniteJetpack()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.3~0.5;6;2;300~500::', gg.TYPE_FLOAT)
	gg.refineNumber('6', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Inf jetpack', '6', 'float')
		return
	end
	
	local results = gg.getResults('500')
	gg.editAll('200', gg.TYPE_FLOAT)
	success('Actived Infinite Jetpack', 'Inf jetpack', results)
end

function HealRayRange()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1;20;25;0.5;26~30', gg.TYPE_FLOAT)
	gg.refineNumber('20;25;0.5', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Healray Range', '20;25;0.5', 'float')
		return
	end
	
	local results = gg.getResults('50')
	gg.editAll('9999', gg.TYPE_FLOAT)
	success('Actived Heal Ray Range', 'Healray Range', results)
end

function NeverCrushed()
	local radius_force = '13;2'
	gg.alert('IMPORTANT: Stand next to a block on the map, (no cube guns)\nso you can be crushed and the script will be activated\n\nAnd press the "Menu" button and do not press the "Play" button, stay in the menu until the hack is activated')
	local checksaved = checkSavedResults('Avatar Radius second')
	if checksaved == false then
		gg.toast('Use Avatar Radius (auto or manual) first')
		return
	end
	
	local function getSavedResultsCrushed()
		local saved_results = gg.getListItems()
		local results = {}
		
		for i, result in ipairs(saved_results) do
			if result.name == 'Never Crushed' then
				table.insert(results, {address=result.address, value=result.value, flags=gg.TYPE_DWORD})
			end
		end
		
		gg.clearResults()
		gg.loadResults(results)
		gg.getResults('99999')
	end
	
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('6,100,000~6,900,000;4,200,000~5,900,000;3;0:400', gg.TYPE_DWORD)
	refineBucle(5, '0', 'float')
	
	local results = gg.getResults('99999')
	success('Activing...', 'Never crushed', results)
	
	-- activate avatar radius to get stuck
	isSavedResult('Avatar Radius second', radius_force, 'float', nil)
	gg.sleep('6000')
	
	getSavedResultsCrushed()
	gg.refineNumber('1', gg.TYPE_DWORD)
	local results2 = gg.getResults('10000')
	
	for i, result in ipairs(results2) do
		result.freeze = true
	end
	
	gg.addListItems(results2)
	gg.sleep('600')
	
	isSavedResult('Avatar Radius second', '0.45;0.95', 'float', nil)
	success('Actived Never Crushed')
end
	

function NeverCrushed102928()
	local force = gg.prompt({'Radius Force (example = 20, No lag = 6), this will cause lag for the script to find the hack'})
	
	
	gg.alert('IMPORTANT: Stand next to a block on the map, (no cube guns)\nso you can be crushed and the script will be activated\n\nAnd press the "Menu" button and do not press the "Play" button, stay in the menu')
	local checksaved = checkSavedResults('Avatar Radius second')
	if checksaved == false then
		gg.toast('Use Avatar Radius (auto or manual) first')
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('6,200,000~6,900,000;101;2~3;0;0;4~6', gg.TYPE_DWORD)
	
	refineBucle(15, '0', 'dword')
	local results1 = gg.getResults('99999')
	success('Activing...', 'Never crushed', results1)
	
	gg.clearResults()
	local saved = isSavedResult('Avatar Radius second', force[1], 'float', nil)
	if saved == true then
		local results2 = getSavedResults('Never crushed', 'dword')
		gg.clearResults()
		gg.loadResults(results2)
		gg.refineNumber('1', gg.TYPE_DWORD)
	
		if gg.getResultsCount() <= 0 then
			notFoundError('Never crushed', '0', 'dword')
		end
		
		local results3 = gg.getResults('8100')

		gg.sleep('6000') -- wait for the result values ​​to be 0
		gg.editAll('1', gg.TYPE_DWORD)
		removeSavedResults('Never crushed', '0', 'dword')
		removeSavedResults('Never crushed', '101', 'dword')
		isSavedResult('Avatar Radius second', '0.45;0.95', 'float', nil)
		success('Actived Never Crushed', 'Never crushed second', results3)
	else
		gg.toast('FAILED: Avatar radius not found')
		return
	end
end
	
function Test()
	local saved = isSavedResult('Fly Jump2', '200', 'dword')
	if saved == true then
		return
	end
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('200', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Fly Jump2', '200', 'dword')
		return
	end
	
	local results = gg.getResults('999')
	gg.editAll('122', gg.TYPE_DWORD)
	success('Actived Fly Jump', 'Fly Jump2', results)
end

function NoclipV2()
	if checkSavedResults('Noclip v2') then
		OptionHackActivation(noclip_hack_actived, 'Noclip v2', 'float', '5500', '0')
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1D;0;0.95;0.45::25', gg.TYPE_FLOAT)
	gg.refineNumber('0', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Noclip v2', '0', 'float')
		return
	end
	
	local results = gg.getResults('2')
	gg.editAll('5500', gg.TYPE_FLOAT)
	noclip_hack_actived = 1
	success('Actived Noclip V2', 'Noclip v2', results)
end

function PlayerSizeXYZ()
	local Xsize = gg.prompt({'X size'})
	local Ysize = gg.prompt({'Y size'})
	local Zsize = gg.prompt({'Z size'})
end

function FlyJump()
	if checkSavedResults('Fly Jump') then
		OptionHackActivation(flyhack_actived, 'Fly Jump', 'float', '1', '0')
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('70F;92F;0.25F;0;0::',gg.TYPE_FLOAT)
	gg.refineNumber('0', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Fly Jump', '0', 'float')
		return
	end
	
	local results = gg.getResults('50')
	gg.editAll('1', gg.TYPE_FLOAT)
	success('Actived Fly Jump', 'Fly Jump', results)
end

function HighJump()
	if checkSavedResults('High Jump') then
		gg.toast('High Jump is already activated, change jump height in :: OTHER ::')
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('70F;92F;0.25F;1',gg.TYPE_FLOAT)
	gg.refineNumber('1', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('High Jump', '1', 'float')
		return
	end
	
	local results = gg.getResults('20')
	gg.editAll(high_jump_value, gg.TYPE_FLOAT)
	success('Actived High Jump', 'High Jump', results)
end

function SuperTrampoline()
	local saved = isSavedResult('Super Trampoline', '0.43', 'float')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.43;1',gg.TYPE_FLOAT)
	gg.refineNumber('0.43', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Super Trampoline', '0.43', 'float')
		return
	end
	
	local results = gg.getResults('200')
	gg.editAll('1', gg.TYPE_FLOAT)
	success('Actived Super Trampoline', 'Super Trampoline', results)
end

function FlyGravity()
	local size = gg.prompt({'Gravity amount (0.1 = normal)'})	
	local saved = isSavedResult('Fly Gravity', size[1], 'float')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.45;0.45;0.95;0.1',gg.TYPE_FLOAT)
	gg.refineNumber('0.1', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Fly Gravity', '0.1', 'float')
		return
	end
	

	local results = gg.getResults('5')
	gg.editAll(size[1], gg.TYPE_FLOAT)
	success('Actived Fly Gravity', 'Fly Gravity', results)
end

function WPCameraHeight()
	local size = gg.prompt(
 		{'Camera amount [2; 180]'},
	 	{2, -76}, {'number'}
	)
	
	
	local saved = isSavedResult('WP Camera', size[1], 'float')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1.75;89;89;0;1.75',gg.TYPE_FLOAT)
	gg.refineNumber('1.75', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('WP Camera', '1.75', 'float')
		return
	end
	
	local results = gg.getResults('20')
	gg.editAll(size[1], gg.TYPE_FLOAT)
	success('Actived Weapon camera height (Use some weapon)', 'WP Camera', results)
end

function SpeedPlayer()
	local speed_value = gg.prompt(
 		{'Speed Amount (1 = normal) [1; 32]'},
	 	{8, -76}, {'number'}
	)
	
	speed = math.floor(speed_value[1] * 8)	
	
	local saved = isSavedResult('Speed', speed, 'float')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1D;8;8;1;1;1;-80F;80F',gg.TYPE_FLOAT)
	--gg.toast('Wait...')
	refineBucle(4, '8', 'float')
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Speed', speed, 'float')
		return
	end
	
	local results =  gg.getResults('4000')
	gg.editAll(speed, gg.TYPE_FLOAT)
	success('Changed player speed', 'Speed', results)
end

function ShotGunKill()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('200;50;350', gg.TYPE_FLOAT)
	gg.refineNumber('200', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Shotgun kill', '200', 'float')
		return
	end
	
	local results = gg.getResults('25')
	gg.editAll('9999999', gg.TYPE_FLOAT)
	success('Actived Shotgun kill', 'Shotgun Kill', results)
end

function CenterGunKill()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('240;150;500', gg.TYPE_FLOAT)
	gg.refineNumber('240', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Centergun kill', '240', 'float')
		return
	end
	
	local results = gg.getResults('25')
	gg.editAll('9999999', gg.TYPE_FLOAT)
	success('Actived CenterGun kill', 'Centergun Kill', results)
end

function PlayerLevel() -- 259,464;-3,729;0;3;32;1F;1F;1F;1F
	local level = gg.prompt(
 		{'What is your current level [1; 45]', 'Level Amount [1; 45]'},
	 	{1, 31}, {'number', 'number'}
	)
	
	
	local saved = isSavedResult('Level', level[2], 'dword')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0;1F;'..level[1]..';-3740~-3710;'..level[1]..';1F', gg.TYPE_DWORD)
	gg.refineNumber(level[1], gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Level', level[1], 'dword')
		return
	end
	
	local results = gg.getResults('100')
	gg.editAll(level[2], gg.TYPE_DWORD)
	success('Changed Level', 'Level', results)
end
	
	
function CubegunRandom()
	local pw = checkSavedResults('Cubegun random')
	if pw == true then
		CubeGunRainbowAndFavOption()
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.8F;444,444;444,418;1~68::80', gg.TYPE_DWORD)
	gg.refineNumber('1~68', gg.TYPE_DWORD)

	if gg.getResultsCount() <= 0 then
		notFoundError('Cubegun random', '0', 'dword')
		return
	end

	local results1 = gg.getResults('100')
	local results_changed = {}
	
	
	for i, result in ipairs(results1) do
    	if result.value ~= 30 and result.value ~= 1 then
            table.insert(results_changed, {address=result.address, value=result.value, flags=gg.TYPE_DWORD})
        end
    end
    
    gg.removeResults(results1)
    gg.loadResults(results_changed)
    local results = gg.getResults('30')
    
    success('Obtained', 'Cubegun random', results)
    CubeGunRainbowAndFavOption()
end


function CubegunAMMO()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('200F;-2147483648~2147483647;30;65536::100', gg.TYPE_DWORD)
	gg.refineNumber('-2147483648~2147483647;25~30')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	
	local results = gg.getResults('999')
	results = SearchWeaponAMMO(results, 'cube gun')
	local found = false
	
	for i, result in ipairs(results) do
    	if result.value == 30 then
        	found = true
        	break
    	end
	end
	
	if found == false then
		gg.toast('FAILED: The value "30" was not found')
		return
	end
	
	for i, v in ipairs(results) do
		if v.flags == gg.TYPE_DWORD then
			v.freeze = true
		end
	end
	gg.addListItems(results)
	values = nil
end

function CubegunChangeColor()
	ShowMaterialCubeList()
    local ID = gg.prompt({'Material ID (0 to 68)'}, {0}, {'number'})
    
    
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber('0.8F;444,444;444,418;1~68::80', gg.TYPE_DWORD)
    gg.refineNumber('1~68', gg.TYPE_DWORD)
    
    if gg.getResultsCount() <= 0 then
        notFoundError()
        return
    end
    
    local results1 = gg.getResults('100')
    local results_changed = {}

    
    for i, result in ipairs(results1) do
        if result.value ~= 30 and result.value ~= 1 then
            table.insert(results_changed, {address=result.address, value=ID[1], flags=gg.TYPE_DWORD})
        end
    end
    
    gg.removeResults(results1)
    gg.loadResults(results_changed)
    local results = gg.getResults('30')
    
    -- freeze values
    for i, result in ipairs(results) do
    	result.value = ID[1]
    	result.freeze = true
	end
    
    gg.addListItems(results)
    success('Changed CubeGun Color')
end


function CubegunBlockSpeed()	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('444444D;200;50;65536D', gg.TYPE_FLOAT)
	gg.refineNumber('50', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Cubegun speed', '50', 'float')
		return
	end
	local results = gg.getResults('15')
	gg.editAll('1777', gg.TYPE_FLOAT)
	success('Actived Cubegun max speed', 'Cubegun speed', results)
end

function CubegunDeleteSpeed()
	if checkSavedResults('Cubegun delete') then
		OptionHackActivation(cubegun_rapidremove_actived, 'Cubegun delete', 'dword', '0', '1')
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1F;1F;1F;0.3F;1;0.8F;444,444;1::160', gg.TYPE_DWORD)
	gg.refineNumber('1', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Cubegun delete', '1', 'dword')
		return
	end
	
	local results = gg.getResults('100')
	gg.editAll('0', gg.TYPE_DWORD)
	success('Actived Cubegun delete speed', 'Cubegun delete', results)
end
	
function SpawnWeaponID(weapon_id)
	local saved = isSavedResult('Spawn weapon fr', weapon_id, 'dword')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_C_HEAP | gg.REGION_ANONYMOUS)
	gg.searchNumber('1~70;1;2049;1F:100', gg.TYPE_DWORD)
	gg.refineNumber('1~70', gg.TYPE_DWORD)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local revert_results = gg.getResults('700')
	gg.editAll(weapon_id, gg.TYPE_DWORD)
	--weapon_data_revert = weapon_data_revert .. gg.getResults(9999)
	
	success('Spawned weapon, touch another weapon to activate (you have 10 seconds!)', 'Spawn weapon fr', revert_results)
	gg.sleep(spawnweapon_sleep)
	gg.setValues(revert_results)
end

function PlayerSizeAdvanced() -- Probably not visible to other players
	local saved = checkSavedResults('Giant avatar')
	if saved == true then
		GiantAvatarOption()
		return
	end
	
	local previous_effect = player_effect_id
	local function LoadResult(results)
		gg.clearResults()
		gg.loadResults(results)
		gg.getResults('999')
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('-1.5;-1.5;1;1;1;43D:180', gg.TYPE_FLOAT)
	gg.refineNumber('1', gg.TYPE_FLOAT)
	
	local results = gg.getResults('100')
	
	-- prevent game objects from increasing in size
	PlayerEffect('15')
	gg.sleep('2200')
	LoadResult(results)
	
	gg.refineNumber('2', gg.TYPE_FLOAT)
	if gg.getResultsCount() <= 0 then
		gg.toast('FAILED: No found results (player size)')
		return
	end
	
	-- set player speed and player hitbox
	local results2 = gg.getResults('10')
	local saved1 = checkSavedResults('Speed')
	local saved2 = checkSavedResults('Avatar hitbox')
	
	if saved1 == false then
		gg.clearResults()
		gg.searchNumber('1;0.00999999978;267D;0.4~0.6;0.3~1', gg.TYPE_FLOAT)
		gg.refineNumber('0.4~0.6', gg.TYPE_FLOAT)
		
		local hitbox_results = gg.getResults('999')
		success('Activing...', 'Avatar hitbox', hitbox_results)
		gg.clearResults()
	end
		
	if saved2 == false then
		gg.clearResults()
		gg.searchNumber('1D;8~20;1;1;1;-80F;80F',gg.TYPE_FLOAT)
		--gg.toast('Wait...')
		refineBucle(2, '8', 'float')
		
		local speed_results = gg.getResults('999')
		success('Activing...', 'Speed', speed_results)
		gg.clearResults()
	end
	
	gg.sleep('200')
	PlayerEffect('0')
	success('Obtained Player Size', 'Giant avatar', results2)
	GiantAvatarOption()
end
	

function PlayerSizeHardOOOOOOOOOLDDDDD() -- improved
	local saved = checkSavedResults('Giant avatar')
	if saved == true then
		GiantAvatarOption()
	end
	
	local function saveResultsGiantAvatar(result_name, save_result, changed_results)
		local saved_results = gg.getListItems()
		local to_remove = {}
		
		for i, result in ipairs(saved_results) do
			if result.name == result_name then
				table.insert(to_remove, {address=result.address, value=result.value, flags=gg.TYPE_FLOAT})
			end
		end
		
		gg.removeListItems(to_remove)
		gg.sleep('300')
		success('Activing...', save_result, changed_results)
	end
				
	
	local function LoadResult(result_name, save_name, type)
		local fuzzyTYPE
		
		if type == 'increased' then
			fuzzyTYPE = gg.SIGN_FUZZY_GREATER
		elseif type == 'decreased' then
			fuzzyTYPE = gg.SIGN_FUZZY_LESS
		end
		
		--local ss = checkSavedResults(result_name)
		local results = getSavedResults(result_name, 'float')
		--removeSavedResults(result_name, '0', 'float', true)
		gg.sleep('399')
		print(results, result_name)
		gg.loadResults(results)
		gg.getResults('99999')
		gg.searchFuzzy('0', fuzzyTYPE)
		
		
		local changed_results = gg.getResults('99999')
		saveResultsGiantAvatar(result_name, save_name, changed_results)
		gg.sleep('500')
		gg.clearResults()
	end
	
	local function ResetPlayerSize()
		PlayerEffect('20') -- instant death
		gg.clearResults()
		gg.sleep('5000')
		PlayerEffect('0')
		gg.clearResults()
		gg.sleep('500')
	end
	
	local function SetPlayerEffect(effect_id)
		PlayerEffect(effect_id)
		gg.clearResults()
		gg.sleep('200')
	end
	
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.1~4', gg.TYPE_FLOAT)
	refineBucle(15, '0.1~4', 'float')
	local results1 = gg.getResults('99999')
	success('Activing...', 'Avatar size', results1)
	
	---------- searchFuzzy hack
	-- Get GrowthPill
	SetPlayerEffect('15')
	LoadResult('Avatar size', 'Avatar2 size', 'increased')
	-- Get MousePill
	SetPlayerEffect('12')
	LoadResult('Avatar2 size', 'Avatar3 size', 'decreased')
	
	SetPlayerEffect('15')
	LoadResult('Avatar3 size', 'Avatar4 size', 'increased')
	
	SetPlayerEffect('12')
	LoadResult('Avatar4 size', 'Avatar5 size', 'decreased')
	
	SetPlayerEffect('15')
	LoadResult('Avatar5 size', 'Avatar6 size', 'increased')
	
	SetPlayerEffect('12')
	LoadResult('Avatar6 size', 'Avatar7 size', 'decreased')
	
	SetPlayerEffect('15')
	LoadResult('Avatar7 size', 'Avatar8 size', 'increased')
	
	SetPlayerEffect('12')
	LoadResult('Avatar8 size', 'Avatar9 size', 'decreased')
	
	SetPlayerEffect('15')
	LoadResult('Avatar9 size', 'Avatar10 size', 'increased')
	
	SetPlayerEffect('12')
	LoadResult('Avatar10 size', 'Avatar11 size', 'decreased')
	
	gg.sleep('2500')
	ResetPlayerSize()
	local results2 = getSavedResults('Avatar11 size', 'float')
	gg.loadResult(results2)
	refineBucle(10, '0.1~10', 'float')
	
	local results3 = gg.getResults('500')
	success('Obtained Player Size', 'Giant avatar', results3)
	
	-- remove all the `avatar size`
	removeSavedResults('Avatar size', '0', 'float', true)
	for x = 2, 10 do
		local result_name = 'Avatar'..tostring(x)
		removeSavedResults(result_name..' size', '0', 'float', true)
	end
	GiantAvatarOption()
end

function RailGunRapidFire()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('5;40;60;4097D', gg.TYPE_FLOAT)
	gg.refineNumber('5', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Railgun rapidfire', '5', 'float')
		return
	end
	
	
	local results = gg.getResults('100')
	gg.editAll('0.01', gg.TYPE_FLOAT)
	success('Actived  Rail Gun rapid fire', 'Railgun rapidfire', results)
end

function RevolverRapidFire() -- also dual revolver
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('100;500;150', gg.TYPE_FLOAT)
	gg.refineNumber('500', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Revolver rapidfire', '500', 'float')
		return
	end
	
	
	local results = gg.getResults('20')
	gg.editAll('9999999', gg.TYPE_FLOAT)
	success('Actived  Revolver rapid fire', 'Revolver rapidfire', results)
end

function Camera()
	local size = gg.prompt(
 		{'Camera amount [1; 280]'},
	 	{1, -76}, {'number'}
	)
	
	
	local saved = EditAndFreezeValues('Camera v2', 'float', size[1])
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('80;5;1.20000004768', gg.TYPE_FLOAT)
	gg.refineNumber('5', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Camera', '5', 'float')
		return
	end
	
	
	local results = gg.getResults('100')
	for i, result in ipairs(results) do
		result.value = size[1]
		result.freeze = true
	end
	
	success('Actived Camera', 'Camera', results)
end

function CameraV2()
	local size = gg.prompt(
 		{'Amount [1; 280]'},
	 	{1, -76}, {'number'}
	)
	
	
	local saved = isSavedResult('Camera v2', size[1], 'float')
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('80;5;1.20000004768', gg.TYPE_FLOAT)
	gg.refineNumber('80', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Camera v2', '80', 'float')
		return
	end
	
	
	local results = gg.getResults('100')
	gg.editAll(size[1], gg.TYPE_FLOAT)
	success('Actived Camera V2', 'Camera v2', results)
end

function PlayerEffect(effect_id, _cancel)
	local saved = isSavedResult('Player Effects (change to 0 to desactive it)', effect_id, 'dword')
	if saved == true then
		return
	end
	
	if _cancel == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_C_HEAP | gg.REGION_ANONYMOUS)
	gg.searchNumber('0.43F;20F;20F;1F;1;0~48:160', gg.TYPE_DWORD)
	gg.refineNumber('0~35', gg.TYPE_DWORD)
	
	local results = gg.getResults('700')
	gg.editAll(effect_id, gg.TYPE_DWORD)
	player_effect_id = effect_id
	success('Actived', 'Player Effects (change to 0 to desactive it)', results)
end

function RemoveCubegunsSimple(radius_value, duration)
	local scan_values = '0.45;0.45;0.95'
	local result_name_to_save = 'Avatar Radius second'
	
	if radius_belowplayer.bool == true then
		scan_values = '1D;0.45;0.95::60'
		result_name_to_save = 'Avatar Radius third'
	else
		if checkSavedResults('Avatar Radius third') then
			local avresults = getSavedResults('Avatar Radius third', 'float')
			-- change name to Avatar Radius second, with success function
			success('...', 'Avatar Radius second', avresults, nil, true)
		end
	end
	
	if radiussimple_disable_duration.bool == true then
		duration = nil
	end
	
	if radiussimple_antilag.bool == true then
		if checkSavedResults('Anti Lag') == false then
			AntiLagRadius()
		end
	end
	
	local function LoadResults(results)
		gg.clearResults()
		gg.loadResults(results)
		return gg.getResults('999')
	end
	
	local saved = isSavedResult(result_name_to_save, radius_value,  'float', duration, nil, false, radiussimple_antilag.bool)
	if saved == true then
		is_simpleradius_actived = true
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber(scan_values, gg.TYPE_FLOAT)
	gg.refineNumber('0.45;0.95', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('10')
	-- ANTI LAG :
	if radiussimple_antilag.bool == true then
		isSavedResult('Anti Lag', '9999', 'float')
		results = LoadResults(results)
	end
	-------------
	gg.editAll(radius_value, gg.TYPE_FLOAT)
	if radiussimple_disable_duration.bool == false then
		gg.sleep(duration)
		gg.editAll('0.45;0.95', gg.TYPE_FLOAT)
	end
	
	if radiussimple_antilag.bool == true and radiussimple_antilag.bool ~= true then
		AntiLagRadius('desactive')
	end
	
	is_simpleradius_actived = true
	success('Actived Remove Cubes', result_name_to_save, results)
end

function RemoveCubegunsXYZ()
	local playerRadius = gg.prompt(
		{'X/Z Size', 'Y Size', 'Duration (seconds multiplied 2x1, example: 75 is 155 seconds) [2; 75]', 'No Radius Duration', 'Make Crumbly Blocks', 'Anti Lag (Fast remove)'},
		{[1]='0.45', [2]='0.95', [3]=2, [4]=false, [5]=false, [6]=false},
		{[3]='number', [4]='checkbox', [5]='checkbox', [6]='checkbox'}
	)
	--gg.alert('rb: '..playerRadius[3])
	playerRadius[3] = string.gsub(tostring(math.floor(playerRadius[3] * 2)), '%.0', '')
	--gg.alert('r: '..playerRadius[3])
	
	if playerRadius[4] == true then
		playerRadius[3] = nil
	else
		if checkSavedResults('Avatar Radius second') then
			playerRadius[3] = playerRadius[3]..'000'
		end
	end
	
	-- change to Avatar Radius second:
	if checkSavedResults('Avatar Radius third') then
		local avtradius = getSavedResults('Avatar Radius third')
		-- change name
		success('...', 'Avatar Radius second', avtresults, nil, true)
	end
	
	local saved = isSavedResult('Avatar Radius second', playerRadius[1]..';'..playerRadius[2],  'float',  playerRadius[3], nil, playerRadius[5], playerRadius[6])
	if saved == true then
		return
	end
	
	if playerRadius[5] == true and checkSavedResults('Player Effects (change to 0 to desactive it)') == false then
		gg.toast('Use "All Blocks Destructibles" or "Spawm Proctection" first')
		return
	end
	
	local function CrumblyBlocksAndLoadResult(results)
		PlayerEffect('24')
		gg.clearResults()
		gg.loadResults(results)
		return gg.getResults('10')
	end
	
	local function LoadResults(results)
		gg.clearResults()
		gg.loadResults(results)
		return gg.getResults('999')
	end
	
	if playerRadius[6] == true then
		if checkSavedResults('Anti Lag') == false then
			AntiLagRadius()
		end
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.45;0.45;0.95', gg.TYPE_FLOAT)
	gg.refineNumber('0.45;0.95', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('10')
	-- edit anti lag hack :
	if playerRadius[6] == true then
		isSavedResult('Anti Lag', '9999', 'float')
		results = LoadResults(results)
	end
	------------------------
	
	gg.editAll(playerRadius[1]..';'..playerRadius[2], gg.TYPE_FLOAT)
	if playerRadius[5] == true then
		results = CrumblyBlocksAndLoadResult(results)
	end
	
	if playerRadius[4] == false then
		gg.sleep(playerRadius[3]..'000')
		gg.editAll('0.45;0.95', gg.TYPE_FLOAT)
	end
	-- disable "make crumbly blocks" :
	if playerRadius[5] == true then
		if is_infhealth_actived == true then
			PlayerEffect('17')
		else
			PlayerEffect('25')
		end
	end
	-------------------------
	
	if playerRadius[6] == true and playerRadius[4] ~= true then
		AntiLagRadius('desactive') -- reset anti lag
	end
	
	success('Actived Remove Cubes', 'Avatar Radius second', results)
	-- continue code :
	if avtradius ~= nil then
		success('...', 'Avatar Radius third', avtradius, nil, true)
	end
end
	

function AutoRemoveCubes()
	local maxRadius = gg.prompt(
		{
			'Maximum XYZ (example: 15 radius)',
			'Duration per radius (seconds) [3; 25]',
			'No impulse (Avoid not being pushed by the radius)',
			'Make Crumbly Blocks (slow)'
		},
		{[1]=9, [2]=5, [3]=false, [4]=false},
		{[1]='number', [2]='number', [3]='checkbox', [4]='checkbox'}
	)
	
	
	local saved = isSavedResult('Avatar Radius', '0.45;0.95',  'float', maxRadius[1], maxRadius[2]..'000', maxRadius[3], nil, maxRadius[4])
	if saved == true then
		return
	end
	
	if maxRadius[3] == true then
		PlayerMovesValue('...', '...', false, true)
	end
	
	if maxRadius[4] == true and checkSavedResults('Player Effects (change to 0 to desactive it)') == false then
		gg.toast('Use All Blocks Destructibles or Self Heal first')
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('0.45F;0.45F;0.95F', gg.TYPE_FLOAT)
	gg.refineNumber('0.45;0.95', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('100')
	AvatarRadius(maxRadius[1], maxRadius[2]..'000', maxRadius[4])
	--PlayerEffect('17')
	success('Actived Auto remove cubes', 'Avatar Radius', results)
end

function BazookaAMMO()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('30F;150F;-2147483648~2147483647;12::100', gg.TYPE_DWORD)
	gg.refineNumber('-2147483648~2147483647;12')
	
	if gg.getResultsCount() <= 0 then
		notFoundError()
		return
	end
	
	local results = gg.getResults('999')
	results = SearchWeaponAMMO(results)
	
	local found = false -- Avoid being banned
	
	for i, result in ipairs(results) do
    	if result.value == 12 then
        	found = true
        	break
    	end
	end
	
	if found == false then
		gg.toast('FAILED: The value "12" was not found')
		return
	end
	
	for i, v in ipairs(results) do
		v.freeze = true
	end
	gg.addListItems(results)
	values = nil
end
	
function ZoomCamera() -- rail gun method
	local size = gg.prompt(
 		{'Zoom amount [5; 260]'},
	 	{5, -76}, {'number'}
	)
	local saved = EditAndFreezeValues('Zoom', 'float', size[1])
	if saved == true then
		return
	end
	
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('5;40;60', gg.TYPE_FLOAT)
		
	gg.sleep(200)
	gg.refineNumber('60', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Zoom', '60', 'float')
		return
	end
	
	local results = gg.getResults('30')
	for i, result in ipairs(results) do
		result.value = size[1]
		result.freeze = true
		result.name = 'Zoom'
	end
	gg.addListItems(results)
end

function BazookaCrash()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('1000;150;30', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Bazooka crash', '1000;150;30', 'float')
		return
	end
	
	local results = gg.getResults('50')
	gg.editAll('3.4E38', gg.TYPE_FLOAT)
	success('Actived Bazooka crash + radius', 'Bazooka crash', results)
end

function ImpulseCrash()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('3000;1500', gg.TYPE_FLOAT)
		
	gg.refineNumber('3000', gg.TYPE_FLOAT)
	if gg.getResultsCount() <= 0 then
		notFoundError('Impulse crash', '3000', 'float')
		return
	end
	
	local results = gg.getResults('50')
	gg.editAll('3.4E38', gg.TYPE_FLOAT)
	impulse_gun_value = '3.4E38'
	success('Actived Impulse crash', 'Impulse crash', results)
end

function ShotgunCrash()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('200;50;350', gg.TYPE_FLOAT)
	gg.refineNumber('200', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Shotgun crash', '200', 'float')
		return
	end
	
	local results = gg.getResults('50')
	gg.editAll('3.4E38', gg.TYPE_FLOAT)
	
	shotgun_damage_value = '3.4E38'
	success('Actived Shotgun crash', 'Shotgun crash', results)
end

function CentergunCrash()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber('240;150;500', gg.TYPE_FLOAT)		
	gg.refineNumber('240', gg.TYPE_FLOAT)
	
	if gg.getResultsCount() <= 0 then
		notFoundError('Centergun crash', '240', 'float')
		return
	end
	
	local results = gg.getResults('50')
	gg.editAll('3.4E38', gg.TYPE_FLOAT)
	success('Actived Centergun crash', 'Centergun crash', results)
end
	
while true do
    if gg.isVisible() then
        gg.setVisible(false)
        if is_main_menu_returned ~= false then
			Dazeer()
		else
			if is_accessorysetting_returned == true then
				AccessorySetOption()
			elseif is_giantavatar_returned == true then
				GiantAvatarOption()
			elseif is_sensivity_returned == true then
				SensivityOption()
			elseif is_setteam_returned == true then
				SetTeamOption()
			elseif is_setcubesize_returned == true then
				CubeGunShapeEditOption()
			end
		end
    else
        if Dmenu == 1 then
            gg.setVisible(false) 
            if is_main_menu_returned ~= false then
				Dazeer()
			else
				if is_accessorysetting_returned == true then
					AccessorySetOption()
				elseif is_giantavatar_returned == true then
					GiantAvatarOption()
				elseif is_sensivity_returned == true then
					SensivityOption()
				elseif is_setteam_returned == true then
					SetTeamOption()
				elseif is_setcubesize_returned == true then
					CubeGunShapeEditOption()
				end
			end
        end 
    end 
end 

