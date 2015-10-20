module preassert.equals;
version(unittest) {
    import unit_threaded;
} else {
    struct Name { string _; }
}

@Name("Empty input")
unittest {
    preprocess("").shouldEqual("");
}
