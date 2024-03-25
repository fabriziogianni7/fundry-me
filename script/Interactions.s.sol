// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

// call fund and withdraw
// testing this in integrations

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

// fund the most recently deployed contract
contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 6e18;
    function run() external {
        address mostRecentFundMeAddress = DevOpsTools
            .get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(mostRecentFundMeAddress, SEND_VALUE);
    }

    function fundFundMe(address fundMeAddress, uint256 amount) public {
        vm.startBroadcast();
        FundMe(payable(fundMeAddress)).fund{value: amount}();
        vm.stopBroadcast();
        console.log("sent %s to fundMe contract", amount);
    }
}
contract WithdrawFundMe is Script {
    function run() external {
        address mostRecentFundMeAddress = DevOpsTools
            .get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecentFundMeAddress);
    }

    function withdrawFundMe(address fundMeAddress) public {
        vm.startBroadcast();
        FundMe(payable(fundMeAddress)).withdrawOptimized();
        vm.stopBroadcast();
        console.log("withdrawn all balance from fundMe contract");
    }
}
