//SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

//https://developer.offchainlabs.com/docs/l1_l2_messages
//use retryable tickets to pass messages from L1 -> L2
//A retryable ticket is an L2 message encoded and delivered by L1
//Retryable tickets handle potential problesm (such as gas differences, and automaticity of tx)
//There are a total of 10 parameters that the L1 must pass to the L2 when creating a retryable ticket.
//

//need OZ for ownable

contract ArbitrumMessanger {

    constructor(address _l2Destination) {}

    function createRetryableTicket(
        address destAddr, 
        uint256 l2CallValue, 
        uint256 maxSubmissionCost, 
        address excessFeeRefundAddress, 
        address callValueRefundAddress, 
        uint256 maxGas, 
        uint256 gasPriceBid, 
        bytes memory data) 
        external returns(uint256) {

            uint256 uniqueTxId = (keccak256(requestID, uint(0) )

            //emit event
    }

    function toDepositEth(uint256 maxSubmissionCost) external returns(uint256){

    }
}