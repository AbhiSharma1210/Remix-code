// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// In order to call a function using only the data field of call, we need to encode:
// A. The function name and
// B. The parameters we want to add.
// All down to the binary level.

// To achieve above objective we need to work with 2 concepts.

// To encode the function name. We need to grab a 'function selector'.
// We can get 'function selector' by different mean but one of them is by encoding the 'function signature' and grabbing the first 4 bytes.

// The 'function selector' is the first 4 bytes of the 'function signature'.
// Example: 0xa9059cbb
// The 'function signature' is a string that defines the function name & parameters.
// Example: "transfer(address, uint256)" - encode this and then the first 4 bytes
// We get the 'function selector' as in previous example.

// We can by

contract CallAnything {
    address public s_someAddress;
    uint256 public s_amount;

    function transfer(address someAddress, uint256 amount) public {
        s_someAddress = someAddress;
        s_amount = amount;
    }

    // A. encoding function name:
    function getSelectorOne() public pure returns (bytes4 selector) {
        // DO NOT put any spaces in "transfer(address,uint256)" otherwise it will not work
        selector = bytes4(keccak256(bytes("transfer(address,uint256)")));
    }

    // B. Adding the parameters that we want:
    function getDataToCallTransfer(
        address someAddress,
        uint256 amount
    ) public pure returns (bytes memory) {
        // abi.encodeWithSelector encode the given arguments starting with the 2nd and prepends the 4 byte selector.
        return abi.encodeWithSelector(getSelectorOne(), someAddress, amount);
    }

    // Now we can call 'transfer' function without directly calling it:
    function callTransferFunctionWithBinary(
        address someAddress,
        uint256 amount
    ) public returns (bytes4, bool) {
        (bool success, bytes memory returnData) = address(this).call(
            // getDataToCallTransfer(someAddress, amount); // Either this or below
            abi.encodeWithSelector(getSelectorOne(), someAddress, amount)
        );
        return (bytes4(returnData), success);
    }

    // Encode with signature
    // We dont need the selector if we used this
    // As its basically encoding the signature for us.
    function callTransferFunctionWithBinaryTwo(
        address someAddress,
        uint256 amount
    ) public returns (bytes4, bool) {
        (bool success, bytes memory returnData) = address(this).call(
            // getDataToCallTransfer(someAddress, amount); // Either this or below
            abi.encodeWithSignature(
                "transfer(address,uint256)",
                someAddress,
                amount
            )
        );
        return (bytes4(returnData), success);
    }

    // Different ways to get selector

    // We can also get a function selector from data sent into the call
    function getSelectorTwo() public view returns (bytes4 selector) {
        bytes memory functionCallData = abi.encodeWithSignature(
            "transfer(address,uint256)",
            address(this),
            1234
        );
        selector = bytes4(
            bytes.concat(
                functionCallData[0],
                functionCallData[1],
                functionCallData[2],
                functionCallData[3]
            )
        );
    }

    // Another way to get data (hard coded)
    function getCallData() public view returns (bytes memory) {
        return
            abi.encodeWithSignature(
                "transfer(address,uint256)",
                address(this),
                123
            );
    }

    // Pass this:
    // 0xa9059cbb000000000000000000000000d7acd2a9fd159e69bb102a1ca21c9a3e3a5f771b000000000000000000000000000000000000000000000000000000000000007b
    // This is output of `getCallData()`
    // This is another low level way to get function selector using assembly
    // We can actually write code that resembles the opcodes using the assembly keyword!
    // This in-line assembly is called "Yul"
    // It's a best practice to use it as little as possible - only when you need to do something very VERY specific
    function getSelectorThree(
        bytes calldata functionCallData
    ) public pure returns (bytes4 selector) {
        // offset is a special attribute of calldata
        assembly {
            selector := calldataload(functionCallData.offset)
        }
    }

    // Another way to get selector with the "this" keyword
    function getSelectorFour() public pure returns (bytes4 selector) {
        return this.transfer.selector;
    }

    // A function that gets the signature
    function getSignatureOne() public pure returns (string memory) {
        return "transfer(address,uint256)";
    }
}

contract CallFunctionWithoutContract {
    address public s_selectorsAndSignaturesAddress;

    constructor(address selectorsAndSignaturesAddress) {
        s_selectorsAndSignaturesAddress = selectorsAndSignaturesAddress;
    }

    // pass in
    // 0xa9059cbb000000000000000000000000d7acd2a9fd159e69bb102a1ca21c9a3e3a5f771b000000000000000000000000000000000000000000000000000000000000007b
    // you could use this to change state
    function callFunctionDirectly(
        bytes calldata callData
    ) public returns (bytes4, bool) {
        (
            bool success,
            bytes memory returnData
        ) = s_selectorsAndSignaturesAddress.call(
                abi.encodeWithSignature("getSelectorThree(bytes)", callData)
            );
        return (bytes4(returnData), success);
    }

    // with a staticcall, we can have this be a view function!
    function staticCallFunctionDirectly() public view returns (bytes4, bool) {
        (
            bool success,
            bytes memory returnData
        ) = s_selectorsAndSignaturesAddress.staticcall(
                abi.encodeWithSignature("getSelectorOne()")
            );
        return (bytes4(returnData), success);
    }

    function callTransferFunctionDirectlyThree(
        address someAddress,
        uint256 amount
    ) public returns (bytes4, bool) {
        (
            bool success,
            bytes memory returnData
        ) = s_selectorsAndSignaturesAddress.call(
                abi.encodeWithSignature(
                    "transfer(address,uint256)",
                    someAddress,
                    amount
                )
            );
        return (bytes4(returnData), success);
    }
}
