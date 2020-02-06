function print_table(mytable)
	for k,v in ipairs(mytable) do
		print(k,v)
	end
end

function mysplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

file = app.activeSprite
filename = mysplit(file.filename, ".")[1]

for i,tag in ipairs(file.tags) do
	if string.sub(tag.name, 1, 1) ~= "!" then
		newfile = Sprite(app.activeSprite)
		app.command.GotoFirstFrame()
		for i,frame in ipairs(file.frames) do
			if i < tag.fromFrame.frameNumber or i > tag.toFrame.frameNumber then
				app.command.RemoveFrame()
			else
				app.command.GotoNextFrame()
			end
		end
		local tagname = tag.name
		if string.sub(tag.name, 1, 1) == "#" then
			app.command.AutocropSprite()
			tagname = string.sub(tagname, 2)
		end
		newfile:saveCopyAs(filename .. "_" .. tagname .. ".gif")
		newfile:close()
		app.activeSprite = file
	end
end
