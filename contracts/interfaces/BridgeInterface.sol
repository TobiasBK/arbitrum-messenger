//SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.4 <0.9.0;

//COPIED & MODIFIED FROM: https://github.com/makerdao/arbitrum-dai-bridge/blob/34acc39bc6f3a2da0a837ea3c5dbc634ec61c7de/contracts/arbitrum/IBridge.sol

interface BridgeInterface {
  
  event MessageDelivered(
    uint256 indexed messageIndex,
    bytes32 indexed beforeInboxAcc,
    address inbox,
    uint8 kind,
    address sender,
    bytes32 messageDataHash
  );

  event BridgeCallTriggered(
    address indexed outbox,
    address indexed destAddr,
    uint256 amount,
    bytes data
  );

  event InboxToggle(address indexed inbox, bool enabled);

  event OutboxToggle(address indexed outbox, bool enabled);

  function deliverMessageToInbox(
    uint8 kind,
    address sender,
    bytes32 messageDataHash
  ) external payable returns (uint256);

  function executeCall(
    address destAddr,
    uint256 amount,
    bytes calldata data
  ) external returns (bool success, bytes memory returnData);

  // These are only callable by the admin
  function setInbox(address inbox, bool enabled) external;

  function setOutbox(address inbox, bool enabled) external;

  // View functions

  function activeOutbox() external view returns (address);

  function allowedInboxes(address inbox) external view returns (bool);

  function allowedOutboxes(address outbox) external view returns (bool);

  function inboxAccs(uint256 index) external view returns (bytes32);

  function messageCount() external view returns (uint256);
}