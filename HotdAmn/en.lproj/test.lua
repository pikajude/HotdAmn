hotdamn.register_cmd("say", function(args)
    hotdamn.say(table.concat(args, " "))
end, -2, {hotdamn.arg.all})

hotdamn.register_cmd("join", function(args)
    if #args == 0 then
        hotdamn.join(hotdamn.current_room())
    else
        for _, v in pairs(args) do
            if v:sub(0, 1) == "#" then
                hotdamn.join(v)
            else
                hotdamn.join("#" .. v)
            end
        end
    end
end, -1, {hotdamn.arg.any})

hotdamn.register_cmd("part", function(args)
    if #args == 0 then
        hotdamn.part(hotdamn.current_room())
    else
        for _, v in pairs(args) do
            if v:sub(0, 1) == "#" then
                hotdamn.part(v)
            else
                hotdamn.part("#" .. v)
            end
        end
    end
end, -1, {hotdamn.arg.any})