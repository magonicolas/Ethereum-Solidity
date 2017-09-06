pragma solidity ^0.4.0;

contract CallerContract {
    CalledContract toBeCalled = CalledContract(0xe3632b9ab0571d2601e804dfddc65eb51ab19310);
    
    function getNumber() constant returns(uint) {
        return toBeCalled.getNumber();
    }
    
}

contract CalledContract {
    uint number = 300;
    
    function getNumber() constant returns(uint) {
        return number;
    }
    
}