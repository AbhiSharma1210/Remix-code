// SPDX-License-Identifier: MIT
// This is only for practice only. 
// The code can be compiled on 

pragma solidity ^0.8.18;

contract Encoding {
    function combineStrings() public pure returns(string memory) {
        return string(abi.encodePacked("Hi Blockchain! ", "Have a great day!"));
    }

    // Example functions
    function encodeNumber() public pure returns(bytes memory){
        bytes memory number = abi.encode(1);
        return number;
    }

    function encodeString() public pure returns(bytes memory){
        bytes memory someString = abi.encode("Random string");
        return someString;
    }

    function encodeStringPacked() public pure returns(bytes memory){
        bytes memory someString = abi.encodePacked("Random string");
        return someString;
    }

    function encodeStringBytes() public pure returns(bytes memory){
        bytes memory someString = bytes("Random string");
        return someString;
    }

    function decodeString() public pure returns(string memory){
        string memory decodedString = abi.decode(encodeString(), (string));
        return decodedString;
    }

    function encodeMulti() public pure returns(bytes memory){
        bytes memory encodeMultiple = abi.encode("Random string", "Another string");
        return encodeMultiple;
    }

    function decodeMulti() public pure returns(string memory, string memory){
        (string memory firstString, string memory secondString) = abi.decode(encodeMulti(), (string, string));
        return (firstString, secondString);
    }

    function multiPackedEncode() public pure returns(bytes memory) {
        bytes memory multiPacked = abi.encodePacked("Random string, ", "Another string");
        return multiPacked;
    }

    // The packed version cannot be decoded by abi.decode 
    // however we can make a function like below to type cast 'packed' data into 'string'

    function stringCastPacked() public pure returns(string memory){
        string memory stringCasted = string(multiPackedEncode());
        return stringCasted;
    }

    // How to send transaction that call functions with just the data field populated?
    // How to populate the data field?

    // Solidity has some more "low-level" keywords, namely "staticcall" and "call". 
    // Call was used in the Raffle Lottery project.
    // There is also 'send'. 

    // call: How we call functions to change the state of the blockchain.
    // staticcall: This is how (at a low level) we do our "view" or "pure" function calls, and potentially don't change the blockchain state.

    // Example of 'call'. Won't work here.
    function withdraw(address recentWinner) public {
        (bool success,) = recentWinner.call{value: address(this).balance}("");
        require(success, "Transfer Failed");
    }

    // Notes:
    // - In our {} we were able to pass specific fields of a transaction, like value, Gas Price and Gas Limit.
    // - In our () we were able to pass data in order to call a specific function - but there was no function we wanted to call!
    // We only sent ETH, so we didn't need to call a function!
    // If we want to call a function, or send any data, we'd do it in these Parentheses!
}