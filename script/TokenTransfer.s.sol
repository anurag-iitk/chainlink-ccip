// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {TokenTransfer} from "../src/TransferToken.sol";

contract CounterScript is Script {
    TokenTransfer public tokenTransfer;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        tokenTransfer = new TokenTransfer(
            0xF694E193200268f9a4868e4Aa017A0118C9a8177,
            0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846
        );

        vm.stopBroadcast();
    }
}
