----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local isOpen = false
local function BurgerShot(pedData)
	if (isOpen) then return end
	isOpen = true
	local Menues = settings.systems.shops.burgershot.menues
	
	local oldDim = getElementDimension(localPlayer)
	local dim = math.random(10000,65535)
	
	local skin, x, y, z, rz = unpack(pedData)
	local ped = createPed(skin, x, y, z, rz)
	setElementDimension(ped, dim)
	setElementInterior(ped, getElementInterior(localPlayer))
	
	
	setPedAnimation(localPlayer)
	--setElementFrozen(localPlayer, true)
	setElementDimension(localPlayer, dim)
	setElementRotation(localPlayer, 0, 0, 0)
	local px,py,pz = getElementPosition(localPlayer)
	setCameraMatrix(px+1.3, py-1.3, pz+1, x, y, z, 0, 70)
	toggleAllControls(false, true, true)
	
	local currentProduct = 1
	local erx, ery, erz = 335, 23, 73
	local product = createObject(Menues[currentProduct].objectID, 0, 0, 0, 0, 0, 0)
	setElementDimension(product, dim)
	setElementInterior(product, getElementInterior(localPlayer))
	
	setTimer(function()
		attachElementToBone(product,ped,11,0.25,0,0.2,533,353,206)
		setPedAnimation ( ped, "food", "shp_tray_lift", 1, false, false, true )
	end, 150, 1)
	
	local animTimer = nil
	changeMenu = function(nr)
		freezeProductList(750)
		setPedAnimation ( ped, "food", "shp_tray_return", 1, false, false, true )
		animTimer = setTimer(function()
			currentProduct = nr
			setElementModel(product, Menues[currentProduct].objectID)
			setPedAnimation ( ped, "food", "shp_tray_lift", 1, false, false, true )
		end, 500, 1)
	end
	closeIt = function()
		isOpen = false
		if (isTimer(animTimer)) then killTimer(animTimer) end
		destroyProductSelect()
		setElementFrozen(localPlayer, false)
		setElementDimension(localPlayer, oldDim)
		setCameraTarget(localPlayer, localPlayer)
		detachElementFromBone(product)
		destroyElement(product)
		destroyElement(ped)
		toggleAllControls(true, true, true, true)
		triggerServerEvent("toggleGhostMode", localPlayer, localPlayer, false)
	end
	buyMenu = function(nr)
		destroyProductSelect()
		
		local buyFix = function(nr)
			bool = true
			if (nr==2) then bool = false end
			closeIt()
			triggerServerEvent("burgerShotBuy", localPlayer, currentProduct, bool)
		end
		local _price = Menues[currentProduct].price
		displayProductSelect("Burger Shot", {[1] = {title = "Hier Essen", price = _price}, [2] = {title = "Zum Mitnehmen", price = _price}}, function()end, buyFix, closeIt, "files/images/productlist/burgershot.png")
	end
	
	displayProductSelect("Burger Shot", Menues, changeMenu, buyMenu, closeIt, "files/images/productlist/burgershot.png")
end
addEvent("burgerShotHello", true)
addEventHandler("burgerShotHello", root, BurgerShot)