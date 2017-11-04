pragma solidity ^0.4.0;

contract Foo {
    
    Calculator calc = new Calculator();
    
    function twoTimesThree() constant returns (int) {
        return calc.multiply(2, 3);
    }
    
    function onePlusSeven() constant returns(int) {
        return calc.add(1, 7);
    }
}

contract Calculator {
    
    function add(int a, int b) returns (int) {
        return a + b;
    }
    
    function multiply(int a, int b) returns (int) {
        return a * b;
    }
}