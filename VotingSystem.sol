pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;

contract Voter{
    struct OptionValues{
        uint pos;
        bool exists;
    }

    uint[] public votes;
    string[] public options;
    mapping(address=>bool) hasVoted;
    mapping(string => OptionValues) mapOptions;

    constructor(string[] memory _options) public{
        options = _options;
        votes.length = options.length;
        for(uint i = 0; i<options.length;i++){
            OptionValues memory optionValue = OptionValues(i,true);
            string memory optionName = options[i];
            mapOptions[optionName] = optionValue;
        }
        
    }
    function vote(uint option) public{
        require(0<=option && option < options.length,"Invalid Input");
        require(!hasVoted[msg.sender],"Already Has Voted");
        
        votes[option] = votes[option]+1;
        hasVoted[msg.sender]=true;
    }
    
    function vote(string memory option) public{
        require(!hasVoted[msg.sender],"Already Has Voted");
        
        OptionValues memory optionValue = mapOptions[option];
        require(optionValue.exists,"This option doesnot exist");
        
        votes[optionValue.pos] = votes[optionValue.pos]+1;
        hasVoted[msg.sender]=true;   
    }

    function getOptions() public view returns(string[] memory ){
        return options;
    }

    function getVotes() public view returns (uint[] memory ){
        return votes;
    }

}