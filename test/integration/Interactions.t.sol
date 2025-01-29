// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {Raffle} from "../../src/Raffle.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {Vm} from "forge-std/Vm.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "../../script/Interactions.s.sol";

contract InteractionsTestIntegration is Test {
    Raffle raffle;
    HelperConfig helperConfig;
    CreateSubscription createSubscription;
    FundSubscription fundSubscription;
    AddConsumer addConsumer;

    address vrfCoordinator;
    address link;
    address account;

    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.deployContract();
        createSubscription = new CreateSubscription();
        fundSubscription = new FundSubscription();
        addConsumer = new AddConsumer();

        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        vrfCoordinator = config.vrfCoordinator;
        link = config.link;
        account = config.account;
    }

    function testCreateAndFundSubscriptionIntegration() public {
        // Create a new subscription
        vm.recordLogs();
        (uint256 subId,) = createSubscription.createSubscription(vrfCoordinator, account);

        // Verify subscription was created
        assertTrue(subId > 0, "Subscription ID should be greater than 0");

        // Fund the subscription
        (uint96 initialBalance,,,,) = VRFCoordinatorV2_5Mock(vrfCoordinator).getSubscription(subId);
        fundSubscription.fundSubscription(vrfCoordinator, subId, link, account);

        // Verify funding was successful
        (uint96 finalBalance,,,,) = VRFCoordinatorV2_5Mock(vrfCoordinator).getSubscription(subId);
        assertTrue(finalBalance > initialBalance, "Subscription should be funded");
    }

    function testAddConsumerToSubscriptionIntegration() public {
        // Create and fund subscription
        (uint256 subId,) = createSubscription.createSubscription(vrfCoordinator, account);
        fundSubscription.fundSubscription(vrfCoordinator, subId, link, account);

        // Add consumer
        addConsumer.addConsumer(address(raffle), vrfCoordinator, subId, account);

        // Verify consumer was added
        (,,,, address[] memory consumers) = VRFCoordinatorV2_5Mock(vrfCoordinator).getSubscription(subId);
        bool isConsumer = false;
        for (uint256 i = 0; i < consumers.length; i++) {
            if (consumers[i] == address(raffle)) {
                isConsumer = true;
                break;
            }
        }
        assertTrue(isConsumer, "Raffle should be registered as consumer");
    }

    function testFullSubscriptionFlowWithRaffleIntegration() public {
        // Create subscription
        (uint256 subId,) = createSubscription.createSubscription(vrfCoordinator, account);

        // Fund subscription
        fundSubscription.fundSubscription(vrfCoordinator, subId, link, account);

        // Add consumer
        addConsumer.addConsumer(address(raffle), vrfCoordinator, subId, account);

        // Enter raffle to verify everything works
        uint256 entranceFee = raffle.getEntranceFee();

        hoax(account, entranceFee);
        raffle.enterRaffle{value: entranceFee}();

        // Verify player was added
        address player = raffle.getPlayer(0);
        assertEq(player, account, "Player should be registered in raffle");
    }
}
