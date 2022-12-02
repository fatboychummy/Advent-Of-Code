# Folder spec
root /
      challenge.lua
      spec
      current_output.txt
      <challenge creator> /
                            <challenge name> /
                                              <challenge number> /
                                                                  run.lua
                                                                  output.txt
                                                                  input.txt
                                                                  challenge.md


root/challenge.lua takes the following arguments:
  creator name number

It will then run the appropriate challenge.lua, passed a file handle for the input and output.
The output file handle will be wrapped such that it also outputs to root/current_output.txt

Store the information about the challenge in challenge.md

## run.lua
Each run.lua file will be `require`'d. It is expected that the file returns
a single function, with an altered filehandle for input and output as its arguments.

`return function(input, output)`

Both input and output handles do not need to be closed or opened. That will be handled
by `root/challenge.lua`.

### Input handle
The input handle is altered slightly. The `read` and `readline` methods will read
as if it were a normal CC `fs` filehandle, however there is also a `.lines()` method
which can be used to quickly and easily get a table filled with each line of the
file seperated, with a `.n` value denoting how many lines there were in total.

### Output handle
The output handle is linked in such a way that it will write to both `root/current_output.txt`
and the challenge's own `output.txt` at the same time. Nothing else is different
from a normal CC `fs` filehandle.

Small outputs (a single line) will also be displayed to the terminal.