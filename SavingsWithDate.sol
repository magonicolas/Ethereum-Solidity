pragma solidity ^0.4.19;

contract Savings {
    address owner;
    uint256 deadline;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function deposit() public payable {
    }

    function Savings(uint256 numberOfDays) public payable {
        owner = msg.sender;
        deadline = now + (numberOfDays * 1 days);
    }

    function withdraw() public onlyOwner {
        require(now >= deadline);

        msg.sender.transfer(address(this).balance);
    }
}