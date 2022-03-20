//SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

import "../libraries/AddressAliasHelper.sol";
import "../interfaces/IArbSys.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ArbitrumMessengerL1ToL2 is Ownable {
    address public l1Target;

    //=======EVENTS=======//

    event MessageToL1Created(
        address indexed _sender,
        address indexed _to,
        uint256 indexed _id,
        bytes _data
    );

    //=======CONSTRUCTOR=======//

    constructor(address _l1Target) {
        l1Target = _l1Target;
    }

    modifier onlyL1Counterpart(address l1Counterpart) {
        require(
            msg.sender == AddressAliasHelper.applyL1ToL2Alias(l1Counterpart),
            "ONLY_COUNTERPART_GATEWAY"
        );
        _;
    }

     //=======OWNABLE FUNCTIONS=======//
     
    function updateL1Target(address _l1Target) public onlyOwner {
        l1Target = _l1Target;
    }

    function sendMessageToL1(
        address _user,
        address _l1Target,
        bytes memory _data
    ) public onlyOwner returns (uint256) {
        // note: this method doesn't support sending ether to L1 together with a call
        uint256 id = IArbSys(address(100)).sendTxToL1(_l1Target, _data);
        emit MessageToL1Created(_user, _l1Target, id, _data);
        return id;
    }

   
}