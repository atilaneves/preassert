module preassert.equals;
version(unittest) {
    import unit_threaded;
} else {
    struct Name { string _; }
}

@safe:

string preprocess(in string input) pure nothrow {
    return input;
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
