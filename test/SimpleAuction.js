/* eslint-disable no-undef */
const { assert, expect } = require('chai');
const Web3 = require("web3");
const Auction =artifacts.require('Auction')
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
let auction
beforeEach(async function() {
auction=await Auction.deployed()
});

describe('Check',async()=>{
  it('ItemId',async()=>{
    const itemId= await auction.itemId()
    assert(itemId,0)
  })
  it('Adding something',async()=>{
    const items=await auction.getItemCount()
    console.log(items,4)
  })
  
})


}

)