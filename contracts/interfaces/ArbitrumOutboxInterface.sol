//SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

//=======OUTBOX INTERFACE=======//

interface ArbitrumOutboxInterface {
    function l2ToL1Sender() external view returns (address);
}
