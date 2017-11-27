pragma solidity ^0.4.13;

contract NotOwnerProxy {
  function exec(address instance, string signature) public returns (bool throws) {
    return instance.call(bytes4(keccak256(signature)));
  }
}
