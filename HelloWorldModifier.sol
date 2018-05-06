// Version
pragma solidity ^0.4.0;

// Contrato
contract HelloWorldContract {
    // Variables
    string word = 'Hello World';
    address owner;
    
    // Inicializador
    function HelloWorldContract() {
        owner = msg.sender;
    }
    
    // Funciones
    function getWord() constant returns(string) {
        return word;
    }
    
    function setWord(string newWord) onlyOwner returns(string) {
        word = newWord;
        return 'You sucessfully changed the variable word';
    }

    //Funcion Especial
    modifier onlyOwner {
        if(owner != msg.sender) {
            throw;
        } else {
            _;
        }
    }
}