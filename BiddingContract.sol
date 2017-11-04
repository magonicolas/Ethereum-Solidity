pragma solidity ^0.4.0;

contract BiddingContract {

    address public originalOwner;
    address public newOwner;

    uint256 public secondsToEnd;
    uint256 public createdTime;

    string public description;
    uint public basePrice;

    address public highestBidder;
    uint public highestPrice;

    bool public bidDidFinish = false;

    event Status(string _msg, address user, uint256 time);

	
	function BiddingContract(string _description, uint _basePrice, uint256 _secondsToEnd) {
        originalOwner = msg.sender;
        description = _description;
        basePrice = _basePrice;
        secondsToEnd = _secondsToEnd;
        createdTime = block.timestamp;
        Status('Bid Created For Item:', msg.sender, block.timestamp);
        Status(description, msg.sender, block.timestamp);
	}

	function bid() payable {
        if(block.timestamp > (createdTime + secondsToEnd)) {
            checkIfBidEnded();
        } else {
            if(msg.value > highestPrice && msg.value > basePrice && bidDidFinish == false) {
                highestBidder.transfer(highestPrice); 
                highestBidder = msg.sender;
                highestPrice = msg.value;
                Status('New Highest Bidder, Old Bidder had his money back', msg.sender, block.timestamp);
             } else {
                Status('This Bid is not possible. Out of Time or Price not High Enought', msg.sender, block.timestamp);
                revert();
            }
        }

	}

	function checkIfBidEnded() {
		
		if(block.timestamp > (createdTime + secondsToEnd)) {
            originalOwner.transfer(this.balance);
            newOwner = highestBidder;
            bidDidFinish = true;
            Status('Item new Owner:', newOwner, block.timestamp);
            Status('Bid Did End!', msg.sender, block.timestamp);
            Status('Checking if bid Ended..', msg.sender, block.timestamp);
        } else {
        	revert();
        }
	}
}
