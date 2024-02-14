//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18; 

import {console, Test} from "forge-std/Test.sol";
// import {BaseAuditTest} from "./BaseAuditTest.t.sol";
import {Soulmate} from "../../src/Soulmate.sol";

contract SoulmateAuditTest is Test{
Soulmate public soulmate; 

function setUp()public{
soulmate = new Soulmate(); 
}

//mintSoulmateToken()
function test_mintSoulmateToken()public{
address soulmate1 = address(1);
address soulmate2 = address(2); 
address soulmate3 = address(3);
address soulmate4 = address(4); 
vm.startPrank(soulmate1); 
soulmate.mintSoulmateToken();
console.log("Soulmate1 is waiting for another soulmate"); 
vm.stopPrank(); 
vm.startPrank(soulmate2);
soulmate.mintSoulmateToken();
vm.stopPrank(); 
console.log("The soulmate2 of soulmate1 is", soulmate.soulmateOf(soulmate1)); 
console.log("The soulmate1 of soulmate2 is", soulmate.soulmateOf(soulmate2)); 
console.log("The balance of soulmate1 is", soulmate.balanceOf(soulmate1)); 
console.log("The balance of soulmate2 is", soulmate.balanceOf(soulmate2)); 
console.log("ANOTHER EXAMPLE"); 
vm.startPrank(soulmate3); 
soulmate.mintSoulmateToken();
console.log("Soulmate3 is waiting for another soulmate"); 
vm.stopPrank(); 
vm.startPrank(soulmate4);
soulmate.mintSoulmateToken();
vm.stopPrank(); 
console.log("The soulmate4 of soulmate3 is", soulmate.soulmateOf(soulmate3)); 
console.log("The soulmate3 of soulmate4 is", soulmate.soulmateOf(soulmate4)); 
console.log("The balance of soulmate3 is", soulmate.balanceOf(soulmate3)); 
console.log("The balance of soulmate4 is", soulmate.balanceOf(soulmate4)); 
assertEq(soulmate.totalSupply(), 2);
}

function test_mintSoulmateToken__AlreadyHaveASoulmate()public{
address soulmate1 = address(1);
address soulmate2 = address(2); 
vm.startPrank(soulmate1); 
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate2);
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate1); 
vm.expectRevert();
soulmate.mintSoulmateToken();
vm.stopPrank(); 
}

function test_mintSoulmateToken__CheckingCorrectMappings()public{
address soulmate1 = address(1);
address soulmate2 = address(2); 
vm.startPrank(soulmate1); 
soulmate.mintSoulmateToken();
vm.stopPrank(); 
assertEq(soulmate.ownerToId(address(1)), 0); 
vm.startPrank(soulmate2);
uint256 currentTimestamp = block.timestamp; 
uint256 timestampDelayedof10Seconds = block.timestamp + 10; 
soulmate.mintSoulmateToken();
vm.stopPrank(); 
assertEq(soulmate.ownerToId(address(2)), 0); 
assertEq(soulmate.soulmateOf(address(1)), address(2)); 
assertEq(soulmate.soulmateOf(address(2)), address(1)); 
assertTrue(soulmate.idToCreationTimestamp(0) >= currentTimestamp && soulmate.idToCreationTimestamp(0) < timestampDelayedof10Seconds);
}


//tokenURI()
function test_tokenURI(uint256 tokenId)public{
tokenId = bound(tokenId, 0, 10000); 
assertEq(soulmate.tokenURI(tokenId), ""); 
}


//transferFrom()
function test_transferFrom()public{
address soulmate1 = address(1);
address soulmate2 = address(2); 
vm.startPrank(soulmate1); 
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate2);
soulmate.mintSoulmateToken();
vm.expectRevert(); 
soulmate.transferFrom(address(2), address(this), 1);
}

function test_safeTransferFrom()public{
address soulmate1 = address(1);
address soulmate2 = address(this); 
vm.startPrank(soulmate1); 
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate2);
soulmate.mintSoulmateToken();
vm.expectRevert(); 
soulmate.safeTransferFrom(address(this), soulmate1, 0);
}

//writeMessageInSharedSpace() && readMessageInSharedSpace()
function test_writeMessageInSharedSpaceAndRead()public{
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
string memory message = soulmate.readMessageInSharedSpace();
console.log("Soulmate1 wrote a message and he is reading the message that it is: ", message); 
vm.stopPrank(); 
vm.startPrank(soulmate2); 
string memory message2 = soulmate.readMessageInSharedSpace();
console.log("Soulmate2 is reading the message of soulmate 1 that it is: ", message2); 
vm.stopPrank(); 

vm.startPrank(soulmate2);
soulmate.writeMessageInSharedSpace("I'm Fine thank you");
string memory message3 = soulmate.readMessageInSharedSpace();
console.log("Soulmate2 wrote a message and he is reading the message that it is: ", message3); 
vm.stopPrank(); 
vm.startPrank(soulmate1); 
string memory message4 = soulmate.readMessageInSharedSpace();
console.log("Soulmate1 is reading the message of soulmate 1 that it is: ", message4); 
vm.stopPrank(); 
address randomUser = address(100);
vm.startPrank(randomUser); 
string memory message5 = soulmate.sharedSpace(0);
console.log("An external user is reading the message:", message5);
}

//getDivorced()
function test_getDivorced()public{
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
vm.stopPrank(); 
vm.startPrank(soulmate2); 
assertEq(soulmate.isDivorced(), true); 
}

function test_getDivorced2()public{
address soulmate1 = address(1);
address soulmate2 = address(2); 
vm.startPrank(soulmate1); 
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate2);
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate2); 
soulmate.getDivorced();
assertEq(soulmate.isDivorced(), true); 
vm.stopPrank(); 
vm.startPrank(soulmate1); 
assertEq(soulmate.isDivorced(), true); 
}


//totalSouls()
function test_totalSouls() public{
address soulmate1 = address(1);
address soulmate2 = address(2); 
vm.startPrank(soulmate1); 
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate2);
soulmate.mintSoulmateToken();
vm.stopPrank(); 
assertEq(soulmate.totalSouls(), 2);
}

function test_totalSoulsWithDivorced() public{
address soulmate1 = address(1);
address soulmate2 = address(2); 
vm.startPrank(soulmate1); 
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate2);
soulmate.mintSoulmateToken();
vm.stopPrank(); 
vm.startPrank(soulmate2); 
soulmate.getDivorced();
console.log("Now after the divorce, the total amounts of souls should be 0 but it is still", soulmate.totalSouls()); 
}
}