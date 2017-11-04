pragma solidity ^0.4.0;

contract CryptoTicket {
	uint public winnerPercentaje = 60;
	uint public companyPercentaje = 15;
	uint public donationsPercentaje = 25;

	address public donationsAddress = 0x0515fA3898931553c36FaCaFc412ac1DA55aC008;

	address public owner;

	uint256 public lastLotteryTime;

	uint256 public timePerLottery = 120;

	uint public potAmount = 0;
	uint public lastWinnerPotAmount;
	address public lastWinner;

	Participant[] public participants;

	uint public ticketPrice = 1 ether;

	event UserStatus(string _msg, address user, uint amount, uint256 time);

	struct Participant {
		address adr;
		uint tickets;
	}

	function CryptoTicket() {
		owner = msg.sender;
		lastLotteryTime = block.timestamp;
		UserStatus('Loterry Created', msg.sender, 0, block.timestamp);
	}

	function buyTicket() payable {
		bool isParticipant = false;
		if(msg.value >= ticketPrice) {
			UserStatus('Ticket Bought', msg.sender, msg.value, block.timestamp);
			for(uint i = 0; i < participants.length; i++) {
            	if(participants[i].adr == msg.sender) {
                	participants[i].tickets += 1;
                	isParticipant = true;
            	}
       		}
        	if(isParticipant == false) {
            	participants.push(Participant({
                	adr: msg.sender,
               	 tickets: 1
           	 }));
			potAmount = this.balance;
       	 }
		} else {
			revert();
		}
	}

	function endLottery() {
		if(block.timestamp > (lastLotteryTime + timePerLottery)) {
			uint random = uint(block.blockhash(block.number-1))%(participants.length + 1) + 0;
			potAmount = this.balance;
			lastWinnerPotAmount = (potAmount * winnerPercentaje / 100);
			participants[random].adr.transfer(potAmount * winnerPercentaje / 100);
			owner.transfer(potAmount * companyPercentaje / 100);
			donationsAddress.transfer(potAmount * donationsPercentaje / 100);
			lastLotteryTime = block.timestamp;
			potAmount = 0;
			lastWinner = participants[random].adr;
			for (uint i = 0; i<participants.length; i++){
            	delete participants[i];
        	}
        	UserStatus('Loterry Ended, Winner:', lastWinner, lastWinnerPotAmount, block.timestamp);

		}
	}
}