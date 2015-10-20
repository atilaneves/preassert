module preprocess.format;

import std.range;
import std.conv;
import std.array;

@safe:


private string getOutputPrefix(in string file, in size_t line) pure {
    return "    " ~ file ~ ":" ~ line.to!string ~ " - ";
}


string equalsMessage(V, E)(V value, E expected,
                           in string file = __FILE__, in size_t line = __LINE__) {
    return (formatValue("Expected: ", expected) ~
            formatValue("     Got: ", value)).
        map!(a => getOutputPrefix(file, line) ~ a).
        join("\n");
}


string[] formatValue(T)(in string prefix, T value) {
    static if(isSomeString!T) {
        return [ prefix ~ `"` ~ value ~ `"`];
    } else static if(isInputRange!T) {
        return formatRange(prefix, value);
    } else {
        return [() @trusted{ return prefix ~ value.to!string; }()];
    }
}


string[] formatRange(T)(in string prefix, T value) {
    //some versions of `to` are @system
    auto defaultLines = () @trusted{ return [prefix ~ value.to!string]; }();

    static if (!isInputRange!(ElementType!T))
        return defaultLines;
    else
    {
        const maxElementSize = value.empty ? 0 : value.map!(a => a.length).reduce!max;
        const tooBigForOneLine = (value.length > 5 && maxElementSize > 5) || maxElementSize > 10;
        if (!tooBigForOneLine)
            return defaultLines;
        return [prefix ~ "["] ~
            value.map!(a => formatValue("              ", a).join("") ~ ",").array ~
            "          ]";
    }
}
