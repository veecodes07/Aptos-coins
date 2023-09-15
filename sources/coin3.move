module MyAddr:: coin3 {
    use std::signer;

    ///Address of the owner of this module
    const MODULE_OWNER: address = MyAddr;

    //Error Codes
    const ENOT_MODULE_OWNER: u64 = 0;
    const EINSUFFICIENT_BALANCE: u64 = 1;
    const EALREADY_HAS_BALANCE: u64 = 2;

    struct Coin has store {
        value: u64

    } 

    struct Balance has store {
        coin: Coin
    }
    //PUBLISH EMPTY BALANCE . THIS FUNC SHOULD BE CALLED BEFORE MINTING.
    public fun publish_balance(account: &signer) {
        //TODO: ADD AN ASSERT TO CHECK IF IT DOES NOT ALREADY HAVE BALANCE.
        let empty_coin = Coin { value: 0};
        move_to(account, Balance { coin: empty_coin});


    }

    ///initialize the module
    public fun mint(module_owner: &signer,  mint_addr: address, amount: u64) {
        //only owner of module can initialize
        assert!(signer::address_of(module_owner) == MODULE_OWNER, ENOT_MODULE_OWNER);
        //DEPOSIT AMOUNT OF TOKENS TO MINT ADDR BALANCE
        deposit(mint_addr, Coin { value : amount});
    }

    ///Return the balance of ownerr.
    public fun balance_of(owner: address): u64 acquires Balance {
        borrow_global<Balance>(owner).coin.value
    }

    ///transfer amount of tokens from to to.
    public fun transfer(from: &signer to: address, amount: u64) acquires Balance {
        let check = withdraw(signer:: address_of(from), amount);
        deposit(to, check);
    }

    //WITHDRAW AMOUNT OF TOKENS FROM THE BALANCE UNDER ADDR
    fun withdraw(addr: address, amount: u64) : Coin acquires Balance {
        let balance = balance_of(addr);
        //balance must be greater than withdraw amount
        assert!(balance >= amount, EINSUFFICIENT_BALANCE);
        let balance_ref = &mut borrow_global_mut<Balance>(addr).coin.value;
        *balance_ref = balance - amount;
        Coin { value: amount}
    }

    /// Deposit `amount` number of tokens to the balance under `addr`.
    fun deposit(_addr: address, check: Coin) {
        // TODO: follow the implementation of `withdraw` and implement me!
        let Coin { value: _amount } = check; // unpacks the check

        // Get a mutable reference of addr's balance's coin value

        // Increment the value by `amount`
    }










}