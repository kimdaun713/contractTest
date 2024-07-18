pragma solidity ^0.8.0;

contract PostFilter {

    struct VerificationResult {
        bytes32 filter;
        uint filtersPoolID;
    }

    bytes32[] private postsMergePool;
    uint private lastPostsPoolPageID;
    
    uint private constant NUM_FILTER_IN_POOL = 10; //Number of filters in pool
    uint private constant NUM_POST_PER_FILTER = 3; //Number of posts included per filter
    uint private constant FILTER_SIZE = 256; //Filter size (bit)
    uint private constant NUM_HASH_FUNCTIONS = 7; //Number of hash functions required for bloom filter
    uint private constant MAX_POSTS_IN_POOL = NUM_FILTER_IN_POOL * NUM_POST_PER_FILTER; 
    //The maximum number of posts in the pool


    
    constructor() {
        postsMergePool.push(0); // 초기 필터 추가
        lastPostsPoolPageID = 0;
    }






    function addPost(uint postID, bytes memory postHash) public {

        uint postBundleID = (postID - 1) / NUM_POST_PER_FILTER + 1;
        uint filterIndex = (postBundleID - 1) % NUM_FILTER_IN_POOL;

        bytes32 filter = postsMergePool[filterIndex];

        for (uint i = 0; i < NUM_HASH_FUNCTIONS; i++) {
            uint hash = uint(keccak256(abi.encodePacked(postHash, i))) % FILTER_SIZE;
            filter |= (bytes32(uint(1) << hash));
        }

        postsMergePool[filterIndex] = filter;

        if (postID > (lastPostsPoolPageID + 1) * MAX_POSTS_IN_POOL)
            resetPostsMergePool();
    }





    function verifyPost(uint _postID) public view returns (VerificationResult memory) {
        VerificationResult memory verifiedResult;
        uint postMergeID = (_postID - 1) / NUM_POST_PER_FILTER + 1;
        uint filterIndex = (postMergeID - 1) % NUM_FILTER_IN_POOL;

        if (_postID <= lastPostsPoolPageID * MAX_POSTS_IN_POOL) {
            verifiedResult.filtersPoolID = _postID / MAX_POSTS_IN_POOL + 1;
            return verifiedResult;
        }

        bytes32 filter = postsMergePool[filterIndex];
        
        verifiedResult.filter = filter;
        return verifiedResult;
    }






    function getFilters() public view returns (bytes32[] memory) {
        return postsMergePool;
    }

    function getLastPostPoolPageID() public view returns (uint) {
        return lastPostsPoolPageID;
    }

    function resetPostsMergePool() internal {
        delete postsMergePool;
        postsMergePool.push(0); 
        lastPostsPoolPageID++;
    }

}
