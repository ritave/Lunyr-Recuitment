# Lunyr Recruitment Challenge

## What is this
This is a solution to the Solidty recruitment challenge posed by Lunyr.
The initial challenge can be found in the `Challenge.sol` file, while the 
solution exists in `contracts/Shareholders.sol`. The goal was to fix the bugs,
security mistakes and generally explain what the Smart-Contract ought to do.

I've decided that the best way to achieve this task is to, alongside with git log,
is to keep a journal of my decisions and their explanations in this README.

## Explanation
The contract is supposed to be a dividend account. People can send Ether to the contract
for a chance to become shareholders. The owner can then manually accept the senders to become
shareholders and get a part of a dividend.

Right now though, the contract does nothing useful, people send Ether, and when `dispense()`
is called, the only thing that happens is their shares are zeroed out back to them.

I understand that maybe the challenge is supposed to be doing nothing useful, but 
underpromise and overdeliver right? I'm making this contract actally useful in real life.
So after my changes the process works so:
* The owner approves a shareholder
* Shareholder can send their own funds to get shares
* Owner can withdraw those funds
* Owner can dispense dividends to the shareholders
* Each shareholder gets a weighed amount of dividend based on their amount of shares
Further improvements would be:
* Make this an ERC20 token, so that the shares can be sold.
* Add a `removeShareholder` function
* Use some kind of SafeMath library for overflows

## Running
All the commands are found as npm scripts. The minimum to run tests would be:

    npm install
    npm run test

## Journal
1. Decided to use Truffle for compilation and testing
  * Preferably I would use somehting lighter for this task,
    but Dapple is deprecated, Dapp is not yet ready and Embark
    is even bigger than Truffle
  * TODO: Create my own open-source light skeleton for Smart-Contract
    development?
2. Installed Solium for automatic security and linting detection
3. Added .editorconfig for your IDE rule standarization
4. Renamed the contract to something more appropriate (also a typo in constructor)
5. Extracted Ownable logic into own SC
  * Also a bug with `owner` checking, `tx.origin` is the whole transaction caller, while
    the `msg.sender` is the last in chain of smart-contracts calls
  * Added tests
6. Fix indentation
7. The loop iterator has a `var` declaration which is `uint8` and not `uint`
8. The error from `send` wasn't checked in `dispense()`
  * Upgraded the solidity version to `0.4.13` and used `transfer`
9. `withdraw()` has a reentrancy attack bug
  * Zero out the value before withdraw
10. `dispense()` just zeros-out shares, I expect it was supposed to send a dividend
  * Made it `payable` and redistribute the funds input by the owner
  * NOTE: Why make it owner only? Might as well give anyone abillity to donate funds
11. Added names to the `FailedSend` event
  * Makes it easier to understand for the next developer
12. A loop in `dispense()` is a bad idea due to gas limits as well as nothing happenig when
    a send fails, moving the whole infrastructure to pull instead of push sends.
  * Made a struct holding all the information concerning the shareholder
  * Seperated `withdraw()` into `withdraw()` and `withdrawInvestments()`
15. Default function destroys previous shares of the owner, instead of adding to them

Cheers 🍸 from Olaf Tomalka <olaf@tomalka.me>
