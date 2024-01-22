// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
contract Voting {

using Counters for Counters.Counter;
 // Counter for voter and candidate IDsh 
Counters.Counter public _voterId;
Counters.Counter public _candidateId;
 // Address of the voting organizer
address public votingOrganizer;
//CANDIDATES FOR VOTING
struct Candidate {
    uint256 candidateId;
    string age;
    string name;
    string image;
    uint256 voteCount;
    address _address;
    string ipfs;}

event CandidateCreate(
    uint256  indexed candidateId,
    string age,
    string name,
    string image,
    uint256 voteCount,
    address _address,
    string ipfs 
    );
    address[] public candidateAddress;
    mapping (address => Candidate)public candidates;

    // --------- END OF CANDIDATE DATA -----------
    //-------- VOTER DATA ---------
    address[] public votedVoters;
    address[] public votersAddress;
    mapping (address => Voter) public voters;

    struct Voter{
        uint256 voter_voterId;
        string voter_name;
        string voter_image;
        address voter_address;
        uint256 voter_allowed;
        bool voter_voted;
        uint256 voter_vote;
        string voter_ipfs;
    }
    event VoterCreated(
       uint256  indexed voter_voterId,
        string voter_name,
        string voter_image,
        address voter_address,
        uint256 voter_allowed,
        bool voter_voted,
        uint256 voter_vote,
        string voter_ipfs 
    );

    // -------END OF VOTER DATA---------
    
    constructor(){
        votingOrganizer = msg.sender;
    }
     /**
     * @dev Adds a new candidate to the voting system.
     * @param _address Candidate's Ethereum address.
     * @param _age Candidate's age.
     * @param _name Candidate's name.
     * @param _image Candidate's image URI.
     * @param _ipfs IPFS hash for additional candidate data.
     */
    function setCandidate(address _address , string memory _age, string memory _name, string memory _image,
    string memory _ipfs)public {
        require(votingOrganizer== msg.sender,"Only organizer can authorized candidates");
        // Increment candidate ID
        _candidateId.increment();
            uint256 idNumber = _candidateId.current();
        // Create a new candidate
            Candidate storage candidate = candidates[_address];
            candidate.age = _age;
            candidate.name = _name;
            candidate.candidateId = idNumber;
            candidate.image = _image;
            candidate.voteCount = 0;
            candidate._address = _address;
            candidate.ipfs = _ipfs;
            // Add candidate's address to the list

            candidateAddress.push(_address);
            // Emit event to signal the creation of a new candidate
            emit CandidateCreate(
                idNumber,
                _age,
                _name,
                _image,
                candidate.voteCount,
                _address,
                _ipfs
            );

    }
     // GET CANDIDATES ADDRESSES
   function getCandidate()public  view returns (address[] memory) {
    return candidateAddress;
   }
   // GET CANDIDATES LENGTH 
  function getCandidateLength()public  view returns (uint256) {
    return candidateAddress.length;
   } 
   // GET THE DATA OF CANDIDATES
   function getCandidatedata(address _address)public  view returns (string memory,string memory,
   uint256,string memory,uint256,string memory,address) {
    return (
            candidates[_address].age,
            candidates[_address].name,
            candidates[_address].candidateId, 
            candidates[_address].image, 
            candidates[_address].voteCount,
            candidates[_address].ipfs,
            candidates[_address]._address
    );
    }
//--------------VOTER SECTION -------------------------------

 /**
     * @dev Allows the organizer to create a new voter with voting rights.
     * @param _address Voter's Ethereum address.
     * @param _name Voter's name.
     * @param _image Voter's image URI.
     * @param _ipfs IPFS hash for additional voter data.
     */
    function voterRight (address _address , string memory _name,
    string memory _image,string memory _ipfs) public {
        require(votingOrganizer == msg.sender,
        "Only organizer can create voter not you");
         // Increment voter ID
        _voterId.increment();
        uint256 idNumber = _voterId.current();
         // Create a new voter
        Voter storage voter = voters[_address];
        require(voter.voter_allowed == 0);

            voter.voter_allowed = 1;
            voter.voter_name = _name;
            voter.voter_image = _image;
            voter.voter_address = _address;
            voter.voter_voterId = idNumber;
            voter.voter_vote = 1000;
            voter.voter_voted = false;
            voter.voter_ipfs = _ipfs;
        // Add voter's address to the list
            votersAddress.push(_address);
        // Emit event to signal the creation of a new voter
    emit VoterCreated(
        idNumber, 
        _name, 
        _image, 
        _address, 
        voter.voter_allowed,
        voter.voter_voted, 
        voter.voter_vote, 
        _ipfs);
    }

    // WHEN THE ORGANIZER AUTHORIZED A VOTER THEN THE VOTER CAN VOTE
    function vote(address _candidateAddress, uint256 _candidateVoteId) external  {
        Voter storage voter = voters[msg.sender];
            require(!voter.voter_voted,"You have already voted");
            require(voter.voter_allowed != 0,"You have no right to vote");

            voter.voter_voted = true;
            voter.voter_vote = _candidateVoteId;

            votedVoters.push(msg.sender);

            candidates[_candidateAddress].voteCount += voter.voter_allowed;
    }
    // GET LENGTH OF THE VOTERS
    function getVoterLength() public view returns (uint256) {
        return votersAddress.length;
    } 
    // GET THE DATA OF THE VOTERS
    function getVoterdata(address _address)public  view returns (uint256, string memory, string memory,
    address,string memory,uint256,bool) {
        return (
                    voters[_address].voter_voterId,
                    voters[_address].voter_name,
                    voters[_address].voter_image,
                    voters[_address].voter_address,
                    voters[_address].voter_ipfs,
                    voters[_address].voter_allowed,
                    voters[_address].voter_voted
        );
     }
        //Returns an array of Ethereum addresses representing voters who have cast their votes.
     function getVotedVoterList() public view returns (address[] memory) {
        return votedVoters;
     }
        //Returns an array of Ethereum addresses representing all registered voters,
        // regardless of whether they have cast a vote or not.
      function getVoterList() public view returns (address[] memory) {
        return votersAddress;
     }
   }

