module MyAddr::basic_coin {
   // use aptos_std::debug;
    use std::signer;
    
    struct Coin has key {
        value: u64,
    }

    public entry fun mint(account: &signer, value: u64) {
        move_to(account, Coin {value})
    }

    #[test(account = @0x1)]
    fun test_mint_10(account: &signer) acquires Coin {
        let addr = signer::address_of(account);
        mint(account, 10);

//check if the minted 10 coins are there in the wallet of signer
        assert!(borrow_global<Coin>(addr).value == 10, 0);   
            }
}