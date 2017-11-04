pragma solidity ^0.4.0;

contract Salary {
    
    uint256 public amountToPay;
    
    address owner;
    
    event Status(string _msg, address user, uint amount);
    
    struct Employee {
        string name;
        uint256 salary;
        bool isActive;
        address account;
    }
    Employee[] public employees;
    
    function Salary() payable {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
		if (msg.sender != owner) {
			revert();
		} else {
			_;
		}
	}
    
    function regiterEmployee(string _name)  {
            employees.push(Employee({
                name: _name,
                salary: 0,
                isActive: false,
                account: msg.sender
            }));
            Status('Registered employee', msg.sender, msg.value);
    }
    
    function setSallary(address employeeAddress, uint256 _salary) onlyOwner {
        for(uint i = 0; i < employees.length; i++) {
            if (employees[i].account == employeeAddress) {
                employees[i].isActive = true;
                employees[i].salary = _salary;
                Status('Salary Set', msg.sender, msg.value);
            }
        }
    }
    
    function quit(address employeeAddress) {
                for(uint i = 0; i < employees.length; i++) {
            if (employees[i].account == employeeAddress) {
                employees[i].isActive = false;
                employees[i].salary = 0;
                Status('Employee has quit', employeeAddress, msg.value);
            }
        }
    }
    
    function fired(address employeeAddress) {
        for(uint i = 0; i < employees.length; i++) {
            if (employees[i].account == employeeAddress) {
                employees[i].isActive = false;
                employees[i].salary = 0;
                Status('Employee Fired', employeeAddress, msg.value);
            }
        }
    }
    
    function updateAmountToPay() {
        amountToPay = 0;
        for(uint i = 0; i < employees.length; i++) {
            if(employees[i].isActive == true) {
                amountToPay += employees[i].salary;
            }
        }
        Status('Amount Updated', msg.sender, msg.value);
    }
    
    function payDay() onlyOwner payable {
        updateAmountToPay();
        if(this.balance >= amountToPay) {
            for(uint j = 0; j < employees.length; j++) {
                if(employees[j].isActive == true) {
                   employees[j].account.transfer(employees[j].salary); 
                }
            }
            Status('Pay Day Executed Succesfully', msg.sender, msg.value);
        } else {
            Status('Pay Day Failed, not enought Balance', msg.sender, msg.value);
            revert();
        }
        
    }
    
    function kill() onlyOwner {
        Status('Contracted Killed, not longer avaikable to use', msg.sender, msg.value);
	    suicide(owner);
	}
    
}