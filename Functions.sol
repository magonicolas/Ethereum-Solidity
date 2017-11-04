pragma solidity ^0.4.0;

contract Functions {
    
    string public text = '';
    int numberOfChanges = 0;
    
    function changeToHello() {
        numberOfChanges += 1;
        text = 'Hello World';
    }
    
    function callChangeToHello() {
        changeToHello();
        if(numberOfChanges == 2) {
            changeToBye();
        }
    }
    
    function changeToBye() {
        numberOfChanges += 1;
        text = 'Bye';
    }
}