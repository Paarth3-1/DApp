/* eslint-disable no-undef */
const { assert, expect } = require('chai');
const Web3 = require("web3");
const Auction =artifacts.require('SimpleAuction')
if (typeof web3 !== 'undefined') {
  // Use Mist/MetaMask's provider
 const web3 = new Web3(Web3.currentProvider);
}
require('chai')
  .use(require('chai-as-promised'))
  .should()

function tokens(n) {
  return web3.utils.toWei(n, 'ether');
}


contract('Auction',(accounts)=>{
  let owner = accounts[0]
  let bidderA = accounts[1]
  let duration = 3600;
  let timestampEnd

let auction;

beforeEach(async function() {
  timestampEnd = web3.eth.getBlock('latest').timestamp  +  duration; // 1 hour from now
  auction = await Auction.new(bidderA, owner);
});

describe('Correct name',async()=>{
  it('has a correct name',async()=>{
    const name= await auction.name()
    assert.equal(name,'Auction')
  })
  it("Does a transaction",async()=>{
    // const transaction=await auction.placeBid
    const items=await auction.items()
    ///ssert.equal(items[0].base_price,20)
  })
  


})


}

)