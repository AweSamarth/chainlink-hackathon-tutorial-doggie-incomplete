const {network, ethers} = require("hardhat")


module.exports = async function(hre){

    const {getNamedAccounts, deployments}=hre
    const{deployer}=await getNamedAccounts()
    const {deploy,  log} = deployments
    const chainId= network.config.chainId
    let vrfCoordinatorV2Address, subscriptionId
    const FUND_AMOUNT="10000000000000000000"

    let tokenUris=[
        
    ]

    /*we need the chainId because if we are working on a testnet or a mainnet those addresses will exist. On a local chain, 
    they won't! So we're gonna make a fake chainlink VRF node (this process is called mocking)
    */
    if (chainId==31337){
         //fake chainlink node\
         const vrfCoordinatorV2Mock= await ethers.getContract("VRFCoordinatorV2Mock")
         vrfCoordinatorV2Address= vrfCoordinatorV2Mock.address
         //whenever we create a vrfCoordinator, we need a subscription along with it    
         const tx=await vrfCoordinatorV2Mock.createSubscription()
         const txReceipt=await tx.wait(1) //waiting a single block
         subscriptionId=txReceipt.events[0].args.subId
         await vrfCoordinatorV2Mock.fundSubscription(SubscriptionId, FUND_AMOUNT)
    }
    else{
        //real ones
        vrfCoordinatorV2Address= "0x6168499c0cFfCaCD319c818142124B7A15E857ab"
        subscriptionId="3491"
    }
    
    args=[
        vrfCoordinatorV2Address,
        "0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc",
        subscriptionId,
        "500000",
        //list of dogs


    ]
}