local function addItems(_keyPressed)

    local key = _keyPressed; -- Store the parameter in a local variable.
    print(key); -- Prints the pressed key to the console.

    -- We test if the correct key is pressed.
    if key == 26 then
    	local player = getSpecificPlayer(0);    -- Java: get player one
        local inv = player:getInventory();      -- Java: access player inv

        -- Java: add the actual items to the inventory
        inv:AddItem("Base.TreeBranch");

	end

end

-- This will be fired whenever a key is pressed.
Events.OnKeyPressed.Add(addItems);