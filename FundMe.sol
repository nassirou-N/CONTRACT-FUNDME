// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5 * 1e18;

    address[] public funders;
    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;
    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable {
        //Allow users to send $
        //Have a mimimum $ sent
        //1. how do we send ETH to this contract?
      
        //require(getConversionRate(msg.value) >= minimumUsd,"didn't send enough ETH");//1e18 = 1 ETH = 1000000000000000000
       // msg.value.getConversionRate();
        require(msg.value.getConversionRate() >= MINIMUM_USD,"didn't send enough ETH");//1e18 = 1 ETH = 1000000000000000000
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;

    }

    modifier onlyOwner(){
        require(msg.sender == i_owner, "Not the owner");
        _;
    }

    function withdraw() public onlyOwner{
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);
        //actually withdraw the funds

        //transfer  //2300 gas 
        //payable(msg.sender).transfer(address(this).balance);

        //send 2300 gas return bool
       // bool sendSuccess = payable(msg.sender).send(address(this).balance);
       // require(sendSuccess, "Send failed");

        //call forward all gas or set gas return bool
       ( bool callSucess, )= payable(msg.sender).call{value: address(this).balance}("");
       require(callSucess,"Call failed");
    }

    receive() external payable {
        fund();
     }

    fallback() external payable {
        fund();
     }

   
    
}
