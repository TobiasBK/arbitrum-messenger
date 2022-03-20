//COPIED & MODIFIED FROM: https://github.com/makerdao/arbitrum-dai-bridge/blob/34acc39bc6f3a2da0a837ea3c5dbc634ec61c7de/contracts/l1/L1CrossDomainEnabled.sol

//SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.4 <0.9.0;

import "./interfaces/IInbox.sol";
import "./interfaces/IOutbox.sol";
import "./interfaces/IBridge.sol";

abstract contract ArbitrumCrossDomainEnabled {
  IInbox public immutable arbitrumInbox;

  event TxToL2(address indexed from, address indexed to, uint256 indexed id, bytes data);
  event EthDepositedToL2(address indexed from, uint256 indexed id);

  constructor(address _arbitrumInbox) {
    arbitrumInbox =  IInbox(_arbitrumInbox);
  }

  modifier onlyL2Counterpart(address l2Counterpart) {
    // a message coming from the counterpart gateway was executed by the bridge
    IBridge bridge = IBridge(arbitrumInbox.bridge());
    require(msg.sender == address(bridge), "NOT_FROM_BRIDGE");
    // and the outbox reports that the L2 address of the sender is the counterpart gateway
    address l2ToL1Sender = IOutbox(bridge.activeOutbox()).l2ToL1Sender();
    require(l2ToL1Sender == l2Counterpart, "ONLY_COUNTERPART_GATEWAY");
    _;
  }

  function sendTxToL2(
    address target,
    address user,
    uint256 maxSubmissionCost,
    uint256 maxGas,
    uint256 gasPriceBid,
    bytes memory data
  ) internal returns (uint256) {
    uint256 seqNum = arbitrumInbox.createRetryableTicket{value: msg.value}(
      target,
      0, // we always assume that l2CallValue = 0
      maxSubmissionCost,
      user,
      user,
      maxGas,
      gasPriceBid,
      data
    );
    emit TxToL2(user, target, seqNum, data);
    return seqNum;
  }

  function sendTxToL2NoAliasing(
    address target,
    address user,
    uint256 l1CallValue,
    uint256 maxSubmissionCost,
    uint256 maxGas,
    uint256 gasPriceBid,
    bytes memory data
  ) internal returns (uint256) {
    uint256 seqNum = arbitrumInbox.createRetryableTicketNoRefundAliasRewrite{value: l1CallValue}(
      target,
      0, // we always assume that l2CallValue = 0
      maxSubmissionCost,
      user,
      user,
      maxGas,
      gasPriceBid,
      data
    );
    emit TxToL2(user, target, seqNum, data);
    return seqNum;
  }

  function depositEthToL2(uint256 maxSubmissionCost) internal returns(uint256) {
    uint256 seqNum = arbitrumInbox.depositEth(maxSubmissionCost);
    emit EthDepositedToL2(msg.sender, seqNum);
    return seqNum;
  }
}
