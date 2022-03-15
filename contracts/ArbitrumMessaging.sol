//SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

import "./interfaces/MessengerInterface.sol";
import "./ArbitrumCrossDomainEnabled.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract ArbitrumMessaging is MessengerInterface, ArbitrumCrossDomainEnabled {

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

    //=======CONSTRUCTOR=======//

    constructor(address _arbitrumInbox) ArbitrumCrossDomainEnabled(_arbitrumInbox) {}

     //=======FUNCTIONS=======//

    //If you know the L2 target address in advance,then don't need to alias an L1 address. So use this function.
     function MessageWithNoAliasing(
        address target,
        address userToRefund,
        uint256 l1CallValue,
        uint256 maxSubmissionCost,
        uint256 gasLimit,
        uint256 gasPrice,
        bytes memory message
    ) external payable {

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

    }

    //If you don't know the L2 target address, use this function.
    function MessageWithAliasing(
        address target,
        address userToRefund,
        uint256 maxSubmissionCost,
        uint256 gasLimit,
        uint256 gasPrice,
        bytes memory data
        ) external payable returns(uint256) {

        uint256 ticketNum = sendTxToL2(target, userToRefund, maxSubmissionCost, gasLimit, gasPrice, data);

        emit RetryableTicketCreated(msg.sender, target, ticketNum, data);

        return ticketNum;
    }
}
