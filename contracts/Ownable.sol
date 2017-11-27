pragma solidity ^0.4.9;

contract Ownable {
  address private owner;

  function Ownable() public {
    owner = msg.sender;  
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function changeOwner(address newOwner) onlyOwner public {
    owner = newOwner;
  }
}
