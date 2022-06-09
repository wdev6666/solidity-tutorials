// SPDX-License-Identifier: MIT

pragma solidity  ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IFakeNFTMarketplace {
    function getPrice() external view returns(uint256);
    function available(uint256 _tokenId) external view returns(bool);
    function purchase(uint256 _tokenId) external payable;
}

interface INFTToken {
    function balanceOf(address owner) external view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns(uint256);
}

contract DAO is Ownable{
    struct Proposal{
        uint256 nftTokenId;
        uint256 deadline;
        uint256 yayVotes;
        uint256 nayVotes;
        bool executed;
        mapping(uint256 => bool) voters;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public numProposals;

    IFakeNFTMarketplace nftMarketplace;
    INFTToken nftToken;

    constructor(address _nftMarketplace, address _nftToken) payable{
        nftMarketplace = IFakeNFTMarketplace(_nftMarketplace);
        nftToken = INFTToken(_nftToken);
    }

    modifier nftHolderOnly(){
        require(nftToken.balanceOf(msg.sender) > 0, "Not a DAO Member!");
        _;
    }

    modifier activeProposalOnly(uint256 proposalIndex){
        require(proposals[proposalIndex].deadline > block.timestamp, "Deadline Exceeded!");
        _;
    }

    modifier inactiveProposalOnly(uint256 proposalIndex){
        require(proposals[proposalIndex].deadline <= block.timestamp, "Deadline not Exceeded!");
        require(proposals[proposalIndex].executed == false, "Proposal Already Executed.");
        _;
    }

    enum Vote{
        YAY,
        NAY
    }

    function createProposal(uint256 _nftTokenId) external nftHolderOnly returns(uint256) {
        require(nftMarketplace.available(_nftTokenId), "NFT Not for sale!");
        Proposal storage proposal = proposals[numProposals];
        proposal.nftTokenId = _nftTokenId;
        proposal.deadline = block.timestamp + 5 minutes;
        numProposals++;
        return numProposals - 1;
    }

    function voteOnProposal(uint256 proposalIndex, Vote vote) external nftHolderOnly activeProposalOnly(proposalIndex){
        Proposal storage proposal = proposals[proposalIndex];
        uint256 voterNFTBalance = nftToken.balanceOf(msg.sender);
        uint256 numVotes = 0;

        for(uint256 i = 0; i < voterNFTBalance; i++){
            uint256 tokenId = nftToken.tokenOfOwnerByIndex(msg.sender, i);
            if(proposal.voters[tokenId] == false){
                numVotes++;
                proposal.voters[tokenId] = true;
            }
        }
        require(numVotes > 0, "Already voted!");
        if(vote == Vote.YAY){
            proposal.yayVotes += numVotes;
        }else{
            proposal.nayVotes += numVotes;
        }
    }

    function executeProposal(uint256 proposalIndex) external nftHolderOnly inactiveProposalOnly(proposalIndex){
        Proposal storage proposal = proposals[proposalIndex];
        if(proposal.yayVotes > proposal.nayVotes){
            uint256 nftPrice = nftMarketplace.getPrice();
            require(address(this).balance >= nftPrice, "Not enough fund!");
            nftMarketplace.purchase{value: nftPrice}(proposal.nftTokenId);
        }
        proposal.executed = true;
    }

    function withdrawEther() external onlyOwner{
        payable(owner()).transfer(address(this).balance);
    }

    receive() external payable{}

    fallback() external payable{}
}

