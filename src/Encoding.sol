// SPDX-License-Identifier: MIT
// This is only for practice only.
// The code can be compiled on Remix.

pragma solidity ^0.8.7;

contract Encoding {
    function combineStrings() public pure returns (string memory) {
        return
            string(
                abi.encodePacked("Blockchain is awesome! ", "Have a great day!")
            );
    }

    // Example functions
    // in Solidity 0.8.12+ we can use string.concat(arg, arg)

    // When we send a transaction, it is "compiled" down to bytecode and sent in a "data" object of the transaction.
    // That data object now governs how future transactions will interact with it.
    // Exmaple: https://sepolia.etherscan.io/address/0x5c1ddb86F11BB46D3067C702AC554aEaED9ff8f0#writeContract

    function encodeNumber() public pure returns (bytes memory) {
        bytes memory number = abi.encode(1); // View how the number looks in binary format.
        return number;
    }

    // We can basically encode almost anything. Example:
    function encodeString() public pure returns (bytes memory) {
        bytes memory someString = abi.encode("Random string");
        return someString;
    }

    // encodePacked is like a compressor.
    // If we don't want a perfect binary version of something, we can use abi.encodePacked
    function encodeStringPacked() public pure returns (bytes memory) {
        bytes memory someString = abi.encodePacked("Random string");
        return someString;
    }

    // Typecasting
    // the above function (encodeeStringPacked()) and this one are almost same.
    function encodeStringBytes() public pure returns (bytes memory) {
        bytes memory someString = bytes("Random string");
        return someString;
    }

    // We can also decode stuff.
    // Note: This only works with 'encode' and not with 'encodePacked' coz the later is trimmed.
    function decodeString() public pure returns (string memory) {
        string memory decodedString = abi.decode(encodeString(), (string));
        return decodedString;
    }

    // We can multi decode as well.
    function encodeMulti() public pure returns (bytes memory) {
        bytes memory encodeMultiple = abi.encode(
            "Random string",
            "Another string"
        );
        return encodeMultiple;
    }

    // and we can also multi decode. Well obviously.
    function decodeMulti() public pure returns (string memory, string memory) {
        (string memory firstString, string memory secondString) = abi.decode(
            encodeMulti(),
            (string, string)
        );
        return (firstString, secondString);
    }

    // We can 'encodePacked' multiple stuff as well.
    // Don't try to decode them.
    function multiPackedEncode() public pure returns (bytes memory) {
        bytes memory multiPacked = abi.encodePacked(
            "Random string, ",
            "Another string"
        );
        return multiPacked;
    }

    // Since the packed version cannot be decoded by abi.decode
    // we can make a function like below to type cast 'packed' data into 'string'

    function stringCastPacked() public pure returns (string memory) {
        string memory stringCasted = string(multiPackedEncode());
        return stringCasted;
    }

    // How to send transaction that call functions with just the data field populated?
    // How to populate the data field?

    // Solidity has some more "low-level" keywords, namely "staticcall" and "call".
    // Call is used in the Raffle Lottery project.
    // There is also 'send'.

    // call: How we call functions to change the state of the blockchain.
    // staticcall: This is how (at a low level) we do our "view" or "pure" function calls, and potentially don't change the blockchain state.

    // Example of 'call'. Won't work here.
    // function withdraw(address recentWinner) public {
    //     (bool success, ) = recentWinner.call{value: address(this).balance}("");
    //     require(success, "Transfer Failed");
    // }

    // Notes:
    // - In our {} we were able to pass specific fields of a transaction, like value, Gas Price and Gas Limit.
    // - In our () we were able to pass data in order to call a specific function - but there was no function we wanted to call!
    // We only sent ETH, so we didn't need to call a function!
    // If we want to call a function, or send any data, we'd do it in these Parentheses!
}
