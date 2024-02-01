
contract BloomFilter {
    // 블룸 필터의 비트 배열
    uint8[] private filter;

    // 필터 크기
    uint private constant filterSize = 500;
    uint private count = 0;
    // 해시 함수의 개수
    uint private constant numHashFunctions = 10;

    // 생성자에서 비트 배열 초기화
    constructor () {
             filter = new uint8[](filterSize);
        
    }

    // 아이템 추가
    function addItem(bytes32 item) public {
        for(uint i = 0; i < numHashFunctions; i++) {
            uint hash = uint(keccak256(abi.encodePacked(item, i))) % (filterSize * 8);
            uint byteIndex = hash / 8;
            uint bitIndex = hash % 8;

            uint8 mask = uint8(1 << bitIndex);

           filter[byteIndex] = mask;
        }
    }

    // 아이템 존재 여부 확인
    function isItemExist(bytes32 item) public view returns (bool) {
        for (uint i = 0; i < numHashFunctions; i++) {
            uint hash = uint(keccak256(abi.encodePacked(item, i))) % (filterSize * 8);
            uint byteIndex = hash / 8;
            uint bitIndex = hash % 8;

            uint8 mask = uint8(1 << bitIndex);
            if ((filter[byteIndex] & mask) == 0) {
                return false; // 비트가 비활성화되어 있으면 데이터 없음
            }
        }
        return true; // 모든 비트가 활성화되어 있으면 데이터 있음
    }

    // 블룸 필터 배열 확인
    function getFilter() public view returns (uint8[] memory) {
        return filter;
    }
}
