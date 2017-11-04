pragma solidity ^0.4.0;

contract LastWill {
    
    address owner;
    
    uint256 public lastTouch;
    
    address[] public childs;
    
    event Status(string _msg, address user, uint256 time);
    
    function LastWill() payable {
        owner = msg.sender;
        lastTouch = block.timestamp;
        Status('Last Will Created', msg.sender, block.timestamp);
    }
    
    function depositFunds() payable {
        Status('Funds Deposited', msg.sender, block.timestamp);
    }
    
    function stillAlive() onlyOwner {
        lastTouch = block.timestamp;
        Status('I Am Still Alive!', msg.sender, block.timestamp);
    }
    
    function isDead() {
        Status('Asking if dead', msg.sender, block.timestamp);
        if(block.timestamp > (lastTouch + 120)) {
            giveMoneyToChilds();
        } else {
            Status('I Am still Alive!', msg.sender, block.timestamp);
        }
    }
    
    function giveMoneyToChilds() {
        Status('I am dead, take my money', msg.sender, block.timestamp);
        uint amountPerChild = this.balance/childs.length;
        for(uint i = 0; i < childs.length; i++) {
            childs[i].transfer(amountPerChild);
        }
    }
    
    function addChild(address _address) onlyOwner {
        Status('Child Added', _address, block.timestamp);
        childs.push(_address);
    }
    
    modifier onlyOwner {
		if (msg.sender != owner) {
			revert();
		} else {
			_;
		}
	}
}