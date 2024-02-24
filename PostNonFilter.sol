// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PostUnfilterContract {
    struct Post {
        bytes32 hash;
        address writerID;
    }

    mapping(uint256 => Post) private posts;
    uint256 private postCount = 0;

    function addPost(uint256 id, bytes32 hash, address writerID) public {
        require(!postExists(id), "Post already exists.");
        posts[id] = Post(hash, writerID);
        postCount += 1;
    }

    function updatePost(uint256 id, bytes32 newHash, address writerID) public {
        require(postExists(id), "Post does not exist.");
        require(posts[id].writerID == writerID, "Only the writer can update the post.");
        require(posts[id].writerID == msg.sender, "Transaction sender is not the writer.");
        
        posts[id].hash = newHash;
    }

    //게시물 검증
    function verifyPost(uint256 id, bytes32 hash) public view returns (bool) {
        if (!postExists(id)) {
            return false;
        }
        return posts[id].hash == hash;
    }

    // 등록된 게시글 수 반환
    function getPostCount() public view returns (uint256) {
        return postCount;
    }

    // 내부 게시글 존재 여부 검사 함수
    function postExists(uint256 id) private view returns (bool) {
        return posts[id].writerID != address(0);
    }
}
