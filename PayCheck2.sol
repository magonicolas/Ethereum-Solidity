pragma solidity ^0.4.0;

contract PayCheck {

    address[] employees = [0xE83fad0b5EdF2999c29a00199Ca9B773A4627239, 0xc6A0c2424BF99f3E65799316710448FdE8c2B228];
    
    mapping (address => uint) withdrawnAmounts;
    
    function PayCheck() payable {
    }
    
    function () payable {
    }
    
    modifier canWithdraw() {
        bool contains = false;
        
        for(uint i = 0; i < employees.length; i++) {
            if(employees[i] == msg.sender) {
                contains = true;
            }
        }
        require(contains);
        _;
    }
    
    function withdraw() canWithdraw {
        uint amountAllocated = this.balance/employees.length;
        uint amountWithdrawn = withdrawnAmounts[msg.sender];
        uint amount = amountAllocated - amountWithdrawn;
        withdrawnAmounts[msg.sender] = amountWithdrawn + amount;
        if (amount > 0) {
            msg.sender.transfer(amount);
        }
        
    }
    
}