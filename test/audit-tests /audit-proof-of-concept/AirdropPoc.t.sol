// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";

import {IVault} from "../../../src/interface/IVault.sol";
import {ISoulmate} from "../../../src/interface/ISoulmate.sol";
import {ILoveToken} from "../../../src/interface/ILoveToken.sol";
import {IStaking} from "../../../src/interface/IStaking.sol";

import {Vault} from "../../../src/Vault.sol";
import {Soulmate} from "../../../src/Soulmate.sol";
import {LoveToken} from "../../../src/LoveToken.sol";
import {Airdrop} from "../../../src/Airdrop.sol";
import {Staking} from "../../../src/Staking.sol";

contract VaultAuditTest is Test{
    Soulmate public soulmateContract;  
    LoveToken public loveToken;
    Staking public stakingContract;
    Airdrop public airdropContract;
    Vault public airdropVault;
    Vault public stakingVault;

    address deployer = address(100);

    function setUp()public{
    vm.startPrank(deployer);
        airdropVault = new Vault();
        stakingVault = new Vault();
        soulmateContract = new Soulmate();
        loveToken = new LoveToken(
            ISoulmate(address(soulmateContract)),
            address(airdropVault),
            address(stakingVault)
        );
        stakingContract = new Staking(
            ILoveToken(address(loveToken)),
            ISoulmate(address(soulmateContract)),
            IVault(address(stakingVault))
        );

        airdropContract = new Airdrop(
            ILoveToken(address(loveToken)),
            ISoulmate(address(soulmateContract)),
            IVault(address(airdropVault))
        );
        airdropVault.initVault(
            ILoveToken(address(loveToken)),
            address(airdropContract)
        );
        stakingVault.initVault(
            ILoveToken(address(loveToken)),
            address(stakingContract)
        );
        vm.stopPrank();
    }
 
function test__AirdropEveryoneCanClaim1TokenPerDay()public{
vm.startPrank(address(1)); 
vm.warp(block.timestamp + 87400); //--> A few more than 1 day 
airdropContract.claim();
assertEq(loveToken.balanceOf(address(1)), 1 * 1e18); 
}
}