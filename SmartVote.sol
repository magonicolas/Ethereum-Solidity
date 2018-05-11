pragma solidity ^0.4.18;

contract SmartVote {

	struct Election {
		mapping (address => bool) ableToVote;
		
		uint yesVotes;
		uint noVotes;	
		uint totalVotes;
	}
	
	mapping (uint => Election) elections;

	event Results(uint _yes, uint _no, uint total);

	function createElection(mapping (address => bool) _ableToVote, uint _id) {
		Election memory _election = Election({
			id: _id,
			ableToVote: _ableToVote
		});
		elections[_id] = _elections;
	}

	function Vote(uint _id, bool _vote) {
		Election storage _election = elections[_id];
		require (_election.ableToVote[msg.sender]);
		if (_vote == true) {
			_election.yesVotes++;
		} else {
			_election.noVotes++;
		}
		_election.totalVotes++;
		_election.ableToVote[msg.sender] = false;
	}

	function ElectionResult(uint _id)  {
		Results(elections[_id].yesVotes, elections[_id].noVotes, elections[_id].total);
	}
}
