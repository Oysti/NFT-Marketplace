// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./IERC721.sol"

contract Market {
    //public - anyone can call
    //private - only this contract
    //internal - only this contract and inheriting contracts
    //external  - only external calls

    enum ListingStatus {
        Active,
        Sold,
        Cancelled       
    }

    struct Listing {
        ListingStatus status;        
        address seller;
        address token;
        uint tokenId;
        uint price;        
    }
    
    event Listed(
        uint listingId,
        address seller,
        address token,
        uint tokenId,
        uint price,
    );

    event Sale(
        uint ListingId,
        address buyer,
        address token,
        uint tokenId,
        uint price
    
    );

    event Cancel(
        uint listingId,
        address seller
    );

    uint private _listingId = 0;
    mapping(uint => Listing) private _listings;

    function listToken(address token, uint tokenId, uint price) external {
        IERC721(token).transferFrom(msg.sender, address this, tokenID);

        Listing memory listing = Listing(
            ListingStatus.Active,
            msg.sender,
            token,
            tokenId,
            price
        );
        
        _listingId++;

        _listings[_listingId] = listing;

        emit Listed(
            _listingId,
            msg.sender,
            token,
            tokenId,
            price
        );
    }

    
    function getListing(ListingId) public view returns (Listing memory listing) {
        return _listings[ListingId];
    }
    
    function buyToken(uint listingId) external payable {
        Listing storage listing = _listings(listingId);

        require(msg.sender != listing.seller, "Seller cannot be buyer");
        require(Listing.status == ListingStatus.Active, "Listing is not active");
        
        require(msg.value >= listing.price, "Insuffiecient payment");

        listing.status = ListingStatus.Sold;
        
        IERC721(listin.token).transferFrom(address this, msg.sender, listing.tokenID);
        payable(listing.seller).transfer(listing.price);

        emit Sale(
            listingId,
            msg.sender,
            token,
            listing.token,
            listing.tokenId,
            listing.price
        );
    }

    function cancel(uint listingId) public {
        Listing storage listing = _listings(ListingId);

        require(msg.sender == listing.seller, "Only seller can cancel listing");
        require(Listing.status == ListingStatus.Active,"Listing is not active");

        listing.status = ListingStatus.Cancelled;

        IERC721(listin.token).transferFrom(address this, msg.sender, listing.tokenID);

        emit Cancel(listingId, listing.seller);
    }
}
