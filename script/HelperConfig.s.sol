// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

//1. Desplegar mocks cuando estemos en una cadena de bloques local como anvil
//2. Mantener trackeados nuestros la direccion contratos a traves de diferentes cadenas como:
//3. Sepolia ETH/USD   && Mainnet ETH/USD

contract HelperConfig is Script{

    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    //Si estamos en una cadena local como anvil, desplegaremos mocks
    // De otra forma, tomamos la direccion existente desde la live network (Sepolia)

    //Creamos una estructura con los parametros como gas, etc
    struct NetworkConfig {
        address priceFeed;  //ETH/USD price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        }else if (block.chainid == 1) {
            activeNetworkConfig = getMainetEthConfig();
        }else{
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public  returns(NetworkConfig memory) {
        //price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig ({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
            return sepoliaConfig;
    }

        function getMainetEthConfig() public  returns(NetworkConfig memory) {
        //price feed address
        NetworkConfig memory ethConfig = NetworkConfig ({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
            return ethConfig;
    }

    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory)  {
        //price feed address
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        //1. Desplegar el mock
        //2. Obtener la address del mock
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig ({priceFeed: address(mockPriceFeed)});
        return anvilConfig;
    }
}