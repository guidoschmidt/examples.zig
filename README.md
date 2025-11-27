[![CI](https://github.com/guidoschmidt/examples.zig/actions/workflows/build.yaml/badge.svg)](https://github.com/guidoschmidt/examples.zig/actions/workflows/build.yaml)

# [zig](https://ziglang.org/) Examples
> Hodgepodge of examples created while learning zig

### Bulid and run the examples

Build all examples:
```
zig build -- all
```

Build a single example with `zig build -- ./src/examples/path/to/example.zig`, e.g.
```
zig build -- ./src/examples/datastructures/reactivity.zig
```

Bulid + run a single example with `zig build run-$EXAMPLE_FILE_NAME -- ./src/examples/path/to/example.zig`, e.g.
```
zig build run-reactivity -- ./src/examples/datastructures/reactivity.zig
```
