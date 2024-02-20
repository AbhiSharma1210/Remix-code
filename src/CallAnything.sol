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
}
