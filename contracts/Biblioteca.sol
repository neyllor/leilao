// SPDX-License-Identifier: MIT

pragma solidity >0.8.0;

library Biblioteca{
    
    function etherToWei(uint sumInEth) public pure returns(uint){
        return sumInEth * 1 ether;
    }
     
    function minutesToSeconds(uint timeInMin) public pure returns(uint){
        return timeInMin * 1 minutes;
    }
}