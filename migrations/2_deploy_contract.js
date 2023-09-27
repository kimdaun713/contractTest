const Demo_Contract = artifacts.require("PostFilter");

module.exports = function(deployer) {
  deployer.deploy(Demo_Contract);
};