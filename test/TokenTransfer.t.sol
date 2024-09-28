// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {TokenTransfer} from "../src/TransferToken.sol";
import {IERC20} from "@chainlink/contracts-ccip/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/IERC20.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";

contract TokenTransferTest is Test {
    TokenTransfer public tokenTransfer;
    IERC20 public mockLinkToken;
    IRouterClient public mockRouter;

    address owner = address(1);
    address receiver = address(2);
    address mockLinkTokenAddress = address(3);
    address mockRouterAddress = address(4);
    address token = address(5);

    uint64 destinationChainSelector = 1;

    function setUp() public {
        // Set the owner address as the deployer
        vm.startPrank(owner);

        // Deploy mocks
        mockLinkToken = IERC20(mockLinkTokenAddress);
        mockRouter = IRouterClient(mockRouterAddress);

        // Deploy the TokenTransfer contract with mocked router and LINK token
        tokenTransfer = new TokenTransfer(
            mockRouterAddress,
            mockLinkTokenAddress
        );

        // Allowlist a destination chain for testing
        tokenTransfer.allowlistDestinationChain(destinationChainSelector, true);

        vm.stopPrank();
    }

    function testTransferTokensPayLINK_Success() public {
        // Arrange
        uint256 amount = 100 ether;
        uint256 fees = 10 ether;

        // Set up the mock calls
        vm.mockCall(
            mockLinkTokenAddress,
            abi.encodeWithSelector(
                IERC20.balanceOf.selector,
                address(tokenTransfer)
            ),
            abi.encode(20 ether)
        );
        vm.mockCall(
            mockRouterAddress,
            abi.encodeWithSelector(
                IRouterClient.getFee.selector,
                destinationChainSelector,
                ""
            ),
            abi.encode(fees)
        );

        vm.mockCall(
            mockLinkTokenAddress,
            abi.encodeWithSelector(
                IERC20.approve.selector,
                mockRouterAddress,
                fees
            ),
            abi.encode(true)
        );

        vm.mockCall(
            mockRouterAddress,
            abi.encodeWithSelector(
                IRouterClient.ccipSend.selector,
                destinationChainSelector,
                ""
            ),
            abi.encode(bytes32("mockMessageId"))
        );

        // Act
        vm.prank(owner);
        bytes32 messageId = tokenTransfer.transferTokensPayLINK(
            destinationChainSelector,
            receiver,
            token,
            amount
        );

        // Assert
        assertEq(messageId, bytes32("mockMessageId"));
    }

    function testTransferTokensPayLINK_NotEnoughBalance() public {
        // Arrange
        uint256 amount = 100 ether;
        uint256 fees = 10 ether;

        // Set up the mock calls
        vm.mockCall(
            mockLinkTokenAddress,
            abi.encodeWithSelector(
                IERC20.balanceOf.selector,
                address(tokenTransfer)
            ),
            abi.encode(5 ether)
        );
        vm.mockCall(
            mockRouterAddress,
            abi.encodeWithSelector(
                IRouterClient.getFee.selector,
                destinationChainSelector,
                ""
            ),
            abi.encode(fees)
        );

        // Act & Assert
        vm.prank(owner);
        vm.expectRevert(
            abi.encodeWithSelector(
                TokenTransfer.NotEnoughBalance.selector,
                5 ether,
                fees
            )
        );
        tokenTransfer.transferTokensPayLINK(
            destinationChainSelector,
            receiver,
            token,
            amount
        );
    }

    function testTransferTokensPayNative_NotEnoughBalance() public {
        // Arrange
        uint256 amount = 100 ether;
        uint256 fees = 1 ether;

        // Set up initial balance (insufficient)
        vm.deal(address(tokenTransfer), 0.5 ether);

        // Act & Assert
        vm.prank(owner);
        vm.expectRevert(
            abi.encodeWithSelector(
                TokenTransfer.NotEnoughBalance.selector,
                0.5 ether,
                fees
            )
        );
        tokenTransfer.transferTokensPayNative(
            destinationChainSelector,
            receiver,
            token,
            amount
        );
    }

    function testWithdraw_Success() public {
        // Arrange
        uint256 initialBalance = 10 ether;
        vm.deal(address(tokenTransfer), initialBalance);

        // Act
        vm.prank(owner);
        tokenTransfer.withdraw(owner);

        // Assert
        assertEq(owner.balance, initialBalance);
    }

    function testWithdraw_NothingToWithdraw() public {
        // Act & Assert
        vm.prank(owner);
        vm.expectRevert(TokenTransfer.NothingToWithdraw.selector);
        tokenTransfer.withdraw(owner);
    }

    function testAllowlistDestinationChain_Success() public {
        // Act
        vm.prank(owner);
        tokenTransfer.allowlistDestinationChain(1234, true);

        // Assert
        assertTrue(tokenTransfer.allowlistedChains(1234));
    }

    function testInvalidReceiverAddress() public {
        // Act & Assert
        vm.prank(owner);
        vm.expectRevert(TokenTransfer.InvalidReceiverAddress.selector);
        tokenTransfer.transferTokensPayLINK(
            destinationChainSelector,
            address(0),
            token,
            100 ether
        );
    }
}
