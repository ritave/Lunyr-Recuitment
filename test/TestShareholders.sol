pragma solidity ^0.4.13;

import "truffle/Assert.sol";
import "../contracts/Shareholders.sol";
import "./utils/NotOwnerProxy.sol";

// Currently there is no way to check amount of wei transfered internally between contracts
// And so we can only automate the simple tests without validation the transfered values

contract TestShareholders {
  uint public initialBalance = 1 ether;

  Shareholders private instance;

  function beforeEach() public {
    instance = new Shareholders();
  }

  function testAddShareholderOwner() public {
    instance.addShareholder(this);

    Assert.isTrue(instance.isShareholder(this), "owner wasn't added as a shareholder");
  }

  function testAddShareholderNotOwner() public {
    NotOwnerProxy proxy = new NotOwnerProxy();

    bool result = proxy.exec(instance, "addShareholder(address)", uint256(this));

    Assert.isFalse(result, "proxy addShareholder succeeded");
    Assert.isFalse(instance.isShareholder(this), "I am unexpected shareholder");
  }

  function testIsShareholder() public {
    instance.addShareholder(this);
    NotOwnerProxy proxy = new NotOwnerProxy();

    Assert.isTrue(instance.isShareholder(this), "this is not a shareholder");
    Assert.isFalse(instance.isShareholder(proxy), "proxy is a shareholder");
  }

  function testFunctionDefault() public {
    bool result = instance.call.value(1 wei)();
    Assert.isTrue(result, "default function fails");
  }

  function testInvestShareholder() public {
    instance.addShareholder(this);
    bool result = instance.call.value(1 wei)(bytes4(keccak256("invest()")));
    Assert.isTrue(result, "shareholder can't invest");
  }

  function testInvestNotShareholder() public {
    bool result = instance.call.value(1 wei)(bytes4(keccak256("invest()")));
    Assert.isFalse(result, "not shareholder investment succeeded");
  }

  function testWithdrawInvestmentsOwner() public {
    instance.addShareholder(this);
    instance.invest.value(1 wei)();

    bool result = instance.call(bytes4(keccak256("withdrawInvestments()")));
    Assert.isTrue(result, "withdrawInvestment fails as owner");
  }

  function testWithdrawInvestmentNotOwner() public {
    instance.addShareholder(this);
    instance.invest.value(1 wei)();
    NotOwnerProxy proxy = new NotOwnerProxy();

    bool result = proxy.exec(instance, "withdrawInvestments()");
    Assert.isFalse(result, "withdrawInvestment() succeeds as not owner");
  }

  function testWithdrawShareholder() public {
    instance.addShareholder(this);

    bool result = instance.call(bytes4(keccak256("withdraw()")));
    Assert.isTrue(result, "withdraw() failed as shareholder");
  } 

  function testWithdrawNotShareholder() public {
    bool result = instance.call(bytes4(keccak256("withdraw()")));
    Assert.isFalse(result, "withdraw() succeeded when not shareholder");
  }

  function() payable public {
    // empty on purpouse
  }
}
