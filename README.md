# Solidity Advanced Functions Examples

## About:
This repository contains some examples with explanations of some advanced Solidity functions. Below are some of the main points covered:

1. Examples of functions utilizing `abi.encode()`,`abi.decode`, `string.concat()`, and `abi.encodePacked()`.
2. Explanation of the differences between the above functions and how they work on a low/system level.
3. What is `call()`, `staticcall()` and `send()`.
4. How and when to use the `call()` function and different types of approach in implementing it.
5. Example of how to use `delegatecall()` function and how it works.

## Note:
Since `call()` is a low level function and utilizing it required low level code, this may raise warning flags by some auditors. Importing an interface is better option as it will have compiler, able to check it the types are matching, etc. So its bettwer to avoid this when possible.

This repository is created in Remix and saved for reference and learning purposes. Every contract is working and tested in Remix.

## Useful links:
More detailed information can be found here. 
[Deconstructing solidity Part I](https://blog.openzeppelin.com/deconstructing-a-solidity-contract-part-i-introduction-832efd2d7737)
[Deconstructing solidity Part II](https://blog.openzeppelin.com/deconstructing-a-solidity-contract-part-ii-creation-vs-runtime-6b9d60ecb44c)
[Deconstructing solidity Part III](https://blog.openzeppelin.com/deconstructing-a-solidity-contract-part-iii-the-function-selector-6a9b6886ea49)

