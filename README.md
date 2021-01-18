# FH - Blockchain - Voting #

## An Ethereum Smart-Contract & Web3 JS Interface for trustless voting at the Technikum ##

This repository hosts a simple smart contract project which allows for trustless and immutable voting.
The project is currently a prove of concept which is however mostly production ready. 
It has been designed for elections of student parties at the University of Applied Sciences Technikum, 
however the contract and its interface can be used in other contexts as well.
<br>
The 2 core components of this repository are:

- The `FHvoting.sol` file which contains the smart contract...

- ...and the `docs` folder, which hosts the index.html containing the interface.

The latter of the two has been deployed on github-pages and can be viewed [right here!](https://nilsbroer.github.io/INN1-2/) <br>
There is even a test-contract deployed on the rinkeybee testnet.

---

## Goals: ##

---

### INN1: ###
 - Creating a private blockchain in a local environment [X]
 - Creating a private FH-network. [X]
 - Implement use-case: Create a process to safe immutable voting-results on the blockchain. [X]
     - The first version of the main contract shall allow to create a collection of parties to vote for
     - and allow time-restricted access
     - for students to vote (restricted by ID).
     - Properly test the existing contract for mistakes
 - Deploy contract on FH-Blockchain (and run) [INN2]
 
TODO (leftover):
 - Finding a way to make voting anonymous (currently input-variables are viewable).
 - Deploy contract on FH-Blockchain (and run)
 - Finding a way to make voting securer and more user-friendly
      - Potentially using AKAP or MetaMask
 - Extending the scope of the voting-contract
 
 ---
 
 ### INN2: ###
 - Improve and finish-up initial contract [ ]
 - Add (any) User-Login-feature [ ]
 - Improve anonymity (currently function-parameters are visible) [ ]
 - Impore usability [ ]
     - Ideally with Blockchain-internal WebUI
     - Can further be used for login (via MetaMask ?)
 - Actually deploy contract, ! switch to Rinkeby ! [ ]
 
 TODO (leftover):
 - Enable MetaMask on a private FH-Network
     - so that FHTW can distribute it's own "Ether"
     - Distribute Ether necessary for voting (to restrict students from unpermitted actions, e.g. voting multiple times)
