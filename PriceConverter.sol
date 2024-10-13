// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;


import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


library PriceConverter {
     function GetPrice() internal view returns(uint256) {
        // the address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI 
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = priceFeed.latestRoundData();
        //prcie of ETH in terms of USD
        //2000.00000000
        return uint256(price * 1e10);
       
    }
    function getConversionRate(uint256 ethAmount) internal view returns(uint256){
        // 1ETH ?
        //(2000_000000000000000000 * 1_000000000000000000) / 1e18 =2000
        //$2000 = 1ETH
        uint256 ethPrice =GetPrice();
        uint256 ethAmountInUsd = (ethAmount * ethPrice) / 1e18;

        return ethAmountInUsd;

    }

    function getVersion() internal view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }
}