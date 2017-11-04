pragma solidity ^0.4.0;

contract SalesContract {
    address public owner;
    uint256 public updatedTime;
    string public salesDescription;
    uint public price;
    bool public onSale = true;

    event UserStatus(string _msg, address user, uint amount, uint256 time);
    
    function SalesContract(string description, uint _price) payable {
        owner = msg.sender;
        salesDescription = description;
        price = _price;
        updatedTime = block.timestamp;
        UserStatus(description, msg.sender, msg.value, block.timestamp);
        UserStatus('Item on Sale:', msg.sender, msg.value, block.timestamp);
    }
    
    function buy() payable {
        if(msg.value >= price && onSale == true) {
            owner.transfer(this.balance);
            owner = msg.sender;
            onSale = false;
            UserStatus('Item Bought', msg.sender, msg.value, block.timestamp);
            UserStatus('Item No Longer on Sale', msg.sender, msg.value, block.timestamp);
        } else {
            revert();
        }
        updatedTime = block.timestamp;
    }

    function updatePrice(uint _price) onlyOwner {
        price = _price;
        UserStatus('Price Updated', msg.sender, price, block.timestamp);
    }

    function modifyDescription(string description) onlyOwner {
        salesDescription = description;
        UserStatus(description, msg.sender, 0, block.timestamp);
        UserStatus('Description Modified', msg.sender, 0, block.timestamp);
    }

    function putOnSale() onlyOwner {
        onSale = true;
        UserStatus('Item Now is On Sale', msg.sender, 0, block.timestamp);
    }

    function removeFromSale() onlyOwner {
        onSale = false;
        UserStatus('Item No Longer on Sale', msg.sender, 0, block.timestamp);
    }

    modifier onlyOwner {
        updatedTime = block.timestamp;
        if (msg.sender != owner) {
            revert();
        } else {
            _;
        }
    }
}