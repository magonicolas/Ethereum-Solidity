pragma solidity ^0.4.0;
contract mortal {
	address public owner;
	function mortal() {
		owner = msg.sender;
	}
	modifier onlyOwner {
		if (msg.sender != owner) {
			throw;
		} else {
			_;
		}
	}
	function kill() onlyOwner {
		suicide(owner); 
	}
}
contract User is mortal {
	string public userName;
	
	function User(string _name) {
		userName = _name;
	}
}
contract Provider is mortal {
	string public providerName;

	function Provider(string _name) {
		providerName = _name;
	}
}
