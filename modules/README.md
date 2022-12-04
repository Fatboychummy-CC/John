# Modules

John likes modules. He says they're what allow him to talk, so more is better!
Every module follows a specific pattern, which John likes to call a
"specification."

## Specification (John-side)

This is the specification for how John reacts to things. For code
specifications, go to the [code-side specifications](#specification-code-side).

### Phrases (John-side)

Phrases are what John responds to. They come in three parts, `openers`,
`commands`, and `arguments`. Though note that arguments are technically part of
the command.

If you do not have a prefix set, John will only respond if you start your phrase
with "Hey John, ". For more information about prefixes, see the
[prefixes section](#prefixes).

Note that any capitalization is stripped from all phrases to make them easier to
parse.

#### Openers (John-side)

An opener is simply a polite start to a command. Without these, John may act a
little rudely to you in response. It's rude to not use an opener, after all.

Some examples of openers are the following:

> Can you please ...

> Can you ...

> Please ...

> Would you be a dear and ...

You can add openers if you'd like, and specify whether they are 'rude' or not.

#### Commands (John-side)

A command is simply your request for John. For example, you may ask John to:

> Grab me < items >.

> Take < items > from my inventory.

> Calculate < calculation >

#### Arguments (John-side)

Arguments are part of a command, for example the items in "Grab me < items >".
John sometimes doesn't understand these the best, so you need to be specific
about them. Note the more arguments there are, the harder it becomes for John to
parse them. In most cases, John should understand a comma-seperated list if
there needs to be multiple arguments.

Arguments wrapped in parenthesis are to be treated exactly like they're shown.
For example, if you state,

> Hey John, can you give me 32 (cobblestone)?

John will take "cobblestone" literally, and will not try to correct you in any
way.

#### Overlapping Phrases (John-side)

Sometimes some phrases are very similar. For this reason, John will first think
about which module best fits the command given, then will run that.

If you absolutely need a specific module but John keeps picking another module,
prepend your command with parenthesis and the module's identifier, like so:

> Hey John, **(inventory)** Can you give me 32 iron ingots?

The above may be needed as `give me` is a phrase corresponding to both the
`inventory` module and `console` module. It should not be needed for a phrase
like this, but if you have an item with the name `console` in it you are trying
to grab, the `console` module may take over.

You can list all of the loaded modules (and their identifiers) by asking John
for them.

> Hey John, **what are the currently loaded modules**?

#### Known words (John-side)

Known words are specific words that John understands which allows for command
chaining. Commands should never require known words to be used.

For example, if you asked John the following:

> Hey John, can you craft 32 sticks **and** give **them** to me?

John here would take note of the words `and` and `them`, split the question into
two commands, and use the result of the first command as the input to the second
command.

A current tree of known words and the actions they do are as follows:

- `and`, `then`
  - Splits the left and right side of the word into seperate commands.
  - `them`, `it`
    - Use the result of the previous command.

Commands can be chained to any length.

> Hey John, can you craft 3 oak wood and craft a bowl then give it to me?

#### Confirmations (John-side)

Sometimes John isn't 100% sure the exact thing you want, and will ask if he has
your command correct. Simply responding yes or no without the prefix
works. Your response will be captured based on your [silence](#silence) rule.

### Hurt (errors, john-side)

When an error occurs, John will tell you something along the lines of:

> Ouch, I tried to do what you asked but I accidentally stubbed my toe.

When this happens, ask for the last 5 lines or so that were written to the
console, or look at the computer to see what went wrong.

> Hey John, (console) can you give me the last 5 lines of the console?

Note that 'give me' is for both the `inventory` and `console` module, so here we
need to ask specifically for the `console` module, as the `inventory` module
takes higher priority in most cases.

### Prefixes

By setting a prefix, you can instead give John commands like so:

> !Can you please grab me 64 cobblestone.

Setting a prefix will prevent John from responding to anything without a prefix.

To set a prefix, simply say:

> Hey John, set prefix to "< prefix >"

> Hey John, set prefix to "!"

John will, from that point forward, only respond to messages with the
exclamation-mark prefix.

### Silence

Sometimes server owners don't like it when John talks to you, which is quite
rude if you ask me. So there exists a way to silence what he'd normally say out
loud, and he will instead whisper it to you and only you (and vice versa).

> Hey John, silence.

Doing this will enable chat capturing, as well as make it so John will whisper
directly to you.

To disable this, simply tell John that he can talk again.

> Hey John, we can talk again.

### General note on responses

John talks very human-like, and states things as-is. If you do not use an
opener, depending on the module, John may either refuse the request or just
respond unhappily.

## Specification (code-side)

### Module structure requirements

Each module should be contained within a folder.

#### init.lua

The folder must have an `init.lua` file at its root. This file can be structured
however you wish it to be structured, however it **must** return the following
methods:

- `test(message: string): number`
  - `message` is the command given by the user, tokenised.
  - This method is used to determine what module to use in the case that no
    module identifier has been given.
  - The return value should be a number from 0-100 for how sure your module is
    that this message is meant for it.
- `run(message: string, rude: boolean, command_position: integer?, queue_length: integer?)`
  - `message` is the command given by the user, tokenised.
  - `rude` is `false` if the user gave an opener, `true` otherwise.
  - `command_position` is the position in the command queue that this command is
    at, given the user inputted a multipart command.
  - `queue_length` is the length of the command queue, given the user inputted a
    multipart command.

##### Optional methods

- `task()`
  - If this method is returned by the `init.lua` file, this will be ran in
    parallel with the main system. If it crashes, a notification will be sent to
    the user. Return a value with the key `task_error` to customize this
    notification.

#### spec.lua

Each module requires a `spec.lua` file at the root of its folder, which returns
a table containing the following key-value pairs:

- `commands: {...: string}`
  - A table of patterns that this module looks for at the start of every
    command. Don't worry about adding `^` to the start of the pattern, the
    module loader will to this for you. Remember that the system will pass
    everything as lowercase strings, you don't need to check for anything
    uppercase.
- `name: string`
  - The friendly name of the module. This can be multiple words.
- `description: string`
  - The description of the module.
- `identifier: string`
  - The identifier for the module. This must be a single word (though hyphens
    can be used in place of spaces).

### Module environment

Each module's `run` function will be run in an environment with a few helper
functions available.

The `run` function is ran by a coroutine handler that will not block other

#### Module helper functions

- `confirm(message: string): boolean`
  - This function requests a confirmation from the user using the message given.
    The message must be formatted in such a way that a `yes` or `no` are valid
    answers.
  - If the user states `yes`, this function will return `true`. It is expected
    that the command should continue as normal.
  - If the user states `no`, this function will return `false`, and it is
    expected that the module immediately runs `return be_specific()`.
- `be_specific()`
  - This function returns a message that asks the user to be more specific about
    what they are asking for.
  - Typical usage is to tail-call this after a failed `confirm()`.
- `say(message: string)`
  - Simply say something to the user. Obeys the current silence setting.
- `request(message: string): string`
  - Request a response from the user. The next message sent by the user will be
    used as the response, no need for the prefix. Response will not be
    tokenised.
  - This will block any commands from being run (as it will take it as input),
    so use this only when absolutely needed.
- `tokenise(value: string): table`
  - Convert the input string into a table of tokens -- words separated by
    spaces. Items in quotations will stay together.
- `levenshtein(s1: string, s2: string): number`
  - Compare two strings to see how similar they are. Numbers closer to zero are
    better.

#### Return

Whatever value you return is what will be sent to the user. If you `return nil`,
a generic message will be sent back stating that nothing has happened. Thus,
ensure you return something rather than using `say` always.

### Phrases (code-side)

Phrases are what are used to decide which module the command should be passed
to. For example, if your module returns the following table of phrases:

```lua
{
  "grab me",
  "grab",
  "get me",
  "get",
  "give me",
  "give"
} -- This is what is returned by the inventory module.
```

The system will first parse out any openers, then parse the rest by running a
match with every phrase. If multiple phrases match the opener, each module who
has a matching phrase will have their `test` methods executed with the full
command. The module that returns the highest certainty factor (0-100) will then
be `run`.

There isn't much else to say for the code-side about these, other than try to
keep openers and commands as short and to the point as possible while keeping
the "human-like" speech pattern so that there is not confusion about usage.

Make sure you take a look at the
[John-side specifications](#specification-john-side) as well, as some
information also pertains to how code should act.

#### Commands (code-side)

Commands are tokenised and openers are removed before being passed to the `run`
function.

#### Arguments (code-side)

Arguments can be specified however you wish to specify them in order to give
them the most "human-like" speech behaviour. For commands that support multiple
arguments for the same request, a comma seperated list is recommended, example:

> Hey John, can you get me 32 cobblestone, 12 redstone, 8 iron?

Arguments wrapped in parenthesis are to be treated as "exactly this." For
example, if the user states,

> Hey John, can you give me 32 (cobblestone)?

Your module should not levenshtein test `cobblestone`, but use it exactly. If
it's incorrect here, that's the user's fault.

#### Known words (code-side)

See the [John-side known words](#known-words-john-side) for how these work.
These do not affect the code-side of things other than you should avoid
requiring them in your commands.

#### Confirmations (code-side)

By calling `confirm` with a message, you can get confirmation from a user about
what it is they want. For example, if the user asks:

> Hey John, can you get me 32 cob?

And the system has `cobblestone` and `cobbledstone`, the levenshtein distance of
both these names are close enough together that it may be unknown which one the
user is asking for. Thus, you'd want to run something like:

```lua
local result = confirm("Is it cobblestone you want?")
if not result then
  return be_specific()
end
```

In this case, the system would ask the user "Is it cobblestone you want?",
listening for their response. If they respond "yes", `result` will be `true`.
If they respond "no" it will be `false`. All other responses wil result in a
generic message along the lines of:

> That's not a yes or no...

`return be_specific()` here will send a generic message to the user telling them
to be more specific in their request.

### Hurt (errors, code-side)

If your module causes an error, the system will not stop, however your module
may be excluded from being run depending on a few rules.

1. Error ratio. If your module is throwing errors more than it is running
   without error, then your module will be disabled. Ratio is 5 errors to 2
   successes. John will say a generic message about not being able to do certain
   things anymore.
2. `task` method crashing. It is assumed the `task` is important to the module,
   so if the `task` method throws an error, the entire module will stop until
   the system is rebooted.
