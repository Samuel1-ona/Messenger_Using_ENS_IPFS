// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "../lib/forge-std";
import {Chat} from "../src/Chat.sol";
import {ENS} from "../src/ENS.sol";

contract CounterTest is Test {
    ENS public ens;
    Chat public chat;

    address SamAddr = address(0x477b144FbB1cE15554927587f18a27b241126FBC);
    address ChisomAddr = address(0xe902aC65D282829C7a0c42CAe165D3eE33482b9f);

    function setUp() public {
        ens = new ENS();
        chat = new Chat(address(ens));

        switchSigner(SamAddr);
        ens.setName("Samuel");

        switchSigner(ChisomAddr);
        ens.setName("Chisom");
    }

    function test_SetName() public view {
        assertEq(ens.getNameFromAddress(SamAddr), "Samuel");
        assertEq(ens.getNameFromAddress(ChisomAddr), "Chisom");
    }

    function test_SendMessage() public {
        switchSigner(SamAddr);
        chat.sendMessage("Chisom", "Hello are you doing");
        assertEq(chat.getSentMessages("Chisom")[0], "Hello are you doing"));
    }

    function test_getMessage() public {
        switchSigner(SamAddr);
        chat.sendMessage("Chisom", "Hello are you doing");

        switchSigner(ChisomAddr);
       
        console.log(chat.getChats("Samuel")[0]);
        assertEq(chat.getChats("Samuel")[0], "Hello are you doing"));
    }

    function switchSigner(address _newSigner) public {
        address foundrySigner = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;
        if (msg.sender == foundrySigner) {
            vm.startPrank(_newSigner);
        } else {
            vm.stopPrank();
            vm.startPrank(_newSigner);
        }
    }

}
