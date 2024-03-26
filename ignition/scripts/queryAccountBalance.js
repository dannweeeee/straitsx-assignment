require("dotenv").config();
const { ethers } = require("hardhat");

async function queryAccountBalance() {
    const provider = new ethers.JsonRpcProvider(`https://sepolia.infura.io/v3/${process.env.INFURA_API_KEY}`);

    const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

    const contractAddress = "0x1AFdaD6Ac74b117433aaA8C88EF95669839b7B0d";
    const ownerAddress = "0x1dF6bE628F34a964AcFb695CD9F5417DBc95ff42";

    const Token = await ethers.getContractFactory("Token");
    const token = Token.attach(contractAddress);

    // Get the balance of the ownerAddress
    const fromBalance = await token.balanceOf(ownerAddress);
    console.log(`Balance of ownerAddress: ${ethers.formatUnits(fromBalance, 18)}`);
}

queryAccountBalance()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
