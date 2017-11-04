pragma solidity ^0.4.0;

contract CustodialContract {

	address client;
	bool public  _switch = false;

	event UpdateStatus(string _msg);
	event UserStatus(string, _msg, address user, uint amount);
	function CustodialContract() {
		client = msg.sender;
	}

	modifier ifOwner() {
		if(client != msg.sender) {
			throw;
		} else {
			_;
		}
	}

	function depositFunds() payable {
		UserStatus(“User has deposited some money”, msg.sender, msg.value);
	}

	function witdrawFunds(uint amount) ifOwner {
		if (client.send(amount)) {
			UpdateStatus(“User transferred some money”);
			_switch = true;
		} else {
			_switch = false;
		}
	}
 	
	function getFunds() constant returns(uint) ifOwner {
		return this.balance;
	}
}