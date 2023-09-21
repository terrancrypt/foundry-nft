// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract Encoding {
    function combineStrings() public pure returns (string memory) {
        return string(abi.encodePacked("Hi Mom!", "Miss you!"));
    }
}
