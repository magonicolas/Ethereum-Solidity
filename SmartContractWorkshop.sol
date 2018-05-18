pragma solidity ^0.4.23;

contract SmartContractWorkshop {
	
	struct Person {
		string name;
		string email;
		bool attendsOnline;
		bool purchased;
	}

	uint256 baseprice = 0.03 ether;
	uint256 priceIncrease = 0.001 ether;
	address owner;
	uint256 faceToFaceLimit = 30;
	uint256 ticketsSold;
	uint256 ticketsFaceToFaceSold;

	mapping(address=>Person) public attendants;

	function SmartContractWorkshop () {
		owner = msg.sender;
	}
	

	function register(string _name, string _email, bool _attendsOnline) payable {

		require (msg.value == currentPrice() && attendants[msg.sender].purchased == false)

		if(_attendsOnline == false ) {

			require (ticketsFaceToFaceSold < 30);
			addAttendantAndTransfer(_name, _email, _attendsOnline);
			ticketsFaceToFaceSold++;
		} else {
			addAttendantAndTransfer(_name, _email, _attendsOnline);
		}
	}

	function addAttendantAndTransfer(string _name, string _email, bool _attendsOnline) {
				attendants[msg.sender] = Person({
				name: _name,
				email: _email,
				attendsOnline: _attendsOnline,
				purchased: true
		});
		ticketsSold++;
		owner.transfer(this.balance);
	}

	function currentPrice() public view returns (uint256) {
        return baseprice + (ticketsSold * priceIncrease);
    }

    modifier onlyOwner() {
		if(owner != msg.sender) {
			revert();
		} else {
			_;
		}
	}
}