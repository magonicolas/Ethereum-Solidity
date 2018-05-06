pragma solidity ^0.4.18;

contract CryptoPay {

	address owner;

	mapping (address => uint256) public payments;

	modifier onlyOwner() { 
		require(msg.sender == owner);
		_; 
	}

	function CryptoPay() {
		owner = msg.sender;
	}

	function transferOwnership(address _newOwner) onlyOwner {
		owner = _newOwner;
	}

	function requestPayment(address _to) payable onlyOwner {
		payments[_to] = msg.value;
	}

	function pay(address _to) onlyOwner {
		_to.transfer(payments[_to]);
		payments[_to] = 0;
	}

	function withdraw(uint256 _amount) onlyOwner {
		require(this.balance >= _amount ether);
		owner.transfer(_amount);
	}
	
}