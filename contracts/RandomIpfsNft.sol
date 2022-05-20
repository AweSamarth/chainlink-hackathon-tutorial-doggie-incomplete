// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; 

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";



contract RandomIpfsNft is ERC721URIStorage, VRFConsumerBaseV2{

    VRFCoordinatorV2Interface immutable i_vrfCoordinator; 
    //i for denoting immutability. Immutable variables are very cheap in terms of gas. Constants are even cheaper
    bytes32 public immutable i_gasLane;   
    //price per gas 
    uint64 public immutable i_subscriptionId;

    uint16 public constant REQUEST_CONFIRMATIONS = 3;
    //for constant variable we mostly name them in all caps.
    //is the number of blocks that needed to be on top of hat block in order to consider it confirmed.

    uint32 public constant NUM_WORDS=1;
    //the number of random numbers that we want

    uint32 public immutable i_callbackGasLimit;
    //max gas amount

    uint256 public constant MAX_CHANCE_VALUE = 100;

    mapping (uint256=>address) public s_requestIdtoSender;
    string[3] public s_dogTokenUris;


    uint256 public s_tokenCounter;



    constructor(
        address vrfCoordinatorV2,
         bytes32 gasLane,
          uint64 subscriptionId,
           uint32 callbackGasLimit,
           string[3] memory dogTokenUris
           ) ERC721("Random IPFS NFT", "RIN") VRFConsumerBaseV2(vrfCoordinatorV2){

        i_vrfCoordinator =VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gasLane= gasLane;
        i_subscriptionId= subscriptionId;
        i_callbackGasLimit=callbackGasLimit;
         s_tokenCounter=0;
         s_dogTokenUris=dogTokenUris;
             //0 st. Bernard
             //1 Pug
            //2 shiba
        
    }
        //mint a random puppy
        function requestDoggie() public returns (uint256 requestId){

             requestId=i_vrfCoordinator.requestRandomWords(

                 i_gasLane,
                 i_subscriptionId,
                 REQUEST_CONFIRMATIONS,
                 i_callbackGasLimit,
                 NUM_WORDS 
             );
        s_requestIdtoSender[requestId]=msg.sender;


    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override{
        address dogOwner=s_requestIdtoSender[requestId];
        uint256 newTokenId=s_tokenCounter;
        s_tokenCounter=s_tokenCounter+1;
        uint256 moddedRng= randomWords[0]%MAX_CHANCE_VALUE;
        uint256 breed= getBreedFromModdedRng(moddedRng);
        _safeMint(dogOwner, newTokenId);
        _setTokenURI(newTokenId, s_dogTokenUris[breed]);


    } 

    function getChanceArray() public pure returns(uint256[3] memory){
        //0-9 St Bernard
        // 10-29 Pug
        // 30-99 Shiba Inu
        return [10,30, MAX_CHANCE_VALUE];
    }



    function getBreedFromModdedRng(uint256 moddedRng) public pure returns(uint256){
        uint256 cumulativeSum=0;
        uint256[3] memory chanceArray=getChanceArray();
        
        for (uint256 i=0; i<chanceArray.length; i++){
            if (moddedRng>= cumulativeSum && moddedRng< cumulativeSum+chanceArray[i]){
                return i;
            }
        cumulativeSum+=chanceArray[i];
        }


    }
}