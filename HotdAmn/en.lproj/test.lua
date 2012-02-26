local generate = function(str)
    return function(args)
        if #args == 0 then
            hotdamn[str](hotdamn.current_room())
        else
            for _, v in pairs(args) do
                if v:sub(0, 1) == "#" then
                    hotdamn[str](v)
                else
                    hotdamn[str]("#" .. v)
                end
            end
        end
    end
end

hotdamn.register_cmd("join", generate("join"), -1, {hotdamn.arg.any})

hotdamn.register_cmd("part", generate("part"), -1, {hotdamn.arg.any})

hotdamn.register_cmd("say", function(args)
    hotdamn.say(hotdamn.current_room(), table.concat(args, " "))
end, -2, {hotdamn.arg.all})

hotdamn.register_cmd("me", function(args)
    hotdamn.action(hotdamn.current_room(), table.concat(args, " "))
end, -2, {hotdamn.arg.all})

hotdamn.register_cmd("kick", function(args)
    username = args[1]
    table.remove(args, 1)
    if #args == 0 then
        hotdamn.kick(hotdamn.current_room(), username)
    else
        hotdamn.kick(hotdamn.current_room(), username, table.concat(args, " "))
    end
end, -2, {hotdamn.arg.username, hotdamn.arg.all})