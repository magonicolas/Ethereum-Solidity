pragma solidity ^0.4.16;

contract Health {

	struct Person {
		address adr;
		string name;
		uint weight;
		string diseases;
		string medication;
	}

	mapping(uint => Person) public peopleData;

	function Health() {
		
	}

    function addPeople(string _name, uint _weight, uint _publicPass)  {
		peopleData[_publicPass] = Person({
			 			adr: msg.sender,
			 			name: _name,
			 			weight: _weight,
			 			diseases: "none",
			 			medication: ""
			 		});
    }

    function changeWeight(uint _publicPass, uint _weight) {
    	peopleData[_publicPass].weight = _weight;
    }

    function addDisease(uint _publicPass, string _diseases) {
		peopleData[_publicPass].diseases = _diseases;
    }

    function addMedication(uint _publicPass, string _medication) {
		peopleData[_publicPass].medication = _medication;
    }

    function changePublicPass(uint _newPublicPass, uint _oldPublicPass) {
    	if(msg.sender != peopleData[_oldPublicPass].adr) {
    		revert();
    	}
    	peopleData[_newPublicPass] = peopleData[_oldPublicPass];
    	delete peopleData[_oldPublicPass];
    }

    function purchasedMedication(uint _publicPass) {
    	peopleData[_publicPass].medication = "";
    }
	
}