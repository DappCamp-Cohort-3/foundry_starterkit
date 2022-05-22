// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/PetPark.sol";

contract PetParkTest is Test {
   
    PetPark petPark;
    
    function setUp() public {
        petPark  = new PetPark();
    }

    function testWhenCalledByOwner() public {
        petPark.add(PetPark.Animal.Fish, 5);
        assertEq(petPark.animalCounts(PetPark.Animal.Fish), 5);
    }

    function testWhenNotCalledByOwner() public {
        vm.expectRevert(
            bytes("Not an owner")
        );
        vm.prank(address(0));
        // vm.label(address(0), "Not Owner Address");
        petPark.add(PetPark.Animal.Fish, 5);        
    }

    function testWhenCalledByOwnerWithInvalidAnimal() public {
        vm.expectRevert(
            bytes("Invalid animal")
        );
        petPark.add(PetPark.Animal.none, 5);
    }

    function testBorrowShouldRevertWhenAgeisZero() public {
        vm.expectRevert(
            bytes("Invalid Age")
        );
        petPark.borrow(0, PetPark.Gender.Male, PetPark.Animal.Fish);
    }

    function testBorrowShouldRevertWhenANimalIsNotAvailable() public {
         vm.expectRevert(
            bytes("Selected animal not available")
        );
        petPark.borrow(24, PetPark.Gender.Male, PetPark.Animal.Fish);
    }

    function testBorrowShouldRevertWhenBorrowingAnimalsOtherThanFishAndDog() public {
        petPark.add(PetPark.Animal.Cat, 5);
        petPark.add(PetPark.Animal.Rabbit, 5);
        petPark.add(PetPark.Animal.Parrot, 5);

        vm.expectRevert(
            bytes("Invalid animal for men")
        );
        petPark.borrow(24, PetPark.Gender.Male, PetPark.Animal.Cat);
    }

}