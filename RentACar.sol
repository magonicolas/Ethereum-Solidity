pragma solidity ^0.4.0;

contract RentACar {

	address public owner;
	string public carModel;
	string public priceDescription = 'You should deposit 2 Ether per day Plus 1 Ether per Day as a Late Secure Payment';
	bool public availableForRent = true;
	address public rentedBy;
	uint256 public rentedFor;
	uint256 public rentedAt;
	uint public constant pricePerDay = 0.2 ether;
	uint public constant latePrice = 0.1 ether;

	event UserStatus(string _msg, address user, uint amount, uint256 time);

	function RentACar (string _carModel) {
		owner = msg.sender;
		carModel = _carModel;
		UserStatus('Car Contract Created', msg.sender, 0, block.timestamp);
	}

	function rentCar(uint256 _days) payable {
		if(msg.value == ((pricePerDay + latePrice)*_days) && availableForRent == true) {
			rentedAt = block.timestamp;
			rentedFor = _days;
			rentedBy = msg.sender;
			availableForRent = false;
			UserStatus('Car Rented', msg.sender, msg.value, block.timestamp);
		} else {
			revert();
		}
	}	

	function returnCar() onlyRenter {
		if(block.timestamp > (rentedAt + rentedFor)) {
			UserStatus('Car Returned Late, latePrice send to Company', msg.sender, 0, block.timestamp);
		} else {
			rentedBy.transfer(latePrice);
			UserStatus('Car Returned on Time', msg.sender, 0, block.timestamp);
		}
		owner.transfer(this.balance);
		availableForRent = true;
		rentedBy = owner;
	}

	modifier onlyRenter() {
		if(rentedBy == msg.sender) {
			_;
		} else {
			revert();
		}
	}
}
