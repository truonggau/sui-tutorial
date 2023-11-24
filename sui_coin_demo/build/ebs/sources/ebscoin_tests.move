#[test_only]
module ebs::ebscoin_tests {

    use ebs::ebscoin::{Self, EBSCOIN};
    use sui::coin::{Coin, TreasuryCap};
    use sui::test_scenario::{Self, next_tx, ctx};

    #[test]
    fun mint_burn() {
        // Initialize a mock sender address
        let addr1 = @0xA;

        // Begins a multi transaction scenario with addr1 as the sender
        let scenario = test_scenario::begin(addr1);
        
        // Run the ebscoin coin module init function
        {
            ebscoin::test_init(ctx(&mut scenario))
        };

        // Mint a `Coin<EBSCOIN>` object
        next_tx(&mut scenario, addr1);
        {
            let treasurycap = test_scenario::take_from_sender<TreasuryCap<EBSCOIN>>(&scenario);
            ebscoin::mint(&mut treasurycap, 100, addr1, test_scenario::ctx(&mut scenario));
            test_scenario::return_to_address<TreasuryCap<EBSCOIN>>(addr1, treasurycap);
        };

        // Burn a `Coin<EBSCOIN>` object
        next_tx(&mut scenario, addr1);
        {
            let coin = test_scenario::take_from_sender<Coin<EBSCOIN>>(&scenario);
            let treasurycap = test_scenario::take_from_sender<TreasuryCap<EBSCOIN>>(&scenario);
            ebscoin::burn(&mut treasurycap, coin);
            test_scenario::return_to_address<TreasuryCap<EBSCOIN>>(addr1, treasurycap);
        };

        // Cleans up the scenario object
        test_scenario::end(scenario);
    }

}
