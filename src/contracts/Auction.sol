pragma solidity ^0.5.0;

contract Auction {

   
	struct Item{			
		string item_name; // name
		string item_desc; // description
		uint base_price; // start price
		uint min_increment; // minimum increment for a bid
		uint auction_price;  // current price of item
	}
	
	string public name="Auction";
	uint constant  public itemCount = 4;
    uint[itemCount] public arrayForItems;
	uint public itemId = 0;
	

    mapping(uint => Item) public items; // item hash table
	mapping(uint => address) public highestBidders; // highest bidders hash table


	event BidEvent(uint _itemId, uint indexed _bidAmt);


	constructor() public {	
		addItem("Vase", "18th Century lost masterpiece with blue-and-white floral design", 20, 2, 20);
		addItem("Mona Lisa", "Famous painting by the Italian artist, Leonardo da Vinci. Just beautiful!", 200, 20, 200);
		addItem("Starry Night", "A Van Gogh classic depicting a beautiful starry night using pastels.", 150, 35, 150);
		addItem("Liberty Leading the People", "Delacroix painting commemorating the July Revolution of 1830 in France", 1000, 100, 1000);
	}
	

	function addItem (string memory _name, string memory _desc, uint _baseValue, uint _increment, uint _startPrice) private { 	
		items[itemId] = Item(_name, _desc, _baseValue, _increment,_startPrice);
		highestBidders[itemId] = address(0);
		itemId ++;
	}


	function getItemCount () public pure returns (uint) {
		return itemCount;
	}
	

	function getItemName (uint _itemId) public view returns (string memory) {
		require(_itemId >= 0 && _itemId < itemCount, "Item does not exist"); // the item id must be greater than 0 but less or equal to the total count

		return items[_itemId].item_name;
	}


	function getItemPrice (uint _itemId) public view returns (uint) {
		require(_itemId >= 0 && _itemId < itemCount, "Item does not exist"); // the item id must be greater than 0 but less or equal to the total count

		return items[_itemId].auction_price;
	}
	

	function getItemIncrement (uint _itemId) public view returns (uint) {
		require(_itemId >= 0 && _itemId < itemCount, "Item does not exist"); // the item id must be greater than 0 but less or equal to the total count

		return items[_itemId].min_increment;
	}
	

	function getPercentIncrease (uint _itemId) public view returns (uint) {
		uint auctionPrice = items[_itemId].auction_price;
		uint basePrice = items[_itemId].base_price;
		uint percentIncrease = (auctionPrice - basePrice)*100/basePrice;

		return percentIncrease;
	}
	

	function getArrayOfNumericalInformation (uint num) public view returns (uint[itemCount] memory) {
		uint[itemCount] memory arrayOfNumbers;

		for (uint i=0;i < itemCount; i++) {
			if (num == 1) {
				arrayOfNumbers[i] = this.getItemPrice(i);
			} else if (num == 2) {
				arrayOfNumbers[i] = this.getPercentIncrease(i);
			} else if (num == 3) {
				arrayOfNumbers[i] = this.getItemIncrement(i);
			}
		}

		return arrayOfNumbers;
	}
	

	function getArrayOfPrices () public view returns (uint[itemCount] memory) {
		return this.getArrayOfNumericalInformation(1);
	}


	function getArrayOfIncreases () public view returns (uint[itemCount] memory) {
		return this.getArrayOfNumericalInformation(2);
	}


	function getArrayOfIncrements () public view returns (uint[itemCount] memory) {
		return this.getArrayOfNumericalInformation(3);
	}


	function getHighestBidders () public view returns (address[itemCount] memory) {
		address[itemCount] memory arrayOfBidders;

		for (uint i=0;i < itemCount; i++) {
			arrayOfBidders[i] = highestBidders[i];
		}

		return arrayOfBidders;

	}
	
	
    // Function to place a bid
    function placeBid (uint _itemId, uint _bidAmt) public returns (uint) {
        // Requirements 
		require(_itemId >= 0 && _itemId < itemCount, "Bidding on an invalid item"); // the item id must be greater than 0 but less than the total count
		
		require(check_bid (_itemId, _bidAmt),"Bid is lower or equal to the highest bid value"); // the bid should be higher or equal to the current
		
		require(check_increment (_itemId, _bidAmt),"Bid is not enough based on minimum increment"); // make sure that the increment is greater than or equal to the minimum increment for the auction item

		require(check_highest_bidder(_itemId, msg.sender), "Person bidding is the highest bidder"); // make sure that person bidding isn't already highest bidder

        items[_itemId].auction_price = _bidAmt; // replace the current price with the new bid amount
		highestBidders[_itemId] = msg.sender; // replace the highest bidder for that item id with the new highest bidder

		emit BidEvent(_itemId, _bidAmt); // logs the bid event on ethereum EVM

        return _itemId; // return the item back 	

    }


    // Function to check if the bid is greater than highest bid
	function check_bid (uint _itemId, uint _bidAmt) public view returns (bool) {
		if (_bidAmt > items[_itemId].auction_price) return true;
		else return false;
	}
	
	
    // Function to check if the difference is greater to minimum increment value
	function check_increment (uint _itemId, uint _bidAmt) public view returns (bool) {
		uint diff;

		diff = _bidAmt - items[_itemId].auction_price;
		if (diff >= items[_itemId].min_increment) return true;
		else return false;
	}
	

	// Function to check if person bidding is the highest bidder
	function check_highest_bidder (uint _itemId, address person_wallet) public view returns (bool) {
		if (person_wallet == highestBidders[_itemId]) {
			return false;
		} else {
			return true;
		}
	}

}
