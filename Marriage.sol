pragma solidity ^0.4.23;

/**
 * This contract is a love contract, we will offer marriage 
 and accept it or rejected on the ethereum blockchain.
 *@autor: magonicolas
 */
contract MarriageContract {

	struct Marriage {
		string agreements;
		uint256 proposalDate;
		uint256 answeredDate;
		uint256 endedDate;
		address proposer;
		address proposed;
		bool accepted;
		bool ended;
	}

	event MarriageStatus(string _msg, address _proposer, address _proposed, bool _accepted, uint256 _date, bool _ended);

	mapping (address => Marriage) public marriages;

	function MarriageContract () {
		
	}	

	function proposeMarriage(string _agreements, address _proposed) {

		require (marriages[msg.sender].proposalDate == 0 || marriages[msg.sender].ended);
		
		Marriage memory _marriage = Marriage({
						agreements: _agreements,
			proposalDate: block.timestamp,
			answeredDate: 0,
			endedDate: 0,
			proposer: msg.sender,
			proposed: _proposed,
			accepted: false,
			ended: false
		});
		marriages[msg.sender] = _marriage;
		marriages[_proposed] = _marriage;
	}

	function answerMarriage(bool _accept) {
		Marriage storage _marriage = marriages[msg.sender];
		Marriage storage _marriageProposer = marriages[_marriage.proposer];

		require (_marriage.proposed == msg.sender);

		_marriage.accepted = _accept;
		_marriageProposer.accepted = _accept;
		
		_marriage.answeredDate = block.timestamp;
		_marriageProposer.answeredDate = block.timestamp;
		MarriageStatus('User has answered to Marriage proposal', _marriage.proposer, msg.sender, _accept, block.timestamp, false);
	}

	function endMarriage() {
		Marriage storage _marriage = marriages[msg.sender];
		Marriage storage _marriageProposer = marriages[_marriage.proposer];

		require (_marriage.proposed == msg.sender || _marriage.proposer == msg.sender);
		
		_marriage.ended = true;
		_marriageProposer.ended = true;
		
		_marriage.endedDate = block.timestamp;
		_marriageProposer.endedDate = block.timestamp;
		MarriageStatus('Marriage Ended', _marriage.proposer, _marriage.proposed, _marriage.accepted, block.timestamp, true);
	}
}