pragma solidity ^0.8.0;

contract BloomFilter {
    // 블룸 필터의 비트 배열
    bytes private filter;

    // 필터 크기
    uint private constant filterSize = 1;
    uint private count = 0;
    // 해시 함수의 개수
    uint private constant numHashFunctions = 1;

    // 생성자에서 비트 배열 초기화
  

    // 아이템 추가
    function addItem(bytes memory item) public {
        if(count == 0){
        filter = new bytes(filterSize);
        }        
        for(uint i = 0; i < numHashFunctions; i++) {
            uint hash = uint(keccak256(abi.encodePacked(item, i))) % (filterSize * 8);
            uint byteIndex = hash / 8;
            uint bitIndex = hash % 8;

            bytes1 mask = bytes1(uint8(1) << bitIndex);
            filter[byteIndex] = filter[byteIndex] | mask;
        }
        count++;
    }
    

    function isItemExist(bytes memory item) public view returns (bool) {
        for (uint i = 0; i < numHashFunctions; i++) {
            uint hash = uint(keccak256(abi.encodePacked(item, i))) % (filterSize * 8);
            uint byteIndex = hash / 8;
            uint bitIndex = hash % 8;
            if ((uint8(filter[byteIndex]) & (uint8(1) << bitIndex)) == 0) {
                return false; // 비트가 비활성화되어 있으면 데이터가 없음
            }
        }
        return true; // 모든 비트가 활성화되어 있으면 데이터 있음
    }

    // 블룸 필터 배열 확인
    function getFilter() public view returns (bytes memory) {
        return filter;
    }
}
