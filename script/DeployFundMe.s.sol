// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script{
    
    function run() external returns (FundMe) {

        //Antes starbroadcast -> No sera una tx real
        HelperConfig helperConfig = new HelperConfig();
        (address ethUsdPriceFeed) = helperConfig.activeNetworkConfig();
        
        //Despues stopbroadcast -> Se hara una tx real
        vm.startBroadcast();
        FundMe fundme =new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundme;
    }
}