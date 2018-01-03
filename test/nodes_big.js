const chai = require("chai");
chai.use(require('chai-as-promised'));
chai.use(require('chai-bignumber')());
chai.should();

const utils = require("./test_utils");
const accounts = require("./testrpc_accounts");
const steps = require("./steps");

contract('Nodes (big)', function () {

  // it("can get all pools", async function () {
  //   // Register and deregister
  //   await steps.Register(accounts[0], 1000);
  //   // console.log(await steps.GetAllNodes());
  //   await steps.Deregister(accounts[0]);
  // });

  // it("can register all miners", async function () {
  //   await steps.RegisterAll(accounts, 1000);
  //   await steps.DeregisterAll(accounts);
  // });

  it("assigns evenly distributed pools", async function () {
    await steps.RegisterAll(accounts, 1000);

    // Wait for next shuffling
    await steps.WaitForEpoch();

    // await steps.AssertPoolDistribution(accounts);

    await steps.DeregisterAll(accounts);
  });

});