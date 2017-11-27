pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "../contracts/Ownable.sol";

contract ConcreteOwnable is Ownable {
  function someFunc() onlyOwner public view returns (bool) {
    return true;
  }
}

contract NotOwnerProxy {
  ConcreteOwnable private ownable;

  function NotOwnerProxy(ConcreteOwnable _ownable) public {
    ownable = _ownable;
  }
  function exec() public view returns (bool) {
    return ownable.someFunc();
  }
}

contract TestOwnable {
  ConcreteOwnable ownable;

  function setUp() private {
    ownable = new ConcreteOwnable();
  }

  function testOwnerSucceeds() public {
    setUp();

    bool result = ownable.someFunc();

    Assert.isTrue(result, "onlyOwner function fails for the owner");
  }

  function testProxyFails() public {
    setUp();
    NotOwnerProxy proxy = new NotOwnerProxy(ownable);

    // Catch the throw instead of bubbling it up the stack
    bool result = proxy.call(bytes4(keccak256("exec()")));
    Assert.isFalse(result, "onlyOwnr function succeeds for not owner");
  }

  function testChangeOwner() public {
    setUp();
    NotOwnerProxy proxy = new NotOwnerProxy(ownable);
    ownable.changeOwner(proxy);

    bool myResult = ownable.call(bytes4(keccak256("someFunc()")));
    Assert.isFalse(myResult, "call succeeds after changing owner");
    Assert.isTrue(proxy.exec(), "owner not changed");
  }
}
