import NonFungibleToken from 0x05

pub contract MyNFT: NonFungibleToken {

 /// The total number of tokens of this type in existence
    pub var totalSupply: UInt64

// events
pub event ContractInitialized()
pub event Withdraw(id: UInt64, from: Address?)
pub event Deposit(id: UInt64, to: Address?)

pub resource NFT: NonFungibleToken.INFT {
pub let id: UInt64
pub let ipfsHash: String
pub var metadata: {String: String}

init(_ipfsHash: String, _metadata:{String: String}) {
self.id = MyNFT.totalSupply
MyNFT.totalSupply = MyNFT.totalSupply + 1

self.ipfsHash = _ipfsHash
self.metadata = _metadata
}
}

pub resource Collection: NonFungibleToken.Receiver, NonFungibleToken.Provider, NonFungibleToken.CollectionPublic {
  pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT} 

  pub fun deposit(token: @NonFungibleToken.NFT) {
  let myToken <- token as! @MyNFT.NFT

  emit Deposit(id: myToken.id, to: self.owner?.address)
  self.ownedNFTs [myToken.id] <-! myToken
  }

// withdraw func
pub fun withdraw(withdrawID: UInt64): @MyNFT.NFT {
let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("This NFT does not exist")
emit Withdraw(id: token.id, from: self.owner?.address)

return <- token 
}

// get id fun 
pub fun getIDs(): [UInt64] {
return self.ownedNFTs.keys
}

// borrow nft fun 
pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
return & self.ownedNFTs[id] as &NonFungibleToken.NFT
}

  init() {
  
  }
}


 init() {
self.totalSupply = 0
}
}