pragma solidity ^0.4.16;

contract Notary {

	struct Document {
		string documentToSign;
		address[] signatures;

	}

	address public owner;
	Document[] public documents;
	int public lastId = -1;
	uint256 documentCreationPrice = 0.001 ether;
	uint256 signaturePrice = 0.0001 ether;

	address[] temp;

	event DocumentCreated(string _description, int _id, address _user, uint256 _time);
	event DocumentSigned(int _id, address _user, uint256 _time);

	function Notary() {
		owner = msg.sender;
	}

	function createDocument(string _document) payable {
		lastId += 1;
		if(msg.value != documentCreationPrice) {
			revert();
		}
		temp.push(msg.sender);
		documents.push(Document({
				documentToSign: _document,
				signatures: temp
			}));
		delete temp[0];
		DocumentSigned(lastId, msg.sender, block.timestamp);
		DocumentCreated(_document, lastId,msg.sender, block.timestamp);
		owner.transfer(this.balance);
	}

	function signDocument(int id) payable {
		if(msg.value != signaturePrice) {
			revert();
		}
		if(id <= lastId) {
			documents[uint256(id)].signatures.push(msg.sender);
		} else {
			revert();
		}
		DocumentSigned(id, msg.sender, block.timestamp);
		owner.transfer(this.balance);
	}
}


pragma solidity ^0.4.16;

contract Notary2 {

	struct Document {
		address[] signatures;
		string documentToSign;	
		string signaturesSring;
	}

	address public owner;
	Document[] public documents;
	int public lastId = -1;
	uint256 documentCreationPrice = 0.001 ether;
	uint256 signaturePrice = 0.0001 ether;
	address[] temp;

	event Status(string _msg, address user, uint256 time);

	function Notary2() {
		owner = msg.sender;
		Status('Notary Created', msg.sender, block.timestamp);
	}

	function createDocument(string _document) payable {
		if(msg.value != documentCreationPrice) {
			revert();
		}
		//address[] signature;
		temp.push(msg.sender);
		documents.push(Document({
				documentToSign: _document,
				signatures: temp,
				signaturesSring: addresstoString(msg.sender)
			}));
	    delete temp[0];
		Status('New Document Created', msg.sender, block.timestamp);
		Status('New Document ID at Last row:', msg.sender, uint256(lastId));
		lastId += 1;
		owner.transfer(this.balance);
	}

	function signDocument(int id) payable {
		if(msg.value != signaturePrice) {
			revert();
		}
		if(id <= lastId) {
			documents[uint256(id)].signatures.push(msg.sender);
			documents[uint256(id)].signaturesSring += bytes32ToString(msg.value);
		}
		Status('Signed Document ID at Last row:', msg.sender, uint256(id));
		Status('New Signature On Document', msg.sender, block.timestamp);
		owner.transfer(this.balance);
	}

	function bytes32ToString (bytes32 data) returns (string) {
    	bytes memory bytesString = new bytes(32);
    	for (uint j=0; j<32; j++) {
       	 	byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
       	 	if (char != 0) {
            	bytesString[j] = char;
        	}
    	}
    	return string(bytesString);
	}
	function addresstoString(address x) returns (string) {
    	bytes memory b = new bytes(20);
    	for (uint i = 0; i < 20; i++)
        	b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
    	return string(b);
	}

}
