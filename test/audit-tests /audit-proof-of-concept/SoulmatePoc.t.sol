//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18; 

import {console, Test} from "forge-std/Test.sol";
// import {BaseAuditTest} from "./BaseAuditTest.t.sol";
import {Soulmate} from "../../../src/Soulmate.sol";

contract SoulmatePoc is Test{
Soulmate public soulmate; 

function setUp()public{
soulmate = new Soulmate(); 
}

function test__Soulmate__OnlyOnePeopleCanMintTheNft()public{
address soulmate1 = address(1);
address soulmate2 = address(2); 
vm.startPrank(soulmate1); 
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate2);
soulmate.mintSoulmateToken();
vm.stopPrank(); 
uint256 soulmate2Balance = soulmate.balanceOf(soulmate2);
uint256 soulmate1Balance = soulmate.balanceOf(soulmate1);
assertNotEq(soulmate2Balance, soulmate1Balance); 
}

function test__Soulmate__SoulmateOfNotWellImplemented()public{
address soulmate1 = address(1);
address soulmate2 = address(2); 
vm.startPrank(soulmate1); 
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate2);
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate1); 
soulmate.getDivorced();
assertEq(soulmate.isDivorced(), true); 
address checkSoulmate = soulmate.soulmateOf(address(1)); 
assertEq(checkSoulmate, soulmate2); 
}

function test__Soulmate__IsDivorcedNotWellImplemented()public{
address soulmate1 = address(1);
address soulmate2 = address(2); 
vm.startPrank(soulmate1); 
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate2);
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate1); 
soulmate.getDivorced();
assertEq(soulmate.isDivorced(), true); 
}

function test__Soulmate__AnUserCanMintATokenWithHimSelf()public{
address soulmate1 = address(1);
address soulmate2 = address(2); 
vm.startPrank(soulmate1); 
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate1);
soulmate.mintSoulmateToken();
vm.stopPrank(); 
}

function test__Soulmate__DifferentsMessagesFromMappingToFunction()public{
address soulmate1 = address(1);
address soulmate2 = address(this); 
vm.startPrank(soulmate1); 
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate2);
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate1);
soulmate.writeMessageInSharedSpace("Hey, how are you?");
string memory messageReadFromFunc = soulmate.readMessageInSharedSpace();
string memory messageReadFromMapping = soulmate.sharedSpace(0);
assertNotEq(messageReadFromFunc, messageReadFromMapping);
}

function test__Soulmate__RandomnessInReadMessageSharedSpace()public{
address soulmate1 = address(1);
address soulmate2 = address(this); 
vm.startPrank(soulmate1); 
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate2);
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate1);
soulmate.writeMessageInSharedSpace("Hey, how are you?");
string memory messageReadFromFunc = soulmate.readMessageInSharedSpace();
string memory messageReadFromMapping = soulmate.sharedSpace(0);
assertEq(messageReadFromFunc,"Hey, how are you?, darling");
}
}