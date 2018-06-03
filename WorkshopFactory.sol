pragma solidity ^0.4.18;


contract WorkshopFactory {
        
    // @dev Sanity check that allows us to ensure that we are pointing to the
    //  right auction in our setEggFactoryAddress() call.
    bool public isEggFactory = true;

    address public vaultAddress;

    // @dev Scheme of egg
    struct Workshop{
        uint256 id;
        address owner; // Owner of the workshop
        address vault; // Vault to send all recollected money, they can use split payment and have their vault for multiple owners.
        uint256 maxTickets; // max available eggs. zero for unlimited
        uint256 ticketsSold; // tickets sold on current Workshop
        
        uint256 increase; // price increase. zero for no increase
        uint256 price; // base price of the workshop
        
        bool active; // is the workshop active to be bought
        bool isWorkshop;
    }

    // Mapping of existing workshops 
    // @dev: uint256 is the ID of the egg scheme
    mapping (uint256 => Workshop) public workshops;
    uint256[] public workshopsIndexes;
    
    uint256[] public activeWorkshops;
    mapping (uint256 => uint256) indexesActiveWorkshops;

    // Mapping of eggs owned by an address
    // @dev: owner => ( workshopId => workshopsAmount )
    mapping ( address => mapping ( uint256 => bool ) ) public workshopsPurchased;

    mapping ( address => mapping ( uint256 => string ) ) workshopsCompletionPasswords;
    

    // Extend constructor
    function EggFactory(address _vaultAddress) public {
        vaultAddress = _vaultAddress;
        ceoAddress = msg.sender;
    }

    // Verify existence of id to avoid collision
    function eggExists( uint _workshopId) internal view returns(bool) {
        return workshops[_workshopId].isWorkshop;
    }

    // Set a new address for vault contract
    function setVaultAddress(address _vaultAddress) public onlyCEO returns (bool) {
        require( _vaultAddress != address(0x0) );
        vaultAddress = _vaultAddress;
    }
    
    function setActiveStatusEgg( uint256 _workshopId, bool state ) public onlyCEO returns (bool){
        require(eggExists(_workshopId));
        eggs[_workshopId].active = state;

        if(state) {
            uint newIndex = activeWorkshops.push(_workshopId);
            indexesActiveWorkshops[_workshopId] = uint256(newIndex-1);
        }
        else {
            indexesActiveWorkshops[activeWorkshops[activeWorkshops.length-1]] = indexesActiveWorkshops[_workshopId];
            activeWorkshops[indexesActiveWorkshops[_workshopId]] = activeWorkshops[activeWorkshops.length-1]; 
            delete activeWorkshops[activeWorkshops.length-1];
            activeWorkshops.length--;
        }
        
        return true;
    }
    
    function listEggsIds() external view returns(uint256[]){
        return workshopsIndexes;
    }
    
    function listActiveWorkshops() external view returns(uint256[]){
        return activeWorkshops;
    }

    // Add modifier of onlyCOO
    function createEggScheme( uint256 _workshopId, uint256 _maxTickets, uint256 _price, uint256 _increase, bool _active) public onlyCEO returns (bool){
        require(!eggExists(_workshopId));
        
        workshops[_workshopId].isWorkshop = true;
        
        workshops[_workshopId].id = _workshopId;
        workshops[_workshopId].maxTickets = _maxTickets;
        workshops[_workshopId].ticketsSold = 0;
        workshops[_workshopId].price = _price;
        workshops[_workshopId].increase = _increase;
        
        workshops[_workshopId].active = _active;
        
        workshopsIndexes.push(_workshopId);
        return true;
    }

    function buyWorkshop(uint256 _workshopId) public payable returns(bool){
        require(workshops[_workshopId].active == true);
        require(currentEggPrice(_workshopId) == msg.value);
        require(workshops[_workshopId].maxTickets == 0 || workshops[_workshopId].ticketsSold+1<=workshops[_workshopId].maxTickets); // until max
        
        vaultAddress.transfer(msg.value); // transfer the amount to vault
        
        workshops[_workshopId].ticketsSold++;
        workshopsPurchased[msg.sender][_workshopId] = true;

        return true;
    } 
    
    function currentEggPrice( uint256 _workshopId ) public view returns (uint256) {
        return workshops[_workshopId].price + (workshops[_workshopId].ticketsSold * workshops[_workshopId].increase);
    _workshopId}