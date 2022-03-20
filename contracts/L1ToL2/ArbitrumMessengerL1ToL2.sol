//SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

import "../ArbitrumCrossDomainEnabled.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ArbitrumMessengerL1ToL2 is ArbitrumCrossDomainEnabled, Ownable {

    //=======EVENTS=======//

    event RetryableTicketCreatedWithNoAliasing(
        address indexed from,
        address indexed to,
        uint256 indexed seqNum,
        address userToRefund,
        uint256 l1CallValue,
        uint256 gasLimit,
        uint256 gasPrice,
        uint256 maxSubmissionCost,
        bytes data
    );
    event RetryableTicketCreated(address indexed from, address indexed to, uint256 indexed seqNum, bytes data);
    event EthDeposited(address indexed from, uint256 indexed seqNum, uint256 indexed amount);

    //=======CONSTRUCTOR=======//

    constructor(address _arbitrumInbox) ArbitrumCrossDomainEnabled(_arbitrumInbox) {}

    //=======OWNABLE FUNCTIONS=======//

    //If you know the L2 target address in advance,then don't need to alias an L1 address. So use this function.
     function MessageToL2WithNoAliasing(
        address target,
        address userToRefund,
        uint256 l1CallValue,
        uint256 maxSubmissionCost,
        uint256 gasLimit,
        uint256 gasPrice,
        bytes memory message
    ) external payable onlyOwner returns(uint256) {

        uint256 ticketNum =
            sendTxToL2NoAliasing(target, userToRefund, l1CallValue, maxSubmissionCost, gasLimit, gasPrice, message);

        emit RetryableTicketCreatedWithNoAliasing(
            msg.sender,
            target,
            ticketNum,
            userToRefund,
            l1CallValue,
            gasLimit,
            gasPrice,
            maxSubmissionCost,
            message
        );

        return ticketNum;

    }

    //If you don't know the L2 target address, use this function.
    function MessageToL2WithAliasing(
        address target,
        address userToRefund,
        uint256 maxSubmissionCost,
        uint256 gasLimit,
        uint256 gasPrice,
        bytes memory data
        ) external payable onlyOwner returns(uint256) {

        uint256 ticketNum = sendTxToL2(target, userToRefund, maxSubmissionCost, gasLimit, gasPrice, data);

        emit RetryableTicketCreated(msg.sender, target, ticketNum, data);

        return ticketNum;
    }

    // /// @dev The standard method to send messages from L1 to Arbitrum.
    // function depositEthL1ToL2(uint256 maxSubmissionCost)
    //     external
    //     payable
    //     onlyOwner
    //     returns (uint256)
    // {
    //     uint256 ticketNum = depositEthToL2{value: msg.value}(
    //         maxSubmissionCost
    //     );

    //     emit EthDeposited(msg.sender, ticketNum, msg.value);
    //     return ticketNum;
    // }
}
