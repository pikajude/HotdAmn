function buddy(hd, args)
    print("called from ObjectiveC")
end

hotdamn:register_cmd("buddy", buddy, 2, {{"add", "remove", "list"}, hotdamn.arg.username})