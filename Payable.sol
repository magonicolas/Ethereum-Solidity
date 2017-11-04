pragma solidity ^0.4.0;

contract CallerContract {
	CalledContract toBeCalled = new CalledContract();

	function getNumber() constant returns(uint) {
		return toBeCalled.getNumber();
	}

	function getWords() constant returns(bytes32) {
		return toBeCalled.getWords();
	}
}

contract CalledContract {
	uint number = 42;
	bytes32 words = 'Hello World';

	function getNumber() constant returns(uint) {
		return number;
	}
	function getWords() constant returns(bytes32) {
		return words;
	}
}