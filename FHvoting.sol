pragma solidity ^0.6;
pragma experimental ABIEncoderV2;
/*
The following notes may be important for understanding the following code:
 - Any unitialized value (even within an unitialized struct) is set to its default zero-value
     - false for bool
     - 0 for any intID
     - ...
 - keccak256() is the most gas-efficient hash-function of Solidity.
*/

//Note that the respective votes are bound to a short, simultanously working as an index for each individual party.
//Short and vote-count are therefor only immutable parts of said party!

contract FHvoting
{
    mapping(address /*_addr*/ => address /*addresses[]*/) addresses;
    address deployer;
    
    struct student
    {
        uint256 extID;
        string intID;
        string name;
        string famname;
        
        uint256 end_of_votetime;
        bool has_voted;
        
        bool initialized;
    }
    mapping(uint256 /*_extID*/ => student) students;
    uint256 s;
    mapping(uint256 /*index*/ => uint256 /*student.extID*/) s_i;
    
    uint256 internal starttime;
    uint256 internal endtime;
    
    struct party
    {
        string short;
        string name;
        
        uint256 vote_count;
        
        bool initialized;
    }
    mapping(string /*_short*/ => party) parties; //making this public would allow you to view the whole party-information by short as well, making that one function redundant (NOT all at once)
    uint256 p;
    mapping(uint256 /*index*/ => string /*party.short*/) p_i;

    constructor() public
    {
        deployer = msg.sender;
        addresses[0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c] = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
        addresses[0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C] = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C;
        addresses[0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB] = 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB;
        addresses[0x583031D1113aD414F02576BD6afaBfb302140225] = 0x583031D1113aD414F02576BD6afaBfb302140225;
        addresses[0xdD870fA1b7C4700F2BD7f44238821C26f7392148] = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;
        //replace ^these^ with the initial node-addresses of your network, when not running on remix
    }
    
    //_____modifiers_____
    
    modifier deployer_only()
    {
        require (msg.sender == deployer, "Only the contract-owner may access this function");
        _;
    }
    
    modifier restricted_access()
    {
        require (msg.sender == addresses[msg.sender], "Only specific addresses may access this function.");
        _;
    }
    
    modifier time_restricted()
    {
        if(endtime != 0)
        {
            require((block.timestamp >= starttime) && (block.timestamp <= endtime), "This function may only be accessed during (a) specific time-frame(s).");
        }
        else
        {
            require(block.timestamp >= starttime);
        }
        _;
    }
    
    //_____functions_____
    
    function give_address_permission(address _addr) public deployer_only
    {
        addresses[_addr] = _addr;
    }
    
    function set_voting_time_intervall(uint256 _starttime, uint256 _endtime) public restricted_access
    {
        if((_endtime > _starttime) && _endtime > block.timestamp)
        {
            starttime = _starttime;
            endtime = _endtime;
        }
    }
    
    function add_or_edit_student(uint256 _extID, string memory _intID, string memory _name, string memory _famname) public restricted_access
    {
        if(!students[_extID].initialized)
            s_i[s++] = _extID;
        students[_extID] = student(_extID, _intID, _name, _famname, students[_extID].end_of_votetime, students[_extID].has_voted, true); //Editing a student does not change their ability to vote.

    }
    
    function give_voting_permission(uint256 _extID, uint8 _minutes) public time_restricted restricted_access
    {
        require(students[_extID].extID == _extID && _extID != 0, "Student does not exist.");
        if(_minutes == 0) { _minutes = 5; } //default is 5 minutes
        students[_extID].end_of_votetime = (block.timestamp + (_minutes * 60 + 60)); //Allows student to vote for x minutes "from now on", with 1 minute of buffer-time added.
    }
    
    function add_or_edit_party(string memory _short, string memory _name) public restricted_access
    {
        if(!parties[_short].initialized)
            p_i[p++] = _short;
        parties[_short] = party(_short, _name, parties[_short].vote_count, true); //Editing a party does not change how many votes they have received so far.
    }
    
    function vote(uint256 _extID, string memory _short) public time_restricted
    {
        require(students[_extID].extID == _extID, "Student does not exist.");
        require(strcomp(parties[_short].short, _short), "Party does not exist.");
        require(students[_extID].has_voted == false, "Student has already voted.");
        require(students[_extID].end_of_votetime >= block.timestamp, "Student is not unlocked for voting.");
        
        parties[_short].vote_count++;
        students[_extID].has_voted = true;
        
        //ISSUE: Everyone can see the input-variables submitted to a function --> voting is immutable but not anonymous //Could manually add pwd, or use AKAP
        //WARNING: Currently anyone can vote for any studentID that is permitted to vote during that time
    }
    
    function count_votes(string memory _short) public view returns (uint256)
    {
        return parties[_short].vote_count;
    }
    function count_votes(uint256 _index) public view returns (uint256)
    {
        return parties[p_i[_index]].vote_count;
    }
    
    function EVALUATE() public view deployer_only returns (string[] memory)
    {
        //We could possibly safe runtime/cost here, by just returning a full array of parties (not just the winners)
        
        uint256 max = 0;
        string[] memory winners = new string[](p);
        uint256 w = 0;

        for(uint256 i = 0; i < p; i++)
        {
            if(max < parties[p_i[i]].vote_count)
            {
                max = parties[p_i[i]].vote_count;
                
                for(; w > 0; w--)
                {
                    winners[w] = "";
                }
                winners[0] = parties[p_i[i]].name;
            }
            else if(max != 0 && max == parties[p_i[i]].vote_count)
            {
                w++;
                winners[w] = parties[p_i[i]].name;
            }
        }
        return winners;
    }
 
    function RESET() public deployer_only
    {
        for(uint256 i = 0; i < s; i++)
        {
            students[s_i[i]].has_voted = false;
        }
        
        for(uint256 i = 0; i < p; i++)
        {
            parties[p_i[i]].vote_count = 0;
        }
    }
    
    //------------------------------------------------------------------------------------------
    
    //_____internal _____functions_____
    function strcomp(string memory _string1, string memory _string2) internal pure returns (bool)
    {
        return (keccak256(abi.encodePacked((_string1))) == keccak256(abi.encodePacked((_string2))) );
        //keccak256 is primarily a hash-function, but can be used for string-comparison and safes some gas in this context
    }
    
    function isempty(string memory _string) internal pure returns (bool)
    {
        return bytes(_string).length == 0;
    }
    
}