require "recipecode"


-- Sets the spear condition based on woodwork level.
function Recipe.OnCreate.CreateSpear(items, result, player, selectedItem)

    local lvl = player:getPerkLevel(Perks.Woodwork);
    local conditionMax = result:getConditionMax();
    local conditionMin = conditionMax / 2;
    local step = (conditionMax - conditionMin) / 2;
    local bonus = step * lvl;
    local condition = conditionMin + bonus;

    if condition > conditionMax then
        result:setCondition(conditionMax);
    else
        result:setCondition(condition);
    end

end


-- Sets the resulting condition to the addon condition minus half of how bad the spear is.
function Recipe.OnCreate.UpgradeSpear(items, result, player, selectedItem)

    local spear_status = 0;
    local addon_status = 0;
    local result_condition = result:getConditionMax();
    local repair_count = 0;

    for i=0,items:size() - 1 do
        if items:get(i):getType() == "SpearCrafted" then
            local condition_max = items:get(i):getConditionMax();
            local condition_curr = items:get(i):getCondition();
            spear_status = condition_curr / condition_max;
        end
    end

    for i=0,items:size() - 1 do
        if instanceof(items:get(i), "HandWeapon") and items:get(i):getType() ~= "SpearCrafted" then
            local condition_max = items:get(i):getConditionMax();
            local condition_curr = items:get(i):getCondition();
            repair_count = items:get(i):getHaveBeenRepaired();
            addon_status = condition_curr / condition_max;
        end
    end

    if addon_status > spear_status then
        result_condition = result_condition * spear_status;
    else
        result_condition = result_condition * addon_status;
    end

    if result_condition < 2 then
        result_condition = 2;
    end

    result:setHaveBeenRepaired(repair_count);
    result:setCondition(result_condition);

end


-- When we reclaim the weapon from a spear we get the weapon back.
-- We also want to return the spear with appropriate condition
function Recipe.OnCreate.DismantleSpear(items, result, player, selectedItem)

    local result_condition = result:getConditionMax();
    local condition_factor = selectedItem:getCondition() / selectedItem:getConditionMax();

    result_condition = result_condition * condition_factor;
    result:setCondition(result_condition);
    result:setHaveBeenRepaired( selectedItem:getHaveBeenRepaired() );

    local spear = player:getInventory():AddItem("Base.SpearCrafted");
    local spear_condition = spear:getConditionMax() * condition_factor;
    spear:setCondition(spear_condition);

end
