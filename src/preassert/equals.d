module preassert.equals;

import std.algorithm;
import std.range;

version(unittest) {
    import unit_threaded;
} else {
    struct Name { string _; }
}

@safe:


string preprocess(in string input) pure nothrow {
    auto fromAssert = input.find("assert");
    if(fromAssert.empty)
        return input;

    if(fromAssert.canFind(","))
        return input;

    return "import preassert.format;\n" ~
        input.replace(");", ", equalsMessage(a, b));");
}

@Name("Empty input")
unittest {
    preprocess("").shouldEqual("");
}

@Name("No asserts in input")
unittest {
    immutable src = q{
        int foo(int i, int j) {
            return i + j;
        }
    };
    preprocess(src).shouldEqual(src);
}

@Name("assert with message")
unittest {
    immutable src = q{
        assert(a == b, "a is not equal to b");
    };
    preprocess(src).shouldEqual(src);
}


@Name("assert with no messge and variables")
unittest {
    immutable src = q{
        assert(a == b);
    };
    preprocess(src).shouldEqual(q{import preassert.format;

        assert(a == b, equalsMessage(a, b));
    });
}

@Name("assert with no message and literals")
unittest {
    immutable src = q{
        assert(a == b);
    };
    preprocess(src).shouldEqual(q{import preassert.format;

        assert(a == b, equalsMessage(a, b));
    });
}
