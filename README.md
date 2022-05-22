# Foundry Hands-on Tutorial

Hands-on tutorial on Foundry

## Agenda

- Forge, 10 minutes
- Cast, 2 minutes
- Q&A, 3 minutes


## Forge

- Directory structure
- Tests structure -- fixture
- Traces
- Cheatcodes
- Mainnet Forking
- Fuzzing
- Debugger
- Deploy
- Hardhat --> Foundry

### Forge setup

- Install Foundry
    - https://getfoundry.sh/
- Init a directory with a good template
    - It has ds-test, written by dapphub and offers some helper functions

### Default setup

```
├── foundry.toml
├── lib
│   └── ds-test
│       ├── default.nix
│       ├── demo
│       ├── LICENSE
│       ├── Makefile
│       └── src
└── src
    ├── Contract.sol
    └── test
        └── Contract.t.sol
```

```
foundry init --template https://github.com/abigger87/femplate
```


## Testing

- Remappings
    `forge remappings > remappings.txt`

- Every test is a `public` or `external` function that starts with `test`
- Every contract has a single `setUp` function that is called before every `testFunction`.
- Introduce PetPark
- Test and TestFail
- CheatCodes
    `vm.prank`
    `vm.expectRevert`
    `vm.label`
    `vm.warp`
- Traces
    `-vvv` and `-vvvv`
- Running a matching test or a matching contract
    `-match-contract` and `--match-test`
- Watch mode
    `--watch`
- Gas Report
    `--gas-report`
- Gas Snapshot
    `forge snapshot` saves the current gas usage per test at .gas-snapshot
    `forge snapshot --diff .gas-snapshot` does a diff between the latest and older version of gas snapshot    
- Debug
    `forge test --debug <test-name>`

## Fuzzing

- Arthimetic Underflow example
- SafeTest example
- Use of `vm.assume`
- Show cast
    `cast 4byte-decode`


## More on Cast

- You can use `cast interface` to easily get the interface signature of some contract on etherscan
`cast interface 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D` (Set Etherscan API Key ENV variable)
- Calling functions on a contract using Cast
`cast call 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D "totalSupply()(uint256)" --rpc-url https://eth-mainnet.alchemyapi.io/v2/Lc7oIGYeL_QvInzI0Wiu_pOZZDEKBrdf`

## Anvil


## Forge & Hardhat


### Cheatcodes

```
interface CheatCodes {
    // Set block.timestamp
    function warp(uint256) external;

    // Set block.number
    function roll(uint256) external;

    // Set block.basefee
    function fee(uint256) external;

    // Loads a storage slot from an address
    function load(address account, bytes32 slot) external returns (bytes32);

    // Stores a value to an address' storage slot
    function store(address account, bytes32 slot, bytes32 value) external;

    // Signs data
    // example: NomadBase.t.sol
    function sign(uint256 privateKey, bytes32 digest) external returns (uint8 v, bytes32 r, bytes32 s);

    // Computes address for a given private key
    // example: NomadBase.t.sol
    function addr(uint256 privateKey) external returns (address);

    // Gets the nonce of an account, aka how many transactions the account has sent
    function getNonce(address account) external returns (uint64);

    // Sets the nonce of an account
    // The new nonce must be higher than the current nonce of the account
    function setNonce(address account, uint256 nonce) external;

    // Performs a foreign function call via terminal.
    // example: https://github.com/libevm/subway/blob/master/contracts/src/test/Sandwich.t.sol
    // Nomad: cross-chain communication. Run subsequent tests with different --rpc-url and use file-based read/writes to emulate off-chain agents, all without leaving solidity (except for the bash script that executes subsequent forge test with different --rpc-url)
    function ffi(string[] calldata) external returns (bytes memory);

    // Sets the *next* call's msg.sender to be the input address
    // example: see startPrank
    function prank(address) external;

    // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called
    // example: https://github.com/gakonst/v3-periphery-foundry/blob/67d6f43d8151531e6351d766343cc92daaa7dae4/contracts/foundry-tests/SwapRouter.t.sol#L56
    function startPrank(address) external;

    // Sets the *next* call's msg.sender to be the input address, and the tx.origin to be the second input
    function prank(address, address) external;

    // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called, and the tx.origin to be the second input
    function startPrank(address, address) external;

    // Resets subsequent calls' msg.sender to be `address(this)`
    function stopPrank() external;

    // Sets an address' balance
    function deal(address who, uint256 newBalance) external;

    // Sets an address' code
    function etch(address who, bytes calldata code) external;

    // Expects an error on next TOP-LEVEL call. If an underlying call reverts but the top-level doesn't (due to some try/catch), then it won't fire.
    function expectRevert() external;
    function expectRevert(bytes calldata) external;
    function expectRevert(bytes4) external;

    // Record all storage reads and writes
    function record() external;

    // Gets all accessed reads and write slot from a recording session, for a given address
    function accesses(address) external returns (bytes32[] memory reads, bytes32[] memory writes);

    // Prepare an expected log with (bool checkTopic1, bool checkTopic2, bool checkTopic3, bool checkData).
    // Call this function, then emit an event, then call a function. Internally after the call, we check if
    // logs were emitted in the expected order with the expected topics and data (as specified by the booleans)
    function expectEmit(bool, bool, bool, bool) external;

    // Mocks a call to an address, returning specified data.
    // Calldata can either be strict or a partial match, e.g. if you only
    // pass a Solidity selector to the expected calldata, then the entire Solidity
    // function will be mocked.
    function mockCall(address, bytes calldata, bytes calldata) external;

    // Clears all mocked calls
    function clearMockedCalls() external;

    // Expect a call to an address with the specified calldata.
    // Calldata can either be strict or a partial match
    function expectCall(address, bytes calldata) external;

    // Gets the bytecode for a contract in the project given the path to the contract.
    function getCode(string calldata) external returns (bytes memory);

    // Label an address in test traces
    // Example: NomadBase.t.sol
    function label(address addr, string calldata label) external;

    // When fuzzing, generate new inputs if conditional not met
    // Useful for limiting the range of the fuzzer
    function assume(bool) external;
}
```


### Hardhat --> Foundry

- You can still use Hardhat for complex deployments and test using Foundry
- describe -> contract
- `beforeEach`-> `setUp`
- To install testing libraries that don't live in a `npm` package, you can still use `forge  install` and `/lib` for ease of use.
- There are two partners for creating actors that interact with the smart contracts:
    - Before we had `vm.prank`, we would create a smart contract that called the smart contract under test. The `user` smart contract would be a simple wrapper. This is now mostly an anti-pattern.
        - Example: https://github.com/pentagonxyz/gov-of-venice/blob/master/src/test/utils/gov2Test.sol
    - Use `vm.prank()` and call all the functions we want to call, using some addressed that we have generated with `vm.addr()`. It reduces the boilerplate considerably.
    - In essence, instead of creating complex actors, we just create addresses. No more boilerplate code.
- Example structure
```
/── contracts
/── node_modules
/── forge-tests
    /── Contract.t.sol
```
- Example migration:
    - Hardhat: https://github.com/nomad-xyz/nomad-monorepo/blob/main/typescript/nomad-tests/test/common.test.ts
    - Foundry: https://github.com/odyslam/monorepo/tree/feat/foundry-tests/packages/contracts-core/contracts/test


```

