pragma solidity ^0.4.0;

contract Alea {
	uint public refferalSentAmount = 0;
	uint public potAmount = 0;
	uint public ticketsSold = 0;

	uint public winnerPercentaje = 80;
	uint public companyPercentaje = 15;
	uint public referralPercentaje = 5;

	address public owner;

	uint256 public cratedTime;

	uint256 public timePerLottery = 80400;


	uint public lastWinnerPotAmount;
	address public lastWinner;

	address[] public participants;

	uint public ticketPrice = 0.01 ether;

	address creator1 = 0x5baa8cf9c87ea0f0c8d1a1d4d4f9d6cfa1eac083; 
	address creator2 = 0x5baa8cf9c87ea0f0c8d1a1d4d4f9d6cfa1eac083;

	event UserStatus(string _msg, address user, uint amount, uint256 time);

	struct Participant {
		address adr;
		uint tickets;
		address referral;
	}

	function Alea() public {
		owner = msg.sender;
		cratedTime = block.timestamp;
		UserStatus('Loterry Created', msg.sender, 0, block.timestamp);
	}

	function buyTicket(uint amount) public payable {
		if(msg.value >= ticketPrice * amount && block.timestamp < (cratedTime + timePerLottery)) {
			bool isParticipant = false;
			ticketsSold += amount;
			participants.push(msg.address);
            UserStatus('Ticket Bought', msg.sender, msg.value, block.timestamp);
			potAmount = this.balance;
		} else {
			revert();
		}
	}

	function buyTicketReferral(address referral, uint amount) public payable {
		if(msg.value >= ticketPrice * amount && block.timestamp < (cratedTime + timePerLottery)) {
			bool isParticipant = false;
			ticketsSold += amount;
			for(uint i = 0; i < participants.length; i++) {
            	if(participants[i].adr == msg.sender) {
                	participants[i].tickets += amount;
                	isParticipant = true;
            	}
       		}
        	if(isParticipant == false) {
            	participants.push(Participant({
                	adr: msg.sender,
               	 tickets: amount,
               	 referral: referral
           	 	}));
            	UserStatus('Ticket Bought', msg.sender, msg.value, block.timestamp);

				potAmount = this.balance;
				referral.transfer(msg.value * referralPercentaje / 100);
				refferalSentAmount = refferalSentAmount + (msg.value * referralPercentaje / 100);
       	 	}
		} else {
			revert();
		}
	}

	function endLottery() public {
		if(block.timestamp > (cratedTime + timePerLottery)) {
			uint random = uint(block.blockhash(block.number-1))%(ticketsSold + 1) + 0;
			for(uint i = 0; i < participants.length; i++) {
				for(uint j = 0; j < participants[i].tickets + 1; j++) {
					UserStatus('Checking', participants[i].adr, random, block.timestamp);
					if(random == 0) {
						lastWinner = participants[i].adr;
						participants[i].adr.transfer(potAmount * winnerPercentaje / 100);
						break;
					}
					random = random - 1;
				}
       		}	
			lastWinnerPotAmount = (potAmount * winnerPercentaje / 100);
			creator1.transfer(this.balance / 2);
			creator2.transfer(this.balance);
        	UserStatus('Loterry Ended, Winner:', lastWinner, lastWinnerPotAmount, block.timestamp);

		} else {
			UserStatus('Loterry NOT Ended:', lastWinner, lastWinnerPotAmount, block.timestamp);
		}
	}
}