const hre = require("hardhat");
async function main() {

    const circuitId = "credentialAtomicQuerySig";
  
    const validatorAddress = "0xb1e86C4c687B85520eF4fd2a0d14e81970a15aFB";
  
    const schemaHash = "c6d272297d43f6583c1cd70d14c46aac" // extracted from PID Platform
  
    const schemaEnd = fromLittleEndian(hexToBytes(schemaHash))
  
  
    const query = {
      schema: ethers.BigNumber.from(schemaEnd),
      slotIndex: 2,
      operator: 1,
      value: [12345, ...new Array(63).fill(0).map(i => 0)],
      circuitId,
    };
  
    // add the address of the contract just deployed
    EstayAddress ="0x3Dee86F1159977dfcE6c90Fd39aB3D49488FF051";
  
    let estay = await hre.ethers.getContractAt("Estay", EstayAddress)
  
    try {
      await estay.setZKPRequest(
        1,
        validatorAddress,
        query
      );
      console.log("Request set");
    } catch (e) {
      console.log("error: ", e);
    }
  }
  
  function hexToBytes(hex) {
    for (var bytes = [], c = 0; c < hex.length; c += 2)
      bytes.push(parseInt(hex.substr(c, 2), 16));
    return bytes;
  }
  
  function fromLittleEndian(bytes) {
    const n256 = BigInt(256);
    let result = BigInt(0);
    let base = BigInt(1);
    bytes.forEach((byte) => {
      result += base * BigInt(byte);
      base = base * n256;
    });
    return result;
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });