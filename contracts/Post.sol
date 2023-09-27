// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract Post {

    
mapping(string => bool) postHash;

    function addPostsHash(string memory _hash) public {
        
        postHash[_hash] = true;

    }

    function getPostHash(string memory _hash) public view returns (bool) {

        return postHash[_hash];

    }

   
}