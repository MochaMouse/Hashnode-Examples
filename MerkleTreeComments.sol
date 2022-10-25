// SPDX-License-Identifier: MIT
// License Specification for contract
pragma solidity ^0.8.13;
// pragma enables certain compiler features. This contract will not compile with a compiler version earlier than 0.8.13

contract MerkleProof {
    //contract name
    function verify(
        //function name, function purpose is to verify
        bytes32[] memory proof,
        //variable 'proof', a 32 byte array stored in memory
        bytes32 root,
        //variable 'root', 32 bytes
        bytes32 leaf,
        //variable 'leaf', 32 bytes
        uint index
        //variable 'index', unsigned integer
    ) public pure returns (bool) {
        //public function that does not read from or modify state and returns a boolean value
        bytes32 hash = leaf;
        //assigns leaf to bytes32 hash

        for (uint i = 0; i < proof.length; i++) {
            //loop while i < proof.length
            bytes32 proofElement = proof[i];
            //assigns proof[i] (an array element in the proof array) to bytes32 proofElement

            if (index % 2 == 0) {
                //if statement that checks if value of index is perfectly divisible by 2
                hash = keccak256(abi.encodePacked(hash, proofElement));
                //hash function
            } else {
                //else for value of index not being perfectly divisible by 2
                hash = keccak256(abi.encodePacked(proofElement, hash));
                //hash function
            }

            index = index / 2;
            // index is assigned the value of index / 2
        }

        return hash == root;
        //checks if the hash is equivalent to the root and returns a boolean of true or false accordingly
    }
}

contract TestMerkleProof is MerkleProof {
    //This contract is a tester for the 'MerkleProof' contract. It inherits from the 'MerkleProof' contract via the use of the 'is' keyword
    bytes32[] public hashes;
    //public bytes32 array named hashes

    constructor() {
        //constructor keyword
        string[4] memory transactions = [
            //array named 'transactions' of type string and size 4
            "alice -> bob",
            "bob -> dave",
            "carol -> alice",
            "dave -> bob"
            //string inputs for array
        ];

        for (uint i = 0; i < transactions.length; i++) {
            //loop
            hashes.push(keccak256(abi.encodePacked(transactions[i])));
            //append hashes array with 'keccak256(abi.encodePacked(transactions[i]))'
        }

        uint n = transactions.length;
        //unsigned integer n is assigned value of transactions.length
        uint offset = 0;
        //unsigned integer offset is assigned value 0

        while (n > 0) {
            //while loop for when value n is greater than 0
            for (uint i = 0; i < n - 1; i += 2) {
                //for loop based on condition '(uint i = 0; i < n - 1; i += 2)'
                hashes.push(
                    //hashes array appended
                    keccak256(
                        abi.encodePacked(hashes[offset + i], hashes[offset + i + 1])
                    )
                    //hash function
                );
            }
            offset += n;
            n = n / 2;
            //offset is += n, n is equal to n/2
        }
    }

    function getRoot() public view returns (bytes32) {
        return hashes[hashes.length - 1];
    }
    //getter function that returns N[N-1], hashes[hashes.length - 1]
    //There are (N-1) edges in each tree, where N is representative of number of nodes.

    /* verify
    3rd leaf
    0xdca3326ad7e8121bf9cf9c12333e6b2271abe823ec9edfe42f813b1e768fa57b

    root
    0xcc086fcc038189b4641db2cc4f1de3bb132aefbd65d510d817591550937818c7

    index
    2

    proof
    0x8da9e1c820f9dbd1589fd6585872bc1063588625729e7ab0797cfc63a00bd950
    0x995788ffc103b987ad50f5e5707fd094419eb12d9552cc423bd0cd86a3861433
    */
}
