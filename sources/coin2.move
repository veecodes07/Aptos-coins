module MyAddr::coin2 {
   // use aptos_std::debug;
    //use std::signer;
    
    struct Coin has key {
        value: u64,
    }

    struct Balance has key {
        coin: Coin
    }
    //publish an empty balance resource before minting or transferring
    public fun publish_balance(account: &signer) { .. }
    

    //Mint 'amount' tokens to mint_addr. Mint must be approved by module owner.
    public fun mint(module_owner: &signer, mint_addr: address, amount : u64) aquires Balance { .. }

    //Returns the balance of owner.
    public fun balance_of(owner:address):u64 acquires Balance{ .. }

    //transfers amount of token from to to.
    public fun transfer(from: &signer, to: address, amount: u64) aquires Balance { .. }


}