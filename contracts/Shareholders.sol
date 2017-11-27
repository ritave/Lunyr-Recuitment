pragma solidity ^0.4.13;

import "./Ownable.sol";

contract Shareholders is Ownable {
  event FailedSend(address shareholder, uint value);

  uint totalShares;
  uint waitingInvestments;
  uint sumDividends; 
  mapping(address => Shareholder) shareholders;

  modifier onlyShareholder {
    require(shareholders[msg.sender].isAccepted);
    _;
  }

  function () onlyShareholder payable public {
    Shareholder memory holder = shareholders[msg.sender];
    claimDividends(holder);

    totalShares += msg.value;
    waitingInvestments += msg.value;
    holder.etherShares += msg.value;
  }

  function addShareholder(address shareholder) onlyOwner public {
    shareholders[shareholder].isAccepted = true;
  }

  function withdraw() onlyShareholder public {
    Shareholder memory holder = shareholders[msg.sender];
    claimDividends(holder);

    uint value = holder.dividendsWaiting;
    holder.dividendsWaiting = 0;
    if (!msg.sender.send(value)) {
      holder.dividendsWaiting = value;
      FailedSend(msg.sender, value);
    }
  }

  function withdrawInvestments() onlyOwner public {
    uint value = waitingInvestments;
    waitingInvestments = 0;
    msg.sender.transfer(value);
  }

  function dispense() onlyOwner payable public {
    sumDividends += msg.value;
  }

  function claimDividends(Shareholder memory holder) view private {
    uint unclaimedDividends = holder.etherShares * (sumDividends-holder.lastDividends) / totalShares;

    holder.lastDividends = sumDividends;
    holder.dividendsWaiting += unclaimedDividends;
  }

  struct Shareholder {
    bool isAccepted;
    uint etherShares;

    uint lastDividends;
    uint dividendsWaiting;
  }
}
