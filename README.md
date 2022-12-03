# Advent of Code

This repository is where I stash all my code for Advent of code.

## challenge.lua

`challenge.lua` is what runs the challenges. Looks nice and stuff too. It will
also setup challenges and download AOC inputs.

### Requirements

1. Create a file named `.session_cookie`, copy your session cookie (without
   `session=`) into it.

### Usage

#### Set up a challenge

```
challenge setup year day challenge_number
```

This will create a couple files for you.

1. `challenge.md` - Store the challenge question here if you want, add markdown
   styling to it to make it look nice on github.
2. `input.txt` - Uses your session cookie to download the challenge input for
   given year and day.
3. `output.txt` - Will be blank until you run the challenge, stores the output
   of the last run of the challenge, so you can copy-paste easier.
4. `test_input.txt` - Advent challenges always contain an example input and the
   results for the example, put the example input in here, run the challenge
   with `test` as the last argument, and check if your answer matches the
   example's answer!
5. `run.lua` - This is where the challenge code is stored. It will be populated
   with some basic input/output stuff and a `return function() end` clause to
   make life easier.

#### Run a test of a challenge

```
challenge year day challenge_number test
```

This runs the challenge using the `test_input.txt` file.

#### Run a challenge

```
challenge year day challenge_number
```

This runs the challenge normally using the `input.txt` file downloaded from AOC.
