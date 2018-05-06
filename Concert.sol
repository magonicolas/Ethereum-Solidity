pragma solidity ^0.4.0;

contract Event {
    
    address owner;
    uint public tickets;
    string public description;
    string public website;
    uint constant price = 0.01 ether;
    mapping (address => uint) public purchasers;
    
    function Event(uint t, string _description, string _webstite) {
        owner = msg.sender;
        description = _description;
        website = _webstite;
        tickets = t;
    }
    
    function () payable {
        buyTickets(1);
    }
    
    function buyTickets(uint amount) payable {
        if (msg.value != (amount * price) || amount > tickets) {
            revert();
        }
        purchasers[msg.sender] += amount;
        tickets -= amount;
        if (tickets == 0) {
            owner.transfer(this.balance);
        }
    }
    
    function refund(uint numTickets)  {
        if (purchasers[msg.sender] < numTickets) {
            revert();
        }
        
        msg.sender.transfer(numTickets * price);
        purchasers[msg.sender] -= numTickets;
        tickets += numTickets;
    }
    
}


