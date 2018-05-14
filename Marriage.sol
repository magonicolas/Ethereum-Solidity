pragma solidity ^0.4.23;

/**
 * This contract is a love contract, we will offer marriage 
 and accept it or rejected on the ethereum blockchain.
 @autor: magonicolas
 */
contract Marriage {

	struct Marriage {
		uint id;
		string agreements;
		uint256 proposalDate;
		uint256 acceptedDate;
		uint256 endedDate;
		address proposer;
		address proposed;
		bool accepted;
		bool ended;
	}

	mapping (uint => Marriage) public marriages;

	function Marriage () {
		
	}	

	function proposeMArriage(uint _id, string _agreements, address _proposed) payable {
		
		Marriage memory _marriage = Marriage({
			id: _id,
			agreements: _agreements,
			proposalDate: block.timestamp,
			acceptedDate: 0,
			endedDate: 0,
			proposer: msg.sender,
			proposed: _proposed,
			accepted: false,
			ended: false
		});
		marriages[_id] = _marriage;
	}
}
