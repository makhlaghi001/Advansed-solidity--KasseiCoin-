pragma solidity ^0.5.0;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";


// Have the KaseiCoinCrowdsale contract inherit the following OpenZeppelin:
// * Crowdsale
// * MintedCrowdsale
// * CapperCrowdsale 
// * TimedCrowdsale 
// * RefundablePostDeliveryCrwodsale
contract KaseiCoinCrowdsale is Crowdsale, MintedCrowdsale,CappedCrowdsale,TimedCrowdsale,RefundablePostDeliveryCrowdsale { 
    
    // Provide parameters for all of the features of your crowdsale, such as the `rate`, `wallet` for fundraising, and `token`.
    constructor(
        uint rate,
        address payable wallet,
        KaseiCoin token,
        uint goal,
        uint Open,
        uint Close
    ) public  
            Crowdsale(rate, wallet, token)
            CappedCrowdsale(goal)
            TimedCrowdsale(Open, Close)
            RefundableCrowdsale(goal)
    

    
       
    {
       
    }
}


contract KaseiCoinCrowdsaleDeployer {
    // Create an `address public` variable called `kasei_token_address`.
    address public kasei_token_address;
    // Create an `address public` variable called `kasei_crowdsale_address`.
    address public kasei_crowdsale_address;

    // Add the constructor.
    constructor( 
        string memory name, 
        string memory symbol,
        address payable wallet,
        uint goal 
    ) public {
        // Create a new instance of the KaseiCoin contract.
        KaseiCoin token = new KaseiCoin(name, symbol, 0);
        
        // Assign the token contract’s address to the `kasei_token_address` variable.
        kasei_token_address = address(token);

        // Create a new instance of the `KaseiCoinCrowdsale` contract
        KaseiCoinCrowdsale Kasei_Crowdsale  = new KaseiCoinCrowdsale (1, wallet, token, goal, now, now + 24 weeks);
            
        // Aassign the `KaseiCoinCrowdsale` contract’s address to the `kasei_crowdsale_address` variable.
        kasei_crowdsale_address =  address(Kasei_Crowdsale);

        // Set the `KaseiCoinCrowdsale` contract as a minter
        token.addMinter( kasei_crowdsale_address);
        
        // Have the `KaseiCoinCrowdsaleDeployer` renounce its minter role.
        token.renounceMinter();
    }
}
