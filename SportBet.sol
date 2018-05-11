pragma solidity ^0.4.18;

contract SportsBet {

	address judge;

	mapping (uint => Bet) public bets;

	struct Bet {
		uint id;
		string description;
		address user1;
		address user2;
		uint amount;
		bool user1Transfer;
		bool user2Transfer;
		bool canceled;
		bool finished;
		uint betBalance;
	}

	function SportsBet() {
		judge = msg.sender;
	}

	function createBet(uint _id, string _description, address _user2) payable {

		require (msg.value > 0);
		
		Bet memory _bet = Bet({
			id: _id,
			description: _description,
			user1: msg.sender,
			user2: _user2,
			amount: msg.value,
			user1Transfer: true,
			user2Transfer: false,
			canceled: false,
			finished: false,
			betBalance: msg.value
		});
		bets[_id] = _bet;
	}

	function acceptBet(uint _id) payable {
		Bet storage _bet = bets[_id];

		require (_bet.user2 == msg.sender && _bet.finished == false && _bet.user2Transfer == false);

		require (msg.value == _bet.amount && _bet.canceled == false);
		_bet.user2Transfer = true;
		_bet.betBalance = _bet.betBalance + msg.value;
	}

	function cancelBet(uint _id) {
		Bet storage _bet = bets[_id];

		require (_bet.user1 == msg.sender && _bet.finished == false);
		
		require (_bet.user2Transfer == false);
		_bet.canceled = true;
		_bet.user1.transfer(_bet.amount);
	}

	function finishBet(uint _id, address _winner) onlyJudge {
		Bet storage _bet = bets[_id];

		require (_bet.user2Transfer == true && _bet.user1Transfer == true);
		uint amount = _bet.amount * 2;
		_winner.transfer(amount);
		_bet.betBalance = _bet.betBalance - amount;
		_bet.finished = true;
		
	}

	modifier onlyJudge {
		if (msg.sender != judge) {
			revert();
		} else {
			_;
		}
	}
}