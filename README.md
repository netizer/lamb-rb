# Lamb

Lamb is a programming language. It's inspired by lambda calculus, so you can (or will) find in it most of the things that you can find in functional languages. It's also inspired by lambs, because they're cute, and this language is cute.

The main goal of the language is to be simple, extensible and to put a developer in the center of development. It has the following features (or goals, when TBD is mentioned):
- As simple as possible syntax (but still, elegant, and super easy to read).
- Powerful macro system.
- Clear error messages.
- Static typing (TBD).

It is a frontend of another programming language, called Forest.

Forest adds another pile of features to the stack:
- Homoiconicity - The code is a data structure - like lisp, but the code is a tree, not a list. Oh, and you don't have brackets everywhere, so you could call it a cute lisp if you really want to. Wait. Lisp is LISt Processor, and Forest is TREEs Processor, or FORESt Processor, so maybe Foresp? Treep?... haha, nevermind.
- It's a super simple data structure - the code has literally 3 keywords (well, low-level keywords), so parsing it, e.g. findinng all calls to a specific function, is as easy as it gets.
- You can embed it in other programming languages, so, it's a perfect language for keeping business logic, or calculatios that you want to share between multiple environments (TBD).

If you want to read more about Forest, it has it's own repository.

## How does it look?

A usecase that already works is pretty simple. You can use Lamb to express data. The thing is that many data formats (JSON, YAML) are just data formats with some programmming-language features (boolean operators in JSON Schema, custom data types in YAML, and so on).

But that means that the format limits the user to features that the format developers already thought about. If your data format needs features of a programming language, why not use a programming language with good data-representation features instead?

There are 2 main reasons why people don't usually write their data in Ruby, or Python, or JS.

First, these languages do not have a nice syntax for expressing data (e.g. in YAML you can write a hash in which part of it depends on another part - e.g. Ruby hashes don't have such feature - you can do it, but it's not obvious how to and everybody does that differently).

Second, a script written in Python, or even pure-functional Haskell can do a lot of things just because you read it from the disc. Most of the time we just want the data. We don't want to read it, and accidentally blow up a toaster.

In Lamb (and Forest, and Groundcover) you can pass to the interpreter only the features you are interested in. You want your file to just create a data structure? That's what it will be able to do. You want it to be able to also read environment variables? That can be done. You want it to use validation functions? Just pass them to the parser. Plus, lamb looks great as a data representation format. Below you have an example of such file written in Lamb.

```lamb
development = merge: default, overrides.dev
production = merge: default, overrides.prod

private:
  default =
    adapter = "postgresql"
    pool = integer: (or: (envvar: "POOL"), "5")
    url = url: (envvar: "DATABASE_URL")
  overrides =
    dev =
      database = "development_database"
    prod =
      database = "production_database"
      username = "username"
      password = envvar: "DATABASE_PASSWORD"
```

## Usage

If you'd like to see the Forest code that will be generated by Lamb intterpretter, just call:

```bash
ruby run.rb fixtures/later_now.lamb
```

If, on the other hand, you'd like Forest to be able to parse Forest files, just include module Lamb to Forest Dependencies (which is already done if you use `bin/forest.rb` from `forest-rb` repository). To see how it's done, you can also check out the test in `spec/ruby_usage_spec.rb` in that repository.

## Status of the language

It's a version 0.0.x, so use it for space travel at your own risk. I'm currently workig on the module system for Forest (which means that Lamb will have a module systemm too), and on translating the Lamb's lexer and parser from Ruby to Forest. Well, to Groundcover, actually, because Forest is just too verbose to write in it directly, but Groundcover compiles to Forest, so that's ok. If you're interested in Groundcover (and in something, that I guess you could call a symmetric compilation, or by a more widely known name if you know any compiler that does that too), it has its own repo too.

## Community

If you feel like taking a look at the code or playing with it, or sending a PR would be fun, that's great :-) I'll do my best to make that experience as nice for you as possible. A good startting pointt to play with Forest and with Lamb is tto follow the instructions in https://github.com/netizer/forest-utils
