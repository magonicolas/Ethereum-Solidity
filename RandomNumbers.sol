pragma solidity ^0.4.0;

contract RandomNumber {
    
    uint min = 0;
    uint max = 3; 
    
    uint public random_number = uint(block.blockhash(block.number-1))%(max + 1) + min;
    
}
