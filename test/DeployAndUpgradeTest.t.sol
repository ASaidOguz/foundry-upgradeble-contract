// SPDX-License-Identifier: MIT


pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";
import{ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import{DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import{Test} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
contract DeployAndUpgradeTest is Test{
    BoxV1 public boxv1;
    BoxV2 public boxv2;
    DeployBox public deployer;
    UpgradeBox public upgradeBox;
    address public proxy;
    address public OWNER=makeAddr("owner");

    function setUp() public{
        deployer= new DeployBox();
        proxy=deployer.run(); // -> point to BoxV1 ----<    
        upgradeBox=new UpgradeBox();
    }
    function testProxyStartsAsBoxV1() public{
        vm.expectRevert();
        BoxV2(proxy).setNumber(5);
        
        uint256 expectedVersion=1;
        assertEq(BoxV1(proxy).version(),expectedVersion);
    }
    function testUpgrades() public{
        BoxV2 boxV2=new BoxV2();
        upgradeBox.upgrade(proxy,address(boxV2));
        uint256 expectedVersion=2;
        uint256 realVersion=BoxV2(proxy).version();
        assertEq(expectedVersion,realVersion);

        BoxV2(proxy).setNumber(5);
        assertEq(BoxV2(proxy).getNumber(),5);
    }
}