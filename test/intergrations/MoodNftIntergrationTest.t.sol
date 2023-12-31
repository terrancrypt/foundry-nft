// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract MoodNftIntergrationTest is Test {
    MoodNft moodNft;
    string public constant HAPPY_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CiAgPGcgY2xhc3M9ImV5ZXMiPgogICAgPGNpcmNsZSBjeD0iNjEiIGN5PSI4MiIgcj0iMTIiLz4KICAgIDxjaXJjbGUgY3g9IjEyNyIgY3k9IjgyIiByPSIxMiIvPgogIDwvZz4KICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+Cjwvc3ZnPg==";

    string public constant SAD_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/Pgo8c3ZnIHdpZHRoPSIxMDI0cHgiIGhlaWdodD0iMTAyNHB4IiB2aWV3Qm94PSIwIDAgMTAyNCAxMDI0IiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxwYXRoIGZpbGw9IiMzMzMiIGQ9Ik01MTIgNjRDMjY0LjYgNjQgNjQgMjY0LjYgNjQgNTEyczIwMC42IDQ0OCA0NDggNDQ4IDQ0OC0yMDAuNiA0NDgtNDQ4Uzc1OS40IDY0IDUxMiA2NHptMCA4MjBjLTIwNS40IDAtMzcyLTE2Ni42LTM3Mi0zNzJzMTY2LjYtMzcyIDM3Mi0zNzIgMzcyIDE2Ni42IDM3MiAzNzItMTY2LjYgMzcyLTM3MiAzNzJ6Ii8+CiAgPHBhdGggZmlsbD0iI0U2RTZFNiIgZD0iTTUxMiAxNDBjLTIwNS40IDAtMzcyIDE2Ni42LTM3MiAzNzJzMTY2LjYgMzcyIDM3MiAzNzIgMzcyLTE2Ni42IDM3Mi0zNzItMTY2LjYtMzcyLTM3Mi0zNzJ6TTI4OCA0MjFhNDguMDEgNDguMDEgMCAwIDEgOTYgMCA0OC4wMSA0OC4wMSAwIDAgMS05NiAwem0zNzYgMjcyaC00OC4xYy00LjIgMC03LjgtMy4yLTguMS03LjRDNjA0IDYzNi4xIDU2Mi41IDU5NyA1MTIgNTk3cy05Mi4xIDM5LjEtOTUuOCA4OC42Yy0uMyA0LjItMy45IDcuNC04LjEgNy40SDM2MGE4IDggMCAwIDEtOC04LjRjNC40LTg0LjMgNzQuNS0xNTEuNiAxNjAtMTUxLjZzMTU1LjYgNjcuMyAxNjAgMTUxLjZhOCA4IDAgMCAxLTggOC40em0yNC0yMjRhNDguMDEgNDguMDEgMCAwIDEgMC05NiA0OC4wMSA0OC4wMSAwIDAgMSAwIDk2eiIvPgogIDxwYXRoIGZpbGw9IiMzMzMiIGQ9Ik0yODggNDIxYTQ4IDQ4IDAgMSAwIDk2IDAgNDggNDggMCAxIDAtOTYgMHptMjI0IDExMmMtODUuNSAwLTE1NS42IDY3LjMtMTYwIDE1MS42YTggOCAwIDAgMCA4IDguNGg0OC4xYzQuMiAwIDcuOC0zLjIgOC4xLTcuNCAzLjctNDkuNSA0NS4zLTg4LjYgOTUuOC04OC42czkyIDM5LjEgOTUuOCA4OC42Yy4zIDQuMiAzLjkgNy40IDguMSA3LjRINjY0YTggOCAwIDAgMCA4LTguNEM2NjcuNiA2MDAuMyA1OTcuNSA1MzMgNTEyIDUzM3ptMTI4LTExMmE0OCA0OCAwIDEgMCA5NiAwIDQ4IDQ4IDAgMSAwLTk2IDB6Ii8+Cjwvc3ZnPg==";

    string public constant SAD_SVG_URI =
        "data:application/json;base64,eyJuYW1lIjogIk1vb2QgTkZUIiwgImRlc2NyaXB0aW9uIjogIkFuIE5GVCB0aGF0IHJlZmxlY3RzIHRoZSBvd25lcnMgbW9vZC4iLCAiYXR0cmlidXRlcyI6IFt7InRyYWlsX3R5cGUiOiAibW9vZGluZXNzIiwgInZhbHVlIjogMTAwfV0gLCAiaW1hZ2UiOiAiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQRDk0Yld3Z2RtVnljMmx2YmowaU1TNHdJaUJ6ZEdGdVpHRnNiMjVsUFNKdWJ5SS9Qanh6ZG1jZ2QybGtkR2c5SWpFd01qUndlQ0lnYUdWcFoyaDBQU0l4TURJMGNIZ2lJSFpwWlhkQ2IzZzlJakFnTUNBeE1ESTBJREV3TWpRaUlIaHRiRzV6UFNKb2RIUndPaTh2ZDNkM0xuY3pMbTl5Wnk4eU1EQXdMM04yWnlJK1BIQmhkR2dnWm1sc2JEMGlJek16TXlJZ1pEMGlUVFV4TWlBMk5FTXlOalF1TmlBMk5DQTJOQ0F5TmpRdU5pQTJOQ0ExTVRKek1qQXdMallnTkRRNElEUTBPQ0EwTkRnZ05EUTRMVEl3TUM0MklEUTBPQzAwTkRoVE56VTVMalFnTmpRZ05URXlJRFkwZW0wd0lEZ3lNR010TWpBMUxqUWdNQzB6TnpJdE1UWTJMall0TXpjeUxUTTNNbk14TmpZdU5pMHpOeklnTXpjeUxUTTNNaUF6TnpJZ01UWTJMallnTXpjeUlETTNNaTB4TmpZdU5pQXpOekl0TXpjeUlETTNNbm9pTHo0OGNHRjBhQ0JtYVd4c1BTSWpSVFpGTmtVMklpQmtQU0pOTlRFeUlERTBNR010TWpBMUxqUWdNQzB6TnpJZ01UWTJMall0TXpjeUlETTNNbk14TmpZdU5pQXpOeklnTXpjeUlETTNNaUF6TnpJdE1UWTJMallnTXpjeUxUTTNNaTB4TmpZdU5pMHpOekl0TXpjeUxUTTNNbnBOTWpnNElEUXlNV0UwT0M0d01TQTBPQzR3TVNBd0lEQWdNU0E1TmlBd0lEUTRMakF4SURRNExqQXhJREFnTUNBeExUazJJREI2YlRNM05pQXlOekpvTFRRNExqRmpMVFF1TWlBd0xUY3VPQzB6TGpJdE9DNHhMVGN1TkVNMk1EUWdOak0yTGpFZ05UWXlMalVnTlRrM0lEVXhNaUExT1RkekxUa3lMakVnTXprdU1TMDVOUzQ0SURnNExqWmpMUzR6SURRdU1pMHpMamtnTnk0MExUZ3VNU0EzTGpSSU16WXdZVGdnT0NBd0lEQWdNUzA0TFRndU5HTTBMalF0T0RRdU15QTNOQzQxTFRFMU1TNDJJREUyTUMweE5URXVObk14TlRVdU5pQTJOeTR6SURFMk1DQXhOVEV1Tm1FNElEZ2dNQ0F3SURFdE9DQTRMalI2YlRJMExUSXlOR0UwT0M0d01TQTBPQzR3TVNBd0lEQWdNU0F3TFRrMklEUTRMakF4SURRNExqQXhJREFnTUNBeElEQWdPVFo2SWk4K1BIQmhkR2dnWm1sc2JEMGlJek16TXlJZ1pEMGlUVEk0T0NBME1qRmhORGdnTkRnZ01DQXhJREFnT1RZZ01DQTBPQ0EwT0NBd0lERWdNQzA1TmlBd2VtMHlNalFnTVRFeVl5MDROUzQxSURBdE1UVTFMallnTmpjdU15MHhOakFnTVRVeExqWmhPQ0E0SURBZ01DQXdJRGdnT0M0MGFEUTRMakZqTkM0eUlEQWdOeTQ0TFRNdU1pQTRMakV0Tnk0MElETXVOeTAwT1M0MUlEUTFMak10T0RndU5pQTVOUzQ0TFRnNExqWnpPVElnTXprdU1TQTVOUzQ0SURnNExqWmpMak1nTkM0eUlETXVPU0EzTGpRZ09DNHhJRGN1TkVnMk5qUmhPQ0E0SURBZ01DQXdJRGd0T0M0MFF6WTJOeTQySURZd01DNHpJRFU1Tnk0MUlEVXpNeUExTVRJZ05UTXplbTB4TWpndE1URXlZVFE0SURRNElEQWdNU0F3SURrMklEQWdORGdnTkRnZ01DQXhJREF0T1RZZ01Ib2lMejQ4TDNOMlp6ND0ifQ==";

    address public user = makeAddr("user");

    DeployMoodNft deployer;

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testViewTokenURIIntergration() public {
        vm.prank(user);
        moodNft.mintNft();
        console.log(moodNft.tokenURI(0));
    }

    function testFlipTokenToSad() public {
        vm.prank(user);
        moodNft.mintNft();

        vm.prank(user);
        moodNft.flipMood(0);

        assertEq(
            keccak256(abi.encodePacked(moodNft.tokenURI(0))),
            keccak256(abi.encodePacked(SAD_SVG_URI))
        );
    }
}
