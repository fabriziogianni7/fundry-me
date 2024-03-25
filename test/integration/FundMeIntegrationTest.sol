// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract FundMeIntegrationTest is StdCheats, Test {
    // deploy contract (you can import a deploy script)
    // This contract is always the msg sender
    FundMe fundMe;
    DeployFundMe deployer;
    address FABRIZIO = makeAddr("FABRIZIO");
    uint256 constant DEFAULT_SEND_FUNDS = 6e18;
    uint256 public constant STARTING_USER_BALANCE = 100 ether;

    function setUp() external {
        deployer = new DeployFundMe();
        fundMe = deployer.run();
        vm.deal(FABRIZIO, 100 ether);
    } // always run first
    modifier funded() {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe), DEFAULT_SEND_FUNDS);
        _;
    }
    function testUserCanFund() public funded {
        assertEq(address(fundMe).balance, DEFAULT_SEND_FUNDS);
    }
    function testUserCanWithdraw() public funded {
        uint256 prvBal = msg.sender.balance;
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));
        uint256 currentBal = msg.sender.balance;
        assertEq(currentBal, prvBal + DEFAULT_SEND_FUNDS);
    }
}
