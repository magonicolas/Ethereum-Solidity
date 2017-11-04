pragma solidity ^0.4.13;

contract Lotery {
    
    struct Participant {
        address adr;
        Ticket ticket;
    }
    
    struct Ticket {
        uint[] ticketNumbers;
    }
    
    address owner;
    uint public loteryNumbers;
    address[] public winners;
    bool public hasFinished = false;
    uint loteryMargin = 20;
    
    Participant[]  participants;
    
    uint min = 0;
    uint max = 30; 
    uint public otherRandomNumber = uint(block.number * block.timestamp)%(max + 1) + min;
    
    function Lotery() payable {
        
    }
    
    function buyTicket(uint[] numbers) {
        bool isParticipant = false;
        for(uint i = 0; i < participants.length; i++) {
            if(participants[i].adr == msg.sender) {
                participants[i].ticket = Ticket({ ticketNumbers: numbers});
            }
        }
        if(isParticipant == false) {
            participants.push(Participant({
                adr: msg.sender,
                ticket: Ticket({ ticketNumbers: numbers})
            }));
        }
    }
    
    function isParticipant() returns(bool) {
        for(uint i = 0; i < participants.length; i++) {
            if(participants[i].adr == msg.sender) {
                return true;
            }
        }
        return false;
    }
    
    
    function depositFunds() payable {
        
    }
    
    function withdrawFunds(uint amount) onlyOwner {
        if(this.balance >= amount) {
            owner.transfer(amount);
        } else {
            revert();
        }
    }
    
    modifier onlyOwner {
		if (msg.sender != owner) {
			revert();
		} else {
			_;
		}
	}
}