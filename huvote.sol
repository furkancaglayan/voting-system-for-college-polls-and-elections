pragma solidity >=0.4.0 <0.6.0;
contract huvote{

    struct Elector{
        bytes32 hashOne;
        bytes32 hashTwo;
        bool hasVoted;
        bool revertedVote;
    }

    struct Proposal
    {
        Moderator mod;
        bool isOfficial;
    }

    struct Moderator{
        address delegate;
        bool isOfficial;
    }

    Moderator moderator;
    Proposal proposal;

    mapping (bytes32 => Elector) public voters;
    mapping (bytes32 => Elector) public revertedVoters;

    modifier NOT_VOTED(bytes32 hashOne)
    {
        require(
            voters[hashOne].hasVoted==false,
            "Sender has voted before."
        );
        _;
    }

    modifier HAS_VOTED(bytes32 hashOne)
    {
        require(
            voters[hashOne].hasVoted==true,
            "Sender has not voted before."
        );
        _;
    }

    modifier OFFICIAL_ELECTION()
    {
        require(
            proposal.isOfficial==true,
            "Election is not official."
        );
        _;
    }
    modifier OFFICIAL_MODERATOR()
    {
        require(
            moderator.isOfficial==true,
            "Moderator is not official."
        );
        _;
    }
    modifier CALL_MODERATOR()
    {
        require(
            msg.sender == moderator.delegate,
            "Sender not authorized."
        );
        _;
    }
    modifier NON_REVERTED_VOTER(bytes32 hashOne)
    {
        require(
            revertedVoters[hashOne].revertedVote == false,
            "Sender not authorized."
        );
        _;
    }

    constructor(bool isVerified) public {
        moderator = Moderator({delegate:msg.sender,isOfficial:isVerified});
        proposal = Proposal({mod:moderator,isOfficial:isVerified});
    }

    function Vote(bytes32 hashOne, bytes32 hashTwo) public payable NOT_VOTED(voteHash) {
            voters[hashOne] = Elector({hashOne:hashOne,hashTwo:hashTwo,hasVoted:true,revertedVote:false});
    } 
    function RevertVote(bytes32 hashOne) public NON_REVERTED_VOTER(hashOne)
    CALL_MODERATOR()
    OFFICIAL_MODERATOR()
    OFFICIAL_ELECTION()
    HAS_VOTED(hashOne)
    {
        voters[hashOne].revertedVote = true;
        voters[hashOne].hasVoted = false;
        
    }

}