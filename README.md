Starting-Goals:
 - Creating a private blockchain in  a local environment [X]
 - Transitioning this to a private FH-network. [ ]
 - Implement use-case: Create a process to safe immutable voting-results on the blockchain. [X]
     - The first version of the main contract shall allow to create a collection of parties to vote for
     - and allow time-restricted access
     - for students to vote (restricted by ID).

Further improvements and additional features can be implemented if time is left over, during next semester or even in the scope of a bachelor thesis.

As most of the above goals have been met, upcoming goals include:
 - Testing the current version, to not allow for any mistakes.
 - Finding a way to make voting anonymous (currently input-variables are viewable).
 - Creating a private FH-blockchain on VMs.
 - Deploing said contract on the FH-blockchain.

Future Ideas are, for example:
 - Finding a way to make voting securer (Potentially using AKAP, which is a little bit like LDAP for Ethereum).
 - Extending the scope of the voting-contract from FH-internal to something more global.