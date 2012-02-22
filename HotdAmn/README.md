HotdAmn Scripting API
=====================

    hotdamn:register_cmd(cmdname :: string, body :: function(2) [, arity :: number, types :: {mixed}])

Registers a command, i.e. `/join` or `/part`. (In fact, built-in commands are internally implemented using the Lua API.)

* `cmdname` - the name of the command to be registered. If a command exists with the same name, this function will trigger an error.
* `body` - a function that takes two arguments:
	* the HotdAmn object
	* a table of arguments passed to the command (i.e. a table of strings)
* `arity` (optional) - the number of arguments the command expects (see Command Arity below)
* `types` (optional) - the types of the expected arguments (see Argument Types below)

` `

    hotdamn:hook(event :: string, callback :: function(3))

* `event` - one of "join", "part", "message"
* `callback` - takes two arguments:
	* HotdAmn proxy object (see HotdAmn Proxy Object)
	* the user that caused the message
	* the contents of the message (for join/part this will be blank)

` `
Command Arity
-------------
"Arity" is how many arguments your command expects. Of course, some commands may have a set number of arguments, none, or a variable number. Every situation is accounted for.

* A command with arity `0` will accept no arguments.
* Passing a positive integer (`3`) will cause the command to require that many arguments.
* Passing a negative integer (`-2`) will cause the command to require AT LEAST `abs(n) - 1` arguments. A `-4` arity function will require at least three arguments but can have more. A `-1` arity function can have as many arguments as you want--this is ideal for commands that are meant to take a text string. And so on.
	
Argument Types
--------------
There are two argument types:

* A table of possible strings. This is useful for commands that have certain sub-commands, like `/buddy add` or `/buddy list`.
* An integer. These are special HotdAmn constants:
	* `hotdamn.arg.any` - unspecified. This will prevent tab completion.
	* `hotdamn.arg.room` - one of the rooms that the user is currently in
	* `hotdamn.arg.privclass` - any privclass in the current room
	* `hotdamn.arg.user` - any user(name) in the current room
	* `hotdamn.arg.all` - all of the above.
	* Adding two of these constants together will result in tab-completion for both types.
	
For example, the `buddy` command is defined (simplified) as follows:

    hotdamn:register_cmd("buddy", buddy, 2, {{"add", "remove"}, hotdamn.arg.user})

which will then tab-complete "add" or "remove" for the first argument, and any of the current users for the second argument. Likewise, the `kick` command is defined:

    hotdamn:register_cmd("kick", kick, -2, {hotdamn.arg.user, hotdamn.arg.all})

When the command has a negative arity, the last argument type specified in the `type` list will be used for the rest of the arguments.