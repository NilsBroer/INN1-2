pragma solidity ^0.6;

contract FHVoting
{
    ///Structs
    struct Student
    {
        address id;
        bool voted;
        bool active;
    }

    struct Party
    {
        string id;
        string name;
        uint256 votes;
        bool active;
    }
    
    //Mappings
    address public administrator;
    mapping(address => address) public moderators;
    mapping(address => Student) students;
    mapping(string => Party) public parties;
    
    //Iterators
    mapping(uint256 => address) m_i;
    uint256 m = 1;
    mapping(uint256 => address) s_i;
    uint256 s = 0;
    mapping(uint256 => string) public p_i;
    uint256 p = 0;

    //Constructor
    constructor() public
    {
        administrator = msg.sender;
        moderators[administrator] = administrator;
        m_i[0] = administrator;
        //Already known wallet-addresses can be added like this:
        //moderators[full-address] = full-address;
    }
    
    //Modifiers
    modifier administrator_only()
    {
        require(msg.sender == administrator, "Only the administrator (contract-owner) may access this function.");
        _;
    }
    
    modifier moderator_only()
    {
        require(msg.sender == moderators[msg.sender], "Only a moderator (see mapping) may access this function.");
        _;
    }
    
    modifier student_only()
    {
        require(students[msg.sender].active, "Only a student (see mapping) may access this function.");
        _;
    }
    
    //Public functions
    function addModerator(address moderator) public administrator_only
    {
        moderators[moderator] = moderator;
        m_i[m] = moderator;
        m++;
    }
    
    function activateStudent(address adr) public moderator_only
    {
        require(!students[adr].active,"Student with given address already active.");
        bool studentIsNew = !(students[adr].id == adr);
        
        students[adr] = Student(adr,false,true);
        
        if(studentIsNew)
        {
            s_i[s++] = adr;
        }
        
    }
    
    function deactivateStudent(address adr) public moderator_only
    {
        require(students[adr].active,"Student with given address is not active.");
        
        students[adr].active = false;
    }
    
    function activateParty(string memory id, string memory name) public moderator_only
    {
        require(!parties[id].active,"Party with given ID already active.");
        bool partyIsNew = !strcomp(parties[id].id,id);
        
        parties[id] = Party(id,name,0,true);
        
        if(partyIsNew)
        {
            p_i[p++] = id;
        }
    }
    
    function editPartyName(string memory id, string memory name) public moderator_only
    {
        require(parties[id].active,"Party with given ID is not active.");
        
        parties[id].name = name;
    }
    
    function deactivateParty(string memory id) public moderator_only
    {
        require(parties[id].active,"Party with given ID is not active.");
        
        parties[id].active = false;
    }
    
    function vote(string memory partyId) public student_only
    {
        require(parties[partyId].active,"Party with given ID is not active.");
        require(!students[msg.sender].voted,"Student (you) already voted.");
        
        parties[partyId].votes++;
        students[msg.sender].voted = true;
    }
    
    function evaluate() public view moderator_only returns (string memory)
    {
        uint256 max = 0;
        string memory winners = "";
        
        for(uint256 i = 0; i < p; i++)
        {
            if(max < parties[p_i[i]].votes)
            {
                max = parties[p_i[i]].votes;
                winners = parties[p_i[i]].name;
            }
            else if(max == parties[p_i[i]].votes && max != 0)
            {
                winners = addWinner(winners,parties[p_i[i]].name);
            }
        }
        
        return winners;
    }
    
    function reset() public administrator_only
    {
        for(uint256 i = 0; i < s; i++)
        {
            students[s_i[i]].voted = false;
        }
        
        for(uint256 i = 0; i< p; i++)
        {
            parties[p_i[i]].votes = 0;
        }
    }
    
    //Internal functions
    function addWinner(string memory _base, string memory _value) pure internal returns (string memory)
    {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        string memory _tmpValue = new string(_baseBytes.length + 1 + _valueBytes.length);
        bytes memory _newValue = bytes(_tmpValue);

        uint i;
        uint j;

        for(i=0; i<_baseBytes.length; i++)
        {
            _newValue[j++] = _baseBytes[i];
        }
        
        _newValue[j++] = ',';

        for(i=0; i<_valueBytes.length; i++)
        {
            _newValue[j++] = _valueBytes[i];
        }

        return string(_newValue);
    }
    
    function strcomp(string memory _string1, string memory _string2) internal pure returns (bool)
    {
        return (keccak256(abi.encodePacked((_string1))) == keccak256(abi.encodePacked((_string2))) );
        //keccak256 is primarily a hash-function, but can be used for string-comparison and safes some gas in this context
    }
    
    function strempty(string memory _string) internal pure returns (bool)
    {
        return bytes(_string).length == 0;
    }
    
}
