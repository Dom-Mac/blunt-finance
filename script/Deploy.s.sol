// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8;

import 'forge-std/Script.sol';
import {CREATE3Factory} from 'create3-factory/CREATE3Factory.sol';

import {BluntDelegateDeployer} from 'contracts/BluntDelegateDeployer.sol';
import {BluntDelegateProjectDeployer} from 'contracts/BluntDelegateProjectDeployer.sol';
import 'contracts/interfaces/IBluntDelegateDeployer.sol';
import '@jbx-protocol/juice-contracts-v3/contracts/interfaces/IJBController.sol';
import '@jbx-protocol/juice-contracts-v3/contracts/interfaces/IJBOperatorStore.sol';

contract DeployScript is Script {
  function run() public returns (BluntDelegateProjectDeployer bluntDeployer) {
    CREATE3Factory create3Factory = CREATE3Factory(0x9fBB3DF7C40Da2e5A0dE984fFE2CCB7C47cd0ABf);
    bytes32 salt = keccak256(bytes(vm.envString('SALT')));
    uint256 deployerPrivateKey = vm.envUint('PRIVATE_KEY');

    // GOERLI
    IJBController jbController = IJBController(0x7Cb86D43B665196BC719b6974D320bf674AFb395);
    IJBOperatorStore jbOperatorStore = IJBOperatorStore(0x99dB6b517683237dE9C494bbd17861f3608F3585);
    address ethAddress = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
    address usdcAddress = 0x2f3A40A3db8a7e3D09B0adfEfbCe4f6F81927557;

    vm.startBroadcast(deployerPrivateKey);

    IBluntDelegateDeployer delegateDeployer = new BluntDelegateDeployer();

    bluntDeployer = BluntDelegateProjectDeployer(
      create3Factory.deploy(
        salt,
        bytes.concat(
          type(BluntDelegateProjectDeployer).creationCode,
          abi.encode(delegateDeployer, jbController, jbOperatorStore, ethAddress, usdcAddress)
        )
      )
    );

    vm.stopBroadcast();
  }
}
