function in_bounds(img, x, y)
	bounds = img.cel.bounds
	if x < bounds.x then
		return false
	end
	if x > bounds.x + bounds.width then
		return false
	end
	if y < bounds.y then
		return false
	end
	if y > bounds.y + bounds.height then
		return false
	end
	return true
end

function get_pixel_color(img, x, y)
	if in_bounds(img, x, y) then
		return Color(app.pixelColor.rgbaR(img:getPixel(x, y)),
			app.pixelColor.rgbaG(img:getPixel(x, y)),
			app.pixelColor.rgbaB(img:getPixel(x, y)),
			app.pixelColor.rgbaA(img:getPixel(x, y)))
	end
	return Color(0, 0, 0, 0)
end

function average_4x4(img, threshold, x, y)
	local pixelarray = {}
	local arrayindex = 0
	for xi = 0, 3, 1 do
		for yi = 0, 3, 1 do
			if get_pixel_color(img, x+xi, y+yi).alpha >= threshold then
				pixelarray[arrayindex] = get_pixel_color(img, x+xi, y+yi)
				arrayindex = arrayindex + 1
			end
		end
	end
	-- if we have no averageColor skip all the rest
	if pixelarray[0] ~= nil then
		averageColor = Color(0, 0, 0, 255)
		for pair in pairs(pixelarray) do
			color = pixelarray[pair]
			averageColor.red = averageColor.red + color.red/arrayindex
			averageColor.green = averageColor.green + color.green/arrayindex
			averageColor.blue = averageColor.blue + color.blue/arrayindex
		end

		-- paint the 4x4 pixel with the averageColor!
		for xi = 0, 3, 1 do
			for yi = 0, 3, 1 do
				img:drawPixel(x+xi, y+yi, averageColor)
			end
		end
	end
end

function average_image_4x4(img, threshold)
	for x = 0, img.width, 4 do
		for y = 0, img.height, 4 do
			average_4x4(img, threshold, x, y)
		end
	end
end

function delete_transparent_bits(img, threshold)
	for x = 0, img.width, 1 do
		for y = 0, img.height, 1 do
			if app.pixelColor.rgbaA(img:getPixel(x, y)) < threshold then
				img:drawPixel(x, y, Color(0, 0, 0, 0))
			else
				if app.pixelColor.rgbaA(img:getPixel(x, y)) >= threshold then
					newColor = get_pixel_color(img, x, y)
					img:drawPixel(x, y, newColor)
				end
			end
		end
	end
end

function is_same_color(color1, color2)
	if color1.r == color2.r and
			color1.g == color2.g and
			color1.b == color2.b and
			color1.a == color2.a then
		return true
	else
		return false
	end
end

-- function add_color_to_list(mycolor, mylist)
-- 	found_color = false

-- 	for i, entry in ipairs(mylist) do
-- 		if is_same_color(entry["color"], mycolor) then
-- 			found_color = true
-- 			entry["count"] = entry["count"] + 1
-- 	end
-- 	if found_color == false then
-- 		mylist[0] = 0
-- 	return mylist
-- end

threshold = 250

for i, cel in ipairs(app.activeSprite.cels) do
	average_image_4x4(cel.image, threshold)
	delete_transparent_bits(cel.image, threshold)
end



print("steps after running this script:")
print(" - load original palette")
print(" - set image color mode to indexed")
print(" - resize image back to original scale")

-- TODO
-- tweaks:
-- 		change averageColor to most common color (within some error margin)
-- 		discard 4x4 pixel if there's less then 4? opaque pixels
-- 		don't touch any pixel if all pixels are opaque/most common color too?
-- 
-- automatically interpolate selected tag via DAINapp CLI
-- automate post processing (load palette, set color mode, resize)