# 

Trojan DAO

## Motivation

This research and development project envisions and describes an easy-to-use community-specific digital currency, that is governed through a Moloch-type DAO. Users can mint, burn, and hold, and participate in its governance, without the constraints of banks. The proposed implementation would operate on a public blockchain and would be backed by Ether. The system is meant to be fully decentralized, and participatory, and operate on-chain without any need for a centralised point of control. If the Trojan DAO is a "bank-as-performance" then its currency is its "currency-as-performance". A currency that is not "bought" or "sold" but rather it is participated in.

Furthermore, the method described can be forked and the depolyment parameters adapted to the scenario of a fundraising mechanism for Moloch-type DAOs. 

https://docs.google.com/document/d/1hijSZrzoXS27cmFbjqwUJ-Oh4uBvS-kV6sIw9NJPbns/edit?usp=sharing

## Goals

Provide creative communities with a usable digital currency based on blockchain technology.

Allow stakeholders to participate in the governance of the currency through a DAO structure.

Provide a source of revenue for the DAO through the economic activities that its currency generates, via "DAO tax".

Making the flow of capital more efficient through the system unlocks economic value and benefits all stakeholders. Creating a circular economy between participants. 

Long Term vision:

Art invades finance - Using blockchain technology, artists involved should be able to exchange value between their communities without the restraints of national borders and capital controls, and without the interference of banks, due to the significant efficiency unlocked in building and operating financial systems.

## Contract Structure

`TrojanToken.sol` is an ERC20-compliant token contract with a built-in bonding curve. This token is used as the "approved token" for the Trojan DAO main contract. TROJ tokens can be minted through the contract, which uses a bonding curve as an automated market maker.

In our example implementation, the minting process is subject to a 2% DAO tax, where the tax amount is deposited into the Trojan Pool, a follow-on funding contract that mirrors the investments of the Trojan DAO. Burning tokens similarly is taxed 3% to the DAO. Transfers of the token are subject to a 1% "redistribution" tax, whereby the tax is redistributed to all the token holders.

This project demonstrates that the bonding curve based token can be used to automatically grant the DAO with funding when it is minted and burned.

## TODOs
* The `TrojanDao.sol` contract depends on the `TrojanToken.sol` contract, which depends on the `TrojanPool.sol` contract, which depends on the `TrojanDao.sol` contract. To work around this circular dependency, we had to add a `setTrojanPool` function. This is horrible for security purposes.
* The `TrojanToken.sol` contract needed to bootstrap the creator with tokens, in order to make testing easier. This should also be fixed for production.
* The TrojanToken contract can deposit funds into the Pool, but it cannot exit them. One way to exit the shares is by making a proxy contract that can receive a grant from the Trojan DAO and then call a function in the TrojanToken contract that will exit the funds.
* The UI needs to integrate the TrojanToken methods.
