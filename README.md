## Setting up Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

### Configuring for VSCode

https://book.getfoundry.sh/config/vscode


## Setting up the docker container

```bash
docker build -t bsides-blockchain .
docker run --rm -it -v$(pwd):/workshop blockchain-workshop
```
