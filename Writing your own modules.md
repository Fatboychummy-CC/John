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

- `patterns: {...: string}`
  - A table of patterns that this module looks for at the start of every
    command. Don't worry about adding `^` to the start of the pattern, the
    module loader will to this for you.
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
    spaces.

### Phrases (code-side)
