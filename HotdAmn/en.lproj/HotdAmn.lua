-----------------------------
-- HotdAmn built-in commands.
-- Created by Joel Taylor.
-----------------------------

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

hotdamn.register_cmd("ban", function(args)
    hotdamn.ban(hotdamn.current_room(), args[1])
end, 1, {hotdamn.arg.username})

hotdamn.register_cmd("unban", function(args)
    hotdamn.unban(hotdamn.current_room(), args[1])
end, 1, {hotdamn.arg.any})

hotdamn.register_cmd("whois", function(args)
    hotdamn.whois(args[1])
end, 1, {hotdamn.arg.username})

local promote = function(args)
    if #args > 1 then
        hotdamn.promote(hotdamn.current_room(), args[1], args[2])
    else
        hotdamn.promote(hotdamn.current_room(), args[1])
    end
end

hotdamn.register_cmd("promote", promote, -2, {hotdamn.arg.username, hotdamn.arg.privclass})
hotdamn.register_cmd("demote", promote, -2, {hotdamn.arg.username, hotdamn.arg.privclass})

hotdamn.register_cmd("topic", function(args)
    if #args == 0 then
        hotdamn.print(hotdamn.current_room(), "Topic for <b>" .. hotdamn.current_room() .. "</b>: " .. hotdamn.gettopic(hotdamn.current_room()))
    else
        hotdamn.settopic(hotdamn.current_room(), table.concat(args, " "))
    end
end, -1, {hotdamn.arg.all})

hotdamn.register_cmd("title", function(args)
    if #args == 0 then
        hotdamn.print(hotdamn.current_room(), "Title for <b>" .. hotdamn.current_room() .. "</b>: " .. hotdamn.gettitle(hotdamn.current_room()))
    else
        hotdamn.settitle(hotdamn.current_room(), table.concat(args, " "))
    end
end, -1, {hotdamn.arg.all})