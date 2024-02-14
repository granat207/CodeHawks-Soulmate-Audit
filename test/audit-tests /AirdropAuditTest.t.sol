// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";

import {IVault} from "../../src/interface/IVault.sol";
import {ISoulmate} from "../../src/interface/ISoulmate.sol";
import {ILoveToken} from "../../src/interface/ILoveToken.sol";
import {IStaking} from "../../src/interface/IStaking.sol";

import {Vault} from "../../src/Vault.sol";
import {Soulmate} from "../../src/Soulmate.sol";
import {LoveToken} from "../../src/LoveToken.sol";
import {Airdrop} from "../../src/Airdrop.sol";
import {Staking} from "../../src/Staking.sol";

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


    function test_Airdrop__DaysInSecond()public{
    assertEq(airdropContract.daysInSecond(), 86400); 
    }

    function test_Airdrop__Claim__TranferFromIsCorrect()public{
    address soulmate1 = address(1);
    address soulmate2 = address(2); 
    vm.startPrank(soulmate1); 
    soulmateContract.mintSoulmateToken();
    vm.stopPrank(); 
    vm.startPrank(soulmate2);
    soulmateContract.mintSoulmateToken();
    vm.warp(block.timestamp + 86400); 
    airdropContract.claim();
    vm.stopPrank(); 
    uint256 soulmate2LoveTokensBalance = loveToken.balanceOf(soulmate2); 
    assertEq(soulmate2LoveTokensBalance / 1e18, 1); 
    }

    function test__Airdrop__CanClaimOnlyOneTimeIn1Day()public{
    address soulmate1 = address(1);
    address soulmate2 = address(2); 
    vm.startPrank(soulmate1); 
    soulmateContract.mintSoulmateToken();
    vm.stopPrank(); 
    vm.startPrank(soulmate2);
    soulmateContract.mintSoulmateToken();
    vm.warp(block.timestamp + 86400); 
    airdropContract.claim();
    vm.expectRevert(); 
    airdropContract.claim(); 
    }

    function test__Airdrop__CanClaimIf1DayIsOccured()public{
    address soulmate1 = address(1);
    address soulmate2 = address(2); 
    vm.startPrank(soulmate1); 
    soulmateContract.mintSoulmateToken();
    vm.stopPrank(); 
    vm.startPrank(soulmate2);
    soulmateContract.mintSoulmateToken();
    vm.warp(block.timestamp + 86400); 
    airdropContract.claim();
    vm.warp(block.timestamp + 86400);
    airdropContract.claim(); 
    vm.stopPrank(); 
    uint256 soulmate2LoveTokensBalance = loveToken.balanceOf(soulmate2); 
    assertEq(soulmate2LoveTokensBalance / 1e18, 2); 
    }

    function test__Airdrop__FirstSoulmateCanClaim()public{
    address soulmate1 = address(1);
    address soulmate2 = address(2); 
    vm.startPrank(soulmate1); 
    soulmateContract.mintSoulmateToken();
    vm.stopPrank(); 
    vm.startPrank(soulmate1);
    soulmateContract.mintSoulmateToken();
    vm.warp(block.timestamp + 86400); 
    airdropContract.claim();
    }

    function test__Airdrop__FirstSoulmateCantClaimIfOneDayIsNotPassed()public{
    address soulmate1 = address(1);
    address soulmate2 = address(2); 
    vm.startPrank(soulmate1); 
    soulmateContract.mintSoulmateToken();
    vm.stopPrank(); 
    vm.startPrank(soulmate1);
    soulmateContract.mintSoulmateToken();
    vm.warp(block.timestamp + 80000); //If the life of a couple is less than 1 day, this axtion will revert
    vm.expectRevert(); 
    airdropContract.claim();
    }

    function test__Airdrop__CantClaimIfSoulmatesAreNotReunited()public{
    address soulmate1 = address(1);
    address soulmate2 = address(2); 
    vm.startPrank(soulmate1); 
    vm.expectRevert(); 
    airdropContract.claim();
    }

    function test__Airdrop__EveryoneCanClaimIfPassesMoreThan1Day__Example1()public{
    address soulmate1 = address(1);
    address soulmate2 = address(2); 
    vm.startPrank(soulmate1); 
    vm.warp(block.timestamp + 86400);
    airdropContract.claim();
    }

    function test__Airdrop__EveryoneCanlaimIfPassessMoreThan1DAY__Example2()public{
    address randomAddr = address(123); 
    vm.startPrank(randomAddr); 
    vm.warp(block.timestamp + 86400);
    airdropContract.claim();
    uint256 balance = loveToken.balanceOf(randomAddr); 
    assertEq(balance / 1e18, 1); 
    }

    function test__Airdrop__EveryoneCanlaimIfPassessMoreThan1DAY__Example3()public{
    address randomAddr = address(123); 
    vm.startPrank(randomAddr); 
    vm.warp(block.timestamp + 86400);
    airdropContract.claim();
    vm.expectRevert(); 
    airdropContract.claim();
    }

    function test__Airdrop__EveryoneCanlaimIfPassessMoreThan1DAY__Example4()public{
    address randomAddr = address(123); 
    vm.startPrank(randomAddr); 
    vm.warp(block.timestamp + 86400);
    airdropContract.claim();
    vm.warp(block.timestamp + 86400);
    airdropContract.claim();
    uint256 balance = loveToken.balanceOf(randomAddr); 
    assertEq(balance / 1e18, 2); 
    }
    
}