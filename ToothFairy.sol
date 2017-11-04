pragma solidity ^0.4.0;

contract ToothFairy {
    
    address child = 0x249A17f2587b9103A3780D67c9B1C6AFcCBe004F; // Replace Child Address Here
    address mother = 0x18D82F0710e4d70ac8d07a7dEC65f005A4a230AC; // Replace Mother Address Here
    address toothFairy;
    
    bool toothPaid = false;
    
    enum ToothState { Mouth, WaitingFallenAproval, Fallen }
    
    ToothState public toothState = ToothState.Mouth;
    
    function ToothFairy() payable {
        toothFairy = msg.sender;
    }
    
    function toothFall() onlyChild {
        if(toothState == ToothState.Mouth) {
            toothState = ToothState.WaitingFallenAproval;
        } else {
            revert();
        }
    }
    
    function motherApproves() onlyMother {
        if(toothState == ToothState.WaitingFallenAproval) {
            toothState = ToothState.Fallen;
            payToChild();
        } else {
            revert();
        }
    }
    
    function payToChild() {
        if(toothState == ToothState.Fallen && toothPaid == false) {
            child.transfer(this.balance);
            toothPaid = true;
        }
    }
    
    modifier onlyChild {
		if (msg.sender != child) {
			revert();
		} else {
			_;
		}
	}
    
    modifier onlyFairy {
		if (msg.sender != toothFairy) {
			revert();
		} else {
			_;
		}
	}
	
	modifier onlyMother {
		if (msg.sender != mother) {
			revert();
		} else {
			_;
		}
	}
    
}