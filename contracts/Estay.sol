// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./lib/GenesisUtils.sol";
import "./interfaces/ICircuitValidator.sol";
import "./verifiers/ZKPVerifier.sol";

contract Estay is ZKPVerifier{
     uint64 public constant TRANSFER_REQUEST_ID = 1;


    address Estayowner;
    uint256 counter;
    
    mapping(uint256 => address) public idToAddress;
    mapping(address => uint256) public addressToId;
    mapping(address=>bool) public hasProof;


    struct rentalsInfo{

        string name;                              // name of the property
        string city;                              // city in ehich property is
        string latitude;                          //latitude for map
        string longitude;                         // longitude for map
        string description1;                      // facilities  ex wifi etc.
        string description2;                      // no. of beds bath toilets etc
        string imageUrl;                          //images of property 
        uint256 maxGuests;                        // max guest allowed
        uint256 pricePerday;                      // 24 hour day price
        string[] datesBooked;                     // dates for which property has already been booked
        uint256 id;                               // id as its primary key 
        address renter;                           // Estayowner of the property
    }

    event rentalCreated(
        string name,
        string city,
        string latitude,
        string longitude,
        string description1,
        string description2,
        string imageUrl,
        uint256 maxGuests,
        uint256 pricePerday,   
        string[] datesBooked,
        uint256 id,
        address renter
    );
    
    event newDatesBooked(
        string[] datesBooked,                     
        uint256 id,
        string city,
        string imageurl,
        address booker                                   // customer address
    );
    
    mapping(uint256=>rentalsInfo) rentals;
    uint256[] public rentalsID; 

    constructor(){
        counter = 0;
        Estayowner = msg.sender;
    }
    
    function addRentals(
        string memory name,
        string memory city,
        string memory latitude,
        string memory longitude,
        string memory description1,
        string memory description2,
        string memory imageUrl,
        uint256 maxGuests,
        uint256 pricePerday,
        string[] memory datesBooked

    ) external {

            require(msg.sender==Estayowner," Only Estay owner of smart contract can put up rentals");        
            rentalsInfo storage newRental;    
            newRental = rentals[counter];
            newRental.name = name;
            newRental.city = city; 
            newRental.latitude = latitude;
            newRental.longitude = longitude;
            newRental.description1 = description1;
            newRental.description2 = description2;
            newRental.imageUrl = imageUrl;
            newRental.maxGuests = maxGuests; 
            newRental.pricePerday = pricePerday;
            newRental.id = counter;
            newRental.renter = Estayowner;
            newRental.datesBooked=datesBooked;
            rentalsID.push(counter);
            counter++;

            emit rentalCreated(
                name,
                city,
                latitude,
                longitude,
                description1,
                description2,
                imageUrl,
                maxGuests,
                pricePerday,
                datesBooked,
                counter,
                Estayowner
            );
    }
    
    function checkBooking( uint256 id,string[] memory newBooking ) private view returns(bool){
          
          for(uint256 i=0; i < newBooking.length ; i++){
              for(uint256 j=0; j < rentals[id].datesBooked.length ;j++){
                  if( keccak256(abi.encodePacked( newBooking[i] ))  ==  keccak256(abi.encodePacked( rentals[id].datesBooked[j] ))){
                      return false;
                  }
              }
          }
          return true;
    }

    function addBooking(uint256 id,string[] memory newBooking) external payable{
        require(hasProof[msg.sender],"You are not approved to make bookings");
        require( id < counter," NO such rentals exist");
        require( checkBooking(id,newBooking)," Not available for requested date ");
        require( msg.value == (rentals[id].pricePerday * newBooking.length * 1 ether)," Please Pay the require ammount");

        for(uint256 i=0; i<newBooking.length ; i++ ){
            rentals[id].datesBooked.push(newBooking[i]);
        }

        payable(Estayowner).transfer(msg.value);
        emit newDatesBooked(newBooking, id, rentals[id].city, rentals[id].imageUrl, msg.sender);
    }

    function _beforeProofSubmit(
        uint64, /* requestId */
        uint256[] memory inputs,
        ICircuitValidator validator
    ) internal view override {
        // check that the challenge input of the proof is equal to the msg.sender 
        address addr = GenesisUtils.int256ToAddress(
            inputs[validator.getChallengeInputIndex()]
        );
        require(
            _msgSender() == addr,
            "address in the proof is not a sender address"
        );
    }

    function _afterProofSubmit(
        uint64 requestId,
        uint256[] memory inputs,
        ICircuitValidator validator
    ) internal override {
        require(
            requestId == TRANSFER_REQUEST_ID && addressToId[_msgSender()] == 0,
            "proof can not be submitted more than once"
        );

        uint256 id = inputs[validator.getChallengeInputIndex()];
        // execute the airdrop
        if (idToAddress[id] == address(0)) {
            //super._mint(_msgSender(), TOKEN_AMOUNT_FOR_AIRDROP_PER_ID);
            addressToId[_msgSender()] = id;
            idToAddress[id] = _msgSender();
            hasProof[_msgSender()]=true;
        }
    }

     function getRentals(uint256 id) public view returns(string memory , string memory, uint256, string [] memory){
             
             rentalsInfo storage temp = rentals[id];
             return( temp.name, temp.city, temp.pricePerday, temp.datesBooked );

     }   


 

}