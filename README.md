# Noir Dash


## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Data](#data)
- [Utils](#utils)
- [TODO](#todo)
- [Appendix](#appendix)

## Installation

To get started with Noir Dash, clone the repository and install the necessary dependencies.

```sh
$ git clone git@github.com:0xshora/noir_dash.git
```

Install noir: see [doc](https://noir-lang.org/docs/getting_started/installation/)

```sh
$ curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash
$ noirup -v 0.32.0
```

## Usage

### generate Prover.toml

```sh
$ nargo check
```

### Test
```sh
$ nargo test
```

or 
```sh
$ nargo test --show-output <test-case>
```

## Data

The game uses several data files to configure stages and user interactions. Below are the descriptions of these files:

- `stage.json`:
  - `x`: The x-coordinate of the stage element.
  - `y`: The y-coordinate of the stage element.
  - `btype`: The type of object. (block->1, needle->2)

- `config_1.toml`:
  - `height`: The height of the stage.
  - `bufferHeight`: The buffer height for the stage.

- `userInteractions.json`:
  - `action`: The action performed by the user (e.g., jump).
  - `x`: The x-coordinate where the action is performed.
  - `y`: The y-coordinate where the action is performed.


## Utils
By using `./utils/make_test.py`, you can create test cases quickly.

```sh
$ python ./utils/make_test.py -c ./data/testStage/config_1.toml -a ./data/testStage/userInteractions_Clear_1.json -o ./data/stage.json
```

Then, you can copy it and paste it to `./src/tests/main_test.nr` or smth.

## TODO
- [ ] Handle the size of objects
- [ ] Test for needles
- [ ] Test for complex stages
- [ ] Randomize initial positions for each user?
- [x] check if the user jump from correct place. (not from air.)
- [x] change configs.
<!-- - [ ] jump from ground or block(id) -> check if the y value is valid or not. -->

## Appendix
- Currently, Noir only supports fixed-length arrays, so maximum values are set for actions and other parameters.
- Noir handles integers, so to work with decimals, multiply or divide by 100 or 10000. (WIP)