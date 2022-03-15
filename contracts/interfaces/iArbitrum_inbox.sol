//SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

//INBOX INTERFACE

interface iArbitrum_Inbox {
    // Retryable tickets are the Arbitrum protocol’s canonical method for passing generalized messages from Ethereum to
    // Arbitrum. A retryable ticket is an L2 message encoded and delivered by L1; if gas is provided, it will be executed
    // immediately. If no gas is provided or the execution reverts, it will be placed in the L2 retry buffer,
    // where any user can re-execute for some fixed period (roughly one week).
    // Retryable tickets are created by calling Inbox.createRetryableTicket.
    // More details here: https://developer.offchainlabs.com/docs/l1_l2_messages#ethereum-to-arbitrum-retryable-tickets
    function createRetryableTicketNoRefundAliasRewrite(
        address destAddr,
        uint256 l2CallValue,
        uint256 maxSubmissionCost,
        address excessFeeRefundAddress,
        address callValueRefundAddress,
        uint256 maxGas,
        uint256 gasPriceBid,
        bytes calldata data
    ) external payable returns (uint256);

    // function bridge() external view returns (address);

    //added from: https://github.com/OffchainLabs/arbitrum/blob/master/packages/arb-bridge-eth/contracts/bridge/interfaces/IInbox.sol
    function createRetryableTicket(
        address destAddr,
        uint256 arbTxCallValue,
        uint256 maxSubmissionCost,
        address submissionRefundAddress,
        address valueRefundAddress,
        uint256 maxGas,
        uint256 gasPriceBid,
        bytes calldata data
    ) external payable returns (uint256);

    function depositEth(uint256 maxSubmissionCost) external payable returns (uint256);

    function bridge() external view returns (IBridge);

    function pauseCreateRetryables() external;

    function unpauseCreateRetryables() external;

    function startRewriteAddress() external;

    function stopRewriteAddress() external;
}