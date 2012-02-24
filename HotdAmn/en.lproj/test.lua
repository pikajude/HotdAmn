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
    hotdamn.say(table.concat(args, " "))
end, -2, {hotdamn.arg.all})
hotdamn.register_cmd("me", function(args)
    hotdamn.action(table.concat(args, " "))
end, -2, {hotdamn.arg.all})