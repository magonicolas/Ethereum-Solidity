pragma solidity ^0.4.0;

contract LastWill {
    
    address owner;
    
    uint256 public lastTouch;
    
    address[] public childs;
    
    address[] public disinherited;
    
    event Status(string _msg, address user, uint amount, uint256 time);
    
    uint heirCount = 0;
    
    function LastWill() payable {
        owner = msg.sender;
        lastTouch = block.timestamp;
        Status('Last Will Created', msg.sender, msg.value, block.timestamp);
    }
    
    function depositFunds() payable {
        Status('Funds Deposited', msg.sender, msg.value, block.timestamp);
    }
    
    function stillAlive() onlyOwner {
        lastTouch = block.timestamp;
        Status('I Am Still Alive!', msg.sender, msg.value, block.timestamp);
    }
    
    function isDead() {
        Status('Asking if dead', msg.sender, msg.value, block.timestamp);
        if(block.timestamp > (lastTouch + 120)) { // 1 Month: 2592000
            giveMoneyToChilds();
        }
    }
    
    function giveMoneyToChilds() {
        Status('I am dead, take my money', msg.sender, msg.value, block.timestamp);
        for(uint i = 0; i < childs.length; i++) {
            bool shouldTransfer = true;
            for(uint j = 0; j < disinherited.length; j++) {
                if(childs[i] == disinherited[j]) {
                    shouldTransfer = false;
                }
            }
            if (shouldTransfer) {
                childs[i].transfer(this.balance/childs.length);
            }
        }
    }
    
    function addChild(address _address) onlyOwner {
        Status('Child Added', _address, msg.value, block.timestamp);
        childs.push(_address);
        heirCount += 1;
    }
    
    function addDesinherited(address _address) onlyOwner {
        disinherited.push(_address);
        heirCount -= 1;
    }

    function remove(uint index)  returns(address[]) {
        if (index >= disinherited.length) return;

        for (uint i = index; i<disinherited.length-1; i++){
            disinherited[i] = disinherited[i+1];
        }
        delete disinherited[disinherited.length-1];
        disinherited.length--;
        heirCount += 1;
        return disinherited;
    }

    
    modifier onlyOwner {
		if (msg.sender != owner) {
			revert();
		} else {
			_;
		}
	}
}