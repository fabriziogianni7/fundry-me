// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is StdCheats, Test {
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

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }
    function testCheckOwner() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }
    function testPriceOracle() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
    // //revert if not send enough eth
    function testFailsIfSendNoFunds() public {
        vm.expectRevert("revert: You need to spend more ETH!");
        fundMe.fund();
    }
    function testFailsIfWithdrawNotOwner() public {
        vm.expectRevert("revert");
        fundMe.withdraw();
    }

    modifier funded() {
        vm.prank(FABRIZIO);
        fundMe.fund{value: DEFAULT_SEND_FUNDS}();
        assert(address(fundMe).balance > 0);
        _;
    }

    function testDataStructUpdatedAfterFund() public funded {
        uint256 fundedAmount = fundMe.getAddressToAmountFunded(FABRIZIO);
        assertEq(fundedAmount, DEFAULT_SEND_FUNDS);
    }

    function testGetFunders() public funded {
        address returnedAddr = fundMe.getFunders(0);
        assertEq(returnedAddr, FABRIZIO);
    }

    function testWithdrawFromASingleFunder() public funded {
        // Arrange
        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        // vm.txGasPrice(GAS_PRICE);
        // uint256 gasStart = gasleft();
        // // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // uint256 gasEnd = gasleft();
        // uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;

        // Assert
        uint256 endingFundMeBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalance // + gasUsed
        );
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;
        for (
            uint160 i = startingFunderIndex;
            i < numberOfFunders + startingFunderIndex;
            i++
        ) {
            // we get hoax from stdcheats
            // prank + deal
            hoax(address(i), STARTING_USER_BALANCE);
            fundMe.fund{value: DEFAULT_SEND_FUNDS}();
        }

        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fundMe.getOwner().balance
        );
        assert(
            (numberOfFunders + 1) * DEFAULT_SEND_FUNDS ==
                fundMe.getOwner().balance - startingOwnerBalance
        );
    }
    function testWithdrawFromMultipleFundersOptimized() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;
        for (
            uint160 i = startingFunderIndex;
            i < numberOfFunders + startingFunderIndex;
            i++
        ) {
            // we get hoax from stdcheats
            // prank + deal
            hoax(address(i), STARTING_USER_BALANCE);
            fundMe.fund{value: DEFAULT_SEND_FUNDS}();
        }

        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdrawOptimized();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fundMe.getOwner().balance
        );
        assert(
            (numberOfFunders + 1) * DEFAULT_SEND_FUNDS ==
                fundMe.getOwner().balance - startingOwnerBalance
        );
    }
}
