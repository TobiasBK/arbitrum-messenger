//SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

import "./interfaces/iMessaging.sol";
import "./ArbitrumCrossDomainEnabled.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";

contract ArbitrumMessaging is iMessaging, ArbitrumCrossDomainEnabled {

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
    event RetryableTicketCreated(uint256 id);

    //=======CONSTRUCTOR=======//

    constructor(address _arbitrumInbox) ArbitrumCrossDomainEnabled(_arbitrumInbox) {}

     //=======FUNCTIONS=======//

    //If you know the L2 target address in advance,then don't need to alias an L1 address. So use this function.
     function MessageWithNoAliasing(
        address target,
        address userToRefund,
        uint256 l1CallValue,
        uint256 gasLimit,
        uint256 gasPrice,
        uint256 maxSubmissionCost,
        bytes memory _message
    ) external payable override {

        uint256 seqNumber =
            sendTxToL2NoAliasing(target, userToRefund, l1CallValue, maxSubmissionCost, gasLimit, gasPrice, message);

        emit RetryableTicketCreatedWithNoAliasing(
            msg.sender,
            target,
            seqNumber,
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
        address user,
        uint256 maxSubmissionCost,
        uint256 maxGas,
        uint256 gasPriceBid,
        bytes memory data
        ) external payable returns(uint256) {

        uint256 ticketId = inbox.createRetryableTicket{value: msg.value}(
            l2Target,
            0, // we always assume that l2CallValue = 0???
            maxSubmissionCost,
            msg.sender,
            msg.sender,
            gasLimit,
            gasPrice,
            message
        );

        emit RetryableTicketCreated(user, target, ticketId, data);

        return ticketId;
    }
}
