pragma solidity ^0.4.0;

contract Savings {

	address owner;

	event UserStatus(string _msg, address user, uint amount, uint256 time);
	
	function Savings() payable {
		owner = msg.sender;
		UserStatus('User has created a savings account', msg.sender, msg.value, block.timestamp);
	}

	modifier onlyOwner() {
		if(owner != msg.sender) {
			revert();
		} else {
			_;
		}
	}

	function depositFunds() payable {
		UserStatus('User has deposited some money', msg.sender, msg.value, block.timestamp);
	}

	function withdrawFunds(uint amount) onlyOwner {
		if (owner.send(amount)) {
			UserStatus('User has withdrawn some money', msg.sender, amount, block.timestamp);
		} 
	}
 	
	function getAllFunds() onlyOwner   {
		UserStatus('User Removed all Funds', msg.sender, this.balance, block.timestamp);
		owner.transfer(this.balance);
	}
	function Kill() onlyOwner {
		UserStatus('Contract Disabled, Transfering Balance to Owner', msg.sender, this.balance, block.timestamp);
	    suicide(owner);
	}
}