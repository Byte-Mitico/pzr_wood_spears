require "recipecode"


-- get the spear, lower its condition according to woodwork perk level
-- also lower the used knife condition
function Recipe.OnCreate.CreateSpear(items, result, player, selectedItem)

    print("Custom CreateSpear()");

    local conditionMax = 2 + player:getPerkLevel(Perks.Woodwork);
    conditionMax = ZombRand(conditionMax, conditionMax + 2);
    if conditionMax > result:getConditionMax() then
        conditionMax = result:getConditionMax();
    end
    if conditionMax < 2 then
        conditionMax = 2;
    end
    result:setCondition(conditionMax)
    
    for i=0,items:size() - 1 do
        if instanceof (items:get(i), "HandWeapon")
		and (items:get(i):getCategories():contains("SmallBlade") or items:get(i):getCategories():contains("LongBlade") or items:get(i):getCategories():contains("Axe"))then
            items:get(i):setCondition(items:get(i):getCondition() - 1);
        end
        if items:get(i):getType() == "SharpedStone" and ZombRand(3) == 0 then
            player:getInventory():Remove(items:get(i))
        end
    end
end


-- get a mix of spear & upgrade item to do a correct condition of the result
-- we take the craftedSpear condition and substract the attached weapon condition
function Recipe.OnCreate.UpgradeSpear(items, result, player, selectedItem)

    print("Custom UpgradeSpear()");

    local conditionMax = 0;
    for i=0,items:size() - 1 do
        if items:get(i):getType() == "SpearCrafted" then
            conditionMax = items:get(i):getCondition()
        end
    end
    
    for i=0,items:size() - 1 do
        if instanceof (items:get(i), "HandWeapon") and items:get(i):getType() ~= "SpearCrafted" then
            conditionMax = conditionMax - ((items:get(i):getConditionMax() - items:get(i):getCondition())/2)
        end
    end
    
    if conditionMax > result:getConditionMax() then
        conditionMax = result:getConditionMax();
    end
    if conditionMax < 2 then
        conditionMax = 2;
    end

    result:setCondition(conditionMax);
end


-- when we reclaim the weapon from a spear we get the weapon back
-- we also want to return the spear with appropriate condition
function Recipe.OnCreate.DismantleSpear(items, result, player, selectedItem)

    print("Custom DismantleSpear()");

    local conditionMax = selectedItem:getCondition();

    if conditionMax > selectedItem:getConditionMax() then
        conditionMax = selectedItem:getConditionMax();
    end
    if conditionMax < 2 then
        conditionMax = 2;
    end
    local spear = player:getInventory():AddItem("Base.SpearCrafted");
    spear:setCondition(conditionMax);
end
