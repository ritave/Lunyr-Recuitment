pragma solidity ^0.4.13;

contract NotOwnerProxy {
  function exec(address instance, string signature) public returns (bool) {
    return instance.call(bytes4(keccak256(signature)));
  }
  function exec(address instance, string signature, uint256 param) public returns (bool) {
    return instance.call(bytes4(keccak256(signature)), param);
  }
}
