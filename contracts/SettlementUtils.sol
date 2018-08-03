pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";

/// @title A library for calculating and verifying order match details
/// @author Republic Protocol
library SettlementUtils {
    using SafeMath for uint256;
    
    struct OrderDetails {
        bytes details;
        uint64 settlementID;
        uint64 tokens;
        uint256 price;
        uint256 volume;
        uint256 minimumVolume;
    }

    /********** SETTLEMENT FUNCTIONS ******************************************/
    /// @notice Calculates the ID of the order
    /// @param order the order to hash
    function hashOrder(OrderDetails order) internal pure returns (bytes32) {
        return keccak256(
            abi.encodePacked(
                order.details,
                order.settlementID,
                order.tokens,
                order.price,
                order.volume,
                order.minimumVolume
            )
        );
    }

    /// @notice Verifies that two orders match when considering the tokens,
    /// price, volumes / minimum volumes and settlement IDs. verifyMatch is used
    /// my the DarknodeSlasher to verify challenges. Settlement layers may also
    /// use this function.
    /// Note that it doesn't check that the orders belong to distinct traders.
    /// @param _buy The buy order details.
    /// @param _sell The sell order details.
    function verifyMatch(OrderDetails _buy, OrderDetails _sell) internal pure returns (bool) {
        return (verifyTokens(_buy.tokens, _sell.tokens) && // Buy and sell tokens should match
                _buy.price >= _sell.price && // Buy price should be greater than sell price
                _buy.volume >= _sell.minimumVolume &&  // Buy volume should be greater than sell minimum volume
                _sell.volume >= _buy.minimumVolume &&  // Sell volume should be greater than buy minimum volume
                _buy.settlementID == _sell.settlementID  // Require that the orders were submitted to the same settlement layer
            );
    }

    /// @notice Verifies that two token requirements can be matched.
    /// @param _buyTokens The buy token details.
    /// @param _sellToken The sell token details.
    function verifyTokens(uint64 _buyTokens, uint64 _sellToken) internal pure returns (bool) {
        return (uint32(_buyTokens) == uint32(_sellToken >> 32) &&
                uint32(_sellToken) == uint32(_buyTokens >> 32)
        );
    }
}