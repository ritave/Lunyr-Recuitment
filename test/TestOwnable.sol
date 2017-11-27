pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "../contracts/Ownable.sol";
import "./utils/NotOwnerProxy.sol";

contract ConcreteOwnable is Ownable {
  function someFunc() onlyOwner public view returns (bool) {
    return true;
  }
}


contract TestOwnable {
  ConcreteOwnable ownable;

  function beforeEach() public {
    ownable = new ConcreteOwnable();
  }

  function testOwnerSucceeds() public {
    bool result = ownable.someFunc();

    Assert.isTrue(result, "onlyOwner function fails for the owner");
  }

  function testProxyFails() public {
    NotOwnerProxy proxy = new NotOwnerProxy();

    // Catch the throw instead of bubbling it up the stack
    bool result = proxy.call(ownable, "exec()");
    Assert.isFalse(result, "onlyOwnr function succeeds for not owner");
  }

  function testChangeOwner() public {
    NotOwnerProxy proxy = new NotOwnerProxy();
    ownable.changeOwner(proxy);

    bool myResult = ownable.call(bytes4(keccak256("someFunc()")));
    Assert.isFalse(myResult, "call succeeds after changing owner");
    Assert.isTrue(proxy.exec(ownable, "someFunc()"), "owner not changed");
  }
}
