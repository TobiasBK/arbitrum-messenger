// SPDX-License-Identifier: AGPL-3.0-only
//COPIED FROM: https://github.com/across-protocol/contracts-v1/blob/master/contracts/insured-bridge/interfaces/MessengerInterface.sol
pragma solidity ^0.8.0;

/**
 * @notice Sends cross chain messages to contracts on a specific L2 network. The `relayMessage` implementation will
 * differ for each L2.
 */
interface MessengerInterface {
    function relayMessage(
        address target,
        address userToRefund,
        uint256 l1CallValue,
        uint256 gasLimit,
        uint256 gasPrice,
        uint256 maxSubmissionCost,
        bytes memory message
    ) external payable;
}