// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
address public organizer;
string public projectTitle;
uint public fundingGoal;
uint public totalFundsRaised;
uint public deadline;
mapping(address => uint) public contributionsBy;

modifier onlyOrganizer() {
    require(msg.sender == organizer, "Only the organizer can call this function");
    _;
}

constructor(string memory _projectTitle, uint _fundingGoal, uint _durationInDays) {
    organizer = msg.sender;
    projectTitle = _projectTitle;
    fundingGoal = _fundingGoal;
    deadline = block.timestamp + (_durationInDays * 1 days);
}

function contribute() public payable {
    require(msg.value > 0, "Contribution must be greater than zero");
    
    if (block.timestamp > deadline) {
        revert("The crowdfunding campaign has ended");
    }

    totalFundsRaised += msg.value;
    contributionsBy[msg.sender] += msg.value;
}

function cancelProject() public onlyOrganizer {
    require(block.timestamp <= deadline, "The campaign has already ended");
    require(totalFundsRaised == 0, "Cannot cancel project with funds raised");

    projectTitle = "";
    fundingGoal = 0;
    deadline = block.timestamp;
}

function withdrawFunds() public onlyOrganizer {
    require(block.timestamp > deadline, "Cannot withdraw funds before the deadline");
    require(totalFundsRaised >= fundingGoal, "Funding goal not met");

    uint amount = totalFundsRaised;
    totalFundsRaised = 0;
    assert(amount > 0);  // Ensures that there are funds to withdraw

    payable(organizer).transfer(amount);
}}