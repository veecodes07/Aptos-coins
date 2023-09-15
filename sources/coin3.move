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
    fun deposit(addr: address, check: Coin) acquires Balance {
        let balance = balance_of(addr);
        let balance_ref = &mut borrow_global_mut<Balance>(addr).coin.value;
        let Coin { value } = check;
        *balance_ref = balance + value;
    }

    #[test(account = @0x1)] // Creates a signer for the `account` argument with address `@0x1`
    #[expected_failure] // This test should abort
    fun mint_non_owner(account: &signer) acquires Balance {
        // Make sure the address we've chosen doesn't match the module
        // owner address
        publish_balance(account);
        assert!(signer::address_of(account) != MODULE_OWNER, 0);
        mint(account, @0x1, 10);
    }

     #[test(account = @MyAddr)] // Creates a signer for the `account` argument with the value of the named address `MyAddr`
    fun mint_check_balance(account: &signer) acquires Balance {
        let addr = signer::address_of(account);
        publish_balance(account);
        mint(account, @named_addr, 42);
        assert!(balance_of(addr) == 42, 0);
    }

    #[test(account = @0x1)]
    fun publish_balance_has_zero(account: &signer) acquires Balance {
        let addr = signer::address_of(account);
        publish_balance(account);
        assert!(balance_of(addr) == 0, 0);
    }

    #[test(account = @0x1)]
    #[expected_failure(abort_code = 2, location = Self)] // Can specify an abort code
    fun publish_balance_already_exists(account: &signer) {
        publish_balance(account);
        publish_balance(account);
    }

    
    #[test]
    #[expected_failure]
    fun withdraw_dne() acquires Balance {
        // Need to unpack the coin since `Coin` is a resource
        Coin { value: _ } = withdraw(@0x1, 0);
    }

    #[test(account = @0x1)]
    #[expected_failure] // This test should fail
    fun withdraw_too_much(account: &signer) acquires Balance {
        let addr = signer::address_of(account);
        publish_balance(account);
        Coin { value: _ } = withdraw(addr, 1);
    }

    #[test(account = @MyAddr)]
    fun can_withdraw_amount(account: &signer) acquires Balance {
        publish_balance(account);
        let amount = 1000;
        let addr = signer::address_of(account);
        mint(account, addr, amount);
        let Coin { value } = withdraw(addr, amount);
        assert!(value == amount, 0);
    }








}