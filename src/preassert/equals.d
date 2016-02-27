module preassert.equals;

import std.algorithm;
import std.range;
import std.conv;
import std.string;

version(unittest) {
    import unit_threaded;
}

@safe:


string preprocess(in string input) pure {
    auto fromAssert = input.find("assert(");
    if(fromAssert.empty)
        return input;

    if(fromAssert.canFind(","))
        return input;

    auto valueRange = fromAssert.save();
    immutable findAssert = valueRange.findSkip("assert(");
    assert(findAssert);
    auto valueStr = valueRange.until("==").to!string.strip;

    auto expectedRange = fromAssert.save();
    immutable findEquals = expectedRange.findSkip("==");
    assert(findEquals);
    immutable expectedStr = expectedRange.until(")").to!string.strip;

    return "import preassert.format;\n" ~
        input.until("assert(").to!string ~ "assert(" ~ valueStr ~ " == " ~ expectedStr ~
        text(", equalsMessage(", valueStr, ", ", expectedStr) ~
        "));\n    ";
}

@("Empty input")
unittest {
    preprocess("").shouldEqual("");
}

@("No asserts in input")
unittest {
    immutable src = q{
        int foo(int i, int j) {
            return i + j;
        }
    };
    preprocess(src).shouldEqual(src);
}

@("assert with message")
unittest {
    immutable src = q{
        assert(a == b, "a is not equal to b");
    };
    preprocess(src).shouldEqual(src);
}


@("assert with no messge and variables")
unittest {
    immutable src = q{
        assert(a == b);
    };
    preprocess(src).shouldEqual(q{import preassert.format;

        assert(a == b, equalsMessage(a, b));
    });
}

@("assert with no message and literals")
unittest {
    immutable src = q{
        assert(3 == 4);
    };
    preprocess(src).shouldEqual(q{import preassert.format;

        assert(3 == 4, equalsMessage(3, 4));
    });
}
