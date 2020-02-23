# 

README

## Motivation

This research and development project envisions and describes an easy-to-use community-specific digital currency, that is governed through a Moloch-fork DAO. Users can mint, burn, and hold, and participate in its governance, without the constraints of banks. Tokens are contributed to a communal pool governed by the DAO whenever the token is minted from the smart contract or transferred from one address to a different address. The proposed implementation would operate on a public blockchain and would be backed by Ether. The system is meant to be fully decentralized, and participatory, and operate on-chain without any need for a centralised point of control. If the Trojan DAO is a "bank-as-performance" then its currency is its "currency-as-performance". A currency that is not "bought" or "sold" but rather it is participated in.

Furthermore, the method described can be forked and the depolyment parameters adapted to the scenario of creating a fundraising mechanism for Moloch-fork DAOs, and be used to develop other novel crypto-economic experiments and use-cases.

https://docs.google.com/document/d/1hijSZrzoXS27cmFbjqwUJ-Oh4uBvS-kV6sIw9NJPbns/edit?usp=sharing

## Goals

* Provides an alternative: Provide creative communities with a usable digital currency based on blockchain technology, as a means of fuelling shared goals and exchanging resources across borders without the mediation of banks.

* Participants are incetivised to be involved / contribute through the DAO structure.

* Provide a source of revenue for the DAO through the economic activities that its currency generates, via "DAO tax".

* Used in community events and activities.

* Anti-Speculative: The currency value is pegged to ETH, is backed by a verifiable reserve of ETH that guarantees a minimum value.

* To enact new economic laws that could form the basis for a collaborative ecosystem. Making the flow of capital more efficient through the system unlocks collaborative value and benefits all stakeholders. Creating a circular economy between participants. 

* Autonomous and immutable: There is no central agency defining "monetary policy". There is no "killswitch". The only way to withdraw Ether from the smart contract is to burn the token. The creator, nor anybody else, can ever access this reserve pool of ether, thus guaranteeing a minimum value for each token.

Long Term vision:

Art invades finance - Using blockchain technology, artists involved should be able to exchange value between their communities without the restraints of national borders and capital controls, and without the interference of banks, due to the significant efficiency unlocked in building and operating financial systems.

## Contract Structure

`TrojanToken.sol` is an ERC20-compliant token contract with a built-in bonding curve. This token is used as the "approved token" for the Trojan DAO main contract. TROJ tokens can be minted through the contract, which uses a bonding curve as an automated market maker. The smart contract accumulates Ether when participants mint the token and it distributes Ether when participants burn it.  

'TrojanPool.sol' In our example implementation, the minting process is subject to a 2% DAO tax, where the tax amount is deposited into the Trojan Pool, a follow-on funding contract that mirrors the investments of the Trojan DAO. Burning tokens similarly is taxed 3% to the DAO. Transfers of the token are subject to a 1% "redistribution" tax, whereby the tax is redistributed to all the token holders. 

In our example implementation, we built off the "Sparkle" token, which in turn was inspired by Bomb Token (BOMB) and Ampleforth (AMPL), with the significant imrpovement of having the token's taxes directed to a DAO (DAO tax) to be governed collectively so as to be directed towards projects of mutual interest, rather than being directed to an individual's account.   

This project demonstrates that the bonding curve based token can be used to automatically grant the DAO with funding when it is minted and burned.


## TODOs
* The `TrojanDao.sol` contract depends on the `TrojanToken.sol` contract, which depends on the `TrojanPool.sol` contract, which depends on the `TrojanDao.sol` contract. To work around this circular dependency, we had to add a `setTrojanPool` function. This is horrible for security purposes.
* The `TrojanToken.sol` contract needed to bootstrap the creator with tokens, in order to make testing easier. This should also be fixed for production.
* The TrojanToken contract can deposit funds into the Pool, but it cannot exit them. One way to exit the shares is by making a proxy contract that can receive a grant from the Trojan DAO and then call a function in the TrojanToken contract that will exit the funds.
* The UI needs to integrate the TrojanToken methods.

## Solidity proof of concept
See [source-code](https://github.com/diffusioncon/Trojan-DAO-Ethereum/tree/master/buidler-contracts/contracts) for a proof of concept implementation on Ethereum using Solidity.

## Contracts
[GuildBank.sol](https://github.com/diffusioncon/Trojan-DAO-Ethereum/blob/master/buidler-contracts/contracts/GuildBank.sol)

[TrojanDAO.sol](https://github.com/diffusioncon/Trojan-DAO-Ethereum/blob/master/buidler-contracts/contracts/TrojanDao.sol)

[TrojanPool.sol](https://github.com/diffusioncon/Trojan-DAO-Ethereum/blob/master/buidler-contracts/contracts/TrojanPool.sol)

[TrojanToken.sol](https://github.com/diffusioncon/Trojan-DAO-Ethereum/blob/master/buidler-contracts/contracts/TrojanToken.sol)

## Simulations
CadCAD simulation

Scenarios simulated: mint, burn, and transfer.

Further negative tests and edge case tests need to be done.

- [CADcad model](https://github.com/TROJANFOUNDATION/Trojan-DAO-Monetary-System/blob/master/cadCAD_simulation/trojan_simulation.py)
- [Readme](https://github.com/TROJANFOUNDATION/Trojan-DAO-Monetary-System/blob/master/cadCAD_simulation/README.md)

![individual-mint-burn-trojan-simulation](https://github.com/TROJANFOUNDATION/Trojan-DAO-Monetary-System/blob/master/cadCAD_simulation/mint-burn-graph.png)

## Documentation

[Schematic-diagram](https://github.com/TROJANFOUNDATION/Trojan-DAO-Monetary-System/blob/master/Proposal%20Process%20-%20Trojan%20DAO.pdf) 

[CAD-System-definition](https://github.com/TROJANFOUNDATION/Trojan-DAO-Monetary-System/blob/master/CAD%20System%20Definition%20-%20Trojan%20DAO.pdf)

[Differential equations for mint, burn and transfer scenarios](https://github.com/TROJANFOUNDATION/Trojan-DAO-Monetary-System/blob/master/Differential-equations.pdf)
