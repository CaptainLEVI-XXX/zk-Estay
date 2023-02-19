const hre = require("hardhat");
async function main() {
    const verifierContract = "Estay";
    const[ owner ]=await ethers.getSigners()
    
    const Estay = await hre.ethers.getContractFactory(verifierContract);
    const estay = await Estay.deploy(
    );
  
    await estay.deployed();
    console.log(`contract is deployed at ${estay.address}`);

    console.log(`listing 3 properties...\n`)

  let  transaction = await estay.connect(owner).addRentals(
    "Messi Stays",
    "Ayodhya",
    "26.7922",
    "82.1998",
    " 3 Guests • 2 Beds • 2 Rooms",
    "Wifi • Kitchen • Living Area",
    "https://ipfs.moralis.io:2053/ipfs/QmS3gdXVcjM72JSGH82ZEvu4D7nS6sYhbi5YyCw8u8z4pE/media/3",
    3,
    3,
    [])
  await transaction.wait()
  
  transaction = await estay.connect(owner).addRentals(
    "Yadav Places",
    "Delhi",
    "28.7041",
    "77.1025",
    " 3 Guests • 2 Beds • 2 Rooms",
    "Wifi • Kitchen • Living Area",
    "https://ipfs.moralis.io:2053/ipfs/QmS3gdXVcjM72JSGH82ZEvu4D7nS6sYhbi5YyCw8u8z4pE/media/1",
    3,
    3,
    [])
  await transaction.wait()
  
  transaction = await estay.connect(owner).addRentals(
    "The Leela Place",
    "Bangalore",
    "12.9716",
    "77.5946",
    " 3 Guests • 2 Beds • 2 Rooms",
    "Wifi • Kitchen • Living Area",
    "https://ipfs.moralis.io:2053/ipfs/QmS3gdXVcjM72JSGH82ZEvu4D7nS6sYhbi5YyCw8u8z4pE/media/2",
    3,
    3,
    [])
  await transaction.wait()

  console.log(`Finished.`)
  }
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });