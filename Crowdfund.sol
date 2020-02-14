pragma solidity ^0.6.0;

contract Crowdfund{

	address payable public recipient;
	uint public balance;
	uint public numDonations;
	mapping(uint => mapping(address => uint)) public donations;

	event Donation(uint _idx, address indexed _donor, uint _amount);
	event Withdraw(uint _amount);
	event Drain(uint _balance);
	event Refund(uint _idx, address indexed _donor, uint _amount);

	modifier onlyRecipient() {
		assert(msg.sender == recipient);
		_;
	}

	constructor(address payable _recipient) public {
		recipient = _recipient;
		balance = 0;
		numDonations = 0;
	}

	function donate() public payable {
		balance += msg.value;
		numDonations++;
		donations[numDonations][msg.sender] = msg.value;
		emit Donation(numDonations, msg.sender, msg.value);
	}

	function withdraw(uint amount) public onlyRecipient {
		assert(amount <= balance);
		balance -= amount;
		emit Withdraw(amount);
		recipient.transfer(amount);
	}

	function drain() public onlyRecipient {
	    uint _balance = balance;
	    balance = 0;
		emit Drain(balance);
		recipient.transfer(_balance);
	}

	function refund(uint idx, address payable donor) public onlyRecipient {
		uint amount = donations[idx][donor];
		assert(amount <= balance);
		balance -= amount;
		emit Refund(idx, donor, amount);
		donor.transfer(amount);
	}
}