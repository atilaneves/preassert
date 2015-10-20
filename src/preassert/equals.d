module preassert.equals;
version(unittest) {
    import unit_threaded;
} else {
    struct Name { string _; }
}

@safe:

string preprocess(in string input) {
    return "";
}

@Name("Empty input")
unittest {
    preprocess("").shouldEqual("");
}
