# Lunyr Recruitment Challenge

## What is this
This is a solution to the Solidty recruitment challenge posed by Lunyr.
The initial challenge can be found in the `Challenge.sol` file.
The goal was to fix the bugs, security mistakes and generally explain what the Smart-Contract ought to do.

## Improvement
Additionally I thought it would be fun to make the contract actually useful in real world.
I've modified it so now it's a basic dividend ledger.

So after my changes the process works as so:
* The owner approves a shareholder
* Shareholder can send their own funds to get shares
* Owner can withdraw those funds
* Owner can dispense dividends to the shareholders
* Each shareholder gets a weighed amount of dividend based on their amount of shares

Further improvements would be:
* Make this an ERC20 token, so that the shares can be sold.
* Add a `removeShareholder` function
* Use some kind of SafeMath library for overflows

I've documented all detected bugs and then iteration decisions in the Journal included in this README.

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
16. Default function also does too much work and most of the time might run out of gas
  * I've removed the `dispense()` function, it's role now does the default function
  * I've added a `invest()` function for the shareholders

Cheers 🍸 from Olaf Tomalka <olaf@tomalka.me>
