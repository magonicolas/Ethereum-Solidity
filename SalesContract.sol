pragma solidity ^0.4.0;

contract SalesContract {
    address public owner;
    bool public sold = false;
    string public salesDescription = 'Volvo V40 HF 56 32';
    uint price = 2 ether;
    
    function SalesContract() payable {
        owner = msg.sender;
    }
    
    function buy() payable {
        if(msg.value >= price) {
            owner.transfer(this.balance);
            owner = msg.sender;
            sold = true;
        } else {
            revert();
        }
    }
}