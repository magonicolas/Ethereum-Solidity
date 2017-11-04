pragma solidity ^0.4.0;

contract CoinFlip {
    
    address owner;
    uint payPercentaje = 90;
    
    event Status(string _msg, address user, uint amount);
    
    function CoinFlip() payable {
        
    }
    
    modifier onlyOwner {
		if (msg.sender != owner) {
			revert();
		} else {
			_;
		}
	}
    
    function betTail() payable {
        if((block.timestamp % 2) == 0) {
            if(this.balance < ((msg.value*payPercentaje)/100)) {
                Status('Congratulations, It was Tail, You won! Sry, we didnt have enought Money to pay you, we pay you all the remaining balance of this contract', msg.sender, this.balance);
                msg.sender.transfer(this.balance);
            } else {
                msg.sender.transfer(msg.value * (100 + payPercentaje)/100);
                Status('Congratulations, It was Tail,You won!', msg.sender, msg.value * (100 + payPercentaje)/100);
            }
        } else {
            Status('We are sorry, it was Head, you lose, try Again to recover your money', msg.sender, msg.value);
        }
    }
    
    function betHead() payable {
        if((block.timestamp % 2) != 0) {
            if(this.balance < ((msg.value*payPercentaje)/100)) {
                Status('Congratulations, It was Head, You won! Sry, we didnt have enought Money to pay you, we pay you all the remaining balance of this contract', msg.sender, this.balance);
                msg.sender.transfer(this.balance);
            } else {
                msg.sender.transfer(msg.value * (100 + payPercentaje)/100);
                Status('Congratulations, It was Head,You won!', msg.sender, msg.value * (100 + payPercentaje)/100);
            }
        } else {
            Status('We are sorry, it was Tail, you lose, try Again to recover your money', msg.sender, msg.value);
        }
    }
    
        
    function kill() onlyOwner {
        Status('Contracted Killed, not longer available to use', msg.sender, this.balance);
	    suicide(owner);
	}
}