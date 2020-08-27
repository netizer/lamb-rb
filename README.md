# TForest

## Usage

```bash
ruby run.rb fixtures/later_now.lamb
```

## Goals

Lamb is one of the programming languages built on top of Forest. There are a couple of goals of this language:
1. To be a functional language that is easy to use, but also has static typing, powerful macro system and a handy module system.
2. To be simple.
3. To be extendable.

## TODO:

- what "merge:" means - keywords vs function calls - "call" value
- what "private:" means - stages?

Solutions:

Set 3 (score: 10):
- "namespace.name:" is a single lexer token, but it produces CallNode that translates to
  call[data[format_call],block[data[namespace1.name],REST]]
and it's a macro-stage keyword that resolves to either:
  - call[data[namespace.name],REST] if such keyword exists in a host environment
  - call[data[call_forest_keyword],block[data[namespace1.name],REST]] if such keyword exists in a forest environment
  - call[data[now_with_args],block[REST,call[hash_get[call[get[namespace1]],get[data[name]]]] otherwise
- there is a file wrapper with:
  call[data[macro_stage],call[data[context],call[data[FILE],data[]]]]  
- "context" is a macro-stage keyword that processes "private"
- we have a nameless namespace that provides keywords without the scope
- we can create namespaced and non-namespace keywords ad-hoc  
- give an example with function name

TODO:
1. lexer produces [:IDENTIFIER, "namespace1.namespace2.name"], but "identifier:" is a macro-stage keyword that translates it to a keyword call or a combination of HashGet and Get
2. file wrapper
3. create a macro_stage action
4. create "create_forest_keyword" and "call_forest_keyword" keywords
5. create format_call keyword for the macro-stage
6. clutching to determine actions to be called in a stage (???)

The flow:

1. The file wrapper for config files contains "macro_stage", and "runtime_stage" calls
2. macro-stage runs clutching process with predefined list of macro-level keywords and executes the keywords (call nodes get "value")
3. runtime-stage runs clutching process with predefined list of runtime-stage keywords and executes the keywords

Potential problems:
1. What if I misspell, let's say, with_permissions call? Then all the calls inside will be called, and with_permissions won't because it won't belong to any stage.
Solution: Maybe I should add action list for all stages (even test) in the call of a file, and then check if any action is missing and rise the error (not during execution), and then specify the stage-specific  wrapper

Wordking:
- run = clutch + go

What I can potentially move to later:
1. "create_forest_keyword" and "call_forest_keyword" keywords
2. give an example with function name vs keyword call

Done:
1. lexer produces [:IDENTIFIER, "namespace1.namespace2.name"], but "identifier:" is a macro-stage keyword that translates it to a keyword call or a combination of HashGet and Get

ACTUAL TODO:
1. file wrapper - prepare the one in forest and introduce a merging function (to think through first...)
2. create a macro_stage action
3. clutching to determine actions to be called in a stage
4. create format_call keyword for the macro-stage
