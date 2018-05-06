pragma solidity ^0.4.0;

contract Variables {
    string public one = 'one';
    int public two = 2;
    uint public three = 3;
    uint256 public four = 4;
    address myAddress = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    mapping (address => uint256) public payments;
    uint[] public intArray;
    
}