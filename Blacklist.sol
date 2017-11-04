pragma solidity ^0.4.0;

contract BlackList {

	struct Person {
		address adr;
		int count;
	}

	mapping(address => Person) public blackList;
	

	function BlackList() {
		
	}	

	function addToBlackList(address _address) {
		blackList[_address].adr = _address;
		blackList[_address].count += 1;
	}
}
